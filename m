From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/2] boot to a mapped device
Date: Thu, 27 Sep 2018 10:23:29 -0400
Message-ID: <20180927142328.GA4074@redhat.com>
References: <cover.1537936397.git.helen.koike@collabora.com>
 <CAFLxGvzCDOTR4stPmp1TTLkQ39x3e8MQuL=AR754abKc5skhpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFLxGvzCDOTR4stPmp1TTLkQ39x3e8MQuL=AR754abKc5skhpA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: helen.koike@collabora.com, device-mapper development <dm-devel@redhat.com>, agk@redhat.com, LKML <linux-kernel@vger.kernel.org>, enric.balletbo@collabora.com, Will Drewry <wad@chromium.org>, linux-doc@vger.kernel.org, linux-lvm@redhat.com, kernel@collabora.com
List-Id: dm-devel.ids

On Wed, Sep 26 2018 at  3:16am -0400,
Richard Weinberger <richard.weinberger@gmail.com> wrote:

> Helen,
> 
> On Wed, Sep 26, 2018 at 7:01 AM Helen Koike <helen.koike@collabora.com> wrote:
> >
> > This series is reviving an old patchwork.
> > Booting from a mapped device requires an initramfs. This series is
> > allows for device-mapper targets to be configured at boot time for
> > use early in the boot process (as the root device or otherwise).
> 
> What is the reason for this patch series?
> Setting up non-trivial root filesystems/storage always requires an
> initramfs, there is nothing
> wrong about this.

Exactly.  If phones or whatever would benefit from this patchset then
say as much.

I will not accept this patchset at this time.

> > Example, the following could be added in the boot parameters.
> > dm="lroot,,,rw, 0 4096 linear 98:16 0, 4096 4096 linear 98:32 0" root=/dev/dm-0
> 
> Hmmm, the new dm= parameter is anything but easy to get right.

No, it isn't.. exposes way too much potential for users hanging
themselves.
