From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 5/5] block: use a driver-specific handler for
 the "inflight" value
Date: Wed, 14 Nov 2018 10:34:37 -0500
Message-ID: <20181114153437.GA17974@redhat.com>
References: <20181106213858.391264280@debian-a64.vm>
	<20181108145240.GA20087@infradead.org>
	<20181108170701.GA29107@redhat.com>
	<20181114151848.GA22138@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181114151848.GA22138@infradead.org>
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

On Wed, Nov 14 2018 at 10:18am -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Nov 08, 2018 at 12:07:01PM -0500, Mike Snitzer wrote:
> > Discussed doing that with Jens and reported as much here:
> > 
> > https://www.redhat.com/archives/dm-devel/2018-November/msg00068.html
> > 
> > And Jens gave additional context for why yet another attempt to switch
> > block core's in_flight to percpu counters is doomed (having already been
> > proposed and rejected twice):
> > 
> > https://www.redhat.com/archives/dm-devel/2018-November/msg00071.html
> > 
> > And yes, definitely should've cc'd linux-block (now added).
> 
> So how is dm different from the the other 3 handful of drivers using
> the make_request interface that the per-cpu counters work for dm and
> not the others?

Think the big part of the historic reluctance to switch to percpu
in_flight counters was that until now (4.21) the legacy request path was
also using the in_flight counters.

Now that they are only used by bio-based (make_request) we likely have
more latitude (hopefully?).  Though I cannot say for sure why they
performed so well in Mikulas' testing.. you'd thinking all the percpu
summing on every jiffie during IO completion would've still been
costly.. but Mikulas saw great results.

Mikulas and I have discussed a new way forward and he is actively
working through implementing it.  Basically he'll still switch to percpu
in_flight counters but he'll change the algorithm for IO accounting
during completion so that it is more of an approximation of the
historically precise in_flight counters and io_ticks (io_ticks is
another problematic component that gets in the way of performance).
Basically the accounting done during IO completion would be much much
faster.  Big part of this is the summation of the percpu in_flight
counters would happen on demand (via sysfs or /proc/diskstats access).
I could look back at my logs from my chat with Mikulas to give you more
details or we could just wait for Mikulas to post the patches (hopefully
within a week).  Your call.

Coming off my Monday discussion with Mikulas I really think the approach
will work nicely and offer a nice performance win for bio-based.

Mike
