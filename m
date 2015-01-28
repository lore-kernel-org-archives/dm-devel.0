From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH 1/2] init: Stricter checking of major:minor root=
	values
Date: Wed, 28 Jan 2015 14:45:56 -0800
Message-ID: <1422485157-33423-1-git-send-email-dehrenberg@chromium.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
Cc: grundler@chromium.org, drewry@chromium.org, gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-Id: dm-devel.ids

In the kernel command-line, previously, root=1:2jakshflaksjdhfa would
be accepted and interpreted just like root=1:2. This patch adds
stricter checking so that additional characters after major:minor are
rejected by root=.

The patch also makes name_to_dev_t take a const char * rather than a
char * for improved possibilities for checking const correctness.

The goal of this patch is to help in unifying dm's interpretation of
its block device argument with the interpretation in other parts of
the kernel. dm rejects malformed major:minor pairs, and it seems
reasonable that root= should reject them as well.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 include/linux/mount.h | 2 +-
 init/do_mounts.c      | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/mount.h b/include/linux/mount.h
index c2c561d..bca086d 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -92,6 +92,6 @@ extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
 extern void mark_mounts_for_expiry(struct list_head *mounts);
 
-extern dev_t name_to_dev_t(char *name);
+extern dev_t name_to_dev_t(const char *name);
 
 #endif /* _LINUX_MOUNT_H */
diff --git a/init/do_mounts.c b/init/do_mounts.c
index eb41008..7e06620 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -207,7 +207,7 @@ done:
  *	bangs.
  */
 
-dev_t name_to_dev_t(char *name)
+dev_t name_to_dev_t(const char *name)
 {
 	char s[32];
 	char *p;
@@ -226,8 +226,9 @@ dev_t name_to_dev_t(char *name)
 
 	if (strncmp(name, "/dev/", 5) != 0) {
 		unsigned maj, min;
+		char dummy;
 
-		if (sscanf(name, "%u:%u", &maj, &min) == 2) {
+		if (sscanf(name, "%u:%u%c", &maj, &min, &dummy) == 2) {
 			res = MKDEV(maj, min);
 			if (maj != MAJOR(res) || min != MINOR(res))
 				goto fail;
-- 
2.2.0.rc0.207.ga3a616c
