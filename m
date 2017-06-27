From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v8 0/2] dm: boot a mapped device without an initramfs
Date: Tue, 27 Jun 2017 16:50:55 -0700
Message-ID: <CAGXu5j+_Bzn-xdaSLOR0bsHMZpngOYw=8CnHDcABk0Xs+T1xqA@mail.gmail.com>
References: <20170519071146.25760-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170519071146.25760-1-enric.balletbo@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-lvm@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, May 19, 2017 at 12:11 AM, Enric Balletbo i Serra
<enric.balletbo@collabora.com> wrote:
> Dear all,
>
> So here is a new version of the patches to be reviewed, this time as
> suggested by Alasdair the patches are reworked to match with the new
> dmsetup bootformat feature [1]. These patches are not reviewed yet but
> the format was discussed in the IRC and was suggested to send the
> kernel patches in parallel.

Just pinging on this thread again. Alasdair, how does this look to you?

Thanks!

-Kees

>
> Changes since v7:
>  - Fix build error due commit
>     e516db4f67 (dm ioctl: add a new DM_DEV_ARM_POLL ioctl)
>
> Changes since v6:
>  - Add a new function to issue the equivalent of a DM ioctl programatically.
>  - Use the new ioctl interface to create the devices.
>  - Use a comma-delimited and semi-colon delimited dmsetup-like commands.
>
> Changes since v5:
>  - https://www.redhat.com/archives/dm-devel/2016-February/msg00112.html
>
> [1] https://www.redhat.com/archives/linux-lvm/2017-May/msg00047.html
>
> Wating for your feedback,
>
> Enric Balletbo i Serra (1):
>   dm ioctl: add a device mapper ioctl function.
>
> Will Drewry (1):
>   init: add support to directly boot to a mapped device
>
>  Documentation/admin-guide/kernel-parameters.rst |   1 +
>  Documentation/admin-guide/kernel-parameters.txt |   3 +
>  Documentation/device-mapper/dm-boot.txt         |  65 ++++
>  drivers/md/dm-ioctl.c                           |  50 +++
>  include/linux/device-mapper.h                   |   6 +
>  init/Makefile                                   |   1 +
>  init/do_mounts.c                                |   1 +
>  init/do_mounts.h                                |  10 +
>  init/do_mounts_dm.c                             | 459 ++++++++++++++++++++++++
>  9 files changed, 596 insertions(+)
>  create mode 100644 Documentation/device-mapper/dm-boot.txt
>  create mode 100644 init/do_mounts_dm.c
>
> --
> 2.9.3
>



-- 
Kees Cook
Pixel Security
