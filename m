From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 01/12] kpartx(coverity): fix resource leak warning
Date: Tue,  8 Jan 2019 23:53:58 +0100
Message-ID: <20190108225409.15977-2-mwilck@suse.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This was an easy-to-fix false positive.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/dasd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 94ae81b..fb358ad 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -137,7 +137,7 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 			/* Not a DASD */
 			return -1;
 	} else {
-		fd_dasd = fd;
+		fd_dasd = dup(fd);
 	}
 
 	if (ioctl(fd_dasd, BIODASDINFO, (unsigned long)&info) != 0) {
@@ -288,7 +288,6 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 out:
 	if (data != NULL)
 		free(data);
-	if (fd_dasd != -1 && fd_dasd != fd)
-		close(fd_dasd);
+	close(fd_dasd);
 	return retval;
 }
-- 
2.19.2
