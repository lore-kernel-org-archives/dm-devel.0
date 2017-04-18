From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6 0/3] dm: boot a mapped device without an initramfs
Date: Tue, 18 Apr 2017 10:37:59 -0700
Message-ID: <CAGXu5jLD+0POz1sopyZNNqDAiq2MZ5ZYdjs43jX5OnWxkZt1Lg@mail.gmail.com>
References: <20170418164240.18079-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170418164240.18079-1-enric.balletbo@collabora.com>
Sender: linux-raid-owner@vger.kernel.org
To: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Will Drewry <wad@chromium.org>, dm-devel@redhat.com, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Guenter Roeck <groeck@google.com>, David Zeuthen <zeuthen@google.com>
List-Id: dm-devel.ids

On Tue, Apr 18, 2017 at 9:42 AM, Enric Balletbo i Serra
<enric.balletbo@collabora.com> wrote:
> Hello,
>
> Some of these patches were send few years back, I saw that first
> version was send to this list in 2010, and after version 4 did not
> land [1]. Some days ago I resend the patches [2] and few hours later I
> noticed that one year ago was send a v5 version [3] and I was not aware.
>
> There was some discussion about v5 and during the discussion Mike Snitzer
> proposed that at least a change of the syntax is required, we're really
> interested on see this upstream as is extensively used in ChromeOS based
> devices so I'm wondering if we can restart the discussion and hopefully
> we will be able to do the modifications needed.
>
> So my first question is, apart of the change of the syntax, what more
> should be changed?

AFAIK, this was the main change needed. Change the syntax and plumb
into the ioctl interface. The discussion ended with Mike being open to
the idea, and for me to go work on it. I haven't had time to work on
it, though, so it has continued to be a locally carried patch:
https://www.redhat.com/archives/dm-devel/2016-February/msg00199.html

More recently David Zeuthen has been poking at this code, so I've
included him on CC here, in case there are new developments.

-Kees

>
> Thanks for your help,
>  Enric
>
> [1] Patchwork links:
>     https://patchwork.kernel.org/patch/104857/
>     https://patchwork.kernel.org/patch/104856/
>     https://patchwork.kernel.org/patch/104858/
>
> [2] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1375276.html
>
> [3] https://www.redhat.com/archives/dm-devel/2016-February/msg00112.html
>
>
> Brian Norris (1):
>   dm: make some mapped_device functions available
>
> Will Drewry (2):
>   dm: export a table+mapped device to the ioctl interface
>   init: add support to directly boot to a mapped device
>
>  Documentation/admin-guide/kernel-parameters.rst |   1 +
>  Documentation/admin-guide/kernel-parameters.txt |   3 +
>  Documentation/device-mapper/boot.txt            |  65 ++++
>  drivers/md/dm-ioctl.c                           |  36 ++
>  drivers/md/dm.h                                 |   8 -
>  include/linux/device-mapper.h                   |  19 +
>  init/Makefile                                   |   1 +
>  init/do_mounts.c                                |   1 +
>  init/do_mounts.h                                |  10 +
>  init/do_mounts_dm.c                             | 448 ++++++++++++++++++++++++
>  10 files changed, 584 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/device-mapper/boot.txt
>  create mode 100644 init/do_mounts_dm.c
>
> --
> 2.9.3
>



-- 
Kees Cook
Pixel Security
