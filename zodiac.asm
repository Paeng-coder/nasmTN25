global _start

section .data

title db 10
      db "==========================================",10
      db "          THE ZODIAC ORACLE",10
      db "==========================================",10,0

welcome db "Discover your destiny!",10,0
askName db "Enter your name: ",0
askMonth db "Enter birth month (1-12): ",0
askDay db "Enter birth day (1-31): ",0
hello db 10,"Welcome, ",0
newline db 10,0

invalidDate db "Invalid date. Please try again.",10,0
invalidChoice db "Invalid choice. Please select 1-6.",10,0

menu db 10,"===== HOROSCOPE MENU =====",10
     db "[1] Love and Relationships",10
     db "[2] Career and Studies",10
     db "[3] Health and Wellness",10
     db "[4] Lucky Number and Color",10
     db "[5] View Zodiac Information",10
     db "[6] Exit",10
     db "Enter your choice: ",0

exitMessage db 10,"Thank you for using the Zodiac Oracle. Goodbye!",10,0
returnMenu db 10,"Return to menu? (Y/N): ",0

signMessage db 10,"--- YOUR ZODIAC SIGN ---",10,0
signLabel db "Zodiac Sign: ",0
elementLabel db "Element: ",0
symbolLabel db "Symbol: ",0
personalityLabel db "Personality: ",0
luckyLabel db "Lucky Number: ",0
colorLabel db "Lucky Color: ",0

zodiacArt db "       /\/\",10
          db "      ( o.o )",10
          db "       > ^ <",10,0

lovePrediction db 10
               db "Love and Relationships: Your charm attracts positive",10
               db "connections. Stay honest and confident.",10,0

careerPrediction db 10
                 db "Career and Studies: Your discipline will help you",10
                 db "reach an important goal soon.",10,0

healthPrediction db 10
                 db "Health and Wellness: Rest when needed and keep",10
                 db "a balanced daily routine.",10,0

; Zodiac names
capricorn db "Capricorn",0
aquarius db "Aquarius",0
pisces db "Pisces",0
aries db "Aries",0
taurus db "Taurus",0
gemini db "Gemini",0
cancer db "Cancer",0
leo db "Leo",0
virgo db "Virgo",0
libra db "Libra",0
scorpio db "Scorpio",0
sagittarius db "Sagittarius",0

; Zodiac elements
earth db "Earth",0
air db "Air",0
water db "Water",0
fire db "Fire",0

; Zodiac symbols
goat db "Goat",0
waterBearer db "Water Bearer",0
fish db "Fish",0
ram db "Ram",0
bull db "Bull",0
twins db "Twins",0
crab db "Crab",0
lion db "Lion",0
maiden db "Maiden",0
scales db "Scales",0
scorpion db "Scorpion",0
archer db "Archer",0

; Personalities
capPersonality db "Responsible, ambitious, and practical.",0
aquPersonality db "Independent, creative, and progressive.",0
pisPersonality db "Compassionate, imaginative, and gentle.",0
ariPersonality db "Confident, energetic, and courageous.",0
tauPersonality db "Patient, dependable, and determined.",0
gemPersonality db "Curious, adaptable, and communicative.",0
canPersonality db "Caring, loyal, and protective.",0
leoPersonality db "Confident, generous, and passionate.",0
virPersonality db "Analytical, kind, and hardworking.",0
libPersonality db "Diplomatic, social, and balanced.",0
scoPersonality db "Focused, brave, and mysterious.",0
sagPersonality db "Optimistic, adventurous, and honest.",0

; Lucky colors
gray db "Gray",0
blue db "Blue",0
green db "Green",0
red db "Red",0
yellow db "Yellow",0
silver db "Silver",0
gold db "Gold",0
navy db "Navy Blue",0
pink db "Pink",0
maroon db "Maroon",0
purple db "Purple",0

inputBuffer times 128 db 0
nameBuffer times 64 db 0

birthMonth dd 0
birthDay dd 0
zodiacIndex dd 0

section .text

_start:
    call display_welcome
    call get_user_info
    call validate_birthdate

    cmp eax,1
    je valid_date

    mov esi,invalidDate
    call print_string
    jmp _start

