From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath-tools: preload also scsi_dh_hp_sw
 before run multipathd
Date: Tue, 11 Oct 2016 15:41:15 +0200
Message-ID: <2779bae3-28f4-9b0f-b014-583b717f715e@suse.de>
References: <20161011125515.8523-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161011125515.8523-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/11/2016 02:55 PM, Xose Vazquez Perez wrote:
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  multipathd/multipathd.service | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
> index e3d6f91..45aca35 100644
> --- a/multipathd/multipathd.service
> +++ b/multipathd/multipathd.service
> @@ -11,7 +11,7 @@ Conflicts=3Dshutdown.target
>  Type=3Dnotify
>  NotifyAccess=3Dmain
>  LimitCORE=3Dinfinity
> -ExecStartPre=3D/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac d=
m-multipath
> +ExecStartPre=3D/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw =
scsi_dh_rdac dm-multipath
>  ExecStart=3D/sbin/multipathd -d -s
>  ExecReload=3D/sbin/multipathd reconfigure
>
>
Well.

If you can point me to a single user of an MSA1500 I'm happy to include =

it. If you don't know what an MSA1500 is nor what hp_sw does it's =

probably not a good idea to have it.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
