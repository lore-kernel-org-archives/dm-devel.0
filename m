From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for
 request-based device
Date: Wed, 19 May 2010 17:51:31 -0400
Message-ID: <20100519215130.GA32301@redhat.com>
References: <4BEA659F.9050206@ct.jp.nec.com>
 <20100513035750.GA25523@redhat.com>
 <4BED049C.5040409@ct.jp.nec.com>
 <20100514140852.GA10373@redhat.com>
 <4BF10BF1.3040108@ct.jp.nec.com>
 <20100517172737.GA24591@redhat.com>
 <4BF25091.3000507@ct.jp.nec.com>
 <20100518134639.GA27582@redhat.com>
 <4BF37DD5.9050409@ct.jp.nec.com>
 <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinndXq8DkMBOUf5z8R_8lWRoRbDuOZ1LEmWeI21@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Wed, May 19 2010 at  8:01am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, May 19, 2010 at 1:57 AM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> =
wrote:
> > Also, your patch changes the queue configuration even when a table =
is
> > already active and used. =A0(e.g. Loading bio-based table to a mapp=
ed_device
> > which is already active/used as request-based sets q->requst_fn in =
NULL.)
> > That could cause some critical problems.
>=20
> Yes, that is possible and I can add additional checks to prevent this=
=2E
> But this speaks to a more general problem with the existing DM code.
>=20
> dm_swap_table() has the negative check to prevent such table loads, e=
=2Eg.:
> /* cannot change the device type, once a table is bound */
>=20
> This check should come during table_load, as part of
> dm_table_set_type(), rather than during table resume.

=46YI, the following patch is the relevant portion of the v6 patch that
addresses the issue discussed above.

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 990cf17..62ebd94 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -782,6 +782,7 @@ int dm_table_set_type(struct dm_table *t)
 {
 	unsigned i;
 	unsigned bio_based =3D 0, request_based =3D 0;
+	struct dm_table *live_table =3D NULL;
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
 	struct list_head *devices;
@@ -803,7 +804,7 @@ int dm_table_set_type(struct dm_table *t)
 	if (bio_based) {
 		/* We must use this table as bio-based */
 		t->type =3D DM_TYPE_BIO_BASED;
-		return 0;
+		goto finish;
 	}
=20
 	BUG_ON(!request_based); /* No targets in this table */
@@ -831,6 +832,18 @@ int dm_table_set_type(struct dm_table *t)
=20
 	t->type =3D DM_TYPE_REQUEST_BASED;
=20
+finish:
+	/* cannot change the device type, once a table is bound */
+	live_table =3D dm_get_live_table(t->md);
+	if (live_table) {
+		if (dm_table_get_type(live_table) !=3D dm_table_get_type(t)) {
+			DMWARN("can't change the device type after a table is bound");
+			dm_table_put(live_table);
+			return -EINVAL;
+		}
+		dm_table_put(live_table);
+	}
+
 	return 0;
 }
=20
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a47f0b8..923b662 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2470,13 +2470,6 @@ struct dm_table *dm_swap_table(struct mapped_dev=
ice *md, struct dm_table *table)
 		goto out;
 	}
=20
-	/* cannot change the device type, once a table is bound */
-	if (md->map &&
-	    (dm_table_get_type(md->map) !=3D dm_table_get_type(table))) {
-		DMWARN("can't change the device type after a table is bound");
-		goto out;
-	}
-
 	map =3D __bind(md, table, &limits);
=20
 out:
