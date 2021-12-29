     h option(*nodebugio)
     h* Program: Knowlegment assessment
     h* Program propose: To register information about personal document
     h* Author: Mauricio Silva
     h* Date: 05/11/2019
     fcpf004t   cf   e             workstn
     f                                     sfile(cpf004s : rrn)
     fcpf004rp  o    e             printer oflind(*in10)
     f
     d rrn             s              3  0
     d c1_numr         s             14a
     d c1_nome         s             20a
     d c1_sexo         s              1a
     d c1_data         s              8  0
     d c1_esta         s             19a
     c/copy qrpglesrc,cpf004prcy
      /free
            write  head01;
            *in03 = '0';
            tit ='YKK do Brasil - Divisao Fastening';
            dow *in03 = '0';
            *in41 = '1';
            *in42 = '1';
            *in44 = '1';
            write cpf004c;
            *in44 = '0';
            rrn = 0;
            exsr srload;
            if rrn = 0;
               *in41 = '0';
            endif;
            exfmt cpf004c;
            Select;
             when *in03 = '1';
               iter;
             when *in06 = '1';
               exsr sradicionar;
            endsl;

            exsr srreadSubF;

            enddo;
            *inlr = '1';
            begsr srload;
            exec sql
              declare c1 cursor for
                        select cp.cpfnumr, cp.cpfnome, cp.cpfsexo,
                               cp.cpfdata, cp.cpfesta
                        from cpf004f cp
                        where cp.cpfnumr >= :ctnumr
                        order by cp.cpfnumr;

            exsr srfetch1;
            dow sqlcode = 0;
                sfnumr = c1_numr;
                sfnome = c1_nome;
                sfsexo = c1_sexo;
                sfdata = c1_data;
                sfesta = c1_esta;
                rrn += 1;
                write cpf004s;
                exsr srfetch1;
            enddo;
            exec sql close c1;
            endsr;

            begsr srfetch1;
            exec sql open c1;
            exec sql fetch c1 into :c1_numr,
                                   :c1_nome,
                                   :c1_sexo,
                                   :c1_data,
                                   :c1_esta;
            endsr;
            begsr sradicionar;
             reset cpf004s;
             sfnumr = GetSequence( );
             *in12 = '0';
             dow *in12 = '0';
               exfmt cpf004w;
                if *in12 = '0';
                   AdicionarCPF(sfnumr :sfnome :sfsexo :sfdata :sfesta);
                   *in12 = '1';
                endif;
             enddo;
            endsr;
            begsr srReadSubF;
             readc cpf004s;
             dow not %eof;
               *in30 = '0';
               if sfsel <> ' ';
                 if sfsel = '4' or
                    sfsel = '5' or
                    sfsel = '6';
                    *in30 = '1';
                 endif;
                 Exfmt cpf004w;
                 if *in12 = '0';
                   select;
                     when sfsel = '2';
                     AlterarCPF(sfnumr :sfnome :sfsexo :sfdata :sfesta);
                     *in12 = '1';
                     when sfsel = '4';
                     DeletarCPF(sfnumr :sfnome :sfsexo :sfdata :sfesta);
                     *in12 = '1';
                     when sfsel = '6';
                     if *in10 = '1';
                        write  head01;
                     endif;
                     write  detail;
                   endsl;
                 endif;
               endif;
               sfsel = ' ';
              readc cpf004s;
             enddo;
            endsr;
      /end-free
