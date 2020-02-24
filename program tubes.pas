program Tiket_Kereta;
uses crt,sysutils;

	type Pembeli = record
		Nama             : string;
		Status_Pekerjaan : string;
        Kelas_Kereta     : string;
		nomorkursi       : integer;
		abjadkursi       : char;
		tujuan           : string;
		jam              : string;
		harga            : longint;
	end;

	type Stasiun =record
		Tujuan       : string;
		jam          : string;
		Harga        : longint;
	end;

	type Ekonomi   = array [1..15,'A'..'D'] of Pembeli;
	type Eksekutif = array [1..15,'A'..'D'] of Pembeli;
	type jadwal    = array [1..50] of Stasiun;

var
	//variabel deklarasi tipe
	datapembeli : Pembeli;
	datastasiun : Stasiun;
	//variabel deklarasi array
	jadwal_kereta       : jadwal;
	datakursi_ekonomi   : Ekonomi;
	datakursi_eksekutif : Eksekutif;
	//Variabel save data
	SaveEkonomi      : file of Ekonomi;
	SaveEksekutif    : file of Eksekutif;
	SaveJadwal       : file of jadwal;
	savejumlahjadwal : file of integer;
	//variabel global
	i          : integer;
	j            : char;
	JumlahJadwal : integer;

//========================================================FORMAT LOGIN=============================================================//
procedure login;
    var
            user:string='admin';
            pas:string='admin';
            u,p:string;
    begin
        repeat
        clrscr;
        gotoxy(15,10);writeln('                     ========================= FORM LOGIN =========================');
        gotoxy(15,15);writeln('                     ==============================================================');
        gotoxy(15,16);writeln('                     User & Password = admin                                       ');
        gotoxy(15,12);write  ('                          Username : '); readln(u);
        gotoxy(15,13);write  ('                          Password : '); readln(p);

        if (u<>user) or (p<>pas) then
        begin
        gotoxy(15,14);writeln('                                  [#] USERNAME ATAU PASSWORD SALAH [#]       ');
        end;

        readln;
        until (u=user) and (p=pas);
    end;

procedure loading;
	var
		i : integer;
	begin
		for i:=1 to 100 do
		begin
			gotoxy(25,10);writeln ('====================== Sedang Melakukan Pencarian Data ========================');
			gotoxy(25,12);writeln ('===============================================================================');
			gotoxy(25,11);write   ('                                    ',i,'%                                     ');
		end;
	end;
//========================================================jadwal kereta============================================================//
procedure delete (var jadwal_kereta : jadwal);
    var
    	i,j : integer;
    begin
    	write ('                    pilih data yang ingin di hapus : ');
    	readln (j);
    	writeln;
    	for i:= j to JumlahJadwal do
    	begin
    		jadwal_kereta[i] := jadwal_kereta[i+1];
    	end;
    	readln;
    	JumlahJadwal := JumlahJadwal-1;
    end;

procedure input_jadwal(var datastasiun : Stasiun; var jadwal_kereta : jadwal);
	var
		jawaban : string;
              i : integer;
	begin
		clrscr;
		i := 0;
		JumlahJadwal := 0;
		repeat
		i := i+1;
		writeln ('                    =================================jadwal kereta',i,'================================');
		write   ('                       Masukkan Tujuan : '); readln (datastasiun.Tujuan);
		write   ('                       Masukkan jam    : '); readln (datastasiun.jam);
		write   ('                       Masukkan Harga  : '); readln (datastasiun.harga);
		writeln ('                    ===============================================================================');
		writeln;
		writeln ('                    Input lagi jadwal ? (y/n) :');
		write   ('                    ');
		readln(jawaban);
		writeln;
		
		JumlahJadwal := JumlahJadwal+1;
		jadwal_kereta[i] := datastasiun;

		until (jawaban ='n') or (jawaban ='N');
	end;

procedure edit(var datastasiun : Stasiun; var jadwal_kereta : jadwal);
    var
		jawaban : string;
              i : integer;
	begin
		clrscr;
		i := JumlahJadwal;
		repeat
		i := i+1;
		writeln ('                    =================================jadwal kereta',i,'================================');
		write   ('                       Masukkan Tujuan : '); readln (datastasiun.Tujuan);
		write   ('                       Masukkan jam    : '); readln (datastasiun.jam);
		write   ('                       Masukkan Harga  : '); readln (datastasiun.harga);
		writeln ('                    ===============================================================================');
		writeln;
		writeln ('                    Input lagi jadwal ? (y/n) :');
		write   ('                    ');
		readln(jawaban);
		writeln;
			
		jadwal_kereta[i] := datastasiun;
		JumlahJadwal := JumlahJadwal+1;

		until (jawaban ='n') or (jawaban ='N');
		readln;
	end;

