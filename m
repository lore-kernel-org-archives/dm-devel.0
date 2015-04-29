From: Christoph Hellwig <hch@lst.de>
Subject: Re: Kernel v4.1-rc1 + MQ dm-multipath + MQ SRP oops
Date: Wed, 29 Apr 2015 15:37:21 +0200
Message-ID: <20150429133721.GA4521@lst.de>
References: <553F7474.70905@sandisk.com> <20150429132029.GA3876@lst.de>
	<20150429133433.GA23127@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150429133433.GA23127@redhat.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Wed, Apr 29, 2015 at 09:34:33AM -0400, Mike Snitzer wrote:
> I'm seeing this same crash on the completion path (when using your
> tcm_loop script).  But for Bart's case his stacktrace included
> dm_requeue_unmapped_original_request() -- which if called from
> map_request() implies clone->q won't have been initialized given
> __multipath_map()'s code for setting up the old request_fn case.
> 
> Long story short: your fix is right for Bart's crash (but not the ones
> I'm seeing with tcm_loop) -- I'll get it queued up with a proper header
> attributed to you and cc'ing stable as needed.

I don't really have a good explanation for your crash then, but no
block driver will zero out ->q on outstanding requests, so I'd look for
the cause for your issue in device mapper.  That allocation of request
from a mempool for dm-mpath is something very special that I don't
think anyone else does.
