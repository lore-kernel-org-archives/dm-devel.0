From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 03/18] Fix issues with user_friendly_names
	initramfs bindings
Date: Thu,  7 Apr 2016 18:19:57 -0500
Message-ID: <1460071212-21018-4-git-send-email-bmarzins@redhat.com>
References: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1460071212-21018-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
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
currently has. Second, it fixes the -B option to actually work
correctly, so that it can be started that way in the initramfs.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c    | 1 -
 libmultipath/configure.c | 3 +++
 multipathd/main.c        | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index cfcc685..005252b 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -601,7 +601,6 @@ load_config (char * file, struct udev *udev)
 	get_sys_max_fds(&conf->max_fds);
 	conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
 	conf->wwids_file = set_default(DEFAULT_WWIDS_FILE);
-	conf->bindings_read_only = 0;
 	conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
 	conf->features = set_default(DEFAULT_FEATURES);
 	conf->flush_on_last_del = 0;
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
diff --git a/multipathd/main.c b/multipathd/main.c
index 38a2b42..687c697 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1570,6 +1570,7 @@ reconfigure (struct vectors * vecs)
 	if (!load_config(DEFAULT_CONFIGFILE, udev)) {
 		dm_drv_version(conf->version, TGT_MPATH);
 		conf->verbosity = old->verbosity;
+		conf->bindings_read_only = old->bindings_read_only;
 		conf->daemon = 1;
 		configure(vecs, 1);
 		free_config(old);
-- 
1.8.3.1
