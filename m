From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/7] per-cpu in_flight counters for
	bio-based drivers
Date: Wed, 5 Dec 2018 19:43:54 -0700
Message-ID: <5d4f6fc4-5d17-294d-5d07-38a4b8a0c19c@kernel.dk>
References: <20181205202433.95823-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181205202433.95823-1-snitzer@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On 12/5/18 1:24 PM, Mike Snitzer wrote:
> Hi,
> 
> This v3 adds "block: stop passing 'cpu' to all percpu stats methods"
> before switching over to percpu counters.

I gave this a shot, with the hope of being able to use it for blk-mq
as well. The tldr is that it's still slower than the tag iteration,
but that isn't a show stopper for a generic implementation. But
unfortunately it fails for queue size results, iostat just shows
0 for the average queue size.

-- 
Jens Axboe
