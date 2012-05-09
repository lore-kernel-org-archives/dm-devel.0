From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH v3 2/5] scsi_dh: add
	scsi_dh_attached_handler_name
Date: Wed, 09 May 2012 17:54:23 -0500
Message-ID: <1336604063.1118.99.camel@chandra-lucid.austin.ibm.com>
References: <1336514167-15393-1-git-send-email-snitzer@redhat.com>
	<1336514167-15393-3-git-send-email-snitzer@redhat.com>
	<77471C95FAFD844C8CA02DD4F4C5FE2B05D284@SACEXCMBX02-PRD.hq.netapp.com>
	<20120509204101.GB26785@redhat.com>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120509204101.GB26785@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

Mike, you may have to cross post to linux-scsi for James to pick it up.

On Wed, 2012-05-09 at 16:41 -0400, Mike Snitzer wrote:
> Introduce scsi_dh_attached_handler_name() to retrieve the name of the
> scsi_dh that is attached to the scsi_device associated with the provided
> request queue.  Returns NULL if a scsi_dh is not attached.
> 
> Also, fix scsi_dh_{attach,detach} function header comments to document
> @q rather than @sdev.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh.c |   36 ++++++++++++++++++++++++++++++++--
>  include/scsi/scsi_dh.h                |    5 ++++
>  2 files changed, 39 insertions(+), 2 deletions(-)
> 
> v3: fixed missing put_device that Babu pointed out
> 
> Index: linux-2.6/drivers/scsi/device_handler/scsi_dh.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/device_handler/scsi_dh.c
> +++ linux-2.6/drivers/scsi/device_handler/scsi_dh.c
> @@ -468,7 +468,8 @@ EXPORT_SYMBOL_GPL(scsi_dh_handler_exist)
> 
>  /*
>   * scsi_dh_attach - Attach device handler
> - * @sdev - sdev the handler should be attached to
> + * @q - Request queue that is associated with the scsi_device
> + *      the handler should be attached to
>   * @name - name of the handler to attach
>   */
>  int scsi_dh_attach(struct request_queue *q, const char *name)
> @@ -498,7 +499,8 @@ EXPORT_SYMBOL_GPL(scsi_dh_attach);
> 
>  /*
>   * scsi_dh_detach - Detach device handler
> - * @sdev - sdev the handler should be detached from
> + * @q - Request queue that is associated with the scsi_device
> + *      the handler should be detached from
>   *
>   * This function will detach the device handler only
>   * if the sdev is not part of the internal list, ie
> @@ -527,6 +529,36 @@ void scsi_dh_detach(struct request_queue
>  }
>  EXPORT_SYMBOL_GPL(scsi_dh_detach);
> 
> +/*
> + * scsi_dh_attached_handler_name - Get attached device handler's name
> + * @q - Request queue that is associated with the scsi_device
> + *      that may have a device handler attached
> + *
> + * Returns name of attached handler, NULL if no handler is attached.
> + */
> +const char *scsi_dh_attached_handler_name(struct request_queue *q)
> +{
> +	unsigned long flags;
> +	struct scsi_device *sdev;
> +	const char *handler_name = NULL;
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	sdev = q->queuedata;
> +	if (!sdev || !get_device(&sdev->sdev_gendev))
> +		sdev = NULL;
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +
> +	if (!sdev)
> +		return NULL;
> +
> +	if (sdev->scsi_dh_data)
> +		handler_name = sdev->scsi_dh_data->scsi_dh->name;
> +
> +	put_device(&sdev->sdev_gendev);
> +	return handler_name;
> +}
> +EXPORT_SYMBOL_GPL(scsi_dh_attached_handler_name);
> +
>  static struct notifier_block scsi_dh_nb = {
>  	.notifier_call = scsi_dh_notifier
>  };
> Index: linux-2.6/include/scsi/scsi_dh.h
> ===================================================================
> --- linux-2.6.orig/include/scsi/scsi_dh.h
> +++ linux-2.6/include/scsi/scsi_dh.h
> @@ -60,6 +60,7 @@ extern int scsi_dh_activate(struct reque
>  extern int scsi_dh_handler_exist(const char *);
>  extern int scsi_dh_attach(struct request_queue *, const char *);
>  extern void scsi_dh_detach(struct request_queue *);
> +extern const char *scsi_dh_attached_handler_name(struct request_queue *q);
>  extern int scsi_dh_set_params(struct request_queue *, const char *);
>  #else
>  static inline int scsi_dh_activate(struct request_queue *req,
> @@ -80,6 +81,10 @@ static inline void scsi_dh_detach(struct
>  {
>  	return;
>  }
> +static inline const char *scsi_dh_attached_handler_name(struct request_queue *q)
> +{
> +	return NULL;
> +}
>  static inline int scsi_dh_set_params(struct request_queue *req, const char *params)
>  {
>  	return -SCSI_DH_NOSYS;
> 
