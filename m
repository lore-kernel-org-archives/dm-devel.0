From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH]:[multipath-tools] Adding the hwtable for	LSI
	generic rdac storage devices
Date: Wed, 11 Mar 2009 08:41:31 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF46675BC75@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF46675B0E8@cosmail01.lsi.com>
	<1236734269.11383.1.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1236734269.11383.1.camel@chandra-ubuntu>
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
To: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Fri, 2009-03-06 at 09:38 -0700, Moger, Babu wrote:
> This patch adds the hwtable for LSI rdac generic storage. Also sets the=
 feature pg_init_retries to maximum(50).
>=20
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
>=20
> ---
>=20
> --- multipath-tools/libmultipath/hwtable.c.orig	2009-03-04 14:33:11.000=
000000 -0600
> +++ multipath-tools/libmultipath/hwtable.c	2009-03-04 14:43:57.00000000=
0 -0600
> @@ -837,6 +837,22 @@ static struct hwentry default_hw[] =3D {
>  		.checker_name  =3D RDAC,
>  		.prio_name     =3D PRIO_RDAC,
>  	},
> +	/* LSI Generic rdac storage */
> +	{
> +		.vendor        =3D "(LSI|ENGENIO)",
> +		.product       =3D "INF-01-00",
> +		.getuid        =3D DEFAULT_GETUID,
> +		.features      =3D "2 pg_init_retries 50",
> +		.hwhandler     =3D "1 rdac",
> +		.selector      =3D DEFAULT_SELECTOR,
> +		.pgpolicy      =3D GROUP_BY_PRIO,
> +		.pgfailback    =3D -FAILBACK_IMMEDIATE,
> +		.rr_weight     =3D RR_WEIGHT_NONE,
> +		.no_path_retry =3D 15,

you don't want to use "queue" for no path retry ?

No, We did not want to set it to "queue" by default. Reason is, we know t=
hat I/O session will hang in case of all path failure. User will not know=
 why the session is non-responsive, if he is not familiar with this featu=
re. Also, we think this feature (queue) is meant for maintenance or suppo=
rt (like replacing the switch/cable or shutting down the storage for shor=
t duration).  In these cases user can set to queue on the fly.=20

Want to mention one more thing. I saw other hwtable table (mostly IBM). T=
hey don't set the feature pg_init_retries. In that case it is defaulting =
to 0. We have seen issues because of this during the failovers. In case o=
f multi-host scenario (more than one host accessing the same storage), we=
 have seen failovers not been able complete in one attempt and resulting =
I/O failure. I would suggest setting pg_init_retries to maximum by defaul=
t.=20

> +		.minio         =3D DEFAULT_MINIO,
> +		.checker_name  =3D RDAC,
> +		.prio_name     =3D PRIO_RDAC,
> +	},
>  	/*
>  	 * EOL
>  	 */
>=20
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
