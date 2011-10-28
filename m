From: Bernd Broermann <bernd@broermann.com>
Subject: Re: DM inconsistent after disk migration
Date: Fri, 28 Oct 2011 16:06:46 +0200
Message-ID: <4EAAB6F6.7080505@broermann.com>
References: <780ff8d84fb70f7ddf8beb696ff02ddf.squirrel@webmail.xlab.net>
	<4EA0398D.4020207@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EA0398D.4020207@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Am 20.10.2011 17:09, schrieb Bryn M. Reeves:
> On 10/20/2011 03:47 PM, Bernd Broermann wrote:
>> CODE "move" script
>> # mirror
>> pvcreate /dev/disk2
>> vgextend vg01  /dev/disk2
>> lvconvert -m1 --mirrorlog core /dev/vg01/lvdata  /dev/disk2
>> # split
>> lvconvert -m0 --mirrorlog core /dev/vg01/lvdata  /dev/disk1
>> vgreduce vg01  /dev/disk1
>> pvremove  /dev/disk1
> 
> If you just want to move the logical extents in vg01/lvdata from disk1 -> disk2 why not use pvmove?
> 
> Internally it will construct a corelog mirror in a very similar way but it saves you from having to manually split things and supports transactional updates allowing the move to be automatically
> resumed if it is interrupted for any reason.
> 
> E.g.:
> 
> pvcreate /dev/disk2
> pvmove /dev/disk1 /dev/disk2 (you can ommit disk2 here if it's the
>                               only free space in the VG and pvmove will
>                               chose it automatically)
> vgreduce /dev/disk1
> pvremove /dev/disk1
> 
>> My assumption is that SLAVE reconfigures the device-mapper not correct,
>> when doing the "move" operations on MASTER.
> 
> Nothing told the SLAVE host that vg01/lvdata had changed so it still has the original PV device open (from its point of view on that side of the SRDF replication).
> 
> If the LV is not in use you can just de-activate/re-activate to have it see the changes to the VG metadata:
> 
> vgchange -an vg01; vgchange -ay vg01

Thank you,
you gave me the right advice.

I did a vgchange --refresh , as senn in the man page.
Other dead entries of LVs on SLAVE , I could remove with "dmsetup remove <LV device>".

Bernd

> 
> Unless you're using a clustered environment with clvmd hosts that have a common view of shared storage will not be aware of on-disk changes made by another host. This is hazardous if both hosts can
> write to the storage at the same time as it's possible for simultaneous updates to the VG metadata to corrupt one another (SRDF should prevent this since only one side of the replicated device can be
> writable at a time but some care is still needed to ensure all hosts have a coherent view of the VG).
> 
> Regards,
> Bryn.
> 
> 
