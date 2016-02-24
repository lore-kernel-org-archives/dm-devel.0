From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: drop unnecessary assignment of md->queue
Date: Wed, 24 Feb 2016 11:58:23 -0500
Message-ID: <20160224165823.GA15480@redhat.com>
References: <1456301738-16076-1-git-send-email-bob.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1456301738-16076-1-git-send-email-bob.liu@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bob Liu <bob.liu@oracle.com>
Cc: linux-kernel@vger.kernel.org, mpatocka@redhat.com, axboe@fb.com, j-nomura@ce.jp.nec.com, neilb@suse.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 24 2016 at  3:15am -0500,
Bob Liu <bob.liu@oracle.com> wrote:

> md->queue and q are the same thing in dm_init_request_based_queue() and
> dm_init_request_based_blk_mq_queue().
> 
> Also drop the temporary struct request_queue *q.

Yeah, I carried the extra assignment just as a form of documentation but
your patch is correct (they aren't needed).  I've rebased your patch
ontop of linux-dm.git's 'dm-4.6' and have staged it in linux-next.
