From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-bufio: initialize read-only module
	parameters
Date: Thu, 5 Dec 2013 17:33:29 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1312051732300.2574@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Some module parameters in dm-bufio are read-only. These parameters inform
the user about memory consumption. They are not supposed to be changed by
the user.

However, despite being read-only, these parameters can be set on modprobe
or insmod command line, for example:
modprobe dm-bufio current_allocated_bytes=12345

The kernel doesn't expect that these variables can be non-zero at module
initialization and if the user sets them, it results in BUG.

This patch initializates the variables in the module init routine, so that
user-supplied values are ignored.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org	# 3.2+

---
 drivers/md/dm-bufio.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-3.13-rc2/drivers/md/dm-bufio.c
===================================================================
--- linux-3.13-rc2.orig/drivers/md/dm-bufio.c	2013-12-05 23:23:02.000000000 +0100
+++ linux-3.13-rc2/drivers/md/dm-bufio.c	2013-12-05 23:26:37.000000000 +0100
@@ -1717,6 +1717,11 @@ static int __init dm_bufio_init(void)
 {
 	__u64 mem;
 
+	dm_bufio_allocated_kmem_cache = 0;
+	dm_bufio_allocated_get_free_pages = 0;
+	dm_bufio_allocated_vmalloc = 0;
+	dm_bufio_current_allocated = 0;
+
 	memset(&dm_bufio_caches, 0, sizeof dm_bufio_caches);
 	memset(&dm_bufio_cache_names, 0, sizeof dm_bufio_cache_names);
 
