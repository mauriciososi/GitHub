     h nomain option(*nodebugio)
     fcpf004l1  uf a e           k disk
     fcpfseq4   uf   e           K disk
     d kcpf_N          s             14  0
     d kcpf_A          s             14a
     pGetSequence      b                   export
     dGetSequence      pi            14a
      /free
        kcpf_a = '99999999999999';
        setgt kcpf_A Cpfseq4;
        readp cpfseq4;
        if not %eof(cpfseq4);
           kcpf_n = %dec((seqnum): 14 : 0) + 1000100010001;
           seqnum = %char(kcpf_n);
           update seqnumr;
        endif;
        return seqnum;
     pGetSequence      e
      *
     pAdicionarCPF     b                   export
     dAdicionarCPF     pi            14a
     d pi_numr                       14a
     d pi_nome                       20a
     d pi_sexo                        1a
     d pi_data                        8  0
     d pi_esta                       19a
            reset cpf004r;
            cpfnumr = pi_numr;
            cpfnome = pi_nome;
            cpfsexo = pi_sexo;
            cpfdata = pi_data;
            cpfesta = pi_esta;
            write cpf004r;
            return 'WRT-Sucessfull';
     pAdicionarCPF     e
      *
     pAlterarCPF       b                   export
     dAlterarCPF       pi            14a
     d pi_numr                       14a
     d pi_nome                       20a
     d pi_sexo                        1a
     d pi_data                        8  0
     d pi_esta                       19a
            kcpf_a = pi_numr;
            chain kcpf_a cpf004l1;
            if %found(cpf004l1);
               cpfnome = pi_nome;
               cpfsexo = pi_sexo;
               cpfdata = pi_data;
               cpfesta = pi_esta;
               update cpf004r;
               return 'WRT-Sucessfull';
            endif;
     pAlterarCPF       e
      *
     pDeletarCPF       b                   export
     dDeletarCPF       pi            14a
     d pi_numr                       14a
     d pi_nome                       20a
     d pi_sexo                        1a
     d pi_data                        8  0
     d pi_esta                       19a
            kcpf_a = pi_numr;
            exec sql
            delete cpf004f
               where cpfnumr = :Kcpf_a;
               return 'DLT-Sucessfull';

     pDeletarCPF       e
      /end-free
