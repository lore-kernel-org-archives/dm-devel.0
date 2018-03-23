From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 04/20] multipath -u -i: respect entries in
	WWIDs file
Date: Fri, 23 Mar 2018 12:54:57 -0500
Message-ID: <20180323175457.GI3103@octiron.msp.redhat.com>
References: <20180319150155.5363-1-mwilck@suse.com>
	<20180319150155.5363-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180319150155.5363-5-mwilck@suse.com>
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

On Mon, Mar 19, 2018 at 04:01:39PM +0100, Martin Wilck wrote:
> Previously, if find_multipaths was set, devices listed in the WWIDs file
> weren't classified as multipath members by "multipath -u -i" unless they also
> met the "find_multipaths" criteria (at least two paths, or existing map with
> this WWID). Now we classify all paths in the WWIDs file as multipath members, too.
> 
> The rationale for this patch is to match the logic that multipathd applies
> by default (i.e. without "-n").
> 

Still calling the option ignore_wwids is a little confusing when you
aren't actually ignoring the wwids file (you're just not requiring it),
but at any rate...

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 20f46acd924a..4d45df3cdb83 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -437,16 +437,19 @@ configure (struct config *conf, enum mpath_cmds cmd,
>  		 * set, you need to actually check if there are two available
>  		 * paths to determine if this path should be multipathed. To
>  		 * do this, we put off the check until after discovering all
> -		 * the paths */
> -		if (cmd == CMD_VALID_PATH &&
> -		    (!conf->find_multipaths || !conf->ignore_wwids)) {
> -			if (conf->ignore_wwids ||
> +		 * the paths.
> +		 * Paths listed in the wwids file are always considered valid.
> +		 */
> +		if (cmd == CMD_VALID_PATH) {
> +			if ((!conf->find_multipaths && conf->ignore_wwids) ||
>  			    check_wwids_file(refwwid, 0) == 0)
>  				r = 0;
> -
> -			printf("%s %s a valid multipath device path\n",
> -			       devpath, r == 0 ? "is" : "is not");
> -			goto out;
> +			if (r == 0 ||
> +			    !conf->find_multipaths || !conf->ignore_wwids) {
> +				printf("%s %s a valid multipath device path\n",
> +				       devpath, r == 0 ? "is" : "is not");
> +				goto out;
> +			}
>  		}
>  	}
>  
> -- 
> 2.16.1
