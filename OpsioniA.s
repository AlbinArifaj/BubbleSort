.globl main
.data
array: .space 20 #Nje array e cila mban 5 shifra

msg: .asciiz "Jep numrin e antareve te Vektorit MAX(5):"
msg1: .asciiz "Shtyp Elementet nje nga nje:"
msg2: .asciiz "Vlera E Vektorit ne Fund:"
newLine: .asciiz "\n"

.text

main:
    
    jal populloVektorin
    move $a0,$v0
    jal unazaKalimit
    li $v0 ,10
    syscall

populloVektorin:
    addi $sp, $sp ,12                 # allokim te memories ne stack.
    sw $ra , 0($sp)                   # ruajtja e adrese ne poziten ku gjendet stack pointer
    sw $a0, 4($sp)                    # ruajtja e vleres ne poziten ku gjendet stack pointer + 4
    sw $s0, 8($sp)                    # ruajtja e vleres ne poziten ku gjendet stack pointer + 8

loopPerN:
    
    # komanden MIPS per printim te String
    li $v0, 4                          
    la $a0,msg                        
    syscall

    # komanden MIPS per printim te String
    li $v0, 4
    la $a0, newLine
    syscall

    # vleren e (n) nga console
    li ,$v0, 5                        
    syscall

    bge $v0, 1 elseForMaMadhe0        # nese vlera ne $v0 ma e madhe se 0 vazhdo te label:elseForMaMadhe0 nese jo vetem vazhdo  
    j loopPerN                        # kthehem te loopPerN
    elseForMaMadhe0:
    

    ble $v0, 5 elseForMaMadhe5        # nese vlera ne $v0 ma e madhe se 5 vazhdo te label:elseForMaMadhe5 nese jo vetem vazhdo  
    j loopPerN                        # kthehem te loopPerN
    elseForMaMadhe5:
    

    move $s0,$v0                      # vlera e v0 qe eshte qe eshte jepur nga konzola duke e levizure ne temporary regjister

    #jemi duke printuar vleren e mesazhit 1
    li, $v0, 4                        
    la, $a0, msg1
    syscall 

    
    # komanden MIPS per printim te String
    li $v0, 4
    la $a0, newLine
    syscall

    addi $t6, $t6,4                   # vendosje te vleres 4 ne $t6 
    li $t0 , 0                        # duke e incializura $t0 ne zero
    mul $s0, $s0, $t6                 # $s0 shumzim me 4 pasi qe int jane 4 bit


    loop:
        slt $t4, $t0,$s0              # nese $t0<$s0 , $t4 ndezet(1), në qofte se jo $t4 rrin e fikur(0)
        beq $t4, $zero, else          # ne qofte se $t4 = 0 shko te label:else në qofte se jo vazhdo

        #jemi duke e shtuar nje vlere nga consola
        li ,$v0, 5                    
        syscall

        sw $v0, array($t0)            # vleren e shtuar nga consola e vendosim ne array
        addi $t0 ,$t0,4               # mbledhje të $t0 me 4 

        j loop;                       # kthim te loop
        else:
        move $v0, $s0                 # vleren e $s0 pe vendosim ne $v0
        lw $ra, 0($sp)                # return address $ra ne gjendjen fillestare 
        lw $a0, 4($sp)                # argumentin $a0 ne gjendjen fillestare
        lw $s0, 8($sp)                # regjistrin $s0 ne gjendjen fillestare
        addi $sp, $sp, 12             # deallokim te memories ne stack

        jr $ra
        

