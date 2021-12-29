     h nomain option(*Nodebugio)
     fcpfseq    uf a e           k disk
     fcpf002l1  uf a e           k disk
     d kcpf            S             14a
     d wseq            S             14  0
     d wnome           S             25a
     d wsexo           S              1a
     d wdata           S              8  0
     d westa           S             20a
     p GetSequence     b                   export
     d GetSequence     pi            14a
       /free
           kcpf = '99999999999999';
           setgt kcpf cpfseq;
           readp cpfseq;
           if not %eof(cpfseq);
              wseq = %dec((seqnum):14 : 0) +1;
              seqnum = %char(wseq);
              update seq001r;
           endif;
           return  seqnum;
     p GetSequence     e
      *
      *
     p AdicionarCPF    b                   export
     d AdicionarCPF    pi            30a
     d pi_numr                       14a
     d pi_nome                       25a
     d pi_sexo                        1a
     d pi_data                        8  0
     d pi_esta                       20a
       /free
                reset cpf002r;
                cpfnumr = pi_numr;
                cpfnome = pi_nome;
                cpfsexo = pi_sexo;
                cpfdata = pi_data;
                cpfesta = pi_esta;
                write cpf002r;
                 return '0';

     p AdicionarCPF    e
      *
     p AlterarCPF      b                   export
     d AlterarCPF      pi            30a
     d pi_numr                       14a
     d pi_nome                       25a
     d pi_sexo                        1a
     d pi_data                        8  0
     d pi_esta                       20a
       /free
                kcpf = pi_numr;
                chain kcpf cpf002l1;
                if %found(cpf002l1);
                   cpfnome   = pi_nome;
                   cpfsexo   = pi_sexo;
                   cpfdata   = pi_data;
                   cpfesta   = pi_esta;
                   update cpf002r;
                   return 'UPD-00-SUCESSFULL';
                endif;

     p AlterarCPF      e
      *
     p DeletarCPF      b                   export
     d DeletarCPF      pi            30a
     d pi_numr                       14a
     d pi_nome                       25a
     d pi_sexo                        1a
     d pi_data                        8  0
     d pi_esta                       20a
       /free
                kcpf = pi_numr;
                exec sql
                delete from cpf002f
                   where cpfnumr =:kcpf;
                return 'DLT-00-SUCESSFULL';

     p DeletarCPF      e
       /end-free
