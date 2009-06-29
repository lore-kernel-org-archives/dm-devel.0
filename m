From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC] IO scheduler based io controller (V5)
Date: Mon, 29 Jun 2009 13:23:09 -0400
Message-ID: <20090629172309.GB4622@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<4A48E601.2050203@vlnb.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A48E601.2050203@vlnb.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 29, 2009 at 08:04:17PM +0400, Vladislav Bolkhovitin wrote:
> Hi,
>
> Vivek Goyal, on 06/20/2009 12:37 AM wrote:
>> Hi All,
>>
>> Here is the V5 of the IO controller patches generated on top of 2.6.30.
>>
>> Previous versions of the patches was posted here.
>>
>> (V1) http://lkml.org/lkml/2009/3/11/486
>> (V2) http://lkml.org/lkml/2009/5/5/275
>> (V3) http://lkml.org/lkml/2009/5/26/472
>> (V4) http://lkml.org/lkml/2009/6/8/580
>>
>> This patchset is still work in progress but I want to keep on getting the
>> snapshot of my tree out at regular intervals to get the feedback hence V5.
>
> [..]
>
>> Testing
>> =======
>>
>> I have been able to do only very basic testing of reads and writes.
>>
>> Test1 (Fairness for synchronous reads)
>> ======================================
>> - Two dd in two cgroups with cgrop weights 1000 and 500. Ran two "dd" in those
>>   cgroups (With CFQ scheduler and /sys/block/<device>/queue/fairness = 1)
>>
>> dd if=/mnt/$BLOCKDEV/zerofile1 of=/dev/null &
>> dd if=/mnt/$BLOCKDEV/zerofile2 of=/dev/null &
>>
>> 234179072 bytes (234 MB) copied, 3.9065 s, 59.9 MB/s
>> 234179072 bytes (234 MB) copied, 5.19232 s, 45.1 MB/s
>
> Sorry, but the above isn't a correct way to test proportional fairness  
> for synchronous reads. You need throughput only when *both* dd's  
> running, don't you?
>

Hi Vladislav,

Actually the focus here is following two lines.

group1 time=8 16 2471 group1 sectors=8 16 457840
group2 time=8 16 1220 group2 sectors=8 16 225736

I have pasted the output of dd completion output but as you pointed out
it does not mean much as higher weight dd finishes first and after that
second dd will get 100% of disk.

What I have done is that launch two dd jobs. The moment first dd finishes,
my scripts go and read up "io.disk_time" and "io.disk_sectors" files in two
cgroups.

disk_time keeps track of how much disk time a cgroup has got on a
particular disk and disk_sector keeps track of how many sector of IO a
cgroup has done on a particular disk.

Please notice above that once first dd (higher weight dd) finished, at
that point group1 got 2471 ms of disk time and group2 got 1220 ms of disk
time.

Similarly, by the time first dd finished, group1 has transferred 457840
sectors and group 2 has transferred 225736 sectors.

Here disk time of group1 is almost double of disk time received by group2.
(group1 weight=1000 and group2 weight=500). Currently like CFQ, we provide
fairness in terms of disk time.

So I think test should be fine. Just that output of "dd" is confusing and
probably I did not explain the testing procedure well. In next posting
will make the procedure more clear.

> Considering both transfers started simultaneously (which isn't obvious  
> too) in the way you test the throughput value only for the first  
> finished dd is correct, because after it finished, the second dd started  
> transferring data *alone*, hence the result throughput value for it got  
> partially for simultaneous, partially for alone reads, i.e. screwed.
>
> I'd suggest you instead test as 2 runs of:
>
> 1. while true; do dd if=/mnt/$BLOCKDEV/zerofile1 of=/dev/null; done
>    dd if=/mnt/$BLOCKDEV/zerofile2 of=/dev/null
>
> 2. while true; do dd if=/mnt/$BLOCKDEV/zerofile2 of=/dev/null; done
>    dd if=/mnt/$BLOCKDEV/zerofile1 of=/dev/null
>
> and take results from the standalone dd's.
>
> Vlad
