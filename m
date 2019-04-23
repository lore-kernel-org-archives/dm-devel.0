From: Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 56/79] docs: Documentation/*.txt: rename all ReST
	files to *.rst
Date: Tue, 23 Apr 2019 12:07:38 -0300
Message-ID: <20190423120738.3be8337e@coco.lan>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
	<cda57849a6462ccc72dcd360b30068ab6a1021c4.1555938376.git.mchehab+samsung@kernel.org>
	<20190423083135.GA11158@hirez.programming.kicks-ass.net>
	<20190423125519.GA7104@redhat.com>
	<20190423130132.GT4038@hirez.programming.kicks-ass.net>
	<20190423132100.GB7132@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190423132100.GB7132-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Farhan Ali <alifm-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Halil Pasic <pasic-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, openipmi-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nicholas Piggin <npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sean Paul <sean-p7yTbzM4H96eqtR555YLDQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel@vger.k
List-Id: dm-devel.ids

Em Tue, 23 Apr 2019 09:21:00 -0400
Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> escreveu:

> On Tue, Apr 23 2019 at  9:01am -0400,
> Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> > On Tue, Apr 23, 2019 at 08:55:19AM -0400, Mike Snitzer wrote:  
> > > On Tue, Apr 23 2019 at  4:31am -0400,
> > > Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > >   
> > > > On Mon, Apr 22, 2019 at 10:27:45AM -0300, Mauro Carvalho Chehab wrote:
> > > >   
> > > > >  .../{atomic_bitops.txt => atomic_bitops.rst}  |  2 +  
> > > > 
> > > > What's happend to atomic_t.txt, also NAK, I still occationally touch
> > > > these files.  
> > > 
> > > Seems Mauro's point is in the future we need to touch these .rst files
> > > in terms of ReST compatible changes.
> > > 
> > > I'm dreading DM documentation changes in the future.. despite Mauro and
> > > Jon Corbet informing me that ReST is simple, etc.  

ReST is simple[1], and neither Jon or me wants to burden developers to
use complex documents all over the Kernel tree. ReST is just a way to 
make the documents with similar visual. The main advantage of ReST is
that documents can be better organized, as they will be inside some
index.rst file.

[1] Ok, as any document, you could write an easy or hard to read stuff.
The way we're using on most places is to be just a coding style with
benefits. I wrote a quick 101 guide to ReST at the end, with all you
probably need to know about it.

So, for example, in the specific case of atomic_bitops, all it takes for
it to be parsed by Sphinx is to rename it to .rst. With that, it can be
added into an index.rst file, like at Documentation/driver-api/index.rst.

The document, as is, will be displayed like this:

	https://www.infradead.org/~mchehab/rst_conversion/driver-api/atomic_bitops.html?highlight=atomic_t

And the original text file can also be seen from the output data:

	https://www.infradead.org/~mchehab/rst_conversion/_sources/driver-api/atomic_bitops.rst.txt

> > 
> > Well, it _can_ be simple, I've seen examples of rst that were not far
> > from generated HTML contents. And I must give Jon credit for not
> > accepting that atrocious crap.
> > 
> > But yes, I have 0 motivation to learn or abide by rst. It simply doesn't
> > give me anything in return. There is no upside, only worse text files :/  
> 
> Right, but these changes aren't meant for our benefit.  They are for
> users who get cleaner web accessible Linux kernel docs.  Seems the
> decision has been made that the users' benefit, and broader
> modernization of Linux docs, outweighs the inconvenience for engineers
> who maintain the content of said documentation.

> This kind of thing happens a lot these days: pile on engineers, they can
> take it :/

Yes, that's the main goal: ensure that more people will see the
documents and write less crappy code. So, overall, reducing the
time we spent with reviews of bad code.


----

=================================
My 101 ReST quick reference guide
=================================

Basically, a "quick" ReST guide for those that don't want to learn it
and like to have an easy to read text document would be

1) to format documents like:

	=========
	Doc Title
	=========

	foo chapter
	===========

	bar section
	-----------

	foobar sub-section
	^^^^^^^^^^^^^^^^^^

	foobarzeta sub-sub-section
	..........................

(the actual character used to mark the titles can be different,
provided that you use the same character for the same title
level - the above is just the way *I* use, as it makes easier for
me to remember the title level).

2) remember that ReST considers new lines with same indentation as
   belonging to the same paragraph. So,

	foo
	bar

is identical to:

	foo bar

while
	foo
	   bar

will make "foo" bold, and write bar on the next line. So, if you
want to have them on two separate lines on its output, it should
be either write it as:

	foo

	bar

or you could use a list:

	- foo
	- bar

Btw, *a lot* of Kernel documents already have the above format.

3) literal values should be either inside ``foo``, `foo` or on an
   indented line after a ::, like:

	example::

		# some_command_to_be_typed

If you follow those three simple rules, your document will be properly
parsed. The above covers 90% of what we normally use.

Tables are also easy to write there, as it recognizes two ways to write
ascii tables, with are already popular ways to write them.

So, those are valid tables:

Without a title:

	===   ===============
	foo   foo description
	bar   bar description
	===   ===============


	+-------+-----------------+
	| foo   | foo description |
	+-------+-----------------+
	| bar   | bar description |
	+-------+-----------------+

(both will produce exactly the same output)

With a title:

	===== ===============
	field description
	===== ===============
	foo   foo description
	bar   bar description
	===   ===============

	+-------+-----------------+
	| field | description     |
	+=======+=================+
	| foo   | foo description |
	+-------+-----------------+
	| bar   | bar description |
	+-------+-----------------+

(both will produce exactly the same output)

This is not too different on what we usually do on documents - except that
some documents sometimes use UTF8, or a different character set to mark the
table lines. So the "conversion" is simply to follow one of the above
styles.

Thanks,
Mauro
