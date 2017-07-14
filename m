From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH 0/2] multipath-tools/libmultipath: Support
 for the native NVMe Ioctl command and add args min_avg_latency for
 path_latency.
Date: Fri, 14 Jul 2017 09:47:27 +0800
Message-ID: <7b972a5c-3e51-ae74-9b8e-b8f3f0eede19@huawei.com>
References: <1499932288-15420-1-git-send-email-philip.yang@huawei.com>
	<aa611abe-5149-6847-e1d9-c501f1586a64@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <aa611abe-5149-6847-e1d9-c501f1586a64@gmail.com>
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
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com
Cc: zouming.zouming@huawei.com, guanjunxiong@huawei.com, chengjike.cheng@huawei.com, shenhong09@huawei.com, hege09@huawei.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Xose,

But tur can not support NVMe device, and if the default checker change to ping,
then it can support NVMe device by a keep alive command and SCSI device by a
tur command.

Regards!
-Yang

On 2017/7/14 0:44, Xose Vazquez Perez wrote:
> On 07/13/2017 09:51 AM, Yang Feng wrote:
> 
>> [...]
>>    In the checkers, delete the file tur.c and create the new file ping.c:
>> ping.c can support the native NVMe Keep Alive Ioctl command to the nvme
>> device, and can support the SG TUR Ioctl command to the scsi device.
>> [...]
>>  delete mode 100644 libmultipath/checkers/tur.c
>>  delete mode 100644 libmultipath/checkers/tur.h
> 
> tur can not be deleted. It breaks current configs, and replacing
> the default checker so fast is a bit delicate.
> 
> .
> 
