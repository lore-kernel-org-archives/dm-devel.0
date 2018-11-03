From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v10 0/2] dm: boot a mapped device without an initramfs
Date: Sat, 03 Nov 2018 10:10:08 +0100
Message-ID: <3624012.MiIzIq7dko@blindfold>
References: <20181103035341.16893-1-helen.koike@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181103035341.16893-1-helen.koike@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Helen Koike <helen.koike@collabora.com>, keescook@chromium.org
Cc: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com, linux-kernel@vger.kernel.org, enric.balletbo@collabora.com, wad@chromium.org, linux-doc@vger.kernel.org, linux-lvm@redhat.com, kernel@collabora.com
List-Id: dm-devel.ids

Helen,

Am Samstag, 3. November 2018, 04:53:39 CET schrieb Helen Koike:
> As mentioned in the discussion from the previous version of this patch, Android
> and Chrome OS do not use initramfs mostly due to boot time and size liability.

Do you have numbers on that?

I understand that using something like dracut with systemd inside is not what you
want from a boot time point of view.
But having an initramfs embedded into the kernel image which contains only a single
static linked binary can be *very* small and fast.
If you invest a little more time, you don't even need a libc, just fire up some
syscalls to setup your dm. I use this technique regularly on deeply embedded systems
to setup non-trivial UBIFS/crypto stuff.

Want I'm trying to say, before adding ad-hoc a feature to the kernel, we should be
very sure that there is no other way to solve this in a sane manner.
We have initramfs support for reasons.

Thanks,
//richard
