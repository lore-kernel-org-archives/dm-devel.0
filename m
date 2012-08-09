From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v5 12/12] block: Only clone bio vecs that are
 in use
Date: Wed, 8 Aug 2012 20:25:03 -0700
Message-ID: <CAH+dOxKr=BcWO5qmYZkrc2px+ckx=_+viWQ9M2hE7RMA3DaXNg@mail.gmail.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-13-git-send-email-koverstreet@google.com>
	<Pine.LNX.4.64.1208061913500.21956@file.rdu.redhat.com>
	<20120808232804.GL6983@dhcp-172-17-108-109.mtv.corp.google.com>
	<CAFR8uedZiG0NWgWQQa03r+kKh8rT0jzpj+hwPzq+i7K6zhpT_A@mail.gmail.com>
	<20120809031936.GM7262@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120809031936.GM7262-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Muthu Kumar <muthu.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Wed, Aug 8, 2012 at 8:19 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> In particular, if this change breaks anything then the new bio_split()
> _will_ break things.
>
> We need to be clear about our interfaces; in this case bi_idx and
> bi_vcnt, in particular. Either this is a safe change, or it's not. If
> no one knows... that's a bigger problem, and not just for this patch...
>
> Fortunately this code actually has been tested quite a bit (and the bio
> splitting code for even longer), and (somewhat to my surprise) I haven't
> run into any bugs caused by it.

Oh, it's worse than that - remember how bio_kmalloc() works for up to
1024 pages, but bio_alloc_bioset() only up to 256?

We can already have situations where bios are allocated that are
impossible to clone (or if we don't, it's only because of
queue_limits. That's not sketchy at all.)
