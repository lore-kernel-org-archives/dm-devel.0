From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 09/19] libmultipath: make close_fd() a common
	helper
Date: Wed, 19 Dec 2018 00:19:21 +0100
Message-ID: <20181218231931.10762-10-mwilck@suse.com>
References: <20181218231931.10762-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181218231931.10762-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

move close_fd() into util.c.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/sysfs.c | 5 -----
 libmultipath/util.c  | 5 +++++
 libmultipath/util.h  | 2 ++
 multipath/main.c     | 4 ----
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 558c8d6a..65904d7b 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -295,11 +295,6 @@ static int select_dm_devs(const struct dirent *di)
 	return fnmatch("dm-*", di->d_name, FNM_FILE_NAME) == 0;
 }
 
-static void close_fd(void *arg)
-{
-	close((long)arg);
-}
-
 bool sysfs_is_multipathed(const struct path *pp)
 {
 	char pathbuf[PATH_MAX];
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 28eb7577..944c632e 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -506,3 +506,8 @@ void free_scandir_result(struct scandir_result *res)
 		FREE(res->di[i]);
 	FREE(res->di);
 }
+
+void close_fd(void *arg)
+{
+	close((long)arg);
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index dea3fa04..1e0d832c 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -35,6 +35,8 @@ void set_max_fds(int max_fds);
 #define pthread_cleanup_push_cast(f, arg)		\
 	pthread_cleanup_push(((void (*)(void *))&f), (arg))
 
+void close_fd(void *arg);
+
 struct scandir_result {
 	struct dirent **di;
 	int n;
diff --git a/multipath/main.c b/multipath/main.c
index f40c179b..a25e1b4f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -388,10 +388,6 @@ enum {
 };
 
 static const char shm_find_mp_dir[] = MULTIPATH_SHM_BASE "find_multipaths";
-static void close_fd(void *arg)
-{
-	close((long)arg);
-}
 
 /**
  * find_multipaths_check_timeout(wwid, tmo)
-- 
2.19.2
