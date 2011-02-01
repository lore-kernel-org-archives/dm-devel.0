From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: [PATCH]: scsi_dh_rdac: fix BUG_ON in get_rdac_data
 from within send_mode_select
Date: Tue, 1 Feb 2011 13:39:08 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF37311A@cosmail01.lsi.com>
References: <D8C50530D6022F40A817A35C40CC06A7064B3773D8@DUBX7MCDUB01.EMEA.DELL.COM>
	<E463DF2B2E584B4A82673F53D62C2EF4FF372CBD@cosmail01.lsi.com>
	<D8C50530D6022F40A817A35C40CC06A7064B377EFA@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A7064B377EFA@DUBX7MCDUB01.EMEA.DELL.COM>
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
To: "Menny_Hamburger@Dell.com" <Menny_Hamburger@Dell.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids



> -----Original Message-----
> From: Menny_Hamburger@Dell.com [mailto:Menny_Hamburger@Dell.com]
> Sent: Tuesday, February 01, 2011 2:03 AM
> To: Moger, Babu
> Cc: dm-devel@redhat.com
> Subject: RE: [dm-devel] [PATCH]: scsi_dh_rdac: fix BUG_ON in get_rdac_data
> from within send_mode_select
> 
> Hi Babu,
> 
> I ran the tests with my earlier patch intact.
> 
> I reviewed your patches and I can see how they solve the same issue.
> I also acknowledge that we have two different approaches here:
> 1) The patches you suggest solves the issue in a wider range (for all SCSI
> device handlers).
>    The patches are quite complex (several pieces of code) so the potential
> for bugs is higher, and they will require a wider range of testing.
> 2) The patch I submitted solves this issue only in the RDAC hardware
> driver.
>    Since we do have time to market issues involved, if the patch has no
> logical flaws and solves the problem locally I think I will apply it
>    on our side.
> 
> I would like to suggest these action items:
> 1) After you modify the patches to fit the current code, I will test the
> patches here with our RDAC environment that seems quite adequate for
> detecting
>    these problems.
> 2) Please review my patch and see if it has any logical flaws. I tested
> the patch in our test scenario a few hundreds of times and it
>    I seems to be doing what it's supposed to.
> 
> Best Regards,
> Menny
> This panic comes from get_rdac_data, which is called from within the
> send_mode_select code.
> My analysis picked up the following problem:
> The RDAC detach code nullifies the scsi_dh_data before flushing the mode
> select workqueue, and as result a pending send_mode_select will BUG_ON in
> get_rdac_data.
> The following patch (tested over RHEL54) flushes the workqueue before
> setting scsi_dh_data to NULL:


Your code looks bit different than what I have. I don't have RHEL5.4. I looked at RHEL 5.3. I don't see get_rdac_data in send_mode_select. However, I got the logic behind your code. Your logic helps in cases where get_rdac_data is used in the same context as mode select submission. But, if you use get_rdac_data in other places then this code does not help.  I see get_rdac_data in rdac_activate which is used before send_mode_select.

 
> diff -r -U 2 a/drivers/scsi/device_handler/scsi_dh_rdac.c
> b/drivers/scsi/device_handler/scsi_dh_rdac.c
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c        2011-01-30
> 11:02:31.271426000 +0200
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c        2011-01-30
> 11:02:31.327069000 +0200
> @@ -853,8 +853,22 @@
>         spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>         scsi_dh_data = retrieve_scsi_dh_data(sdev);
> -       store_scsi_dh_data(sdev, NULL);
>         spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> 
>         h = (struct rdac_dh_data *) scsi_dh_data->buf;
> +       if (h->ctlr) {
> +               int flush;
> +
> +               spin_lock(&h->ctlr->ms_lock);
> +               flush = (h->ctlr->ms_sdev == sdev);
> +               spin_unlock(&h->ctlr->ms_lock);
> +
> +               if (flush)
> +                       flush_workqueue(kmpath_rdacd);
> +       }
> +
> +       spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
> +       store_scsi_dh_data(sdev, NULL);
> +       spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
> +
>         if (h->ctlr)
>                 kref_put(&h->ctlr->kref, release_controller);
> 
> 
> 
> The patch ensures that we run flush only when detaching the device the
> "owns" the send_mode_select (ms_sdev).
> 
> Menny
> 
> 
