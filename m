From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: BUG in dm/dm-mirror module?
Date: Mon, 13 Aug 2007 10:18:09 -0500
Message-ID: <45517CCC-7B68-4B0F-92EC-04F4E81CDA0E@redhat.com>
References: <20070811010853.GA9952@us.ibm.com> <46BD78B7.3080200@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46BD78B7.3080200@redhat.com>
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


On Aug 11, 2007, at 3:52 AM, Milan Broz wrote:

> malahal@us.ibm.com wrote:
>> Hi, I am trying to create a mirrored disk log. I have four block
>> devices, two for the log (which is a mirror!) and two for the actual
>> mirror device.  But I can't use the mirror device at all. It just  
>> hangs
>> for any read/write. Here are the details of dmsetup calls. I am using
>> RHEL5 (2.6.18-8.el5). Looks like a mirror module bug and I appreciate
>> any help.
>>
>> dev1="/dev/sda1"
>> dev2="/dev/sdb1"
>> dev3="/dev/sdc1"
>> dev4="/dev/sdd1"
>> echo "0 8192 mirror core 1 512 2 $dev1 0 $dev2 0" | dmsetup create  
>> log
>> echo "0 24576 mirror disk 2 /dev/mapper/log 512 2 $dev3 0 $dev4 0"  
>> | dmsetup create mirror
>
> Hi,
>
> yes, there is known problem with one kmirrord thread and using  
> mirrored log.
> (i.e. mirror over mirror)
>
> For problem description see this patch for upstream kernel
> http://www2.kernel.org/pub/linux/kernel/people/agk/patches/ 
> 2.6/2.6.21/dm-raid1-one-kmirrord-per-mirror.patch
>
> All testing RHEL5 kernels from 2.6.18-18 has this fix included,
> so for testing purposes you can try RHEL5.1 beta kernel.

On a different topic, why are you mirroring the log?  Isn't this  
somewhat dangerous?

Let's say that the primary copy of the log dies or goes offline.  You  
continue on because the log device is still "good".  If your machine  
crashes and the primary log device is "rediscovered" on bootup, what  
happens?  The contents of the stale side will be copied - resulting  
in your log not properly reflecting the state of your mirror device  
and maybe even leaving inconsistencies.

You might argue that we should update the metadata to exclude the  
failed primary at the point of failure.  Two things come to mind:
1) log I/O will continue until you take action - leaving you open to  
the scenario above
2) it would be simpler to just allocate a new log (since you are  
changing metadata anyway) and initialize the log as "in-sync" if the  
mirror is already "in-sync".

If you ignore the possibility of transient device failures, mirroring  
the log might make some sense.  You gain an advantage only at the  
times when a log device fails and:
1) the machine fails before the initial resync has completed
2) the machine fails while assigning a new log device

Ultimately, I think that in order to have a fast solution that allows  
you to do the above (as well as a whole host of other advanced  
features, like real-time mirroring) you need kernel accessible device  
labels on each mirror device and log.  The labels would track things  
like: who's the primary, who's a slave, who's in the group, who's  
failed, etc.  I've seen some people advocate putting this in the log,  
but the log can fail.  (I hope I've already conveyed why I don't  
think it's a good idea to mirror the log.)  I don't have any good  
ideas for making this happen right now.

  brassow
