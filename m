From: Christophe Saout <christophe@saout.de>
Subject: [stable][PATCH < 2.6.19] Fix data corruption with
	dm-crypt over RAID5
Date: Sat, 02 Dec 2006 03:27:56 +0100
Message-ID: <1165026476.29307.23.camel__11373.9606728361$1165106096$gmane$org@leto.intern.saout.de>
References: <456B732F.6080906@lelik.org>
	<20061129145208.GQ4409@agk.surrey.redhat.com>
	<456F46E3.6030702@lelik.org>
	<1164983209.24524.20.camel@leto.intern.saout.de>
	<20061201152143.GE4409@agk.surrey.redhat.com>
	<45704B95.3020308@lelik.org>
	<1165026116.29307.18.camel@leto.intern.saout.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1165026116.29307.18.camel@leto.intern.saout.de>
Resent-To: dm-devel@redhat.com
Resent-Message-Id: <E1GqfJb-0007Al-Vs@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>, dm-crypt@saout.de, Andrey <dm-crypt-revealed-address@lelik.org>, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com
List-Id: dm-devel.ids

Fix corruption issue with dm-crypt on top of software raid5. Cancelled
readahead bio's that report no error, just have BIO_UPTODATE cleared
were reported as successful reads to the higher layers (and leaving
random content in the buffer cache). Already fixed in 2.6.19.

Signed-off-by: Christophe Saout <christophe@saout.de>


--- linux-2.6.18.orig/drivers/md/dm-crypt.c	2006-09-20 05:42:06.000000000 +0200
+++ linux-2.6.18/drivers/md/dm-crypt.c	2006-12-02 03:03:36.000000000 +0100
@@ -717,13 +717,15 @@
 	if (bio->bi_size)
 		return 1;
 
+	if (!bio_flagged(bio, BIO_UPTODATE) && !error)
+		error = -EIO;
+                        
 	bio_put(bio);
 
 	/*
 	 * successful reads are decrypted by the worker thread
 	 */
-	if ((bio_data_dir(bio) == READ)
-	    && bio_flagged(bio, BIO_UPTODATE)) {
+	if (bio_data_dir(io->bio) == READ && !error) {
 		kcryptd_queue_io(io);
 		return 0;
 	}
