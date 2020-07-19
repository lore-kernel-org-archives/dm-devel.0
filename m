From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 64/74] multipathd: check_path(): set
 retrigger_delay if necessary
Date: Sun, 19 Jul 2020 00:07:16 -0500
Message-ID: <20200719050716.GW11089@octiron.msp.redhat.com>
References: <20200709105145.9211-1-mwilck@suse.com>
	<20200709105145.9211-12-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-12-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 09, 2020 at 12:51:35PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> In a follow up patch, we will set INIT_MISSING_UDEV and set tick=1
> (minimal) at the same time. In this case, which is new, check_path()
> must reset the delay when it first triggers an uevent.

Maybe I'm just being obtuse here, but I don't get what this does.
pp->tick will always be 0 for any path that makes it to the check

if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {

And then if it's not out of retries, the path will get set to
INIT_REQUESTED_UDEV, and pathinfo() will take care of resetting pp->tick
when it gets called by the new uevent.

If it is out of retries, the path won't get pp->tick reset, which seems
wrong, but it that case it should probably be set to max_checkint, like
happens when the "add missing paths" code fails.

Or like I said, maybe I'm just missing something.
-Ben

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7b2d320..0cd0ee6 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2019,6 +2019,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  	int disable_reinstate = 0;
>  	int oldchkrstate = pp->chkrstate;
>  	int retrigger_tries, verbosity;
> +	unsigned int retrigger_delay;
>  	unsigned int checkint, max_checkint;
>  	struct config *conf;
>  	int marginal_pathgroups, marginal_changed = 0;
> @@ -2036,6 +2037,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  
>  	conf = get_multipath_config();
>  	retrigger_tries = conf->retrigger_tries;
> +	retrigger_delay = conf->retrigger_delay;
>  	checkint = conf->checkint;
>  	max_checkint = conf->max_checkint;
>  	verbosity = conf->verbosity;
> @@ -2048,6 +2050,8 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  	};
>  
>  	if (!pp->mpp && pp->initialized == INIT_MISSING_UDEV) {
> +		if (pp->tick != retrigger_delay)
> +			pp->tick = conf->retrigger_delay;
>  		if (pp->retriggers < retrigger_tries) {
>  			condlog(2, "%s: triggering change event to reinitialize",
>  				pp->dev);
> -- 
> 2.26.2
