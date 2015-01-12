From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: blk-mq request allocation stalls
Date: Mon, 12 Jan 2015 14:11:39 -0500
Message-ID: <20150112191138.GC21518@redhat.com>
References: <54B3DE54.7090909@sandisk.com> <54B3EB4A.9090404@kernel.dk>
	<54B3F255.5080802@sandisk.com> <54B3F78D.2020704@kernel.dk>
	<54B3FE89.200@sandisk.com> <54B3FFAE.4070609@kernel.dk>
	<alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
	<54B40E8A.6010005@kernel.dk>
	<alpine.LNX.2.00.1501121818510.4026@localhost.lm.intel.com>
	<alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501121830010.4026@localhost.lm.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Mon, Jan 12 2015 at  1:35pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Mon, 12 Jan 2015, Keith Busch wrote:
> >Oh, let's look at "__blk_rq_prep_clone". dm calls that after
> >blk_get_request() for the blk-mq based multipath types and overrides the
> >destinations cmd_flags with the source's even though the source was not
> >allocated from a blk-mq based queue, much less a shared tag.
> 
> Untested patch. This will also preserve the failfast cmd_flag dm-mpath
> set after allocating.

Ah, good point.  The failfast flag would get cleared with the patch I
just proposed (unless REQ_FAILFAST_TRANSPORT was added to
REQ_PRESERVE_CLONE_MASK).

Anyway, I'm happy to see this implemented however you guys think is
best.  I think I like Keith's patch better than mine.
