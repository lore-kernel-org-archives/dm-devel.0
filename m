From: David Rosenstrauch <darose@darose.net>
Subject: Volume group / volumes not activated at boot
Date: Wed, 23 Oct 2013 11:05:40 -0400
Message-ID: <5267E5C4.3070707@darose.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

For several months now, my server has be been failing to activate all 
volume groups / volumes at boot.  My server has 3 PV's, 3 VG's, and 4 
LV's.  But for some reason only 3 of the 4 LV's are activated after boot.

I can subsequently activate the VG manually (vgchange -ay vg2) and then 
mount the LV.  But the fact that the LV never activates automatically at 
boot time means that I can't add it in the fstab to so that it mounts at 
boot.

The start of the problem seems to coincide with when my distro (Arch 
Linux) moved to using lvmetad for device discovery.  But the distro's 
LVM package maintainer has reviewed my logs and can't see any reason why 
the volume group is not getting activated.

I've posted a verbose LVM debug log that I obtained while booting my 
device into single user mode.  (See http://www.darose.net/lvm2.log) 
You'll notice a few odd things in the log:  e.g., vg2 and vg2/lvshare 
never get activated, /etc/lvm/backup/vg2 never gets read or written, etc.

Details of my environment are as follows:
OS:	Arch Linux
Kernel:	3.11.6
Architecture:	x86_64
device-mapper version:	2.02.103
LVM version:	2.02.103

Any help greatly appreciated!

Best,

DR
