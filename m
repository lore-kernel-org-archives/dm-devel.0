From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Tue, 15 Dec 2009 23:26:34 +0100
Message-ID: <200912152326.34728.bzolnier@gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tuesday 15 December 2009 10:57:49 pm Mikulas Patocka wrote:

> But some maintainers take output of the script checkpatch.pl dogmatically,
> requiring that every new work must pass the script without a warning. This is
> counterproductive --- if I write a driver and I will be doing most maintenance
> work on it in the future, it is viable that the driver is formatted in such
> a way that is best editable for me, not for anyone else. And as shown in example
> (1), this 80-column requirement makes even simple changes much harder.

It has been agreed in the past that 80-column warnings shouldn't result
automatically in the rejection of the new hardware support so the above
argumentation is a bit weak.

> So: I am submitting this patch for the checkpatch.pl script.
> 
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Having this limitation makes people at least think about designing their
code properly and making it more compact.

If you don't want to see such warnings just apply the following patch that
I've been keeping locally (it helped me to work on staging drivers):

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] checkpatch.pl: add option to disable 80 column limit check

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 scripts/checkpatch.pl |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: b/scripts/checkpatch.pl
===================================================================
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -17,6 +17,7 @@ use Getopt::Long qw(:config no_auto_abbr
 my $quiet = 0;
 my $tree = 1;
 my $chk_signoff = 1;
+my $chk_cl = 1;
 my $chk_patch = 1;
 my $tst_only;
 my $emacs = 0;
@@ -41,6 +42,7 @@ Options:
   -q, --quiet                quiet
   --no-tree                  run without a kernel tree
   --no-signoff               do not check for 'Signed-off-by' line
+  --no-cl                    do not apply 80 column limit
   --patch                    treat FILE as patchfile (default)
   --emacs                    emacs compile window format
   --terse                    one line per report
@@ -67,6 +69,7 @@ GetOptions(
 	'q|quiet+'	=> \$quiet,
 	'tree!'		=> \$tree,
 	'signoff!'	=> \$chk_signoff,
+	'cl!'		=> \$chk_cl,
 	'patch!'	=> \$chk_patch,
 	'emacs!'	=> \$emacs,
 	'terse!'	=> \$terse,
@@ -1365,7 +1368,7 @@ sub process {
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
 #80 column limit
-		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
+		if ($chk_cl && $line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
 		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
 		    $length > 80)
