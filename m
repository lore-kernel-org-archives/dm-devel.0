From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 46/54] libmultipath: path_discover(): always
 set DI_BLACKLIST
Date: Fri, 17 Jul 2020 17:21:08 -0500
Message-ID: <20200717222108.GS11089@octiron.msp.redhat.com>
References: <20200709103623.8302-1-mwilck@suse.com>
	<20200709103623.8302-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103623.8302-5-mwilck@suse.com>
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

On Thu, Jul 09, 2020 at 12:36:15PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since 65e1845 ("multipath: call store_pathinfo with DI_BLACKLIST"), we
> use DI_BLACKLIST for new paths. There's no reason why we shouldn't do the
> same with paths which are (unexpectedly) already in pathvec. As argued
> for 65e1845, this might save some unnecessary work for paths which are
> blacklisted anyway.

It seems to me like either we should assume that if we added the path to
pathvec, it's valid, or we should check, and if it's blacklisted, remove
it. Just leaving it on pathvec without all of the pathinfo work done
doesn't make much sense to me. Am I missing something here?

-Ben
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/discovery.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 5f4ebf0..caabfef 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -137,7 +137,7 @@ path_discover (vector pathvec, struct config * conf,
>  				      udevice, flag | DI_BLACKLIST,
>  				      NULL);
>  	else
> -		return pathinfo(pp, conf, flag);
> +		return pathinfo(pp, conf, flag | DI_BLACKLIST);
>  }
>  
>  static void cleanup_udev_enumerate_ptr(void *arg)
> -- 
> 2.26.2
