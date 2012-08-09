From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v5 12/12] block: Only clone bio vecs that
 are in use
Date: Thu, 9 Aug 2012 00:01:54 -0700
Message-ID: <20120809070154.GG2845@dhcp-172-17-108-109.mtv.corp.google.com>
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
Cc: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Wed, Aug 08, 2012 at 04:47:46PM -0700, Muthu Kumar wrote:
> You are changing the meaning of __bio_clone() here. In old code, the
> number of io_vecs, bi_idx, bi_vcnt are preserved. But in this modified
> code, you are mapping bio_src's bi_iovec[bi_idx] to bio_dests
> bi_iovec[0] and also restricting the number of allocated io_vecs of
> the clone. It may be useful for cases were we would like a identical
> copy of the original bio (may not be in current code base, but this
> implementation is definitely not what one would expect from the name
> "clone").

Implementation details changed somewhat but the high-level semantics
didn't change at all.  Any driver not messing with bio internals - and
they shouldn't - shouldn't notice the change.  No in-kernel drivers
seem to be broken by the change.  If you ask me, this looks more like
a bug fix to me where the bug is a silly behavior restricting
usefulness of the interface.

> May be, call this new implementation some thing else (and use it for bcache)?

This doesn't only change __bio_clone() but all clone interface stacked
on top of it, so, no way.  This ain't windows.

Thanks.

-- 
tejun
