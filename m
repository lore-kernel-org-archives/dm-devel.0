From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/1] dm: do not allocate any mempools for
	blk-mq	request-based DM
Date: Tue, 28 Apr 2015 08:28:43 +0200
Message-ID: <20150428062843.GA19065@lst.de>
References: <1429957432-20672-1-git-send-email-hch@lst.de>
	<20150428005950.GA31039@redhat.com>
	<20150428010303.GB31039@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150428010303.GB31039@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Mon, Apr 27, 2015 at 09:03:04PM -0400, Mike Snitzer wrote:
> Do not allocate the io_pool mempool for blk-mq request-based DM
> (DM_TYPE_MQ_REQUEST_BASED) in dm_alloc_rq_mempools().
> 
> Also refine __bind_mempools() to have more precise awareness of which
> mempools each type of DM device uses -- avoids mempool churn when
> reloading DM tables (particularly for DM_TYPE_REQUEST_BASED).

Btw, I looked into this code and didn't dare to touch it before I
understood how we deal with the case of dm-mpath using blk-mq and
low level driver not or the other way around.

As far as I can see we'd need the request mempool as long as the
low level driver does not use dm-mq, independent of what dm-mpath
itsel uses.

The code doesn't seem to handle this right, but as mentioned I'm not
100% sure and need to dive deeper into this.  Is there a place enforcing
dm-mpath is using the same request type as the underlying devices?
