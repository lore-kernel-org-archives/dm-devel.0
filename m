From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] block: make bio_inc_remaining()
	interface	accessible again
Date: Fri, 6 May 2016 18:27:05 +0200
Message-ID: <20160506162705.GA7999@lst.de>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
	<1462463665-85312-3-git-send-email-snitzer@redhat.com>
	<20160506152535.GA6738@lst.de> <20160506155633.GA7318@lst.de>
	<20160506161915.GA905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160506161915.GA905@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Fri, May 06, 2016 at 12:19:16PM -0400, Mike Snitzer wrote:
> (this is a direct result of completing the discard bio before all
> mappings, and associated sub-discards, have):

The completion order really should not matter, we rely on it not
mattering for almost every usage of the bio_chain API.  So there
is something else fishy going on here.  What's your test case?
I'd like to dig a bit deeper into this.
