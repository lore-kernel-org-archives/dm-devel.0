From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 5/5] block: use a driver-specific handler for
 the "inflight" value
Date: Thu, 8 Nov 2018 12:07:01 -0500
Message-ID: <20181108170701.GA29107@redhat.com>
References: <20181106213858.391264280@debian-a64.vm>
	<20181108145240.GA20087@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181108145240.GA20087@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 08 2018 at  9:52am -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Nov 06, 2018 at 10:35:03PM +0100, Mikulas Patocka wrote:
> > Device mapper was converted to percpu inflight counters. In order to
> > display the correct values in the "inflight" sysfs file, we need a custom
> > callback that sums the percpu counters.
> 
> The attribute that calls this is per-partition, while your method
> is per-queue, so there is some impedence mismatch here.
> 
> Is there any way you could look into just making the generic code
> use percpu counters?

Discussed doing that with Jens and reported as much here:

https://www.redhat.com/archives/dm-devel/2018-November/msg00068.html

And Jens gave additional context for why yet another attempt to switch
block core's in_flight to percpu counters is doomed (having already been
proposed and rejected twice):

https://www.redhat.com/archives/dm-devel/2018-November/msg00071.html

And yes, definitely should've cc'd linux-block (now added).

Mike
