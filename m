From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 2/3] dm: Export function dm_suspend_md()
Date: Sun, 21 Jun 2015 13:20:33 +0200
Message-ID: <1434885634-19895-3-git-send-email-pali.rohar@gmail.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
 <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1434885634-19895-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
List-Id: dm-devel.ids

This patch exports function dm_suspend_md() which suspend mapped device=
 so other
kernel drivers can use it and could suspend mapped device when needed.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 drivers/md/dm.c |    6 ++++++
 drivers/md/dm.h |    5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2caf492..03298ff 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3343,6 +3343,12 @@ out:
 	return r;
 }
=20
+int dm_suspend_md(struct mapped_device *md)
+{
+	return dm_suspend(md, DM_SUSPEND_LOCKFS_FLAG);
+}
+EXPORT_SYMBOL_GPL(dm_suspend_md);
+
 /*
  * Internal suspend/resume works like userspace-driven suspend. It wai=
ts
  * until all bios finish and prevents issuing new bios to the target d=
rivers.
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 6123c2b..528e5e0 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -151,6 +151,11 @@ int dm_test_deferred_remove_flag(struct mapped_dev=
ice *md);
 void dm_deferred_remove(void);
=20
 /*
+ * Suspend mapped_device
+ */
+int dm_suspend_md(struct mapped_device *md);
+
+/*
  * The device-mapper can be driven through one of two interfaces;
  * ioctl or filesystem, depending which patch you have applied.
  */
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
