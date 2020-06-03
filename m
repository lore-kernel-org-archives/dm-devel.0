From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 1/3] block: add flag 'nowait_requests' into queue
 limits
Date: Tue, 2 Jun 2020 21:58:22 -0700
Message-ID: <20200603045822.GA17137@infradead.org>
References: <159101473169.180989.12175693728191972447.stgit@buzz>
 <159101502963.180989.6228080995222059011.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <159101502963.180989.6228080995222059011.stgit@buzz>
Sender: linux-block-owner@vger.kernel.org
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Mon, Jun 01, 2020 at 03:37:09PM +0300, Konstantin Khlebnikov wrote:
> Add flag for marking bio-based queues which support REQ_NOWAIT.
> Set for all request based (mq) devices.
> 
> Stacking device should set it after blk_set_stacking_limits() if method
> make_request() itself doesn't delay requests or handles REQ_NOWAIT.

I don't think this belongs into the queue limits.  For example a
stacking driver that always defers requests to a workqueue can support
REQ_NOWAIT entirely independent of the underlying devices.  I think
this just needs to be a simple queue flag.
