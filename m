From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Thu, 2 Aug 2018 09:41:34 -0700
Message-ID: <CA+55aFyAox9BTDpRsqLXiROhHOX60aa45LEZ7Azteaumdu11Fw@mail.gmail.com>
References: <226835ba-2197-b850-6e5b-8ba14f7fd016@torlan.ru>
 <CAOi1vP_tYG77e71CdDiOcszSSEWrp9Vfi+KB7yFAXVQChkjP5A@mail.gmail.com> <93bff248-6897-4867-841b-2dace11597de@torlan.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <93bff248-6897-4867-841b-2dace11597de@torlan.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: wgh@torlan.ru
Cc: Ilya Dryomov <idryomov@gmail.com>, Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 2, 2018 at 8:16 AM WGH <wgh@torlan.ru> wrote:
>
> On 08/02/2018 04:31 PM, Ilya Dryomov wrote:
> >
> > From a quick look, --permission r sets DM_READONLY_FLAG, which makes dm
> > mark the disk read-only with set_disk_ro(dm_disk(md), 1) in do_resume().
> > A bit later it tries to write to the disk from write_header():
> >
> >   return chunk_io(ps, ps->header_area, 0, REQ_OP_WRITE, 0, 1);
> >
> > Thanks,
> >
> >                 Ilya
>
> After further investigation, this was fixed on lvm2 side (userspace) in
> https://sourceware.org/git/?p=lvm2.git;a=commit;h=a6fdb9d9d70f51c49ad11a87ab4243344e6701a3
> (snapshot: keep COW writable for read-only volumes).
>
> So I guess that's it. Time to poke my distribution package maintainers
> to bump the package version.

That is *not* how kernel development is supposed to work. If your
script used to work, it should continue to work.

Why did it use to work despite that read-only flag? And what was it
that actually broke this?

We remain bug-for-bug compatible with older kernel versions when
people depend on the bugs. Unless the old bugs are security issues,
and even then we try to make it _look_ like we work the same way.

Or was it a user-space lvm tool that broke in the first place, and the
kernel release update was a red herring?

                 Linus
