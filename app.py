from flask import Flask, render_template, request, redirect, url_for, send_from_directory
from flask_mysqldb import MySQL 
import uuid
import os
import datetime
from werkzeug.utils import secure_filename
app = Flask(__name__)

# Konfigurasi database
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'pos'
mysql = MySQL(app)
tanggal_daftar = datetime.date.today()

# Path to save uploaded images
UPLOAD_FOLDER = 'uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@app.route('/')
def main():
    return render_template('/index.html/')

@app.route('/kontak')
def kontak():
    return render_template('/kontak.html/')

# Master Data Kader
@app.route('/datakader')
def datakader():
    cur = mysql.connection.cursor()
    cur.execute("SELECT id, nama, alamat, tanggal_lahir, pekerjaan, Jenis_kelamin, agama, foto FROM informasikader")
    informasi = cur.fetchall()
    cur.close()
    return render_template('datakader.html', menu='kader', submenu='data', data=informasi)

@app.route('/statusregistrasi')
def statusregistrasi():
    cur = mysql.connection.cursor()
    cur.execute("SELECT id, status, tanggal_daftar FROM status")
    info = cur.fetchall()
    cur.close()
    return render_template('statusregistrasi.html', menu='registrasi', submenu='status', data=info)

@app.route('/display_photo/<int:member_id>')
def display_photo(member_id):
    # Fetch photo filename from database based on member_id
    cur = mysql.connection.cursor()
    cur.execute("SELECT foto FROM informasikader WHERE id = %s", (member_id,))
    photo_filename = cur.fetchone()[0]
    cur.close()

    # Return the photo file as a response
    return send_from_directory(app.config['UPLOAD_FOLDER'], photo_filename)

# Route to download photo based on member_id
@app.route('/download_photo/<int:member_id>')
def download_photo(member_id):
    # Fetch photo filename from database based on member_id
    cur = mysql.connection.cursor()
    cur.execute("SELECT foto FROM informasikader WHERE id = %s", (member_id,))
    photo_filename = cur.fetchone()[0]
    cur.close()

    # Return the photo file as a download response
    return send_from_directory(app.config['UPLOAD_FOLDER'], photo_filename, as_attachment=True)

# KTA
@app.route('/kta')
def kta():
    cur = mysql.connection.cursor()
    cur.execute("SELECT id, nama, foto FROM informasikader")
    data = cur.fetchall()
    cur.close()

    # Render the template with fetched data
    return render_template('kta.html', menu='kta', submenu='kta', data=data)

# Master Form Registrasi
@app.route('/simpanformregistrasi', methods=["POST"])
def simpanformregistrasi():
    try:
        id_pendaftaran = uuid.uuid4()  # Generate UUID
        nama = request.form.get('nama')
        alamat = request.form.get('alamat')
        notelp = request.form.get('notelp')
        tgl = request.form.get('tgl')
        pekerjaan = request.form.get('pekerjaan')
        jk = request.form.get('jk')
        agama = request.form.get('agama')
        ab = request.form.get('ab')
        foto = request.files.get('foto')

        if not all([nama, alamat, tgl, pekerjaan, jk, agama, foto]):
            return "Missing form data", 400

        if foto:
            filename = secure_filename(foto.filename)
            foto.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

            cur = mysql.connection.cursor()
            cur.execute("""
                INSERT INTO informasikader (nama, alamat, tanggal_lahir, pekerjaan, Jenis_kelamin, agama, foto) 
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (nama, alamat, tgl, pekerjaan, jk, agama, filename))

            cur.execute("""
                INSERT INTO status (status, tanggal_daftar) 
                VALUES ('Pending', %s)
            """, (tanggal_daftar,))
            
            cur.execute("""
                INSERT INTO informasipendaftaran (id_pendaftaran, nama_kader, no_hp, alasan_bergabung) 
                VALUES (%s,%s, %s, %s)
            """, (str(id_pendaftaran.hex)[:4], nama, notelp, ab,))

            cur.execute("""
                INSERT INTO ekta (nama, foto) 
                VALUES (%s, %s)
            """, ( nama, filename))

            mysql.connection.commit()
            cur.close()

        return redirect(url_for('kta'))
    except Exception as e:
        return f"An error occurred: {str(e)}", 500

# Form dan Data
@app.route('/formregistrasi')
def formregistrasi():
    return render_template('formregistrasi.html', menu='registrasi', submenu='form')


@app.route('/strukturpartai')
def strukturpartai():
    return render_template('strukturpartai.html', menu='partai', submenu='struktur')


@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

if __name__ == '__main__':
    app.run(debug=True)
