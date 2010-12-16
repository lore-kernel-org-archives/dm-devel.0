From: <Menny_Hamburger@Dell.com>
Subject: Re: [Patch 2 of 2]: scsi-dh + dm-mpath: propagate SCSI
 device deletion to multipath
Date: Thu, 16 Dec 2010 14:21:45 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064AFFCF09@DUBX7MCDUB01.EMEA.DELL.COM>
References: <D8C50530D6022F40A817A35C40CC06A7064AFC9450@DUBX7MCDUB01.EMEA.DELL.COM>
	<20101215160952.GA20869@redhat.com>
	<D8C50530D6022F40A817A35C40CC06A7064AFFCA3E@DUBX7MCDUB01.EMEA.DELL.COM>
	<20101216140209.GA23507@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101216140209.GA23507@redhat.com>
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
Cc: dm-devel@redhat.com, Itay_Dar@Dell.com, Rob_Thomas@Dell.com
List-Id: dm-devel.ids

Mike,

What I meant is that removing the dm-mpath change from the patch makes the operation path go into an area that I did not test (the default case).
I know it's only a !hw_handler_name and a printk (as I said before - this might sound superstitious), however I did my tests with the dm-mpath part,
and I prefer to send a 100% tested patch then to add something I did not test.
My suggestion was to supply a scsi_dh only patch that goes through the same operation path as the one I tested - via the SCSI_DH_NOSYS case in pg_init_done. In addition, the separation of offline from cancel/del also seems the correct way to do this.

Hope this makes sense,
Menny





-----Original Message-----
From: Mike Snitzer [mailto:snitzer@redhat.com] 
Sent: 16 December, 2010 16:02
To: Hamburger, Menny
Cc: dm-devel@redhat.com; Thomas, Rob; Dar, Itay
Subject: Re: [Patch 2 of 2]: scsi-dh + dm-mpath: propagate SCSI device deletion to multipath

On Thu, Dec 16 2010 at  2:32am -0500,
Menny_Hamburger@Dell.com <Menny_Hamburger@Dell.com> wrote:

> Hi Mike,
> 
> I am sorry about the submission problems, there's a first time for everything...
> 
> I know this sounds superstitious but I did run quite thorough tests on
> this issue and I would really prefer that the proposed patch would go
> through the same code path as the one I have tested.
> 
> My suggestion is to modify the scsi_dh code as follows:
> 
> if (!scsi_dh || !get_device(&sdev->sdev_gendev) ||
>     sdev->sdev_state == SDEV_CANCEL ||
>     sdev->sdev_state == SDEV_DEL)
>        err = SCSI_DH_NOSYS;   
> 
> if (sdev->sdev_state == SDEV_OFFLINE)
>        err = SCSI_DH_DEV_OFFLINED;
> 
> if (err) {
>     if (fn)
>         fn(fn_data, err);
> 
>     return err;
> } 
> 
> There is logic and benefits here:
> 1) SDEV_CANCEL/SDEV_DEV are just a stage before the DH is deleted so we can respond with the same SCSI_DH_NOSYS.
>    I think it's best here to handle these together, since they are in fact the same thing. 
>    In addition, when we delete a device, I don't think it goes through an offline state.
> 2) SDEV_OFFLINE is easily reverted by echoing to the state of the device - it's not like detaching.
>    Returning SCSI_DH_DEV_OFFLINED will just call the default case and perform fail_path - no need to worry about any handler issues here.
> 3) It will let me sleep better at night...

I think you misunderstood me.

We had a bugzilla exchange yesterday (and as you stated above):  the
dm-mpath change isn't required so it is only the scsi_dh patch that
needs to go upstream.

I didn't take issue with your scsi_dh patch.  What I shared (below) was
that dm-devel isn't the appropriate place to email a patch that is
exclussively for scsi_dh.  (This is just the tedious bit of "how does
this change go upstream?").

I'll take care of rebasing your scsi_dh patch to the scsi-misc git tree
I referenced and then send the patch to linux-scsi on your behalf.

Regards,
Mike


> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com] 
> Sent: 15 December, 2010 18:10
> To: Hamburger, Menny
> Cc: dm-devel@redhat.com
> Subject: Re: [Patch 2 of 2]: scsi-dh + dm-mpath: propagate SCSI device deletion to multipath
> 
> On Wed, Dec 15 2010 at  3:31am -0500,
> Menny_Hamburger@dell.com <Menny_Hamburger@dell.com> wrote:
> 
> > The problem:
> > When a SCSI device attached to a device handler is deleted, userland processes currently performing I/O on the device will I/O hang forever.
> > 
> > Attached is the multipath layer part of the patch.
> 
> Please do not use attachments when submitting patches.  Please inline
> the patch in the body of the mail.  Also please trim extraneous info
> when you reply to mails and please do not top-post.
> 
> Your patch submissions were not well received by the dm-devel patchwork
> (which automatically collects submitted dm-devel patches so they don't
> get lost in the shuffle).
> 
> Also, please use unique and descriptive subjects for the patches in a
> multipatch series.
> 
> As for the proposed mpath change: Babu already pointed out that you
> don't need this mpath change as the default case already performs
> fail_path().
> 
> So all you need is that scsi_dh patch to get upstream.  But to do that
> you'll need to:
> 1) create a patch against the upstream scsi-misc tree (not RHEL5.5):
>    git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> 2) send the patch to the linux-scsi@vger.kernel.org mailing list (feel
>    free to cc dm-devel too).
> 
> Once this change is in the upstream scsi tree it'll propagate to RHEL
> releases.
> 
> Thanks,
> Mike
