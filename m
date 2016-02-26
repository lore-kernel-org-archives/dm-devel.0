From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH V2]multipath-tools: prevent unnecessary
 reinstate of stand-by paths with implicit tpgs mode and no active array
 paths
Date: Fri, 26 Feb 2016 13:00:50 -0600
Message-ID: <20160226190050.GE2915@octiron.msp.redhat.com>
References: <D2F4F783.87D0%Shiva.Krishna@nimblestorage.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D2F4F783.87D0%Shiva.Krishna@nimblestorage.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shiva Krishna <Shiva.Krishna@nimblestorage.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 26, 2016 at 02:25:08AM +0000, Shiva Krishna wrote:
> --- 
>  libmultipath/propsel.c |    2 +-
>  libmultipath/structs.h |    1 +
>  multipathd/main.c      |   19 ++++++++++++++++---
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index f64d5e4..b9e389f 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -374,7 +374,7 @@ detect_prio(struct path * pp)
>  	int ret;
>  	struct prio *p = &pp->prio;
>  
> -	if (get_target_port_group_support(pp->fd) <= 0)
> +	if ((pp->tpgs = get_target_port_group_support(pp->fd)) <= 0)
>  		return;
>  	ret = get_target_port_group(pp->fd);
>  	if (ret < 0)

Again, setting this in detect_prio will make this useless for all
devices that don't use detect_prio. After the "out:" label in
select_prio, you can check if the alua prioritizer is being used,
and set this there. 

-Ben

> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 5f68a8e..ef5fb7e 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -193,6 +193,7 @@ struct path {
>  	int detect_prio;
>  	int watch_checks;
>  	int wait_checks;
> +	int tpgs;
>  	char * uid_attribute;
>  	char * getuid;
>  	struct prio prio;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 04f6d02..b6b0053 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -62,6 +62,7 @@ static int use_watchdog;
>  #include <pgpolicies.h>
>  #include <uevent.h>
>  #include <log.h>
> +#include "prioritizers/alua_rtpg.h"
>  
>  #include "main.h"
>  #include "pidfile.h"
> @@ -1161,6 +1162,7 @@ check_path (struct vectors * vecs, struct path * pp)
>  	int new_path_up = 0;
>  	int chkr_new_path_up = 0;
>  	int add_active;
> +	int ignore_reinstate = 0;
>  	int oldchkrstate = pp->chkrstate;
>  
>  	if (pp->initialized && !pp->mpp)
> @@ -1235,6 +1237,16 @@ check_path (struct vectors * vecs, struct path * pp)
>  			pp->wait_checks = 0;
>  	}
>  
> +	/*
> +	 * don't reinstate failed path, if its in stand-by
> +	 * and if target supports only implicit tpgs mode.
> +	 * this will prevent unnecessary i/o by dm on stand-by
> +	 * paths if there are no other active paths in map.
> +	 */
> +	ignore_reinstate = (newstate == PATH_GHOST &&
> +			    pp->mpp->nr_active == 0 &&
> +			    pp->tpgs == TPGS_IMPLICIT) ? 1 : 0;
> +
>  	pp->chkrstate = newstate;
>  	if (newstate != pp->state) {
>  		int oldstate = pp->state;
> @@ -1297,7 +1309,7 @@ check_path (struct vectors * vecs, struct path * pp)
>  				pp->watch_checks--;
>  			add_active = 0;
>  		}
> -		if (reinstate_path(pp, add_active)) {
> +		if (!ignore_reinstate && reinstate_path(pp, add_active)) {
>  			condlog(3, "%s: reload map", pp->dev);
>  			ev_add_path(pp, vecs);
>  			pp->tick = 1;
> @@ -1316,8 +1328,9 @@ check_path (struct vectors * vecs, struct path * pp)
>  			enable_group(pp);
>  	}
>  	else if (newstate == PATH_UP || newstate == PATH_GHOST) {
> -		if (pp->dmstate == PSTATE_FAILED ||
> -		    pp->dmstate == PSTATE_UNDEF) {
> +		if ((pp->dmstate == PSTATE_FAILED ||
> +		    pp->dmstate == PSTATE_UNDEF) &&
> +		    !ignore_reinstate) {
>  			/* Clear IO errors */
>  			if (reinstate_path(pp, 0)) {
>  				condlog(3, "%s: reload map", pp->dev);
> --
> 
