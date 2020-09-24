From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
 lengths for skcipher devices
Date: Thu, 24 Sep 2020 08:58:47 -0700 (PDT)
Message-ID: <17ff78d3-2ef3-414b-8168-2a2f603fcec0@default>
References: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
	<3be1ea32-b6a8-41ef-a9ba-ed691434d068@default>
	<20200924012732.GA10766@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924012732.GA10766@redhat.com>
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
Cc: Damien.LeMoal@wdc.com, ssudhakarp@gmail.com, Martin Petersen <martin.petersen@oracle.com>, dm-crypt@saout.de, dm-devel@redhat.com, Shirley Ma <shirley.ma@oracle.com>, mpatocka@redhat.com, Milan Broz <gmazyland@gmail.com>, agk@redhat.com
List-Id: dm-devel.ids

Hello Mike,

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Wednesday, September 23, 2020 7:28 PM
> To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> Cc: agk@redhat.com; dm-devel@redhat.com; dm-crypt@saout.de;
> mpatocka@redhat.com; Damien.LeMoal@wdc.com; Shirley Ma
> <shirley.ma@oracle.com>; ssudhakarp@gmail.com; Martin Petersen
> <martin.petersen@oracle.com>; Milan Broz <gmazyland@gmail.com>
> Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer lengths for
> skcipher devices
> 
> You've clearly done a nice job with these changes.  Looks clean.

Thanks.

> 
> BUT, I'm struggling to just accept that dm-crypt needs to go to these
> extra lengths purely because of one bad apple usecase.

During my initial stages of investigation, I had the same impression as yours, but digging further, I felt fixing dm-crypt would be more appropriate.

In the following two test cases, windows installation/formatting/booting, all were successful.

Windows Guest <--> Vhost-Scsi <--> LIO(scsi/target/blockio) <--> iSCSI block device
Windows Guest <--> Vhost-Scsi <--> LIO(scsi/target/blockio) <--> Local MegaRaid Block Device

When I inserted dm-crypt in the IO path, that is where I noticed windows boot/install/format failures. The IO path is like this:

Windows Guest <--> Vhost-Scsi <--> LIO(scsi/target/blockio) <-->  dm-crypt <--> iSCSI block device

After these tests, I realized that, when every other component in the IO stack can handle unaligned bio lengths, why can't make dm-crypt handle the same. Hence, the patch.
 
> 
> These alignment constraints aren't new.  Are there other portions of
> Linux's crypto subsystem that needed comparable fixes in order to work
> with Microsfot OS initiated IO through a guest?

I ran basic test with "--cipher aes-xts-plain64" and verified the fix. Also, noticed that the crypto subsystem uses APIs in crypto/skcipher.c which are already specifically written to handle unaligned buffers.

> 
> You forecast that these same kinds of changes are needed for AEAD and
> dm-integrity... that's alarming.

I understand the concern. I have tried to ensure the patch doesn't result in degrade in performance for the Linux use case. If at all, there is any performance impact due to this change, it will be only for windows(I didn't see any performance drop in my test, though).

Thanks
Sudhakar

> 
> Are we _certain_ there is no other way forward?
> (Sorry I don't have suggestions.. I'm in "fact finding mode" ;)
> 
> Thanks,
> Mike
> 
> On Wed, Sep 23 2020 at  1:01pm -0400,
> Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com> wrote:
> 
> > Could someone review this patch set, please?
> >
> > Thanks
> > Sudhakar
> >
> > > -----Original Message-----
> > > From: Sudhakar Panneerselvam
> > > Sent: Wednesday, September 16, 2020 12:40 PM
> > > To: agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com
> > > Cc: Shirley Ma <shirley.ma@oracle.com>; ssudhakarp@gmail.com; Martin
> > > Petersen <martin.petersen@oracle.com>
> > > Subject: [dm-devel] [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
> lengths
> > > for skcipher devices
> > >
> > > Hi,
> > >
> > > This changeset allows processing of unaligned bio requests in dm crypt
> > > for the I/Os generated from a windows guest OS in a QEMU environment.
> If
> > > this changeset is accepted, then I will be submitting another changeset that
> > > addresses the similar issue in AEAD disks and dm-integrity module.
> > >
> > > Thanks
> > > Sudhakar
> > >
> > > Sudhakar Panneerselvam (2):
> > >   dm crypt: Allow unaligned bio buffer lengths for skcipher devices
> > >   dm crypt: Handle unaligned bio buffer lengths for lmk and tcw
> > >
> > >  drivers/md/dm-crypt.c | 154
> +++++++++++++++++++++++++++++++++++----
> > > -----------
> > >  1 file changed, 108 insertions(+), 46 deletions(-)
> > >
> > > --
> > > 1.8.3.1
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> > >
> >
> 
