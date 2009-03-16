From: "dushyanth.h@directi.com" <dushyanth.h@directi.com>
Subject: Re: Multipath failover issues
Date: Tue, 17 Mar 2009 02:33:53 +0530
Message-ID: <49BEBEB9.7020707@directi.com>
References: <49BE7C9C.8020100@directi.com>
	<1237226357.309.6.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237226357.309.6.camel@chandra-ubuntu>
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

Hi,

>> device-mapper: multipath: Failing path 8:32.
> 
> 8:32 has failed here.

>> sd 2:0:0:0: SCSI error: return code = 0x00020000
> 
> error code 20000 mean the BUS is busy.
> 
>> end_request: I/O error, dev sdd, sector 1976776672
>> device-mapper: multipath: Failing path 8:48.
> 
> and 8:48 failed because of that.

> Do you know which one was supposed to fail when the RAID controller
> failed ? (my guess is it is 8:32).

The alert on the storage device was (sorry for not including this earlier)

257 Critical 2009-03-11 10:38:43 ALERT:Redundant Controller Failure
Detected (Slot B)

I also found additional logs from /var/log/messages which i did not 
check earlier.

Mar 11 10:32:46 multipathd: sdc: readsector0 checker reports path is down
Mar 11 10:32:46 multipathd: checker failed path 8:32 in map infortrend01
Mar 11 10:32:46 multipathd: infortrend01: remaining active paths: 1
Mar 11 10:32:46 multipathd: sdd: readsector0 checker reports path is down
Mar 11 10:32:46 multipathd: checker failed path 8:48 in map infortrend01
Mar 11 10:32:46 multipathd: infortrend01: remaining active paths: 0
Mar 11 10:32:46 multipathd: dm-0: add map (uevent)
Mar 11 10:32:46 multipathd: dm-0: devmap already registered
Mar 11 10:32:46 multipathd: dm-0: add map (uevent)
Mar 11 10:32:47 multipathd: dm-0: devmap already registered
Mar 11 10:32:47 multipathd: sdd: readsector0 checker reports path is down

So, it looks like 8:32 was the path which had the failed controller and 
during the switch over multipath must have detected 8:48 as busy? if 
this is right, then it must be due to the infortrend device itself.

> looks like for whatever reason the other SCSI bus became busy.

>> sd 2:0:0:0: SCSI error: return code = 0x00020000
>> end_request: I/O error, dev sdd, sector 1967432880
>> sd 2:0:0:0: SCSI error: return code = 0x00020000
>> end_request: I/O error, dev sdd, sector 161647296

Iam assuming it must have been busy for a few secs during the switch 
over and the multipath config doesn't wait enough for the switchover to 
work.

Any advice on the below values ?

 > Additionaly, I have looked at the mailing list archives & annotated conf
 > files and found two options a) failback and b) no_path_retry. What would
 > be the best recommended values for these on a dual controller setup like
 > mine ?
 >
 > It would also be helpful if someone could share infotrend specific
 > settings multipath settings.

TIA
Dushyanth
