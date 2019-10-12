From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 31/72] kpartx: gpt: remove unused arg in
	read_lastoddsector()
Date: Sat, 12 Oct 2019 21:28:16 +0000
Message-ID: <20191012212703.12989-32-martin.wilck@suse.com>
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
 kpartx/gpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index e31611a3..f3216ba2 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -182,7 +182,7 @@ last_lba(int filedes)
 
 
 static ssize_t
-read_lastoddsector(int fd, uint64_t lba, void *buffer, size_t count)
+read_lastoddsector(int fd, void *buffer, size_t count)
 {
 	int rc;
 	struct blkdev_ioctl_param ioctl_param;
@@ -221,7 +221,7 @@ read_lba(int fd, uint64_t lba, void *buffer, size_t bytes)
 	   one sector, so we don't have to be fancy.
 	*/
 	if (!bytesread && !(lastlba & 1) && lba == lastlba) {
-		bytesread = read_lastoddsector(fd, lba, buffer, bytes);
+		bytesread = read_lastoddsector(fd, buffer, bytes);
 	}
 	return bytesread;
 }
-- 
2.23.0
