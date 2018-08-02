From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Thu, 2 Aug 2018 11:32:54 -0700
Message-ID: <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
References: <226835ba-2197-b850-6e5b-8ba14f7fd016@torlan.ru>
 <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
 <93bff248-6897-4867-841b-2dace11597de@torlan.ru> <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
 <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Cc: wgh@torlan.ru, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 2, 2018 at 11:18 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> I think it was my commit 721c7fc701c7 ("block: fail op_is_write()
> requests to read-only partitions").  The block layer was previously
> allowing non-blkdev_write_iter() writes to read-only disks and
> partitions.  dm's chunk_io() boils down to submit_bio(), so in 4.16
> it started to fail if the underlying device was marked read-only.

Ugh. That commit does look like the obviously right thing to do, and
our old behavior was obviously wrong.

At the same time, we really really shouldn't break user flow, even if
that flow was due to an obvious bug.

Dang.

> Apparently at least some versions of lvm(8) instruct dm to mark the COW
> device read-only even though it is always written to.  It comes up only
> if the user asks for a read-only snapshot (the default is writable).
>
> One option might be to ignore the supplied DM_READONLY_FLAG for COW
> devices.  Marking the COW device (i.e. the exception store) read-only
> is probably never sane...

That sounds like possibly the sanest fixlet for this - perhaps
together with a warning message saying "ignoring DM_READONLY_FLAG for
COW device" so that people see that they are doing insane things.

But some of our internal DM_READONLY_FLAG use obviously comes from
other sources that we have to honor (ie some grepping shows me code
like

                if (get_disk_ro(disk))
                        param->flags |= DM_READONLY_FLAG;

where we obviously can *not* override the get_disk_ro() state. So it
depends a lot on how this all happened. But it looks like in this
particular case, it all came from one inconsistent lvmcreate command.

Or - if there really is only _one_ user that noticed this, and a new
lvm2 release fixes his problem, maybe we can say "we broke it, but the
only person who reported it can work around it".

WGH (sorry, no idea what your real name is) - what's the source of the
script that broke? Was it some system script you got from outside and
likely to affect others too?

Or was it just some local thing you wrote yourself and was
unintentionally buggy and nobody else is likely to hit this?

Because if the latter, if you can work around it and you're the only
user this hits, we might just be able to ignore it.

                   Linus