valid_date:
    call determine_zodiac
    call display_zodiac

main_menu:
    call display_menu
    call read_number

    cmp eax,1
    je love_choice

    cmp eax,2
    je career_choice

    cmp eax,3
    je health_choice

    cmp eax,4
    je lucky_choice

    cmp eax,5
    je information_choice

    cmp eax,6
    je exit_program

    mov esi,invalidChoice
    call print_string
    jmp main_menu

love_choice:
    mov esi,lovePrediction
    call print_string
    jmp ask_return

career_choice:
    mov esi,careerPrediction
    call print_string
    jmp ask_return

health_choice:
    mov esi,healthPrediction
    call print_string
    jmp ask_return

lucky_choice:
    call display_lucky
    jmp ask_return

information_choice:
    call display_zodiac

ask_return:
    mov esi,returnMenu
    call print_string

    call read_line

    mov al,[inputBuffer]
    or al,32

    cmp al,'y'
    je main_menu

    jmp exit_program


; --------------------------------------------------
; Display welcome screen
; --------------------------------------------------

display_welcome:
    mov esi,title
    call print_string

    mov esi,welcome
    call print_string

    ret


; --------------------------------------------------
; Get user information
; --------------------------------------------------

get_user_info:
    mov esi,askName
    call print_string

    call read_line

    mov esi,nameBuffer
    mov edi,inputBuffer
    call copy_string

    mov esi,askMonth
    call print_string

    call read_number
    mov [birthMonth],eax

    mov esi,askDay
    call print_string

    call read_number
    mov [birthDay],eax

    mov esi,hello
    call print_string

    mov esi,nameBuffer
    call print_string

    mov esi,newline
    call print_string

    ret


; --------------------------------------------------
; Validate birthdate
; --------------------------------------------------

validate_birthdate:
    mov eax,[birthMonth]

    cmp eax,1
    jl invalid_birthdate

    cmp eax,12
    jg invalid_birthdate

    mov ebx,[birthDay]

    cmp ebx,1
    jl invalid_birthdate

    cmp ebx,31
    jg invalid_birthdate

    ; February only allows days 1-28
    cmp eax,2
    jne check_30_day_month

    cmp ebx,28
    jg invalid_birthdate

    mov eax,1
    ret

check_30_day_month:
    cmp eax,4
    je check_day_30

    cmp eax,6
    je check_day_30

    cmp eax,9
    je check_day_30

    cmp eax,11
    je check_day_30

    mov eax,1
    ret

check_day_30:
    cmp ebx,30
    jg invalid_birthdate

    mov eax,1
    ret

invalid_birthdate:
    mov eax,0
    ret


; --------------------------------------------------
; Correct Zodiac Identification
;
; Capricorn:   Dec 22 - Jan 19
; Aquarius:    Jan 20 - Feb 18
; Pisces:      Feb 19 - Mar 20
; Aries:       Mar 21 - Apr 19
; Taurus:      Apr 20 - May 20
; Gemini:      May 21 - Jun 20
; Cancer:      Jun 21 - Jul 22
; Leo:         Jul 23 - Aug 22
; Virgo:       Aug 23 - Sep 22
; Libra:       Sep 23 - Oct 22
; Scorpio:     Oct 23 - Nov 21
; Sagittarius: Nov 22 - Dec 21
; --------------------------------------------------

determine_zodiac:
    mov eax,[birthMonth]
    mov ebx,[birthDay]

    ; January 20 - February 18 = Aquarius
    cmp eax,1
    jne check_february

    cmp ebx,20
    jl capricorn_sign

    mov ecx,1
    jmp save_zodiac

check_february:
    cmp eax,2
    jne check_march

    cmp ebx,19
    jl aquarius_sign

    mov ecx,2
    jmp save_zodiac

check_march:
    cmp eax,3
    jne check_april

    cmp ebx,21
    jl pisces_sign

    mov ecx,3
    jmp save_zodiac

check_april:
    cmp eax,4
    jne check_may

    cmp ebx,20
    jl aries_sign

    mov ecx,4
    jmp save_zodiac

