From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 12/16] Closures
Date: Fri, 25 May 2012 13:57:04 -0700
Message-ID: <1337979424.30100.19.camel@joe2Laptop>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
	 <1337977539-16977-13-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337977539-16977-13-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Fri, 2012-05-25 at 13:25 -0700, Kent Overstreet wrote:
> Asynchronous refcounty thingies; they embed a refcount and a work
> struct. Extensive documentation follows in include/linux/closure.h
[]
> diff --git a/include/linux/closure.h b/include/linux/closure.h
[]
> +enum closure_type {
> +	TYPE_closure				= 0,

I still think these should be
	CLOSURE_TYPE_closure
etc.

> +#define __CLOSURE_TYPE(cl, _t)						\
> +	  __builtin_types_compatible_p(typeof(cl), struct _t)		\
> +		? TYPE_ ## _t :						\
	CLOSURE_TYPE_##_t

> +#define __closure_type(cl)						\
> +(									\
> +	__CLOSURE_TYPE(cl, closure)					\
> +	__CLOSURE_TYPE(cl, closure_with_waitlist)			\
> +	__CLOSURE_TYPE(cl, closure_with_timer)				\
> +	__CLOSURE_TYPE(cl, closure_with_waitlist_and_timer)		\
> +	invalid_closure_type()						\
> +)

You should still feel dirty about this...

> +#define continue_at(_cl, _fn, _wq, ...)					\
> +do {									\
> +	BUG_ON(!(_cl) || object_is_on_stack(_cl));			\
> +	closure_set_ip(_cl);						\
> +	set_closure_fn(_cl, _fn, _wq);					\
> +	closure_sub(_cl, CLOSURE_RUNNING + 1);				\
> +	return __VA_ARGS__;						\
> +} while (0)

Does this have to be a macro?

> diff --git a/lib/closure.c b/lib/closure.c
[]
> +#define CL_FIELD(type, field)					\
> +	case TYPE_ ## type:					\
> +	return &container_of(cl, struct type, cl)->field
> +
> +static struct closure_waitlist *closure_waitlist(struct closure *cl)
> +{
> +	switch (cl->type) {
> +		CL_FIELD(closure_with_waitlist, wait);
> +		CL_FIELD(closure_with_waitlist_and_timer, wait);
> +	default:
> +		return NULL;
> +	}
> +}

Here:

static struct closure_waitlist *closure_waitlist(struct closure *cl)
{
	switch (cl->type) {
	case CLOSURE_TYPE_closure_with_waitlist:
		return &container_of(cl, struct closure_with_waitlist, cl)->wait;
	case CLOSURE_TYPE_closure_with_waitlist_and_timer:
		return &container_of(cl, struct closure_with_waitlist_and_timer, cl)->wait;
	}

	return NULL;
}
