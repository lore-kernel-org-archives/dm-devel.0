From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v2 12/14] Closures
Date: Wed, 23 May 2012 21:16:54 -0400
Message-ID: <20120524011654.GA28662@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-13-git-send-email-koverstreet@google.com>
 <1337820443.1747.24.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1337820443.1747.24.camel@joe2Laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids

On Wed, May 23, 2012 at 05:47:23PM -0700, Joe Perches wrote:
> > +#define CLOSURE_REMAINING_MASK	(~(~0 << 20))
> 
> More commonly used is ((1 << 20) - 1)

Hadn't come across that in the kernel - the ~(~0 << foo) I got from K&R.
But I can switch.

> 
> > +#define CLOSURE_GUARD_MASK					\
> > +	((1 << 20)|(1 << 22)|(1 << 24)|(1 << 26)|(1 << 28)|(1 << 30))
> 
> Perhaps a poor choice of layout.
> 
> Perhaps it'd be more sensible to define CLOSURE_<FOO>_GUARDs
> along with CLOSURE_<FOO>

Good idea, I'll do that.

> 
> It might make more sense to use another macro with
> the somewhat magic number of 20 more explicitly defined.

I think to get 20 defined in a single place I'd have to have a separate
enum - something like:

enum closure_state_bits {
	CLOSURE_REMAINING_END	= 20,
	CLOSURE_BLOCKING_GUARD	= 20,
	CLOSURE_BLOCKING_BIT	= 21,
	etc.
};

and then the existing enum changed to use those. Verbose, but maybe the
best way to do it.

> 
> > +
> > +	/*
> > +	 * CLOSURE_RUNNING: Set when a closure is running (i.e. by
> > +	 * closure_init() and when closure_put() runs then next function), and
> > +	 * must be cleared before remaining hits 0. Primarily to help guard
> > +	 * against incorrect usage and accidently transferring references.
> 
> accidentally

And gvim was already highlighting that for me :(

> 
> []
> > +	 * CLOSURE_TIMER: Analagous to CLOSURE_WAITING, indicates that a closure
> 
> analogous
> 
> []
> 
> > +#define TYPE_closure			0U
> > +#define TYPE_closure_with_waitlist	1U
> > +#define TYPE_closure_with_timer		2U
> > +#define TYPE_closure_with_waitlist_and_timer 3U
> 
> UPPER_lower is generally frowned on.
> It'd be better to use CLOSURE_TYPE as all uses
> are obscured by macros.

Definitely ugly, but the alternative would be
struct closure_WITH_WAITLIST;
struct closure_WITH_TIMER;

and this way at least the ugliness is confined to the internal
implementation.

> > +#define __CL_TYPE(cl, _t)						\
> > +	  __builtin_types_compatible_p(typeof(cl), struct _t)		\
> > +		? TYPE_ ## _t :						\
> 
> Might as well use __CLOSURE_TYPE

Yeah.

> > +
> > +#define __closure_type(cl)						\
> > +(									\
> > +	__CL_TYPE(cl, closure)						\
> > +	__CL_TYPE(cl, closure_with_waitlist)				\
> > +	__CL_TYPE(cl, closure_with_timer)				\
> > +	__CL_TYPE(cl, closure_with_waitlist_and_timer)			\
> > +	invalid_closure_type()						\
> > +)
> 
> outstandingly obscure. props.

Heh. Yeah, I felt dirty for writing that. But it prevents the typenames
and constants from getting out of sync.

> Another paragon of intelligibility.
> 
> I think you should lose CL_FIELD and
> write normal switch/cases.

Well, same with the last one it's mapping constants -> typenames and
preventing a mismatch. But I dunno, I might drop this one. Though it is
less painful to read than the last one.

> > +static int debug_seq_show(struct seq_file *f, void *data)
> > +{
> > +	struct closure *cl;
> > +	spin_lock_irq(&closure_list_lock);
> > +
> > +	list_for_each_entry(cl, &closure_list, all) {
> > +		int r = atomic_read(&cl->remaining);
> > +
> > +		seq_printf(f, "%p: %pF -> %pf p %p r %i ",
> > +			   cl, (void *) cl->ip, cl->fn, cl->parent,
> > +			   r & CLOSURE_REMAINING_MASK);
> > +
> > +		if (test_bit(WORK_STRUCT_PENDING, work_data_bits(&cl->work)))
> > +			seq_printf(f, "Q");
> 
> seq_putc or seq_puts

Thanks.

> > +
> > +		if (r & CLOSURE_RUNNING)
> > +			seq_printf(f, "R");
> > +
> > +		if (r & CLOSURE_BLOCKING)
> > +			seq_printf(f, "B");
> > +
> > +		if (r & CLOSURE_STACK)
> > +			seq_printf(f, "S");
> > +
> > +		if (r & CLOSURE_SLEEPING)
> > +			seq_printf(f, "Sl");
> > +
> > +		if (r & CLOSURE_TIMER)
> > +			seq_printf(f, "T");
> > +
> > +		if (r & CLOSURE_WAITING)
> > +			seq_printf(f, " W %pF\n",
> > +				   (void *) cl->waiting_on);
> > +
> > +		seq_printf(f, "\n");
> 
> or maybe just bundle all this in a single seq_printf

Do you mean something like this?
seq_printf(f, "%s%s%s%s%s\n",
	   r & CLOSURE_RUNNING	? "R" : "",
	   r & CLOSURE_BLOCKING ? "B" : "");

Or do you have a better way of writing that in mind?
