From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Thu, 2 Aug 2018 20:18:44 +0200
Message-ID: <CAOi1vP-SJO4AMK=XD3Lmja++2dQqoiw6Zn8Vgxf8OfvYgnuC6Q@mail.gmail.com>
References: <226835ba-2197-b850-6e5b-8ba14f7fd016@torlan.ru>
 <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com>
 <93bff248-6897-4867-841b-2dace11597de@torlan.ru> <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: wgh@torlan.ru, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, linux-kernel@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 2, 2018 at 6:41 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Aug 2, 2018 at 8:16 AM WGH <wgh@torlan.ru> wrote:
> >
> > On 08/02/2018 04:31 PM, Ilya Dryomov wrote:
> > >
> > > From a quick look, --permission r sets DM_READONLY_FLAG, which makes dm
> > > mark the disk read-only with set_disk_ro(dm_disk(md), 1) in do_resume().
> > > A bit later it tries to write to the disk from write_header():
> > >
> > >   return chunk_io(ps, ps->header_area, 0, REQ_OP_WRITE, 0, 1);
> > >
> > > Thanks,
> > >
> > >                 Ilya
> >
> > After further investigation, this was fixed on lvm2 side (userspace) in
> > https://sourceware.org/git/?p=lvm2.git;a=commit;h=a6fdb9d9d70f51c49ad11a87ab4243344e6701a3
> > (snapshot: keep COW writable for read-only volumes).
> >
> > So I guess that's it. Time to poke my distribution package maintainers
> > to bump the package version.
>
> That is *not* how kernel development is supposed to work. If your
> script used to work, it should continue to work.
>
> Why did it use to work despite that read-only flag? And what was it
> that actually broke this?

I think it was my commit 721c7fc701c7 ("block: fail op_is_write()
requests to read-only partitions").  The block layer was previously
allowing non-blkdev_write_iter() writes to read-only disks and
partitions.  dm's chunk_io() boils down to submit_bio(), so in 4.16
it started to fail if the underlying device was marked read-only.

>
> We remain bug-for-bug compatible with older kernel versions when
> people depend on the bugs. Unless the old bugs are security issues,
> and even then we try to make it _look_ like we work the same way.
>
> Or was it a user-space lvm tool that broke in the first place, and the
> kernel release update was a red herring?

Apparently at least some versions of lvm(8) instruct dm to mark the COW
device read-only even though it is always written to.  It comes up only
if the user asks for a read-only snapshot (the default is writable).

One option might be to ignore the supplied DM_READONLY_FLAG for COW
devices.  Marking the COW device (i.e. the exception store) read-only
is probably never sane...

Thanks,

                Ilya
