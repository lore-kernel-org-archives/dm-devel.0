From: Nicola Murino <n.murino@theorematica.it>
Subject: Re: EMC CX LUN problem
Date: Wed, 25 Jan 2006 09:09:40 +0100
Message-ID: <43D73244.50809@theorematica.it>
References: <43D69CB0.8020402@theorematica.it>	<1138141690.6009.8.camel@ca-bwong3.trans.corp>
	<43D6D16D.1060909@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1470971547=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43D6D16D.1060909@bzed.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, bernd@bzed.de
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============1470971547==
Content-Type: multipart/alternative;
	boundary="------------080906010209010609060500"

This is a multi-part message in MIME format.
--------------080906010209010609060500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi thanks all for your help,

I have two raid group, each raid group has two lun, the lun of the first 
raid group are for a linux cluster, the lun of the second raid group are 
for a windows cluster,

I installed navicli, this is the output you requested:

./navicli -h 192.168.2.11 getlun
Statistics logging is disabled.
 Certain fields are not printed if statistics
 logging is not enabled.
LOGICAL UNIT NUMBER 0
Prefetch size (blocks) =         0
Prefetch multiplier =            4
Segment size (blocks) =          0
Segment multiplier =             4
Maximum prefetch (blocks) =      4096
Prefetch Disable Size (blocks) = 4097
Prefetch idle count =            40

Variable length prefetching YES
Prefetched data retained    YES

Read cache configured according to
 specified parameters.

Total Hard Errors:          0
Total Soft Errors:          0
Total Queue Length:         0
Name                        ql
Minimum latency reads N/A

RAID Type:                  RAID5
RAIDGroup ID:               0
State:                      Bound
Stripe Crossing:            0
Element Size:               128
Current owner:              SP B
Offset:                     0
Auto-trespass:              DISABLED
Auto-assign:                DISABLED
Write cache:                ENABLED
Read cache:                 ENABLED
Idle Threshold:             0
Idle Delay Time:            20
Write Aside Size:           2048
Default Owner:              SP B
Rebuild Priority:           ASAP
Verify Priority:            ASAP
Prct Reads Forced Flushed:  0
Prct Writes Forced Flushed: 0
Prct Rebuilt:               100
Prct Bound:                 100
LUN Capacity(Megabytes):    512000
LUN Capacity(Blocks):       1048576000
UID:                        60:06:01:60:86:F0:16:00:BE:5A:CA:73:DB:8C:DA:11
Is Private:                 NO
Snapshots List:             None
MirrorView Name if any:     Not Mirrored

LOGICAL UNIT NUMBER 2
Prefetch size (blocks) =         0
Prefetch multiplier =            4
Segment size (blocks) =          0
Segment multiplier =             4
Maximum prefetch (blocks) =      4096
Prefetch Disable Size (blocks) = 4097
Prefetch idle count =            40

Variable length prefetching YES
Prefetched data retained    YES

Read cache configured according to
 specified parameters.

Total Hard Errors:          0
Total Soft Errors:          0
Total Queue Length:         0
Name                        win
Minimum latency reads N/A

RAID Type:                  RAID5
RAIDGroup ID:               1
State:                      Bound
Stripe Crossing:            0
Element Size:               128
Current owner:              SP A
Offset:                     0
Auto-trespass:              DISABLED
Auto-assign:                DISABLED
Write cache:                ENABLED
Read cache:                 ENABLED
Idle Threshold:             0
Idle Delay Time:            20
Write Aside Size:           2048
Default Owner:              SP A
Rebuild Priority:           ASAP
Verify Priority:            ASAP
Prct Reads Forced Flushed:  0
Prct Writes Forced Flushed: 0
Prct Rebuilt:               100
Prct Bound:                 100
LUN Capacity(Megabytes):    819200
LUN Capacity(Blocks):       1677721600
UID:                        60:06:01:60:86:F0:16:00:B6:2F:72:8B:DB:8C:DA:11
Is Private:                 NO
Snapshots List:             None
MirrorView Name if any:     Not Mirrored

LOGICAL UNIT NUMBER 3
Prefetch size (blocks) =         0
Prefetch multiplier =            4
Segment size (blocks) =          0
Segment multiplier =             4
Maximum prefetch (blocks) =      4096
Prefetch Disable Size (blocks) = 4097
Prefetch idle count =            40