unazaKalimit:

    addi $sp , $sp ,-8                # allokim te memories ne stack
    sw $ra , 0($sp)                   # ruajtje e adrese ne poziten ku gjendet stack pointer
    sw $a0, 4($sp)                    # ruajtje e vleres ne poziten ku gjendet stack pointer +4

    move $s0,$v0                      # vleren e $v0 e vendosim ne $s0
    addi $s3, $s0,-4                  # ne regjistrin $s3 pe vendosim vleren $s0(n)-4
   
    addi $t1,$t1,0                    # vendosje te regjistrit $t1(p) ne zero 
    secondLoop:
        slt $s8,$t1,$s3               # në qoftë se $t1(p)<$s3(n-1), $s8 ndezet
        beq $s8, $zero , secondElse   # në qoftë se $s8 eshte e fikur shko te label:secondElse , nese jo vazhdo
        lw $s1, array($t1)            # vleren ne e array ne poziten $t0 dhe e vendosim në $s1
        addi $s2, $t1, 0              # në $s2 vendosim vleren e $t1

        move $a0, $t1                 # vendosim $t1 në $a0
        move $a1, $s1                 # vendosim $s1 në $a1
        move $a2, $s2                 # vendosim $s2 në $a2
        move $a3, $s0                 # vendosim $s0 në $a3
        jal unazaVlerave              # levizim te procedura unazaVlerave
        
        lw $t3, array($t1)            # vendosim në $t3(temp) vleren e array ne poziten $t1(p)
        lw $t8, array($s2)            # vendosim në $t8 vleren e array ne poziten $s2(loc) 
        sw $t8, array($t1)            # vendosim ne array ne poziten $t1(p) vleren e $t8
        sw $t3, array($s2)            # vendosim në array ne poziten $s2 vleren e $t3(temp) 
        
        addi $t1, $t1,4               # mbledhim regjistrin $t1(p) me +4
        j secondLoop;                 # po shkojme te secondLopp

        secondElse:

        # komanden MIPS per printim te String
        li $v0, 4                       
        la $a0,msg2                     
        syscall

        # komanden MIPS per printim te String
        addi $v0,$zero , 4             
        la $a0 , newLine
        syscall

        

        li $t0 ,0                      # ne regjistrin $t0(i) vendosim ne 0
        fourthLoop:                    
        slt $s6, $t0,$s0               # në qoftë se $t0(i)<$s0(n), $s6 ndezet (1), nëse jo fikekt (0)
        beq $s6 , $zero, fourthElse    # në qoftë se $s6 e fikur (0) dalim nga loop 
        lw $s4, array($t0)             # vleren e array në pozite $t0(i) vendosim në $s4

        # komanda ne MIPS per printim te int
        li $v0 ,1                       
        move $a0, $s4
        syscall

        # komanden MIPS per printim te String
        li $v0, 4
        la $a0, newLine
        syscall

        addi $t0, $t0, 4                # mbledhim regjistrin $t0 me +4
        j fourthLoop                    # po shkojme te fourthLoo[]
        fourthElse:

        lw $ra ,0($sp)                  # return address $ra ne gjendjen fillestare
        lw $a0, 4($sp)                  # argumentin $a0 ne gjendjen fillestare
        addi $sp, $sp, 4                # deallokojm memorien në stack
        jr $ra                           



unazaVlerave:
        addi $sp,$sp ,-20                 # allokojm memorie ne stack
        sw $ra,0($sp)                     # ruajtja e adrese ne poziten ku gjendet stack pointer
        sw $a0,4($sp)                     # ruajtja e argumentit $a0 ne poziten ku gjendet stack pointer +4
        sw $a1,8($sp)                     # ruajtja e argumentit $a1 ne poziten ku gjendet stack pointer +8
        sw $a2,12($sp)                    # ruajtja e argumentit $a2 ne poziten ku gjendet stack pointer +12
        sw $s0,16($sp)                    # ruajtja e regjistirn temporary $s0 ne poziten ku gjendet stack pointer +16

        
        move $t1,$a0                      # vendosim vleren e argumentit $a0 ne $t1
        move $s1,$a1                      # vendosim vleren e argumentit $a1 ne $s1
        move $s2,$a2                      # vendosim vleren e argumentit $a2 ne $s2
        move $s0,$a3                      # vendosim vleren e argumentit $a3 ne $s0

        addi $t2, $t1, 0                  # vendosim vleren $t1 ne $2 

        thirdLoop:
            slt $t5, $t2 , $s0            # në qoftë se $t2(k)<$s0(n), ndezime $t5 on ne qofte se jo off 
            beq $t5, $zero ,thirdElse     # në qofte se $t5 eshte zero nuk eshte e ndezur shkojm te thirdElse
            lw $t9, array($t2)            # në $t9 vendosim vleren e array ne pozite $t2 
    
            sge $s7, $s1, $t9             # në qoftë se $s1(min)<$t9(a[k]) atëhere $s7 ndezet, në qofte se jo fiket
            beq $s7, $zero,loopMin        # në qoftë se $s7 e barabarte me 0 atëher dalim nga thirdLoop

            add $s1 , $t9, $zero          # vendosim ne $s1(min) vlerën e $t9(a[k])
            move $s2, $t2,                # vendosim ne $s2(loc) vlerën e $t2(k)
            addi $t2,$t2 ,4               # mbledhim regjistrin $t2(k) me +4
        j thirdLoop;

    loopMin:

    addi $t2,$t2 ,4                     # mbledhim regjistrin $t2(k) me +4
    j thirdLoop;                        # po shkojme te thirdLoop

    thirdElse:
    lw $ra , 0($sp)                     # return address $ra ne gjendjen fillestare
    lw $a0 , 4($sp)                     # argumentin $a0 ne gjendjen fillestare
    lw $a1 , 8($sp)                     # argumentin $a1 ne gjendjen fillestare
    lw $a2 , 12($sp)                    # argumentin $a2 ne gjendjen fillestare
    lw $a3 , 16($sp)                    # argumentin $a3 ne gjendjen fillestare
    addi $sp, $sp , 20                  # deallokim te memories ne stack
    jr $ra                              
   
    
