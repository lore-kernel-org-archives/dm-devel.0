From: Neil Brown <neilb@suse.de>
Subject: Re: Is there a way to see updated contents of a DM
 target's underlying device while the DM target is in use?
Date: Thu, 1 Jul 2010 10:22:03 +1000
Message-ID: <20100701102203.51d9a8fc@notabene.brown>
References: <4BD43A85686FC34D819098DB1C3999D99E4199BA@orsmsx502.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BD43A85686FC34D819098DB1C3999D99E4199BA@orsmsx502.amr.corp.intel.com>
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
Cc: robertx.m.riches.jr@intel.com
List-Id: dm-devel.ids

On Wed, 30 Jun 2010 15:54:08 -0700
"Riches Jr, RobertX M" <robertx.m.riches.jr@intel.com> wrote:

> (New list member, just subscribed.  Apologies if this is not the right list for this question.)
> 
> Is there a way to see the updated contents of a DM target's underlying device while the DM target is in use?  I Googled and searched in documentation and existing code for an answer but was not able to find it.
> 
> Background:
> 
> I'm debugging a DM target that does change-tracking.  It's a combination of code from dm-linear, Alberto Bertogli's dm-csum, dm-delay, and some original code.  (The project architect does intend to properly release it under GPL per the license of the incorporated GPL pieces.)  The target reserves an early portion of the underlying device and exposes/creates/supports a device that is a linear mapping of the rest of the underlying device.  The idea is each write to the exposed device sets a corresponding bit in the reserved portion, using the write barrier trick from dm-csum's 'same' mode, to indicate which parts of the exposed device have been modified and which have not.  (I had earlier tried to use the userspace dirty-logging facility but found it to not meet our needs.)
> 
> The target is intended to be used with LVM snapshots to do block-device-level backups.  (I'm aware of filesystem-level issues with that, but the requirement is the requirement.)  The underlying device for the DM target will be an LVM logical volume.  The backup manager will send a dmsetup message to the DM target to hold all writes (and maybe reads) on indefinite delay, create an LVM snapshot of the DM target's underlying device, then flush the held bios and resume normal operation.
> 
> Problem:
> 
> The current problem I have is many updates are not visible in the DM target's underlying device until I do a 'dmsetup remove'.  When I look at the underlying device (an LVM LV) prior to 'dmsetup remove', it's not reliable whether I see what has been written by the DM target.  I have verified that the bios go out and the callbacks are called.

try blockdev --flushbufs
on the device before reading it.
Or issue the ioctl yourself.
Or use O_DIRECT to read.

I suspect you are reading from the page cache for the device, while dm-linear
reads/writes directly to the device avoiding the page cache.

NeilBrown


> 
> Any suggestions toward being able to reliably see (as in copy out) data from the underlying device or making an LVM snapshot of it while my change-tracking DM target module is still in use?
> 
> Thanks,
> 
> Robert Riches
> Azad Consultant at Intel
> 
> 