procedure Tayang_Jadwal;
    var
        i : integer;
    begin
    clrscr;
		for  i := 1 to JumlahJadwal do
        begin
            if jadwal_kereta [i].harga <> 0 then
            begin
                writeln('                    [*]========================jadwal kereta ',i,'==============================[*]');
                writeln('                          Tujuan    : ',jadwal_kereta[i].Tujuan);
                writeln('                          Jam       : ',jadwal_kereta[i].jam);
                writeln('                          Harga     : ',jadwal_kereta[i].Harga);
                writeln('                    [*]=====================================================================[*]');
                writeln;
                writeln;
            end;
        end;
        	writeln('                                              [/] PRESS ENTER TO CONTINUE [\]                      ');
            readln;
    end;
//===========================================================Sorting===============================================================//
procedure bubblemenaikJam (var datastasiun : stasiun);
	var
        i,j:integer;
        temp:stasiun;
	begin
        i:=1;
        while i<=JumlahJadwal-1 do
        begin
                j:=1;
                while j<=JumlahJadwal-i do
                begin
                        if (jadwal_kereta[j].jam > jadwal_kereta[j+1].jam) then
                        begin
                                temp:=jadwal_kereta[j+1];
                                jadwal_kereta[j+1]:=jadwal_kereta[j];
                                jadwal_kereta[j]:=temp;
                        end;
                        j:=j+1;
                end;
                i:=i+1;
        end;
        Tayang_Jadwal;
	end;

procedure bubblemenurunJam (var datastasiun : stasiun);
	var
        i,j:integer;
        temp:stasiun;
	begin
        i:=1;
        while i<=JumlahJadwal-1 do
        begin
                j:=1;
                while j<=JumlahJadwal-i do
                begin
                        if (jadwal_kereta[j].jam < jadwal_kereta[j+1].jam) then
                        begin
                                temp:=jadwal_kereta[j];
                                jadwal_kereta[j]:=jadwal_kereta[j+1];
                                jadwal_kereta[j+1]:=temp;
                        end;
                        j:=j+1;
                end;
                i:=i+1;
        end;
        Tayang_Jadwal;
	end;

procedure SelectionMenaikHarga (var datastasiun : stasiun);
	var
		i,j,idx_min : integer;
		temp : stasiun;
	begin
		for i := 1 to JumlahJadwal-1 do
		begin
			idx_min := i;
			for j := i+1 to JumlahJadwal do
			begin
				if (jadwal_kereta[j].harga < jadwal_kereta[idx_min].harga) then
					idx_min := j;
			end;
			temp := jadwal_kereta[idx_min];
			jadwal_kereta[idx_min] := jadwal_kereta[i];
			jadwal_kereta[i] := temp;
		end;
		Tayang_Jadwal;
	end;

procedure SelectionMenurunHarga (var datastasiun : stasiun);
	var
		i,j,idx_max : integer;
		temp : stasiun;
	begin
		for i := 1 to JumlahJadwal-1 do
		begin
			idx_max := i;
			for j := i+1 to JumlahJadwal do
			begin
				if (jadwal_kereta[j].harga > jadwal_kereta[idx_max].harga) then
					idx_max := j;
			end;
			temp := jadwal_kereta[idx_max];
			jadwal_kereta[idx_max] := jadwal_kereta[i];
			jadwal_kereta[i] := temp;
		end;
		Tayang_Jadwal;
	end;

procedure InsertionMenaikTujuan (var datastasiun : stasiun);
	var
		pass,i : integer;
		temp : stasiun;
	begin
		for pass := 1 to JumlahJadwal-1 do
		begin
			i:=pass+1;
			temp := jadwal_kereta[i];
			while (i > 1) and (temp.tujuan < jadwal_kereta[i-1].tujuan)  do
			begin
				jadwal_kereta[i] := jadwal_kereta[i-1];
				i := i-1
			end;
				jadwal_kereta[i] := temp;
		end;
		Tayang_Jadwal;
	end;

