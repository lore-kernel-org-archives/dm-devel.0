From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: [PATCH] additional bio list helpers
Date: Wed, 07 Feb 2007 11:26:14 +0000
Message-ID: <45C9B756.4090408@redhat.com>
References: <45C85FBF.7060207@redhat.com>
	<20070206.160524.39151213.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000600090005000909050208"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070206.160524.39151213.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: dm-devel@redhat.com, mauelshagen@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000600090005000909050208
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Kiyoshi,

Kiyoshi Ueda wrote:
> This one breaks the bio_list if bl2 is a empty list.
> Probably missed to add like below?
> -----------------------------------
> +	if (bio_list_empty(bl2))
> +		return;
> -----------------------------------

Quite right - fixed, thanks!

> I think that bl->tail is always NULL when bl->head is NULL,
> unless the bio_list is corrupted.  So no need to check bl->tail.

This was actually already changed in my git copy, but I forgot to
re-generate the patch before posting - apologies!

> I think that this check in not needed because it is covered
> by bio_for_each() below.

Agreed!

> I think that bio_list_join() is same as existing bio_list_merge_head().

Also agreed - thanks for catching these. This one also isn't used by
dm-loop anyway.

Revised patch attached - this time just including the changes actually
needed by the dm-loop patch:

bio_list_empty
bio_for_each
bio_list_nr
bio_list_merge_init

Kind regards,

Bryn.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFybdW6YSQoMYUY94RAgZxAKChuSEQAP0zs+f9/yzjCf92beTkJQCdEQBq
oxBR+Xsj1V6Fj4r9ec3sPZ0=
=nIAj
-----END PGP SIGNATURE-----

--------------000600090005000909050208
Content-Type: text/x-patch;
 name="dm-bio-list-helpers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-bio-list-helpers.patch"

Add additional bio list helpers to dm-bio-list.h:

bio_list_empty
bio_for_each
bio_list_nr
bio_list_merge_init

These are used by dm-loop for manipulating lists of bios to be
resubmitted by the fs I/O code.

Signed-off-by: Bryn Reeves <breeves@redhat.com>

===================================================================
diff --git a/drivers/md/dm-bio-list.h b/drivers/md/dm-bio-list.h
index da43496..6db7644 100644
--- a/drivers/md/dm-bio-list.h
+++ b/drivers/md/dm-bio-list.h
@@ -14,11 +14,31 @@ struct bio_list {
 	struct bio *tail;
 };
 
+static inline int  bio_list_empty(struct bio_list *bl)
+{
+	return bl->head == NULL;
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
+	bio_for_each(bio, bl)
+		i++;
+	return i;
+}
+
 static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
 {
 	bio->bi_next = NULL;
@@ -58,6 +78,13 @@ static inline void bio_list_merge_head(struct bio_list *bl,
 	bl->head = bl2->head;
 }
 
+static inline void bio_list_merge_init(struct bio_list *bl,
+				       struct bio_list *bl2)
+{
+	bio_list_merge(bl, bl2);
+	bio_list_init(bl2);
+}
+
 static inline struct bio *bio_list_pop(struct bio_list *bl)
 {
 	struct bio *bio = bl->head;

--------------000600090005000909050208
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000600090005000909050208--
