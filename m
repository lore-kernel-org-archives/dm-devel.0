From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] multipath-tools: change default failback
 from manual to immediate
Date: Thu, 28 Jul 2016 16:03:34 +0200
Message-ID: <c3922f2d-d524-4700-e890-902a22c89491@suse.de>
References: <1468271522-3052-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468271522-3052-1-git-send-email-xose.vazquez@gmail.com>
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

On 07/11/2016 11:12 PM, Xose Vazquez Perez wrote:
> Default value is: manual
>       1                 .pgfailback    =3D 15,
>       2                 .pgfailback    =3D 30,
>      24                 .pgfailback    =3D FAILBACK_UNDEF,
>      50                 .pgfailback    =3D -FAILBACK_IMMEDIATE,
> =

> manual is not used by any device.
> =

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/defaults.h    |  2 +-
>  libmultipath/hwtable.c     | 50 ----------------------------------------=
------
>  multipath/multipath.conf.5 |  2 +-
>  3 files changed, 2 insertions(+), 52 deletions(-)
> =

Please revert.

'immediate' fallback only makes sense if the device has a working
prioritizer _and_ supports a 'preferred path'.
None of which can be assumed for an unknown device, so this patch
will break automatic configuration.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
