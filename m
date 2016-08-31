From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] dm-bufio: Remove deprecated create_singlethread_workqueue
Date: Wed, 31 Aug 2016 10:21:49 -0400
Message-ID: <20160831142149.GH12660@htj.duckdns.org>
References: <20160830164911.GA26756@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160830164911.GA26756@Karyakshetra>
Sender: linux-raid-owner@vger.kernel.org
To: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Aug 30, 2016 at 10:19:11PM +0530, Bhaktipriya Shridhar wrote:
> The workqueue "dm_bufio_wq" queues a single work item &dm_bufio_work and
> hence it doesn't require execution ordering. Hence, alloc_workqueue has
> been used to replace the deprecated create_singlethread_workqueue instance.
> 
> The WQ_MEM_RECLAIM flag has been set since md / dm are block multi disk
> drivers and require forward progress under memory pressure.
> 
> Since there are fixed number of work items, explicit concurrency
> limit is unnecessary here.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
