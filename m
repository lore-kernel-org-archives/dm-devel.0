From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 40/57] libmultipath: fixup dm_rename to
 complete cookie on failure
Date: Mon, 2 May 2016 20:16:37 -0500
Message-ID: <20160503011637.GX26117@octiron.msp.redhat.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-41-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1461755458-29225-41-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Wed, Apr 27, 2016 at 01:10:41PM +0200, Hannes Reinecke wrote:

I usually try to follow the lead of the cookie using-code of the lvm2
library, and that doesn't call udev_complete() on dm_task_set_cookie()
failures. However, it does look like there is a possible problem with

dm_task_set_cookie -> _udev_notify_sem_inc -> semctl(semid, 0, GETVAL)

or

dm_task_set_cookie -> _udev_notify_sem_create -> semctl(gen_semid, 0,
GETVAL) or later

failing.  If that happens, the semaphore stays incremented, and
dm_task_set_cookie returns failure.  In the general case it could be
risky to call udev_complete when dm_task_set_cookie failed. The 
semaphore might have not gotten incremented, and if we were doing
multiple operations with the cookie, we might not wait for all of them
any more. But the way multipath is using cookies, I think this is
always safe. At worst, it won't be necessary, and we'll do nothing.

But this should probably get fixed in the libdevmapper code, so that
when dm_task_set_cookie fails, in cleans up any partial operations.

ACK (we can pull these back out when it's been sorted in libdevmapper)
-Ben

> >From my understanding we should be calling udev_complete() on
> a cookie if dm_task_set_cookie() failed.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  libmultipath/devmapper.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index c2ae83b..b10f9e6 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1440,8 +1440,10 @@ dm_rename (const char * old, char * new)
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
