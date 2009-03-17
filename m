From: Dushyanth Harinath <dushyanth.h@directi.com>
Subject: Re: Multipath failover issues
Date: Tue, 17 Mar 2009 18:00:00 +0530
Message-ID: <49BF97C8.1030406@directi.com>
References: <49BE7C9C.8020100@directi.com>	<1237226357.309.6.camel@chandra-ubuntu>
	<49BEBEB9.7020707@directi.com>
	<1237243253.309.13.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237243253.309.13.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

>> 257 Critical 2009-03-11 10:38:43 ALERT:Redundant Controller Failure
>> Detected (Slot B)
>>
>> I also found additional logs from /var/log/messages which i did not 
>> check earlier.
>>
>> Mar 11 10:32:46 multipathd: sdc: readsector0 checker reports path is down
>> Mar 11 10:32:46 multipathd: checker failed path 8:32 in map infortrend01
>> Mar 11 10:32:46 multipathd: infortrend01: remaining active paths: 1
>> Mar 11 10:32:46 multipathd: sdd: readsector0 checker reports path is down
>> Mar 11 10:32:46 multipathd: checker failed path 8:48 in map infortrend01
> 
> Does this timing correspond to when you turned off the controller ?

This is when the controller failed. The controller shutdown happened 
much later.

>> Iam assuming it must have been busy for a few secs during the switch 
>> over and the multipath config doesn't wait enough for the switchover to 
>> work.
> 
> Answer to your previous question would help here :)
> 
> Set no_path_retry to "queue", which would queue the I/Os when "all" the
> paths fail.

Iam not sure if i can do this as well. Aren't we creating an illusion 
that the storage subsystem is fine and queuing requests when actually 
the subsystem is gone ? What actually is done for queuing and there must 
be some limits for the queue as well right ?

> If the behavior seen above was caused by the storage and will be
> rectified in an acceptable (to the user) time, then this parameter
> setting would solve your problem.

Iam checking this with infortrend.

> BTW, have you seen the I/O successfully been sent to the lun (both paths
> - you can use iostat to check it) before you failed the controller ? (I
> am trying to see if your config settings are proper).

Iam doing a post mortem of the redundant controller failure here :). I 
dug out what was done after the controller failure.

* Primary Controller failed and failover to secondary did not work
* Multipath failed both paths and ext3 went read only
* Postgres crashed
* When they logged in and ran (multipath -v2 -ll), they saw both paths 
active - I cannot find any multipath log entries which shows paths 
reinstated until 11:50 - which was after controller shutdown and power 
cycle.
* The filesystem was mounted again (without fsck) and database started 
(This answers your question abt IO to the LUNs i think)
* Postgres recovered and was shutdown immediately and /data unmounted.
* After this the controllers on the infotrend was shutdown and the 
device power cycled.

PS : Iam digging up the entire multipath logs instead of posting 
snippets here - will add to pastebin and send the link over

TIA
Dushyanth
