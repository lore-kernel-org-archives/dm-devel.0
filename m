From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH v2] dm stripe: document that chunk size is
	specified in sectors (resend)
Date: Thu, 14 Jan 2016 04:47:35 +0900
Message-ID: <1452714455-8510-1-git-send-email-kusumi.tomohiro@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: snitzer@redhat.com, mpatocka@redhat.com
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Mention it's in sector similar to f49e869.

> It is not required that the chunk size must be at least as
> large as the page size, so that sentence should be dropped too.

Also get rid of an obsolete sentence which mentions
chunk size must be >=PAGE_SIZE.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
---
 Documentation/device-mapper/striped.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/device-mapper/striped.txt b/Documentation/device-mapper/striped.txt
index 45f3b91..36695ad 100644
--- a/Documentation/device-mapper/striped.txt
+++ b/Documentation/device-mapper/striped.txt
@@ -9,8 +9,7 @@ devices in parallel.
 
 Parameters: <num devs> <chunk size> [<dev path> <offset>]+
     <num devs>: Number of underlying devices.
-    <chunk size>: Size of each chunk of data. Must be at least as
-                  large as the system's PAGE_SIZE.
+    <chunk size>: Size of each chunk of data in sectors.
     <dev path>: Full pathname to the underlying block-device, or a
                 "major:minor" device-number.
     <offset>: Starting sector within the device.
-- 
1.7.1
