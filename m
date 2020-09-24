From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
 lengths for skcipher devices
Date: Thu, 24 Sep 2020 13:26:59 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2009241314280.28814@file01.intranet.prod.int.rdu2.redhat.com>
References: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
	<3be1ea32-b6a8-41ef-a9ba-ed691434d068@default>
	<20200924012732.GA10766@redhat.com>
	<20200924051419.GA16103@sol.localdomain>
	<252587bb-c0b7-47c9-a97b-91422f8f9c47@default>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <252587bb-c0b7-47c9-a97b-91422f8f9c47@default>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc: Damien.LeMoal@wdc.com, ssudhakarp@gmail.com, Mike Snitzer <snitzer@redhat.com>, dm-crypt@saout.de, Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com, Shirley Ma <shirley.ma@oracle.com>, Martin Petersen <martin.petersen@oracle.com>, Milan Broz <gmazyland@gmail.com>, agk@redhat.com
List-Id: dm-devel.ids



On Thu, 24 Sep 2020, Sudhakar Panneerselvam wrote:

> Hello Eric,
> 
> > -----Original Message-----
> > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > Sent: Wednesday, September 23, 2020 11:14 PM
> > To: Mike Snitzer <snitzer@redhat.com>
> > Cc: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>;
> > Damien.LeMoal@wdc.com; ssudhakarp@gmail.com; Martin Petersen
> > <martin.petersen@oracle.com>; dm-crypt@saout.de; dm-devel@redhat.com;
> > Shirley Ma <shirley.ma@oracle.com>; mpatocka@redhat.com; Milan Broz
> > <gmazyland@gmail.com>; agk@redhat.com
> > Subject: Re: [dm-devel] [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
> > lengths for skcipher devices
> > 
> > On Wed, Sep 23, 2020 at 09:27:32PM -0400, Mike Snitzer wrote:
> > > You've clearly done a nice job with these changes.  Looks clean.
> > >
> > > BUT, I'm struggling to just accept that dm-crypt needs to go to these
> > > extra lengths purely because of one bad apple usecase.
> > >
> > > These alignment constraints aren't new.  Are there other portions of
> > > Linux's crypto subsystem that needed comparable fixes in order to work
> > > with Microsfot OS initiated IO through a guest?
> > >
> > > You forecast that these same kinds of changes are needed for AEAD and
> > > dm-integrity... that's alarming.
> > >
> > > Are we _certain_ there is no other way forward?
> > > (Sorry I don't have suggestions.. I'm in "fact finding mode" ;)
> > >
> > 
> > I don't understand why this is needed, since dm-crypt already sets its
> > logical_block_size to its crypto sector_size.  Isn't it expected that I/O that
> > isn't aligned to logical_block_size fails?  It's the I/O submitter's
> > responsibility to ensure logical_block_size alignment of all I/O segments.
> > Exactly how is the misaligned I/O actually being submitted here?
> 
> You are right that each I/O size should be a multiple of the block 
> device's sector size, but I am not sure if there is any constraint that 
> individual segment lengths should be aligned to its sector size, could 
> you help me with how this is enforced in block layer? The closest I see 
> is "dma_alignment" member in "struct request_queue" of the low-level 
> block device driver and as mentioned in the patch description, iSCSI, 
> MegaRaid, qla2xxx, nvme and others have much relaxed constraint.
> 
> To your other question, the IO stack looks like this:
> 
> Windows Guest <--> Vhost-Scsi <--> LIO(scsi/target/blockio) <-->  dm-crypt <--> iSCSI block device
> 
> One real example out of my debugging: Windows sends a I/O request with 
> 6656 bytes to vhost-scsi interface. Vhost-scsi uses translate_desc() in 
> drivers/vhost/vhost.c to convert windows user space memory buffers to 
> kernel iovecs. Vhost-scsi then converts the iovecs to sg entries in 
> vhost_scsi_mapal() which is then handed over to "target" subsystem and 
> eventually submitted to dm-crypt. This 6656 bytes IO has got 3 segments, 
> first segment had 1584, second 4096 and the last had 976 bytes. Dm-crypt 
> rejects the I/O after seeing the first segment length 1584 which is not 
> a 512 byte multiple.
> 
> Let me know if there are further questions.
> 
> Thanks
> Sudhakar

Hi

I think it should be fixed in vhost-scsi.

Mikulas
