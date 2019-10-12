From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 54/72] libmpathcmd: fix -Wsign-compare warnings
Date: Sat, 12 Oct 2019 21:28:44 +0000
Message-ID: <20191012212703.12989-55-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/mpath_cmd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index f00bf7e1..60b2d965 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -96,7 +96,8 @@ static size_t write_all(int fd, const void *buf, size_t len)
  */
 int __mpath_connect(int nonblocking)
 {
-	int fd, len;
+	int fd;
+	size_t len;
 	struct sockaddr_un addr;
 	int flags = 0;
 
@@ -172,7 +173,7 @@ int mpath_recv_reply_data(int fd, char *reply, size_t len,
 	ret = read_all(fd, reply, len, timeout);
 	if (ret < 0)
 		return ret;
-	if (ret != len) {
+	if ((size_t)ret != len) {
 		errno = EIO;
 		return -1;
 	}
-- 
2.23.0
