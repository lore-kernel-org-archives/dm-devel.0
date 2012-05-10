From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Bcache v13 00/16]
Date: Thu, 10 May 2012 11:34:34 -0700
Message-ID: <CAA9_cmdozzzapZrU2uAiquuquggzMUBficntrJBo5KXV_Q58sA@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1336619038.git.koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tejun-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-raid <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

On Wed, May 9, 2012 at 8:07 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> bcache: a cache for arbitrary block devices using an SSD.
>
> Short overview:
> Bcache does both writethrough and writeback caching. It presents itself as a
> new block device, a bit like say md. You can cache an arbitrary number of
> block devices with a single cache device, and attach and detach things at
> runtime - it's quite flexible.
>
> It's very fast. It uses a b+ tree for the index, along with a journal to
> coalesce index updates, and a bunch of other cool tricks like auxiliary binary
> search trees with software floating point keys for searching within btree
> nodes.
>
> Bcache is solid, production ready code. There are still bugs being found that
> affect specific configurations, but there haven't been any major issues found
> in awhile - it's well past time I started working on getting it into mainline.
>
> It's a lot of code - I tried to split it out so that it'd make some sort of
> sense for reviewing. Let me know if there's anything else I can do to make
> review easier.
>
> TODO/known issues:
>
> __up_write() needs to be exported for bcache to compile as a module - it's
> used for bypassing lockdep when traversing the btree during garbage
> collection. If someone else knows a better solution, please let me know.
>
> The userspace interface is going to change before it goes in. The general
> consensus at LSF was that we don't want yet another interface for
> probing/managing block devices, and dm exists so we may as well use that. I
> don't think anyone's started on that yet, though.

Might as well mention I've started work on a md conversion.  Nearing
the point of having RFC patches ready to post.

I'm doing it in such a way that it does not preclude a dm target from
coming along as well.  Like I mentioned to Alasdair at LSF, there's no
reason this could not be treated the same as the shared raid
personalities between dm and md.

--
Dan
