From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] kobject: provide kobject_put_wait to fix module unload
 race
Date: Mon, 6 Jan 2014 13:43:07 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401061303300.6190@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com> <20140104181620.GA2087@kroah.com> <20140104183403.GG10323@ZenIV.linux.org.uk> <20140104224206.GC18213@core.coreip.homeip.net> <alpine.LRH.2.02.1401051706040.18406@file01.intranet.prod.int.rdu2.redhat.com>
 <20140105223926.GA31541@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140105223926.GA31541@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jeff Mahoney <jeffm@suse.com>, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tglx@linutronix.de, paulmck@linux.vnet.ibm.com, mingo@kernel.org
List-Id: dm-devel.ids



On Sun, 5 Jan 2014, Dmitry Torokhov wrote:

> > But sometimes, the driver itself needs to create nodes in the sysfs 
> > filesystem (for example drivers/md/dm-sysfs.c). I don't quite see how 
> > would you push all driver-specific sysfs nodes into the generic non-module 
> > code.
> 
> Then you need to make sure your driver does not allow unloading while
> its objects are active. I.e. require that all your devices are gone
> (by increasing module count when you create a DM object and decreasing
> it when you release DM object) before you allow unloading the driver.

For drivers that register to various subsystems (for example with 
pci_register_driver and pci_unregister_driver) this can't be done 
correctly - pci_unregister_driver is called from the module unload path, 
it destroys all instances of the device and their appropriate sysfs nodes.

The sysfs nodes exist even if the driver is unused and has zero module 
count.

> Basically we should avoid kobject_put() in exit paths of the module.



> Then we are left with that tiny race with release being preempted and
> module getting unloaded.

Majority of kobject users aren't managing module refcount in the 
release routine. They do not have a tiny race - they have a big race that 
is hapenning with CONFIG_DEBUG_KOBJECT_RELEASE.



These use completion to wait for the released object (thus, they are 
correct):
cpufreq_sysfs_release, cpuidle_sysfs_release, cpuidle_state_sysfs_release, 
cpuidle_driver_sysfs_release, ext4_sb_release, ext4_feat_release, 
f2fs_sb_release

These have no protection against module unload at all:
pkt_kobj_release, map_release, portio_release, ib_port_release, 
cm_release_port_obj, mlx4_port_release, ttm_bo_global_kobj_release, 
ttm_pool_kobj_release, ttm_mem_zone_kobj_release, 
ttm_mem_global_kobj_release, rdev_free, md_free, efivar_release, 
dmi_entry_free, dmi_sysfs_entry_release, edd_release, 
iscsi_boot_kobj_release, lockspace_kobj_release, gfs2_sbd_release, 
release_nbp

These have empty or non-existent release routine (thus having no 
protection): dm-sysfs.c, qib_port_release

These use module refcount: edac_device_ctrl_master_release, 
edac_device_ctrl_instance_release, edac_device_ctrl_block_release

> Thanks.
> 
> -- 
> Dmitry

Mikulas
