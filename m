From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] scsi_dh: Allow NULL hardware handler
 name in scsi_dh_attach()
Date: Tue, 8 May 2012 10:27:36 -0400
Message-ID: <20120508142736.GE8383@redhat.com>
References: <1336486687-31535-1-git-send-email-hare@suse.de>
	<1336486687-31535-2-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1336486687-31535-2-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Babu Moger <babu.moger@netapp.com>
List-Id: dm-devel.ids

On Tue, May 08 2012 at 10:18am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> This patch allows to pass in a NULL hardware handler to
> scsi_dh_attach(), causing the reference count of the existing
> hardware handler to be increased.
> An error will be returned if no hardware handler is attached.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 48e46f5..9820f1f 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -475,10 +475,14 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
>  {
>  	unsigned long flags;
>  	struct scsi_device *sdev;
> -	struct scsi_device_handler *scsi_dh;
> +	struct scsi_device_handler *scsi_dh = NULL;
>  	int err = 0;
>  
> -	scsi_dh = get_device_handler(name);
> +	if (name) {
> +		scsi_dh = get_device_handler(name);
> +	} else if (sdev && sdev->scsi_dh_data) {
> +		scsi_dh = sdev->scsi_dh_data->scsi_dh;
> +	}

Like the first time you posted this, sdev is not initialized where
you're trying to use it (the sdev initialization happens later in
scsi_dh_attach).  And you have extraneous curly braces.
