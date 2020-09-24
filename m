From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
 lengths for skcipher devices
Date: Thu, 24 Sep 2020 10:12:44 -0700 (PDT)
Message-ID: <0b18d5a9-5bf3-41fb-9766-7f4b75019067@default>
References: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
	<3be1ea32-b6a8-41ef-a9ba-ed691434d068@default>
	<alpine.LRH.2.02.2009240834020.11084@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2009240834020.11084@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Damien.LeMoal@wdc.com, ssudhakarp@gmail.com, snitzer@redhat.com, dm-crypt@saout.de, dm-devel@redhat.com, Shirley Ma <shirley.ma@oracle.com>, Martin Petersen <martin.petersen@oracle.com>, agk@redhat.com
List-Id: dm-devel.ids

Hello Mikulas,

> -----Original Message-----
> From: Mikulas Patocka [mailto:mpatocka@redhat.com]
> Sent: Thursday, September 24, 2020 6:40 AM
> To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> Cc: agk@redhat.com; snitzer@redhat.com; dm-devel@redhat.com; dm-
> crypt@saout.de; Damien.LeMoal@wdc.com; Shirley Ma
> <shirley.ma@oracle.com>; ssudhakarp@gmail.com; Martin Petersen
> <martin.petersen@oracle.com>
> Subject: RE: [dm-devel] [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
> lengths for skcipher devices
> 
> 
> 
> On Wed, 23 Sep 2020, Sudhakar Panneerselvam wrote:
> 
> > Could someone review this patch set, please?
> >
> > Thanks
> > Sudhakar
> 
> Hi
> 
> I'd like to ask - what sector size do you use in dm-crypt? Could the issue
> be fixed just by using the smallest possible 512-byte sectors?

My test has been with 512 bytes sector length. 

> 
> What I/O method does qemu use? Is it direct i/o + aio? What is unaligned -
> the base address? Or length? Or the sector number? Could you use strace on
> qemu and show an example of an I/O that fails due to alignment?

Please see my update on June 11 @ https://github.com/virtio-win/kvm-guest-drivers-windows/issues/446 when I originally posted this issue to windows virtio forum. It has some finer details of the reproduction steps and might answer some of your questions.

Also, please see my reply to Eric's email on some of the low level details of function call sequence leading to the issue. If there are further questions, let me know.

Thanks
Sudhakar

> 
> Mikulas
> 