check_may:
    cmp eax,5
    jne check_june

    cmp ebx,21
    jl taurus_sign

    mov ecx,5
    jmp save_zodiac

check_june:
    cmp eax,6
    jne check_july

    cmp ebx,21
    jl gemini_sign

    mov ecx,6
    jmp save_zodiac

check_july:
    cmp eax,7
    jne check_august

    cmp ebx,23
    jl cancer_sign

    mov ecx,7
    jmp save_zodiac

check_august:
    cmp eax,8
    jne check_september

    cmp ebx,23
    jl leo_sign

    mov ecx,8
    jmp save_zodiac

check_september:
    cmp eax,9
    jne check_october

    cmp ebx,23
    jl virgo_sign

    mov ecx,9
    jmp save_zodiac

check_october:
    cmp eax,10
    jne check_november

    cmp ebx,23
    jl libra_sign

    mov ecx,10
    jmp save_zodiac

check_november:
    cmp eax,11
    jne check_december

    cmp ebx,22
    jl scorpio_sign

    mov ecx,11
    jmp save_zodiac

check_december:
    ; December 1-21 = Sagittarius
    cmp ebx,22
    jl sagittarius_sign

    ; December 22-31 = Capricorn
    jmp capricorn_sign


capricorn_sign:
    mov ecx,0
    jmp save_zodiac

aquarius_sign:
    mov ecx,1
    jmp save_zodiac

pisces_sign:
    mov ecx,2
    jmp save_zodiac

aries_sign:
    mov ecx,3
    jmp save_zodiac

taurus_sign:
    mov ecx,4
    jmp save_zodiac

gemini_sign:
    mov ecx,5
    jmp save_zodiac

cancer_sign:
    mov ecx,6
    jmp save_zodiac

leo_sign:
    mov ecx,7
    jmp save_zodiac

virgo_sign:
    mov ecx,8
    jmp save_zodiac

libra_sign:
    mov ecx,9
    jmp save_zodiac

scorpio_sign:
    mov ecx,10
    jmp save_zodiac

sagittarius_sign:
    mov ecx,11

save_zodiac:
    mov [zodiacIndex],ecx
    ret


; --------------------------------------------------
; Display zodiac information
; --------------------------------------------------

display_zodiac:
    mov esi,signMessage
    call print_string

    mov esi,zodiacArt
    call print_string

    mov esi,signLabel
    call print_string

    call print_zodiac_name

    mov esi,elementLabel
    call print_string

    call print_element

    mov esi,symbolLabel
    call print_string

    call print_symbol

    mov esi,personalityLabel
    call print_string

    call print_personality

    ret


; --------------------------------------------------
; Display lucky number and color
; --------------------------------------------------

display_lucky:
    mov esi,luckyLabel
    call print_string

    mov eax,[zodiacIndex]
    inc eax
    call print_number

    mov esi,newline
    call print_string

    mov esi,colorLabel
    call print_string

    mov eax,[zodiacIndex]

    cmp eax,0
    je print_gray

    cmp eax,1
    je print_blue

    cmp eax,2
    je print_green

    cmp eax,3
    je print_red

    cmp eax,4
    je print_green

    cmp eax,5
    je print_yellow

    cmp eax,6
    je print_silver

    cmp eax,7
    je print_gold

    cmp eax,8
    je print_navy

    cmp eax,9
    je print_pink

    cmp eax,10
    je print_maroon

    jmp print_purple

print_gray:
    mov esi,gray
    jmp print_color

print_blue:
    mov esi,blue
    jmp print_color

print_green:
    mov esi,green
    jmp print_color

print_red:
    mov esi,red
    jmp print_color

print_yellow:
    mov esi,yellow
    jmp print_color

print_silver:
    mov esi,silver
    jmp print_color

print_gold:
    mov esi,gold
    jmp print_color

print_navy:
    mov esi,navy
    jmp print_color

print_pink:
    mov esi,pink
    jmp print_color

print_maroon:
    mov esi,maroon
    jmp print_color

print_purple:
    mov esi,purple

print_color:
    call print_string

    mov esi,newline
    call print_string

    ret


; --------------------------------------------------
; Print zodiac name
; --------------------------------------------------

