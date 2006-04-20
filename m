From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath and StorageWorks HSG80
Date: Thu, 20 Apr 2006 23:22:48 +0200
Message-ID: <4447FBA8.3040705@free.fr>
References: <20060420194321.GE29759@ingress.sbb.uvm.edu>	<4447E8BF.1060205@bzed.de>	<20060420204739.GB32417@ingress.sbb.uvm.edu>	<4447F4AC.5040904@free.fr>
	<20060420210504.GC32417@ingress.sbb.uvm.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060420210504.GC32417@ingress.sbb.uvm.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


>> That's certainly where the IO errors are triggered at bootup.
>> Can you send the code snippet ?
>>     
>
> You mean from the init script? Here it is:
>
> hsg80_init() {
>         dummy_capa=2097152
>
>         for i in $(grep -rl 2097152 /sys/block/sd*/size|awk -F/ '{print
> $4}')
>         do
>                 echo
>                 echo "##################################"
>                 echo "FIXING HSG80 device: $i"
>                 echo
>                 sg_start -start /dev/$i
>                 sleep 1
>                 echo 1>/sys/block/$i/device/rescan
>         done
> }
>
> I put the echo's in so that I could see if and for which devices
> it was being called. And yes, it's called for the two "ghost"
> devices (sdc and sdd).
>
>
> But if you look at boot output, the errors begin well before
> the multipath-tools init script runs. 
>
>   
Right, this script can't be the culprit.
> Here is a trimmed excerpt:
>
>
> (218411 MB)
> [42949395.380000] SCSI device sdb: drive cache: write through
> [42949395.450000]  sdb: unknown partition table
> [42949395.510000] sd 0:0:1:1: Attached scsi disk sdb
> [42949395.580000] sdc : READ CAPACITY failed.
> [42949395.580000] sdc : status=1, message=00, host=0, driver=08
> [42949395.710000] sd: Current: sense key: Not Ready
> [42949395.770000]     Additional sense: Logical unit not ready,
> initializing cmd. required
> [42949395.870000] sdc: asking for cache data failed
> [42949395.930000] sdc: assuming drive cache: write through
> [42949396.000000] sdc : READ CAPACITY failed.
> [42949396.000000] sdc : status=1, message=00, host=0, driver=08
> [42949396.130000] sd: Current: sense key: Not Ready
> [42949396.190000]     Additional sense: Logical unit not ready,
> initializing cmd. required
> [42949396.300000] sdc: asking for cache data failed
> [42949396.360000] sdc: assuming drive cache: write through
> [42949396.430000]  sdc:<6>sd 0:0:2:1: Device not ready.
> [42949396.490000] end_request: I/O error, dev sdc, sector 0
>   
The scsi driver probing seems to fail with io errors on ghost paths.
If so, you can consider it harmless.

Regards,
cvaroqui
