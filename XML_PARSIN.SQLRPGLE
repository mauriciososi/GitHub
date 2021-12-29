     HOption(*srcstmt: *nodebugio)
      *---------------------------------------------------------------------
      * Program ID: XML_Parsing
      * Author: Mauricio Silva
      * Detail: Reading XML IFS root
      *---------------------------------------------------------------------
     D FileName        S            100A   Inz
     D Options         S            100A   Inz
     D
     D Customer        DS                  Qualified
     D  ID                            5
     D  Name                         20
     D  Status                       10
     D  ContactInfo                        LikeDS(CtInfor_T)
     D  Points                        5S 0
     D  Order                              LikeDS(Order_T)
     D
     D CtInfor_T       DS                  Template
     D  WorkPhone                    10
     D  MobilePhone                  10
     D
     D Order_T         DS                  Qualified
     D  OrderNumber                  10
     D  OrderDetail                        LikeDS(OrdDet_T)
     D
     D OrdDet_T        DS                  Qualified
     D  Item                               LikeDS(Item_T) Dim(10)
     D  Count_Item                    5i 0
     D
     D Item_T          DS                  Template
     D  ItemName                     15A
     D  DepartmentNumber...
     D                                2S 0
     D  Quantity                      5S 0
      /Free

            Options = 'doc=file case=any ' +
                      'allowmissing=yes allowextra=yes ' +
                      'countprefix=count_';

            FileName = '/home/MSXBRASIL/XML_ORDER';

            xml-into customer
               %xml(%Trim(FileName):options);

            Return;

      /End-Free
