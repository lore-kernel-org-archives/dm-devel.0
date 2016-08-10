From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipathd: fix memory allocation logic
 error for polls in uxsock_listen()
Date: Wed, 10 Aug 2016 11:42:58 +0200
Message-ID: <2bcb58e4-9264-9dbf-7527-ec1c620f292e@suse.de>
References: <1470821560-10864-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470821560-10864-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn, christophe varoqui <christophe.varoqui@free.fr>
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/10/2016 11:32 AM, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
> =

> logic error exists in memory allocation for polls in uxsock_listen(), eve=
n if the allocated memory size meet the needs, it is still to realloc memor=
y, which is not up to expectations.
> =

> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  multipathd/uxlsnr.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> =

> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index f114e59..fa29b2a 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -145,7 +145,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger=
, void * trigger_data)
>  	pthread_cleanup_push(uxsock_cleanup, NULL);
>  =

>  	condlog(3, "uxsock: startup listener");
> -	polls =3D (struct pollfd *)MALLOC(MIN_POLLS + 1);
> +	polls =3D (struct pollfd *)MALLOC((MIN_POLLS + 1) * sizeof(struct pollf=
d));
>  	if (!polls) {
>  		condlog(0, "uxsock: failed to allocate poll fds");
>  		return NULL;
> @@ -167,9 +167,11 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigge=
r, void * trigger_data)
>  		}
>  		if (num_clients !=3D old_clients) {
>  			struct pollfd *new;
> -			if (num_clients < MIN_POLLS) {
> +			if (num_clients <=3D MIN_POLLS && old_clients > MIN_POLLS) {
>  				new =3D REALLOC(polls, (1 + MIN_POLLS) *
>  						sizeof(struct pollfd));
> +			} else if (num_clients <=3D MIN_POLLS && old_clients <=3D MIN_POLLS) {
> +				new =3D polls;
>  			} else {
>  				new =3D REALLOC(polls, (1+num_clients) *
>  						sizeof(struct pollfd));
> @@ -181,7 +183,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger=
, void * trigger_data)
>  				pthread_yield();
>  				continue;
>  			}
> -			num_clients =3D old_clients;
> +			old_clients =3D num_clients;
>  			polls =3D new;
>  		}
>  		polls[0].fd =3D ux_sock;
> =

Thanks for catching this.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
