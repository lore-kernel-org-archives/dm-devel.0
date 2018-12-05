From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 4/6] block: switch to per-cpu in-flight
	counters
Date: Wed, 5 Dec 2018 13:03:47 -0500
Message-ID: <20181205180347.GA9966@redhat.com>
References: <20181130222226.77216-1-snitzer@redhat.com>
	<20181130222226.77216-5-snitzer@redhat.com>
	<d6a741cd-ea75-19d0-13e3-eb1321e617b4@kernel.dk>
	<20181205174942.GA9838@redhat.com>
	<eb184c39-9d60-0fa3-0d27-7af2f78d601e@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <eb184c39-9d60-0fa3-0d27-7af2f78d601e@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 05 2018 at 12:54pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 12/5/18 10:49 AM, Mike Snitzer wrote:
> > On Wed, Dec 05 2018 at 12:30pm -0500,
> > Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >> There's also no need to pass in the cpu, if we're not running with
> >> preempt disabled already we have a problem. 
> > 
> > Why should this be any different than the part_stat_* interfaces?
> > __part_stat_add(), part_stat_read(), etc also use
> > per_cpu_ptr((part)->dkstats, (cpu) accessors.
> 
> Maybe audit which ones actually need it? To answer the specific question,
> it's silly to pass in the cpu, if we're pinned already. That's true
> both programatically, but also for someone reading the code.

I understand you'd like to avoid excess interface baggage.  But seems to
me we'd be better off being consistent, when extending the percpu
portion of block core stats, and then do an incremental to clean it all
up.

But I'm open to doing it however you'd like if you feel strongly about
how this should be done.

Mike
