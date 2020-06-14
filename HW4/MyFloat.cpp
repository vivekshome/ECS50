#include "MyFloat.h"

MyFloat::MyFloat(){
  sign = 0;
  exponent = 0;
  mantissa = 0;
}

MyFloat::MyFloat(float f){
  unpackFloat(f);
}

MyFloat::MyFloat(const MyFloat & rhs){
  sign = rhs.sign;
  exponent = rhs.exponent;
  mantissa = rhs.mantissa;
}

ostream& operator<<(std::ostream &strm, const MyFloat &f){
  //this function is complete. No need to modify it.
  strm << f.packFloat();
  return strm;
}


MyFloat MyFloat::operator+(const MyFloat& rhs) const{

    MyFloat n1(*this);
    MyFloat n2(rhs);
    MyFloat sum(0);

    if((n1.sign != n2.sign) && (n1.exponent == n2.exponent) && (n1.mantissa == n2.mantissa)) // X + (-X) = 0
    {
      return sum;
    }

    if((n1.mantissa == 0x7FFFFF) && (n2.mantissa == 0x7FFFFF) && (n2.sign == 1)) //Special Case - If both mantissas are all 1s and sign on second one is negativs
    {
      int expdiff = n1.exponent - n2.exponent;

      if(expdiff < 0) //If difference in exponents is the negative, it means that n2 > n1, so we need to adjust accordingly.
      {
        sum.sign = 1;
        expdiff *= -1;
      }

      sum.exponent = std::max(n1.exponent, n2.exponent); //Exponent is the max exponent.
      sum.mantissa = 0x7FFFFF - (0b1 << (24 - expdiff)); //Figured out formula via trial and error

      return sum;
    }

    n1.mantissa += (0b1 << 23); //Restoring Implicit One
    n2.mantissa += (0b1 << 23); //Restoring Implicit One

    if(n1.exponent < n2.exponent) //Equalizing Exponents and Shifting Mantissa Accordingly
    {
      n1.mantissa = n1.mantissa >> (n2.exponent - n1.exponent);
      n1.exponent = n2.exponent;
    }
    else if(n2.exponent < n1.exponent)
    {
      n2.mantissa = n2.mantissa >> (n1.exponent - n2.exponent);     
      n2.exponent = n1.exponent;
    }

    sum.exponent = n1.exponent; //Setting Exponent of Sum

    if(n1.sign == n2.sign)
    {
      sum.mantissa = n1.mantissa + n2.mantissa;
      sum.sign = n1.sign;
    }
    else
    {
      sum.mantissa = std::max(n1.mantissa, n2.mantissa) - std::min(n1.mantissa, n2.mantissa); //If signs are not same, perform subtraction.      
    }   

    if(sum.mantissa < 0) //If Mantissa is Negative, tranfer sign to sign bit, and make mantissa positive again.
    {
      sum.sign = 1;
      sum.mantissa *= -1;
    }

    if((((sum.mantissa >> 24) & 0b1) == 1) && (n1.sign == n2.sign)) //Check for Carry (Sign has to be the same)
    {      
          sum.exponent++;     
          sum.mantissa = sum.mantissa >> 1;
    }    
    else if((((sum.mantissa >> 24) & 0b1) == 0) && (n1.sign != n2.sign))//Check for Borrow (Sign has to be different)
    {      
          sum.exponent--;     
          sum.mantissa = sum.mantissa << 1;        
    }   

    sum.mantissa -= (0b1 << 23); //Removing Implicit One
  
  return sum; 
}

MyFloat MyFloat::operator-(const MyFloat& rhs) const{
  
    MyFloat n1(*this);
    MyFloat n2(rhs);
    MyFloat diff(0);

    if((n1.sign == 0) && (n2.sign == 0))
    {
      n2.sign = 1;
      diff = n1 + n2;
    }
    else if((n1.sign == 0) && (n2.sign == 1))
    {
      n2.sign = 0;
      diff = n1 + n2;
    }
    else if((n1.sign == 1) && (n2.sign == 0))
    {
      n2.sign = 1;
      diff = n1 + n2;
    }
    else if((n1.sign == 1) && (n2.sign == 1))
    {
      n2.sign = 0;
      diff = n1 + n2;
    }    

    return diff;
}

bool MyFloat::operator==(const float rhs) const{
  
  MyFloat n1(*this);
  MyFloat n2(rhs);

  if((n1.sign == n2.sign) && (n1.exponent == n2.exponent) && (n1.mantissa == n2.mantissa))
  {
    return true;
  }
  else
  {
    return false;
  }
}


void MyFloat::unpackFloat(float f) {
  //this function must be written in inline assembly
  //extracts the fields of f into sign, exponent, and mantissa

  __asm__
(
// EAX = f, EBX = sign, ECX = mantissa, EDX = exponent

"movl %%eax, %%ebx;"
"shrl $31, %%ebx;"
"andl $0b1, %%ebx;"

"movl %%eax, %%ecx;"
"andl $0x7FFFFF, %%ecx;" //Switched to Hexadecimal Formatting of nos. due to too many 1's in the number lol.

"movl %%eax, %%edx;"
"shrl $23, %%edx;"
"andl $0xFF, %%edx;":

"=b" (sign), "=c" (mantissa), "=d" (exponent):

"a" (f):

"cc"
);
}

float MyFloat::packFloat() const{
  //this function must be written in inline assembly
  //returns the floating point number represented by this
  
  float f = 0;

  __asm__
  (
  // EAX = f, EBX = sign, ECX = mantissa, EDX = exponent

  "movl $0, %%eax;"

  "shll $31, %%ebx;"
  "orl %%ebx, %%eax;"

  "orl %%ecx, %%eax;"

  "shll $23, %%edx;"
  "orl %%edx, %%eax;":

  "=a" (f):

  "b" (sign), "c" (mantissa), "d" (exponent):

  "cc"        
  );

  return f;
}