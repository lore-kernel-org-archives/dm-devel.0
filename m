From: Jens Axboe <axboe@kernel.dk>
Subject: Re: xfstests generic/347 seems unhappy on todays block
	for-next tree
Date: Mon, 10 Dec 2018 14:39:39 -0700
Message-ID: <f7854d23-cba0-d5ce-e136-6cacd052a6da@kernel.dk>
References: <20181210213724.GA27905@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210213724.GA27905@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, snitzer@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/10/18 2:37 PM, Christoph Hellwig wrote:
> This test is described as:
> 
> # Test very basic thin device usage, exhaustion, and growth

Does that tree have:

commit c616cbee97aed4bc6178f148a7240206dcdb85a6
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Dec 6 22:17:44 2018 -0700

    blk-mq: punt failed direct issue to dispatch list

?

-- 
Jens Axboe