procedure InsertionMenurunTujuan (var datastasiun : stasiun);
	var
		pass,i : integer;
		temp : stasiun;
	begin
		for pass := 1 to JumlahJadwal-1 do
		begin
			i:=pass+1;
			temp := jadwal_kereta[i];
			while (i > 1) and (temp.tujuan > jadwal_kereta[i-1].tujuan)  do
			begin
				jadwal_kereta[i] := jadwal_kereta[i-1];
				i := i-1
			end;
				jadwal_kereta[i] := temp;
		end;
		Tayang_Jadwal;
	end;

procedure pilihansorting;
	var
		pilihan1 : string;
		pilihan2 : integer;
        pilihan3 : integer;
	begin
		Tayang_Jadwal;
		repeat
		writeln ('Lakukan pengurutan data (y/n) ? ');
		readln (pilihan1);
		if (pilihan1 = 'y') or (pilihan1 ='Y') then
			begin
				writeln ('1.berdasarkan tujuan ');
				writeln ('2.berdasarkan jam    ');
				writeln ('3.berdasarkan harga  ');
				write   ('pilih : ');
				readln (pilihan2);

				if (pilihan2 = 1) then
								begin
									writeln ('1.Urut A -> Z');
									writeln ('2.Urut Z -> A');
									write   ('Pilih : ');
									readln (pilihan3);
									writeln;
									if (pilihan3 = 1) then
										InsertionMenaikTujuan(datastasiun)
									else if (pilihan3 = 2) then
										InsertionMenurunTujuan(datastasiun);
								end
				else if (pilihan2 = 2) then
				begin
					writeln ('1.Urut terkecil -> terbesar');
					writeln ('2.Urut terbesar -> terkecil');
					write   ('Pilih : ');
					readln (pilihan3);
					writeln;
					if (pilihan3 = 1) then
						bubblemenaikJam(datastasiun)
					else if (pilihan3 = 2) then
						bubblemenurunJam(datastasiun);
				end
				else if (pilihan2 = 3) then
				begin
					writeln ('1.Urut termurah -> termahal');
					writeln ('2.Urut termahal -> termurah');
					write   ('Pilih : ');
					readln (pilihan3);
					writeln;
					if (pilihan3 = 1) then
						SelectionMenaikHarga(datastasiun)
					else if (pilihan3 = 2) then
						SelectionMenurunHarga(datastasiun);
				end;

			end;
		until (pilihan1 ='n') or (pilihan1= 'N');
	end;
//==========================================================Map Kursi==============================================================//
procedure pilih_kursi_ekonomi (var datakursi_ekonomi : ekonomi; var datapembeli : pembeli);
	begin
		writeln;
		writeln ('Silahkan Pilih Kursi Ekonomi ');
		write   ('Pilih Nomor Kursi : '); readln (datapembeli.nomorkursi);
		write   ('Pilih Abjad Kursi : '); readln (datapembeli.abjadkursi);

		datakursi_ekonomi[datapembeli.nomorKursi][datapembeli.abjadKursi] := datapembeli;
	end;

procedure pilih_kursi_eksekutif (var datakursi_eksekutif : eksekutif; var datapembeli : pembeli);
	begin
		writeln;
		writeln ('Silahkan Pilih Kursi Ekonomi ');
		write   ('Pilih Nomor Kursi : '); readln (datapembeli.nomorkursi);
		write   ('Pilih Abjad Kursi : '); readln (datapembeli.abjadkursi);

		datakursi_eksekutif[datapembeli.nomorKursi][datapembeli.abjadKursi] := datapembeli;
	end;

procedure Peta_Kursi_ekonomi(var datakursi_ekonomi : Ekonomi);
		begin
		clrscr;
			writeln ('=====Kursi Ekonomi======');
			writeln ('=                      =');
			writeln ('=____B_O_R_D_E_S_______=');
			for i:= 1 to 15 do
			begin
				for j := 'A' to 'B' do
				begin
					if datakursi_ekonomi[i][j].nama = '' then					
						write  (' [',j,']')
					else
						write (' [x]');
				end;
				write('|  ',i,'  |');
				for j := 'C' to 'D' do
				begin
					if datakursi_ekonomi[i][j].nama = '' then
						write  (' [',j,']')
					else
						write (' [x]');
				end;
				writeln;
			end;
			writeln ('========================');
			write   ('         x : sudahterisi');
			writeln;

			pilih_kursi_ekonomi(datakursi_ekonomi,datapembeli);
			readln;
        end;

