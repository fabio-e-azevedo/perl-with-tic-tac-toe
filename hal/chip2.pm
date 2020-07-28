# advanced operations chip

package chip2;
require chip1;

use strict;
use warnings;

use constant SCORE=>'
┌───┬───┬───┐
│ 3 │ 2 │ 3 │
├───┼───┼───┤
│ 2 │ 4 │ 2 │
├───┼───┼───┤
│ 3 │ 2 │ 3 │
└───┴───┴───┘
';

sub get_prob {
   my $game = shift;
   my @nums;
   my %odds;

   while ($game =~ /[1-9]/g) {
      $odds{$&} = substr(SCORE, $-[0], 1);
   }

   @nums = sort { $odds{$b} <=> $odds{$a} } keys %odds;

   return $nums[0];
}

sub win_move {
   my $game = shift;
   my $mark = shift;
   my $tkns = shift;
   my @nums = $game =~ /[1-9]/g;
   my $move;

   TRY: for (@nums) {
      my $num = $_;
      my $try = $game =~ s/$num/$mark/r;
      my $vic = chip1::get_victor $try, $tkns;

      if (defined $vic) {
         $move = $num;
         last TRY;
      }
   }

   return $move;
}

sub hal_move {
   my $game = shift;
   my $mark = shift;
   my @mark = @{ shift; };
   my $move;

   $move = win_move $game, $mark, \@mark;

   if (not defined $move) {
      $mark = ($mark eq $mark[0]) ? $mark[1] : $mark[0];
      $move = win_move $game, $mark, \@mark;
   }

   if (not defined $move) {
      $move = get_prob $game;
   }

   return $move;
}

sub complain {
   print "My mind is going. I can feel it.\n";
}

sub import {
   no strict;
   no warnings;

   my $p = __PACKAGE__;
   my $c = caller;

   *{ $c . '::hal_move' } = \&{ $p . '::hal_move' };
   *{ $c . '::complain' } = \&{ $p . '::complain' };
}

1;
