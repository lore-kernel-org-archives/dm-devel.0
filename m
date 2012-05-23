From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Bcache v13 12/16] bcache: Bset code (lookups within a btree
 node)
Date: Wed, 23 May 2012 10:55:44 -0700
Message-ID: <20120523175544.GC18143@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <5b5998d7d09ec36377acdb5d15665d1e4e818521.1336619038.git.koverstreet@google.com>
 <20120522223932.GK14339@google.com>
 <20120523042114.GC607@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120523042114.GC607-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Wed, May 23, 2012 at 12:21:14AM -0400, Kent Overstreet wrote:
> > > +/* I have no idea why this code works... and I'm the one who wrote it

Ooh, BTW, the preferred multiline comment format is fully winged one -

/*
 * blah blah.
 * blah blah.
 */

> > > + *
> > > + * However, I do know what it does:
> > > + * Given a binary tree constructed in an array (i.e. how you normally implement
> > > + * a heap), it converts a node in the tree - referenced by array index - to the
> > > + * index it would have if you did an inorder traversal.
> > > + *
> > > + * The binary tree starts at array index 1, not 0
> > > + * extra is a function of size:
> > > + *   extra = (size - rounddown_pow_of_two(size - 1)) << 1;
> > > + */
> > 
> > It's kinda problematic if you can't understand or explain it.  I'm
> > scared.  :(
> 
> Hehe. I spent several days staring at pictures of binary trees, then
> staring at integers in binary from my code doing inorder travels until
> eventually I saw the pattern. Never figured out the math behind it.
> 
> But I did test every j for every binary tree up to size somewhere around
> 6 million. I suppose I'll mention that in the comment.

How useful is this?  Any chance we can use something simpler (or
understandable at least)?

> > > +__attribute__((optimize(3)))
> > 
> > So, this sets different optimization level per function.  Is this
> > really necessary?  If so, you need to make compiler independent in
> > include/linux/compiler*.h.
> 
> The bset_search_*() functions are definitely hot enough to justify it,
> but I can't remember if I ever checked whether that attribute made a
> difference.

Let's drop it for now.  -O3 is different from -O2 but not necessarily
better.

> > > +	start_time = local_clock();
> > > +
> > > +	btree_mergesort(b, out, iter, fixup, remove_stale);
> > > +	b->nsets = start;
> > > +
> > > +	if (!fixup && !start && b->written)
> > > +		btree_verify(b, out);
> > > +
> > > +	if (!start && order == b->page_order) {
> > > +		out->magic	= bset_magic(b->c);
> > > +		out->seq	= b->sets[0].data->seq;
> > > +		out->version	= b->sets[0].data->version;
> > > +		swap(out, b->sets[0].data);
> > > +
> > > +		if (b->c->sort == b->sets[0].data)
> > > +			b->c->sort = out;
> > > +	} else {
> > > +		b->sets[start].data->keys = out->keys;
> > > +		memcpy(b->sets[start].data->start, out->start,
> > > +		       (void *) end(out) - (void *) out->start);
> > > +	}
> > > +
> > > +	if (out == b->c->sort)
> > 
> > And is this test correct given the above swap(out, b->sets[0].data)?
> 
> Yes. It's difficult to read but I think it's just as bad if the check is
> before the swap(). It's avoiding a memcpy() and just swapping buffers
> when possible - I added a comment to that effect.

Ah, okay, if (b->c->sort == b->sets[0].data) updates b->c->sort to
match the swap.  Wouldn't it be easier to read if it did something
like following?

	bool using_backup;	// or whatever better name you can think of

	out = alloc;
	if (!out) {
		lock;
		....
		using_backup = true;
	}

	Do whatever;

	if (using_backup) {
		/* explain that @out may have changed */
		b->c->sort = out;
		unlock;
	} else {
		free;
	}

It would also be nicer to not do operations which may fail during var
decl.

> > > +#define BSET_CACHELINE		128
> > > +#define BSET_CACHELINE_BITS	ilog2(BSET_CACHELINE)
> > 
> > Hmm... what if CACHELINE isn't 128 bytes?  What are the effects?
> > Wouldn't it be better to name it something else (I don't know,
> > BSET_UNIT_BYTES or whatever) and then explain that it's defined to be
> > close to popular cacheline size and the effects of it not coinciding
> > with actual cacheline size? 
> 
> It's poorly named, yeah. Nothing bad happens if it's not the same size
> as hardware cachelines (as it's not now) - it used to be 64, but I
> realized the lookup code would touch slightly less memory if it was 128.
> 
> What it's defining is the number of bytes per bset_float, if you missed
> that - when we're done searching the bset_float tree we have this many
> bytes left that we do a linear search over.
> 
> Since (after level 5, if my math is right) every level of the bset_tree
> is on a new cacheline, we're touching one fewer cacheline in the bset
> tree in exchange for one more cacheline in the linear search - but the
> linear search might stop before it gets to the second cacheline.

How much benefit are we gaining by doing this float thing?  Any chance
we can do something simpler?  As long as it's properly encapsulated,
it shouldn't be too bad but I keep having the suspicion that a lot of
complexity is added for unnecessary level of optimization.

> > > +void bset_init_next(struct btree *);
> > > +
> > > +void bset_fix_invalidated_key(struct btree *, struct bkey *);
> > > +void bset_fix_lookup_table(struct btree *, struct bkey *);
> > > +
> > > +struct bkey *__bset_search(struct btree *, struct bset_tree *,
> > > +			   const struct bkey *);
> > > +#define bset_search(b, t, search)				\
> > > +	((search) ? __bset_search(b, t, search) : (t)->data->start)
> > 
> > Why oh why is this a macro? 
> 
> No particular reason. I don't care one way or the other about these one
> line wrappers, but I'll switch it to a static inline function if you
> prefer.

In general, functions are preferable unless there are specific reasons
to use macros like mucking with types.

> > And can we please have descriptive
> > variable names in prototypes?  btree_sort_into(btree *, btree *) - how
> > is one supposed to know from which into which?
> 
> Well - my intent isn't for these to be documentation, they're just there
> to make the compiler happy... I'd rather refer to the function
> definitions. That seems to me to be the norm within the kernel, function
> documentation goes with the definition and I've seen dropped variable
> names before (but then, that was block layer stuff :)
> 
> I'll change it if you want, though.

Yes, please do so.  Just match them to the actual function definition.

Thanks.

-- 
tejun
