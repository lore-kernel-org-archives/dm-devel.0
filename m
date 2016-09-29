From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/10] dm snapshot: Use kmalloc_array() in
 init_origin_hash()
Date: Thu, 29 Sep 2016 14:21:22 -0700
Message-ID: <1475184082.1954.5.camel@perches.com>
References: <566ABCD9.1060404@users.sourceforge.net>
         <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
         <3861d349-48fd-162b-a749-83e007f70b41@users.sourceforge.net>
         <1475142864.31297.5.camel@tiscali.nl> <1475143376.1946.2.camel@perches.com>
         <1475147577.31297.11.camel@tiscali.nl>
         <1475149503.31297.14.camel@tiscali.nl>
         <1475161270.2027.5.camel@perches.com>
         <1475178181.31297.21.camel@tiscali.nl>
         <1475180693.1954.1.camel@perches.com>
         <1475181593.31297.25.camel@tiscali.nl>
         <1475182586.1954.3.camel@perches.com>
         <1475183693.31297.36.camel@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1475183693.31297.36.camel@tiscali.nl>
Sender: kernel-janitors-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>, Andy Whitcroft <apw@canonical.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

On Thu, 2016-09-29 at 23:14 +0200, Paul Bolle wrote:
> On Thu, 2016-09-29 at 13:56 -0700, Joe Perches wrote:
> > It doesn't matter match either way to me.
> Why does this stop you fixing an apparently wrong checkpatch rule,
> crude as parts of it are (ie, uppercase identifier must be a constant)?

It doesn't.  It just doesn't matter much (match) to me.
Here:
---
 scripts/checkpatch.pl | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3373c65fef1c..fc931d89152e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5835,8 +5835,8 @@ sub process {
 		if ($^V && $^V ge 5.10.0 &&
 		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
 			my $oldfunc = $3;
-			my $a1 = $4;
-			my $a2 = $10;
+			my $a1 = trim($4);
+			my $a2 = trim($10);
 			my $newfunc = "kmalloc_array";
 			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
 			my $r1 = $a1;
@@ -5850,7 +5850,7 @@ sub process {
 				if (WARN("ALLOC_WITH_MULTIPLY",
 					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
 				    $fix) {
-					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
+					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . $r1 . ', ' . $r2/e;
 
 				}
 			}