Variable length prefetching YES
Prefetched data retained    YES

Read cache configured according to
 specified parameters.

Total Hard Errors:          0
Total Soft Errors:          0
Total Queue Length:         0
Name                        quorum
Minimum latency reads N/A

RAID Type:                  RAID5
RAIDGroup ID:               1
State:                      Bound
Stripe Crossing:            0
Element Size:               128
Current owner:              SP A
Offset:                     0
Auto-trespass:              DISABLED
Auto-assign:                DISABLED
Write cache:                ENABLED
Read cache:                 ENABLED
Idle Threshold:             0
Idle Delay Time:            20
Write Aside Size:           2048
Default Owner:              SP A
Rebuild Priority:           ASAP
Verify Priority:            ASAP
Prct Reads Forced Flushed:  0
Prct Writes Forced Flushed: 0
Prct Rebuilt:               100
Prct Bound:                 100
LUN Capacity(Megabytes):    5120
LUN Capacity(Blocks):       10485760
UID:                        60:06:01:60:86:F0:16:00:FC:D3:8B:91:DB:8C:DA:11
Is Private:                 NO
Snapshots List:             None
MirrorView Name if any:     Not Mirrored

LOGICAL UNIT NUMBER 1
Prefetch size (blocks) =         0
Prefetch multiplier =            4
Segment size (blocks) =          0
Segment multiplier =             4
Maximum prefetch (blocks) =      4096
Prefetch Disable Size (blocks) = 4097
Prefetch idle count =            40

Variable length prefetching YES
Prefetched data retained    YES

Read cache configured according to
 specified parameters.

Total Hard Errors:          0
Total Soft Errors:          0
Total Queue Length:         0
Name                        mail
Minimum latency reads N/A

RAID Type:                  RAID5
RAIDGroup ID:               0
State:                      Bound
Stripe Crossing:            0
Element Size:               128
Current owner:              SP B
Offset:                     0
Auto-trespass:              DISABLED
Auto-assign:                DISABLED
Write cache:                ENABLED
Read cache:                 ENABLED
Idle Threshold:             0
Idle Delay Time:            20
Write Aside Size:           2048
Default Owner:              SP B
Rebuild Priority:           ASAP
Verify Priority:            ASAP
Prct Reads Forced Flushed:  0
Prct Writes Forced Flushed: 0
Prct Rebuilt:               100
Prct Bound:                 100
LUN Capacity(Megabytes):    153600
LUN Capacity(Blocks):       314572800
UID:                        60:06:01:60:86:F0:16:00:E4:6F:56:7A:DB:8C:DA:11
Is Private:                 NO
Snapshots List:             None
MirrorView Name if any:     Not Mirrored

the output of scsi_id is the same:

server2 block # scsi_id -g -u -s /block/sdb
36006016086f01600e46f567adb8cda11
server2 block # scsi_id -g -u -s /block/sdc
36006016086f01600e46f567adb8cda11
server2 block # scsi_id -g -u -s /block/sdd
36006016086f01600e46f567adb8cda11
server2 block # scsi_id -g -u -s /block/sde
36006016086f01600e46f567adb8cda11
server2 block # scsi_id -g -u -s /block/sdf
36006016086f01600e46f567adb8cda11
server2 block # scsi_id -g -u -s /block/sdg
36006016086f01600e46f567adb8cda11
server2 block # scsi_id -g -u -s /block/sdh
36006016086f01600e46f567adb8cda11
server2 block # scsi_id -g -u -s /block/sdi
36006016086f01600e46f567adb8cda11

I can see and write only on the LUN called mail, I'm not able to see ql

thanks for your help,

regards
Nicola


