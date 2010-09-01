From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH UPDATED 4/5] dm: implement REQ_FLUSH/FUA
 support for request-based dm
Date: Wed, 1 Sep 2010 11:20:54 -0400
Message-ID: <20100901152053.GA25644@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
	<1283162296-13650-5-git-send-email-tj@kernel.org>
	<20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org>
	<4C7BD202.4040700@kernel.org> <20100830194731.GA10702@redhat.com>
	<Pine.LNX.4.64.1009010625070.16035@hs20-bc2-1.build.redhat.com>
	<4C7E36E8.2000705@kernel.org>
	<Pine.LNX.4.64.1009010811001.23591@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1009010811001.23591@hs20-bc2-1.build.redhat.com>
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
Cc: Tejun Heo <tj@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 01 2010 at  8:12am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Wed, 1 Sep 2010, Tejun Heo wrote:
> 
> > Hello,
> > 
> > On 09/01/2010 12:31 PM, Mikulas Patocka wrote:
> > > My recommended approach to this (on non-request-based dm) is to simply let 
> > > the current barrier infrastructure be as it is --- you don't need to 
> > > change it now, you can simply map FUA write to barrier write and FLUSH to 
> > > zero-data barrier --- and it won't cause any data corruption. It will just 
> > > force unneeded I/O queue draining.
> > > 
> > > Once FLUSH+FUA interface is finalized and committed upstream, we can 
> > > remove that I/O queue draining from dm to improve performance.
> > 
> > Unfortunately, it doesn't work that way.  The current dm
> > implementation depends on block layer holding the queue while a
> > barrier sequence is in progress which the new implementation doesn't
> > do anymore (the whole point of this conversion BTW).
> 
> That may be true for request-based dm (I don't know).
> 
> But bio-based dm doesn't depend on it, I wrote it and I didn't rely on 
> that.

Mikulas,

Current bio-based barrier support also defers IO if a flush is in
progress.  See _dm_request:

	/*
	 * If we're suspended or the thread is processing barriers
	 * we have to queue this io for later.
	 */

Tejun also shared the following:

"bio based implementation also uses dm_wait_for_completion() and
DMF_QUEUE_IO_TO_THREAD to plug all the follow up bio's while flush is in
progress, which sucks for throughput but successfully avoids starvation."

here:
https://www.redhat.com/archives/dm-devel/2010-August/msg00174.html
