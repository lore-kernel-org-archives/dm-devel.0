From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 5/5] block: use a driver-specific handler for
 the "inflight" value
Date: Wed, 14 Nov 2018 07:18:48 -0800
Message-ID: <20181114151848.GA22138@infradead.org>
References: <20181106213858.391264280@debian-a64.vm>
	<20181108145240.GA20087@infradead.org>
	<20181108170701.GA29107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181108170701.GA29107@redhat.com>
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 08, 2018 at 12:07:01PM -0500, Mike Snitzer wrote:
> Discussed doing that with Jens and reported as much here:
> 
> https://www.redhat.com/archives/dm-devel/2018-November/msg00068.html
> 
> And Jens gave additional context for why yet another attempt to switch
> block core's in_flight to percpu counters is doomed (having already been
> proposed and rejected twice):
> 
> https://www.redhat.com/archives/dm-devel/2018-November/msg00071.html
> 
> And yes, definitely should've cc'd linux-block (now added).

So how is dm different from the the other 3 handful of drivers using
the make_request interface that the per-cpu counters work for dm and
not the others?
