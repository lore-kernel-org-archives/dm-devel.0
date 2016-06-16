From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/39] libmpathpersist: Handle send error
Date: Thu, 16 Jun 2016 11:47:28 +0200
Message-ID: <1466070465-1021-23-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_updatepr.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index bda8991..0529d13 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -33,10 +33,14 @@ int update_prflag(char * arg1, char * arg2, int noisy)
 
 	snprintf(str,sizeof(str),"map %s %s", arg1, arg2);
 	condlog (2, "%s: pr flag message=%s", arg1, str);
-	send_packet(fd, str);
+	if (send_packet(fd, str) != 0) {
+		condlog(2, "%s: message=%s send error=%d", arg1, str, errno);
+		mpath_disconnect(fd);
+		return -2;
+	}
 	ret = recv_packet(fd, &reply, DEFAULT_REPLY_TIMEOUT);
 	if (ret < 0) {
-		condlog(2, "%s: message=%s error=%d", arg1, str, errno);
+		condlog(2, "%s: message=%s recv error=%d", arg1, str, errno);
 		ret = -2;
 	} else {
 		condlog (2, "%s: message=%s reply=%s", arg1, str, reply);
-- 
2.6.6
