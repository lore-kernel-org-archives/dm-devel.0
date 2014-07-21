From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Subject: Re: [PATCH] dm-writeboost: Remove unsure BUG() from
	init_rambuf_pool
Date: Mon, 21 Jul 2014 22:52:47 +0900
Message-ID: <CAMym5wuVey8shaFt0C+XWpdZ-KeukY3kQ5SHeCdNTpg9AGL87w@mail.gmail.com>
References: <87egxr0wul.wl%satoru.takeuchi@gmail.com>
	<20140718100130.5bc9f9cc4e9ce674ab014423@gmail.com>
	<CAMym5wu+DUrxqOaenW1h4WgcJOGzMK1H1amMbYS7783qugQFNg@mail.gmail.com>
	<87bnsl37az.wl%satoru.takeuchi@gmail.com>
	<20140719181339.GB6822@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140719181339.GB6822@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>, ejt@redhat.com, Akira Hayakawa <ruby.wktk@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdaia,

2014-07-20 3:13 GMT+09:00 Alasdair G Kergon <agk@redhat.com>:
> On Sat, Jul 19, 2014 at 08:40:52PM +0900, Satoru Takeuchi wrote:
>> In addition, I'd like to know your opinion about whether setting
>> the upper limit of nr_rambuf_pool argument is neccesary or not.
>
> 1) If it's a parameter passed from userspace under the control of the
> sysadmin, then you should just trust the sysadmin to set a sensible
> value, and only return an error if the value they ask for is unobtainable.

Thank you for your comment.

I don't say anything if this function returns an ENOMEM without any effect to
whole system. In this case, it fails *after* evicting massive amount of memory.
Since linux is used by very large amount of system, I consider someone will
eventually make a mistake. So I consider setting upper limit is better way
from the perspective of fool proof.

>
> Example: dm-ioctl.c copy_params()
>
> 2) If certain large values would be useless, leaving no memory for
> anything else, then you could apply a sensible limit based on the amount
> of memory available.

I agree with you.

It's difficult to guess the appropriate upper limit from the perspective of
dm-writeboost at this point since it's depend on system and requires
a number of performance measurements. So, the second best way is limiting
the rambuf size based on the available memory as you say. It can avoid
the above-mentioned problem anyway and very easy to implement.

Thanks,
Satoru

>
> Example: dm_bufio.c
>
>  * Memory management policy:
>  *      Limit the number of buffers to DM_BUFIO_MEMORY_PERCENT of main memory
>  *      or DM_BUFIO_VMALLOC_PERCENT of vmalloc memory (whichever is lower).
>  *      Always allocate at least DM_BUFIO_MIN_BUFFERS buffers.
>
> Alasdair
>
