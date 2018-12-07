From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm crypt: fix lost ioprio when queuing
 crypto bios from task with ioprio
Date: Fri, 7 Dec 2018 11:43:20 -0800
Message-ID: <20181207194319.GA1690@infradead.org>
References: <20181206221507.5423-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181206221507.5423-1-snitzer@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, Eric Wheeler <dm-devel@lists.ewheeler.net>
List-Id: dm-devel.ids

On Thu, Dec 06, 2018 at 05:15:07PM -0500, Mike Snitzer wrote:
> From: Eric Wheeler <dm-devel@lists.ewheeler.net>
> 
> Since dm-crypt queues writes (and sometimes reads) to a different kernel
> thread (workqueue), the bios will dispatch from tasks with different
> io_context->ioprio settings than the submitting task, thus giving
> incorrect ioprio hints to the io scheduler.
> 
> By assigning the ioprio to the bio before queuing to a workqueue, the
> original submitting task's io_context->ioprio setting can be retained
> through the life of the bio.  We only set the bio's ioprio in dm-crypt
> if not already set (by somewhere else, higher in the stack).

The scheme looks a little odd to me.  Instead of requring a driver
call why don't we just make sure bios always have the submitting
tasks priority set and then make sure the lower layers can rely on it?
