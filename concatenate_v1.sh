#
# Concatenates trajectories for consecutive runs for umbrella sampling computations - gromacs
#
# The Bresme Group, 2022
#
#

rm pullf-files.dat tpr-files.dat
touch pullf-files.dat tpr-files.dat
n=1
while [ $n -le 65 ] 
do 
   rm win$n-pullf_total.xvg lastline.dat 
#   rm kk1 kk2 kk3 kk4

   FILE="win$n-prod_pullf.xvg"
   head -17 win$n-prod_pullf.xvg > win$n-pullf_total.xvg
   awk 'NR > 17 && $2 != "" {print $1,"     ", $2}' $FILE >> win$n-pullf_total.xvg


#    head -17 win$n-prod_pullf.xvg > kk1
#   awk 'NR > 17 && $2 != "" {print $1,"     ", $2}' $FILE >> kk1

   tail --lines=1 win$n-pullf_total.xvg >> lastline.dat
   mytime=$(awk '{ print $1 }' lastline.dat)
#   echo "*",$mytime

   # Check for other files
   j=2
   while [ $j -lt 5 ] 
   do
#      echo "j="$j
     FILE="win$n-prod.part000$j""_pullf.xvg"
#      echo "$FILE"

     if [ -f "$FILE" ]; then
# 	echo "$FILE exists"," My time="$mytime
	awk -v tim=$mytime 'NR > 17 && $1 > tim && $2 != "" {print $1,"     ", $2}' $FILE >> win$n-pullf_total.xvg
#	awk -v tim=$mytime 'NR > 17 && $1 > tim && $2 != "" {print $1,"     ", $2}' $FILE >> kk$j
        rm lastline.dat
        tail --lines=1 win$n-pullf_total.xvg >> lastline.dat
        mytime=$(awk '{ print $1 }' lastline.dat)
#        echo "*",$j,$mytime
     fi

     ((j++))
   done

# Write to pullf and tpr files for processing using umbrella sampling analysis
echo "win$n-pullf_total.xvg" >> pullf-files.dat
echo "win$n-prod.tpr" >> tpr-files.dat
echo "Window="$n
((n++))

done

echo "All done fb!"