procedure Peta_Kursi_eksekutif(var datakursi_eksekutif : Eksekutif);
		begin
		clrscr;
			writeln ('=====Kursi Eksekutif====');
			writeln ('=                      =');
			writeln ('=____B_O_R_D_E_S_______=');
			for i:= 1 to 15 do
			begin
				for j := 'A' to 'B' do
				begin
					if datakursi_eksekutif[i][j].nama = '' then					
						write  (' [',j,']')
					else
						write (' [x]');
				end;
				write('|  ',i,'  |');
				for j := 'C' to 'D' do
				begin
					if datakursi_eksekutif[i][j].nama = '' then
						write  (' [',j,']')
					else
						write (' [x]');
				end;
				writeln;
			end;
			writeln ('========================');
			writeln ('        x : sudah terisi');
			writeln;
			pilih_kursi_eksekutif(datakursi_eksekutif,datapembeli);

			readln;
        end;
//==========================================================Searching==============================================================//
procedure SearchHargaMax;
	var
		i : integer;
		max : longint;
	begin
		max := jadwal_kereta[1].harga;
		for i := 1 to JumlahJadwal do
		begin
			if (jadwal_kereta[i].harga > max) then
			begin
				max := jadwal_kereta[i].harga;
			end;
		end;
		write ('Harga termahal :',max);
		writeln;
	end;

procedure SearchHargaMin;
	var
		i : integer;
		min : longint;
	begin
		min := jadwal_kereta[1].harga;
		for i := 1 to JumlahJadwal do
		begin
			if (jadwal_kereta[i].harga < min) then
			begin
				if jadwal_kereta[i].harga <> 0 then
				min := jadwal_kereta[i].harga;
			end;
		end;
		if (min <> 0) then
		write ('Harga termurah : ',min);
		writeln;
	end;

procedure cariharga;
	var
		pilihan,x : string;
		pilihan2 : integer;
		indeks : integer;
	begin
		repeat
			writeln('Ingin melakukan pencarian (y/n) ? ');
			readln(pilihan);
			if (pilihan='y') or (pilihan = 'Y') then
			begin
				writeln ('1.Harga Termahal');
				writeln ('2.Harga Termurah');
				write   ('Pilih : ');
				readln(pilihan2);
				writeln;
				if (pilihan2 = 1) then
				begin
					SearchHargaMax;
					writeln;
				end
				else if (pilihan2 = 2) then
				begin
					SearchHargaMin;
					writeln;
				end;
			end;
		until (pilihan ='n');
	end;
//======================================================Pilihan Setiap Data========================================================//
procedure Pilih_jadwal(var datapembeli : Pembeli);
	var
		pilihjadwal : integer;

	begin
	clrscr;
		pilihansorting;
		writeln;
		repeat
			write ('Silahkan pilih berdasarkan nomor jadwal : '); readln(pilihjadwal);
			writeln ('#Keterangan : Harga kelas eksekutif ditambah 30% ');
			write ('Kelas kereta (ekonomi/eksekutif)    : '); readln(datapembeli.Kelas_Kereta);

			if((datapembeli.Kelas_Kereta <> 'ekonomi') or (datapembeli.Kelas_Kereta <> 'eksekutif')) then
			begin
				writeln ('Salah Memilih jadwal');
				writeln;
			end;

		until((datapembeli.Kelas_Kereta = 'ekonomi') or (datapembeli.Kelas_Kereta = 'eksekutif'));
		//==================================simpan data==================================================//
		for i:=1 to pilihjadwal do
			begin
				datapembeli.tujuan := jadwal_kereta[i].Tujuan;
				datapembeli.jam := jadwal_kereta[i].jam;
				datapembeli.Harga := jadwal_kereta[i].Harga;
			end;

		if (datapembeli.Kelas_Kereta = 'ekonomi') then
			Peta_Kursi_ekonomi(datakursi_ekonomi)
		else if  (datapembeli.Kelas_Kereta = 'eksekutif') then
			Peta_Kursi_eksekutif(datakursi_eksekutif);

	end;

procedure input_data_pembeli(var datapembeli : Pembeli);
	begin
	clrscr;
		gotoxy(25,10);writeln('==============================Form Pembeli============================');
		gotoxy(25,14);writeln('======================================================================');
		gotoxy(25,12);write  ('   Nama Lengkap     : '); readln(datapembeli.nama);
		gotoxy(25,13);write  ('   Status Pekerjaan : '); readln(datapembeli.Status_Pekerjaan);
		pilih_jadwal(datapembeli);
	end;

