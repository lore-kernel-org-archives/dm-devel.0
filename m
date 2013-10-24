From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Volume group / volumes not activated at boot
Date: Thu, 24 Oct 2013 11:32:48 +0200
Message-ID: <5268E940.2000006@redhat.com>
References: <5267E5C4.3070707@darose.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5267E5C4.3070707@darose.net>
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

Dne 23.10.2013 17:05, David Rosenstrauch napsal(a):
> For several months now, my server has be been failing to activate all volume
> groups / volumes at boot.  My server has 3 PV's, 3 VG's, and 4 LV's.  But for
> some reason only 3 of the 4 LV's are activated after boot.
>
> I can subsequently activate the VG manually (vgchange -ay vg2) and then mount
> the LV.  But the fact that the LV never activates automatically at boot time
> means that I can't add it in the fstab to so that it mounts at boot.
>
> The start of the problem seems to coincide with when my distro (Arch Linux)
> moved to using lvmetad for device discovery.  But the distro's LVM package
> maintainer has reviewed my logs and can't see any reason why the volume group
> is not getting activated.

IMHO in normal case distro should ensure that only devices needed for the
system are activated on the boot.

So if you need all your volumes from a VG active - just add somewhere in your
boot sequence    'vgchange -ay' if you need all LVs active.

There is also recently a support for 'autoactivated' LVs - but this needs 
lvmetad daemon running in your system.

Zdenek
