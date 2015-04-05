From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 3/3] dm-crypt: Adds support for wiping key when doing suspend/hibernation
Date: Sun,  5 Apr 2015 19:20:19 +0200
Message-ID: <1428254419-7334-4-git-send-email-pali.rohar@gmail.com>
References: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1428254419-7334-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
List-Id: dm-devel.ids

This patch adds dm message commands and option strings to optionally wi=
pe key
from dm-crypt device before entering suspend or hibernate state.

Before key is wiped dm device must be suspended. To prevent race condit=
ions with
I/O and userspace processes, wiping action must be called after process=
es are
freezed. Otherwise userspace processes could start reading/writing to d=
isk after
dm device is suspened and freezing processes before suspend/hibernate a=
ction
will fail.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
---
 drivers/md/dm-crypt.c |  109 +++++++++++++++++++++++++++++++++++++++++=
++++----
 1 file changed, 102 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 713a962..9b02824 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -23,6 +23,7 @@
 #include <linux/atomic.h>
 #include <linux/scatterlist.h>
 #include <linux/rbtree.h>
+#include <linux/suspend.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
 #include <crypto/hash.h>
@@ -31,6 +32,8 @@
=20
 #include <linux/device-mapper.h>
=20
+#include "dm.h"
+
 #define DM_MSG_PREFIX "crypt"
