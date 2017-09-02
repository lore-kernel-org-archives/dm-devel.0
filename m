From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 08/31] kpartx: only recognize dasd part table on
	DASD
Date: Sun,  3 Sep 2017 00:38:37 +0200
Message-ID: <20170902223900.7339-9-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The code for reading DASD partition tables is so generic
that it will pretend to find a partition even on a totally
zeroed disk. Prevent that by recognizing dasd partition tables
only on DASD disks. Such a check was already present for DM
mappings on DASD, but (strangely) not for DASD itself.

Without this, kpartx will (try to) create a partition mapping
on a loop device with no partition table.

Found this during testing because test-kpartx unexpectedly
succeeded without my "fix part deletion without partition table" fix
when run on a loop device. That was caused by this bug pretending an
existing partition table although there was none.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/dasd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index f50c1bdb..e418d5ac 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -133,6 +133,9 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 			/* Couldn't open the device */
 			return -1;
 		}
+	} else if ((unsigned int)major(sbuf.st_rdev) != 94) {
+			/* Not a DASD */
+			return -1;
 	} else {
 		fd_dasd = fd;
 	}
-- 
2.14.0
