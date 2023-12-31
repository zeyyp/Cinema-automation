using Npgsql;
using NpgsqlTypes;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices.ComTypes;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace sinema
{
    public partial class film : Form
    {
        public film()
        {
            InitializeComponent();
        }

        NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost; port =5432; Database = sinema2; user ID = postgres; password=48;");
        private void FilmListeleB_Click(object sender, EventArgs e)
        {
            string sorgu = "Select*from \"Film\" ";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, baglanti);
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];

        }

        private void FilmAraB_Click(object sender, EventArgs e)
        {
           

            try
            {
                // TextBox'tan film adını al
                string filmAdi = textBoxFilmAdi.Text;

                // Fonksiyon adı
                string fonksiyonAdi = "filmgetir2";

                // NpgsqlCommand oluştur
                NpgsqlCommand cmd = new NpgsqlCommand($"SELECT * FROM {fonksiyonAdi}(@pfilmadi)", baglanti);

                // "pfilmadi" parametresini ekleyin
                cmd.Parameters.AddWithValue("pfilmadi", filmAdi);

                // NpgsqlDataAdapter kullanarak sorguyu çalıştırın
                NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(cmd);
                DataTable table = new DataTable();
                adapter.Fill(table);

                // Verileri işleyin (örneğin DataGridView'e aktarabilirsiniz)
                dataGridView1.DataSource = table;
            }
            catch (Exception ex)
            {
                // Hata yönetimi
                MessageBox.Show("Hata oluştu: " + ex.Message);
            }



        }

        private void FilmGuncelleB_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            try
            {
                // TextBox'tan film bilgilerini al
                string filmID = GtextBoxID.Text;
                string filmAdi = GtextBoxAdi.Text;
                string Yonetmen = GtextBoxYönetmen.Text;
                string IMDb = GtextBoxIMDb.Text;

                // Fonksiyon adı
                string fonksiyonAdi = "filmguncelle2";

                // NpgsqlCommand oluştur
                NpgsqlCommand cmd = new NpgsqlCommand($"SELECT * FROM {fonksiyonAdi}(@pfilmkodu, @pfilmadi, @pyonetmen, @pimdb)", baglanti);

                // Parametreleri ekleyin
                cmd.Parameters.AddWithValue("pfilmkodu", NpgsqlDbType.Varchar).Value = filmID;
                cmd.Parameters.AddWithValue("pfilmadi", filmAdi);
                cmd.Parameters.AddWithValue("pyonetmen", Yonetmen);
                cmd.Parameters.AddWithValue("pimdb", float.Parse(IMDb));

                // NpgsqlDataAdapter kullanarak sorguyu çalıştırın
                NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(cmd);
                DataTable table = new DataTable();
                adapter.Fill(table);

                // Verileri işleyin (örneğin DataGridView'e aktarabilirsiniz)
                dataGridView1.DataSource = table;
            }
            catch (Exception ex)
            {
                // Hata yönetimi
                MessageBox.Show("Hata oluştu: " + ex.Message);
            }
        }


        //--------------------------------------------------------------------------------

        private void FilmEkleB_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            try
            {
                // TextBox'tan film bilgilerini al
                string filmID = EtextBoxID.Text;
                string filmAdi = EtextBoxAdi.Text;
                string Yonetmen = EtextBoxYönetmen.Text;
                string IMDb = EtextBoxIMDb.Text;

                // Fonksiyon adı
                string fonksiyonAdi = "FilmEkle";

                // NpgsqlCommand oluştur
                NpgsqlCommand cmd = new NpgsqlCommand($"SELECT * FROM {fonksiyonAdi}(@pfilmkodu, @pfilmadi, @pyonetmen, @pimdb)", baglanti);

                // Parametreleri ekleyin
                cmd.Parameters.AddWithValue("pfilmkodu", NpgsqlDbType.Varchar).Value = filmID;
                cmd.Parameters.AddWithValue("pfilmadi", filmAdi);
                cmd.Parameters.AddWithValue("pyonetmen", Yonetmen);
                cmd.Parameters.AddWithValue("pimdb", float.Parse(IMDb));

                // NpgsqlDataAdapter kullanarak sorguyu çalıştırın
                NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(cmd);
                DataTable table = new DataTable();
                adapter.Fill(table);

                // Verileri işleyin (örneğin DataGridView'e aktarabilirsiniz)
                dataGridView1.DataSource = table;
            }
            catch (Exception ex)
            {
                // Hata yönetimi
                MessageBox.Show("Hata oluştu: " + ex.Message);
            }
            baglanti.Close();
        }



        private void FilmSilB_Click(object sender, EventArgs e)
        {
            baglanti.Open();
            try
            {
                // TextBox'tan film bilgilerini al
                string filmID = StextBoxID.Text;
                string filmAdi = StextBoxAdi.Text;
                string Yonetmen = StextBoxYönetmen.Text;
                string IMDb = StextBoxIMDb.Text;

                // Fonksiyon adı
                string fonksiyonAdi = "FilmSil";

                // NpgsqlCommand oluştur
                NpgsqlCommand cmd = new NpgsqlCommand($"SELECT * FROM {fonksiyonAdi}(@pfilmkodu)", baglanti);

                
                cmd.Parameters.AddWithValue("pfilmkodu", NpgsqlDbType.Varchar).Value = filmID;
                

                NpgsqlDataAdapter adapter = new NpgsqlDataAdapter(cmd);
                DataTable table = new DataTable();
                adapter.Fill(table);

                dataGridView1.DataSource = table;
            }
            catch (Exception ex)
            {
                // Hata yönetimi
                MessageBox.Show("Hata oluştu: " + ex.Message);
            }
            baglanti.Close();
        }
    }
}
