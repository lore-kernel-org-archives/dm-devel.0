From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: Fwd: Re: [PATCH] dm-mpath: push back requests
 instead of queueing
Date: Tue, 12 Nov 2013 08:23:42 +0000
Message-ID: <11AF7C027C4C02408624617A49860784F0A8A4@BPXM12GP.gisp.nec.co.jp>
References: <527CE4A1.90707@linux.vnet.ibm.com>
	<5280BEBC.4040500@linux.vnet.ibm.com> <5280C306.7080805@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5280C306.7080805@suse.de>
Content-Language: ja-JP
Content-ID: <3F2DDF44C1B92D4FB3349B0C4BA067AC@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 11/11/13 20:44, Hannes Reinecke wrote:
> On 11/11/2013 12:25 PM, Steffen Maier wrote:
>> One thing I'm still wondering: Would there be any benefit of actually stopping the request
>> queue until at least one path becomes available again?
> [blk_{start|stop}_queue()] I.e. stop
>> in map_io() after we're sure there is no path in any prio group,
> and restart in reinstate_path().
>>
> Hehe. Thought about that, too.
> 
> Problem with that approach is the way multipath currently works.
> Currently multipath does _not_ have a flag for 'all paths down and
> queue_if_no_path is active, please requeue'.
> It rather evaluates all possible paths during map_io, and only
> if it determines that no paths are present and queue_if_no_path
> is set it'll requeue the I/O.
> 
> So if we were to use start/stop queue here the block layer would
> never trigger 'map_io', and multipath would never check the path
> states and no I/O will be sent, ever.

I might misunderstand but if you stop the queue here:

        if ((pgpath && m->queue_io) ||
            (!pgpath && m->queue_if_no_path)) {
                /* Queue for the daemon to resubmit */

you can start the queue on completion of pg_init
for "pgpath && m->queue_io" case,
and can start on reinstate_path() message
for "!pgpath && m->queue_if_no_path" case.

> blk_start/stop_queue works best if you have _alternative_ means
> of setting those, besides the normal I/O path.
> (It's original idea was to be used from LLDDs, after all).
> When one of these functions is being used in the normal I/O path
> things are becoming iffy really fast.
> 
> That said, it _would_ make sense to use blk_start/stop_queue for
> pg_init; we cannot send I/O during pg_init anyway, so there's
> no point in retrying I/O here.

blk_stop/start_queue is used to implement dm suspend/resume.
So if you use them from target, care has to be taken not to
interfere with dm core.

-- 
Jun'ichi Nomura, NEC Corporation
