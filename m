From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Tue, 26 Jul 2016 12:06:11 -0400
Message-ID: <20160726160611.GA32174@redhat.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
	<20160720140815.GA19045@redhat.com>
	<20160720142727.GA57399@redhat.com>
	<1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
	<20160720183321.GA20223@redhat.com>
	<84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
	<20160725175344.GA23000@redhat.com>
	<08a1e048-8191-08bc-a39b-4c04a89ee2d4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <08a1e048-8191-08bc-a39b-4c04a89ee2d4@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jul 26 2016 at  2:02am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 07/25/2016 07:53 PM, Mike Snitzer wrote:
> >
> >The various ioctls you're seeing is just multipathd responding to the
> >failures.  Part of reloading a table (with revised path info, etc) is to
> >suspend and then resume the device that is being updated.
> >
> >But I'm not actually sure on the historic reasoning of why
> >queue_if_no_path is disabled (and active setting saved) on suspend.
> >
> >I'll think about this further but maybe others recall why?
> >
> Yes, originally multipath was using the device-mapper internal
> queueing mechanism, which meant that queued I/O was holding a
> reference to the table. So you couldn't change the table while I/O
> was pending/queued, and you'd have to unset queue_if_no_path to
> allow the tables to be swapped.
> (Or something. That's the reasoning I gave to myself when seeing
> that construct. And I found myself pretty convincing. Not that I've
> ever tested that.)
> So with commit e809917735ebf ("dm mpath: push back requests instead of
> queueing") that obviously isn't true anymore, and I'd love to see that
> quirk go.

Yeah, but unfortunately (or fortunately?) I've reinstated bio-based
multipath support -- for current 4.8 merge -- that actually _does_ make
use of (and reintroduces) the multipath target's internal queueing only
for bio-based use, see:

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.8&id=76e33fe4e2c4363c2b9f627472bd43dc235c3406
