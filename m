From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/2] dm flakey: document that default I/O error
	is only for write (resend)
Date: Wed, 13 Jan 2016 01:51:43 +0900
Message-ID: <56952c88.020d620a.94f42.2f0d@mx.google.com>
References: <1452617503-18220-1-git-send-email-y>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1452617503-18220-1-git-send-email-y>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, mpatocka@redhat.com
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>

.map of dm-flakey with no optional feature parameters specified
results in -EIO only for writes during down time. Read bios are
submitted as usual whether it's in up or down time.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 Documentation/device-mapper/dm-flakey.txt |    2 +-
 drivers/md/dm-flakey.c                    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/device-mapper/dm-flakey.txt b/Documentation/device-mapper/dm-flakey.txt
index 6ff5c23..c171706 100644
--- a/Documentation/device-mapper/dm-flakey.txt
+++ b/Documentation/device-mapper/dm-flakey.txt
@@ -27,7 +27,7 @@ Mandatory parameters:
 
 Optional feature parameters:
   If no feature parameters are present, during the periods of
-  unreliability, all I/O returns errors.
+  unreliability, all write I/O returns errors.
 
   drop_writes:
 	All write I/O is silently ignored.
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 09e2afc..8da73ac 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -312,7 +312,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 		}
 
 		/*
-		 * By default, error all I/O.
+		 * By default, error all write I/O.
 		 */
 		return -EIO;
 	}
-- 
1.7.1
