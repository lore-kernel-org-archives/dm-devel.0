From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Wed, 30 Jan 2019 21:23:09 -0500
Message-ID: <yq1ftt9bm5u.fsf@oracle.com>
References: <20190125021107.4595-1-zhangxiaoxu5@huawei.com>
	<CAMeeMh_=UVGwo-=9WtBXRmiHTXnLAswqis97bM-aiuwnzPU0QQ@mail.gmail.com>
	<20190128221441.GA24102@redhat.com> <yq1lg34f4i7.fsf@oracle.com>
	<CAMeeMh85T_qui=LWd0u=b_oMN5XLqowqkvLuYGBM2Ae6tS-mzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMeeMh85T_qui=LWd0u=b_oMN5XLqowqkvLuYGBM2Ae6tS-mzg@mail.gmail.com>
	(John Dorminy's message of "Wed, 30 Jan 2019 09:08:50 -0500")
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
Cc: axboe@kernel.dk, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


John,

>> So disallowing WRITE SAME unless all component devices have the same LBS
>> is the correct fix.
>
> Alternately, could possibly WRITE_SAME bios be accepted with the
> minimum sector size of the stack rather than the max, e.g. 512 in this
> example rather than 4k? They'd need to have a granularity of the
> larger sector size, though, presumabily necessitating new queue limits
> write_same_{granularity,block_size}, which might be too much work.

I don't have a problem restricting the buffer contents to be consistent
within a page. Or even change the upper layer semantics to specify the
buffer contents using a single byte (0x00..0xff).

But the issue of head and tail remains if there is a block size mismatch
so it's important that we keep scaling the logical block size up when
stacking and reject any bio that can't be honored on a 4Kn device.

> (I use WRITE_SAME to fill devices with a particular pattern in order
> to catch failures to initialize disk structures appropriately,
> personally, but it's just for convenience/speed.)

The intent was for stuff like MD to use it to initialize parity disks,
etc. But adoption has been pretty slow.

I don't have any problems keeping WRITE_SAME around if people are
actually using it. It just seemed like most active users only cared
about writing zeroes.

-- 
Martin K. Petersen	Oracle Linux Engineering
