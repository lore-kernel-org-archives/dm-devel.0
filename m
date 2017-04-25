From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] kpartx: default to running in sync mode
Date: Tue, 25 Apr 2017 12:12:25 +0200
Message-ID: <d4cdb3c3-c815-998f-9794-150179c74411@linux.vnet.ibm.com>
References: <1493073570-17167-1-git-send-email-bmarzins@redhat.com>
	<1493073570-17167-5-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1493073570-17167-5-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On 04/25/2017 12:39 AM, Benjamin Marzinski wrote:
> When users run kpartx, they would naturally assume that when it
> completes, the devices have been created. However, kpartx runs in async
> mode by default.  This seems like it is likely to trip up users.  So,
> switch the default to sync mode, add a -n option to enable async mode,
> and set async mode when kpartx is called by the udev rules.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  kpartx/kpartx.c     | 10 +++++++---
>  kpartx/kpartx.rules |  2 +-
>  2 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 58e60ff..d1edd5e 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c

> -int udev_sync =3D 0;
> +int udev_sync =3D 1;

> -	printf("\t-s sync mode. Don't return until the partitions are created\n=
");
> +	printf("\t-n nosync mode. Return before the partitions are created\n");
> +	printf("\t-s sync mode. Don't return until the partitions are created. =
Default.\n");

> +		case 'n':
> +			udev_sync =3D 0;
> +			break;

> diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
> index 48a4d6c..a958791 100644
> --- a/kpartx/kpartx.rules
> +++ b/kpartx/kpartx.rules
> @@ -40,6 +40,6 @@ ENV{DM_NR_VALID_PATHS}=3D=3D"0", GOTO=3D"kpartx_end"
>  ENV{ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!=3D"1", IMPORT{db}=3D"DM_SUBSYSTEM_=
UDEV_FLAG1"
>  ENV{DM_SUBSYSTEM_UDEV_FLAG1}=3D=3D"1", GOTO=3D"kpartx_end"
>  ENV{DM_STATE}!=3D"SUSPENDED", ENV{DM_UUID}=3D=3D"mpath-*", \
> -	RUN+=3D"/sbin/kpartx -u -p -part /dev/$name"
> +	RUN+=3D"/sbin/kpartx -un -p -part /dev/$name"

I understand this was async before and is now still async after the =

default change in kpartx. However, I'm wondering in general how one =

would "wait" for kpartx mappings, since I suppose a "udevadm settle" =

would not suffice. Dracut probably does not care because it would loop =

until its required root-fs devices have appeared.

-- =

Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
