From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm-thinp: fix REQ_FLUSH semantics
Date: Wed, 27 Apr 2011 08:20:46 -0400
Message-ID: <20110427122046.GB20633@infradead.org>
References: <20110427100246.GA22521@infradead.org>
	<1303898956.4679.58.camel@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1303898956.4679.58.camel@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, ejt@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 27, 2011 at 11:09:16AM +0100, Joe Thornber wrote:
> On Wed, 2011-04-27 at 06:02 -0400, Christoph Hellwig wrote:
> > REQ_FLUSH means the metadata needs to be flushed before the data payload
> > (if there is one), not after it.  And yes, this means the typical
> > REQ_FUA|REQ_FLUSH requests imply two flushes.
> 
> Not sure what you're getting at here.  The bio wasn't issued until after
> the commit.
> 
> 			if ((bio->bi_rw & (REQ_FUA | REQ_FLUSH))) {
> 				r = commit(tc);
> 				if (r < 0) {
> 					bio_io_error(bio);
> 					continue;
> 				}
> 			}
> 
> 			remap_bio(tc, bio, pool_block);
> 			generic_make_request(bio);

Indeed.  Given that the metadata is on-disk and doesn't change by
doing I/O to the newly mapped block always doing it before the
I/O to the underlying device is fine.  I thus retract this patch.