print_zodiac_name:
    mov eax,[zodiacIndex]

    cmp eax,0
    je name_capricorn

    cmp eax,1
    je name_aquarius

    cmp eax,2
    je name_pisces

    cmp eax,3
    je name_aries

    cmp eax,4
    je name_taurus

    cmp eax,5
    je name_gemini

    cmp eax,6
    je name_cancer

    cmp eax,7
    je name_leo

    cmp eax,8
    je name_virgo

    cmp eax,9
    je name_libra

    cmp eax,10
    je name_scorpio

    jmp name_sagittarius

name_capricorn:
    mov esi,capricorn
    jmp print_name

name_aquarius:
    mov esi,aquarius
    jmp print_name

name_pisces:
    mov esi,pisces
    jmp print_name

name_aries:
    mov esi,aries
    jmp print_name

name_taurus:
    mov esi,taurus
    jmp print_name

name_gemini:
    mov esi,gemini
    jmp print_name

name_cancer:
    mov esi,cancer
    jmp print_name

name_leo:
    mov esi,leo
    jmp print_name

name_virgo:
    mov esi,virgo
    jmp print_name

name_libra:
    mov esi,libra
    jmp print_name

name_scorpio:
    mov esi,scorpio
    jmp print_name

name_sagittarius:
    mov esi,sagittarius

print_name:
    call print_string

    mov esi,newline
    call print_string

    ret


; --------------------------------------------------
; Print element
; --------------------------------------------------

print_element:
    mov eax,[zodiacIndex]

    cmp eax,0
    je element_earth

    cmp eax,1
    je element_air

    cmp eax,2
    je element_water

    cmp eax,3
    je element_fire

    cmp eax,4
    je element_earth

    cmp eax,5
    je element_air

    cmp eax,6
    je element_water

    cmp eax,7
    je element_fire

    cmp eax,8
    je element_earth

    cmp eax,9
    je element_air

    cmp eax,10
    je element_water

    jmp element_fire

element_earth:
    mov esi,earth
    jmp print_element_text

element_air:
    mov esi,air
    jmp print_element_text

element_water:
    mov esi,water
    jmp print_element_text

element_fire:
    mov esi,fire

print_element_text:
    call print_string

    mov esi,newline
    call print_string

    ret


; --------------------------------------------------
; Print symbol
; --------------------------------------------------

print_symbol:
    mov eax,[zodiacIndex]

    cmp eax,0
    je symbol_goat

    cmp eax,1
    je symbol_water_bearer

    cmp eax,2
    je symbol_fish

    cmp eax,3
    je symbol_ram

    cmp eax,4
    je symbol_bull

    cmp eax,5
    je symbol_twins

    cmp eax,6
    je symbol_crab

    cmp eax,7
    je symbol_lion

    cmp eax,8
    je symbol_maiden

    cmp eax,9
    je symbol_scales

    cmp eax,10
    je symbol_scorpion

    jmp symbol_archer

symbol_goat:
    mov esi,goat
    jmp print_symbol_text

symbol_water_bearer:
    mov esi,waterBearer
    jmp print_symbol_text

symbol_fish:
    mov esi,fish
    jmp print_symbol_text

symbol_ram:
    mov esi,ram
    jmp print_symbol_text

symbol_bull:
    mov esi,bull
    jmp print_symbol_text

symbol_twins:
    mov esi,twins
    jmp print_symbol_text

symbol_crab:
    mov esi,crab
    jmp print_symbol_text

symbol_lion:
    mov esi,lion
    jmp print_symbol_text

symbol_maiden:
    mov esi,maiden
    jmp print_symbol_text

symbol_scales:
    mov esi,scales
    jmp print_symbol_text

symbol_scorpion:
    mov esi,scorpion
    jmp print_symbol_text

symbol_archer:
    mov esi,archer

print_symbol_text:
    call print_string

    mov esi,newline
    call print_string

    ret


; --------------------------------------------------
; Print personality
; --------------------------------------------------

