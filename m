From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 1/3] PM suspend/hibernate: Call notifier after freezing processes
Date: Sun, 21 Jun 2015 13:20:32 +0200
Message-ID: <1434885634-19895-2-git-send-email-pali.rohar@gmail.com>
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

To prevent race conditions on userspace processes with I/O some taks mu=
st be
called after processes are freezed. This patch adds new events which ar=
e
delivered by pm_notifier_call_chain() after freezing processes when doi=
ng
suspend or hibernate action.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 include/linux/suspend.h  |    2 ++
 kernel/power/hibernate.c |    2 ++
 kernel/power/suspend.c   |    4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 5efe743..bc743c8 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -368,6 +368,8 @@ static inline bool hibernation_available(void) { re=
turn false; }
 #define PM_POST_SUSPEND		0x0004 /* Suspend finished */
 #define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved image */
 #define PM_POST_RESTORE		0x0006 /* Restore failed */
+#define PM_HIBERNATION_AFTER_FREEZE	0x0007 /* After hibernation freeze=
 */
+#define PM_SUSPEND_AFTER_FREEZE		0x0008 /* After suspend freeze */
=20
 extern struct mutex pm_mutex;
=20
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 2329daa..184f7ee 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -671,6 +671,8 @@ int hibernate(void)
 	if (error)
 		goto Exit;
=20
+	pm_notifier_call_chain(PM_HIBERNATION_AFTER_FREEZE);
+
 	lock_device_hotplug();
 	/* Allocate memory management structures */
 	error =3D create_basic_memory_bitmaps();
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 8d7a1ef..ba2a945 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -277,8 +277,10 @@ static int suspend_prepare(suspend_state_t state)
 	trace_suspend_resume(TPS("freeze_processes"), 0, true);
 	error =3D suspend_freeze_processes();
 	trace_suspend_resume(TPS("freeze_processes"), 0, false);
-	if (!error)
+	if (!error) {
+		pm_notifier_call_chain(PM_SUSPEND_AFTER_FREEZE);
 		return 0;
+	}
=20
 	suspend_stats.failed_freeze++;
 	dpm_save_failed_step(SUSPEND_FREEZE);
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
