From: Nicola Murino <n.murino@theorematica.it>
Subject: Re: EMC CX LUN problem [SOLVED]
Date: Wed, 25 Jan 2006 20:42:13 +0100
Message-ID: <43D7D495.6000006@theorematica.it>
References: <43D69CB0.8020402@theorematica.it>	<1138141690.6009.8.camel@ca-bwong3.trans.corp>
	<43D73F73.4010907@theorematica.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43D73F73.4010907@theorematica.it>
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

Finally I solved my problem, the gulty was scsi_id, I install CentOS and 
scsi_id works as expected reporting different uuid for each lun

this is my final situation:

[root@server1 block]# scsi_id -g -u -s /block/sdb
36006016086f01600bc80c9afbc8dda11
[root@server1 block]# scsi_id -g -u -s /block/sdc
36006016086f01600463513d9978dda11
[root@server1 block]# scsi_id -g -u -s /block/sdd
36006016086f01600bc80c9afbc8dda11
[root@server1 block]# scsi_id -g -u -s /block/sde
36006016086f01600463513d9978dda11
[root@server1 block]# scsi_id -g -u -s /block/sdf
36006016086f01600bc80c9afbc8dda11
[root@server1 block]# scsi_id -g -u -s /block/sdg
36006016086f01600463513d9978dda11
[root@server1 block]# scsi_id -g -u -s /block/sdh
36006016086f01600bc80c9afbc8dda11
[root@server1 block]# scsi_id -g -u -s /block/sdi
36006016086f01600463513d9978dda11



multipath -l
mail (36006016086f01600bc80c9afbc8dda11)
[size=150 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [active]
  \_ 1:0:1:0 sdd  8:48    [active]
  \_ 2:0:1:0 sdh  8:112   [active]
\_ round-robin 0 [enabled]
  \_ 1:0:0:0 sdb  8:16    [active]
  \_ 2:0:0:0 sdf  8:80    [active]

ql (36006016086f01600463513d9978dda11)
[size=500 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [active]
  \_ 1:0:1:1 sde  8:64    [active]
  \_ 2:0:1:1 sdi  8:128   [active]
\_ round-robin 0 [enabled]
  \_ 1:0:0:1 sdc  8:32    [active]
  \_ 2:0:0:1 sdg  8:96    [active]


scsi_id is broken in gentoo and ubuntu, at least for this setup infact I 
have a working multipath setup using gentoo with some minor difference 
in hardware equipment,

thanks to all,

regards
Nicola


Nicola Murino ha scritto:
> Brian Wong ha scritto:
>> On Tue, 2006-01-24 at 22:31 +0100, Nicola Murino wrote:
>>  
>>> Hi,
>>>
>>> I'm trying to configure a new emc cx storage, I have the following:
>>>
>>> 2 server, each server has a qla2462 dual port hba
>>> each qla2462 is connected to a switch (only one switch)
>>> 1 emc cx storage with 4 path connected to the switch
>>>
>>> I defined two lun on the storage however I'm able to see only one LUN
>>>
>>> multipath -l show the following:
>>>
>>> multipath -l
>>> mail (36006016086f01600e46f567adb8cda11)
>>> [size=150 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
>>> \_ round-robin 0 [active]
>>>  \_ 1:0:1:0 sdd 8:48  [active][ready]
>>>  \_ 1:0:1:1 sde 8:64  [active][ready]
>>>  \_ 2:0:1:0 sdh 8:112 [active][ready]
>>>  \_ 2:0:1:1 sdi 8:128 [active][ready]
>>> \_ round-robin 0 [enabled]
>>>  \_ 2:0:0:0 sdf 8:80  [active][ready]
>>>  \_ 1:0:0:0 sdb 8:16  [active][ready]
>>>  \_ 1:0:0:1 sdc 8:32  [active][ready]
>>>  \_ 2:0:0:1 sdg 8:96  [active][ready]
>>>
>>>     
>>
>> i could be off in the weeds here, but this output looks wrong.  the
>> host:channel:target:lun numbers listed there suggest your cx is indeed
>> surfacing luns 0 and 1, but multipath is grouping them under a single
>> target ID.
>>
>>   
> Maybe you are right! I added another LUN and this is multipath output
>
> multipath -l
> mail (36006016086f01600e46f567adb8cda11)
> [size=150 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
> \_ round-robin 0 [active]
> \_ 2:0:0:0 sdh 8:112 [active][ready]
> \_ 1:0:0:0 sdb 8:16  [active][ready]
> \_ 1:0:0:1 sdc 8:32  [active][ready]
> \_ 1:0:0:2 sdd 8:48  [active][ready]
> \_ 2:0:0:1 sdi 8:128 [active][ready]
> \_ 2:0:0:2 sdj 8:144 [active][ready]
> \_ round-robin 0 [enabled]
> \_ 1:0:1:0 sde 8:64  [active][ready]
> \_ 1:0:1:1 sdf 8:80  [active][ready]
> \_ 1:0:1:2 sdg 8:96  [active][ready]
> \_ 2:0:1:0 sdk 8:160 [active][ready]
> \_ 2:0:1:1 sdl 8:176 [active][ready]
> \_ 2:0:1:2 sdm 8:192 [active][ready]
>
>
>> i think emc engineers monitor this list; perhaps they can help.
>>   
> maybe the problem is scsi_id that report the same output for all block 
> device,
>
> I have kernel 2.6.16-rc1 on a server and 2.6.13.5 on the other one,
>
> with 2.6.16-rc1
>
> lsmod
> Module                  Size  Used by
> dm_round_robin          3840  1
> dm_emc                  5760  1
> dm_multipath           18696  3 dm_round_robin,dm_emc
> qla2400               200448  0
> qla2xxx               116964  25 qla2400
>
> with 2.6.13.5
>
>
> root@server1:/home/admin# lsmod
> Module                  Size  Used by
> ehci_hcd               29576  0
> uhci_hcd               30864  0
> usbcore               104828  3 ehci_hcd,uhci_hcd
> dm_round_robin          3712  1
> dm_emc                  5632  1
> dm_multipath           18312  3 dm_round_robin,dm_emc
> qla2xxx               110044  12
> firmware_class          8448  1 qla2xxx
>
>
> hba controller are qlogic2462
>
> thanks
> Nicola
>
>
>
>> also, look at this if you havent already (there's a section on clariion
>> cx's), and feel free to add your findings.
>>
>> http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments
>>
>> hope that helps,
>>
>> brian
>>
>>
>> -- 
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>>   
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
