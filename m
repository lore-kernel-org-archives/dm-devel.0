From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [RFC PATCH 0/2] dm crypt: Allow unaligned buffer
 lengths for skcipher devices
Date: Thu, 24 Sep 2020 08:47:30 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2009240845330.11084@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Damien.LeMoal@wdc.com, ssudhakarp@gmail.com, Martin Petersen <martin.petersen@oracle.com>, dm-crypt@saout.de, Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, dm-devel@redhat.com, Shirley Ma <shirley.ma@oracle.com>, Milan Broz <gmazyland@gmail.com>, agk@redhat.com
List-Id: dm-devel.ids



On Wed, 23 Sep 2020, Mike Snitzer wrote:

> You've clearly done a nice job with these changes.  Looks clean.
> 
> BUT, I'm struggling to just accept that dm-crypt needs to go to these
> extra lengths purely because of one bad apple usecase.
> 
> These alignment constraints aren't new.  Are there other portions of
> Linux's crypto subsystem that needed comparable fixes in order to work
> with Microsfot OS initiated IO through a guest?
> 
> You forecast that these same kinds of changes are needed for AEAD and
> dm-integrity... that's alarming.

... and dm-writecache also expects that the bio is aligned ...

Mikulas

> Are we _certain_ there is no other way forward?
> (Sorry I don't have suggestions.. I'm in "fact finding mode" ;)
> 
> Thanks,
> Mike
