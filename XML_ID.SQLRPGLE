     HOption(*srcstmt: *nodebugio)
      *---------------------------------------------------------------------
      * Program ID: XML_ID
      * Author: Mauricio Silva
      * Detail: Create new Brazilian ID number
      *---------------------------------------------------------------------
     D FileName        S            100A   Inz
     D Options         S            100A   Inz
     D
     D Identification  DS                  Qualified
     D  ID                           14A
     D  Name                         28A
     D  Gender                        1A
     D  BirthDate                     8P 0
     D  City                         20A
     D  Province                      2A
     C/copy qrpglesrc,cpf002_pr
      /Free

            Options = 'doc=file case=any ' +
                      'allowmissing=yes allowextra=yes ';

            FileName = '/home/MSXBRASIL/XML_ID';

            xml-into Identification
               %xml(%Trim(FileName):options);

            Monitor;
               Add_ID_N#( IDENTIFICATION.ID
                         :IDENTIFICATION.NAME
                         :IDENTIFICATION.GENDER
                         :IDENTIFICATION.BIRTHDATE
                         :IDENTIFICATION.CITY
                         :IDENTIFICATION.PROVINCE);
            On-Error;
            EndMon;
            return;


      /End-Free
