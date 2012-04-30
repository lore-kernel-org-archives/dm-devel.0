From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/16] Remove stale variable in
	sysfs_attr_get_value
Date: Mon, 30 Apr 2012 12:25:59 +0200
Message-ID: <1335781568-13299-9-git-send-email-hare@suse.de>
References: <1335781568-13299-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1335781568-13299-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/sysfs.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 16dce4a..13af8a1 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -287,7 +287,6 @@ size_t sysfs_attr_get_value(const char *devpath, const char *attr_name,
 			    char *attr_value, int attr_len)
 {
 	char path_full[PATH_SIZE];
-	const char *path;
 	struct stat statbuf;
 	int fd;
 	ssize_t size;
@@ -303,7 +302,7 @@ size_t sysfs_attr_get_value(const char *devpath, const char *attr_name,
 	sysfs_len = strlcpy(path_full, sysfs_path, sizeof(path_full));
 	if(sysfs_len >= sizeof(path_full))
 		sysfs_len = sizeof(path_full) - 1;
-	path = &path_full[sysfs_len];
+
 	strlcat(path_full, devpath, sizeof(path_full));
 	strlcat(path_full, "/", sizeof(path_full));
 	strlcat(path_full, attr_name, sizeof(path_full));
-- 
1.7.3.4
