#!/bin/bash

findfile(file_name_extract, smb_path, source ) {
 sudo find $smb_ptah -name $file_name_extract -type f -exec gcp {} $source \;
}




