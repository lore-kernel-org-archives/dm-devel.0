From: John Dorminy <jdorminy@redhat.com>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Wed, 30 Jan 2019 09:08:50 -0500
Message-ID: <CAMeeMh85T_qui=LWd0u=b_oMN5XLqowqkvLuYGBM2Ae6tS-mzg@mail.gmail.com>
References: <20190125021107.4595-1-zhangxiaoxu5@huawei.com>
	<CAMeeMh_=UVGwo-=9WtBXRmiHTXnLAswqis97bM-aiuwnzPU0QQ@mail.gmail.com>
	<20190128221441.GA24102@redhat.com> <yq1lg34f4i7.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq1lg34f4i7.fsf@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 28, 2019 at 11:54 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> We rounded up LBS when we created the DM device. And therefore the
> bv_len coming down is 4K. But one of the component devices has a LBS of
> 512 and fails this check.
>
> At first glance one could argue we should just nuke the BUG_ON since the
> sd code no longer relies on bv_len. However, the semantics for WRITE
> SAME are particularly challenging in this scenario. Say the filesystem
> wants to WRITE SAME a 4K PAGE consisting of 512 bytes of zeroes,
> followed by 512 bytes of ones, followed by 512 bytes of twos, etc. If a
> component device only has a 512-byte LBS, we would end up writing zeroes
> to the entire 4K block on that component device instead of the correct
> pattern. Not good.
>
> So disallowing WRITE SAME unless all component devices have the same LBS
> is the correct fix.

Alternately, could possibly WRITE_SAME bios be accepted with the
minimum sector size of the stack rather than the max, e.g. 512 in this
example rather than 4k? They'd need to have a granularity of the
larger sector size, though, presumabily necessitating new queue limits
write_same_{granularity,block_size}, which might be too much work. For
devices with bigger sectors, the block layer or DM would need to
expand the small-sector payload to an appropriate larger-sector
payload, but it would preserve the ability to use WRITE_SAME with
non-zero payloads.

(I use WRITE_SAME to fill devices with a particular pattern in order
to catch failures to initialize disk structures appropriately,
personally, but it's just for convenience/speed.)
