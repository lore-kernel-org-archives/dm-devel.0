From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: [PATCH] fix hard-coded disk header chunk size for persistent snapshot
Date: Wed, 12 May 2010 10:29:22 +0900
Message-ID: <4BEA0472.1060300@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, agk@redhat.com
Cc: linux-kernel@vger.kernel.org, kusumi.tomohiro@jp.fujitsu.com
List-Id: dm-devel.ids

Hi,

This patch fixes hard-coded value for the size of a chunk that includes
disk header for persistent snapshot. It should be changed to existing
macro NUM_SNAPSHOT_HDR_CHUNKS instead of using hard-coded value 1.

Thanks,
Tomohiro Kusumi


Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
---

diff -aNur linux-2.6.34-rc7.org/drivers/md/dm-snap-persistent.c linux-2.6.34-rc7/drivers/md/dm-snap-persistent.c
--- linux-2.6.34-rc7.org/drivers/md/dm-snap-persistent.c        2010-05-10 10:36:28.000000000 +0900
+++ linux-2.6.34-rc7/drivers/md/dm-snap-persistent.c    2010-05-12 09:21:50.000000000 +0900
@@ -266,7 +266,7 @@
  */
 static chunk_t area_location(struct pstore *ps, chunk_t area)
 {
-       return 1 + ((ps->exceptions_per_area + 1) * area);
+       return NUM_SNAPSHOT_HDR_CHUNKS + ((ps->exceptions_per_area + 1) * area);
 }
 
 /*
