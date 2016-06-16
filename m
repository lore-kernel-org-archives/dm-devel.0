From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/39] libmpathcmd: limit size of the CLI buffer
Date: Thu, 16 Jun 2016 11:47:24 +0200
Message-ID: <1466070465-1021-19-git-send-email-hare@suse.de>
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

A malicious program might inject a large buffer via the CLI and
causing the daemon to abort due to OOM.
So limit the maximum CLI buffer size to 64k.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathcmd/mpath_cmd.c | 2 ++
 libmpathcmd/mpath_cmd.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 1aaf5ea..2290ecb 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -142,6 +142,8 @@ int mpath_recv_reply(int fd, char **reply, unsigned int timeout)
 	len = mpath_recv_reply_len(fd, timeout);
 	if (len <= 0)
 		return len;
+	if (len > MAX_REPLY_LEN)
+		return -EINVAL;
 	*reply = malloc(len);
 	if (!*reply)
 		return -1;
diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index 4ec0291..f33f000 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -28,6 +28,7 @@ extern "C" {
 
 #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
 #define DEFAULT_REPLY_TIMEOUT	1000
+#define MAX_REPLY_LEN		65536
 
 
 /*
-- 
2.6.6
