     h option(*Nodebugio)
     fcpf002t   CF   e             workstn
     f                                     sfile(cpf002s:rrn)
     d rrn             s              3  0
     d p               s              1a
     d wSearch         s             20a
     d c1_NUMR         s             14a
     d c1_NOME         s             25a
     d c1_SEXO         s              1a
     d c1_DATA         s              8  0
     d c1_ESTA         s             20a
     c/copy qrpglesrc,cpf003_pr
       /free
           dow *in03 ='0';
              *in41 = '1';
              *in42 = '1';
              *in44 = '1';
              write cpf002r;
              write cpf002c;
              *in44 = '0';
              rrn   = 0;
              exsr srload;
              if rrn = 0;
                 *in44 = '0';
              endif;
              write cpf002r;
              exfmt cpf002c;
              if *in03 = '1';
                 iter;
              endif;
              if *in06 = '1';
                 exsr sradicionar;
              endif;

              readc cpf002s;
              dow not %eof;
               if sfsel <> ' ';
                 dow *in12 = '0';
                     exfmt cpf002w;
                     if *in12 ='0';
                      select;
                       when sfsel = '2';
                        AlterarCPF( sfNUMR :sfNOME
                           :sfsexo :sfDATA :sfESTA);
                        *in12 ='1';
                       when sfsel = '4';
                        DeletarCPF( sfNUMR :sfNOME
                           :sfsexo :sfDATA :sfESTA);
                        *in12 ='1';
                      endsl;
                     endif;
                 enddo;
                 sfsel = ' ';
                 *in12 ='0';
               endif;
              readc cpf002s;
              enddo;
           enddo;
           *inlr = '1';
           begsr srload;
            exec sql
               declare c1 cursor for
                    select cp.cpfnumr, cp.cpfnome,
                           cp.cpfsexo, cp.cpfdata, cp.cpfesta
                    from cpf002f cp
                    where cp.cpfnumr >= :ctnumr
                 order by cp.cpfnumr;
           exsr srfetch1;
           dow sqlcode = 0;
               sfNUMR = c1_NUMR;
               sfNOME = c1_NOME;
               sfSEXO = c1_SEXO;
               sfDATA = c1_DATA;
               sfESTA = c1_ESTA;
               rrn += 1;
               write cpf002s;
               exsr srfetch1;
           enddo;
           exec sql close c1;

           endsr;
           begsr srfetch1;
           exec sql open c1;
           exec sql fetch c1 into :c1_NUMR,
                                  :c1_NOME,
                                  :c1_SEXO,
                                  :c1_DATA,
                                  :c1_ESTA;

           endsr;

           begsr srAdicionar;
           reset cpf002s;
           sfnumr=GetSequence( );
           dow *in12 = '0';
               exfmt cpf002w;
               if *in12 ='0';
                  AdicionarCPF( sfNUMR :sfNOME :sfsexo :sfDATA :sfESTA);
                  *in12 ='1';
               endif;
           enddo;
           *in12 ='0';
           endsr;
       /end-free
