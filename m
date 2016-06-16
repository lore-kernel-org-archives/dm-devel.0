From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/39] kpartx: fixup filedescriptor leak in
	set_loop()
Date: Thu, 16 Jun 2016 11:47:32 +0200
Message-ID: <1466070465-1021-27-git-send-email-hare@suse.de>
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

Upon error 'ffd' was never closed.
Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 kpartx/lopart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kpartx/lopart.c b/kpartx/lopart.c
index e7f6090..5495e27 100644
--- a/kpartx/lopart.c
+++ b/kpartx/lopart.c
@@ -252,6 +252,7 @@ set_loop (const char *device, const char *file, int offset, int *loopro)
 	}
 
 	if ((fd = open (device, mode)) < 0) {
+		close(ffd);
 		perror (device);
 		return 1;
 	}
-- 
2.6.6
