From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/8] raid1 barriers
Date: Mon, 27 Apr 2009 07:45:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904270744220.18227@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904270701250.12459@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270743540.18227@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904270743540.18227@hs20-bc2-1.build.redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Accept empty barriers in dm-io.

dm-io will process empty write barrier requests just like the other
read/write requests.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm-io.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-io.c	2009-04-24 09:24:26.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-io.c	2009-04-24 09:27:07.000000000 +0200
@@ -285,8 +285,12 @@ static void do_region(int rw, unsigned r
 	unsigned offset;
 	unsigned num_bvecs;
 	sector_t remaining = where->count;
+	/*
+	 * "count" may be zero when "rw" indicates a write barrier request.
+	 * In this case, we must send a zero-sized barrier.
+	 */
 
-	while (remaining) {
+	do {
 		/*
 		 * Allocate a suitably sized-bio: we add an extra
 		 * bvec for bio_get/set_region() and decrement bi_max_vecs
@@ -323,7 +327,7 @@ static void do_region(int rw, unsigned r
 
 		atomic_inc(&io->count);
 		submit_bio(rw, bio);
-	}
+	} while (remaining);
 }
 
 static void dispatch_io(int rw, unsigned int num_regions,
@@ -342,7 +346,7 @@ static void dispatch_io(int rw, unsigned
 	 */
 	for (i = 0; i < num_regions; i++) {
 		*dp = old_pages;
-		if (where[i].count)
+		if (where[i].count || (rw & (1 << BIO_RW_BARRIER)))
 			do_region(rw, i, where + i, dp, io);
 	}
 
