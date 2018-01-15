From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [GIT PULL] block changes to improve device mapper for 4.16
Date: Tue, 16 Jan 2018 01:00:33 +0800
Message-ID: <20180115170027.GA4924@ming.t460p>
References: <20180115025913.GA20727@redhat.com>
 <36b17d56-bd2b-220a-08c1-8bd44d33f854@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <36b17d56-bd2b-220a-08c1-8bd44d33f854@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jan 15, 2018 at 08:33:41AM -0700, Jens Axboe wrote:
> On 1/14/18 7:59 PM, Mike Snitzer wrote:
> > Hi Jens,
> > 
> > I prepared this pull request in the hope that it may help you review and
> > stage these changes for 4.16.
> > 
> > I went over Ming's changes again to refine the headers and code comments
> > for clarity to help ease review and inclussion.
> > 
> > I've done extensive testing of the changes in this pull request in
> > combination with all the dm-4.16 changes I'll be sending to Linus, using
> > this tree (which gets pulled into linux-next, I wanted some coverage):
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next
> > I'll obviously drop these changes from dm's linux-next once you pick
> > them up.
> > 
> > FYI, this dm-4.16 commit addresses the concerns Bart raised last week
> > against Ming's dm-mpath changes:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=7a9d12664a183c4a1e2fa86b0a9206006b95138e
> > 
> > The following changes since commit bf9ae8c5325c0070d0ec81a849bba8d156f65993:
> > 
> >   blk-mq: fix bad clear of RQF_MQ_INFLIGHT in blk_mq_ct_ctx_init() (2018-01-14 10:46:24 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-block-4.16/dm
> > 
> > for you to fetch changes up to 0e94dfab56071a7afd0a9de9b8f6a0535148fb36:
> > 
> >   blk-mq: issue request directly for blk_insert_cloned_request (2018-01-14 13:00:02 -0500)
> > 
> > Please pull, thanks!
> > Mike
> > 
> > ----------------------------------------------------------------
> > - Small correctness fix in del_gendisk() if GENHD_FL_HIDDEN is used.
> > 
> > - Cleanup blk_unregister_queue() to more precisely protect against
> >   concurrent sysfs changes, blk_mq_unregister_dev() now requires caller
> >   to hold q->sysfslock (blk_unregister_queue is only caller).
> > 
> > - Introduce add_disk() variant, add_disk_no_queue_reg(), that allows the
> >   gendisk to be registered but the associated disk->queue's
> >   blk_register_queue() is left for the driver to do once its
> >   request_queue is fully initialized.  Fixes long-standing DM
> >   request_queue initialization issues.
> > 
> > - Ming's blk-mq improvements to blk_insert_cloned_request(), which is
> >   used exclusively by request-based DM's blk-mq mode, that enable
> >   substantial dm-mpath sequential IO performance improvements.
> > 
> > ----------------------------------------------------------------
> > Mike Snitzer (4):
> >       block: only bdi_unregister() in del_gendisk() if !GENHD_FL_HIDDEN
> >       block: properly protect the 'queue' kobj in blk_unregister_queue
> >       block: allow gendisk's request_queue registration to be deferred
> >       dm: fix incomplete request_queue initialization
> > 
> > Ming Lei (3):
> >       blk-mq: move actual issue into __blk_mq_issue_req helper
> 
> I don't like this patch at all - it's a 10 line function (if that)
> that ends up with three outputs, two of them hidden in passed
> in pointers. On top of that, a function that is named
> __blk_mq_issue_req() and returns bool, you would logically expect
> a 'true' return to mean that it succeeded. This is the opposite.

OK, __blk_mq_issue_req() has been cleaned up in V4, please consider
it for V4.16.

Thanks,
Ming
