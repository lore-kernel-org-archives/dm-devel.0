From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v11] dm: add support to directly boot to a mapped device
Date: Thu, 21 Feb 2019 09:13:34 -0800
Message-ID: <CAGXu5jKiEmmpVE0f_9r4Wop8c11skcsgAruGr2UbOiAof8T7DA@mail.gmail.com>
References: <20190218181819.20524-1-helen.koike@collabora.com> <20190221155032.GA3155@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190221155032.GA3155@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Helen Koike <helen.koike@collabora.com>, device-mapper development <dm-devel@redhat.com>, Will Drewry <wad@chromium.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, richard -rw- weinberger <richard.weinberger@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-lvm@redhat.com, Enric Balletbo i Serra <enric.balletbo@collabora.com>, kernel@collabora.com, Alasdair G Kergon <agk@redhat.com>, David Zeuthen <zeuthen@google.com>
List-Id: dm-devel.ids

On Thu, Feb 21, 2019 at 7:50 AM Mike Snitzer <snitzer@redhat.com> wrote:
>
> On Mon, Feb 18 2019 at  1:18pm -0500,
> Helen Koike <helen.koike@collabora.com> wrote:
>
> > Add a dm-mod.create= kernel module parameter.
> > It allows device-mapper targets to be configured at boot time for use early
> > in the boot process (as the root device or otherwise).
> >
> > Signed-off-by: Will Drewry <wad@chromium.org>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > [rework to use dm_ioctl calls]
> > Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> > [refactored for upstream]
> > Signed-off-by: Helen Koike <helen.koike@collabora.com>
>
> Can I get confirmation from Will and Kees that this v11 is safe to carry
> their Signed-off-by?  Are you guys "happy" with this patch?

I think those should be "Co-developed-by:" to more correctly capture
the intent. At this point I think Helen is the primary author. Or at
least, Will and I aren't anymore. :)

At first pass, yes, this patch does what's needed for Chrome OS and
Android, but I'll take a closer look shortly (and I've added David who
has looked at this most recently).

Thanks!

-- 
Kees Cook
