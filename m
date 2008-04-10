From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Data corruption on software RAID
Date: Thu, 10 Apr 2008 08:14:36 +0200
Message-ID: <ftkb92$r4n$1@ger.gmane.org>
References: <Pine.LNX.4.64.0804080033430.13352@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754804AbYDJGPZ@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:
> During source code review, I found an unprobable but possible data 
> corruption on RAID-1 and on DM-RAID-1. (I'm not sure about RAID-4,5,6).
>
> The RAID code was enhanced with bitmaps in 2.6.13.
...
> The developers assume that when all writes to the region finish, the 
> region is in-sync.

Just for the records: You don't need bitmaps for that, this happens on
plain non-bitmapped devices as well.
I had an interesting discussion about this with Heinz Mauelshagen on the
linux-raid list back in early 2006 starting with
	Message-ID: <du6t39$be5$1@sea.gmane.org>

And it's not that unlikely at all. I experience such inconsistencies
regularly on ext2/3 filesystems with heavy inode fluctuations (for
example via cp -al; rsync, like rsnapshot does). I periodically sync
these inconsistencies manual. However, it always seems to appear with
inode removal only, which is rather harmless.


regards
   Mario
-- 
I've never been certain whether the moral of the Icarus story should
only be, as is generally accepted, "Don't try to fly too high," or
whether it might also be thought of as, "Forget the wax and feathers
and do a better job on the wings."            -- Stanley Kubrick
