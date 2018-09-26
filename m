From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 0/2] boot to a mapped device
Date: Wed, 26 Sep 2018 09:16:57 +0200
Message-ID: <CAFLxGvzCDOTR4stPmp1TTLkQ39x3e8MQuL=AR754abKc5skhpA@mail.gmail.com>
References: <cover.1537936397.git.helen.koike@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1537936397.git.helen.koike@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: helen.koike@collabora.com
Cc: device-mapper development <dm-devel@redhat.com>, agk@redhat.com, snitzer@redhat.com, LKML <linux-kernel@vger.kernel.org>, enric.balletbo@collabora.com, Will Drewry <wad@chromium.org>, linux-doc@vger.kernel.org, linux-lvm@redhat.com, kernel@collabora.com
List-Id: dm-devel.ids

Helen,

On Wed, Sep 26, 2018 at 7:01 AM Helen Koike <helen.koike@collabora.com> wrote:
>
> This series is reviving an old patchwork.
> Booting from a mapped device requires an initramfs. This series is
> allows for device-mapper targets to be configured at boot time for
> use early in the boot process (as the root device or otherwise).

What is the reason for this patch series?
Setting up non-trivial root filesystems/storage always requires an
initramfs, there is nothing
wrong about this.

> Example, the following could be added in the boot parameters.
> dm="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" root=/dev/dm-0

Hmmm, the new dm= parameter is anything but easy to get right.

-- 
Thanks,
//richard
