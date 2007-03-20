#=====================================================================
# LX-Office ERP
# Copyright (C) 2004
# Based on SQL-Ledger Version 2.1.9
# Web http://www.lx-office.org
#
#=====================================================================
# SQL-Ledger Accounting
# Copyright (C) 2001
#
#  Author: Dieter Simader
#   Email: dsimader@sql-ledger.org
#     Web: http://www.sql-ledger.org
#
#  Contributors:
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#=====================================================================
#
# this is the default code for the Check package
#
#=====================================================================

sub init {
  my $self = shift;

  %{ $self->{numbername} } = (0      => 'Zero',
                              1      => 'One',
                              2      => 'Two',
                              3      => 'Three',
                              4      => 'Four',
                              5      => 'Five',
                              6      => 'Six',
                              7      => 'Seven',
                              8      => 'Eight',
                              9      => 'Nine',
                              10     => 'Ten',
                              11     => 'Eleven',
                              12     => 'Twelve',
                              13     => 'Thirteen',
                              14     => 'Fourteen',
                              15     => 'Fifteen',
                              16     => 'Sixteen',
                              17     => 'Seventeen',
                              18     => 'Eighteen',
                              19     => 'Nineteen',
                              20     => 'Twenty',
                              30     => 'Thirty',
                              40     => 'Forty',
                              50     => 'Fifty',
                              60     => 'Sixty',
                              70     => 'Seventy',
                              80     => 'Eighty',
                              90     => 'Ninety',
                              10**2  => 'Hundred',
                              10**3  => 'Thousand',
                              10**6  => 'Million',
                              10**9  => 'Billion',
                              10**12 => 'Trillion',);

}

sub num2text {
  my ($self, $amount) = @_;

  return $self->{numbername}{0} unless $amount;

  my @textnumber = ();

  # split amount into chunks of 3
  my @num = reverse split //, $amount;
  my @numblock = ();
  my @a;
  my $i;

  while (@num) {
    @a = ();
    for (1..3) {
      push(@a, shift(@num));
    }
    push(@numblock, join(" ", reverse @a));
  }

  while (@numblock) {

    $i   = $#numblock;
    @num = split(//, $numblock[$i]);

    if ($numblock[$i] == 0) {
      pop @numblock;
      next;
    }

    if ($numblock[$i] > 99) {

      # the one from hundreds
      push(@textnumber, $self->{numbername}{ $num[0] });

      # add hundred designation
      push(@textnumber, $self->{numbername}{ 10**2 });

      # reduce numblock
      $numblock[$i] -= $num[0] * 100;

    }

    $numblock[$i] *= 1;

    if ($numblock[$i] > 9) {

      # tens
      push(@textnumber, $self->format_ten($numblock[$i]));
    } elsif ($numblock[$i] > 0) {

      # ones
      push(@textnumber, $self->{numbername}{ $numblock[$i] });
    }

    # add thousand, million
    if ($i) {
      $num = 10**($i * 3);
      push(@textnumber, $self->{numbername}{$num});
    }

    pop(@numblock);

  }

  join(' ', @textnumber);

}

sub format_ten {
  my ($self, $amount) = @_;

  my $textnumber = "";
  my @num        = split(//, $amount);

  if ($amount > 20) {
    $textnumber = $self->{numbername}{ $num[0] * 10 };
    $amount     = $num[1];
  } else {
    $textnumber = $self->{numbername}{$amount};
    $amount     = 0;
  }

  $textnumber .= " " . $self->{numbername}{$amount} if $amount;

  $textnumber;

}

1;

