From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Mon, 28 Jan 2019 23:54:08 -0500
Message-ID: <yq1lg34f4i7.fsf@oracle.com>
References: <20190125021107.4595-1-zhangxiaoxu5@huawei.com>
	<CAMeeMh_=UVGwo-=9WtBXRmiHTXnLAswqis97bM-aiuwnzPU0QQ@mail.gmail.com>
	<20190128221441.GA24102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190128221441.GA24102@redhat.com> (Mike Snitzer's message of
	"Mon, 28 Jan 2019 17:14:42 -0500")
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
Cc: axboe@kernel.dk, John Dorminy <jdorminy@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


Mike,

>> In the first place, if it's an LVM-only issue, we should fix it only
>> for device-mapper devices. If this is the right way to fix it,
>> possibly the way to do that would be to change DM calls to
>> blk_queue_max_write_same_sectors() to only set the max sectors to
>> more than 0 if and only if the logical block sizes match.
>
> There is no way this is specific to lvm (or DM).  It may _seem_ that way
> because lvm/dm are in the business of creating stacked devices --
> whereby exposing users to blk_stack_limits().
>
> I'll have a closer look at this issue, hopefully tomorrow, but Zhang
> Xiaoxu's proposed fix looks bogus to me.  Not disputing there is an
> issue, just feels like a different fix is needed.

It's caused by a remnant of the old bio payload hack in sd.c:

	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);

We rounded up LBS when we created the DM device. And therefore the
bv_len coming down is 4K. But one of the component devices has a LBS of
512 and fails this check.

At first glance one could argue we should just nuke the BUG_ON since the
sd code no longer relies on bv_len. However, the semantics for WRITE
SAME are particularly challenging in this scenario. Say the filesystem
wants to WRITE SAME a 4K PAGE consisting of 512 bytes of zeroes,
followed by 512 bytes of ones, followed by 512 bytes of twos, etc. If a
component device only has a 512-byte LBS, we would end up writing zeroes
to the entire 4K block on that component device instead of the correct
pattern. Not good.

So disallowing WRITE SAME unless all component devices have the same LBS
is the correct fix.

That said, now that we have REQ_OP_WRITE_ZEROES (where the LBS is
irrelevant due to the payload being the ZERO_PAGE), it may be worthwhile
to remove REQ_OP_WRITE_SAME. I think drbd is the only user relying on a
non-zero payload. The target code ends up manually iterating, if I
remember correctly...

-- 
Martin K. Petersen	Oracle Linux Engineering
