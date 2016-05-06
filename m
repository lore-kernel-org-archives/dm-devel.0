From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 5/5] dm thin: unroll issue_discard() to
 create longer discard bio chains
Date: Fri, 6 May 2016 17:48:29 +0100
Message-ID: <20160506164828.GD19687@rh-vpn>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
	<1462463665-85312-6-git-send-email-snitzer@redhat.com>
	<20160506161216.GC7397@lst.de> <20160506163657.GA19687@rh-vpn>
	<20160506164435.GB8332@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160506164435.GB8332@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, May 06, 2016 at 06:44:35PM +0200, Christoph Hellwig wrote:
> On Fri, May 06, 2016 at 05:36:58PM +0100, Joe Thornber wrote:
> > But the plugging and error handling are called from two places.
> > process_prepared_discard_passdown() and
> > passdown_double_checking_shared_status().
> 
> passdown_double_checking_shared_status is only called from
> process_prepared_discard_passdown.  So the blk_start_plug from
> begin_discard and the work in end_discard could be moved into
> it trivially.

Good point, will do.  Thx.
