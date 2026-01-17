; Program Penghitung BMI (Body Mass Index)
; Output tetap menampilkan input sebelumnya
; Untuk emu8086

org 100h

.data
    msg_berat  db 'Masukkan Berat Badan (kg): $'
    msg_tinggi db 0Dh, 0Ah, 'Masukkan Tinggi Badan (cm): $' ; Tambah baris baru di awal
    msg_hasil  db 0Dh, 0Ah, 0Dh, 0Ah, '--- HASIL PERHITUNGAN ---', 0Dh, 0Ah, 'Skor BMI Anda (Pembulatan): $'
    msg_cat    db 0Dh, 0Ah, 'Kategori: $'
    
    cat_kurus  db 'Berat Badan Kurang (Underweight)$'
    cat_ideal  db 'Berat Badan Ideal (Normal)$'
    cat_gemuk  db 'Kelebihan Berat Badan (Overweight)$'
    cat_obes   db 'Obesitas (Obese)$'
    
    berat      dw ?
    tinggi     dw ?
    bmi_score  dw ?

.code
start:
    ; 1. Input Berat Badan
    mov dx, offset msg_berat
    mov ah, 09h
    int 21h
    call input_num
    mov berat, ax
    
    ; 2. Input Tinggi Badan (Teks akan muncul di baris bawahnya tanpa menghapus berat)
    mov dx, offset msg_tinggi
    mov ah, 09h
    int 21h
    call input_num
    mov tinggi, ax

    ; --- Logika Perhitungan BMI ---
    ; (Berat * 10000) / (Tinggi * Tinggi)
    mov ax, tinggi
    mul tinggi       
    mov bx, ax       ; Simpan Tinggi^2 di BX

    mov ax, berat
    mov cx, 10000
    mul cx           ; DX:AX = Berat * 10000
    div bx           ; AX = Hasil bagi (Skor BMI)
    mov bmi_score, ax

    ; --- Menampilkan Output Akhir ---
    mov dx, offset msg_hasil
    mov ah, 09h
    int 21h
    
    mov ax, bmi_score
    call print_num

    mov dx, offset msg_cat
    mov ah, 09h
    int 21h

    ; Penentuan Kategori
    mov ax, bmi_score
    cmp ax, 18
    jbe kurang
    cmp ax, 24
    jbe ideal
    cmp ax, 29
    jbe gemuk
    jmp obesitas

kurang:
    mov dx, offset cat_kurus
    jmp print_cat
ideal:
    mov dx, offset cat_ideal
    jmp print_cat
gemuk:
    mov dx, offset cat_gemuk
    jmp print_cat
obesitas:
    mov dx, offset cat_obes

print_cat:
    mov ah, 09h
    int 21h

exit:
    mov ah, 4Ch
    int 21h

; --- Prosedur Input Angka ---
input_num proc
    xor bx, bx
input_loop:
    mov ah, 01h
    int 21h
    cmp al, 13       ; Enter?
    je input_done
    sub al, '0'
    mov ah, 0
    push ax
    mov ax, 10
    mul bx
    pop dx
    add ax, dx
    mov bx, ax
    jmp input_loop
input_done:
    mov ax, bx
    ret
input_num endp

; --- Prosedur Cetak Angka ---
print_num proc
    push ax
    push bx
    push cx
    push dx
    mov cx, 0
    mov bx, 10
p_loop1:
    mov dx, 0
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne p_loop1
p_loop2:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop p_loop2
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num endp

end start