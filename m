From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
Date: Wed, 13 May 2009 08:56:13 +0800
Message-ID: <4A0A1AAD.3090606@cn.fujitsu.com>
References: <4A08F1B3.4060700@cn.fujitsu.com>	<20090512.151104.71103166.ryov@valinux.co.jp>	<4A092EE7.4070403@cn.fujitsu.com> <20090512.191206.226779551.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756893AbZEMAz3@vger.kernel.org>
In-Reply-To: <20090512.191206.226779551.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: Alan.Brunelle@hp.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
List-Id: dm-devel.ids

>>>>>> Thanks for your suggestion. I'll use TRACE_EVENT instead.
>>>>> blk_add_trace_msg() supports both blktrace and tracepoints. I can
>>>>> get messages from dm-ioband through debugfs. Could you expain why
>>>>> should we use TRACE_EVENT instead?
>>>>>
>>>> Actually blk_add_trace_msg() has nothing to do with tracepoints..
>>>>
>>>> If we use blk_add_trace_msg() is dm, we can use it in md, various block
>>>> drivers and even ext4. So the right thing is, if a subsystem wants to add
>>>> trace facility, it should use tracepoints/TRACE_EVENT.
>>>>
>>>> With TRACE_EVENT, you can get output through debugfs too, and it can be used
>>>> together with blktrace:
>>>>
>>>>  # echo 1 > /sys/block/dm/trace/enable
>>>>  # echo blk > /debugfs/tracing/current_tracer
>>>>  # echo dm-ioband-foo > /debugfs/tracing/tracing/set_event
>>>>  # cat /deubgfs/tracing/trace_pipe
>>>>  
>>>> And you can enable dm-ioband-foo while disabling dm-ioband-bar, and you can
>>>> use filter feature too.
>>> Thanks for explaining.
>>> The base kernel of current dm tree (2.6.30-rc4) has not supported
>>> dm-device tracing yet. I'll consider using TRACE_EVENT when the base
>>> kernel supports dm-device tracing.
>>>
>> I think we don't have any plan on dm-device tracing support, do we? And you
>> don't need that.
>>
>> I downloaded dm-ioband 1.10.4, and applied it to latest tip-tree, and made
>> a patch to convert those blktrace msgs to trace events.
>>
>>  # ls /debug/tracing/events/dm-ioband
>>  enable  ioband_endio     ioband_issue_list    ioband_urgent_bio
>>  filter  ioband_hold_bio  ioband_make_request
>>  # echo 1 /debug/tracing/events/dm-ioband/enable
>>  # echo blk /debug/tracing/current_tracer
>>  ...
> 
> Is the following line unnecessary in the latest tip-tree?
> 
>    # echo 1 > /sys/block/dm/trace/enable
> 

Yes, still needed. I was not giving a complete demonstration. ;)

> How to enable/disable tracing on each device?

echo 1 > /sys/block/dm-0/trace/enable
echo 1 > /sys/block/dm-1/trace/enable

Or use filter facility:

echo "dev == $(( (ma0 << 20) | mi0 ))" > /debug/tracing/events/dm-ioband/filter

This will filter out all events generated from dm-1, leaving those from dm-0.
