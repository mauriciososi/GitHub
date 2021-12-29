     hnomain  option(*nodebugio)
     fcpfseq    uf a e           k disk
     fcpf001f   uf a e           k disk
     fcpf001l1  uf   e           k disk    rename(cpf001r:cpf001r1)
     d kseq            s             14a
     d wnum            s             14  0
     p ADD_ID_N#       b                   export
     d ADD_ID_N#       pi            20a
     d pi_numr                       14a
     d pi_nome                       26a
     d pi_sexo                        1a
     d pi_datan                       8  0
     d pi_cida                       19a
     d pi_provi                       2a
      /free
            Wnum   = 0;
            Kseq   = '999999999999999';
            SetGt Kseq Cpfseq;
            ReadP Cpfseq;
            If  Not %Eof(cpfseq);
            Wnum  = %Dec((SeqNum): 14 :0) + 1;
            SeqNum = %Char(Wnum);
            UpDate   Seq001r;
            EndIf;

            reset cpf001r;
            CPNUMR = SeqNum  ;
            CPNOME = pi_nome ;
            CPSEXO = pi_sexo ;
            CPDTNA = pi_datan;
            CPcida = pi_cida ;
            CPprov = pi_provi;
            write cpf001r;
            If pi_numr=  '9999';
               return 'Registro adicionado';
            else;
               return *on;
            EndIf;
     p ADD_ID_N#       e
      *
     p Change_ID_N#    b                   export
     d Change_ID_N#    pi            20a
     d pi_numr                       14a
     d pi_nome                       26a
     d pi_sexo                        1a
     d pi_datan                       8  0
     d pi_cida                       19a
     d pi_provi                       2a
      /free
            kseq = pi_numr;
            chain kseq cpf001l1;
            if %found;
               CPNOME = pi_nome ;
               CPSEXO = pi_sexo ;
               CPDTNA = pi_datan;
               CPcida = pi_cida ;
               CPprov = pi_provi;
               update  cpf001r1;
            endif;
            return 'Registro atualizado';
     p Change_ID_N#    e
      *
     p Delete_ID_N#    b                   export
     d Delete_ID_N#    pi            20a
     d pi_numr                       14a
      /free
            kseq = pi_numr;
            chain kseq cpf001l1;
            if %found;
               Delete  cpf001r1;
            endif;
            return 'Record was deleted.';
     p Delete_ID_N#    e
      /end-free
