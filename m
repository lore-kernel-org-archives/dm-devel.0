From: Ric Wheeler <ricwheeler@gmail.com>
Subject: generic wrappers for multi-device FS operations
Date: Tue, 08 Mar 2011 12:04:25 -0500
Message-ID: <4D766199.4010307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Karel Zak <kzak@redhat.com>, Jim Meyering <jim@meyering.net>, Chris Mason <chris.mason>
List-Id: dm-devel.ids


After seeing some of the feedback and confusion that happened in the fedora 
community after Josef suggestion that we default to btrfs in an upcoming Fedora 
release, it became clear to me that many users are incredibly unaware of the 
common features that we have across file systems today given LVM/device mapper 
support.

btrfs will make multi-volume/multi-disk operations common place and easy to do, 
but there is no reason not to do most/all of this today with ext4, xfs, etc on 
top of lvm.

To make this trivial to do for users, I think that it would be really nice to 
have a two-level wrappers for things like resize, add a volume, shrink, etc. 
Similar to the way we have mount or fsck invoke file system specific bits.

Good idea? Bad idea?

Thanks!

Ric

