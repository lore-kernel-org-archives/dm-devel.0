From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Add a tracepoint for block request remapping
Date: Mon, 21 Sep 2009 21:11:28 +0200
Message-ID: <20090921191128.GF23126@kernel.dk>
References: <4AB7A8EE.9070607@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AB7A8EE.9070607@ce.jp.nec.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 22 2009, Jun'ichi Nomura wrote:
> # Re-sending just the core bit.
> 
> Since 2.6.31 now has request-based device-mapper, it's useful to have
> a tracepoint for request-remapping as well as bio-remapping.
> This patch adds a tracepoint for request-remapping, trace_block_rq_remap().

Applied to the upstream for-linus branch (for 2.6.32).

-- 
Jens Axboe
