From: Luca Berra <bluca@comedia.it>
Subject: Re: [dm-devel] Re: LVM on dmraid breakage
Date: Sat, 4 Aug 2007 08:50:48 +0200
Message-ID: <20070804065047.GA29541@percy.comedia.it>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B254E4.60700@cfl.rr.com> <20070803081133.GB939@percy.comedia.it>
	<46B36F7A.2090601@cfl.rr.com>
	<20070803195749.GA27271@percy.comedia.it>
	<46B39E58.2040305@cfl.rr.com>
Reply-To: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <ataraid-list-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B39E58.2040305@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: dm-devel@redhat.com, ataraid-list@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 03, 2007 at 05:30:00PM -0400, Phillip Susi wrote:
>Luca Berra wrote:
>>On Fri, Aug 03, 2007 at 02:10:02PM -0400, Phillip Susi wrote:
>>>I agree with moving the partition detection code to user space, but 
>>>trying to undo it after the fact doesn't help because udev is already 
>>>processing the add events.  Also you do not need to remove the 
>>>partitions so long as pvscan understands that it shouldn't be using them.
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>which is the modification i proposed to lvm tools, isn't it?
>
>You suggested deleting the partition table after it has already been 
>detected.  I am saying that while I agree in principal that partition 
I was referring to the modification to lvm2, not the one to dmraid.

>detection should be moved out of the kernel, for now, it is in there and 
>deleting them after they have already been detected doesn't help matters 
>because pvscan may already be running on them.
Actually i am not worried too much about vgscan/pvscan, i am much more
worried for mount, swapon, one particular piece of crap called
hibernate-cleanup.sh etc.
besides, i am positive that users get confused having both /dev/sda1 and
/dev/mapper/via_aggehhahyue1

>>>Udev is supposed to be the new model for enumerating devices and 
>>i know that, and i will withdraw from this discussion, since it might
>>get to an useless flame war.
>>
>>Is there any technical reason for not having lvm tools filter out 
>>devices that
>>are used by device mapper?
>>
>>besides dmraid, think of multipath.
>
>None that I can see at the moment, but that doesn't mean there isn't 
>one, or won't be one in the future.  The other problem is that there are 
the above is called FUD

>likely other factors besides being used already as a dm target that 
>might give reason for lvm to not scan the volume.  These kind of policy 
probably, we strive to be perfect, but we still have a long way to
go...

>decisions seem like they should be made by udev rather than hard coded 
>into lvm.  If the admin wants a policy where lvm should look at volumes, 
>or indeed, maybe only certain volumes, that already happen to be dm 
>targets, he should be able to do that.  Likewise, there may be some 
udev is not the only thing on earth that wants to activate a volume
group. what if i wanted to do it manually?

>other reason to not look at a disk for lvm pvs.  Editing a conf file to 
>specify a filter list of devices by name is all well and good for a 
>static system, but it does not play well in the modern udev managed plug 
>and play world.
whoever wrote about editing the conf file?
i wrote about detecting that a device is already in user by
device-mapper and skipping that.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
