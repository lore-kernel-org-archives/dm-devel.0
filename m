From: Gris Ge <fge@redhat.com>
Subject: [PATCH 1/3] multipath-tools: Remove the limitation of
	IPC command reply length.
Date: Wed, 16 Aug 2017 20:34:07 +0800
Message-ID: <20170816123409.16535-1-fge@redhat.com>
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
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

Issue:
    libmpathcmd will reply error 22(Invalid argument) when having 1000
    mpath.

Root cause:
    libmpathcmd return error when reply string length exceeded the 65535.

Fix:
    Remove the limitation on reply data length.

Extra:
    Initially this limitation was removed and improved by commit
    bb219efb131aef61c331f181193bf1d80e6b2a99
    but then was added back via commit
    7381c3f2b19903cc56d1ddafb13e8ad3afc08580

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libmpathcmd/mpath_cmd.c | 4 ----
 libmpathcmd/mpath_cmd.h | 1 -
 2 files changed, 5 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 1496b682..af618cff 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -142,10 +142,6 @@ int mpath_recv_reply(int fd, char **reply, unsigned int timeout)
 	len = mpath_recv_reply_len(fd, timeout);
 	if (len <= 0)
 		return len;
-	if (len > MAX_REPLY_LEN) {
-		errno = EINVAL;
-		return -1;
-	}
 	*reply = malloc(len);
 	if (!*reply)
 		return -1;
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index 6534474c..b57b708b 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -26,7 +26,6 @@ extern "C" {
 
 #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
 #define DEFAULT_REPLY_TIMEOUT	4000
-#define MAX_REPLY_LEN		65536
 
 
 /*
-- 
2.14.1
