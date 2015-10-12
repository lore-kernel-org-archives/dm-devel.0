From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 05/18] update multipath rules to deal with
 partition devices
Date: Mon, 12 Oct 2015 08:42:17 +0200
Message-ID: <561B5649.5030305@suse.de>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
	<1444333491-16265-6-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-6-git-send-email-bmarzins@redhat.com>
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
> Partition devices should inherit the DM_MULTIPATH_DEVICE_PATH
> state of their parents, and if they are part of multipath path devices,
> they shouldn't have their own ID_FS_TYPE
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/multipath.rules | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> =

> diff --git a/multipath/multipath.rules b/multipath/multipath.rules
> index c76e6b8..c8fb7e6 100644
> --- a/multipath/multipath.rules
> +++ b/multipath/multipath.rules
> @@ -1,14 +1,22 @@
>  # Set DM_MULTIPATH_DEVICE_PATH if the device should be handled by multip=
ath
>  SUBSYSTEM!=3D"block", GOTO=3D"end_mpath"
> +ACTION!=3D"add|change", GOTO=3D"end_mpath"
> +KERNEL!=3D"sd*|dasd*", GOTO=3D"end_mpath"
> +
> +ENV{DEVTYPE}!=3D"partition", GOTO=3D"test_dev"
> +IMPORT{parent}=3D"DM_MULTIPATH_DEVICE_PATH"
> +ENV{DM_MULTIPATH_DEVICE_PATH}=3D=3D"1", ENV{ID_FS_TYPE}=3D"none", \
> +	ENV{SYSTEMD_READY}=3D"0"
> +GOTO=3D"end_mpath"
> +
> +LABEL=3D"test_dev"
>  =

>  ENV{MPATH_SBIN_PATH}=3D"/sbin"
>  TEST!=3D"$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}=3D"/usr/=
sbin"
>  =

> -SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add|change", KERNEL=3D=3D"sd*|dasd*=
", \
> -	ENV{DM_MULTIPATH_DEVICE_PATH}!=3D"1", \
> +ENV{DM_MULTIPATH_DEVICE_PATH}!=3D"1", \
>  	PROGRAM=3D=3D"$env{MPATH_SBIN_PATH}/multipath -u %k", \
> -	ENV{DM_MULTIPATH_DEVICE_PATH}=3D"1" \
> -	ENV{ID_FS_TYPE}=3D"none" \
> +	ENV{DM_MULTIPATH_DEVICE_PATH}=3D"1", ENV{ID_FS_TYPE}=3D"none", \
>  	ENV{SYSTEMD_READY}=3D"0"
>  =

>  LABEL=3D"end_mpath"
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
