From: Edward Goggin <egoggin@emc.com>
Subject: RE: Re: dm-emc hardware handler patches
Date: Wed, 6 Dec 2006 17:32:06 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E40299619E@CORPUSMX40A.corp.emc.com>
References: <20061206220602.GI4409@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20061206220602.GI4409@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, agk@redhat.com
Cc: michaelc@cs.wisc.edu
List-Id: dm-devel.ids

On Wednesday, December 06, 2006 5:06 PM, Alasdair G Kergon wrote

> How about this instead?

Much better idea.  I wish I thought of it!

Is the rest of the patch OK?

Do I need to do anything more with this?

>=20
> --- linux-2.6.19.orig/drivers/md/dm-hw-handler.h=09
> 2006-12-06 20:49:24.000000000 +0000
> +++ linux-2.6.19/drivers/md/dm-hw-handler.h	2006-12-06=20
> 21:18:46.000000000 +0000
> @@ -16,6 +16,7 @@
>  struct hw_handler_type;
>  struct hw_handler {
>  	struct hw_handler_type *type;
> +	struct mapped_device *md;
>  	void *context;
>  };
> =20
>=20
> Then each hw-handler wouldn't need its own code to store it and
> we'd just have:
>=20
> --- linux-2.6.19.orig/drivers/md/dm-mpath.c	2006-12-06=20
> 20:55:37.000000000 +0000
> +++ linux-2.6.19/drivers/md/dm-mpath.c	2006-12-06=20
> 21:35:09.000000000 +0000
> @@ -666,6 +666,9 @@ static int parse_hw_handler(struct arg_s
>  		return -EINVAL;
>  	}
> =20
> +	m->hw_handler.md =3D dm_table_get_md(ti->table);
> +	dm_put(m->hw_handler.md);
> +
>  	r =3D hwht->create(&m->hw_handler, hw_argc - 1, as->argv);
>  	if (r) {
>  		dm_put_hw_handler(hwht);
>=20
>=20
>=20
> > +	/*
> > +	 * No need to hold a reference on the mapped device here
> > +	 * since one is already held for the duration of the
> > +	 * mapped device open.
> > +	 */
>=20
> I think it's stronger than that: a (self-)reference must not=20
> be held here,
> or how would the reference count ever subsequently drop to zero?
>=20

Agreed, that is the way I initially implemented it and I ran into
the exact problem you describe.

> Makes you wonder in what circumstances the dm_get() in=20
> dm_table_get_md()
> is ever required.

Yup, but while it's a stretch, possibly some code path may
want to hold a reference to the mapped device even if the
device was already removed from the hash table.
