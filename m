From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/3] libmultipath: prevent memory leak in
 alloc_path_with_pathinfo() if pp_ptr is NULL
Date: Wed, 14 Dec 2016 08:05:50 +0100
Message-ID: <efce26ad-7542-d145-371e-46ce125e6de1@suse.de>
References: <1481680921-6489-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1481680921-6489-1-git-send-email-mauricfo@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, bmarzins@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

On 12/14/2016 03:01 AM, Mauricio Faria de Oliveira wrote:
> In alloc_path_with_pathinfo(), if the 'pp_ptr' argument is NULL
> (which is acceptable and checked in the function in two places)
> the 'pp' pointer is lost as it is not referenced anywhere else;
> thus the memory allocated for it is leaked.
>
> So, call free_path() in the case 'pp_ptr' is NULL too.
>
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> ---
>  libmultipath/discovery.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 7b5b4344b2a1..3c5c808436b2 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -58,7 +58,7 @@ alloc_path_with_pathinfo (struct config *conf, struct u=
dev_device *udevice,
>  		err =3D pathinfo(pp, conf, flag | DI_BLACKLIST);
>  	}
>
> -	if (err)
> +	if (err || !pp_ptr)
>  		free_path(pp);
>  	else if (pp_ptr)
>  		*pp_ptr =3D pp;
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
