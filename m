From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] block: use a driver-specific handler for
 the "inflight" value
Date: Fri, 16 Nov 2018 01:11:02 -0800
Message-ID: <20181116091102.GA22961@infradead.org>
References: <20181116000508.980108938@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181116000508.980108938@debian.vm>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 16, 2018 at 01:04:19AM +0100, Mikulas Patocka wrote:
> Device mapper was converted to percpu inflight counters. In order to
> display the correct values in the "inflight" sysfs file and in
> /proc/diskstats, we need a custom callback that sums the percpu counters.
> 
> The function part_round_stats calculates the number of in-flight I/Os
> every jiffy and uses this to calculate the counters time_in_queue and
> io_ticks. In order to avoid excessive memory traffic on systems with high
> number of CPUs, this functionality is disabled when percpu inflight values
> are used and the values time_in_queue and io_ticks are calculated
> differently - the result is less precise.

And none of that is device mapper specific.  Please submit this code
to the block layer for use by all make_request based drivers.  Depending
on what Jens as the maintainers thinkgs of the tradeoffs we can discuss
if the summing should be on or off by default, or if we maybe even
need the current code as a fallback.
