From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [dm-devel] [PATCH] Fix I/O counts in vmstat
Date: Thu, 22 Mar 2012 11:06:37 +0900
Message-ID: <4F6A892D.1030601@ce.jp.nec.com>
References: <Pine.LNX.4.64.1203202336370.15617@file.rdu.redhat.com> <4F69A798.4000200@ce.jp.nec.com> <Pine.LNX.4.64.1203211148220.23047@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1203211148220.23047@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

On 03/22/12 00:50, Mikulas Patocka wrote:
> On Wed, 21 Mar 2012, Jun'ichi Nomura wrote:
>>> The decision whether bio is counted or not is made by the code that
>>> submits the bio. This leads to some problems:
>>
>> How about convering dm targets to use generic_make_request?
> 
> The problem would be raid1 resynchronization. There are no incoming bios 
> when resynchronizing, but the administrator still needs to see the 
> resynchronization workload in vmstat. The code path that submits bios for 
> resynchronization is the same as the path that handles write requests.

Admins could see the workload with iostat or sar.
If pgpgout does not increase but iostat shows disk activity,
admins can tell resynchronization is going on.

> Also dm-over-loop would still result in double-counting, even if we use 
> generic_make_request in dm.

It reflects the fact that writeback actually happens twice.

>> Since submit_bio counts vm events, it seems natural for
>> caller to decide which function to use.
>> Device driver does not know whether the requested I/O is
>> for vm-to-device or device-to-device.
>> We could still use iostat to measure throughput of individual
>> block devices. 

-- 
Jun'ichi Nomura, NEC Corporation
