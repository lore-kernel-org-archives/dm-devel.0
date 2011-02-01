From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH] multipathd: use 0 for initial pg if
	nr_priority_groups=0
Date: Tue, 01 Feb 2011 16:38:58 +0100
Message-ID: <4D482912.2020203@suse.de>
References: <1296490458-12910-1-git-send-email-snitzer@redhat.com>	<1296490458-12910-2-git-send-email-snitzer@redhat.com>	<E463DF2B2E584B4A82673F53D62C2EF4FF372B9C@cosmail01.lsi.com>
	<20110131183445.GA13689@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110131183445.GA13689@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 01/31/2011 07:34 PM, Mike Snitzer wrote:
> On Mon, Jan 31 2011 at  1:09pm -0500,
> Moger, Babu <Babu.Moger@lsi.com> wrote:
> =

>> Looks good to me. =

>>
>>> -----Original Message-----
>>> From: Mike Snitzer [mailto:snitzer@redhat.com]
>>> Sent: Monday, January 31, 2011 10:14 AM
>>> To: dm-devel@redhat.com
>>> Cc: Mike Snitzer; Moger, Babu
>>> Subject: [PATCH 2/2] dm mpath: allow table load with 0 priority groups
>>>
>>> If an mpath device is held open when all paths in the last priority
>>> group have failed userspace multipathd will attempt to reload the
>>> associated DM table to reflect that the device no longer has any
>>> priority groups.  But the reload attempt always failed because the
>>> multipath target did not allow 0 priority groups.
>>>
>>> Adjust multipath target to allow a table with both 0 priority groups
>>> and 0 for the initial priority group number.
>>>
>>> All multipath target messages related to priority group (enable_group,
>>> disable_group, switch_group) will properly handle a priority group of
>>> 0 (will cause error).
>>>
>>> When reloading a multipath table with 0 priority groups, userspace
>>> multipathd must be updated to specify an initial priority group number
>>> of 0 (rather than 1).
>>
>>  Looks like we still have some action from multipath tool. CCing Ben..
> =

> Right, I looked in to the multipath-tools change.  Here is an RFC patch.
> =

> Inlined "FIXME"s pose the relevant questions.  I held off on having
> select_path_group() return 0 when !mpp->pg because I wasn't confident
> that I wouldn't break multipathd in some unintuitive way.
> =

> I did audit the various callers (indirect through setup_map call):
> =

> update_path_groups
> ev_add_path
> ev_remove_path
> =

> (all above first call setup_map)
> =

> setup_map()
>   - mpp->bestpg =3D select_path_group()
>   - assemble_map() -- establishes mp->params
> =

> do_map()
> =

> Even though I verified that much I wasn't completely confident in
> changing select_path_group()'s defualt return of 1 -- so I localized the
> change to where I _knew_ it was safe (assemble_map):
> =

> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index 1ef3aad..97b6420 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -52,6 +52,7 @@ assemble_map (struct multipath * mp)
>  	int i, j;
>  	int shift, freechar;
>  	int minio;
> +	int nr_priority_groups, initial_pg_nr;
>  	char * p;
>  	struct pathgroup * pgp;
>  	struct path * pp;
> @@ -60,9 +61,19 @@ assemble_map (struct multipath * mp)
>  	p =3D mp->params;
>  	freechar =3D sizeof(mp->params);
>  =

> +	nr_priority_groups =3D VECTOR_SIZE(mp->pg);
> +	/*
> +	 * FIXME: make this conditional on multipath target version?
> +	 * - but no existing code is conditional on multipath target version,
> +	 *   nor does dm_drvprereq() store the version for code to do so.
> +	 * - thing is older multipath never allowed nr_priority_groups=3D0 so
> +	 *   it doesn't _really_ matter if initial_pg_nr=3D0 here...
> +	 */
> +	initial_pg_nr =3D (nr_priority_groups ? mp->bestpg : 0);
> +
>  	shift =3D snprintf(p, freechar, "%s %s %i %i",
>  			 mp->features, mp->hwhandler,
> -			 VECTOR_SIZE(mp->pg), mp->bestpg);
> +			 nr_priority_groups, initial_pg_nr);
>  =

>  	if (shift >=3D freechar) {
>  		fprintf(stderr, "mp->params too small\n");
> diff --git a/libmultipath/switchgroup.c b/libmultipath/switchgroup.c
> index 025a95d..82c30ad 100644
> --- a/libmultipath/switchgroup.c
> +++ b/libmultipath/switchgroup.c
> @@ -41,7 +41,7 @@ select_path_group (struct multipath * mpp)
>  	struct pathgroup * pgp;
>  =

>  	if (!mpp->pg)
> -		return 1;
> +		return 1; /* FIXME: return 0 here? */
>  =

>  	vector_foreach_slot (mpp->pg, pgp, i) {
>  		if (!pgp->paths)
> =

I have a similar patchset in my multipath-tools tree, to allow maps
with zero paths, too.
However, there are quite a few places which required checking, as
we're basically _never_ check if a pointer is NULL before accessing
it. With a bit of luck I'll find some time to send out the patchset.

Otherwise you could have a look at

git://git.kernel.org/pub/scm/linux/kernel/git/hare/multipath-tools.git
branch sles11-sp1 will have the most recent stuff.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
