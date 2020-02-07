From: Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 1/1] libmultipath: fix files read from config_dir
Date: Fri,  7 Feb 2020 11:45:25 -0300
Message-ID: <20200207144525.16341-1-ematsumiya@suse.de>
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
To: christophe.varoqui@opensvc.com
Cc: Enzo Matsumiya <ematsumiya@suse.de>, dm-devel@redhat.com, Martin.Wilck@suse.com
List-Id: dm-devel.ids

If config_dir contains a file named, for example, "some.conf.backup", this file
will still be loaded by multipath because process_config_dir()
(libmultipath/config.c) uses strstr() to check for the ".conf" extension, but
that doesn't guarantee that ".conf" is at the end of the filename.

This patch will make sure that only files ending in ".conf" are loaded from
config_dir.

This is to comply with config_dir entry description in man 5 multipath.conf.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 libmultipath/config.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 20e3b8bf..4785ade8 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -671,8 +671,11 @@ process_config_dir(struct config *conf, vector keywords, char *dir)
 	sr.n = n;
 	pthread_cleanup_push_cast(free_scandir_result, &sr);
 	for (i = 0; i < n; i++) {
-		if (!strstr(namelist[i]->d_name, ".conf"))
+		char *ext = strrchr(namelist[i]->d_name, '.');
+
+		if (!ext || strcmp(ext, ".conf"))
 			continue;
+
 		old_hwtable_size = VECTOR_SIZE(conf->hwtable);
 		snprintf(path, LINE_MAX, "%s/%s", dir, namelist[i]->d_name);
 		path[LINE_MAX-1] = '\0';
-- 
2.16.4
