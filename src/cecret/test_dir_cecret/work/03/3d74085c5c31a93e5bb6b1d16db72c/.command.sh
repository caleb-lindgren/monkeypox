#!/bin/bash -ue
mkdir -p fasta_prep

echo ">MPXV_reference" > fasta_prep/MPXV_reference.fasta
grep -v ">" MPXV_reference.fasta | fold -w 75 >> fasta_prep/MPXV_reference.fasta

num_N=$(grep -v ">" MPXV_reference.fasta | grep -o 'N' | wc -l )
num_ACTG=$(grep -v ">" MPXV_reference.fasta | grep -o -E "C|A|T|G" | wc -l )
num_degenerate=$(grep -v ">" MPXV_reference.fasta | grep -o -E "B|D|E|F|H|I|J|K|L|M|O|P|Q|R|S|U|V|W|X|Y|Z" | wc -l )
first_line=$(grep ">" consensus/MPXV_reference.consensus.fa | sed 's/>//g' )
num_total=$(( $num_N + $num_degenerate + $num_ACTG ))

if [ -z "$num_N" ] ; then num_N="0" ; fi
if [ -z "$num_ACTG" ] ; then num_ACTG="0" ; fi
if [ -z "$num_degenerate" ] ; then num_degenerate="0" ; fi
if [ -z "$first_line" ] ; then first_line=MPXV_reference ; fi
if [ -z "$num_total" ] ; then num_total=0 ; fi

# capture process environment
set +u
echo num_N=${num_N[@]} > .command.env
echo num_ACTG=${num_ACTG[@]} >> .command.env
echo num_degenerate=${num_degenerate[@]} >> .command.env
echo num_total=${num_total[@]} >> .command.env
echo first_line=${first_line[@]} >> .command.env
