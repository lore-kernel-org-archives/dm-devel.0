From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: preload also scsi_dh_hp_sw
 before run multipathd
Date: Wed, 12 Oct 2016 13:37:17 +0200
Message-ID: <a00c50a5-3eae-edfb-f793-89fee7cd734c@gmail.com>
References: <20161011125515.8523-1-xose.vazquez@gmail.com>
	<2779bae3-28f4-9b0f-b014-583b717f715e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2779bae3-28f4-9b0f-b014-583b717f715e@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/11/2016 03:41 PM, Hannes Reinecke wrote:

> On 10/11/2016 02:55 PM, Xose Vazquez Perez wrote:
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  multipathd/multipathd.service | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
>> index e3d6f91..45aca35 100644
>> --- a/multipathd/multipathd.service
>> +++ b/multipathd/multipathd.service
>> @@ -11,7 +11,7 @@ Conflicts=shutdown.target
>>  Type=notify
>>  NotifyAccess=main
>>  LimitCORE=infinity
>> -ExecStartPre=/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_rdac dm-multipath
>> +ExecStartPre=/sbin/modprobe -a scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh_rdac dm-multipath
>>  ExecStart=/sbin/multipathd -d -s
>>  ExecReload=/sbin/multipathd reconfigure
>>
> If you can point me to a single user of an MSA1500 I'm happy to include it. If you don't
> know what an MSA1500 is nor what hp_sw does it's probably not a good idea to have it.

Why?

scsi_dh_hp_sw is used also for dec/compaq ESA12000 and RA8000 arrays with HSG80 controller.
And in HP MSA 1000/1500 and EVA 3000/5000, with old firmware.

Thank you.
