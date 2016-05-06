From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 6/6] libmultipath: fixup dm_rename to
 complete cookie on failure
Date: Fri, 6 May 2016 15:29:21 -0500
Message-ID: <20160506202920.GW26117@octiron.msp.redhat.com>
References: <1462341450-5507-1-git-send-email-hare@suse.de>
	<1462341450-5507-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1462341450-5507-7-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Wed, May 04, 2016 at 07:57:30AM +0200, Hannes Reinecke wrote:
> >From my understanding we should be calling udev_complete() on
> a cookie if dm_task_set_cookie() failed.

I was wrong when I said that this will sometimes be helpful to us. It is
true that it won't hurt things. But that is because it will never do
anything.  There does appear to be a bug in dm_task_set_cookie(), where
it can fail without cleaning up the cookie.  However, when it does that,
it will always zero out the cookie value before returning, so we will
never be able to clean up the cookie ourselves. Also, like I mentioned,
dm_udev_complete doesn't actually clean up the cookie completely. It
needs to be waited on for that.

I don't think that there is ever a time when we should be calling
dm_udev_complete(). None of the dmsetup cookie handling code does. If we
fail to set the cookie, we should just act like the cookie has been
cleaned up by device-mapper (and we need to make device-mapper actually
do that).  Once we call dm_task_run() after setting a cookie, we should
always call dm_udev_wait(), regardless of the whether or not
dm_task_run() fails. And we should never call dm_task_set_cookie()
cookie in the first place for tasks that will not generate a udev event.
That should make this all work correctly.

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  libmultipath/devmapper.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 0ae72fc..5396521 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1442,8 +1442,10 @@ dm_rename (const char * old, char * new)
>  	dm_task_no_open_count(dmt);
>  
>  	if (!dm_task_set_cookie(dmt, &cookie,
> -				DM_UDEV_DISABLE_LIBRARY_FALLBACK))
> +				DM_UDEV_DISABLE_LIBRARY_FALLBACK)) {
> +		dm_udev_complete(cookie);
>  		goto out;
> +	}
>  	r = dm_task_run(dmt);
>  
>  	if (!r)
> -- 
> 2.6.6
