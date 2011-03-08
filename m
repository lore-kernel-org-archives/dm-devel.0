From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: generic wrappers for multi-device FS operations
Date: Tue, 08 Mar 2011 23:23:00 +0100
Message-ID: <4D76AC44.9090206@redhat.com>
References: <4D766199.4010307@gmail.com>	<B2CB305A-1268-4F0A-98AA-CA08FA10FDE8@dilger.ca>
	<4D76988E.7010400@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D76988E.7010400@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 8.3.2011 21:58, Ric Wheeler napsal(a):
> On 03/08/2011 03:54 PM, Andreas Dilger wrote:
>> On 2011-03-08, at 10:04 AM, Ric Wheeler wrote:
>>> After seeing some of the feedback and confusion that happened in the fedora
>>> community after Josef suggestion that we default to btrfs in an upcoming
>>> Fedora release, it became clear to me that many users are incredibly
>>> unaware of the common features that we have across file systems today given
>>> LVM/device mapper support.
>>>
>>> btrfs will make multi-volume/multi-disk operations common place and easy to
>>> do, but there is no reason not to do most/all of this today with ext4, xfs,
>>> etc on top of lvm.
>>>
>>> To make this trivial to do for users, I think that it would be really nice
>>> to have a two-level wrappers for things like resize, add a volume, shrink,
>>> etc. Similar to the way we have mount or fsck invoke file system specific
>>> bits.
>> I definitely think this makes sense.  However, taking a quick look at fsadm,
>> I don't think it is the right starting point for this work.  It is essentially
>> a single script that is special-casing each filesystem it is touching, which
>> makes it a maintenance nightmare to add in support for different filesystems.
>>
>> A better structure is the mkfs.* and fsck.* tools that extend the basic
>> mkfs/fsck functionality for each new filesystem.  That allows new filesystems
>> to be added without the requirement to modify the upstream fsadm script.
> 
> I do like the two level scheme that mkfs.* and fsck.* use - same interface
> largely regardless of the file system and the ability to customize the fs
> specific command as needed.
> 
>>
>> Another tool similar to this that I've been trying to push upstream for some
>> time is the "lvcheck" script, which is essentially a wrapper for online
>> filesystem checking.  It is currently structured as an extension to the LVM
>> tools, since it depends on creating a snapshot of an LV and does a check on
>> the snapshot.  If the snapshot is clean the original filesystem is marked
>> checked as well, which avoids the "slow ext* check on boot" problem, while
>> still ensuring that periodic filesystem checks will catch latent errors.
>>
>> It wouldn't be unreasonable to have a new wrapper for online filesystem
>> checking (e.g. ofsck) or just an extension to fsck that does this in a more
>> "plug-in" manner like fsck.* does today.  It would naturally progress into
>> real online checking for filesystems that support this (e.g. btrfs, and I
>> think XFS is going in this direction as well).
>>
>> Cheers, Andreas
> 
> Online fsck would certainly be a win & would make a lot of users happy,
> 

Can I ask for creating RH bugzillas for missing fsadm functionality.
(Support for btrfs (Bug 643907)  is already there thought other more prio task
are currently resolved).

Zdenek
