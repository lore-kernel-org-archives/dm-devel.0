From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Thu, 09 Apr 2009 06:48:10 -0400
Message-ID: <49DDD26A.2090901@redhat.com>
References: <20090324143034.GW27476@kernel.dk>
	<Pine.LNX.4.64.0903241033070.4088@hs20-bc2-1.build.redhat.com>
	<20090324150517.GX27476@kernel.dk>
	<Pine.LNX.4.64.0903251106520.27750@hs20-bc2-1.build.redhat.com>
	<20090325152751.GV27476@kernel.dk>
	<Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>
	<20090326084205.GG27476@kernel.dk>
	<Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>
	<20090331104933.GJ5178@kernel.dk>
	<Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>
	<20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com>
	<Pine.LNX.4.64.0904080844550.28196@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904080844550.28196@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, ak@linux.intel.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Mikulas Patocka wrote:
>> And I will restate that back at EMC we tested the original barriers (with
>> reiserfs mostly, a bit on ext3 and ext2) and saw significant reduction in file
>> system integrity issues after power loss.
>>     
>
> You saw that barrier-enabled filesystem was worse than the same filesystem 
> without barriers? And what kind of issues were that? Disks writing damaged 
> sectors if powered-off in the middle of the writes? Or data corruptions 
> due to bugs in ReiserFS?
>   

No - I was not being clear. We saw a reduction in issues which is a 
confusing way to say that it was significantly better with barriers 
enabled, for both ext3 & reiserfs.

>   
>> The vantage point I had at EMC while testing and deploying the original
>> barrier work done by Jens and Chris was pretty unique - full ability to do
>> root cause failures of any component when really needed, a huge installed base
>> which could send information home on a regular basis about crashes/fsck
>> instances/etc and the ability (with customer permission) to dial into any box
>> and diagnose issues remotely. Not to mention access to drive vendors to
>> pressure them to make the flushes more robust. The application was also able
>> to validate that all acknowledged writes were consistent.
>>
>> Barriers do work as we have them, but as others have mentioned, it is not a
>> "free" win - fsync will actually move your data safely out to persistent
>> storage for a huge percentage of real users (including every ATA/S-ATA and SAS
>> drive I was able to test).  The file systems I monitored in production use
>> without barriers were much less reliable.
>>     
>
> With write cache or without write cache?
>   
Write cache enabled.

Barriers are off when write cache is disabled - we probe the drives 
write cache and enable barriers at mount time if and only if the 
barriers are on.
> With cache and without barriers the system is violating the specification. 
> There just could be data corruption ... and it will eventually happen.
>
> If you got corruption without cache and without barriers, there's a bug 
> and it needs to be investigated.
>
>   
>> As others have noted, some storage does not need barriers or flushed (high end
>> arrays, drives with no volatile write cache) and some need it but stink (low
>> cost USB flash sticks?) so warning is a good thing to do...
>>
>> ric
>>     
>
> Mikulas
>   
