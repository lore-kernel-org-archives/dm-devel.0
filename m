From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH] multipath-tools: check sysfs path state for
	NVMe/NVMf
Date: Fri, 28 Jul 2017 14:54:01 +0800
Message-ID: <87413531-8abe-a279-dd97-0d49e56984b6@huawei.com>
References: <1501205323-13440-1-git-send-email-guanjunxiong@huawei.com>
	<66209fe7-9ed4-d269-5102-5a97a3c58854@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <66209fe7-9ed4-d269-5102-5a97a3c58854@suse.de>
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
To: Hannes Reinecke <hare@suse.de>, dm-devel@redhat.com, christophe.varoqui@opensvc.com, mwilck@suse.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: philip.yang@huawei.com, zouming.zouming@huawei.com, hege09@huawei.com, shenhong09@huawei.com
List-Id: dm-devel.ids

Hi Hannes,

On 2017/7/28 14:12, Hannes Reinecke wrote:
> On 07/28/2017 03:28 AM, Guan Junxiong wrote:
>> The previous code of path_offline checking was only valid for SCSI
>> device. It returned PATH_UP for other devices and throwed path check-
>> ing to chekers. This patch supplements checking sysfs path state for
>> NVMe/NVMf devices. For example, if NVMe/NVMf path is reconnectting or
>> resetting, we return PATH_PENDING in order to skip current path check-
>> ing and reschedule path checking in the next tick as soon as possible.
>>
>> Signed-off-by: Guan Junxiong <guanjunxiong@huawei.com>
>> ---
>>  libmultipath/discovery.c | 45 +++++++++++++++++++++++++++++++++++----------
>>  1 file changed, 35 insertions(+), 10 deletions(-)
>>
> Thanks for doing this.
> 
>>
> Patch looks good.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> 
Nice to have any review. Thanks.

> However, I do wonder if we really need a path checker for NVMf once we
> have this. After all, the sysfs attribute reflects that KATO status,
> which pretty much determines if we can send I/O _at all_.
> 
> Cheers,
>
> Hannes

IMO, I think Keep Alive feature is in controller granularity , _not_ namespace
granularity. A namespace can be detached ( or disabled with nvmetcli tools)
from controller which has many namespaces attached, but the controller sysfs
state attribute is still "live". Therefor, we do need further path checker
after we know controller is live.

Refer to the following quoted from NVMe Spec 1.3:
"The Keep Alive feature is used by the host to determine that the controller
is operational and by the controller to determine that the host is operational.
The host and controller are operational when each is accessible and able to
issue or execute commands."


Regards
Guan


.
