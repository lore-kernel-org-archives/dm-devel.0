From: <Menny_Hamburger@Dell.com>
Subject: Re: [PATCH v2][SCSI] scsi_dh: propagate SCSI device
	deletion
Date: Thu, 16 Dec 2010 16:42:19 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064AFFD087@DUBX7MCDUB01.EMEA.DELL.COM>
References: <D8C50530D6022F40A817A35C40CC06A7064AFC9450@DUBX7MCDUB01.EMEA.DELL.COM>
	<20101215160952.GA20869@redhat.com>
	<D8C50530D6022F40A817A35C40CC06A7064AFFCA3E@DUBX7MCDUB01.EMEA.DELL.COM>
	<20101216140209.GA23507@redhat.com>
	<D8C50530D6022F40A817A35C40CC06A7064AFFCF09@DUBX7MCDUB01.EMEA.DELL.COM>
	<20101216152930.GB23507@redhat.com>
	<D8C50530D6022F40A817A35C40CC06A7064AFFD030@DUBX7MCDUB01.EMEA.DELL.COM>
	<20101216162951.GE23507@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101216162951.GE23507@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com
Cc: Itay_Dar@Dell.com, dm-devel@redhat.com, Rob_Thomas@Dell.com
List-Id: dm-devel.ids

Mike,

Don't forget you have multipathd running in userland that tests each path from user space:
When multipathd detects a path failure it tells the driver to call fail_path on that path - on a system with blk abort this should be enough
(although again - you are making the problem go away instead of preventing it) since all processing doing I/O will be stopped on I/O error.
On a system without blk_abort, doing fail_path is not enough - it just fails the path but does not flush the request queue.
pg_init_done does other things in addition to failing the path - specifically it schedules process_queued_ios that flushes the request queue.

Menny



-----Original Message-----
From: Mike Snitzer [mailto:snitzer@redhat.com] 
Sent: 16 December, 2010 18:30
To: Hamburger, Menny
Cc: Dar, Itay; Thomas, Rob; device-mapper development
Subject: Re: [PATCH v2][SCSI] scsi_dh: propagate SCSI device deletion

On Thu, Dec 16 2010 at 10:52am -0500,
Menny_Hamburger@dell.com <Menny_Hamburger@dell.com> wrote:

> 1) When  I tested this problem, deleting the device set it temporarily
>    to SDEV_DEL (sometimes SDEV_CANCEL) state. So the main issue should
>    be solved with the function returning SCSI_DH_NOSYS.
>    Failing to the default on offline is OK with me since there is no
>    issue with !mw_handler_name because the device still exists.

OK.

