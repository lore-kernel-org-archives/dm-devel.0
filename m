From: Jens Axboe <axboe@kernel.dk>
Subject: Re: limits->max_sectors is getting set to 0,
 why/where? [was: Re: dm: kernel oops by divide error on v4.16+]
Date: Mon, 9 Apr 2018 15:56:44 -0600
Message-ID: <78732cb7-3666-e1b0-e6d3-2a3409a0d4ca@kernel.dk>
References: <20180408040005.GA19128@ming.t460p>
	<20180409155120.GA10990@redhat.com> <20180409183836.GA11256@redhat.com>
	<db4499d6-05b8-73f3-76d0-a91af91430b0@kernel.dk>
	<70f1d349-f091-19a2-9ec6-978ac1e7dda0@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------C90BFEFBC64939D9EED8A038"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <70f1d349-f091-19a2-9ec6-978ac1e7dda0@kernel.dk>
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
To: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Chris Mason <clm@fb.com>, dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------C90BFEFBC64939D9EED8A038
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 4/9/18 3:26 PM, Jens Axboe wrote:
> On 4/9/18 1:32 PM, Jens Axboe wrote:
>> On 4/9/18 12:38 PM, Mike Snitzer wrote:
>>> On Mon, Apr 09 2018 at 11:51am -0400,
>>> Mike Snitzer <snitzer@redhat.com> wrote:
>>>
>>>> On Sun, Apr 08 2018 at 12:00am -0400,
>>>> Ming Lei <ming.lei@redhat.com> wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> The following kernel oops(divide error) is triggered when running
>>>>> xfstest(generic/347) on ext4.
>>>>>
>>>>> [  442.632954] run fstests generic/347 at 2018-04-07 18:06:44
>>>>> [  443.839480] divide error: 0000 [#1] PREEMPT SMP PTI
>>>>> [  443.840201] Dumping ftrace buffer:
>>>>> [  443.840692]    (ftrace buffer empty)
>>> ...
>>>>> [  443.845756] CPU: 1 PID: 29607 Comm: dmsetup Not tainted 4.16.0_f605ba97fb80_master+ #1
>>>>> [  443.846968] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-2.fc27 04/01/2014
>>>>> [  443.848147] RIP: 0010:pool_io_hints+0x77/0x153 [dm_thin_pool]
>>>
>>> ...
>>>
>>>> I was able to reproduce (in my case RIP was pool_io_hints+0x45)
>>>>
>>>> Which on my kernel, is:
>>>>
>>>> crash> dis -l pool_io_hints+0x45
>>>> /root/snitm/git/linux/drivers/md/dm-thin.c: 2748
>>>> 0xffffffffc0765165 <pool_io_hints+69>:  div    %rdi
>>>>
>>>> Which is drivers/md/dm-thin.c:is_factor()'s return
>>>> !sector_div(block_size, n);
>>>>
>>>> SO looking at pool_io_hints() it would seem limits->max_sectors is 0 for
>>>> this xfstests device... why would that be!?
>>>>
>>>> Clearly pool_io_hints() could stand to be more defensive with a
>>>> !limits->max_sectors negative check but is it ever really valid for
>>>> max_sectors to be 0?
>>>>
>>>> Pretty sure the ultimate bug is outside DM (but not seeing an obvious
>>>> place where block core would set max_sectors to 0, all blk-settings.c
>>>> uses min_not_zero(), etc).
>>>
>>> I successfully ran this test against the linux-dm.git
>>> "for-4.17/dm-changes" tag that Linus merged after the block changes:
>>>  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.17/dm-changes
>>>
>>> # ./check tests/generic/347
>>> FSTYP         -- ext4
>>> PLATFORM      -- Linux/x86_64 thegoat 4.16.0-rc5.snitm
>>> MKFS_OPTIONS  -- /dev/mapper/test-xfstests_scratch
>>> MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-xfstests_scratch /scratch
>>>
>>> generic/347      65s
>>> Ran: generic/347
>>> Passed all 1 tests
>>>
>>> SO this would seem to implicate some regression in the 4.17 block layer
>>> changes.
>>
>> No immediate ideas come to mind, we didn't have a lot of changes and I
>> don't see anything that looks problematic. Maybe you can try and
>> bisect it and see what you come up with?
> 
> I ran it, problematic commit is:
> 
> commit 3c8ba0d61d04ced9f8d9ff93977995a9e4e96e91
> Author: Kees Cook <keescook@chromium.org>
> Date:   Fri Mar 30 18:52:36 2018 -0700
> 
>     kernel.h: Retain constant expression output for max()/min()
> 

The fun continues. Thinking I'd try a userspace repro and thinking it
would be difficult to reproduce, try the attached min.c that just copies
all the bits from include/linux/kernel.h

axboe@x1:~ $ gcc -Wall -O2 -o min min.c
axboe@x1:~ $ ./min 128 256
min_not_zero(128, 256) = 0

-- 
Jens Axboe


--------------C90BFEFBC64939D9EED8A038
Content-Type: text/x-csrc;
 name="min.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="min.c"

#include <stdio.h>
#include <stdlib.h>

#define __is_constexpr(x) \
	(sizeof(int) == sizeof(*(8 ? ((void *)((long)(x) * 0l)) : (int *)8)))

#define __no_side_effects(x, y) \
		(__is_constexpr(x) && __is_constexpr(y))

#define __typecheck(x, y) \
		(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))

#define __safe_cmp(x, y) \
		(__typecheck(x, y) && __no_side_effects(x, y))

#define __cmp(x, y, op)	((x) op (y) ? (x) : (y))

#define __cmp_once(x, y, op) ({		\
		typeof(x) __x = (x);	\
		typeof(y) __y = (y);	\
		__cmp(__x, __y, op); })

#define __careful_cmp(x, y, op)				\
		__builtin_choose_expr(__safe_cmp(x, y),	\
				      __cmp(x, y, op), __cmp_once(x, y, op))

#define min(x, y)	__careful_cmp(x, y, <)

#define min_not_zero(x, y) ({			\
	typeof(x) __x = (x);			\
	typeof(y) __y = (y);			\
	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })

int main(int argc, char *argv[])
{
	int val1, val2;

	if (argc < 3) {
		printf("%s val1 val2\n", argv[0]);
		return 1;
	}

	val1 = atoi(argv[1]);
	val2 = atoi(argv[2]);
	printf("min_not_zero(%d, %d) = %d\n", val1, val2, min_not_zero(val1, val2));
	return 0;
}

--------------C90BFEFBC64939D9EED8A038
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------C90BFEFBC64939D9EED8A038--
