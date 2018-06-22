From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 6/6] libmultipath: fix gcc 8.1 "truncated output"
	warnings
Date: Sat, 23 Jun 2018 01:15:16 +0200
Message-ID: <20180622231516.18806-6-mwilck@suse.com>
References: <20180622231516.18806-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180622231516.18806-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Eli Qiao <taget@linux.vnet.ibm.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

gcc 8.1 was warning about a possibly truncated output in snprintf.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/sysfs.c | 4 ++--
 libmultipath/util.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 16e0a737..b7dacaad 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -239,7 +239,7 @@ sysfs_get_size (struct path *pp, unsigned long long * size)
 int sysfs_check_holders(char * check_devt, char * new_devt)
 {
 	unsigned int major, new_minor, table_minor;
-	char path[PATH_SIZE], check_dev[PATH_SIZE];
+	char path[PATH_MAX], check_dev[PATH_SIZE];
 	char * table_name;
 	DIR *dirfd;
 	struct dirent *holder;
@@ -256,7 +256,7 @@ int sysfs_check_holders(char * check_devt, char * new_devt)
 
 	condlog(3, "%s: checking holder", check_dev);
 
-	snprintf(path, PATH_SIZE, "/sys/block/%s/holders", check_dev);
+	snprintf(path, sizeof(path), "/sys/block/%s/holders", check_dev);
 	dirfd = opendir(path);
 	if (dirfd == NULL) {
 		condlog(3, "%s: failed to open directory %s (%d)",
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 7251ad08..aff74281 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -329,7 +329,7 @@ setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
 
 int systemd_service_enabled_in(const char *dev, const char *prefix)
 {
-	char path[PATH_SIZE], file[PATH_SIZE], service[PATH_SIZE];
+	char path[PATH_SIZE], file[PATH_MAX], service[PATH_SIZE];
 	DIR *dirfd;
 	struct dirent *d;
 	int found = 0;
@@ -356,7 +356,7 @@ int systemd_service_enabled_in(const char *dev, const char *prefix)
 		p = d->d_name + strlen(d->d_name) - 6;
 		if (strcmp(p, ".wants"))
 			continue;
-		snprintf(file, PATH_SIZE, "%s/%s/%s",
+		snprintf(file, sizeof(file), "%s/%s/%s",
 			 path, d->d_name, service);
 		if (stat(file, &stbuf) == 0) {
 			condlog(3, "%s: found %s", dev, file);
-- 
2.17.1
