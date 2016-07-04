From: Gris Ge <fge@redhat.com>
Subject: [PATCH V5 2/3] multipath-tools: Set errno
	mpath_recv_reply() when failure
Date: Mon,  4 Jul 2016 17:40:11 +0800
Message-ID: <20160704094012.121934-3-fge@redhat.com>
References: <20160704091704.119896-1-fge@redhat.com>
	<20160704094012.121934-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160704094012.121934-1-fge@redhat.com>
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

Enforce what mpath_cmd.h states "-1 on failure (with errno set)" for
mpath_recv_reply() by set errno and return -1 on failure.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libmpathcmd/mpath_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 1aaf5ea..d92a461 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -141,7 +141,7 @@ int mpath_recv_reply(int fd, char **reply, unsigned int timeout)
 	*reply = NULL;
 	len = mpath_recv_reply_len(fd, timeout);
 	if (len <= 0)
-		return len;
+		return -1;
 	*reply = malloc(len);
 	if (!*reply)
 		return -1;
@@ -149,7 +149,7 @@ int mpath_recv_reply(int fd, char **reply, unsigned int timeout)
 	if (err) {
 		free(*reply);
 		*reply = NULL;
-		return err;
+		return -1;
 	}
 	return 0;
 }
-- 
2.9.0
