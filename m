From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 1/2] dm stripe: document that chunk size is
	specified in sectors
Date: Thu, 19 Nov 2015 03:13:07 +0900
Message-ID: <1447870388-14437-1-git-send-email-kusumi.tomohiro@gmail.com>
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
It sounds like one specifies it in a number like 4096.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 Documentation/device-mapper/striped.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/device-mapper/striped.txt b/Documentation/device-mapper/striped.txt
index 45f3b91..66a7671 100644
--- a/Documentation/device-mapper/striped.txt
+++ b/Documentation/device-mapper/striped.txt
@@ -9,8 +9,8 @@ devices in parallel.
 
 Parameters: <num devs> <chunk size> [<dev path> <offset>]+
     <num devs>: Number of underlying devices.
-    <chunk size>: Size of each chunk of data. Must be at least as
-                  large as the system's PAGE_SIZE.
+    <chunk size>: Size of each chunk of data in sector. Must be
+                  at least as large as the system's PAGE_SIZE.
     <dev path>: Full pathname to the underlying block-device, or a
                 "major:minor" device-number.
     <offset>: Starting sector within the device.
-- 
1.7.1
