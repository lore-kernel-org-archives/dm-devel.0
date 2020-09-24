From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
 lengths for skcipher devices
Date: Thu, 24 Sep 2020 08:40:25 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2009240834020.11084@file01.intranet.prod.int.rdu2.redhat.com>
References: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
	<3be1ea32-b6a8-41ef-a9ba-ed691434d068@default>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3be1ea32-b6a8-41ef-a9ba-ed691434d068@default>
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
Cc: Damien.LeMoal@wdc.com, ssudhakarp@gmail.com, snitzer@redhat.com, dm-crypt@saout.de, dm-devel@redhat.com, Shirley Ma <shirley.ma@oracle.com>, Martin Petersen <martin.petersen@oracle.com>, agk@redhat.com
List-Id: dm-devel.ids



On Wed, 23 Sep 2020, Sudhakar Panneerselvam wrote:

> Could someone review this patch set, please?
> 
> Thanks
> Sudhakar

Hi

I'd like to ask - what sector size do you use in dm-crypt? Could the issue 
be fixed just by using the smallest possible 512-byte sectors?

What I/O method does qemu use? Is it direct i/o + aio? What is unaligned - 
the base address? Or length? Or the sector number? Could you use strace on 
qemu and show an example of an I/O that fails due to alignment?

Mikulas
