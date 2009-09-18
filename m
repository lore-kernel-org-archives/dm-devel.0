From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add a tracepoint for block request remapping
Date: Fri, 18 Sep 2009 12:45:39 +0200
Message-ID: <20090918104539.GX23126@kernel.dk>
References: <4AB2E57B.2090101@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AB2E57B.2090101@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 18 2009, Jun'ichi Nomura wrote:
> Since 2.6.31 now has request-based device-mapper, it's useful to have
> a tracepoint for request-remapping as well as bio-remapping.
> 
> This patch adds a tracepoint for request-remapping, trace_block_rq_remap().
> Existing trace_block_remap() is left unchanged but it might be better to
> rename it to trace_block_bio_remap().

This looks good, we should definitely have a remap trace at that level
too. Apart from that, nothing further to add than acking the observation
that you need to make the ->device_to part of the trace endian clean.

If you resend with that and just send the core bit (the dm part should
go through the dm branch), then I'll include it for 2.6.32.

-- 
Jens Axboe