=20
 /*
@@ -112,13 +115,18 @@ struct iv_tcw_private {
  * and encrypts / decrypts at the same time.
  */
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID,
-	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD };
+	     DM_CRYPT_SAME_CPU, DM_CRYPT_NO_OFFLOAD,
+	     DM_CRYPT_KEY_WIPE_ON_HIBERNATION,
+	     DM_CRYPT_KEY_WIPE_ON_SUSPEND,
+};
=20
 /*
  * The fields in here must be read only after initialization.
  */
 struct crypt_config {
 	struct dm_dev *dev;
+	struct dm_target *ti;
+	struct list_head entry;
 	sector_t start;
=20
 	/*
@@ -181,6 +189,9 @@ struct crypt_config {
=20
 #define MIN_IOS        16
=20
+static LIST_HEAD(crypt_list);
+static DEFINE_MUTEX(crypt_list_mtx);
+
 static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_reques=
t *dmreq);
@@ -1497,12 +1508,26 @@ out:
=20
 static int crypt_wipe_key(struct crypt_config *cc)
 {
+	int ret;
+
+	if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
+		ret =3D cc->iv_gen_ops->wipe(cc);
+		if (ret)
+			return ret;
+	}
+
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
=20
 	return crypt_setkey_allcpus(cc);
 }
=20
+static void crypt_suspend_and_wipe_key(struct crypt_config *cc)
+{
+	dm_suspend_md(dm_table_get_md(cc->ti->table));
+	crypt_wipe_key(cc);
+}
+
 static void crypt_dtr(struct dm_target *ti)
 {
 	struct crypt_config *cc =3D ti->private;
@@ -1512,6 +1537,10 @@ static void crypt_dtr(struct dm_target *ti)
 	if (!cc)
 		return;
=20
+	mutex_lock(&crypt_list_mtx);
+	list_del(&cc->entry);
+	mutex_unlock(&crypt_list_mtx);
+
 	if (cc->write_thread)
 		kthread_stop(cc->write_thread);
=20
@@ -1738,6 +1767,7 @@ static int crypt_ctr(struct dm_target *ti, unsign=
ed int argc, char **argv)
 	cc->key_size =3D key_size;
=20
 	ti->private =3D cc;
+	cc->ti =3D ti;
 	ret =3D crypt_ctr_cipher(ti, argv[0], argv[1]);
 	if (ret < 0)
 		goto bad;
@@ -1832,7 +1862,14 @@ static int crypt_ctr(struct dm_target *ti, unsig=
ned int argc, char **argv)
 			else if (!strcasecmp(opt_string, "submit_from_crypt_cpus"))
 				set_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags);
=20
+			else if (!strcasecmp(opt_string, "key_wipe_on_hibernation"))
+				set_bit(DM_CRYPT_KEY_WIPE_ON_HIBERNATION, &cc->flags);
+
+			else if (!strcasecmp(opt_string, "key_wipe_on_suspend"))
+				set_bit(DM_CRYPT_KEY_WIPE_ON_SUSPEND, &cc->flags);
+
 			else {
+				ret =3D -EINVAL;
 				ti->error =3D "Invalid feature arguments";
 				goto bad;
 			}
@@ -1871,6 +1908,10 @@ static int crypt_ctr(struct dm_target *ti, unsig=
ned int argc, char **argv)
 	ti->num_flush_bios =3D 1;
 	ti->discard_zeroes_data_unsupported =3D true;
=20
+	mutex_lock(&crypt_list_mtx);
+	list_add(&cc->entry, &crypt_list);
+	mutex_unlock(&crypt_list_mtx);
+
 	return 0;
=20
 bad:
@@ -1979,6 +2020,8 @@ static void crypt_resume(struct dm_target *ti)
 /* Message interface
  *	key set <key>
  *	key wipe
+ *	key wipe_on_hibernation <0|1>
+ *	key wipe_on_suspend <0|1>
  */
 static int crypt_message(struct dm_target *ti, unsigned argc, char **a=
rgv)
 {
@@ -1989,6 +2032,30 @@ static int crypt_message(struct dm_target *ti, u=
nsigned argc, char **argv)
 		goto error;
=20
 	if (!strcasecmp(argv[0], "key")) {
+		if (argc =3D=3D 3 && !strcasecmp(argv[1], "wipe_on_hibernation")) {
+			if (!strcmp(argv[2], "1")) {
+				set_bit(DM_CRYPT_KEY_WIPE_ON_HIBERNATION, &cc->flags);
+				return 0;
+			} else if (!strcmp(argv[2], "0")) {
+				clear_bit(DM_CRYPT_KEY_WIPE_ON_HIBERNATION, &cc->flags);
+				return 0;
+			} else {
+				DMWARN("unrecognised message received.");
+				return -EINVAL;
+			}
+		}
+		if (argc =3D=3D 3 && !strcasecmp(argv[1], "wipe_on_suspend")) {
+			if (!strcmp(argv[2], "1")) {
+				set_bit(DM_CRYPT_KEY_WIPE_ON_SUSPEND, &cc->flags);
+				return 0;
+			} else if (!strcmp(argv[2], "0")) {
+				clear_bit(DM_CRYPT_KEY_WIPE_ON_SUSPEND, &cc->flags);
+				return 0;
+			} else {
+				DMWARN("unrecognised message received.");
+				return -EINVAL;
+			}
+		}
 		if (!test_bit(DM_CRYPT_SUSPENDED, &cc->flags)) {
 			DMWARN("not suspended during key manipulation.");
 			return -EINVAL;
@@ -2002,11 +2069,6 @@ static int crypt_message(struct dm_target *ti, u=
nsigned argc, char **argv)
 			return ret;
 		}
 		if (argc =3D=3D 2 && !strcasecmp(argv[1], "wipe")) {
-			if (cc->iv_gen_ops && cc->iv_gen_ops->wipe) {
-				ret =3D cc->iv_gen_ops->wipe(cc);
-				if (ret)
-					return ret;
-			}
 			return crypt_wipe_key(cc);
 		}
 	}
@@ -2055,19 +2117,52 @@ static struct target_type crypt_target =3D {
 	.iterate_devices =3D crypt_iterate_devices,
 };
=20
+static int dm_crypt_pm_notifier_call(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	struct crypt_config *cc;
+
+	mutex_lock(&crypt_list_mtx);
+
+	list_for_each_entry(cc, &crypt_list, entry) {
+		if ((action =3D=3D PM_HIBERNATION_AFTER_FREEZE &&
+		     test_bit(DM_CRYPT_KEY_WIPE_ON_HIBERNATION, &cc->flags)) ||
+		    (action =3D=3D PM_SUSPEND_AFTER_FREEZE &&
+		     test_bit(DM_CRYPT_KEY_WIPE_ON_SUSPEND, &cc->flags))) {
+			crypt_suspend_and_wipe_key(cc);
+		}
+	}
+
+	mutex_unlock(&crypt_list_mtx);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block dm_crypt_pm_notifier_block =3D {
+	.notifier_call =3D dm_crypt_pm_notifier_call,
+};
+
 static int __init dm_crypt_init(void)
 {
 	int r;
=20
 	r =3D dm_register_target(&crypt_target);
-	if (r < 0)
+	if (r < 0) {
 		DMERR("register failed %d", r);
+		return r;
+	}
+
+	r =3D register_pm_notifier(&dm_crypt_pm_notifier_block);
+	if (r) {
+		DMWARN("register_pm_notifier failed %d", r);
+	}
=20
 	return r;
 }
=20
 static void __exit dm_crypt_exit(void)
 {
+	unregister_pm_notifier(&dm_crypt_pm_notifier_block);
 	dm_unregister_target(&crypt_target);
 }
=20
--=20
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
