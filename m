From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] proper extern for mdp_major
Date: Mon, 14 Apr 2008 21:41:51 +0300
Message-ID: <20080414184151.GY6695@cs181133002.pp.htv.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch adds a proper extern for mdp_major in include/linux/raid/md.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008

 include/linux/raid/md.h |    2 ++
 init/do_mounts_md.c     |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

1eeb5848dc2a1c4ecb179fba4ac3db377c35ef40 diff --git a/include/linux/raid/md.h b/include/linux/raid/md.h
index fbaeda7..20b694f 100644
--- a/include/linux/raid/md.h
+++ b/include/linux/raid/md.h
@@ -73,6 +73,8 @@
  */
 #define MD_PATCHLEVEL_VERSION           3
 
+extern int mdp_major;
+
 extern int register_md_personality (struct mdk_personality *p);
 extern int unregister_md_personality (struct mdk_personality *p);
 extern mdk_thread_t * md_register_thread (void (*run) (mddev_t *mddev),
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 753dc54..9589e99 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -24,7 +24,6 @@ static struct {
 
 static int md_setup_ents __initdata;
 
-extern int mdp_major;
 /*
  * Parse the command-line parameters given our kernel, but do not
  * actually try to invoke the MD device now; that is handled by
