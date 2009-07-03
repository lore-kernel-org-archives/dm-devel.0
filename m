From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Use Average path priority value for path
	switching
Date: Fri, 03 Jul 2009 08:40:12 +0200
Message-ID: <4A4DA7CC.9040902@suse.de>
References: <1246583474.30568.2.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1246583474.30568.2.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Chandra,

Chandra Seetharaman wrote:
> Hello,
>=20
> Few weeks back I posted some issues w.r.t the way path priorities are
> used during path switching.
>=20
> Here is Hannes's latest response
> (http://marc.info/?l=3Ddm-devel&m=3D124573807907764&w=3D2) and this pat=
ch is
> based on his suggestion.
>=20
Very cool! Well done there. But a few comments I have, see inline.

> regards,
>=20
> chandra
> -----------------------------------------------------------------------=
=20
> Failback happens only when the sum of priorities of all paths
> (on the higher priority path group) is greater than the sum
> of priorities of all paths on the lower priority path group.
>=20
> This leads into problems when there are more than one paths
> in each of the path groups, and the sum of all paths in the
> lower priority path group is greater than that of path priority
> of a single high priority path.
>=20
> This patch fixes the problem by using average priority of a
> path group in deciding path group switch over.
>=20
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  libmultipath/structs.h     |    1 +
>  libmultipath/switchgroup.c |   23 ++++++++++++++++++-----
>  2 files changed, 19 insertions(+), 5 deletions(-)
>=20
> Index: multipath-tools-mainline/libmultipath/structs.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-mainline.orig/libmultipath/structs.h
> +++ multipath-tools-mainline/libmultipath/structs.h
> @@ -202,6 +202,7 @@ struct pathgroup {
>  	long id;
>  	int status;
>  	int priority;
> +	int up_paths;

Maybe rename this to active_paths?

>  	vector paths;
>  	char * selector;
>  };
> Index: multipath-tools-mainline/libmultipath/switchgroup.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-mainline.orig/libmultipath/switchgroup.c
> +++ multipath-tools-mainline/libmultipath/switchgroup.c
> @@ -14,13 +14,16 @@ path_group_prio_update (struct pathgroup
>  	int priority =3D 0;
>  	struct path * pp;
> =20
> +	pgp->up_paths =3D 0;
>  	if (!pgp->paths) {
>  		pgp->priority =3D 0;
>  		return;
>  	}
>  	vector_foreach_slot (pgp->paths, pp, i) {
> -		if (pp->state !=3D PATH_DOWN)
> +		if (pp->state !=3D PATH_DOWN) {
>  			priority +=3D pp->priority;
Do _not_ aggregate the path state here; just do

priority =3D pp->priority

it'll save you the averaging out later on.

> +			pgp->up_paths++;
> +		}
>  	}
>  	pgp->priority =3D priority;
>  }
> @@ -29,8 +32,9 @@ extern int
>  select_path_group (struct multipath * mpp)
>  {
>  	int i;
> -	int highest =3D 0;
> +	int highest_avg =3D 0;
>  	int bestpg =3D 1;
> +	int avg_priority, highest_up_paths =3D 1;

Again, maybe use max_active_paths and max_priority

>  	struct pathgroup * pgp;
> =20
>  	if (!mpp->pg)
> @@ -41,9 +45,18 @@ select_path_group (struct multipath * mp
>  			continue;
> =20
>  		path_group_prio_update(pgp);
> -		if (pgp->priority > highest) {
> -			highest =3D pgp->priority;
> -			bestpg =3D i + 1;
> +		if (pgp->up_paths) {
> +			avg_priority =3D pgp->priority / pgp->up_paths;
You don't have to average here, if you don't aggregate the priority
as mentioned above.

The test would then just be
if (pgp->priority > max_priority) {
    max_priority =3D pgp->priority;
    max_active_paths =3D pgp->active_paths;
    bestpg =3D i + i;
} else if (pgp->priority =3D=3D max_priority) {
    if (pgp->active_paths > max_active_paths) {
        max_active_paths =3D pgp->active_paths;
        bestpg =3D i + 1;
    }
}

> +			if (avg_priority > highest_avg) {
> +				highest_avg =3D avg_priority;
> +				highest_up_paths =3D pgp->up_paths;
> +				bestpg =3D i + 1;
> +			} else if (avg_priority =3D=3D highest_avg) {
> +				if (pgp->up_paths > highest_up_paths) {
> +					highest_up_paths =3D pgp->up_paths;
> +					bestpg =3D i + 1;
> +				}
> +			}
>  		}
>  	}
>  	return bestpg;
>=20
>=20

But apart from this: Yes, this is exactly how I
think it should be done.

Great job, Chandra.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
