From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC] IO scheduler based IO controller V9
Date: Thu, 10 Sep 2009 11:20:13 +0800
Message-ID: <4AA8706D.3050802@cn.fujitsu.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <4AA4B905.8010801@cn.fujitsu.com> <20090908191941.GF15974@redhat.com> <4AA75B71.5060109@cn.fujitsu.com> <20090909150537.GD8256@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754988AbZIJDVz@vger.kernel.org>
In-Reply-To: <20090909150537.GD8256@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com
List-Id: dm-devel.ids

Vivek Goyal wrote:
> On Wed, Sep 09, 2009 at 03:38:25PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> On Mon, Sep 07, 2009 at 03:40:53PM +0800, Gui Jianfeng wrote:
>>>> Hi Vivek,
>>>>
>>>> I happened to encount a bug when i test IO Controller V9.
>>>> When there are three tasks to run concurrently in three group,
>>>> that is, one is parent group, and other two tasks are running=20
>>>> in two different child groups respectively to read or write=20
>>>> files in some disk, say disk "hdb", The task may hang up, and=20
>>>> other tasks which access into "hdb" will also hang up.
>>>>
>>>> The bug only happens when using AS io scheduler.
>>>> The following scirpt can reproduce this bug in my box.
>>>>
>>> Hi Gui,
>>>
>>> I tried reproducing this on my system and can't reproduce it. All t=
he
>>> three processes get killed and system does not hang.
>>>
>>> Can you please dig deeper a bit into it.=20
>>>
>>> - If whole system hangs or it is just IO to disk seems to be hung.
>>     Only when the task is trying do IO to disk it will hang up.
>>
>>> - Does io scheduler switch on the device work
>>     yes, io scheduler can be switched, and the hung task will be res=
umed.
>>
>>> - If the system is not hung, can you capture the blktrace on the de=
vice.
>>>   Trace might give some idea, what's happening.
>> I run a "find" task to do some io on that disk, it seems that task h=
angs=20
>> when it is issuing getdents() syscall.
>> kernel generates the following message:
>>
>> INFO: task find:3260 blocked for more than 120 seconds.
>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mes=
sage.
>> find          D a1e95787  1912  3260   2897 0x00000004
>>  f6af2db8 00000096 f660075c a1e95787 00000032 f6600270 f6600508 c203=
7820
>>  00000000 c09e0820 f655f0c0 f6af2d8c fffebbf1 00000000 c0447323 f715=
2a1c
>>  0006a144 f7152a1c 0006a144 f6af2e04 f6af2db0 c04438df c2037820 c203=
7820
>> Call Trace:
>>  [<c0447323>] ? getnstimeofday+0x57/0xe0
>>  [<c04438df>] ? ktime_get_ts+0x4a/0x4e
>>  [<c068ab68>] io_schedule+0x47/0x79
>>  [<c04c12ee>] sync_buffer+0x36/0x3a
>>  [<c068ae14>] __wait_on_bit+0x36/0x5d
>>  [<c04c12b8>] ? sync_buffer+0x0/0x3a
>>  [<c068ae93>] out_of_line_wait_on_bit+0x58/0x60
>>  [<c04c12b8>] ? sync_buffer+0x0/0x3a
>>  [<c0440fa4>] ? wake_bit_function+0x0/0x43
>>  [<c04c1249>] __wait_on_buffer+0x19/0x1c
>>  [<f81e4186>] ext3_bread+0x5e/0x79 [ext3]
>>  [<f81e77a8>] htree_dirblock_to_tree+0x1f/0x120 [ext3]
>>  [<f81e7923>] ext3_htree_fill_tree+0x7a/0x1bb [ext3]
>>  [<c04a01f9>] ? kmem_cache_alloc+0x86/0xf3
>>  [<c044c428>] ? trace_hardirqs_on_caller+0x107/0x12f
>>  [<c044c45b>] ? trace_hardirqs_on+0xb/0xd
>>  [<f81e09e4>] ? ext3_readdir+0x9e/0x692 [ext3]
>>  [<f81e0b34>] ext3_readdir+0x1ee/0x692 [ext3]
>>  [<c04b1100>] ? filldir64+0x0/0xcd
>>  [<c068b86a>] ? mutex_lock_killable_nested+0x2b1/0x2c5
>>  [<c068b874>] ? mutex_lock_killable_nested+0x2bb/0x2c5
>>  [<c04b12db>] ? vfs_readdir+0x46/0x94
>>  [<c04b12fd>] vfs_readdir+0x68/0x94
>>  [<c04b1100>] ? filldir64+0x0/0xcd
>>  [<c04b1387>] sys_getdents64+0x5e/0x9f
>>  [<c04028b4>] sysenter_do_call+0x12/0x32
>> 1 lock held by find/3260:
>>  #0:  (&sb->s_type->i_mutex_key#7){+.+.+.}, at: [<c04b12db>] vfs_rea=
ddir+0x46/0x94
>>
>> ext3 calls wait_on_buffer() to wait buffer, and schedule the task ou=
t in TASK_UNINTERRUPTIBLE
>> state, and I found this task will be resumed after a quite long peri=
od(more than 10 mins).
>=20
> Thanks Gui. As Jens said, it does look like a case of missing queue
> restart somewhere and now we are stuck, no requests are being dispatc=
hed
> to the disk and queue is already unplugged.
>=20
> Can you please also try capturing the trace of events at io scheduler
> (blktrace) to see how did we get into that situation.

  Ok, I'll try.

>=20
> Are you using ide drivers and not libata? As jens said, I will try to=
 make
> use of ide drivers and see if I can reproduce it.

  Hi Vivek, Jens,

  yes, i used the old ide driver. So I switch to libata instead(deactiv=
ate the=20
  whole =E2=80=9CATA/ATAPI/MFM/RLL support=E2=80=9D), the bug still exi=
sts and I can reproduce
  it by that script.

>=20
> Thanks
> Vivek
>=20
>=20
>=20

--=20
Regards
Gui Jianfeng
