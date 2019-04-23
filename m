From: Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 56/79] docs: Documentation/*.txt: rename all ReST
	files to *.rst
Date: Tue, 23 Apr 2019 17:05:02 -0300
Message-ID: <20190423170409.7b1370ac@coco.lan>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
	<cda57849a6462ccc72dcd360b30068ab6a1021c4.1555938376.git.mchehab+samsung@kernel.org>
	<20190423083135.GA11158@hirez.programming.kicks-ass.net>
	<20190423125519.GA7104@redhat.com>
	<20190423130132.GT4038@hirez.programming.kicks-ass.net>
	<20190423103053.07cf2149@lwn.net>
	<20190423171158.GG12232@hirez.programming.kicks-ass.net>
	<20190423172006.GD16353@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190423172006.GD16353-Jj63ApZU6fQ@public.gmane.org>
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

Em Tue, 23 Apr 2019 19:20:06 +0200
Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> escreveu:

> On Tue, Apr 23, 2019 at 07:11:58PM +0200, Peter Zijlstra wrote:
> > I know I'm an odd duck; but no. They're _less_ accessible for me, as
> > both a reader and author. They look 'funny' when read as a text file
> > (the only way it makes sense to read them; I spend 99% of my time on a
> > computer looking at monospace text interfaces; mutt, vim and console, in
> > that approximate order).  
> 
> +1
> 
> It is probably fine to stare at them here
> https://www.kernel.org/doc/html/latest/ and the end result is good
> for showing them in browsers but after this conversion, it is
> getting more and more painful to work with those files. For example,
> Documentation/x86/x86_64/mm.txt we use a lot. I'd hate it if I had to go
> sort out rest muck first just so that I can read it.

That's my view about how that specific file would be after
converted to ReST:

	https://git.linuxtv.org/mchehab/experimental.git/tree/Documentation/x86/x86_64/mm.rst?h=convert_rst_renames

I don't have any troubles reading/understanding it as a plain text
file, and its html output is also nice (although Sphinx 1.7.8 seems to
have some issues when parsing some cells - probably due to some bug):

	https://www.infradead.org/~mchehab/rst_conversion/x86/x86_64/mm.html

> 
> I think we can simply leave some text files be text files and be done
> with it.

Changbin's approach was somewhat close to what you want. He simply
prepended the tables with ::, in order to show them as plain old
ascii:

	https://lore.kernel.org/lkml/20190423162932.21428-60-changbin.du-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/

Both equally works, from ReST conversion PoV. I'm fine ether way.

I prefer my approach, as, IMHO, it is visually nicer on both text and
html versions, but his approach is likely easier to maintain, as doing
ascii artwork by hand is sometimes painful.

Thanks,
Mauro
