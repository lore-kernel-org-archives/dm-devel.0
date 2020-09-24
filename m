From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
 lengths for skcipher devices
Date: Thu, 24 Sep 2020 10:38:26 -0700 (PDT)
Message-ID: <7b6fdfd5-0160-4bcf-b7ed-d0e51553c678@default>
References: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
	<3be1ea32-b6a8-41ef-a9ba-ed691434d068@default>
	<20200924012732.GA10766@redhat.com>
	<20200924051419.GA16103@sol.localdomain>
	<252587bb-c0b7-47c9-a97b-91422f8f9c47@default>
	<alpine.LRH.2.02.2009241314280.28814@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2009241314280.28814@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Damien.LeMoal@wdc.com, ssudhakarp@gmail.com, Mike Snitzer <snitzer@redhat.com>, dm-crypt@saout.de, Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com, Ma <shirley.ma@oracle.com>, Martin Petersen <martin.petersen@oracle.com>, Shirley, Milan Broz <gmazyland@gmail.com>, agk@redhat.com
List-Id: dm-devel.ids

Hi Mikulas,

> > Windows Guest <--> Vhost-Scsi <--> LIO(scsi/target/blockio) <-->  dm-crypt
> <--> iSCSI block device
> >
> > One real example out of my debugging: Windows sends a I/O request with
> > 6656 bytes to vhost-scsi interface. Vhost-scsi uses translate_desc() in
> > drivers/vhost/vhost.c to convert windows user space memory buffers to
> > kernel iovecs. Vhost-scsi then converts the iovecs to sg entries in
> > vhost_scsi_mapal() which is then handed over to "target" subsystem and
> > eventually submitted to dm-crypt. This 6656 bytes IO has got 3 segments,
> > first segment had 1584, second 4096 and the last had 976 bytes. Dm-crypt
> > rejects the I/O after seeing the first segment length 1584 which is not
> > a 512 byte multiple.
> >
> > Let me know if there are further questions.
> >
> > Thanks
> > Sudhakar
> 
> Hi
> 
> I think it should be fixed in vhost-scsi.

In the above example of 6656 bytes I/O, windows allocates 6656 bytes virtually contiguous I/O. This IO, when it lands in the kernel, translates to 3 physically discontiguous pages, that's why translate_desc() had to create 3 iovecs to handle this I/O. I don't understand how vhost-scsi could have solved this issue. Only other possibility I see is to have windows fix it by always sending 512 byte aligned buffer lengths, but going with my earlier point that every other component in the Linux IO path handles this case well except for dm-crypt, so it make more sense to fix it in dm-crypt.

Thanks
Sudhakar

> 
> Mikulas
> 
