//creo eseguibile col comando su command window:
//c++ main.cpp -L dependencies/lib -lpq -o main

#include <cstdio>
#include <iostream>
#include <fstream>
#include "dependencies/include/libpq-fe.h"

using namespace std;

#define PG_HOST "127.0.0.1"
#define PG_USER "filippotonini" // nome utente
#define PG_DB "Progetto" //il nome del database
#define PG_PASS "xxxxxx" // password
#define PG_PORT 5432
 

PGconn* connectDB(){
    //connessione col DB
    char conninfo[250];
    sprintf(conninfo,"user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER , PG_PASS, PG_DB, PG_HOST, PG_PORT);
    
    PGconn * conn = PQconnectdb(conninfo);
    
    if (PQstatus(conn) != CONNECTION_OK){
        cout<<"Errore di connessione " << PQerrorMessage(conn);
        PQfinish(conn);
        exit(1);
    }
    else{
        cout <<" Connessione avvenuta correttamente "<<endl;
        
        return conn;
    }
}

void checkResults(PGresult* res, const PGconn* conn){
    //check dei risultati
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Risultati inconsisitenti!" << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }
}

void PrintLine(int nfields, int* columnsize){
    //print di una linea di una certa lunghezza
    cout << "-";
    for(int i=0; i<nfields; ++i){
        for(int j=0; j<columnsize[i]+3; ++j){
            cout << "-";
        }
    }
    cout << endl;
}

void PrintQuery(PGresult* res) {
    const int ntuple = PQntuples(res), nfields = PQnfields(res);
    //crea matrice dove saranno inseriti i risulatati della query e i nomi degli attributi
    string table[ntuple + 1][nfields];

    //inserisce nella prima riga il nome degli attributi
    for (int i = 0; i < nfields; ++i) {
        string s = PQfname(res, i);
        table[0][i] = s;
    }
    
    //assegna a tutti gli altri elementi della matrice il risulatato della query
    for (int i = 0; i < ntuple; ++i)
        for (int j = 0; j < nfields; ++j) {
            if(PQgetisnull(res, i, j))
                table[i+1][j] = "[null]";
            
            else
                table[i+1][j] = PQgetvalue(res, i, PQfnumber(res, PQfname(res, j)));
     }
    
     //inizializza la dimensione della colonna a 0
     int columnsize[nfields];
     for (int i = 0; i < nfields; ++i)
        columnsize[i] = 0;

    //trova la lunghezza massima in char tra le tuple di un certo attributo e lo salva in columnsize
     for (int i = 0; i < nfields; ++i) {
        for (int j = 0; j < ntuple+1; ++j) {
            int size = table[j][i].size();
            if (columnsize[i] < size)
                columnsize[i] = size;
        }
     }
    
    PrintLine(nfields, columnsize);
    
    //stampa gli attributi e lascia spazi vuoti per raggiungere la dimensione della colonna
    for (int j = 0; j < nfields; ++j) {
        cout << "|";
        cout << table[0][j];
        for (int k = 0; k < columnsize[j] - table[0][j].size() + 2; ++k)
            cout << ' ';
        if (j == nfields - 1)
            cout << "|";
    }
    cout << endl;
    PrintLine(nfields, columnsize);
    
    //stampa le tuple sempre lasciando spazi vuoti nel caso la stringa stampata sia più corta della domansione della colonna
    for (int i = 1; i < ntuple + 1; ++i) {
        for (int j = 0; j < nfields; ++j) {
            cout << "| ";
            cout << table[i][j];
            for (int k = 0; k < columnsize[j] - table[i][j].size() + 1; ++k)
                cout << ' ';
            if (j == nfields - 1)
                cout << "|";
        }
        cout << endl;
    }
    PrintLine(nfields, columnsize);
}

 int main (int argc, char **argv) {
     
     PGconn* conn = connectDB();
     PGresult *res;
     bool repeat=true;
     
     while(repeat){ //main loop del programma
     
     //print lista query
     int InputNumber;
     cout << endl;
     cout << "scegliere una query digitando un numero tra 1 e 6" << endl;
     cout << "1) Dato il codice fiscale di un agonista, mostrare il completamento delle route di gara che ha tentato ordinate secondo l’inclinazione della parete" << endl << endl;
     cout << "2) Per ogni altezza degli agonisti trovare le somme delle vie completate, raggruppate per tipo di presa" << endl << endl;
     cout << "3) Trovare il materiale di presa più usato da ogni routesetter e il loro corrispettivo stipendio" << endl << endl;
     cout << "4) Trovare gli orari di prenotazione in cui la media del numero del noleggio delle scarpette è maggiore di un certo numero" << endl << endl;
     cout << "5) Trovare gli iscritti che partecipano a un certo corso, e che hanno un certo abbonamento" << endl << endl;
     cout << "6) Trovare nome e cognome delle persone che frequentano i corsi di trainer con uno stipendio maggiore di un certo valore (es 1730)" << endl << endl;
     
     //input per scegliere la query
     cin >> InputNumber;
     if(InputNumber>6||InputNumber<0){InputNumber=7;}
     char Query[250];
     char in[20];
         
     //switch su query in base al numero scelto
     switch(InputNumber){
         case 0:
             repeat=false;
             break;
         case 1:
             cout << "inserire un codice fiscale (es LZZGDU94D07B888Z)" << endl;
             cin >> in;
             sprintf(Query, "Select InclinazioneMuro, Completamento from RouteDiGara where Agonista in ( Select CodTessera From Utente as u join Iscritto as i on i.CF=u.CF where u.CF='%s')Order by InclinazioneMuro;", in);
             res = PQexec(conn, Query);
             checkResults(res, conn);
             PrintQuery(res);
             break;
         case 2:
             res = PQexec(conn, "select Altezza, TipoPresa, sum(Completamento) from Agonista as a join RouteDiGara as r on a.CodTessera=r.Agonista group by Altezza, TipoPresa order by Altezza");
             checkResults(res, conn);
             PrintQuery(res);
             break;
         case 3:
             res = PQexec(conn, "Select Routesetter, MaterialePiùUsato, Stipendio from Routesetter join  (select Routesetter,max(Materiale) as MaterialePiùUsato from InventarioPrese,Route where InventarioPrese.Route = Route.IDPercorso group by Routesetter) as RM on Routesetter.Soprannome=RM.Routesetter");
             checkResults(res, conn);
             PrintQuery(res);
             break;
         case 4:
             cout << "inserire il numero (es 3)" << endl;
             cin >> in;
             sprintf(Query, "select Orario from Iscritto as i join Effettuazione as e on i.CodTessera=e.Iscritto group by e.Orario having avg(NumNoleggioScarpette) > %s", in);
             res = PQexec(conn, Query);
             checkResults(res, conn);
             PrintQuery(res);
             break;
         case 5:
             char in2[20];
             cout << "inserire il codice del corso (es INT01)" << endl;
             cin >> in;
             cout << "inserire il nome dell'abbonamento (es mensile)" << endl;
             cin >> in2;
             sprintf(Query, "select Abbonamento.CodTessera from Abbonamento join Iscritto on Abbonamento.CodTessera = Iscritto.CodTessera where Iscritto.CodCorso='%s' and Abbonamento.Nome='%s'", in, in2);
             res = PQexec(conn, Query);
             checkResults(res, conn);
             PrintQuery(res);
             break;
         case 6:
             cout << "inserire lo stipendio del trainer (es 1730)" << endl;
             cin >> in;
             sprintf(Query, "select Nome,Cognome from Iscritto join Utente on Iscritto.CF=Utente.Cf where Iscritto.CodCorso in (select CodCorso from Corso join Trainer on Corso.Trainer=Trainer.Utente where Trainer.Stipendio > %s)", in);
             res = PQexec(conn, Query);
             checkResults(res, conn);
             PrintQuery(res);
             break;
         case 7:
             cout << "errore: indice query inesistente" << endl;
             break;
             
     }
     }
     PQfinish(conn);
     return 0;
}

