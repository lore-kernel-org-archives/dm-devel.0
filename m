From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/18] Increase host buffer size
Date: Mon, 12 Oct 2015 09:10:31 +0200
Message-ID: <561B5CE7.4050307@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-17-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-17-git-send-email-bmarzins@redhat.com>
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
> Currently the host buffer only has space for 7 characters, this means
> on systems with many scsi hosts (1000 or more), multipath will overflow
> this buffer. This can happen pretty easily if there are a large number
> of iscsi devices.  This patch increases the host buffer to hold 15
> characters, which can deal with 100000000000000 scsi hosts.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/structs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> =

> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 85a8fdc..99b6aae 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -15,7 +15,7 @@
>  #define BLK_DEV_SIZE		33
>  #define PATH_SIZE		512
>  #define NAME_SIZE		512
> -#define HOST_NAME_LEN		8
> +#define HOST_NAME_LEN		16
>  #define SLOT_NAME_SIZE		40
>  =

>  #define SCSI_VENDOR_SIZE	9
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
