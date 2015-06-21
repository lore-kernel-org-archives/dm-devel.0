From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 0/3] dm-crypt: Adds support for wiping key when doing suspend/hibernation
Date: Sun, 21 Jun 2015 13:20:31 +0200
Message-ID: <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-pm-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
List-Id: dm-devel.ids

This patch series increase security of suspend and hibernate actions. I=
t allows
user to safely wipe crypto keys before suspend and hibernate actions st=
arts
without race conditions on userspace process with heavy I/O.

To automatically wipe cryto key for <device> before hibernate action ca=
ll:
$ dmsetup message <device> 0 key wipe_on_hibernation

To automatically wipe cryto key for <device> before suspend action call=
:
$ dmsetup message <device> 0 key wipe_on_suspend

To disable automatic wipe call retain_on_suspend/retain_on_hibernation.

Pali Roh=C3=A1r (3):
  PM suspend/hibernate: Call notifier after freezing processes
  dm: Export function dm_suspend_md()
  dm-crypt: Adds support for wiping key when doing suspend/hibernation

 drivers/md/dm-crypt.c    |  126 ++++++++++++++++++++++++++++++++++++++=
+++++---
 drivers/md/dm.c          |    6 +++
 drivers/md/dm.h          |    5 ++
 include/linux/suspend.h  |    2 +
 kernel/power/hibernate.c |    2 +
 kernel/power/suspend.c   |    4 +-
 6 files changed, 136 insertions(+), 9 deletions(-)

--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-pm" in
