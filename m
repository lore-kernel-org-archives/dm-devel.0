From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/30] Correctly print out 'max' for max_fds
Date: Tue, 16 Jul 2013 09:13:07 +0200
Message-ID: <1373958801-103613-17-git-send-email-hare@suse.de>
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

If the value specified for 'max_fds' is the system-wide limit
we should be printing out 'max', and not that value.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/dict.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index b747fcd..6a58fa2 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -2565,10 +2565,16 @@ snprint_def_rr_min_io_rq (char * buff, int len, void * data)
 static int
 snprint_max_fds (char * buff, int len, void * data)
 {
+	int r = 0, max_fds;
+
 	if (!conf->max_fds)
 		return 0;
 
-	return snprintf(buff, len, "%d", conf->max_fds);
+	r = get_sys_max_fds(&max_fds);
+	if (!r && max_fds == conf->max_fds)
+		return snprintf(buff, len, "\"max\"");
+	else
+		return snprintf(buff, len, "%d", conf->max_fds);
 }
 
 static int
-- 
1.7.12.4
