From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Tue, 15 Dec 2009 16:57:49 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Drop 80-character limit in checkpatch.pl

Serious issues:
===============

(1) The code is hard to edit with common text editors
-----------------------------------------------------

For example, let's have this function
struct some_structure *some_function(struct susystem *s, struct s_buffer *b, 
				     unsigned some_number, unsigned some_flags,
				     unsigned long *extra_return_value)

Now, try to make this function static. Or try to add/remove/change some
argument. You end up manually realigning all the arguments. The same problem
happens when editing longer expressions.

This is the most annoying problem with imposed text alignment. If there were
no alignment, you just type "I static SPACE ESC" in vi and get it there
(similarly HOME static SPACE in notepad). If you have to maintain alignment,
the number of keystokes becomes much higher:

			(insert the keyword)
I static SPACE ESC
			(split the second argument)
f , l s ENTER
			(align the second argument)
TAB TAB TAB TAB TAB SPACE SPACE SPACE SPACE ESC
		(see if the third argument fits --- it doesn't, revert it)
J u
			(align the third argument)
j ^ XXXXXX i TAB TAB SPACE SPACE SPACE SPACE ESC
			(split the fourth argument --- it is aligned well)
f , l s ENTER ESC
			(align the fifth argument)
j ^ XXXXXX i TAB TAB SPACE SPACE SPACE SPACE ESC

There are shorter possible sequences using vi keystrokes but the person doing
the editing doesn't always find the optimal way quickly enough, so the actual
editing will look somehow like this.

For emacs, there is a script in CodingStyle to make it conform to the Linux
kernel coding style, but the script only changes tabbing, it does absolutely
nothing with respect to the line width --- with the script loaded, emacs still
doesn't realign the arguments if you add a "static" keyword there.

[ I'm wondering, which editor does the person who invented and supports this
line-wrapping actually use. I suppose none :-) --- it looks like that person
mostly reads the code and tries to make it look aesthetical. ]

(2) Grepping the code is unreliable
-----------------------------------

For example, you see a message "device: some error happened" in syslog.
Now, you grep the kernel with a command (grep -r "some error happened" .) to
find out where it came from. You miss it if the code is formatted like this:
				if (some_error_happened) {
					printk(KERN_ERR "%s: some error "
						"happened", dev->name);
				}
In this case, you usually narrow the search to "error happened" and "some error"
and eventually find it.
Now, the real problem comes, when there are two instance of "some error
happened" message, one is wrapped and the other is not. Here, grep misleads you
to the non-wrapped instance and you are never going to find out that there is
another place where this error could be reported.

Similar grepping problems also exist (less frequently) when grepping the code
--- i.e. Where is the function "bla" called with argument BLA_SOME_FLAG?).
Grep and regular expressions give unreliable results because of 80-line
wrapping.

Less serious issues:
====================

(3) Wrapping wastes space on wide-screen displays
-------------------------------------------------

Obvious. The screen area past column 80 is not used at all.

(4) Wrapping wastes space on small 80x25 display
------------------------------------------------

It is less obvious, but let's see how artifical 80-column wrapping wastes space
on a real 80-column display.

With wrapping: 4 lines:
				struc = some_function(s, buffer, variable +
					get_something(123), FLAG_ONE |
					FLAG_TWO | FLAG_THREE | FLAG_FOUR,
					&extra_ret);

Without wrapping (note that the editor/viewer wraps it automatically at
column 80): 2 lines:
				struc = some_function(sub, buffer, variable + ge
t_something(123), FLAG_ONE | FLAG_TWO | FLAG_THREE | FLAG_FOUR, &extra_ret);

(5) Wrapping makes long expressions harder to understand
--------------------------------------------------------

If I have a complex expression, I do not try to wrap it at predefined
80-column boundaries, but at logical boundaries within the expression to make
it more readable (the brain can't find matching parentheses fast, so we can
help it by aligning the code according to topmost terms in the expression).

Example:
				if (unlikely(call_some_function(s, value) != RET
_SUCCESS) ||
				    (var_1 == prev_var_1 && var_2 == prev_var_2)
 ||
				    flags & (FLAG_1 | FLAG_2) ||
				    some_other_condition) {
				}

Now, if we impose 80-column limit, we get this. One may argue that is looks
aesthetically better, but it is also less intelligible than the previous
version:
				if (unlikely(call_some_function(s, value) !=
				    RET_SUCCESS) || (var_1 == prev_var_1 &&
				    var_2 == prev_var_2) || flags & (FLAG_1 |
				    FLAG_2) || some_other_condition) {
				}

Counter-arguments:
==================

Some people say that 80-column wrapping is imposed so that kernel code is
readable and editable in 80-column text mode.
(for example http://lkml.indiana.edu/hypermail/linux/kernel/0807.2/0010.html)

I personally use 80-column text mode a lot of time, yet I find the artifical
wrapping annoying. The key point is that the editor and viewer wrap the text
automatically at column 80, so there is never any text invisible and there is
no need to wrap it manually.

vi, less, mcview, emacs, grep, pine (*), mutt --- all these will automatically
skip to the next line if some line is longer than terminal width.

(*) pine does this auto-wrapping only in viewer mode, but no one writes code in
pine anyway.

If you rely on this auto-wrapping, you get split words (such as call_some_functi
on()), but I find these split words less annoying than having to manually
realign lines with tabs and spaces each time I edit something.

---

If this 80-column wrapping was only taken as a guidance --- use it or not, as
you like --- there would be little problem with it, because this manual
realigning doesn't annoy anyone but the person who writes the code.

But some maintainers take output of the script checkpatch.pl dogmatically,
requiring that every new work must pass the script without a warning. This is
counterproductive --- if I write a driver and I will be doing most maintenance
work on it in the future, it is viable that the driver is formatted in such
a way that is best editable for me, not for anyone else. And as shown in example
(1), this 80-column requirement makes even simple changes much harder.

So: I am submitting this patch for the checkpatch.pl script.


Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 scripts/checkpatch.pl |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux-2.6.32-devel/scripts/checkpatch.pl
===================================================================
--- linux-2.6.32-devel.orig/scripts/checkpatch.pl	2009-12-07 19:57:31.000000000 +0100
+++ linux-2.6.32-devel/scripts/checkpatch.pl	2009-12-07 19:57:44.000000000 +0100
@@ -1374,15 +1374,6 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
-		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
-		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
-		    $length > 80)
-		{
-			WARN("line over 80 characters\n" . $herecurr);
-		}
-
 # check for adding lines without a newline.
 		if ($line =~ /^\+/ && defined $lines[$linenr] && $lines[$linenr] =~ /^\\ No newline at end of file/) {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
