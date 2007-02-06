From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: [PATCH] additional bio list helpers
Date: Tue, 06 Feb 2007 11:00:15 +0000
Message-ID: <45C85FBF.7060207@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050101020607080309040502"
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Heinz Mauelshagen <mauelshagen@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050101020607080309040502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Add a couple of extra helper routines to drivers/md/dm-bio-list.h. This
patch is required for the current dm-loop patch.

Kind regards,

Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFyF+/6YSQoMYUY94RAnB0AJ9CUAbLJhy9sGeAkQuKvjfPOcXFhgCfXqXT
td9QjIOQK+ECBVf3H0Wl83g=
=NX1z
-----END PGP SIGNATURE-----

--------------050101020607080309040502
Content-Type: text/x-patch;
 name="dm-bio-list-helpers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-bio-list-helpers.patch"

Add additional bio list helpers to dm-bio-list.h:

bio_list_empty
bio_list_nr
bio_list_join
bio_list_join_init
bio_list_merge_init
bio_list_push

These are used by dm-loop for manipulating lists of bios to be
resubmitted by the fs I/O code.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Bryn Reeves <breeves@redhat.com>

===================================================================
diff --git a/drivers/md/dm-bio-list.h b/drivers/md/dm-bio-list.h
index da43496..301efae 100644
--- a/drivers/md/dm-bio-list.h
+++ b/drivers/md/dm-bio-list.h
@@ -14,11 +14,33 @@ struct bio_list {
 	struct bio *tail;
 };
 
+static inline int  bio_list_empty(struct bio_list *bl)
+{
+	return bl->head == NULL && bl->tail == NULL;
+}
+
+#define BIO_LIST_HEAD(bl)	struct bio_list bl = { NULL, NULL }
+
 static inline void bio_list_init(struct bio_list *bl)
 {
 	bl->head = bl->tail = NULL;
 }
 
+#define bio_for_each(bio, bl) \
+	for (bio = (bl)->head; bio; bio = bio->bi_next)
+
+static inline int bio_list_nr(struct bio_list *bl)
+{
+	int i=0;
+	struct bio *bio;
+
+	if(bio_list_empty(bl))
+		return i;
+	bio_for_each(bio, bl)
+		i++;
+	return i;
+}
+
 static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
 {
 	bio->bi_next = NULL;
@@ -33,9 +55,6 @@ static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
 
 static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
 {
-	if (!bl2->head)
-		return;
-
 	if (bl->tail)
 		bl->tail->bi_next = bl2->head;
 	else
@@ -58,6 +77,40 @@ static inline void bio_list_merge_head(struct bio_list *bl,
 	bl->head = bl2->head;
 }
 
+static inline void bio_list_join(struct bio_list *bl, struct bio_list *bl2)
+{
+	if (bio_list_empty(bl2))
+		return;
+
+	bl2->tail->bi_next = bl->head;
+	bl->head = bl2->head;
+
+	if (!bl->tail)
+		bl->tail = bl2->tail;
+}
+
+static inline void bio_list_join_init(struct bio_list *bl, struct bio_list *bl2)
+{
+	bio_list_join(bl, bl2);
+	bio_list_init(bl2);
+}
+
+static inline void bio_list_merge_init(struct bio_list *bl,
+				       struct bio_list *bl2)
+{
+	bio_list_merge(bl, bl2);
+	bio_list_init(bl2);
+}
+
+static inline void bio_list_push(struct bio_list *bl, struct bio *bio)
+{
+	bio->bi_next = bl->head;
+	bl->head = bio;
+
+	if (!bl->tail)
+		bl->tail = bio;
+}
+
 static inline struct bio *bio_list_pop(struct bio_list *bl)
 {
 	struct bio *bio = bl->head;

--------------050101020607080309040502
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050101020607080309040502--
