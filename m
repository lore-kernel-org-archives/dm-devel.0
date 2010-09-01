From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA
 support for request-based dm
Date: Wed, 01 Sep 2010 13:20:08 +0200
Message-ID: <4C7E36E8.2000705@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
	<1283162296-13650-5-git-send-email-tj@kernel.org>
	<20100830132836.GB5283@redhat.com>
	<4C7BB932.1070405@kernel.org> <4C7BD202.4040700@kernel.org>
	<20100830194731.GA10702@redhat.com>
	<Pine.LNX.4.64.1009010625070.16035@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1009010625070.16035@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hello,

On 09/01/2010 12:31 PM, Mikulas Patocka wrote:
> My recommended approach to this (on non-request-based dm) is to simply let 
> the current barrier infrastructure be as it is --- you don't need to 
> change it now, you can simply map FUA write to barrier write and FLUSH to 
> zero-data barrier --- and it won't cause any data corruption. It will just 
> force unneeded I/O queue draining.
> 
> Once FLUSH+FUA interface is finalized and committed upstream, we can 
> remove that I/O queue draining from dm to improve performance.

Unfortunately, it doesn't work that way.  The current dm
implementation depends on block layer holding the queue while a
barrier sequence is in progress which the new implementation doesn't
do anymore (the whole point of this conversion BTW).

Thanks.

-- 
tejun
