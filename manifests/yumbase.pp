class zeg::yumbase {
package { ['screen', 'git', 'wget', 'bzip2', 'telnet', 'initscripts', 'fontconfig', 'freetype', 'urw-fonts', 'dejavu-fonts-common', 'dejavu-sans-fonts', 'fontpackages-filesystem', 'libfontenc', 'xorg-x11-font-utils', 'bash-completion', 'vim', 'liberation-fonts-common', 'liberation-mono-fonts', 'liberation-narrow-fonts', 'liberation-sans-fonts', 'liberation-serif-fonts',    ]:
ensure => installed,
}



}
