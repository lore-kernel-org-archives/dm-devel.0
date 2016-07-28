From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] multipath-tools: change default
 path_grouping_policy from failover to group_by_prio
Date: Thu, 28 Jul 2016 16:06:27 +0200
Message-ID: <76957be3-8db8-7863-7152-b67c18194c36@suse.de>
References: <1468271522-3052-1-git-send-email-xose.vazquez@gmail.com>
	<1468271522-3052-2-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468271522-3052-2-git-send-email-xose.vazquez@gmail.com>
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
> Default value is: failover
>       5                 .pgpolicy      =3D GROUP_BY_SERIAL,
>      23                 .pgpolicy      =3D MULTIBUS,
>      48                 .pgpolicy      =3D GROUP_BY_PRIO,
> =

> failover is only used by 1 device:
> IBM/3303 NVDISK
> =

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/defaults.h    |  2 +-
>  libmultipath/hwtable.c     | 49 +---------------------------------------=
------
>  multipath/multipath.conf.5 |  2 +-
>  3 files changed, 3 insertions(+), 50 deletions(-)
> =

Please reconsider.

'group_by_prio' requires a working prioritizer, which we cannot assume
for an unknown device.

To handle this situation properly we should be using 'group_by_prio' as
the default is a prioritizer is found and switch to 'failover' for all
other cases.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
