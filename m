From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 30/57] multipathd: skip uninitialized devices
 during reconfiguration
Date: Mon, 2 May 2016 14:14:07 -0500
Message-ID: <20160502191407.GT26117@octiron.msp.redhat.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-31-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1461755458-29225-31-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Wed, Apr 27, 2016 at 01:10:31PM +0200, Hannes Reinecke wrote:
> libudev has a separate filter setting to skip uninitialized
> devices during enumeration.

So, I assume if udev filters out a device here, it's because a uevent
should be coming when the device is fully initialized. correct?

The only thing I worry about with taking out all of the backup stuff is
what happens if udev simply times out processing an event, and doesn't
grab the UUID.  In this case we still won't get a UUID unless we force
another event, or grab the information ourselves.

But ACK on the patch itself.

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/discovery.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 2fa0907..2cf2566 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -148,6 +148,7 @@ path_discovery (vector pathvec, struct config * conf, int flag)
>  		return -ENOMEM;
>  
>  	udev_enumerate_add_match_subsystem(udev_iter, "block");
> +	udev_enumerate_add_match_is_initialized(udev_iter);
>  	udev_enumerate_scan_devices(udev_iter);
>  
>  	udev_list_entry_foreach(entry,
> -- 
> 2.6.6
