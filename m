From: Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 56/79] docs: Documentation/*.txt: rename all ReST
	files to *.rst
Date: Wed, 24 Apr 2019 07:40:07 -0300
Message-ID: <20190423232325.679c100b@coco.lan>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
	<cda57849a6462ccc72dcd360b30068ab6a1021c4.1555938376.git.mchehab+samsung@kernel.org>
	<20190423083135.GA11158@hirez.programming.kicks-ass.net>
	<20190423125519.GA7104@redhat.com>
	<20190423130132.GT4038@hirez.programming.kicks-ass.net>
	<20190423103053.07cf2149@lwn.net>
	<20190423171158.GG12232@hirez.programming.kicks-ass.net>
	<20190423172006.GD16353@zn.tnic> <20190423170409.7b1370ac@coco.lan>
	<20190423213816.GE16353@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190423213816.GE16353-Jj63ApZU6fQ@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Farhan Ali <alifm-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Halil Pasic <pasic-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, openipmi-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nicholas Piggin <npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sean Paul <sean-p7yTbzM4H96eqtR555YLDQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-wireless@v
List-Id: dm-devel.ids

Em Tue, 23 Apr 2019 23:38:16 +0200
Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> escreveu:

> On Tue, Apr 23, 2019 at 05:05:02PM -0300, Mauro Carvalho Chehab wrote:
> > That's my view about how that specific file would be after
> > converted to ReST:
> > 
> > 	https://git.linuxtv.org/mchehab/experimental.git/tree/Documentation/x86/x86_64/mm.rst?h=convert_rst_renames
> > 
> > I don't have any troubles reading/understanding it as a plain text
> > file,  
> 
> If that is all the changes it would need, then I guess that's ok. Btw,
> those rst-conversion patches don't really show what got changed. Dunno
> if git can even show that properly. I diffed the two files by hand to
> see what got changed, see end of mail.

Well, you can use git show -M01 and it will likely show what
changed. The thing is that plain diff is not very good showing
diffs on text files. I suspect that using some tool like wdiff
would give a better view of such changes.

> So I guess if table in rst means, one needs to draw rows and columns, I
> guess that's ok. It's not like I have to do it every day.

Yes, for complex tables, one needs to draw rows/columns. For simple
tables, all you need to do is something like:

  ====== ========   ====    ========    ===
  -      CONT PTE    PMD    CONT PMD    PUD
  ====== ========   ====    ========    ===
  4K:         64K     2M         32M     1G
  16K:         2M    32M          1G
  64K:         2M   512M         16G
  ====== ========   ====    ========    ===

in order to teach Sphinx where each column starts/stops, and
(optionally) show the table titles in bold.

(that's from Documentation/arm64/hugetlbpage.rst conversion)

> But exactly this - *having* to do rst formatting would mean a lot of
> getting used to and people writing something which is not necessarily
> correct rst and someone else fixing up after them.

Yeah, one has to take the conversion effort, but once done, it should be
easy to keep it updated.

> > and its html output is also nice (although Sphinx 1.7.8 seems to
> > have some issues when parsing some cells - probably due to some bug):
> > 
> > 	https://www.infradead.org/~mchehab/rst_conversion/x86/x86_64/mm.html  
> 
> I don't know how that looks in your browser but in mine those addresses
> are not in monospaced font and there's no properly reading them.
> 
> And yap, the cells parsing fun I see too.

Font selection is one of the things would require some markup, as a
plain text file doesn't have font changes.

There are several ways to make it use a monospaced font.

The straight forward way would be to place everything that it is
monospaced inside ``double quotes``, with is the ReST way to mark
a literal block inside a text. IMHO, that would add too much
"noise" at the tables.

Another possibility would be to do:

	.. raw:: html

	       <head><style>td { font-family: monospace, monospace; }</style></head>

(the double monospace here is not a mistake - it is due to a known
bug^H^H^Hfeature on some browsers[1])

[1] https://stackoverflow.com/questions/38781089/font-family-monospace-monospace

IMO, the best alternative would be to add a new class to the css file,
and use it whenever we need a table with monospaced font, e. g.:

diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
index e21e36cd6761..0948de6651f8 100644
--- a/Documentation/sphinx-static/theme_overrides.css
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -125,3 +125,7 @@ div[class^="highlight"] pre {
         color: inherit;
     }
 }
+
+table.monospaced {
+	font-family: monospace, monospace;
+}
diff --git a/Documentation/x86/x86_64/mm.rst b/Documentation/x86/x86_64/mm.rst
index e8a92fa0f9b2..704bad5c5130 100644
--- a/Documentation/x86/x86_64/mm.rst
+++ b/Documentation/x86/x86_64/mm.rst
@@ -18,6 +18,8 @@ Notes:
    notation than "16 EB", which few will recognize at first sight as 16 exabytes.
    It also shows it nicely how incredibly large 64-bit address space is.
 
+.. cssclass:: monospaced
+
 +-----------------+------------+------------------+---------+-----------------------------------------------------------+
 |   Start addr    |   Offset   |     End addr     |  Size   | VM area description                                       |
 +=================+============+==================+=========+===========================================================+

(patch on the top of this tree
https://git.linuxtv.org/mchehab/experimental.git/tree/Documentation/x86/x86_64/mm.rst?h=convert_rst_renames)

The ..cssclass:: markup on the above example will be applied just to
the table below it. So, with that, it is possible to have normal and
monospaced tables mixed (if you apply the above patch, you'll see
that just the first table will use monospaced fonts).

- 

Personally, I don't care much with monospaced fonts on this table. After
all, if I want to see it monospaced, I can simply click at the
"View page source" at the browser, and it will display the file as a
plain old monospaced text file.

Thanks,
Mauro
