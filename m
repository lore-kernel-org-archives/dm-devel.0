From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] multipathd: fix -Wpointer-to-int-cast warning in
	uxlsnr
Date: Tue,  6 Mar 2018 22:25:12 +0100
Message-ID: <20180306212512.3178-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Chongyun Wu <wu.chongyun@h3c.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Fixes: "multipathd: release uxsocket and resource when cancel thread"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/uxlsnr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 0531061912b3..cdafd82943e7 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -148,7 +148,7 @@ void uxsock_cleanup(void *arg)
 {
 	struct client *client_loop;
 	struct client *client_tmp;
-	int ux_sock = (int)arg;
+	long ux_sock = (long)arg;
 
 	close(ux_sock);
 
@@ -167,7 +167,7 @@ void uxsock_cleanup(void *arg)
  */
 void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 {
-	int ux_sock;
+	long ux_sock;
 	int rlen;
 	char *inbuf;
 	char *reply;
-- 
2.16.1
