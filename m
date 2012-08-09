From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v5 12/12] block: Only clone bio vecs that are
 in use
Date: Wed, 8 Aug 2012 20:19:36 -0700
Message-ID: <20120809031936.GM7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-13-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208061913500.21956@file.rdu.redhat.com>
 <20120808232804.GL6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <CAFR8uedZiG0NWgWQQa03r+kKh8rT0jzpj+hwPzq+i7K6zhpT_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFR8uedZiG0NWgWQQa03r+kKh8rT0jzpj+hwPzq+i7K6zhpT_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Muthu Kumar <muthu.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

On Wed, Aug 08, 2012 at 04:47:46PM -0700, Muthu Kumar wrote:
> Tejun,
> 
> This is changing the semantics of the clone. Sorry, I missed this
> thread and replied separately. But anyway, replying it again here:
> 
> 
> On Wed, Aug 8, 2012 at 4:28 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Mon, Aug 06, 2012 at 07:16:33PM -0400, Mikulas Patocka wrote:
> >> Hi Kent
> >>
> >> When you change the semantics of an exported function, rename that
> >> function. There may be external modules that use __bio_clone and this
> >> change could silently introduce bugs in them.
> >>
> >> Otherwise, the patchset looks fine.
> >
> > I don't know.  This doesn't change the main functionality and should
> > be transparent unless the caller is doing something crazy.  It *might*
> > be nice to rename but I don't think that's a must here.
> >
> > Thanks.
> 
> --
> You are changing the meaning of __bio_clone() here. In old code, the
> number of io_vecs, bi_idx, bi_vcnt are preserved. But in this modified
> code, you are mapping bio_src's bi_iovec[bi_idx] to bio_dests
> bi_iovec[0] and also restricting the number of allocated io_vecs of
> the clone. It may be useful for cases were we would like a identical
> copy of the original bio (may not be in current code base, but this
> implementation is definitely not what one would expect from the name
> "clone").

The problem is that bio_clone() is used on bios that were not allocated
or submitted by the cloning module.

If some code somewher submits a bio that points to 500 pages, but by the
time it gets to a driver it only points to 200 pages (say, because it
was split), that clone should succeed; it shouldn't fail simply because
it was trying to clone more than was necessary.

Bios have certain (poorly documented) semantics, and if this breaks
anything it's probably because that code was doing something crazy in
the first place.

In particular, if this change breaks anything then the new bio_split()
_will_ break things.

We need to be clear about our interfaces; in this case bi_idx and
bi_vcnt, in particular. Either this is a safe change, or it's not. If
no one knows... that's a bigger problem, and not just for this patch...

Fortunately this code actually has been tested quite a bit (and the bio
splitting code for even longer), and (somewhat to my surprise) I haven't
run into any bugs caused by it.
