From: Joe Perches <joe@perches.com>
Subject: [PATCH] scripts/checkpatch.pl: Change long line warning to 105
 chars
Date: Thu, 17 Dec 2009 21:12:24 -0800
Message-ID: <1261113144.13734.317.camel@Joe-Laptop.home>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <20091217061229.GD3946@linux-sh.org> <m3tyvqgfs4.fsf@intrepid.localdomain>
	 <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	 <24653.1261110557@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751145AbZLRFM2@vger.kernel.org>
In-Reply-To: <24653.1261110557@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Valdis.Kletnieks@vt.edu, Andy Whitcroft <apw@canonical.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>, Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 2009-12-17 at 23:29 -0500, Valdis.Kletnieks@vt.edu wrote:
> Yeah, but I respectfully submit that if the regexp '^\t{6}' matches a non-
> continuation line, it's probably in its rights to whinge. 
> 	grep -r -P '^\t{7:}(?!(.*,$|.*\);$))' . | more
> produces a whole lot of "this can't end well" output.

I think this is a good test to add to checkpatch.

Add 105 character long line WARN test
Add 80 character long line STRICT test
Add 6+ leading indent tabs test, consider restructuring

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bc4114f..c358251 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1374,13 +1374,20 @@ sub process {
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-#80 column limit
+#Line too long
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
-		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
-		    $length > 80)
-		{
-			WARN("line over 80 characters\n" . $herecurr);
+		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/) {
+			if ($length > 105) {
+				WARN("line over 105 characters\n" . $herecurr);
+			} elsif ($length > 80) {
+				CHK("line over 80 characters\n" . $herecurr);
+			}
+		}
+
+#too many leading tabs - deep leading indent
+		if ($line =~ /^\+	{6,}(?!(.*,$|.*\);$))/) {
+			CHK("Too many leading tabs.  Consider restructuring code\n" . $herecurr);
 		}
 
 # check for adding lines without a newline.
