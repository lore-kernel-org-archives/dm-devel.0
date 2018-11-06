From: Will Drewry <wad@chromium.org>
Subject: Re: [PATCH v10 0/2] dm: boot a mapped device without an initramfs
Date: Tue, 6 Nov 2018 08:24:02 -0600
Message-ID: <CAAFS_9F62S_rm2uJDzXJzJyM82-o-xBAnx5Rkk-3iDD53YS72g@mail.gmail.com>
References: <20181103035341.16893-1-helen.koike@collabora.com> <3624012.MiIzIq7dko@blindfold>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3624012.MiIzIq7dko@blindfold>
Sender: linux-kernel-owner@vger.kernel.org
To: richard@nod.at
Cc: helen.koike@collabora.com, Kees Cook <keescook@chromium.org>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, enric.balletbo@collabora.com, linux-doc@vger.kernel.org, linux-lvm@redhat.com, kernel@collabora.com
List-Id: dm-devel.ids

Hi Richard, Helen,

On Sat, Nov 3, 2018 at 4:10 AM Richard Weinberger <richard@nod.at> wrote:
>
> Helen,
>
> Am Samstag, 3. November 2018, 04:53:39 CET schrieb Helen Koike:
> > As mentioned in the discussion from the previous version of this patch, Android
> > and Chrome OS do not use initramfs mostly due to boot time and size liability.
>
> Do you have numbers on that?

Originally, we saved ~200 ms, but I don't think we have recent
numbers.  (Unless Helen has some!) We first authored and posted this
patch in 2010:
- https://marc.info/?l=dm-devel&m=127429492521964&w=2
- https://marc.info/?l=dm-devel&m=127429499422096&w=2
- https://marc.info/?l=dm-devel&m=127429493922000&w=2

Every Chrome OS device uses a variant of this patch as well as
Android devices starting last year (if they use AVB 2.0).

Originally, the intent was the measured latency reduction.  We get a
linear speed
improvement when doing a cryptographic verification of the kernel and
initramfs.
Why? More data == more hashes (sha256 w/compute per block).  There's
additional overhead from bringing up early userspace, but those are the
numbers I don't have.

> I understand that using something like dracut with systemd inside is not what you
> want from a boot time point of view.
> But having an initramfs embedded into the kernel image which contains only a single
> static linked binary can be *very* small and fast.
> If you invest a little more time, you don't even need a libc, just fire up some
> syscalls to setup your dm. I use this technique regularly on deeply embedded systems
> to setup non-trivial UBIFS/crypto stuff.
>
> Want I'm trying to say, before adding ad-hoc a feature to the kernel, we should be
> very sure that there is no other way to solve this in a sane manner.
> We have initramfs support for reasons.

I very much appreciate the perspective, but after 8 years in shipping
devices after
integrating feedback from kernel maintainers over the subsequent years, this
doesn't feel like an "ad-hoc" feature.  It's been effective and fit in
well with the
existing kernel functionality, etc (imho :).  What level of
performance improvement or
other changes might be necessary to make the cut?

Thanks!
will
