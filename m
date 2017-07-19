From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH 0/2] multipath-tools/libmultipath: Support
 for the native NVMe Ioctl command and add args min_avg_latency for
 path_latency.
Date: Wed, 19 Jul 2017 10:13:13 +0800
Message-ID: <1d61ba74-423f-651d-87d3-ae8b322f3301@huawei.com>
References: <1499932288-15420-1-git-send-email-philip.yang@huawei.com>
	<aa611abe-5149-6847-e1d9-c501f1586a64@gmail.com>
	<7b972a5c-3e51-ae74-9b8e-b8f3f0eede19@huawei.com>
	<1500029120.4808.13.camel@suse.com>
	<7349ceaa-71d3-600d-b7ef-bbdaa5f5b724@huawei.com>
	<b86f625a-f500-c35a-9660-88fb9f7c17c5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b86f625a-f500-c35a-9660-88fb9f7c17c5@gmail.com>
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
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
Cc: zouming.zouming@huawei.com, chengjike.cheng@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Hi Xose,

Thanks for your reviews

The up-to-date patch will be sent later.

Regards!
-Yang

On 2017/7/18 7:00, Xose Vazquez Perez wrote:
> On 07/17/2017 04:23 AM, Yang Feng wrote:
> 
>> I think there is a mistake:
>> 1. In fact, the tur checker feature has never been removed. The tur checker
>> has just been renamed to "ping" checker and the keep alive command checker
>> feature is added into this checker. So, the renamed checker remains "tur"
>> and add "keep alive". Absolutely, I agree that SCSI is going to stay for
>> some time to come, So it can support a SCSI device by "tur" and support a
>> NVMe device by "keep alive".
>> 2. If add a new checker for "keep alive", it maybe increase the redundancy
>> of code. And, when the SCSI LUN and the NVMe namespace are maped in the
>> same array for the same host, no matter which checker is choosed, it will
>> not be able to support the scenario very well.
>> 3. Using read() with O_DIRECT for path_latency can avoid this problem, but
>> can not fix this problem.
> There is no need to rename tur to ping. Same work can be done over tur.c.
> 
> 
