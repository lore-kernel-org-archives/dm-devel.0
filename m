From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 08/35] libmultipath: create bitfield
	abstraction
Date: Tue, 04 Aug 2020 17:04:50 +0200
Message-ID: <2ae4b38b8f07eb1ac9be31099b5be091fa6e9617.camel@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
	<20200709101620.6786-9-mwilck@suse.com>
	<20200716211708.GM11089@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200716211708.GM11089@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 2020-07-16 at 16:17 -0500, Benjamin Marzinski wrote:
> On Thu, Jul 09, 2020 at 12:15:53PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > In e32d521d ("libmultipath: coalesce_paths: fix size mismatch
> > handling"),
> > we introduced simple bitmap handling functions. We can do better.
> > This
> > patch introduces a bitfield type with overflow detection and a
> > find_first_set() method.
> > 
> > Use this in coalesce_paths(), and adapt the unit tests. Also, add
> > unit tests for "odd" bitfield sizes; so far we tested only
> > multiples
> > of 64.
> > 
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> >  libmultipath/configure.c |   9 +-
> >  libmultipath/util.c      |  35 ++++++
> >  libmultipath/util.h      |  57 ++++++++-
> >  tests/util.c             | 263
> > +++++++++++++++++++++++++++++++++++----
> >  4 files changed, 327 insertions(+), 37 deletions(-)
> > 
> > ...
> > diff --git a/libmultipath/util.c b/libmultipath/util.c
> > index 3c43f28..46cacd4 100644
> > --- a/libmultipath/util.c
> > +++ b/libmultipath/util.c
> > @@ -404,3 +404,38 @@ void close_fd(void *arg)
> >  {
> >  	close((long)arg);
> >  }
> > +
> > +struct bitfield *alloc_bitfield(unsigned int maxbit)
> > +{
> > +	unsigned int n;
> > +	struct bitfield *bf;
> > +
> > +	n = maxbit > 0 ? (maxbit - 1) / bits_per_slot + 1 : 0;
> 
> What's the point in accepting 0? That's an empty bitmap.
> 
> > +	bf = calloc(1, sizeof(struct bitfield) + n *
> > sizeof(bitfield_t));
> 
> Need to check that bf got set before dereferencing it.

Thanks for spotting these, I will fix them.

> 
> > +	bf->len = maxbit;
> > +	return bf;
> > +}
> > +
> > +void _log_bitfield_overflow(const char *f, unsigned int bit,
> > unsigned int len)
> > +{
> > +	condlog(0, "%s: bitfield overflow: %u >= %u", f, bit, len);
> > +}
> > +
> > +unsigned int find_first_set(const struct bitfield *bf)
> > +{
> > +	unsigned int b = 0, i, n;
> > +
> > +	for (i = 0; i < bf->len; i+= bits_per_slot) {
> > +		b = _ffs(bf->bits[i / bits_per_slot]);
> > +		if (b != 0)
> > +			break;
> > +	};
> > +	if (b == 0)
> > +		return 0;
> > +
> > +	n = i + b;
> > +	if (n <= bf->len)
> > +		return n;
> > +
> > +	return 0;
> > +}
> 
> This is neat and all, but what's it for?  I didn't see it used in the
> rest of the patches.  Did I miss it, or do you have a future use for
> it?

Got me :-) I first thought we had a use for it. I can rip it out if you
prefer, saving a local copy in case we need it in the future. 

Martin
