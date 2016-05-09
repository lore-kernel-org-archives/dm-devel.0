From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 5/7] multipathd: wait for udev in cli_resume()
Date: Mon, 9 May 2016 13:01:44 -0500
Message-ID: <20160509180144.GA26117@octiron.msp.redhat.com>
References: <1462791185-2903-1-git-send-email-hare@suse.de>
	<1462791185-2903-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1462791185-2903-6-git-send-email-hare@suse.de>
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

On Mon, May 09, 2016 at 12:53:03PM +0200, Hannes Reinecke wrote:
> When calling 'cli_resume()' we should be waiting for udev to
> ensure the device really has been resumed.

Since multipathd has udev sync support disabled, this change doesn't do
anything (which is fine, since I don't see any need to wait for udev
here). It does allow your next patch to remove the need_sync option,
which is (I assume) the bigger point.

ACK

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  multipathd/cli_handlers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 0397353..5112786 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -967,7 +967,7 @@ cli_resume(void * v, char ** reply, int * len, void * data)
>  		return 1;
>  	}
>  
> -	r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 0, 0);
> +	r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 1, 0);
>  
>  	condlog(2, "%s: resume (operator)", param);
>  
> -- 
> 2.6.6
