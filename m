From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/10] multipath: set cookie before using it.
Date: Sun, 30 Oct 2016 14:46:41 +0100
Message-ID: <9d326d19-f9b1-4036-13df-38ac5be2b6ca@suse.de>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
	<1477709726-5442-7-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-7-git-send-email-bmarzins@redhat.com>
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
> dm_task_set_cookie() expects the cookie to be initialized when it is
> called, but dm_rename() didn't initialized it, causing renames to fail
> some of the time.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/devmapper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index ee61ff0..546e227 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1424,7 +1424,7 @@ dm_rename (const char * old, char * new, char *deli=
m, int skip_kpartx)
>  {
>  	int r =3D 0;
>  	struct dm_task *dmt;
> -	uint32_t cookie;
> +	uint32_t cookie =3D 0;
>  	uint16_t udev_flags =3D DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpart=
x =3D=3D SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
>
>  	if (dm_rename_partmaps(old, new, delim))
>
We never get this 'cookie' business right ...

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
