From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/39] libmultipath/uevent.c: handle errors from
	setsockopt()
Date: Thu, 16 Jun 2016 11:47:18 +0200
Message-ID: <1466070465-1021-13-git-send-email-hare@suse.de>
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
 libmultipath/uevent.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index fb8b4a7..ff4bc86 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -291,8 +291,12 @@ int failback_listen(void)
 		}
 
 		/* enable receiving of the sender credentials */
-		setsockopt(sock, SOL_SOCKET, SO_PASSCRED,
-			   &feature_on, sizeof(feature_on));
+		retval = setsockopt(sock, SOL_SOCKET, SO_PASSCRED,
+				    &feature_on, sizeof(feature_on));
+		if (retval < 0) {
+			condlog(0, "failed to enable credential passing, exit");
+			goto exit;
+		}
 
 	} else {
 		/* Fallback to read kernel netlink events */
@@ -330,8 +334,11 @@ int failback_listen(void)
 		condlog(3, "receive buffer size for socket is %u.", rcvsz);
 
 		/* enable receiving of the sender credentials */
-		setsockopt(sock, SOL_SOCKET, SO_PASSCRED,
-			   &feature_on, sizeof(feature_on));
+		if (setsockopt(sock, SOL_SOCKET, SO_PASSCRED,
+			       &feature_on, sizeof(feature_on)) < 0) {
+			condlog(0, "error on enabling credential passing for socket");
+			exit(1);
+		}
 
 		retval = bind(sock, (struct sockaddr *) &snl,
 			      sizeof(struct sockaddr_nl));
-- 
2.6.6
