From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 12/16] Closures
Date: Fri, 25 May 2012 14:35:20 -0700
Message-ID: <20120525213520.GC14196@google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-13-git-send-email-koverstreet@google.com>
 <1337979424.30100.19.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1337979424.30100.19.camel@joe2Laptop>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Fri, May 25, 2012 at 01:57:04PM -0700, Joe Perches wrote:
> On Fri, 2012-05-25 at 13:25 -0700, Kent Overstreet wrote:
> > Asynchronous refcounty thingies; they embed a refcount and a work
> > struct. Extensive documentation follows in include/linux/closure.h
> []
> > diff --git a/include/linux/closure.h b/include/linux/closure.h
> []
> > +enum closure_type {
> > +	TYPE_closure				= 0,
> 
> I still think these should be
> 	CLOSURE_TYPE_closure
> etc.

Oh - yes, definitely.

> > +#define __CLOSURE_TYPE(cl, _t)						\
> > +	  __builtin_types_compatible_p(typeof(cl), struct _t)		\
> > +		? TYPE_ ## _t :						\
> 	CLOSURE_TYPE_##_t
> 
> > +#define __closure_type(cl)						\
> > +(									\
> > +	__CLOSURE_TYPE(cl, closure)					\
> > +	__CLOSURE_TYPE(cl, closure_with_waitlist)			\
> > +	__CLOSURE_TYPE(cl, closure_with_timer)				\
> > +	__CLOSURE_TYPE(cl, closure_with_waitlist_and_timer)		\
> > +	invalid_closure_type()						\
> > +)
> 
> You should still feel dirty about this...

I feel a lot dirtier for implementing dynamic dispatch like this than
the macro tricks. The macro stuff at least is pretty simple stuff that
doesn't affect anything outside the 10 lines of code where it's used.

> > +#define continue_at(_cl, _fn, _wq, ...)					\
> > +do {									\
> > +	BUG_ON(!(_cl) || object_is_on_stack(_cl));			\
> > +	closure_set_ip(_cl);						\
> > +	set_closure_fn(_cl, _fn, _wq);					\
> > +	closure_sub(_cl, CLOSURE_RUNNING + 1);				\
> > +	return __VA_ARGS__;						\
> > +} while (0)
> 
> Does this have to be a macro?

Yes (though I could at least drop the __VA_ARGS__ part, I'm not using it
anymore and it was always a hack).

I explained why in the documentation, but basically the return is there
to enforce correct usage (it can't prevent you from doing dumb things,
but it can keep you from doing dumb things accidentally).

It's not _just_ enforcing correct usage though, it leads to better and
cleaner style. continue_at() is really flow control, so it makes the
code clearer and easier to follow if that's how it's used (by using it
also return).


> > diff --git a/lib/closure.c b/lib/closure.c
> []
> > +#define CL_FIELD(type, field)					\
> > +	case TYPE_ ## type:					\
> > +	return &container_of(cl, struct type, cl)->field
> > +
> > +static struct closure_waitlist *closure_waitlist(struct closure *cl)
> > +{
> > +	switch (cl->type) {
> > +		CL_FIELD(closure_with_waitlist, wait);
> > +		CL_FIELD(closure_with_waitlist_and_timer, wait);
> > +	default:
> > +		return NULL;
> > +	}
> > +}
> 
> Here:
> 
> static struct closure_waitlist *closure_waitlist(struct closure *cl)
> {
> 	switch (cl->type) {
> 	case CLOSURE_TYPE_closure_with_waitlist:
> 		return &container_of(cl, struct closure_with_waitlist, cl)->wait;
> 	case CLOSURE_TYPE_closure_with_waitlist_and_timer:
> 		return &container_of(cl, struct closure_with_waitlist_and_timer, cl)->wait;
> 	}
> 
> 	return NULL;
> }

Alright, if you feel that strongly about it :)