Bernd Zeimetz ha scritto:
> Hi,
>
>   
>>> I'm trying to configure a new emc cx storage, I have the following:
>>>    
>>>
>>> I defined two lun on the storage however I'm able to see only one LUN
>>>
>>> multipath -l show the following:
>>>
>>> multipath -l
>>> mail (36006016086f01600e46f567adb8cda11)
>>> [size=150 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
>>> \_ round-robin 0 [active]
>>> \_ 1:0:1:0 sdd 8:48  [active][ready]
>>> \_ 1:0:1:1 sde 8:64  [active][ready]
>>> \_ 2:0:1:0 sdh 8:112 [active][ready]
>>> \_ 2:0:1:1 sdi 8:128 [active][ready]
>>> \_ round-robin 0 [enabled]
>>> \_ 2:0:0:0 sdf 8:80  [active][ready]
>>> \_ 1:0:0:0 sdb 8:16  [active][ready]
>>> \_ 1:0:0:1 sdc 8:32  [active][ready]
>>> \_ 2:0:0:1 sdg 8:96  [active][ready]
>>>
>>>    
>>>
>>>       
> did you probably just share one raid group via 2 LUNs? Then the output
> of multipath is imho indeed right. For me it shows the setup you've
> described - one raidgroup, shared via 2 LUNs (usually one per default on
> SP A, one on SP B, attached via 2 paths per SP to a switch, accessed
> from your server via 2 HBAs.
> If you have access to the Navisphere cli tool - please post the output of
>
> ./navicli -h IP_OF_ONE_OF_YOUR_SPs getlun
>
> I think this will show that my hint is right.
> Imho you want to create a second raid group and share it via 2 LUNs, too.
>
>   
>> http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments
>>  
>>
>>     
> I hope there's nothing wring with the stuff I've written about the
> EMC/CX in there, if you find anything please let me know - I don't look
> in there often.
>
>
> Hope that helps,
>
> best regards
>
>
> Bernd
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>   


--------------080906010209010609060500
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Hi thanks all for your help,<br>
<br>
I have two raid group, each raid group has two lun, the lun of the
first raid group are for a linux cluster, the lun of the second raid
group are for a windows cluster,<br>
<br>
I installed navicli, this is the output you requested:<br>
<br>
./navicli -h 192.168.2.11 getlun<br>
Statistics logging is disabled.<br>
&nbsp;Certain fields are not printed if statistics<br>
&nbsp;logging is not enabled.<br>
LOGICAL UNIT NUMBER 0<br>
Prefetch size (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Prefetch multiplier =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>
Segment size (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Segment multiplier =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>
Maximum prefetch (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4096<br>
Prefetch Disable Size (blocks) = 4097<br>
Prefetch idle count =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 40<br>
<br>
Variable length prefetching YES<br>
Prefetched data retained&nbsp;&nbsp;&nbsp; YES<br>
<br>
Read cache configured according to<br>
&nbsp;specified parameters.<br>
<br>
Total Hard Errors:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Total Soft Errors:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Total Queue Length:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ql<br>
Minimum latency reads N/A<br>
<br>
RAID Type:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RAID5<br>
RAIDGroup ID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bound<br>
Stripe Crossing:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Element Size:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 128<br>
Current owner:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SP B<br>
Offset:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Auto-trespass:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DISABLED<br>
Auto-assign:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DISABLED<br>
Write cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ENABLED<br>
Read cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ENABLED<br>
Idle Threshold:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Idle Delay Time:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20<br>
Write Aside Size:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2048<br>
Default Owner:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SP B<br>
Rebuild Priority:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASAP<br>
Verify Priority:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASAP<br>
Prct Reads Forced Flushed:&nbsp; 0<br>
Prct Writes Forced Flushed: 0<br>
Prct Rebuilt:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100<br>
Prct Bound:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100<br>
LUN Capacity(Megabytes):&nbsp;&nbsp;&nbsp; 512000<br>
LUN Capacity(Blocks):&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1048576000<br>
UID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
60:06:01:60:86:F0:16:00:BE:5A:CA:73:DB:8C:DA:11<br>
Is Private:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NO<br>
Snapshots List:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br>
MirrorView Name if any:&nbsp;&nbsp;&nbsp;&nbsp; Not Mirrored<br>
<br>
LOGICAL UNIT NUMBER 2<br>
Prefetch size (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Prefetch multiplier =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>
Segment size (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Segment multiplier =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>
Maximum prefetch (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4096<br>
Prefetch Disable Size (blocks) = 4097<br>
Prefetch idle count =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 40<br>
<br>
Variable length prefetching YES<br>
Prefetched data retained&nbsp;&nbsp;&nbsp; YES<br>
<br>
Read cache configured according to<br>
&nbsp;specified parameters.<br>
<br>
Total Hard Errors:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Total Soft Errors:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Total Queue Length:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; win<br>
Minimum latency reads N/A<br>
<br>
RAID Type:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RAID5<br>
RAIDGroup ID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>
State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bound<br>
Stripe Crossing:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Element Size:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 128<br>
Current owner:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SP A<br>
Offset:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Auto-trespass:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DISABLED<br>
Auto-assign:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DISABLED<br>
Write cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ENABLED<br>
Read cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ENABLED<br>
Idle Threshold:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Idle Delay Time:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20<br>
Write Aside Size:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2048<br>
Default Owner:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SP A<br>
Rebuild Priority:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASAP<br>
Verify Priority:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASAP<br>
Prct Reads Forced Flushed:&nbsp; 0<br>
Prct Writes Forced Flushed: 0<br>
Prct Rebuilt:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100<br>
Prct Bound:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100<br>
LUN Capacity(Megabytes):&nbsp;&nbsp;&nbsp; 819200<br>
LUN Capacity(Blocks):&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1677721600<br>
UID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
60:06:01:60:86:F0:16:00:B6:2F:72:8B:DB:8C:DA:11<br>
Is Private:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NO<br>
Snapshots List:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br>
MirrorView Name if any:&nbsp;&nbsp;&nbsp;&nbsp; Not Mirrored<br>
<br>
LOGICAL UNIT NUMBER 3<br>
Prefetch size (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Prefetch multiplier =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>
Segment size (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Segment multiplier =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>
Maximum prefetch (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4096<br>
Prefetch Disable Size (blocks) = 4097<br>
Prefetch idle count =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 40<br>
<br>
Variable length prefetching YES<br>
Prefetched data retained&nbsp;&nbsp;&nbsp; YES<br>
<br>
Read cache configured according to<br>
&nbsp;specified parameters.<br>
<br>
Total Hard Errors:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Total Soft Errors:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Total Queue Length:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; quorum<br>
Minimum latency reads N/A<br>
<br>
RAID Type:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RAID5<br>
RAIDGroup ID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<br>
State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bound<br>
Stripe Crossing:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Element Size:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 128<br>
Current owner:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SP A<br>
Offset:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Auto-trespass:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DISABLED<br>
Auto-assign:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DISABLED<br>
Write cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ENABLED<br>
Read cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ENABLED<br>
Idle Threshold:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Idle Delay Time:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20<br>
Write Aside Size:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2048<br>
Default Owner:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SP A<br>
Rebuild Priority:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASAP<br>
Verify Priority:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASAP<br>
Prct Reads Forced Flushed:&nbsp; 0<br>
Prct Writes Forced Flushed: 0<br>
Prct Rebuilt:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100<br>
Prct Bound:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100<br>
LUN Capacity(Megabytes):&nbsp;&nbsp;&nbsp; 5120<br>
LUN Capacity(Blocks):&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10485760<br>
UID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
60:06:01:60:86:F0:16:00:FC:D3:8B:91:DB:8C:DA:11<br>
Is Private:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NO<br>
Snapshots List:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br>
MirrorView Name if any:&nbsp;&nbsp;&nbsp;&nbsp; Not Mirrored<br>
<br>
LOGICAL UNIT NUMBER 1<br>
Prefetch size (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Prefetch multiplier =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>
Segment size (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Segment multiplier =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4<br>
Maximum prefetch (blocks) =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4096<br>
Prefetch Disable Size (blocks) = 4097<br>
Prefetch idle count =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 40<br>
<br>
Variable length prefetching YES<br>
Prefetched data retained&nbsp;&nbsp;&nbsp; YES<br>
<br>
Read cache configured according to<br>
&nbsp;specified parameters.<br>
<br>
Total Hard Errors:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Total Soft Errors:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Total Queue Length:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mail<br>
Minimum latency reads N/A<br>
<br>
RAID Type:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RAID5<br>
RAIDGroup ID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Bound<br>
Stripe Crossing:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Element Size:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 128<br>
Current owner:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SP B<br>
Offset:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Auto-trespass:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DISABLED<br>
Auto-assign:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DISABLED<br>
Write cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ENABLED<br>
Read cache:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ENABLED<br>
Idle Threshold:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<br>
Idle Delay Time:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20<br>
Write Aside Size:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2048<br>
Default Owner:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SP B<br>
Rebuild Priority:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASAP<br>
Verify Priority:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ASAP<br>
Prct Reads Forced Flushed:&nbsp; 0<br>
Prct Writes Forced Flushed: 0<br>
Prct Rebuilt:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100<br>
Prct Bound:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 100<br>
LUN Capacity(Megabytes):&nbsp;&nbsp;&nbsp; 153600<br>
LUN Capacity(Blocks):&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 314572800<br>
UID:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
60:06:01:60:86:F0:16:00:E4:6F:56:7A:DB:8C:DA:11<br>
Is Private:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NO<br>
Snapshots List:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; None<br>
MirrorView Name if any:&nbsp;&nbsp;&nbsp;&nbsp; Not Mirrored<br>
<br>
the output of scsi_id is the same:<br>
<br>
server2 block # scsi_id -g -u -s /block/sdb<br>
36006016086f01600e46f567adb8cda11<br>
server2 block # scsi_id -g -u -s /block/sdc<br>
36006016086f01600e46f567adb8cda11<br>
server2 block # scsi_id -g -u -s /block/sdd<br>
36006016086f01600e46f567adb8cda11<br>
server2 block # scsi_id -g -u -s /block/sde<br>
36006016086f01600e46f567adb8cda11<br>
server2 block # scsi_id -g -u -s /block/sdf<br>
36006016086f01600e46f567adb8cda11<br>
server2 block # scsi_id -g -u -s /block/sdg<br>
36006016086f01600e46f567adb8cda11<br>
server2 block # scsi_id -g -u -s /block/sdh<br>
36006016086f01600e46f567adb8cda11<br>
server2 block # scsi_id -g -u -s /block/sdi<br>
36006016086f01600e46f567adb8cda11<br>
<br>
I can see and write only on the LUN called mail, I'm not able to see ql<br>
<br>
thanks for your help,<br>
<br>
regards<br>
Nicola<br>
<br>
<br>
Bernd Zeimetz ha scritto:
<blockquote cite="mid43D6D16D.1060909@bzed.de" type="cite">
  <pre wrap="">Hi,

  </pre>
  <blockquote type="cite">
    <blockquote type="cite">
      <pre wrap="">I'm trying to configure a new emc cx storage, I have the following:
   

I defined two lun on the storage however I'm able to see only one LUN

multipath -l show the following:

multipath -l
mail (36006016086f01600e46f567adb8cda11)
[size=150 GB][features="1 queue_if_no_path"][hwhandler="1 emc"]
\_ round-robin 0 [active]
\_ 1:0:1:0 sdd 8:48  [active][ready]
\_ 1:0:1:1 sde 8:64  [active][ready]
\_ 2:0:1:0 sdh 8:112 [active][ready]
\_ 2:0:1:1 sdi 8:128 [active][ready]
\_ round-robin 0 [enabled]
\_ 2:0:0:0 sdf 8:80  [active][ready]
\_ 1:0:0:0 sdb 8:16  [active][ready]
\_ 1:0:0:1 sdc 8:32  [active][ready]
\_ 2:0:0:1 sdg 8:96  [active][ready]

   

      </pre>
    </blockquote>
  </blockquote>
  <pre wrap=""><!---->did you probably just share one raid group via 2 LUNs? Then the output
of multipath is imho indeed right. For me it shows the setup you've
described - one raidgroup, shared via 2 LUNs (usually one per default on
SP A, one on SP B, attached via 2 paths per SP to a switch, accessed
from your server via 2 HBAs.
If you have access to the Navisphere cli tool - please post the output of

./navicli -h IP_OF_ONE_OF_YOUR_SPs getlun

I think this will show that my hint is right.
Imho you want to create a second raid group and share it via 2 LUNs, too.

  </pre>
  <blockquote type="cite">
    <pre wrap=""><a class="moz-txt-link-freetext" href="http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments">http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments</a>
 

    </pre>
  </blockquote>
  <pre wrap=""><!---->I hope there's nothing wring with the stuff I've written about the
EMC/CX in there, if you find anything please let me know - I don't look
in there often.


Hope that helps,

best regards


Bernd

--
dm-devel mailing list
<a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a>

  </pre>
</blockquote>
<br>
</body>
</html>

--------------080906010209010609060500--


--===============1470971547==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1470971547==--
