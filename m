From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH 0/2] multipath-tools/libmultipath: Support
 for the native NVMe Ioctl command and add args min_avg_latency for
 path_latency.
Date: Mon, 17 Jul 2017 10:23:14 +0800
Message-ID: <7349ceaa-71d3-600d-b7ef-bbdaa5f5b724@huawei.com>
References: <1499932288-15420-1-git-send-email-philip.yang@huawei.com>
	<aa611abe-5149-6847-e1d9-c501f1586a64@gmail.com>
	<7b972a5c-3e51-ae74-9b8e-b8f3f0eede19@huawei.com>
	<1500029120.4808.13.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1500029120.4808.13.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com
Cc: zouming.zouming@huawei.com, chengjike.cheng@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Hi Martin,

Thanks for your reviews.

I think there is a mistake:
1. In fact, the tur checker feature has never been removed. The tur checker
has just been renamed to "ping" checker and the keep alive command checker
feature is added into this checker. So, the renamed checker remains "tur"
and add "keep alive". Absolutely, I agree that SCSI is going to stay for
some time to come, So it can support a SCSI device by "tur" and support a
NVMe device by "keep alive".
2. If add a new checker for "keep alive", it maybe increase the redundancy
of code. And, when the SCSI LUN and the NVMe namespace are maped in the
same array for the same host, no matter which checker is choosed, it will
not be able to support the scenario very well.
3. Using read() with O_DIRECT for path_latency can avoid this problem, but
can not fix this problem.

Respect and regards.
-Yang

On 2017/7/14 18:45, Martin Wilck wrote:
> On Fri, 2017-07-14 at 09:47 +0800, Yang Feng wrote:
>> Hi Xose,
>>
>> But tur can not support NVMe device, and if the default checker
>> change to ping,
>> then it can support NVMe device by a keep alive command and SCSI
>> device by a
>> tur command.
> 
> I agree with Xose. This is what we have the hwtable for. It's a good
> and necessary thing to implement a checker equivalent to TUR for NVME,
> but not a reason to remove TUR. SCSI is going to stay for some time to
> come.
> 
> As for the path latency checker and your readsector0 function, I don't
> quite understand why you are using SG_IO at all. Why can't you just
> read() with O_DIRECT?
> 
> Saying that without having had the time for a deeper review of your
> patch.
> 
> Martin
> 
