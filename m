From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 08/10] Fix issues with user_friendly_names
	initramfs bindings
Date: Fri, 15 May 2015 18:14:11 -0500
Message-ID: <1431731653-3892-9-git-send-email-bmarzins@redhat.com>
References: <1431731653-3892-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1431731653-3892-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Stewart, Sean" <Sean.Stewart@netapp.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Multipath has an issue with user_friendly_names set in the initramfs.
If the bindings are in the initramfs bindings file, it will create them,
and it may use bindings that are different than the ones in the regular
file system.  Once multipathd starts up in the regular file system, it
will try to register the existing bindings, but that may (and in many
cases, is likely to) fail. If it can't reanme it, will pick a new
binding. Since when multipathd starts discovering the existing devices,
it obviously doesn't know all of the existing devices yet, it may very
well pick a binding that's already in use by a device that it hasn't
discovered yet. In this case multipath will be unable to rename the
device to the new binding. Unfortunately, if it fails the rename, it
never resets the alias of the device stored in the mpvec to current
alias of the actual dm device. So multipath will have devices in the
mpvec where the alias and the wwid don't match the actual dm devices
that exist.  This can cause all sorts of problems.

This patch does two things to deal with this.  First, it makes sure that
if the rename fails, the device will reset its alias to the one that it
currently has.

Second, it adds a new option to help avoid the problem in the first
place.  There actually already is a solution to this issue. If
multipathd is started with -B, it makes the bindings file read-only. If
multipathd is started this way in the initramfs, it will never make new
bindings for a device. If the device doesn't already have a binding, it
will simply be named with its wwid. The problem with this method is that
AFAICT it causes a maintenance problem with dracut.  At least on RedHat,
dracut is simply copying the regular multipathd.service file into the
initramfs. I don't see a way in multipathd.service to only start
multipathd with the -B option in the initramfs (If there is a way, I'd
be happy to use that). So, the only alternative that lets us use -B is
to have a separate multipathd.service file that dracut uses for the
initramfs.  This seems like more work than it's worth.

Instead, this patch pulls some code from systemd to detect if multipathd
is running in the initramfs.  If it is, and if new_bindings_in_boot is
not set, multipathd will set the bindings file to read-only, just like
the -B option does.

Cc: "Stewart, Sean" <Sean.Stewart@netapp.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c    |  4 ++++
 libmultipath/config.h    |  1 +
 libmultipath/configure.c |  3 +++
 libmultipath/dict.c      |  4 ++++
 libmultipath/util.c      | 30 ++++++++++++++++++++++++++++++
 libmultipath/util.h      |  1 +
 6 files changed, 43 insertions(+)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index cfcc685..f0aae53 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -621,6 +621,7 @@ load_config (char * file, struct udev *udev)
 	conf->uid_attribute = set_default(DEFAULT_UID_ATTRIBUTE);
 	conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
 	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
+	conf->new_bindings_in_boot = 0;
 
 	/*
 	 * preload default hwtable
@@ -735,6 +736,9 @@ load_config (char * file, struct udev *udev)
 	    !conf->wwids_file)
 		goto out;
 
+	 if (conf->new_bindings_in_boot == 0 && in_initrd())
+		conf->bindings_read_only = 1;
+
 	return 0;
 out:
 	free_config(conf);
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 372eace..05f1f6d 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -137,6 +137,7 @@ struct config {
 	int uxsock_timeout;
 	int retrigger_tries;
 	int retrigger_delay;
+	int new_bindings_in_boot;
 	unsigned int version[3];
 
 	char * dev;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 24ad948..3559c01 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -421,6 +421,9 @@ select_action (struct multipath * mpp, vector curmp, int force_reload)
 		condlog(2, "%s: unable to rename %s to %s (%s is used by %s)",
 			mpp->wwid, cmpp->alias, mpp->alias,
 			mpp->alias, cmpp_by_name->wwid);
+		/* reset alias to existing alias */
+		FREE(mpp->alias);
+		mpp->alias = STRDUP(cmpp->alias);
 		mpp->action = ACT_NOTHING;
 		return;
 	}
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index e3bc67e..1952b1e 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -395,6 +395,9 @@ declare_def_snprint(retrigger_tries, print_int)
 declare_def_handler(retrigger_delay, set_int)
 declare_def_snprint(retrigger_delay, print_int)
 
+declare_def_handler(new_bindings_in_boot, set_yes_no)
+declare_def_snprint(new_bindings_in_boot, print_yes_no)
+
 static int
 def_config_dir_handler(vector strvec)
 {
@@ -1373,6 +1376,7 @@ init_keywords(void)
 	install_keyword("uxsock_timeout", &def_uxsock_timeout_handler, &snprint_def_uxsock_timeout);
 	install_keyword("retrigger_tries", &def_retrigger_tries_handler, &snprint_def_retrigger_tries);
 	install_keyword("retrigger_delay", &def_retrigger_delay_handler, &snprint_def_retrigger_delay);
+	install_keyword("new_bindings_in_boot", &def_new_bindings_in_boot_handler, &snprint_def_new_bindings_in_boot);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/util.c b/libmultipath/util.c
index ac0d1b2..fcab5fc 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -3,6 +3,8 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <unistd.h>
+#include <sys/vfs.h>
+#include <linux/magic.h>
 
 #include "debug.h"
 #include "memory.h"
@@ -258,3 +260,31 @@ dev_t parse_devt(const char *dev_t)
 
 	return makedev(maj, min);
 }
+
+/* This define was taken from systemd. src/shared/macro.h */
+#define F_TYPE_EQUAL(a, b) (a == (typeof(a)) b)
+
+/* This function was taken from systemd. src/shared/util.c */
+int in_initrd(void) {
+	static int saved = -1;
+	struct statfs s;
+
+	if (saved >= 0)
+		return saved;
+
+	/* We make two checks here:
+	 *
+	 * 1. the flag file /etc/initrd-release must exist
+	 * 2. the root file system must be a memory file system
+	 * The second check is extra paranoia, since misdetecting an
+	 * initrd can have bad bad consequences due the initrd
+	 * emptying when transititioning to the main systemd.
+	 */
+
+	saved = access("/etc/initrd-release", F_OK) >= 0 &&
+		statfs("/", &s) >= 0 &&
+		(F_TYPE_EQUAL(s.f_type, TMPFS_MAGIC) ||
+		 F_TYPE_EQUAL(s.f_type, RAMFS_MAGIC));
+
+	return saved;
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 257912c..a1404f2 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -10,6 +10,7 @@ size_t strlcat(char *dst, const char *src, size_t size);
 int devt2devname (char *, int, char *);
 dev_t parse_devt(const char *dev_t);
 char *convert_dev(char *dev, int is_path_device);
+int in_initrd(void);
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
-- 
1.8.3.1
