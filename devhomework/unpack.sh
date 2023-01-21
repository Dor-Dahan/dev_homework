#!/bin/bash

#getting file list and unpaking the files
func_unpack() {
  SAVEIFS=$IFS
  IFS=","
  
  local FILE=0
  local FILES_FIXED=""
  
  # looking for files with space and combining it 
  for WORD in "$@"
  do
    if [ "$FILE" = 0 ]
    then
      FILE="$WORD"
    else
      FILE="$FILE $WORD"           
    fi

    if [ "$(file -b "$FILE")" != "cannot open (No such file or directory)" ] && [ "$FILES_FIXED" = "" ]
    then
      FILES_FIXED="$FILE"
      FILE=0
    elif [ "$(file -b "$FILE")" != "cannot open (No such file or directory)" ]
    then
      FILES_FIXED="$FILES_FIXED,$FILE"
      FILE=0
    fi
  done
  
  # convert FILES_FIXED to array
  read -ra FILES <<< "$FILES_FIXED"
  
  # iterate over files
  for FILE in "${FILES[@]}"
  do
    #find file type
    local EXT=$(expr "$(file -b "$FILE")" : '\([-1-9a-zA-Z]*\)')
    
    #unpack archive or handle directory
    case $EXT in
      "Zip")
        local DIR=$(dirname "$FILE")
        unzip -oqq "$FILE" -d "$DIR"
  		  ;;
  		"gzip")
  			gunzip -df "$FILE"
  		  ;;
  		"bzip2")
  			bunzip2 -fkq "$FILE"
  		  ;;
  		"compress")
  			uncompress -f "$FILE"
  		  ;;
  		"directory")
        #unpack contents of directory if requested or if the target is a directory
        if [ "$RECURSIVE" = TRUE ] || [ $IS_TOP = TRUE ]
        then
          IS_TOP=FALSE      
          func_unpack $FILE/*
        fi 
  		  ;;
  	esac
   
   #verbose output if requested 
    if [ "$VERBOSE" = TRUE ]
    then
  		case $EXT in 
  			"Zip" | "gzip" | "bzip2" | "compress")
  				echo "Unpacking $FILE"
          let "NUM_SUCCESS++"
  			  ;;
  			"directory")
          ;;
        *)
  				echo "Ignoring $FILE"
          let "NUM_FAIL++"
  			  ;;
  		esac
    fi	
  done
  IFS=$SAVEIFS
}

#handle arguments
for arg in "$@"
do
	case $arg in
    -r)
	    RECURSIVE=TRUE
		  shift
	    ;;
    -v)
			VERBOSE=TRUE
			shift
		  ;;
		-rv|-vr)
			VERBOSE=TRUE
			RECURSIVE=TRUE
			shift
		  ;;
	esac
done

NUM_SUCCESS=0 
NUM_FAIL=0
IS_TOP=TRUE

func_unpack $@

# return results
echo "Decompressed $NUM_SUCCESS archive(s)"
exit $NUM_FAIL
