From: majianpeng <majianpeng@gmail.com>
Subject: Re: [PATCH] dm-cache: Add handle to contlr if
	cache_create failed.
Date: Fri, 8 Mar 2013 11:13:33 +0800
Message-ID: <201303081113305023593@gmail.com>
References: <5139441C.7000309@gmail.com>,
	<20130308021027.GV8913@agk.fab.redhat.com>
Reply-To: majianpeng <majianpeng@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk <agk@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

>On Fri, Mar 08, 2013 at 09:51:24AM +0800, majianpeng wrote:
>> It  ignored to judge the result of cache_create.
>> If cache_create failed, but the copy_ctr_args successed.
>
>Thanks for reporting this, but I already added this patch to linux-next today:
>  https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=f1ccbd181202c660b237b9bef0af277b980d5073
>
>and will push the batch of 7 patches upstream either Friday or early
>next week.  (I'm waiting to hear about two more patches first: a fix for
>a theoretical problem that's been discovered and a possible adjustment
>to the hints metadata.)
>
>Alasdair
>
I wanted to use dm-cache on softraid5 to improve the performance.
But  i don't know how to use.I readed the document and found a example:
>dmsetup create my_cache --table '0 41943040 cache /dev/mapper/metadata \
>	/dev/mapper/ssd /dev/mapper/origin 512 1 writeback default 0'
After the this,  mke2fs on /dev/mapper/origin met error.
 Did i use my_cache or origin to mkfs?

Thanks!
Jianpeng Ma
