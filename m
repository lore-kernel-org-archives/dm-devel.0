From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/10] multipath-tools: remove
 USER_FRIENDLY_NAMES_OFF
Date: Mon, 20 Jun 2016 09:07:26 +0200
Message-ID: <5767962E.7090800@suse.de>
References: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
	<1466175169-16684-8-git-send-email-xose.vazquez@gmail.com>
	<CABr-GneYSo9zHqsn45wsigTX+sMpu8SgEquBEU_4Qoka47XgZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GneYSo9zHqsn45wsigTX+sMpu8SgEquBEU_4Qoka47XgZg@mail.gmail.com>
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

On 06/20/2016 08:58 AM, Christophe Varoqui wrote:
> I tend to agree with Xose this is unfair to set user_friendly_name in
> the hwtable entries.
> Does anybody have a vote against my merging this patch ?
> =

> On Fri, Jun 17, 2016 at 4:52 PM, Xose Vazquez Perez
> <xose.vazquez@gmail.com <mailto:xose.vazquez@gmail.com>> wrote:
> =

>     This is up to sysadmins, and it is already off by default.
> =

>     Cc: Christophe Varoqui <christophe.varoqui@opensvc.com
>     <mailto:christophe.varoqui@opensvc.com>>
>     Cc: device-mapper development <dm-devel@redhat.com
>     <mailto:dm-devel@redhat.com>>
>     Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com
>     <mailto:xose.vazquez@gmail.com>>
>     ---
>      libmultipath/hwtable.c | 2 --
>      1 file changed, 2 deletions(-)
> =

>     diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
>     index 598b9b8..bef8d31 100644
>     --- a/libmultipath/hwtable.c
>     +++ b/libmultipath/hwtable.c
>     @@ -794,7 +794,6 @@ static struct hwentry default_hw[] =3D {
>                     .prio_name     =3D PRIO_ONTAP,
>                     .prio_args     =3D NULL,
>                     .retain_hwhandler =3D RETAIN_HWHANDLER_ON,
>     -               .user_friendly_names =3D USER_FRIENDLY_NAMES_OFF,
>                     .detect_prio   =3D DETECT_PRIO_ON,
>             },
>             /*
>     @@ -1133,7 +1132,6 @@ static struct hwentry default_hw[] =3D {
>                     .pgfailback    =3D -FAILBACK_IMMEDIATE,
>                     .checker_name  =3D TUR,
>                     .fast_io_fail  =3D 10,
>     -               .user_friendly_names =3D USER_FRIENDLY_NAMES_OFF,
>                     .prio_name     =3D DEFAULT_PRIO,
>                     .no_path_retry =3D 0,

No, indeed, that's fine.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
