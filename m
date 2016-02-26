From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5 0/3] init: add support to directly boot to a mapped device
Date: Fri, 26 Feb 2016 11:59:30 -0800
Message-ID: <CAGXu5jJNgwdRZ0c0qG-gDqjcAvSn1ZyLsHBhqgfbM6iE2u1uow@mail.gmail.com>
References: <1455992032-14594-1-git-send-email-keescook@chromium.org>
	<20160221220839.GD16166@agk-dp.fab.redhat.com>
	<CAGXu5jJ9nUdE8u8a3EYR5uS_zOLEkmQn3M0Nsm9bkxBmMxpC9Q@mail.gmail.com>
	<20160226165358.GA26728@redhat.com>
	<CAGXu5j+JGPZ2sH3uAHwpJ3im_TBUL19U43EZw-Z2dZ6fQiC2zA@mail.gmail.com>
	<20160226192145.GA27326@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160226192145.GA27326@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Will Drewry <wad@chromium.org>, Chen Yu <yu.c.chen@intel.com>, Jonathan Corbet <corbet@lwn.net>, David Zeuthen <zeuthen@google.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, LKML <linux-kernel@vger.kernel.org>, Dan Ehrenberg <dehrenberg@chromium.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Vishnu Pratap Singh <vishnu.ps@samsung.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 26, 2016 at 11:21 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Fri, Feb 26 2016 at  1:52pm -0500,
> Kees Cook <keescook@chromium.org> wrote:
>
>> On Fri, Feb 26, 2016 at 8:53 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>> > On Mon, Feb 22 2016 at  1:55pm -0500,
>> > Kees Cook <keescook@chromium.org> wrote:
>> >
>> >> On Sun, Feb 21, 2016 at 2:08 PM, Alasdair G Kergon <agk@redhat.com> wrote:
>> >> > On Sat, Feb 20, 2016 at 10:13:49AM -0800, Kees Cook wrote:
>> >> >> This is a resurrection of a patch series from a few years back, first
>> >> >> brought to the dm maintainers in 2010. It creates a way to define dm
>> >> >> devices on the kernel command line for systems that do not use an
>> >> >> initramfs, or otherwise need a dm running before init starts.
>> >> >>
>> >> >> This has been used by Chrome OS for several years, and now by Brillo
>> >> >> (and likely Android soon).
>> >> >>
>> >> >> The last version was v4:
>> >> >> https://patchwork.kernel.org/patch/104860/
>> >> >> https://patchwork.kernel.org/patch/104861/
>> >> >
>> >> > Inconsistencies in the terminology here can be sorted out during review,
>> >> > and I see that you've taken on board some of my review comments from
>> >> > 2010, but what are your responses to the rest of them?
>> >>
>> >> Ah, sorry, the threads I could find were incomplete, so I wasn't able
>> >> to find those comments that were made to Will's 2010 submission. In
>> >> some of the cleanups I did I was very confused about "target" vs
>> >> "table", and tried to fix that. Regardless, I'm open to fixing
>> >> whatever is needed. :)
>> >>
>> >> Thanks for looking at this again!
>> >
>> > This work isn't going to fly as is.  I appreciate the effort and the
>> > goal (without understanding _why_) but: you're open-coding, duplicating
>> > and/or reinventing way too much in do_mounts_dm.c
>> >
>> > 1) You first need to answer: _why_ is using a proper initramfs not
>> > viable?  A very simple initramfs that issues dmsetup commands, etc,
>> > isn't so daunting is it?  Why is it so important for the kernel to
>> > natively provide a dmsetup interface?  Chrome, Android, etc cannot use
>> > initramfs?
>>
>> That is correct: Chrome OS does not (and won't) use an initramfs. This
>> is mainly for reasons of boot speed, verified boot block size, and
>> maybe some other things I don't remember.
>
> Not sure what "verified boot block size" means but...

Chrome OS uses coreboot as its boot firmware and a coreboot module
known as "depthcharge" for doing the crypto-verification and booting
of the Chrome OS system. This is the static root of trust Chrome OS
extends from its read-only boot firmware through to the kernel it
loads and the dm-verity partition it mounts as the read-only root
filesystem. To keep the boot speed fast and the kernel size small,
there is no initramfs.

> Sorry I really don't buy that using a custom initramfs would be the
> source of slow boot.  initramfs is _not_ this hugely inefficient
> mechanism you'd have us believe.

I didn't say it was hugely inefficient, but for Chrome OS it's not
needed, and was a measurable source of boot time. We just got rid of
it since it was redundant. I can't change that design decision; I'm
just here to help bring the dm= boot support upstream. :)

> And if that is the justification for this early boot dm= support then
> the Chrome OS project/team will have to continue to carry the hack
> locally.  It has no place upstream.  But I'm open to revisiting this if
> it can be implemented in a very cheap way.

Yeah, I'm open to whatever suggestions you have.

>> > 2) If you are able to adequately justify the need for dm=:
>> > I'd much rather the dm= kernel commandline be a simple series of
>> > comma-delimited dmsetup-like commands.
>> >
>> > You'd handle each command with extremely basic parsing:
>> >  <dm_ioctl_cmd> <args> [, <dm_ioctl_cmd> <args>]
>> > (inventing a special token to denote <newline>, to support tables with
>> > multiple entries, rather than relying on commas and counts, etc)
>>
>> Sure, changing the syntax is fine by me. We'd need to plumb access to
>> the ioctl interface, though.
>
> I was hoping to avoid any extra hacks but yes... seems you'd need a new
> API to issue the equivalent of a DM ioctl programatically.  Hopefully
> it'd be quite a small wrapper.

Seems like it shouldn't be too bad.

>> > and you'd then have do_mounts_dm.c open /dev/mapper/control directly and
>> > issue proper DM ioctls rather than adding all your shim code.  This last
>> > bit of opening /dev/mapper/control from init needs more research -- not
>> > sure if doing such a thing from kernel is viable/safe/acceptable.
>>
>> Well, there's no /dev and no init since our dm is the root device
>> (dm-verity). We need everything up and running before we mount the
>> root filesystem, very similar to do_mount_md.c's purpose.
>
> Ah yes, microoptimization associated with no udev or normal Linux boot
> comes full circle and limits the use of existing standard interfaces.

Chrome OS is hardly the only Linux device without an initramfs, but
yeah, it does cause us headaches from time to time.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
