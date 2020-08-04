Function Get-WindowsArt()
{
    [string[]] $ArtArray  =
            "                         ....::::       ",
            "                 ....::::::::::::       ",
            "        ....:::: ::::::::::::::::       ",
            "....:::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            "................ ................       ",
            ":::::::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            ":::::::::::::::: ::::::::::::::::       ",
            "'''':::::::::::: ::::::::::::::::       ",
            "        '''':::: ::::::::::::::::       ",
            "                 ''''::::::::::::       ",
            "                         ''''::::       ",
            "                                        ",
            "                                        ",
            "                                        ";
    
    return $ArtArray;
}

Function Get-MacArt()
{
    [string[]] $ArtArray = 
            "                 -/+:.                  ",
            "                :++++.                  ",
            "               /+++/.                   ",
            "       .:-::- .+/:-\`\`.::-               ",
            "    .:/++++++/::::/++++++/:\`            ",
            "  .:///////////////////////:\`           ",
            "  ////////////////////////\`             ",
            " -+++++++++++++++++++++++\`              ",
            " /++++++++++++++++++++++/               ",
            " /sssssssssssssssssssssss.              ",
            " :ssssssssssssssssssssssss-             ",
            "  osssssssssssssssssssssssso/\`          ",
            "  \`syyyyyyyyyyyyyyyyyyyyyyyy+\`          ",
            "   \`ossssssssssssssssssssss/            ",
            "     :ooooooooooooooooooo+.             ",
            "      \`:+oo+/:-..-:/+o+/-               ",
            "                                        ",
            "                                        ",
            "                                        ",
            "                                        ";

    return $ArtArray;    
}

# Old windows logo from WinScreeny by Nijikokun:
# https://github.com/Nijikokun/WinScreeny
Function Get-OldWindowsArt() 
{
    $esc = [char]27
    $f1 = "$esc[31m"
    $f2 = "$esc[32m"
    $f3 = "$esc[34m"
    $f4 = "$esc[33m"
    [string[]] $ArtArray =
    "$f1         ,.=:^!^!t3Z3z.,                ",
    "$f1        :tt:::tt333EE3                  ",
    "$f1        Et:::ztt33EEE  $f2@Ee.,      ..,   ",
    "$f1       ;tt:::tt333EE7 $f2;EEEEEEttttt33#   ",
    "$f1      :Et:::zt333EEQ.$f2 SEEEEEttttt33QL   ",
    "$f1      it::::tt333EEF $f2@EEEEEEttttt33F    ",
    "$f1     ;3=*^``````'*4EEV $f2`:EEEEEEttttt33@.    ",
    "$f4     ,.=::::it=., $f1`` $f2@EEEEEEtttz33QF     ",
    "$f4    ;::::::::zt33)   $f2'4EEEtttji3P*      ",
    "$f4   :t::::::::tt33.$f3`:Z3z..  $f2```` $f3,..g.      ",
    "$f4   i::::::::zt33F$f3 AEEEtttt::::ztF       ",
    "$f4  ;:::::::::t33V $f3;EEEttttt::::t3        ",
    "$f4  E::::::::zt33L $f3@EEEtttt::::z3F        ",
    "$f4 {3=*^``````'*4E3) $f3;EEEtttt:::::tZ``        ",
    "$f4             `` $f3`:EEEEtttt::::z7          ",
    "$f3                 $f3'VEzjt:;;z>*``          "
    

    return $ArtArray;
}