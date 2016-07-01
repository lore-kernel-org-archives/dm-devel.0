From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 1/3] multipath-tools: Increase
 MAX_REPLY_LEN.
Date: Fri, 1 Jul 2016 16:46:53 +0200
Message-ID: <5776825D.8050202@suse.de>
References: <1455264623-16199-2-git-send-email-fge@redhat.com>
	<20160701124656.169890-1-fge@redhat.com>
	<20160701124656.169890-2-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160701124656.169890-2-fge@redhat.com>
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

On 07/01/2016 02:46 PM, Gris Ge wrote:
> Problem:
> =

>     mpath_recv_reply() return -EINVA with 2k paths.
> =

> Root cause:
> =

>     With 2k paths(1k mpaths) simulated by scsi_debug, the 'show maps json'
>     requires 1633217 bytes while MAX_REPLY_LEN is 65535 bytes.
> =

> Fix:
> =

>     Increase MAX_REPLY_LEN to 10485760(10MiB) which is enough for 10k
>     paths.
> =

> Signed-off-by: Gris Ge <fge@redhat.com>
> ---
>  libmpathcmd/mpath_cmd.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> =

> diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
> index f33f000..d65c648 100644
> --- a/libmpathcmd/mpath_cmd.h
> +++ b/libmpathcmd/mpath_cmd.h
> @@ -28,7 +28,9 @@ extern "C" {
>  =

>  #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
>  #define DEFAULT_REPLY_TIMEOUT	1000
> -#define MAX_REPLY_LEN		65536
> +#define MAX_REPLY_LEN		10485760
> +/* ^ 10 MiB, enough for 'show maps json' command with 10k paths which
> + *   requires about 8 MiB */
>  =

>  =

Huh.
Can't say I like it. The limit is pretty much self-imposed, so I'd
rather bite the bullet and make it size-independent.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
