From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH v3 0/8] dm-raid (raid456) target
Date: Thu, 6 Jan 2011 11:37:00 -0600
Message-ID: <E33A7BB7-C6C2-4A00-84B2-08FE24961FFD@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>	<20101221141443.5aea0b12@notabene.brown>	<20110105223628.GA13164@redhat.com>
	<20110106214645.2bd321f4@notabene.brown>
	<4D25E617.70509@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D25E617.70509@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


On Jan 6, 2011, at 9:56 AM, Phillip Susi wrote:

> On 1/6/2011 5:46 AM, NeilBrown wrote:
>> 3:	<#raid_devs> <meta_dev1> <dev1> .. <meta_devN> <devN>
>
> Let me get this straight.  You specify a separate device to hold the
> metadata and write intent bitmap for each data device?  So for a 3  
> disk
> raid 5, lvm will need to create two logical volumes on each of the 3
> physical volumes, one of which will only be a single physical extent,
> and will hold the raid metadata and write intent bitmap?
>
> Why not just store the metadata on the main device like mdadm does  
> today?

There is no single big reason to do things as I've propose, just a lot  
of little reasons...

1) Device-mapper already has a few cases where metadata is kept on  
separate devices from the data (snapshots and mirror log) and no cases  
where they are kept together.  This new raid module is similar to the  
mirroring case, where bitmaps are kept separately.

2) It seems a bit funny to specify a length (second param of the  
device-mapper CTR) and then expect the devices to be larger than their  
share of that amount to accommodate metadata.  You might say it is  
funny to have to specify a separate device to hold the metadata, but I  
would again give the mirror log as an example.

3) Where multiple physical devices form a single leg/component of the  
array, the argument for having a metadata device specifically tied to  
its data device as an indivisible unit is weakened.

4) Having the metadata on a separate logical device increases the  
flexibility of its placement.  You could have it at the beginning, in  
the middle, or at the end.  (The middle might actually be preferred  
for performance reasons.)  There are no offset calculations to perform  
in the kernel that depend on metadata placement.

5) Resizing an array might require the resizing of the metadata area.   
Because the devices are separate, there is no need to move around data  
or metadata to accommodate this.  If they were mixed in the same  
device and the metadata was at the beginning, that's a problem if the  
metadata no longer fits in its area.  Likewise, if the metadata were  
at the end of a mixed device, you would have to move it when growing.   
These problems are eliminated.

6) The metadata areas are not necessary in every case.  Some raid  
controllers handle the metadata on their own (dm-raid works with  
these).  You might say it is merely another flag on the CTR line to  
indicate whether to use metadata or not.  Perhaps, but having them  
separate means you can easily convert between the two types.

7) Clustering?  Perhaps one of the weaker arguments, but having the  
metadata separate allows it to easily grow to accommodate a bitmap /  
device / node, for example.  This is really the same argument as  
easily being able to reform/resize the metadata area.

8) Bitmaps/superblocks that are updated often could be placed on  
separate devices, like SSDs, while the data is on spinning media.  I'm  
not necessarily advocating this, but if someone wants to do it, I  
think they should be able to.

9) Flexibility for the future.  Imagine a mirror and you'd like to  
split off a leg - the data portion alone becomes the linear device.   
The metadata device could be discarded, or it could be recombined with  
the data device and reinserted into the array - having just the deltas  
be played back from the original mirror that has remained actively in- 
use.

Each of these reasons is not all that compelling in isolation; but  
together, I think they make a pretty good case.  There is additional  
flexibility here; and this is to be sacrificed for what?  A simpler  
CTR line?  I don't know of anyone who enters these by hand without  
instead using LVM, dm-raid, multipath, etc.  MD does it this way?   
Well, this is device-mapper and it has its own idiosyncrasies and  
precedents.

Also, I understand what you mean by your final question, but for those  
who are new to this I'd like to point out that we /are/ storing the  
metadata on the main physical device, but not the same logical  
device.  [Again, this will be the rule, but is flexible.]

  brassow
