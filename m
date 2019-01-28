From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Mon, 28 Jan 2019 17:14:42 -0500
Message-ID: <20190128221441.GA24102@redhat.com>
References: <20190125021107.4595-1-zhangxiaoxu5@huawei.com>
	<CAMeeMh_=UVGwo-=9WtBXRmiHTXnLAswqis97bM-aiuwnzPU0QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAMeeMh_=UVGwo-=9WtBXRmiHTXnLAswqis97bM-aiuwnzPU0QQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Dorminy <jdorminy@redhat.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sat, Jan 26 2019 at  6:17am -0500,
John Dorminy <jdorminy@redhat.com> wrote:

> Hi. I have read a bit of DM code and spent an hour reviewing this... I
> didn't get to the point of knowing what the right fix for the problem
> is, and I may have a wrong understanding, but I have two thoughts
> about the patch:
> 
> I don't think this is the right solution for two reasons:
> 
> In the first place, if it's an LVM-only issue, we should fix it only
> for device-mapper devices. If this is the right way to fix it,
> possibly the way to do that would be to change DM calls to
> blk_queue_max_write_same_sectors() to only set the max sectors to more
> than 0 if and only if the logical block sizes match.

There is no way this is specific to lvm (or DM).  It may _seem_ that way
because lvm/dm are in the business of creating stacked devices --
whereby exposing users to blk_stack_limits().

I'll have a closer look at this issue, hopefully tomorrow, but Zhang
Xiaoxu's proposed fix looks bogus to me.  Not disputing there is an
issue, just feels like a different fix is needed.

Mike
