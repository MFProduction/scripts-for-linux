#!/bin/bash
#Redovalnica
if [ -d "~/tmp" ]; then
	TEMP_DIR=~/tmp
else
	TEMP_DIR=/tmp
fi

####CONSTANS
TITLE="Redovalnica"
RIGHT_NOW=$(date +"%x %r %Z")
TIME_STAMP="updated $RIGHT_NOW by $USER"
TEMP_FILE=$TEMP_DIR/red
vp=
####FUNCTIONS
function press_enter
{
	enter=
	echo -n "prosim pritisni 'meni' za glavni meni (q za izhod >"
	read enter
	if [ "$enter" != "meni" ]; then
		if [ "$enter" == "q" ]; then
			exit_f
		else
			press_enter
		fi
	else
		clear		
		glavni_meni
	fi
} #end of press_enter

function write_temp
{
	#funkcija naredi temp datoteko	
	echo -n "$TIME_STAMP" > $TEMP_FILE
	echo -n ", " >> $TEMP_FILE	
	
	echo -n "razred: $razred" >> $TEMP_FILE
	echo -n ", " >> $TEMP_FILE

	echo -n "Priimek: $priimek" >> $TEMP_FILE
	echo -n ", " >> $TEMP_FILE	

	echo -n "Predmet: $predmet" >> $TEMP_FILE
	echo -n ", " >> $TEMP_FILE
		
	echo -n "Ocena: $ocena" >> $TEMP_FILE
	
} #end of write_temp

function vpis_dijaka 
{
	vp="1"	
	clear	
	echo -n "Vpiši ime razreda >"
	read razred
	clear
	echo -n "Vpiši priimek dijaka >"
	read priimek
	clear
	echo -n "Vpiši ime predmeta >"
	read predmet
	clear
	echo -n "Vpiši oceno >"
	read ocena
	clear
	write_temp
} # end of vpis_dijaka

function izpis_txt
{
	if [ "$vp" == "1" ]; then
		response=
		filename=~/redovalnica
		echo -n "vpiši ime od redovalnice [ $filename ] >"
		read response
		if [ -n "$response" ]; then
			filenme="$response"
		fi
		#tega dela še nisem naredil zaenkrat nebo naredil še nič!		
	else
		echo "prvo moraš vpisati ocene"
		press_enter
	fi
} #end of izpis_txt

function post_html
{
	clear
	echo "Izpis v obliki html:"	
	if [ "$vp" == "1" ]; then				
		response_html=
		filename_html=~/redovalnica.html
		echo -n "vpiši lokacijo in ime od redovalnice [ $filename_html ] >"
		read response_html
		if [ -n "$response_html" ]; then
			filename_html="$response_html"
		fi
		
		if [ -f "$filename_html" ]; then 
			echo -n "Ta datoteka že obstaja. Jo prepišem? (y,n) >"
			read response_html				
			if [ "$response_html" != "y" ]; then
				echo -n "Če želite shraniti na drugo lokacijo pritisnite 1 (enter-izhod)  >"
				read druga_lokacija
				if [ "$druga_lokacija" == "1" ]; then
					clear					
					post_html
				else
										
					press_enter					
					
				fi
			else
				clear
				write_html >$filename_html				
				echo "Datoteka $filename je bila uspešno prepisana"
				press_enter
			fi
		else
						
			write_html >$filename_html
			echo "Datoteka $filename_html je bila ustvarjena"
			press_enter	
		fi
	else
		echo "-prvo moraš vpisati ocene"
		press_enter
	fi
} #end of post_html

function write_html
{
		
	cat << _EOF_
	<html>
  	<head>
        <title>$TITLE</title>
        </head>
        <body>
        <h1>$TITLE</h1>
	<p>$TIME_STAMP</p>        
	<pre>
		razread: $razred
		priimek: $priimek
		predmet: $predmet
		ocena  : $ocena
	</pre>
        </body>
    </html>
_EOF_
} #end of izpis_html

function exit_f 
{
	clear	
	echo -n "Ali zares želiš oditi? (y/n) >"
	read odhod
	if [ "$odhod" == "y" ]; then
		clean_up
		exit
	else
		clear
		glavni_meni
	fi
} #end of function exit_f

function help_f
{
	clear
	echo "Redovlanica"
	echo "prijavleni ste kot $USER"
	echo -n ">"
	read nn
	if [ "$nn" == "*" ]; then
		press_enter
	fi 
} #end of function help_f

function glavni_meni
{
	slection=
	until [ "$selction" = "0" ]; do
		echo ""
		echo "************"
		echo "REDOVALNICA"
		echo "************"		
		echo "Glavni Meni"	
		echo "1- Vpis v redovalnico"
		echo "2- Izpis v tekstovni obliki"
		echo "3- Izpis v html obliki"
		echo "4- Sprintaj Redovalnico"
		echo ""
		echo "h- pomoč"
		echo "q- zapri program"
		echo "************"
		echo -n "Izberi eno od naštetih možnosti in pritisni enter >"	
		read selection
		case $selection in
		1) 			vpis_dijaka 
					;;
	  	2) 			izpis_txt 
					;;
		3) 			post_html
					;;
		4) 			;;

		h) 			help_f 
					;; #še ni napisana 
		q)  			exit_f
					;; 
		meni) 			clear 
					glavni_meni 
					;;		
		*) 			clear
					press_enter
					;; 
		esac
	done
} #end of glavni_meni

function clean_up
{
	#počisti vse temp fajle
	rm -f $TEMP_FILE
	exit 
}
####MAIN
trap clean_up;  SIGTERM
clear
echo "pozdravljeni v Redovalnici!"
echo "$RIGHT_NOW , prijavljeni ste kot $USER , "
press_enter



