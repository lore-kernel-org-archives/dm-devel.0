From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/4] kpartx: fail if dup() of dasd file
	descriptor fails
Date: Fri, 17 May 2019 11:14:08 -0500
Message-ID: <1558109650-21179-3-git-send-email-bmarzins@redhat.com>
References: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

If kpartx fails to create a copy of the dasd file descriptor, it should
fail, instead of treating the error value as a valid fd. Found by
coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/dasd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 61b609a5..d95d8ca0 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -138,6 +138,8 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 			return -1;
 	} else {
 		fd_dasd = dup(fd);
+		if (fd_dasd < 0)
+			return -1;
 	}
 
 	if (ioctl(fd_dasd, BIODASDINFO, (unsigned long)&info) != 0) {
-- 
2.17.2
