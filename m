From: Enric Balletbo Serra <eballetbo@gmail.com>
Subject: Re: [PATCH v7 0/2] dm: boot a mapped device without an
	initramfs
Date: Fri, 19 May 2017 09:06:36 +0200
Message-ID: <CAFqH_52vbi1eM4tLg1tTtzxHpC4OObLWM8jp3nbMnsWv=LE93g@mail.gmail.com>
References: <20170518162911.15538-1-enric.balletbo@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170518162911.15538-1-enric.balletbo@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, linux-lvm@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi,

2017-05-18 18:29 GMT+02:00 Enric Balletbo i Serra
<enric.balletbo@collabora.com>:
> Dear all,
>
> So here is a new version of the patches to be reviewed, this time as
> suggested by Alasdair the patches are reworked to match with the new
> dmsetup bootformat feature [1]. These patches are not reviewed yet but
> the format was discussed in the IRC and was suggested to send the
> kernel patches in parallel.
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
>  drivers/md/dm-ioctl.c                           |  45 +++
>  include/linux/device-mapper.h                   |   6 +
>  init/Makefile                                   |   1 +
>  init/do_mounts.c                                |   1 +
>  init/do_mounts.h                                |  10 +
>  init/do_mounts_dm.c                             | 459 ++++++++++++++++++++++++
>  9 files changed, 591 insertions(+)
>  create mode 100644 Documentation/device-mapper/dm-boot.txt
>  create mode 100644 init/do_mounts_dm.c
>
> --
> 2.9.3
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Rebasing the patches against current linux-next I just noticied that
there is a build error due commit

commit e516db4f676ac88c7c7f698f8047178e8accc3b8
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Fri May 5 11:12:52 2017 -0700

    dm ioctl: add a new DM_DEV_ARM_POLL ioctl

So I'll send v8 to fix this.

Best regards,
  Enric
