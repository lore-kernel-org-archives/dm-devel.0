From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 03:55:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200355330.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

dm-target-flush-option.patch

Two variables for targets.

Target driver can change num_flush_requests and signal that it wants
to receive flushes. It receives num_flush_requests flushes, individual
flushes are differentiated by map_info->flush_request (which goes from
0 to num_flush_requests - 1).

Old targets without flush support won't receive any flush requests.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/device-mapper.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.30-rc1-devel/include/linux/device-mapper.h
===================================================================
--- linux-2.6.30-rc1-devel.orig/include/linux/device-mapper.h	2009-04-10 06:32:54.000000000 +0200
+++ linux-2.6.30-rc1-devel/include/linux/device-mapper.h	2009-04-10 06:33:26.000000000 +0200
@@ -21,6 +21,7 @@ typedef enum { STATUSTYPE_INFO, STATUSTY
 union map_info {
 	void *ptr;
 	unsigned long long ll;
+	unsigned flush_request;
 };
 
 /*
@@ -168,6 +169,16 @@ struct dm_target {
 	sector_t split_io;
 
 	/*
+	 * A number of zero-length barrier requests that will be submitted
+	 * to the target for the purpose of flushing cache.
+	 *
+	 * The request number will be placed in union map_info->flush_request.
+	 * It is a responsibility of the target driver to remap these requests
+	 * to the real underlying devices.
+	 */
+	unsigned num_flush_requests;
+
+	/*
 	 * These are automatically filled in by
 	 * dm_table_get_device.
 	 */
