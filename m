From: Jens Axboe <axboe@kernel.dk>
Subject: Re: xfstests generic/347 seems unhappy on todays block
	for-next tree
Date: Mon, 10 Dec 2018 15:00:33 -0700
Message-ID: <695940bb-3783-c8f6-6747-dfd548df7ca7@kernel.dk>
References: <20181210213724.GA27905@infradead.org>
	<f7854d23-cba0-d5ce-e136-6cacd052a6da@kernel.dk>
	<20181210215356.GA20174@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210215356.GA20174@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On 12/10/18 2:53 PM, Christoph Hellwig wrote:
> On Mon, Dec 10, 2018 at 02:39:39PM -0700, Jens Axboe wrote:
>> On 12/10/18 2:37 PM, Christoph Hellwig wrote:
>>> This test is described as:
>>>
>>> # Test very basic thin device usage, exhaustion, and growth
>>
>> Does that tree have:
>>
>> commit c616cbee97aed4bc6178f148a7240206dcdb85a6
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Thu Dec 6 22:17:44 2018 -0700
>>
>>     blk-mq: punt failed direct issue to dispatch list
>>
>> ?
> 
> yes.
> 
> The latest commit is 6f75723190d88e1319bea623bfe0292bf3917965

Reproduces here, guessing it's the inflight counters... Trying without.

-- 
Jens Axboe
