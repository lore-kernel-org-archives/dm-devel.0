From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-raid: add RAID discard support
Date: Tue, 23 Sep 2014 23:35:34 -0500
Message-ID: <659A2E16-8112-4677-80F1-77F4D5FB9A01@redhat.com>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140924142157.33475baa@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids


On Sep 23, 2014, at 11:21 PM, NeilBrown wrote:

> 
> For RAID5 it is not acceptable to return "zeros or the original content".
> This is because of the possibility of RMW cycles to update the parity block.
> As "discard" the doesn't treat all blocks in a stripe in an identical way
> will cause the parity block to become incorrect, and it will stay incorrect
> through multiple RMW cycles until an RCW corrects it.
> A device failure while the parity block is incorrect will lead to data
> corruption.
> 
> The only real solution I can think of is to maintain an 'allocated' bitmap
> and clear bits when DISCARDing.  When a write happens to a location that is
> not 'allocated' the whole  bit worth gets resynced (or maybe zeroed-out).
> 
> Grumble.

I see, sure.

Are there problems with this 'allocated' bitmap idea when bitrot is considered?  Scrubbing (check/repair) assumes that the bitmap cannot be trusted and does a complete scan of the array - dealing with mismatches.  If bitrot happens in the 'allocated' bitmap...

 brassow
