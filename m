From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] dm mpath: Skip calling activate_path if the
	path is already failed
Date: Fri, 14 Aug 2009 10:39:38 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474B7A064@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF46F2BA886@cosmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF46F2BA886@cosmail01.lsi.com>
Content-Language: en-US
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Alasdair, Can you please pick up this patch in your next update..

Hannes, Any comments from you? I know you have already reviewed this in a=
nother thread.

Thanks
Babu Moger=20

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
On
> Behalf Of Moger, Babu
> Sent: Wednesday, July 29, 2009 10:47 AM
> To: dm-devel@redhat.com
> Subject: [dm-devel] [PATCH] dm mpath: Skip calling activate_path if the
> path is already failed
>=20
> This patch adds a check to skip failed paths while calling activate_pat=
h.
> If the path is already failed then activate_path will fail for sure. We
> don't have to call in that case.
>=20
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> ---
>=20
>=20
> --- linux-2.6.31-rc3/drivers/md/dm-mpath.c.orig	2009-07-27
> 10:30:39.000000000 -0500
> +++ linux-2.6.31-rc3/drivers/md/dm-mpath.c	2009-07-27
> 10:35:50.000000000 -0500
> @@ -454,6 +454,10 @@ static void process_queued_ios(struct wo
>  		m->pg_init_count++;
>  		m->pg_init_required =3D 0;
>  		list_for_each_entry(tmp, &pgpath->pg->pgpaths, list) {
> +			/* Skip failed paths */
> +			if (!tmp->is_active)
> +				continue;
> +
>  			if (queue_work(kmpath_handlerd, &tmp->activate_path))
>  				m->pg_init_in_progress++;
>  		}
>=20
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
