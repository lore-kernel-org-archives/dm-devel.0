From: Jens Axboe <axboe@kernel.dk>
Subject: Re: drive-by blk-cgroup cleanups
Date: Mon, 29 Jun 2020 09:09:45 -0600
Message-ID: <90c404ed-58b0-274e-516f-b7c63ce34fcc@kernel.dk>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200627073159.2447325-1-hch@lst.de>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Dennis Zhou <dennis@kernel.org>
List-Id: dm-devel.ids

On 6/27/20 1:31 AM, Christoph Hellwig wrote:
> Hi all,
> 
> while looking into another "project" I ended up wading through the
> blkcq code for research and found a bunch of lose ends.  So here is
> a bunch of drive-by cleanups for the code.

Applied, thanks.

-- 
Jens Axboe
