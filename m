From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Sun, 29 Jan 2012 11:24:47 -0800
Message-ID: <20120129192447.GB17211@htj.dyndns.org>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Jan 29, 2012 at 06:41:33PM +0900, Namhyung Kim wrote:
> The block_bio_complete() TP has been missed so long, so that bio-based
> drivers haven't been able to trace its IO behavior. Add it.
> 
> In some rare cases, such as loop_switch, @bio->bi_bdev can be NULL.
> Thus convert it to TRACE_EVENT_CONDITION() as Steven suggested.
> 
> From now on, request-based drivers will also get BLK_TA_COMPLETEs for
> all bio's in requests. This needs to be handled in userland properly.
> 
> Also remove external use of the TP in DM and unexport it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: dm-devel@redhat.com

I like the smiplicity change but do we know how we can filter this out
from userland?  Also, what's the reason not to do it from blktrace.c?
What would be the downside of doing that?

Thanks.

-- 
tejun