//==========================================================Cetak Tiket============================================================//
procedure CetakTiketEkonomi;
	begin
	clrscr;
        writeln('                              [*]========================TIKET KERETA API==========================[*]');
        writeln(                                                                                                        );
        writeln('                                  Nama               : ',datakursi_ekonomi[i][j].Nama                  );
        writeln('                                  Status Pekerjaan   : ',datakursi_ekonomi[i][j].Status_Pekerjaan      );
        writeln('                                                                                                      ');
        writeln('                                                                                                      ');
        writeln('                                                           Data Kereta                                ');
        writeln('                                  Tujuan    : ',datakursi_ekonomi[i][j].tujuan                         );
        writeln('                                  Kelas     : ',datakursi_ekonomi[i][j].Kelas_Kereta                   );
        writeln('                                  Jam       : ',datakursi_ekonomi[i][j].jam                            );
        writeln('                                  Kursi     : ',datakursi_ekonomi[i][j].nomorkursi,datakursi_ekonomi[i][j].abjadkursi);
        writeln('                              [*]==================================================================[*]');
        writeln('                                                                                                      ');
        writeln('                                                                                                      ');
        writeln('                              Harga Tiket yang harus dibayar : Rp.',datakursi_ekonomi[i][j].Harga      );
        readln;
    end;

procedure CetakTiketEksekutif;
	begin
	clrscr;
        writeln('                              [*]========================TIKET KERETA API==========================[*]');
        writeln(                                                                                                        );
        writeln('                                  Nama               : ',datakursi_eksekutif[i][j].Nama                );
        writeln('                                  Status Pekerjaan   : ',datakursi_eksekutif[i][j].Status_Pekerjaan    );
        writeln('                                                                                                      ');
        writeln('                                                                                                      ');
        writeln('                                                           Data Kereta                                ');
        writeln('                                  Tujuan    : ',datakursi_eksekutif[i][j].tujuan                       );
        writeln('                                  Kelas     : ',datakursi_eksekutif[i][j].Kelas_Kereta                 );
        writeln('                                  Jam       : ',datakursi_eksekutif[i][j].jam                          );
        writeln('                                  Kursi     : ',datakursi_eksekutif[i][j].nomorkursi,datakursi_eksekutif[i][j].abjadkursi);
        writeln('                              [*]==================================================================[*]');
        writeln('                                                                                                      ');
        writeln('                                                                                                      ');
        writeln('                              Harga Tiket yang harus dibayar : Rp.',datakursi_eksekutif[i][j].Harga +(datakursi_eksekutif[i][j].Harga*0.3):0:0);
        readln;
    end;

procedure searchNama;
	var
		nama,Status : string;
	begin
	clrscr;
		gotoxy(25,10);writeln('===========================Cetak Tiket======================');
		gotoxy(25,14);writeln('============================================================');
		gotoxy(25,12);write  ('   Nama Lengkap     : '); readln (nama);
		gotoxy(25,13);write  ('   Status Pekerjaan : '); readln (Status);
		clrscr;
		loading;
		delay(100);
		for i := 1 to 15 do
		begin
			for j := 'A' to 'D' do
			begin
				if (datakursi_ekonomi[i][j].nama = nama ) and (datakursi_ekonomi[i][j].Status_Pekerjaan = Status) then
					CetakTiketEkonomi
				else if (datakursi_eksekutif[i][j].nama = nama) and (datakursi_eksekutif[i][j].Status_Pekerjaan = Status) then
					CetakTiketEksekutif;
			end;
		end;
	end;

//=========================================================Menu pembeli=============================================================//
procedure Menu_pembeli;
	var
		pilihan : integer;
	begin
			repeat
	clrscr;
			writeln ('======================================Silahkan Pilih Menu===============================');
			writeln ('= 1.Lihat Jadwal                                                                       =');
			writeln ('= 2.Pesan jadwal                                                                       =');
			writeln ('= 3.Cetak Tiket                                                                        =');
			writeln ('=                                                                              0.Exit  =');
			writeln ('========================================================================================');
			writeln();
			write ('Pilih Menu : ');
			readln(pilihan);

			while (pilihan <> 1) and (pilihan <> 2) and (pilihan <>3) and (pilihan <>0) do
			begin
			writeln ('Menu tidak tersedia, mohon input ulang');
			write ('Pilih Menu : ');
			readln (pilihan);
			end;

			case pilihan of
			1 : begin
				Tayang_Jadwal;
				cariharga;
				end;
			2 : input_data_pembeli (datapembeli);
			3 : searchNama;
			end;
			until (pilihan =0);
     end;

