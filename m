From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 28/39] kpartx: Handle errors from lseek()
Date: Thu, 16 Jun 2016 11:47:34 +0200
Message-ID: <1466070465-1021-29-git-send-email-hare@suse.de>
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
 kpartx/gpt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 5a54970..3dac605 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -206,9 +206,10 @@ read_lba(int fd, uint64_t lba, void *buffer, size_t bytes)
 	int sector_size = get_sector_size(fd);
 	off_t offset = lba * sector_size;
 	uint64_t lastlba;
-        ssize_t bytesread;
+	ssize_t bytesread;
 
-	lseek(fd, offset, SEEK_SET);
+	if (lseek(fd, offset, SEEK_SET) < 0)
+		return 0;
 	bytesread = read(fd, buffer, bytes);
 
 	lastlba = last_lba(fd);
-- 
2.6.6
