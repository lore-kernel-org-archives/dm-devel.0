From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] dm: reduce memory overhead of DM devices
Date: Sat, 4 Oct 2014 10:01:30 -0700
Message-ID: <20141004170130.GA30207@infradead.org>
References: <542E8CF9.6000609@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <542E8CF9.6000609@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 03, 2014 at 11:48:08AM +0000, Junichi Nomura wrote:
> This series of patches reduce the memory overhead of device-mapper
> device mainly by removing unused mempool for bio vecs.
> 
> DM creates per-device bioset to ensure forward progress under
> low memory situation and bioset always includes mempool for bvec.

Thanks, this looks like a good step forward.

I'd still love to go all the way and avoid any bio cloning.  I can
see two ways to do this:

 1) similar to the original block layer multipathing with a callback
    that allows the submitter to hook into the completion path at
    blk_update_request time.
 2) by not completing the io chain in req_bio_endio, similar to how
    we do it for requests that are part of a flush sequence using
    the REQ_FLUSH_SEQ.

While the first seems like the cleaner architecture it might be worth
to look into the second version given that 1) wasn't well received
last time, and 2) already works nicely for a very similar use
case.  If we end up implementing 1) it should also be able to replace
the current flag based completion hack for the flush sequence.