//=========================================================Menu Stasiun=============================================================//
procedure Menu_stasiun;
	var
		pilihan : integer;
	begin
	clrscr;
			login;
			repeat
	clrscr;
			writeln('=================================Menu Pihak Stasiun=================================');
			writeln('= 1.Input  Data                                                                    =');
			writeln('= 2.Delete Data                                                                    =');
			writeln('= 3.Tambah Data                                                                    =');
			writeln('= 4.Lihat  Data                                                                    =');
			writeln('=                                                                          0.Exit  =');
			writeln('====================================================================================');
			writeln;
			write ('Pilih Menu : ');
			readln (pilihan);

			while (pilihan <> 1) and (pilihan <> 2) and (pilihan<>3) and (pilihan<>4) and (pilihan<>0) do
			begin
			writeln ('Menu tidak tersedia, mohon input ulang');
			write   ('Pilih Menu : ');
			readln (pilihan);
			end;

			case pilihan of
			1 : input_jadwal (datastasiun,jadwal_kereta);
			2 : begin
				Tayang_Jadwal;
				delete(jadwal_kereta);
				end;
			3 : edit(datastasiun,jadwal_kereta);
			4 : Tayang_Jadwal;
            end
            until (pilihan = 0);
        end;
//==========================================================Menu Utama==============================================================//
procedure Menu_utama;
    var
        pilihan : integer;
    begin
       		repeat
    clrscr;
            writeln ('==========================Selamat datang di PT. Kereta Api AR====================== ');
            writeln ('= 1.Pihak Stasiun                                                                 = ');
            writeln ('= 2.Pembeli                                                                       = ');
            writeln ('=                                                                                 = ');
            writeln ('=                                                                        0. exit  = ');
            writeln ('=================================================================================== ');
            writeln ();
            write   ('Pilih Menu : ');
            readln  (pilihan);


			while (pilihan <> 1) and (pilihan <> 2) and (pilihan<>0) do
			begin
			writeln ('Menu tidak tersedia, mohon input ulang');
			write ('Pilih Menu : ');
			readln (pilihan);
			end;

            case pilihan of
                1 : Menu_stasiun;
                2 : Menu_pembeli;
            end;
            until (pilihan = 0);
    end;
//=========================================================Program utama============================================================//

begin
clrscr;		
		if fileexists ('ArsipEkonomi.dat') then
		begin
		assign(SaveEkonomi,'ArsipEkonomi.dat');
        assign(SaveEksekutif,'ArsipEksekutif.dat');
            assign(SaveJadwal,'ArsipJadwal.dat');
            assign(savejumlahjadwal,'Arsipjumlahjadwal.dat');
            reset(SaveEkonomi);
               	reset(SaveEksekutif);
                reset(SaveJadwal);
                reset(savejumlahjadwal);
               				
               	while ((not eof (SaveEkonomi)) and (not eof (SaveEksekutif)) and (not eof(SaveJadwal))) do
               	begin
               		read(SaveEkonomi,datakursi_ekonomi);
               		read(SaveEksekutif,datakursi_eksekutif);
               		read(SaveJadwal,jadwal_kereta);
               		read(savejumlahjadwal,JumlahJadwal);
               	end;
               		close(SaveEksekutif);
               		close(SaveEkonomi);
               		close(SaveJadwal);
               		close(saveJumlahJadwal);
        end;
        begin		

        textbackground(cyan);
        textcolor(black);
        Menu_utama ();
        assign(SaveEkonomi,'ArsipEkonomi.dat');
        rewrite(SaveEkonomi);
            assign(SaveEksekutif,'ArsipEksekutif.dat');
            rewrite(SaveEksekutif);
                assign(SaveJadwal,'ArsipJadwal.dat');
                rewrite(SaveJadwal);
                assign(savejumlahjadwal,'Arsipjumlahjadwal.dat');
                rewrite(savejumlahjadwal);
        reset(SaveEkonomi);
        write(SaveEkonomi,datakursi_ekonomi);
        	reset(SaveEksekutif);
        	write(SaveEksekutif,datakursi_eksekutif);
        		reset(SaveJadwal);
        		write(SaveJadwal,jadwal_kereta);
        		reset(savejumlahjadwal);
        		write(savejumlahjadwal,JumlahJadwal);
        end;
end.