> 2) Aborting the request queue does not obviate the need for this
>    patch, it's just that in a system where abort queue exists, the I/O
>    hang will not occur.
>    Another way to say this is that the abort queue functionality (if
>    it worked OK - which it doesn't) hides the problem from the user
>    experience by forcing all the queues to be flushed.

But my point was the blk_abort_queue() wouldn't ever be called for this
case would it?  Because fail_path() isn't called for this SDEV_DEL and
SDEV_CANCEL corner case (hence the need for your patch).

So the relation to blk_abort_queue() is still muddled for me.

>    My preference
>    was always to make sure a problem (in this case the I/O hang) does
>    not occur in the first place rather than take actions when it does.

Sure, I agree, and given blk_abort_queue() is prone to crash -- albeit
a fairly rare race -- we need a solution that doesn't rely on
blk_abort_qeue.  But I'm just missing how blk_abort_queue() was helping
this case (can't see how it would ever be called).

Mike


> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com] 
> Sent: 16 December, 2010 17:30
> To: Hamburger, Menny
> Cc: dm-devel@redhat.com; Thomas, Rob; Dar, Itay
> Subject: [PATCH v2][SCSI] scsi_dh: propagate SCSI device deletion
> 
> On Thu, Dec 16 2010 at  9:21am -0500,
> Menny_Hamburger@Dell.com <Menny_Hamburger@Dell.com> wrote:
> 
> > Mike,
> > 
> > What I meant is that removing the dm-mpath change from the patch makes
> > the operation path go into an area that I did not test (the default
> > case). 
> > I know it's only a !hw_handler_name and a printk (as I said before -
> > this might sound superstitious), however I did my tests with the
> > dm-mpath part, and I prefer to send a 100% tested patch then to add
> > something I did not test.
> > My suggestion was to supply a scsi_dh only patch that goes through the
> > same operation path as the one I tested - via the SCSI_DH_NOSYS case
> > in pg_init_done. In addition, the separation of offline from
> > cancel/del also seems the correct way to do this.
> 
> I see, my misunderstanding.
> 
> - But you're still returning SCSI_DH_DEV_OFFLINED; so if dm mpath's
>   pg_init_done isn't updated to explicitly handle it it'll just
>   fail_path() via the default case.  Are you OK with that?
> 
> - In your initial patch you said: "When running an upstream kernel,
>   the above scenario may not occur because the request queue is aborted
>   when the multipath fails the path."
> 
>   I'm missing _why_ fail_path's call to blk_abort_queue() would obviate
>   the need for this patch.  blk_abort_queue() is only called from
>   fail_path().  But I thought the problem is fail_path() isn't called in
>   this case where the device is SCSI_DH_NOSYS or SCSI_DH_DEV_OFFLINED?
>   -- due to the missing call to activate_complete callback (pg_init_done)
>   (again, I'm very interested in this because we'll be reverting DM
>    mpath's call to blk_abort_queue in the near future). 
> 
> But this would be the revised scsi_dh patch (I'm not sending to
> linux-scsi until I have an answer for the above concerns):
> 
> 
> From: Menny Hamburger <Menny_Hamburger@Dell.com>
> 
> When the scsi_dh_activate returns SCSI_DH_NOSYS the activate_complete
> callback is not called and the error is not propagated to DM mpath.
> 
> When a SCSI device attached to a device handler is deleted, userland
> processes currently performing I/O on the device will have their I/O
> hang forever.  
> 
> - Set SCSI_DH_NOSYS error when the handler is in the process of being
>   deleted (e.g. the SCSI device is in a SDEV_CANCEL or SDEV_DEL state).
> 
> - Set SCSI_DH_DEV_OFFLINED error when device is in SDEV_OFFLINE state.
> 
> - Call the activate_complete callback function directly from
>   scsi_dh_activate if an error has been set (when either the scsi_dh
>   internal data has already been deleted or is in the process of being
>   deleted).
> 
> The patch was tested in an ISCSI environment, RDAC H/W handler and
> multipath.
> In the following reproduction process, dd will I/O hang forever and the
> only way to release it will be to reboot the machine:
> 1) Perform I/O on a multipath device:
>     dd if=/dev/dm-0 of=/dev/zero bs=8k count=1000000 &
> 2) Delete all slave SCSI devices contained in the mpath device:
>    I)  In an ISCSI environment, the easiest way to do this is by
>    stopping ISCSI:
>        /etc/init.d/iscsi stop
>    II) Another way to delete the devices is by applying the following
>    bash scriptlet:
>        dm_devs=$(ls /sys/block/ | grep dm- | xargs)
>        for dm_dev in $dm_devs; do
>          devices=$(ls /sys/block/$dm_dev/slaves)
>          for device in $devices; do
>             echo 1 > /sys/block/$device/device/delete
>          done
>        done
> 
> NOTE: when DM mpath uses blk_abort_queue this scsi_dh change isn't
> required.  However, DM mpath's call to blk_abort_queue has proven to be
> unsafe due to a race (between blk_abort_queue and scsi_request_fn) that
> can lead to list corruption.  Therefore we cannot rely on
> blk_abort_queue (dm mpath's blk_abort_queue call will be reverted and
> will only be restored once the race with scsi_request_fn is fixed).
> 
> Signed-off-by: Menny Hamburger <Menny_Hamburger@Dell.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 6fae3d2..b0c56f6 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -442,12 +442,19 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
>  	sdev = q->queuedata;
>  	if (sdev && sdev->scsi_dh_data)
>  		scsi_dh = sdev->scsi_dh_data->scsi_dh;
> -	if (!scsi_dh || !get_device(&sdev->sdev_gendev))
> +	if (!scsi_dh || !get_device(&sdev->sdev_gendev) ||
> +	    sdev->sdev_state == SDEV_CANCEL ||
> +	    sdev->sdev_state == SDEV_DEL)
>  		err = SCSI_DH_NOSYS;
> +	if (sdev->sdev_state == SDEV_OFFLINE)
> +		err = SCSI_DH_DEV_OFFLINED;
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  
> -	if (err)
> +	if (err) {
> +		if (fn)
> +			fn(data, err);
>  		return err;
> +	}
>  
>  	if (scsi_dh->activate)
>  		err = scsi_dh->activate(sdev, fn, data);
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
