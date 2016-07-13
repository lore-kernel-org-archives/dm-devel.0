From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: poor thin performance, relative to thick
Date: Wed, 13 Jul 2016 10:17:07 -0400
Message-ID: <20160713141707.GA9378@redhat.com>
References: <20160711204454.GA24378@helmut>
	<CA+res+RiK-qARGYgasWoLMTDXZ8RpF9eXy1uYUHxNSqJ6Joxfg@mail.gmail.com>
	<20160713032926.GA30280@helmut>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160713032926.GA30280@helmut>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jack Wang <jack.wang.usish@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 12 2016 at 11:29pm -0400,
Jon Bernard <jbernard@tuxion.com> wrote:

> * Jack Wang <jack.wang.usish@gmail.com> wrote:
> > 2016-07-11 22:44 GMT+02:00 Jon Bernard <jbernard@tuxion.com>:
> > > Greetings,
> > >
> > > I have recently noticed a large difference in performance between thick
> > > and thin LVM volumes and I'm trying to understand why that it the case.
> > >
> > > In summary, for the same FIO test (attached), I'm seeing 560k iops on a
> > > thick volume vs. 200k iops for a thin volume and these results are
> > > pretty consistent across different runs.
> > >
> > > I noticed that if I run two FIO tests simultaneously on 2 separate thin
> > > pools, I net nearly double the performance of a single pool.  And two
> > > tests on thin volumes within the same pool will split the maximum iops
> > > of the single pool (essentially half).  And I see similar results from
> > > linux 3.10 and 4.6.
> > >
> > > I understand that thin must track metadata as part of its design and so
> > > some additional overhead is to be expected, but I'm wondering if we can
> > > narrow the gap a bit.
> > >
> > > In case it helps, I also enabled LOCK_STAT and gathered locking
> > > statistics for both thick and thin runs (attached).
> > >
> > > I'm curious to know whether this is a know issue, and if I can do
> > > anything the help improve the situation.  I wonder if the use of the
> > > primary spinlock in the pool structure could be improved - the lock
> > > statistics appear to indicate a significant amount of time contending
> > > with that one.  Or maybe it's something else entirely, and in that case
> > > please enlighten me.
> > >
> > > If there are any specific questions or tests I can run, I'm happy to do
> > > so.  Let me know how I can help.
> > >
> > > --
> > > Jon
> > 
> > Hi Jon,
> > 
> > Have you try to enable scsi_mq mode in newer kernel eg 4.6, see if it
> > makes any difference?
> 
> Thanks for the suggestion, I had not tried it previously.  I added
> 'scsi_mod.usb_blk_mq=Y' and 'dm_mod.use_blk_mq=Y' to my kernel command
> line and verified the mq subdirectory contents in /sys/block/<device>.
> All seemed to be correctly enabled.  I also realized that
> dm_mod.use_blk_mq is only for multipath, so I don't think it's relevant
> to my tests.

Yes dm_mod.use_blk_mq is specific to request-based DM.

But using scsi-mq will eliminate any q->queue_lock contention from the
underlying SCSI device that you have in your current lockstat.
 
> Results were very similar to previous tests, ~10x slowdown from thick to
> thin.  Mike raised several good points, I'm re-running the tests and
> will post new results in response.

OK, thanks.
