From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: do not change SCSI device handler
Date: Wed, 3 Apr 2013 09:32:34 -0400
Message-ID: <20130403133234.GA2197@redhat.com>
References: <Pine.LNX.4.64.1304022000390.27554@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304022000390.27554@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 02 2013 at  8:04pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> This fixes BZ 912245 and 902595.
> 
> Mikulas
> 
> ---
> 
> dm-mpath: do not change SCSI device handler
> 
> This patch prevents the multipath target from changing the device handler.
> This fixes a kernel crash that can happen when changing the device
> handler.
> 
> When we reload a multipath device, there are two instances of the
> multipath target - the first instance that is active and the second
> instance that is being constructed with "ctr" method.
> 
> If the multipath constructor finds out that the device is using a
> different device handler, it detaches the existing handler and attaches a
> new handler. However, the first instance of the multipath target still
> exists and processes requests. If the first instance sends some
> path-management request with scsi_dh_activate and the second instance
> detaches the device handler while the path-management request is in
> flight, a crash happens. The reason for the crash is that the endio
> routine for the path-management request is working with structures that
> were freed when the handler was detached.
> 
> There is no practical need to change device handlers on an active device,
> so this patch disables it.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-mpath.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> Index: linux-3.9-rc5-fast/drivers/md/dm-mpath.c
> ===================================================================
> --- linux-3.9-rc5-fast.orig/drivers/md/dm-mpath.c	2013-04-02 21:54:25.000000000 +0200
> +++ linux-3.9-rc5-fast/drivers/md/dm-mpath.c	2013-04-03 01:15:04.000000000 +0200
> @@ -618,12 +618,13 @@ static struct pgpath *parse_path(struct 
>  		 */
>  		r = scsi_dh_attach(q, m->hw_handler_name);
>  		if (r == -EBUSY) {
> -			/*
> -			 * Already attached to different hw_handler:
> -			 * try to reattach with correct one.
> -			 */
> -			scsi_dh_detach(q);
> -			r = scsi_dh_attach(q, m->hw_handler_name);
> +			ti->error = "a different device handler is already "
> +				"attached";

Don't really need to wrap this to multiple lines (helps searching).

> +			DMERR("A different device handler for device %s is "
> +				"attached. You need to deactivate "
> +				"the device to change device handler.",
> +				p->path.dev->name);
> +			goto bad;
>  		}
>  
>  		if (r < 0) {

We should include the currently attached scsi_dh in the DMERR message,
e.g.:
	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
	DMERR("The %s device handler for devices %s is already attached.  ...",
	      attached_handler_name, p->path.dev->name);
	kfree(attached_handler_name);
	goto bad;

Otherwise, looks good.

Acked-by: Mike Snitzer <snitzer@redhat.com>
