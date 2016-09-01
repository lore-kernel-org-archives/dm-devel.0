From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 8/9] dm: Fix two race conditions related to
 stopping and starting queues
Date: Thu, 1 Sep 2016 18:18:23 -0400
Message-ID: <20160901221823.GA13209@redhat.com>
References: <20160901155051.GA11353@redhat.com>
	<20160901161253.GA11410@redhat.com>
	<e8cf7d03-82a6-cba3-60c4-c436ae3a24f7@sandisk.com>
	<20160901190505.GA12106@redhat.com>
	<235c0ca3-0c01-6dc8-208e-1a4c153dd69c@sandisk.com>
	<20160901203332.GB12407@redhat.com>
	<889bdb89-a16b-927a-adf0-fa04418a0c06@sandisk.com>
	<20160901204806.GA12742@redhat.com>
	<66e36ae7-19ff-058f-049a-3e91a62b19b3@sandisk.com>
	<20160901211718.GA12894@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160901211718.GA12894@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Sep 01 2016 at  5:17pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Sep 01 2016 at  4:52pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> > On 09/01/2016 01:48 PM, Mike Snitzer wrote:
> > >Yeah, I since fixed that.  Doesn't change the fact that your use of
> > >blk_mq_freeze_queue() causes the 100% cpu usage.
> > 
> > Hello Mike,
> > 
> > Sorry but that doesn't make sense to me. blk_mq_freeze_queue()
> > either returns quickly or waits. It cannot cause 100% CPU usage.
> > Something else must be going on. If you can make the code available
> > that you used in your test I will have a look at it.
> 
> The suspend is hanging due the blk_mq_freeze_queue() -- and in turn the
> resume (after reinstating paths) never happens.  So no paths are
> available.  IO just keeps getting requeued, hence the 100% usage.
> 
> The root of the problem is that the suspend isn't completing though.
> 
> I've moved your work out to my private devel branch, see:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel

FYI I get the same 'dmsetup suspend --nolockfs --noflush mp' hang,
running mptest's test_02_sdev_delete, when I try your unmodified
patchset, see:

http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel.bart
