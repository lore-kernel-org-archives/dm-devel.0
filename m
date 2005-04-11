From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH]  rm alloc_page from dm-emc take 2
Date: Mon, 11 Apr 2005 04:36:37 -0700
Message-ID: <425A6145.7010302@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020708020607090300060301"
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
To: Lars Marowsky-Bree <lmb@suse.de>, Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------020708020607090300060301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I am not sure if the first mail got sent out. Here is
the correct mail with the patch.

Hey Lars,

Here is what I meant. A Page for just something around 8-16 bytes
seems wasteful. Plus there is no reserve.

If you have to end up setting more bits maybe it is better to
preallocate a command per device at create time, or maybe since
there are four different combos I should have done it with this
patch?

This was made against 2.6.12-rc2. Only compile tested.

Mike

--------------020708020607090300060301
Content-Type: text/x-patch;
 name="preallocate-cmd.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="preallocate-cmd.patch"

--- linux-2.6.12-rc2/drivers/md/dm-emc.c.orig	2005-04-11 03:09:20.000000000 -0700
+++ linux-2.6.12-rc2/drivers/md/dm-emc.c	2005-04-11 04:27:08.000000000 -0700
@@ -28,13 +28,41 @@ struct emc_handler {
 #define TRESPASS_PAGE 0x22
 #define EMC_FAILOVER_TIMEOUT (60 * HZ)
 
-/* Code borrowed from dm-lsi-rdac by Mike Christie */
+static unsigned char emc_long_trespass[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x09,                 /* Page length - 2 */
+	0x81,		      /* Trespass code + Honor reservation bit */
+	0xff, 0xff,           /* Trespass target */
+	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
+};
 
-static inline void free_bio(struct bio *bio)
-{
-	__free_page(bio->bi_io_vec[0].bv_page);
-	bio_put(bio);
-}
+static unsigned char emc_long_trespass_hr[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x09,                 /* Page length - 2 */
+	0x01,		      /* Trespass code + Honor reservation bit */
+	0xff, 0xff,           /* Trespass target */
+	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
+};
+
+static unsigned char emc_short_trespass[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x02,                 /* Page length - 2 */
+	0x81,		      /* Trespass code + Honor reservation bit */
+	0xff,                 /* Trespass target */
+};
+
+static unsigned char emc_short_trespass_hr[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x02,                 /* Page length - 2 */
+	0x01,		      /* Trespass code + Honor reservation bit */
+	0xff,                 /* Trespass target */
+};
+
+/* Code borrowed from dm-lsi-rdac by Mike Christie */
 
 static int emc_endio(struct bio *bio, unsigned int bytes_done, int error)
 {
@@ -54,15 +82,15 @@ static int emc_endio(struct bio *bio, un
 		dm_pg_init_complete(path, 0);
 
 	/* request is freed in block layer */
-	free_bio(bio);
+	bio_put(bio);
 
 	return 0;
 }
 
-static struct bio *get_failover_bio(struct path *path, unsigned data_size)
+static struct bio *get_failover_bio(struct path *path, unsigned char *data,
+				    unsigned data_size)
 {
 	struct bio *bio;
-	struct page *page;
 
 	bio = bio_alloc(GFP_ATOMIC, 1);
 	if (!bio) {
@@ -76,20 +104,13 @@ static struct bio *get_failover_bio(stru
 	bio->bi_private = path;
 	bio->bi_end_io = emc_endio;
 
-	page = alloc_page(GFP_ATOMIC);
-	if (!page) {
+	if (bio_add_page(bio, virt_to_page(data), data_size,
+			 offset_in_page(data)) != data_size) {
 		DMERR("dm-emc: get_failover_bio: alloc_page() failed.");
 		bio_put(bio);
 		return NULL;
 	}
 
-	if (bio_add_page(bio, page, data_size, 0) != data_size) {
-		DMERR("dm-emc: get_failover_bio: alloc_page() failed.");
-		__free_page(page);
-		bio_put(bio);
-		return NULL;
-	}
-
 	return bio;
 }
 
@@ -135,46 +156,27 @@ static struct request *emc_trespass_get(
 	struct bio *bio;
 	struct request *rq;
 	unsigned char *page22;
-	unsigned char long_trespass_pg[] = {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x09,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation bit */
-		0xff, 0xff,           /* Trespass target */
-		0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
-		};
-	unsigned char short_trespass_pg[] = {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x02,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation bit */
-		0xff,                 /* Trespass target */
-		};
-	unsigned data_size = h->short_trespass ? sizeof(short_trespass_pg) :
-				sizeof(long_trespass_pg);
-
-	/* get bio backing */
-	if (data_size > PAGE_SIZE)
-		/* this should never happen */
-		return NULL;
+	unsigned data_size;
 
-	bio = get_failover_bio(path, data_size);
+	if (h->short_trespass) {
+		page22 = h->hr ? emc_short_trespass_hr : emc_short_trespass;
+		data_size = sizeof(emc_short_trespass);
+	} else {
+		page22 = h->hr ? emc_long_trespass_hr : emc_long_trespass;
+		data_size = sizeof(emc_long_trespass);
+	}
+
+	bio = get_failover_bio(path, page22, data_size);
 	if (!bio) {
 		DMERR("dm-emc: emc_trespass_get: no bio");
 		return NULL;
 	}
 
-	page22 = (unsigned char *)bio_data(bio);
-	memset(page22, 0, data_size);
-
-	memcpy(page22, h->short_trespass ?
-		short_trespass_pg : long_trespass_pg, data_size);
-
 	/* get request for block layer packet command */
 	rq = get_failover_req(h, bio, path);
 	if (!rq) {
 		DMERR("dm-emc: emc_trespass_get: no rq");
-		free_bio(bio);
+		bio_put(bio);
 		return NULL;
 	}
 

--------------020708020607090300060301
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------020708020607090300060301--
