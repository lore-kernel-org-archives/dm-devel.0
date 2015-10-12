From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/18] make kpartx -d remove all partitions
Date: Mon, 12 Oct 2015 08:46:18 +0200
Message-ID: <561B573A.4020405@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-8-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-8-git-send-email-bmarzins@redhat.com>
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

On 10/08/2015 09:44 PM, Benjamin Marzinski wrote:
> Currently kpartx -d only removes the partitions that have entries in the
> partition table.  If you remove a partition from the device, and then
> run kpartx -d, it will not delete that partition (kpartx -u will).  I don=
't
> see any value in leaving partition devices for partitions that don't even
> exist anymore, so this patch makes -d delete all partitions.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  kpartx/kpartx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> =

> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index d69f9af..a9d4c98 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -426,7 +426,7 @@ main(int argc, char **argv){
>  			break;
>  =

>  		case DELETE:
> -			for (j =3D n-1; j >=3D 0; j--) {
> +			for (j =3D MAXSLICES-1; j >=3D 0; j--) {
>  				if (safe_sprintf(partname, "%s%s%d",
>  					     mapname, delim, j+1)) {
>  					fprintf(stderr, "partname too small\n");
> @@ -434,7 +434,7 @@ main(int argc, char **argv){
>  				}
>  				strip_slash(partname);
>  =

> -				if (!slices[j].size || !dm_map_present(partname))
> +				if (!dm_map_present(partname))
>  					continue;
>  =

>  				if (!dm_simplecmd(DM_DEVICE_REMOVE, partname,
> =

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
