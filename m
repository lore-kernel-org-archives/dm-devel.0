From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 33/39] multipathd: missing mpath_disconnect() in
	uxclnt()
Date: Thu, 16 Jun 2016 11:47:39 +0200
Message-ID: <1466070465-1021-34-git-send-email-hare@suse.de>
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

We should be calling mpath_disconnect() in uxclnt().
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/uxclnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 06c1bf8..37afaac 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -135,6 +135,6 @@ int uxclnt(char * inbuf, unsigned int timeout)
 		process_req(fd, inbuf, timeout);
 	else
 		process(fd, timeout);
-
+	mpath_disconnect(fd);
 	return 0;
 }
-- 
2.6.6
