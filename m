From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/7] dm-mpath: Do not lock up a CPU with requeuing
        activity
Date: Thu, 10 Aug 2017 11:29:11 +0200
Message-ID: <20170810092911.GG24539@lst.de>
References: <20170809183216.526-1-bart.vanassche@wdc.com> <20170809183216.526-4-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170809183216.526-4-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Aug 09, 2017 at 11:32:12AM -0700, Bart Van Assche wrote:
> When using the block layer in single queue mode, get_request()
> returns ERR_PTR(-EAGAIN) if the queue is dying and the REQ_NOWAIT
> flag has been passed to get_request(). Avoid that the kernel
> reports soft lockup complaints in this case due to continuous
> requeuing activity.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
