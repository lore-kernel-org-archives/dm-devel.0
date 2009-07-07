From: Christian May <cmay@linux.vnet.ibm.com>
Subject: Re: dm-devel Digest, Vol 65, Issue 3
Date: Tue, 07 Jul 2009 10:19:50 +0200
Message-ID: <4A530526.8040801@linux.vnet.ibm.com>
References: <20090702200242.DD5298E079C@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090702200242.DD5298E079C@hormel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


Yes, multipath daemon was still running. In the meantime I've updated my 
multipath tools to Hannes latest and greatest version.
It works...Hannes, can you please send your patches/findings 
upstream...would be great.

Thanx.

Christian

>
> One simple question. Did you observe if multipathd is (still) running ?
> (when the port was enabled)
>
> On Thu, 2009-07-02 at 13:27 +0200, Christian May wrote:
>   
>> Hi,
>>
>> I've setup an IBM z10 LPAR (mainframe server) with 2.6.30-kernel. 
>> Attached to the System z10 was an IBM DS8000 storage server. 10x SCSI 
>> LUNs were assigned to LPAR via two pathes:
>>
>> Example:
>> 36005076303ffc1040000000000001269 dm-9 IBM,2107900
>> size=1.0G features='1 queue_if_no_path' hwhandler='0' wp=rw
>> `-+- policy='round-robin 0' prio=-2 status=active
>>   |- 0:0:0:1080639506 sdw   65:96  active undef running
>>   `- 1:0:1:1080639506 sdt   65:48  active undef running
>>
>> Special parameter setting: dev_loss_tmo=90sec; fast_io_fail_tmo=5sec
>>
>> multipath tools: multipath-tools v0.4.9 (04/04, 2009)
>> device-mapper: device-mapper-1.02.27-7.fc10.s390x, 
>> device-mapper-libs-1.02.27-7.fc10.s390x
>>
>> When removing a remote port (disabling a port on the BROCADE FC switch) 
>> one path failed.
>>
>> root@h42lp26/ESAME:~]
>>  > multipath -l
>> 36005076303ffc1040000000000001268 dm-8 ,
>> size=1.0G features='1 queue_if_no_path' hwhandler='0' wp=rw
>> `-+- policy='round-robin 0' prio=-2 status=active
>>   |- #:#:#:#          -     #:#   failed undef running
>>   `- 1:0:1:1080573970 sdr   65:16 active undef running
>>
>> After a while (>90sec) SCSI LUNs were removed from system:
>>
>>
>> UEVENT[1246531815.619428] add      /kernel/uids/74 (uids)
>> UDEV  [1246531815.621708] add      /kernel/uids/74 (uids)
>> UEVENT[1246531816.725299] remove   /kernel/uids/74 (uids)
>> UDEV  [1246531816.726151] remove   /kernel/uids/74 (uids)
>> UEVENT[1246531929.959709] change   /devices/virtual/block/dm-0 (block)
>> UEVENT[1246531929.959749] change   /devices/virtual/block/dm-3 (block)
>> UEVENT[1246531929.959759] change   /devices/virtual/block/dm-4 (block)
>> UEVENT[1246531929.959769] change   /devices/virtual/block/dm-5 (block)
>> UEVENT[1246531929.966647] change   /devices/virtual/block/dm-7 (block)
>> UDEV  [1246531930.045444] change   /devices/virtual/block/dm-4 (block)
>> UDEV  [1246531930.048923] change   /devices/virtual/block/dm-7 (block)
>> UDEV  [1246531930.054614] change   /devices/virtual/block/dm-0 (block)
>> UDEV  [1246531930.060091] change   /devices/virtual/block/dm-3 (block)
>> UDEV  [1246531930.071744] change   /devices/virtual/block/dm-5 (block)
>> UEVENT[1246531949.278541] change   /devices/virtual/block/dm-9 (block)
>> UDEV  [1246531949.369690] change   /devices/virtual/block/dm-9 (block)
>> UEVENT[1246531950.295756] change   /devices/virtual/block/dm-8 (block)
>> UEVENT[1246531950.297597] change   /devices/virtual/block/dm-6 (block)
>> UEVENT[1246531950.297610] change   /devices/virtual/block/dm-2 (block)
>> UEVENT[1246531950.297620] change   /devices/virtual/block/dm-1 (block)
>> UDEV  [1246531950.430097] change   /devices/virtual/block/dm-8 (block)
>> UDEV  [1246531950.588626] change   /devices/virtual/block/dm-2 (block)
>> UDEV  [1246531950.632482] change   /devices/virtual/block/dm-1 (block)
>> UDEV  [1246531950.634515] change   /devices/virtual/block/dm-6 (block)
>> UEVENT[1246532034.277177] remove   
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080377362/scsi_generic/sg0 
>> (scsi_generic)
>> UEVENT[1246532034.277214] remove   
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080377362/scsi_device/0:0:0:1080377362 
>> (scsi_device)
>> UEVENT[1246532034.277226] remove   
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080377362/scsi_disk/0:0:0:1080377362 
>> (scsi_disk)
>> UEVENT[1246532034.277236] remove   /devices/virtual/bdi/8:0 (bdi)
>> UEVENT[1246532034.277247] remove   
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080377362/block/sda 
>> (block)
>> UEVENT[1246532034.277258] remove   
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080377362 
>> (scsi)
>> UEVENT[1246532034.277384] remove   
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080836114/scsi_generic/sg2 
>> (scsi_generic)
>> UEVENT[1246532034.277594] remove   
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080836114/scsi_device/0:0:0:1080836114 
>> (scsi_device)
>> UEVENT[1246532034.277864] remove   
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080836114/scsi_disk/0:0:0:1080836114 
>> (scsi_disk)
>> UEVENT[1246532034.278035] remove   /devices/virtual/bdi/8:32 (bdi)...
>>
>> ....
>>
>> When re-enabling the path, SCSI LUNS were reassigned to system but path 
>> didn't recover:
>>
>> UEVENT[1246532107.387169] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080836114 
>> (scsi)
>>   UEVENT[1246532107.387209] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080836114/scsi_device/0:0:0:1080836114 
>> (scsi_device)
>>   UEVENT[1246532107.387220] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080836114/scsi_generic/sg0 
>> (scsi_generic)
>>   UEVENT[1246532107.387230] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080836114/scsi_disk/0:0:0:1080836114 
>> (scsi_disk)
>>   UEVENT[1246532107.388941] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080377362 
>> (scsi)
>>   UEVENT[1246532107.388952] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080377362/scsi_device/0:0:0:1080377362 
>> (scsi_device)
>>   UEVENT[1246532107.388963] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080377362/scsi_generic/sg2 
>> (scsi_generic)
>>   UEVENT[1246532107.397111] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080836114/block/sdu 
>> (block)
>>   UEVENT[1246532107.399249] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080639506 
>> (scsi)
>>   UEVENT[1246532107.399261] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080639506/scsi_device/0:0:0:1080639506 
>> (scsi_device)
>>   UEVENT[1246532107.399272] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080639506/scsi_generic/sg4 
>> (scsi_generic)
>>   UEVENT[1246532107.399711] add      /devices/virtual/bdi/65:64 (bdi)
>>   UEVENT[1246532107.399722] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080377362/scsi_disk/0:0:0:1080377362 
>> (scsi_disk)
>>   UEVENT[1246532107.401605] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080573970 
>> (scsi)
>>   UEVENT[1246532107.401617] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080573970/scsi_device/0:0:0:1080573970 
>> (scsi_device)
>>   UEVENT[1246532107.401628] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080573970/scsi_generic/sg6 
>> (scsi_generic)
>>   UEVENT[1246532107.403731] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080967186 
>> (scsi)
>>   UEVENT[1246532107.403742] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080967186/scsi_device/0:0:0:1080967186 
>> (scsi_device)
>>   UEVENT[1246532107.403753] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080967186/scsi_generic/sg8 
>> (scsi_generic)
>>   UEVENT[1246532107.405963] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080377362/block/sdv 
>> (block)
>>   UEVENT[1246532107.406168] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080901650 
>> (scsi)
>>   UEVENT[1246532107.407608] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080901650/scsi_device/0:0:0:1080901650 
>> (scsi_device)
>>   UEVENT[1246532107.407624] add      
>> /devices/css0/0.0.0330/0.0.1780/host0/rport-0:0-0/target0:0:0/0:0:0:1080901650/scsi_generic/sg10 
>> (scsi_generic)
>>   UEVENT[1246532107.407880] add      /devices/virtual/bdi/65:80 (bdi)
>>
>>
>> [root@h42lp26/ESAME:~]
>>  > multipath -l
>> 36005076303ffc1040000000000001268 dm-8 ,
>> size=1.0G features='1 queue_if_no_path' hwhandler='0' wp=rw
>> `-+- policy='round-robin 0' prio=-2 status=active
>>   |- #:#:#:#          -     #:#    failed undef running
>>   `- 1:0:1:1080573970 sdr   65:16  active undef running
>>
>>
>> Running "multipath" command will recover the failed path but that's not 
>> way it should be...can somebody help to fix this? Why is the path not 
>> recovered automatically?
>>
>>
>> Regards,
>>
>>
>> Christian May
>>     
