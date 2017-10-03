From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V5 4/8] block: move actual bio merge code into __elv_merge
Date: Tue, 3 Oct 2017 02:16:34 -0700
Message-ID: <20171003091634.GB2771@infradead.org>
References: <20170930112655.31451-1-ming.lei@redhat.com>
 <20170930112655.31451-5-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170930112655.31451-5-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, Omar Sandoval <osandov@fb.com>
List-Id: dm-devel.ids

On Sat, Sep 30, 2017 at 07:26:51PM +0800, Ming Lei wrote:
> So that we can reuse __elv_merge() to merge bio
> into requests from sw queue in the following patches.
> 
> No functional change.

There are very few callers of elv_merge, just update the function
with the new parameters instead of introducing __elv_merge.
