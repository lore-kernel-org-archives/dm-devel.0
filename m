From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Multipath failover issues
Date: Mon, 16 Mar 2009 15:40:53 -0700
Message-ID: <1237243253.309.13.camel@chandra-ubuntu>
References: <49BE7C9C.8020100@directi.com>
	<1237226357.309.6.camel@chandra-ubuntu> <49BEBEB9.7020707@directi.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49BEBEB9.7020707@directi.com>
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


On Tue, 2009-03-17 at 02:33 +0530, dushyanth.h@directi.com wrote:
> Hi,
> 
> >> device-mapper: multipath: Failing path 8:32.
> > 
> > 8:32 has failed here.
> 
> >> sd 2:0:0:0: SCSI error: return code = 0x00020000
> > 
> > error code 20000 mean the BUS is busy.
> > 
> >> end_request: I/O error, dev sdd, sector 1976776672
> >> device-mapper: multipath: Failing path 8:48.
> > 
> > and 8:48 failed because of that.
> 
> > Do you know which one was supposed to fail when the RAID controller
> > failed ? (my guess is it is 8:32).
> 
> The alert on the storage device was (sorry for not including this earlier)
> 
> 257 Critical 2009-03-11 10:38:43 ALERT:Redundant Controller Failure
> Detected (Slot B)
> 
> I also found additional logs from /var/log/messages which i did not 
> check earlier.
> 
> Mar 11 10:32:46 multipathd: sdc: readsector0 checker reports path is down
> Mar 11 10:32:46 multipathd: checker failed path 8:32 in map infortrend01
> Mar 11 10:32:46 multipathd: infortrend01: remaining active paths: 1
> Mar 11 10:32:46 multipathd: sdd: readsector0 checker reports path is down
> Mar 11 10:32:46 multipathd: checker failed path 8:48 in map infortrend01

Does this timing correspond to when you turned off the controller ?


> Mar 11 10:32:46 multipathd: infortrend01: remaining active paths: 0
> Mar 11 10:32:46 multipathd: dm-0: add map (uevent)
> Mar 11 10:32:46 multipathd: dm-0: devmap already registered
> Mar 11 10:32:46 multipathd: dm-0: add map (uevent)
> Mar 11 10:32:47 multipathd: dm-0: devmap already registered
> Mar 11 10:32:47 multipathd: sdd: readsector0 checker reports path is down
> 
> So, it looks like 8:32 was the path which had the failed controller and 
> during the switch over multipath must have detected 8:48 as busy? if 
> this is right, then it must be due to the infortrend device itself.
> 
> > looks like for whatever reason the other SCSI bus became busy.
> 
> >> sd 2:0:0:0: SCSI error: return code = 0x00020000
> >> end_request: I/O error, dev sdd, sector 1967432880
> >> sd 2:0:0:0: SCSI error: return code = 0x00020000
> >> end_request: I/O error, dev sdd, sector 161647296
> 
> Iam assuming it must have been busy for a few secs during the switch 
> over and the multipath config doesn't wait enough for the switchover to 
> work.
> 

Answer to your previous question would help here :)

Set no_path_retry to "queue", which would queue the I/Os when "all" the
paths fail.

If the behavior seen above was caused by the storage and will be
rectified in an acceptable (to the user) time, then this parameter
setting would solve your problem.

BTW, have you seen the I/O successfully been sent to the lun (both paths
- you can use iostat to check it) before you failed the controller ? (I
am trying to see if your config settings are proper).

> Any advice on the below values ?
> 
>  > Additionaly, I have looked at the mailing list archives & annotated conf
>  > files and found two options a) failback and b) no_path_retry. What would

Failback would be useful only when you have different path groups. In a
multibus setup like yours it is of no value.

>  > be the best recommended values for these on a dual controller setup like
>  > mine ?
>  >
>  > It would also be helpful if someone could share infotrend specific
>  > settings multipath settings.
> 
> TIA
> Dushyanth
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
