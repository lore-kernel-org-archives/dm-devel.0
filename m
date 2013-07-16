From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/30] Correctly set max_fds in case of failure
Date: Tue, 16 Jul 2013 09:13:08 +0200
Message-ID: <1373958801-103613-18-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

If we fail to get the system limit for max_fds we should assume
a safe value of 4096.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/dict.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 6a58fa2..4b840de 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -290,18 +290,27 @@ static int
 max_fds_handler(vector strvec)
 {
 	char * buff;
-	int r = 0;
+	int r = 0, max_fds;
 
 	buff = set_value(strvec);
 
 	if (!buff)
 		return 1;
 
+	r = get_sys_max_fds(&max_fds);
+	if (r) {
+		/* Assume safe limit */
+		max_fds = 4096;
+	}
 	if (strlen(buff) == 3 &&
 	    !strcmp(buff, "max"))
-		r = get_sys_max_fds(&conf->max_fds);
+		conf->max_fds = max_fds;
 	else
 		conf->max_fds = atoi(buff);
+
+	if (conf->max_fds > max_fds)
+		conf->max_fds = max_fds;
+
 	FREE(buff);
 
 	return r;
@@ -2571,7 +2580,7 @@ snprint_max_fds (char * buff, int len, void * data)
 		return 0;
 
 	r = get_sys_max_fds(&max_fds);
-	if (!r && max_fds == conf->max_fds)
+	if (!r && conf->max_fds >= max_fds)
 		return snprintf(buff, len, "\"max\"");
 	else
 		return snprintf(buff, len, "%d", conf->max_fds);
-- 
1.7.12.4
