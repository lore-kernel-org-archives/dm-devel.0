From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] stripe_width should be sector_t
Date: Thu, 27 Jan 2005 20:54:20 +0000
Message-ID: <20050127205420.GZ14093@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

stripe_width should be sector_t
--- diff/drivers/md/dm-stripe.c	2005-01-27 20:26:39.000000000 +0000
+++ source/drivers/md/dm-stripe.c	2005-01-27 20:26:32.000000000 +0000
@@ -21,7 +21,7 @@
 	uint32_t stripes;
 
 	/* The size of this target / num. stripes */
-	uint32_t stripe_width;
+	sector_t stripe_width;
 
 	/* stripe chunk size */
 	uint32_t chunk_shift;

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
