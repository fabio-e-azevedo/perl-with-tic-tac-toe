# basic operations chip

package chip1;

use strict;
use warnings;

use constant MAGIC=>'
┌───┬───┬───┐
│ 2 │ 9 │ 4 │
├───┼───┼───┤
│ 7 │ 5 │ 3 │
├───┼───┼───┤
│ 6 │ 1 │ 8 │
└───┴───┴───┘
';
 
use List::Util 'sum';
use Algorithm::Combinatorics 'combinations';

sub get_moves {
   my $game = shift;
   my $mark = shift;
   my @nums;

   while ($game =~ /$mark/g) {
      push @nums, substr(MAGIC, $-[0], 1);
   }

   return @nums;
}

sub get_victor {
   my $game = shift;
   my $marks = shift;
   my $victor;

   TEST: for (@$marks) {
      my $mark = $_;
      my @nums = get_moves $game, $mark;

      next unless @nums >= 3;
      for (combinations(\@nums, 3)) {
         my @comb = @$_;
         if (sum(@comb) == 15) {
            $victor = $mark;
            last TEST;
         }
      }
   }

   return $victor;
}

sub hal_move {
   my $game = shift;
   my @nums = $game =~ /[1-9]/g;
   my $rand = int rand @nums;

   return $nums[$rand];
}

sub complain {
   print "Daisy, Daisy, give me your answer do.\n";
}

sub import {
   no strict;
   no warnings;

   my $p = __PACKAGE__;
   my $c = caller;

   *{ $c . '::get_victor' } = \&{ $p . '::get_victor' };
   *{ $c . '::hal_move' } = \&{ $p . '::hal_move' };
   *{ $c . '::complain' } = \&{ $p . '::complain' };
}

1;
