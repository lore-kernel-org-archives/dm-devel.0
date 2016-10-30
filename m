From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/10] mpath: don't wait for udev if all
 paths are down
Date: Sun, 30 Oct 2016 14:46:08 +0100
Message-ID: <f5d6a290-2a3a-a26f-f3ba-6321cab643a1@suse.de>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-6-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-6-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/29/2016 04:55 AM, Benjamin Marzinski wrote:
> Normally multipath waits for udev to create a device before adding
> more paths, which could trigger a reload. But, if the first path
> discovered is not usable, you should add the next path right away.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index dbcaa03..15c957a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -715,7 +715,10 @@ ev_add_path (struct path * pp, struct vectors * vecs)
>  		goto fail; /* leave path added to pathvec */
>  	}
>  	mpp =3D find_mp_by_wwid(vecs->mpvec, pp->wwid);
> -	if (mpp && mpp->wait_for_udev) {
> +	if (mpp && mpp->wait_for_udev &&
> +	    (pathcount(mpp, PATH_UP) > 0 ||
> +	     (pathcount(mpp, PATH_GHOST) > 0 && pp->tpgs !=3D TPGS_IMPLICIT))) {
> +		/* if wait_for_udev is set and valid paths exist */
>  		mpp->wait_for_udev =3D 2;
>  		orphan_path(pp, "waiting for create to complete");
>  		return 0;
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
