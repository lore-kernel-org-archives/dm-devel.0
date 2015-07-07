From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Subject: Re: [PATCH v2 0/3] dm-crypt: Adds support for wiping key when doing
 suspend/hibernation
Date: Tue, 7 Jul 2015 09:59:41 +0200
Message-ID: <20150707075941.GD12087@pali>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: dm-devel.ids

On Sunday 21 June 2015 13:20:31 Pali Roh=C3=A1r wrote:
> This patch series increase security of suspend and hibernate actions.=
 It allows
> user to safely wipe crypto keys before suspend and hibernate actions =
starts
> without race conditions on userspace process with heavy I/O.
>=20
> To automatically wipe cryto key for <device> before hibernate action =
call:
> $ dmsetup message <device> 0 key wipe_on_hibernation
>=20
> To automatically wipe cryto key for <device> before suspend action ca=
ll:
> $ dmsetup message <device> 0 key wipe_on_suspend
>=20
> To disable automatic wipe call retain_on_suspend/retain_on_hibernatio=
n.
>=20
> Pali Roh=C3=A1r (3):
>   PM suspend/hibernate: Call notifier after freezing processes
>   dm: Export function dm_suspend_md()
>   dm-crypt: Adds support for wiping key when doing suspend/hibernatio=
n
>=20
>  drivers/md/dm-crypt.c    |  126 ++++++++++++++++++++++++++++++++++++=
+++++++---
>  drivers/md/dm.c          |    6 +++
>  drivers/md/dm.h          |    5 ++
>  include/linux/suspend.h  |    2 +
>  kernel/power/hibernate.c |    2 +
>  kernel/power/suspend.c   |    4 +-
>  6 files changed, 136 insertions(+), 9 deletions(-)
>=20

Hello, can somebody look and review this (v2) patch series?

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
