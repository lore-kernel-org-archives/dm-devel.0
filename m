From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: Re: [PATCH v2 2/5] scsi_dh: add
	scsi_dh_attached_handler_name
Date: Wed, 9 May 2012 17:40:44 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B05D284@SACEXCMBX02-PRD.hq.netapp.com>
References: <1336514167-15393-1-git-send-email-snitzer@redhat.com>
	<1336514167-15393-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1336514167-15393-3-git-send-email-snitzer@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

Mike, I have a question for you below.

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Tuesday, May 08, 2012 4:56 PM
> To: dm-devel@redhat.com
> Cc: agk@redhat.com; hare@suse.de; Moger, Babu; sekharan@us.ibm.com;
> Mike Snitzer
> Subject: [PATCH v2 2/5] scsi_dh: add scsi_dh_attached_handler_name
> 
> Introduce scsi_dh_attached_handler_name() to retrieve the name of the
> scsi_dh that is attached to the scsi_device associated with the provided
> request queue.  Returns NULL if a scsi_dh is not attached.
> 
> Also, fix scsi_dh_{attach,detach} function header comments to document
> @q rather than @sdev.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh.c |   31
> +++++++++++++++++++++++++++++--
>  include/scsi/scsi_dh.h                |    5 +++++
>  2 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c
> b/drivers/scsi/device_handler/scsi_dh.c
> index 48e46f5..7497c78 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -468,7 +468,8 @@ EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
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
> @@ -527,6 +529,31 @@ void scsi_dh_detach(struct request_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(scsi_dh_detach);
> 
> +/*
> + * scsi_dh_attached_handler_name - Get attached device handler's name
> + * @q - Request queue that is associated with the scsi_device
> + *      that may have a device handler attached
> + *
> + * Returns name of attached scsi_dh, NULL if no handler is attached.
> + */
> +const char *scsi_dh_attached_handler_name(struct request_queue *q)
> +{
> +	unsigned long flags;
> +	struct scsi_device *sdev;
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	sdev = q->queuedata;
> +	if (!sdev || !get_device(&sdev->sdev_gendev))
> +		sdev = NULL;
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +
> +	if (!sdev || !sdev->scsi_dh_data)
> +		return NULL;
> +
> +	return sdev->scsi_dh_data->scsi_dh->name;
> +}


I only see get_device call.  I don't see matching put_device call.  Was  that on purspose?


> +EXPORT_SYMBOL_GPL(scsi_dh_attached_handler_name);
> +
>  static struct notifier_block scsi_dh_nb = {
>  	.notifier_call = scsi_dh_notifier
>  };
> diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
> index e3f2db2..94f502b 100644
> --- a/include/scsi/scsi_dh.h
> +++ b/include/scsi/scsi_dh.h
> @@ -60,6 +60,7 @@ extern int scsi_dh_activate(struct request_queue *,
> activate_complete, void *);
>  extern int scsi_dh_handler_exist(const char *);
>  extern int scsi_dh_attach(struct request_queue *, const char *);
>  extern void scsi_dh_detach(struct request_queue *);
> +extern const char *scsi_dh_attached_handler_name(struct request_queue
> *q);
>  extern int scsi_dh_set_params(struct request_queue *, const char *);
>  #else
>  static inline int scsi_dh_activate(struct request_queue *req,
> @@ -80,6 +81,10 @@ static inline void scsi_dh_detach(struct request_queue
> *q)
>  {
>  	return;
>  }
> +static inline const char *scsi_dh_attached_handler_name(struct
> request_queue *q)
> +{
> +	return NULL;
> +}
>  static inline int scsi_dh_set_params(struct request_queue *req, const char
> *params)
>  {
>  	return -SCSI_DH_NOSYS;
> --
> 1.7.4.4
