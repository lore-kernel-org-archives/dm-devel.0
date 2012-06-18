From: Christian May <cmay@linux.vnet.ibm.com>
Subject: Re: RHEL6.2: path failures during good path I/O
Date: Mon, 18 Jun 2012 12:03:39 +0200
Message-ID: <4FDEFCFB.70202@linux.vnet.ibm.com>
References: <4FD87335.3040300@linux.vnet.ibm.com>
	<20120613131613.GA18293@redhat.com>
	<4FDA3840.9030307@linux.vnet.ibm.com>
	<20120614211928.GA30587@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120614211928.GA30587@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Sorry, I did a mistake when testing with RHEL6.1....the multipath daemon 
was stopped.
So, also with RHEL6.1. I've noticed path failures. I'm trying to do some 
more testing - maybe it's related to
I/O workload. For my regular tests I'm attaching 10 SCSI LUns to the 
host system via two pathes.
On each multipath device 4 partitions will be created. Five multipath 
devices are going to be used for filesystem I/O, the remaining five for 
block I/O.
Currently I have just fs-I/O started and so far - 1h - no path failures 
occured. I will start block I/O later....

My guess why it could be device-mapper related is based on SLES11SP1 
bugzilla 62249 multipath-tools: multipath device path failure without 
error injection.



Am 14.06.2012 23:19, schrieb Mike Snitzer:
> On Thu, Jun 14 2012 at  3:15pm -0400,
> Christian May<cmay@linux.vnet.ibm.com>  wrote:
>
>> I couldn't recreate the path failures on the exact same test setup
>> with RHEL6.1.
>>
>> Something must have been changed in the device-mapper package!?
> It is good to know 6.1 works and 6.2 doesn't for you.  But I'm not
> understanding why you're thinking it is a device-mapper-multipath
> issue (not kernel issue).
>
> You could do a couple things:
> 1) run the RHEL6.2 kernel on a RHEL6.1 install
> 2) install RHEL6.1 device-mapper-multipath package on RHEL6.2 install
>
> If both work then it implicates the RHEL6.2 device-mapper-multipath
> package.
>
> But all being said, please just file a BZ at bugzilla.redhat.com
>
