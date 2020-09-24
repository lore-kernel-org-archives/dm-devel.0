From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
 lengths for skcipher devices
Date: Thu, 24 Sep 2020 14:44:33 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2009241421170.8544@file01.intranet.prod.int.rdu2.redhat.com>
References: <1600281606-1446-1-git-send-email-sudhakar.panneerselvam@oracle.com>
	<3be1ea32-b6a8-41ef-a9ba-ed691434d068@default>
	<20200924012732.GA10766@redhat.com>
	<20200924051419.GA16103@sol.localdomain>
	<252587bb-c0b7-47c9-a97b-91422f8f9c47@default>
	<alpine.LRH.2.02.2009241314280.28814@file01.intranet.prod.int.rdu2.redhat.com>
	<7b6fdfd5-0160-4bcf-b7ed-d0e51553c678@default>
	<alpine.LRH.2.02.2009241345370.4229@file01.intranet.prod.int.rdu2.redhat.com>
	<fd512a7d-c064-4812-a794-5274c10687db@default>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <fd512a7d-c064-4812-a794-5274c10687db@default>
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

> > By copying it to a temporary aligned buffer and issuing I/O on this
> > buffer.
> 
> I don't like this idea. Because, you need to allocate additional pages 
> for the entire I/O size(for the misaligned case, if you think through 

You can break the I/O to smaller pieces. You can use mempool for 
pre-allocation of the pages.

> carefully, you will know why we have to allocate a temporary buffer that 
> is as big as the original IO) and on top of it, copying the buffer from 
> original to temporary buffer which is all unnecessary while it can 
> simply be fixed in dm-crypt without any of these additional overheads.
> 
> > 
> > > Only other
> > > possibility I see is to have windows fix it by always sending 512 byte
> > > aligned buffer lengths, but going with my earlier point that every other
> > > component in the Linux IO path handles this case well except for
> > > dm-crypt, so it make more sense to fix it in dm-crypt.
> > >
> > > Thanks
> > > Sudhakar
> > 
> > Are you sure that the problem is only with dm-crypt? You haven't tried all
> > the existing block device drivers, have you?
> 
> My question is, why dm-crypt worries about alignment requirement of 
> other layers? Is there anything that impacts dm-crypt if the segment 
> lengths are not aligned?(I believe this case is just not handled so far 

Because the code is simpler if it assumes aligned buffers.

> in dm-crypt and my patch addresses it). Should dm-crypt not just pass on 
> all those I/O requests to those respective layers to handle it which 
> will be more graceful?
> 
> -Sudhakar

So, suppose that we change dm-crypt to handle your workload - what are you 
going to do with other block device drivers that assume aligned bio vector 
length? How will you find all the other drivers that need to be changed?

You are claiming that "every other component in the Linux IO path handles 
this case well except for dm-crypt", but this claim is wrong. There are 
other driver that don't handle misaligned length as well.

Mikulas
