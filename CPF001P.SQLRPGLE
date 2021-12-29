     h option(*nodebugio)
      *---------------------------------------------------------------------
      * Program ID: CPF001
      * Author: Mauricio Silva
      * Detail: Create new Brazilian ID number
      *
      *---------------------------------------------------------------------
     fcpfseq    uf a e           k disk
     fcpf001t   cf   e             workstn
     f                                     sfile(cpf001s:rrn)
     d
     d XML_WRITE_ID    PR                  Extpgm('XML_ID')
     d
     d rrn             s              3  0
     d wnum            s             14  0
     d kseq            s             14a
     d c1_numr         s             14a
     d c1_nome         s             28a
     d c1_sexo         s              1a
     d c1_datan        s              8  0
     d c1_cida         s             22a
     d c1_provi        s              2a
     c/copy qrpglesrc,cpf002_pr
      /free

         Dow *In03 = '0';
           *In40 = '1';
           *In41 = '1';
           *In44 = '1';
           Write Cpf001r;
           Write Cpf001c;
           *in44 = '0';
           Rrn   = 0;
           ExSr Srload;
           If Rrn = 0;
              *In40 = '0';
           EndIf;
           Write Cpf001c;
           Write Cpf001r;
           Exfmt Cpf001c;

           Select;
           When *In03 = '1';
              Iter;
           When *In06 = '1';
              ExSr SrAdd_ID;
           When *in07 = '1';
              ExSr SrXML;
           EndSl;

           If Rrn > 0;
              ExSr SrReadSubf;
           EndIf;
           *in12 = '0';
         EndDo;
         *inlr = '1';

         begsr srload;
         exec sql
            declare c1 cursor for

                    select cp.cpnumr,
                           cp.cpnome,
                           cp.cpsexo,
                           cp.cpdtna,
                           cp.cpcida,
                           cp.cpprov  from cpf001f cp
                                 where cp.cpnumr >= :ctnumr
                    order by cp.cpnumr;
            exsr srfetch1;
            dow sqlcode = 0;
                sfnumr  = c1_numr;
                sfnome  = c1_nome;
                sfsexo  = c1_sexo;
                sfdatan = c1_datan;
                sfcida  = c1_cida;
                sfprovi = c1_provi;
                rrn += 1;
                write cpf001s;
                exsr srfetch1;
            enddo;
            exec sql close c1;
         endsr;

         begsr srfetch1;
         exec sql open c1;
         exec sql fetch c1 into :c1_numr,
                                :c1_nome,
                                :c1_sexo,
                                :c1_datan,
                                :c1_cida,
                                :c1_provi;
         endsr;

         BegSr SrAdd_ID;
          Reset  cpf001s;
      //  Wnum   = 0;
      //  Kseq   = '999999999999999';
      //  SetGt Kseq Cpfseq;
      //  ReadP Cpfseq;
      //  If  Not %Eof(cpfseq);
      //  Wnum  = %Dec((SeqNum): 14 :0) + 1;
      //  SeqNum = %Char(Wnum);
      //  UpDate   Seq001r;
      //  EndIf;
          *In30 = '0';
          Tit1 = '*** ADD NEW ID NUM***';
      //  SfNumr = Seqnum;
          Dow *In12 = '0';
              ExFmt Cpf001w;
              If *In12 = '0';
                 sfnumr='9999';
                Add_ID_N#(sfnumr :sfnome :sfsexo :sfdatan :sfcida : sfprovi);
                 *in12 = '1';
              EndIf;
          EndDo;

         EndSr;

         BegSr SrXML;
           Callp  XML_WRITE_ID( );
         EndSr;

         BegSr SrReadSubf;

          readc(e) cpf001s;
          dow not %eof;
            select;
             when sfsel = '2';
                *in30 = '0';
                *in31 = '1';
                sfsel = ' ';
                tit1 = '*** CHANGE ID DETAIL***';
                *in12 ='0';
                dow *in12 = '0';
                 exfmt cpf001w;
                 if *in12 = '0';
                   Change_ID_N#(sfnumr :sfnome :sfsexo :sfdatan :sfcida
                              :sfprovi);
                      *in12 ='1';
                  endif;
                enddo;
             when sfsel = '4';
                sfsel = ' ';
                      Delete_ID_N#(sfnumr);
             when sfsel = '5';
                sfsel = ' ';
                *in30 = '1';
                *in31 = '1';
                tit1 = '*** VIEW ID NUMBER ***';
                *in12 ='0';
                dow *in12 = '0';
                  exfmt cpf001w;

                enddo;
             when sfsel = '6';
                sfsel = ' ';
            endsl;
          readc(e) cpf001s;
          enddo;

         endsr;
      /end-free
