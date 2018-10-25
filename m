From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 17/21] libmultipath: pathinfo: don't blank
 wwid if checker fails
Date: Thu, 25 Oct 2018 16:50:12 -0500
Message-ID: <20181025215012.GZ7100@octiron.msp.redhat.com>
References: <20181011222707.3631-1-mwilck@suse.com>
	<20181011222707.3631-18-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181011222707.3631-18-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 12, 2018 at 12:27:03AM +0200, Martin Wilck wrote:
> Blanking a WWID is a dangerous operation. E.g. configure() would
> consider the path in question as invalid and orphan it if the
> WWID is blank. Don't do this for possibly transient checker failures.
> Moreover, we try to determine WWID even if path_offline returns
> PATH_DOWN in the first place, so why should we not if the checker
> has a problem?
> 

Is PATH_WILD a transient error?  Clearly we have cases where
PATH_UNCHECKED happens because of a transient error. What's the case
that you are worried about where we temporarily get a PATH_WILD, but we
think we should continue will setting up the path?

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 3550c3a7..467ece7a 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1944,9 +1944,6 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
>  		if (path_state == PATH_UP) {
>  			pp->chkrstate = pp->state = get_state(pp, conf, 0,
>  							      path_state);
> -			if (pp->state == PATH_UNCHECKED ||
> -			    pp->state == PATH_WILD)
> -				goto blank;
>  			if (pp->state == PATH_TIMEOUT)
>  				pp->state = PATH_DOWN;
>  			if (pp->state == PATH_UP && !pp->size) {
> -- 
> 2.19.0
