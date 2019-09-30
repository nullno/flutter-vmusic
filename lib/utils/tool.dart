
/*
数字转换
 int num
*/
 tranNumber(int num){
   double d =0;
    if(num<10000){
      d = num.toDouble();
    }
    if( num>=10000){
      d = num/10000;
    }

    return   d.toStringAsFixed(0) +'万';
}