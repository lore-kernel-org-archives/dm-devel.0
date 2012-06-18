From: Christian May <cmay@linux.vnet.ibm.com>
Subject: Re: RHEL6.2: path failures during good path I/O
Date: Mon, 18 Jun 2012 13:02:03 +0200
Message-ID: <4FDF0AAB.7000001@linux.vnet.ibm.com>
References: <4FD87335.3040300@linux.vnet.ibm.com>
	<20120613131613.GA18293@redhat.com>	<4FDA3840.9030307@linux.vnet.ibm.com>
	<20120614211928.GA30587@redhat.com>
	<4FDEFCFB.70202@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4FDEFCFB.70202@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

So, I've started on my RHEL6.1 system filesystem I/O against 5 multipath 
devices. Each multipath device contains 4 partition - two of them were 
mounted and used for fs-I/O. The exerciser was running for appr. 2 hours 
without a single path failure message. Then I'v started block I/O 
against the other 5 multipath devices.
Pretty soon the first path failure was reported:

Jun 18 12:51:18 jabulan-lp5 root: block IO starts here
Jun 18 12:51:34 jabulan-lp5 root: ./blocktest.pl *************** 
kaupie:./blocktest.pl test starting ***************
Jun 18 12:51:34 jabulan-lp5 root: ./blocktest.pl *************** 
Starting pass 1 ***************
Jun 18 12:51:34 jabulan-lp5 root: ./blocktest.pl *************** 
function function_512k_RI starting ***************
Jun 18 12:52:12 jabulan-lp5 multipathd: mpathk: sde - directio checker 
reports path is down
Jun 18 12:52:12 jabulan-lp5 multipathd: checker failed path 8:64 in map 
mpathk
Jun 18 12:52:12 jabulan-lp5 multipathd: mpathk: remaining active paths: 1
Jun 18 12:52:12 jabulan-lp5 kernel: device-mapper: multipath: Failing 
path 8:64.
Jun 18 12:52:18 jabulan-lp5 multipathd: mpathk: sde - directio checker 
reports path is down
Jun 18 12:52:23 jabulan-lp5 multipathd: mpathk: sde - directio checker 
reports path is up
Jun 18 12:52:23 jabulan-lp5 multipathd: 8:64: reinstated
Jun 18 12:52:23 jabulan-lp5 multipathd: mpathk: remaining active paths: 2
Jun 18 12:53:53 jabulan-lp5 multipathd: mpathk: sde - directio checker 
reports path is down
Jun 18 12:53:53 jabulan-lp5 multipathd: checker failed path 8:64 in map 
mpathk
Jun 18 12:53:53 jabulan-lp5 multipathd: mpathk: remaining active paths: 1
Jun 18 12:53:53 jabulan-lp5 kernel: device-mapper: multipath: Failing 
path 8:64.
Jun 18 12:53:58 jabulan-lp5 multipathd: mpathk: sde - directio checker 
reports path is down
Jun 18 12:54:03 jabulan-lp5 multipathd: mpathk: sde - directio checker 
reports path is up
Jun 18 12:54:03 jabulan-lp5 multipathd: 8:64: reinstated
Jun 18 12:54:03 jabulan-lp5 multipathd: mpathk: remaining active paths: 2
Jun 18 12:55:04 jabulan-lp5 multipathd: mpathi: sdj - directio checker 
reports path is down
Jun 18 12:55:04 jabulan-lp5 multipathd: checker failed path 8:144 in map 
mpathi
Jun 18 12:55:04 jabulan-lp5 multipathd: mpathi: remaining active paths: 1
Jun 18 12:55:04 jabulan-lp5 kernel: device-mapper: multipath: Failing 
path 8:144.


No I/O error messages were logged...following the dmesg output after 
filesystem creation (preparing the partitions for fs-I/O) until 
block-I/O got started:

EXT3-fs (dm-39): using internal journal
EXT3-fs (dm-39): mounted filesystem with ordered data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-25): using internal journal
EXT3-fs (dm-25): mounted filesystem with ordered data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-22): using internal journal
EXT3-fs (dm-22): mounted filesystem with ordered data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-46): using internal journal
EXT3-fs (dm-46): mounted filesystem with ordered data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-38): using internal journal
EXT3-fs (dm-38): mounted filesystem with ordered data mode
device-mapper: multipath: Failing path 8:64.
device-mapper: multipath: Failing path 8:64.
device-mapper: multipath: Failing path 8:144.
device-mapper: multipath: Failing path 8:32.
device-mapper: multipath: Failing path 8:32.
device-mapper: multipath: Failing path 8:144.
[root@jabulan-lp5 ~]#


Really strange...



Am 18.06.2012 12:03, schrieb Christian May:
> Sorry, I did a mistake when testing with RHEL6.1....the multipath 
> daemon was stopped.
> So, also with RHEL6.1. I've noticed path failures. I'm trying to do 
> some more testing - maybe it's related to
> I/O workload. For my regular tests I'm attaching 10 SCSI LUns to the 
> host system via two pathes.
> On each multipath device 4 partitions will be created. Five multipath 
> devices are going to be used for filesystem I/O, the remaining five 
> for block I/O.
> Currently I have just fs-I/O started and so far - 1h - no path 
> failures occured. I will start block I/O later....
>
> My guess why it could be device-mapper related is based on SLES11SP1 
> bugzilla 62249 multipath-tools: multipath device path failure without 
> error injection.
>
>
>
> Am 14.06.2012 23:19, schrieb Mike Snitzer:
>> On Thu, Jun 14 2012 at  3:15pm -0400,
>> Christian May<cmay@linux.vnet.ibm.com>  wrote:
>>
>>> I couldn't recreate the path failures on the exact same test setup
>>> with RHEL6.1.
>>>
>>> Something must have been changed in the device-mapper package!?
>> It is good to know 6.1 works and 6.2 doesn't for you.  But I'm not
>> understanding why you're thinking it is a device-mapper-multipath
>> issue (not kernel issue).
>>
>> You could do a couple things:
>> 1) run the RHEL6.2 kernel on a RHEL6.1 install
>> 2) install RHEL6.1 device-mapper-multipath package on RHEL6.2 install
>>
>> If both work then it implicates the RHEL6.2 device-mapper-multipath
>> package.
>>
>> But all being said, please just file a BZ at bugzilla.redhat.com
>>
>
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