print_personality:
    mov eax,[zodiacIndex]

    cmp eax,0
    je personality_capricorn

    cmp eax,1
    je personality_aquarius

    cmp eax,2
    je personality_pisces

    cmp eax,3
    je personality_aries

    cmp eax,4
    je personality_taurus

    cmp eax,5
    je personality_gemini

    cmp eax,6
    je personality_cancer

    cmp eax,7
    je personality_leo

    cmp eax,8
    je personality_virgo

    cmp eax,9
    je personality_libra

    cmp eax,10
    je personality_scorpio

    jmp personality_sagittarius

personality_capricorn:
    mov esi,capPersonality
    jmp print_personality_text

personality_aquarius:
    mov esi,aquPersonality
    jmp print_personality_text

personality_pisces:
    mov esi,pisPersonality
    jmp print_personality_text

personality_aries:
    mov esi,ariPersonality
    jmp print_personality_text

personality_taurus:
    mov esi,tauPersonality
    jmp print_personality_text

personality_gemini:
    mov esi,gemPersonality
    jmp print_personality_text

personality_cancer:
    mov esi,canPersonality
    jmp print_personality_text

personality_leo:
    mov esi,leoPersonality
    jmp print_personality_text

personality_virgo:
    mov esi,virPersonality
    jmp print_personality_text

personality_libra:
    mov esi,libPersonality
    jmp print_personality_text

personality_scorpio:
    mov esi,scoPersonality
    jmp print_personality_text

personality_sagittarius:
    mov esi,sagPersonality

print_personality_text:
    call print_string

    mov esi,newline
    call print_string

    ret


; --------------------------------------------------
; Display menu
; --------------------------------------------------

display_menu:
    mov esi,menu
    call print_string
    ret


; --------------------------------------------------
; Read line
; --------------------------------------------------

read_line:
    mov eax,3
    mov ebx,0
    mov ecx,inputBuffer
    mov edx,127
    int 0x80

    mov edi,inputBuffer

remove_newline:
    mov al,[edi]

    cmp al,0
    je line_done

    cmp al,10
    je clear_character

    cmp al,13
    je clear_character

    inc edi
    jmp remove_newline

clear_character:
    mov byte [edi],0

line_done:
    ret


; --------------------------------------------------
; Convert input to number
; --------------------------------------------------

read_number:
    call read_line

    mov esi,inputBuffer
    xor eax,eax
    xor ebx,ebx

convert_loop:
    mov bl,[esi]

    cmp bl,0
    je number_done

    cmp bl,'0'
    jb number_done

    cmp bl,'9'
    ja number_done

    imul eax,10

    sub bl,'0'
    add eax,ebx

    inc esi
    jmp convert_loop

number_done:
    ret


; --------------------------------------------------
; Copy string
; --------------------------------------------------

copy_string:
copy_loop:
    mov al,[edi]
    mov [esi],al

    inc edi
    inc esi

    cmp al,0
    jne copy_loop

    ret


; --------------------------------------------------
; Print string
; --------------------------------------------------

print_string:
    push esi

    xor edx,edx

string_length:
    cmp byte [esi+edx],0
    je write_string

    inc edx
    jmp string_length

write_string:
    mov eax,4
    mov ebx,1
    mov ecx,esi
    int 0x80

    pop esi
    ret


; --------------------------------------------------
; Print number
; --------------------------------------------------

print_number:
    push eax
    push ebx
    push ecx
    push edx

    cmp eax,0
    jne convert_number

    mov byte [inputBuffer],'0'

    mov eax,4
    mov ebx,1
    mov ecx,inputBuffer
    mov edx,1
    int 0x80

    jmp finish_number

convert_number:
    mov ecx,10
    xor ebx,ebx

divide_number:
    xor edx,edx
    div ecx

    add edx,'0'
    push edx
    inc ebx

    cmp eax,0
    jne divide_number

print_digits:
    pop edx

    mov [inputBuffer],dl

    mov eax,4
    mov ebx,1
    mov ecx,inputBuffer
    mov edx,1
    int 0x80

    dec ebx
    jnz print_digits

finish_number:
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret


; --------------------------------------------------
; Exit program
; --------------------------------------------------

exit_program:
    mov esi,exitMessage
    call print_string

    mov eax,1
    mov ebx,0
    int 0x80