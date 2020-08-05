From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH RFC] multipath-tools: *untested* use sysfs
 prio also for arrays with dual implicit/explicit alua support
Date: Wed, 05 Aug 2020 23:12:49 +0200
Message-ID: <db83c4595e4e494d95c80825b1a66dfb77e14690.camel@suse.com>
References: <acc2f009-c4b8-0c09-c77c-9400aac38cb1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <acc2f009-c4b8-0c09-c77c-9400aac38cb1@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, DM-DEVEL ML <dm-devel@redhat.com>
Cc: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
List-Id: dm-devel.ids

Hi Xose,

do you have a specific use case where this helps / changes matters?

The idea of the current code is to use PRIO_SYSFS always, except for
RDAC arrays with implicit ALUA, where periodic RTPGs are necessary (see
7e2f46d). This patch would change matters only for RDAC arrays which
advertise both explicit and implicit ALUA support.

Maybe Steven can clarify if such RDAC arrays exist, and whether we
should use PRIO_SYSFS or PRIO_ALUA for them.

Martin


On Sat, 2020-07-25 at 00:34 +0200, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 897e48ca..5a82234f 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -595,7 +595,7 @@ detect_prio(struct config *conf, struct path *
> pp)
>   		tpgs = path_get_tpgs(pp);
>   		if (tpgs == TPGS_NONE)
>   			return;
> -		if ((tpgs == TPGS_EXPLICIT || !check_rdac(pp)) &&
> +		if ((tpgs == TPGS_EXPLICIT || tpgs == TPGS_BOTH ||
> !check_rdac(pp)) &&
>   		    sysfs_get_asymmetric_access_state(pp, buff, 512) >=
> 0)
>   			default_prio = PRIO_SYSFS;
>   		else
> 
> In short:
> 
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 897e48ca..a9609a01 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -595,7 +595,7 @@ detect_prio(struct config *conf, struct path *
> pp)
>   		tpgs = path_get_tpgs(pp);
>   		if (tpgs == TPGS_NONE)
>   			return;
> -		if ((tpgs == TPGS_EXPLICIT || !check_rdac(pp)) &&
> +		if ((tpgs != TPGS_IMPLICIT || !check_rdac(pp)) &&
>   		    sysfs_get_asymmetric_access_state(pp, buff, 512) >=
> 0)
>   			default_prio = PRIO_SYSFS;
>   		else
> 
