From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: help with hds DF500F
Date: Mon, 21 Jan 2008 14:02:38 -0600
Message-ID: <20080121200238.GE1929@ether.msp.redhat.com>
References: <97a7c7ed0801181927o226a1b4fm6acf8d64b80ec772@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <97a7c7ed0801181927o226a1b4fm6acf8d64b80ec772@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Fri, Jan 18, 2008 at 10:27:31PM -0500, Michael Di Domenico wrote:
> I have a Hitachi DF500F that i'm trying to redundantly connect.  I've
> got a single QLogic HBA dual-port.  Both ports are connected to an FC
> switch.  The HDS unit has four ports, two per controller.  All four
> ports are connected to the FC switch also.  This is on RedHat 5
> x86_64.
> 
> I'm trying to setup multipath, but i can't seem to figure out the correct setup.
> 
> I also noted two things that seem like bugs.  I used the 'make rpm' to
> build and rpm of multipath, however there were several files not
> included in the rpm which caused it to fail, so i added those to the
> %files section.
> 
> Also the RPM doesnt seem to include the
> /etc/init.d/multipathd.init.redhat file for me, i had to hand copy it
> over.
> 
> I'm sure i'm doing something wrong, i just dont know what it is.

Have you tried using the device-mapper-multipath rpm that is distributed
with RHEL5? 

Also, the Hitachi DF500F is autoconfigured, so you shouldn't need a
devices section, and most of your blacklist section is included by
default.

Try the following for a /etc/multipath.conf
----

blacklist {
	devnode "^sda$"
}

defaults {
	polling_interval 120
}

----

And see if that works with the RHEL5 device-mapper-multipath rpm

-Ben

> Thanks
> 
> Here is my /etc/multipath.conf file:
> 
> defaults {
>  polling_interval 120
>  udev_dir /dev
>  rr_weight priorities
>  failback immediate
>  }
> 
> blacklist {
>  devnode cciss
>  devnode fd
>  devnode hd
>  devnode md
>  devnode sr
>  devnode scd
>  devnode st
>  devnode ram
>  devnode raw
>  devnode loop
>  devnode "^sda$"
> }
> 
> devices {
>  device {
>   vendor "HITACHI"
>   product "DF500F"
>   path_grouping_policy group_by_prio
>   prio_callout "/sbin/mpath_prio_hds_modular %d"
>   getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
>  }
> }
> 
> here is what happens when i run multipath:
> 
> error calling out /sbin/mpath_prio_hds_modular 67:128
> error calling out /sbin/mpath_prio_hds_modular 67:112
> error calling out /sbin/mpath_prio_hds_modular 67:96
> error calling out /sbin/mpath_prio_hds_modular 67:80
> error calling out /sbin/mpath_prio_hds_modular 67:64
> error calling out /sbin/mpath_prio_hds_modular 67:48
> error calling out /sbin/mpath_prio_hds_modular 67:32
> error calling out /sbin/mpath_prio_hds_modular 67:16
> error calling out /sbin/mpath_prio_hds_modular 67:0
> error calling out /sbin/mpath_prio_hds_modular 66:240
> error calling out /sbin/mpath_prio_hds_modular 66:224
> error calling out /sbin/mpath_prio_hds_modular 66:208
> error calling out /sbin/mpath_prio_hds_modular 66:192
> error calling out /sbin/mpath_prio_hds_modular 66:176
> error calling out /sbin/mpath_prio_hds_modular 66:160
> error calling out /sbin/mpath_prio_hds_modular 66:144
> error calling out /sbin/mpath_prio_hds_modular 66:128
> error calling out /sbin/mpath_prio_hds_modular 66:112
> error calling out /sbin/mpath_prio_hds_modular 66:96
> error calling out /sbin/mpath_prio_hds_modular 66:80
> error calling out /sbin/mpath_prio_hds_modular 66:64
> error calling out /sbin/mpath_prio_hds_modular 66:48
> error calling out /sbin/mpath_prio_hds_modular 66:32
> error calling out /sbin/mpath_prio_hds_modular 66:16
> error calling out /sbin/mpath_prio_hds_modular 66:0
> error calling out /sbin/mpath_prio_hds_modular 65:240
> error calling out /sbin/mpath_prio_hds_modular 65:224
> error calling out /sbin/mpath_prio_hds_modular 65:208
> error calling out /sbin/mpath_prio_hds_modular 65:192
> error calling out /sbin/mpath_prio_hds_modular 65:176
> error calling out /sbin/mpath_prio_hds_modular 65:160
> error calling out /sbin/mpath_prio_hds_modular 65:144
> error calling out /sbin/mpath_prio_hds_modular 65:128
> error calling out /sbin/mpath_prio_hds_modular 65:112
> error calling out /sbin/mpath_prio_hds_modular 65:96
> error calling out /sbin/mpath_prio_hds_modular 65:80
> error calling out /sbin/mpath_prio_hds_modular 65:64
> error calling out /sbin/mpath_prio_hds_modular 65:48
> error calling out /sbin/mpath_prio_hds_modular 65:32
> error calling out /sbin/mpath_prio_hds_modular 65:16
> error calling out /sbin/mpath_prio_hds_modular 65:0
> error calling out /sbin/mpath_prio_hds_modular 8:240
> error calling out /sbin/mpath_prio_hds_modular 8:224
> error calling out /sbin/mpath_prio_hds_modular 8:208
> error calling out /sbin/mpath_prio_hds_modular 8:192
> error calling out /sbin/mpath_prio_hds_modular 8:176
> error calling out /sbin/mpath_prio_hds_modular 8:160
> error calling out /sbin/mpath_prio_hds_modular 8:144
> error calling out /sbin/mpath_prio_hds_modular 8:128
> error calling out /sbin/mpath_prio_hds_modular 8:112
> error calling out /sbin/mpath_prio_hds_modular 8:96
> error calling out /sbin/mpath_prio_hds_modular 8:80
> error calling out /sbin/mpath_prio_hds_modular 8:64
> error calling out /sbin/mpath_prio_hds_modular 8:48
> error calling out /sbin/mpath_prio_hds_modular 8:32
> error calling out /sbin/mpath_prio_hds_modular 8:16
> error calling out /sbin/mpath_prio_hds_modular 67:128
> error calling out /sbin/mpath_prio_hds_modular 67:112
> error calling out /sbin/mpath_prio_hds_modular 67:96
> error calling out /sbin/mpath_prio_hds_modular 67:80
> error calling out /sbin/mpath_prio_hds_modular 67:64
> error calling out /sbin/mpath_prio_hds_modular 67:48
> error calling out /sbin/mpath_prio_hds_modular 67:32
> error calling out /sbin/mpath_prio_hds_modular 67:16
> error calling out /sbin/mpath_prio_hds_modular 67:0
> error calling out /sbin/mpath_prio_hds_modular 66:240
> error calling out /sbin/mpath_prio_hds_modular 66:224
> error calling out /sbin/mpath_prio_hds_modular 66:208
> error calling out /sbin/mpath_prio_hds_modular 66:192
> error calling out /sbin/mpath_prio_hds_modular 66:176
> error calling out /sbin/mpath_prio_hds_modular 65:192
> error calling out /sbin/mpath_prio_hds_modular 65:176
> error calling out /sbin/mpath_prio_hds_modular 65:160
> error calling out /sbin/mpath_prio_hds_modular 65:144
> error calling out /sbin/mpath_prio_hds_modular 65:128
> error calling out /sbin/mpath_prio_hds_modular 65:112
> error calling out /sbin/mpath_prio_hds_modular 65:96
> error calling out /sbin/mpath_prio_hds_modular 65:80
> error calling out /sbin/mpath_prio_hds_modular 65:64
> error calling out /sbin/mpath_prio_hds_modular 65:48
> error calling out /sbin/mpath_prio_hds_modular 65:32
> error calling out /sbin/mpath_prio_hds_modular 65:16
> error calling out /sbin/mpath_prio_hds_modular 65:0
> error calling out /sbin/mpath_prio_hds_modular 8:240
> 67:112: size 2097152, expected 487825408. Discard
> 67:96: size 2097152, expected 487825408. Discard
> 67:80: size 2097152, expected 487825408. Discard
> 67:64: size 2097152, expected 487825408. Discard
> 67:48: size 2097152, expected 487825408. Discard
> 67:32: size 2097152, expected 487825408. Discard
> 67:0: size 2097152, expected 487825408. Discard
> 66:240: size 2097152, expected 487825408. Discard
> 66:224: size 2097152, expected 487825408. Discard
> 66:208: size 2097152, expected 487825408. Discard
> 66:192: size 2097152, expected 487825408. Discard
> 66:176: size 2097152, expected 487825408. Discard
> 65:176: size 2097152, expected 487825408. Discard
> 65:160: size 2097152, expected 487825408. Discard
> 65:144: size 2097152, expected 487825408. Discard
> 65:128: size 2097152, expected 487825408. Discard
> 65:112: size 2097152, expected 487825408. Discard
> 65:96: size 2097152, expected 487825408. Discard
> 65:64: size 2097152, expected 487825408. Discard
> 65:48: size 2097152, expected 487825408. Discard
> 65:32: size 2097152, expected 487825408. Discard
> 65:16: size 2097152, expected 487825408. Discard
> 65:0: size 2097152, expected 487825408. Discard
> 8:240: size 2097152, expected 487825408. Discard
> error calling out /sbin/mpath_prio_hds_modular 66:160
> error calling out /sbin/mpath_prio_hds_modular 66:144
> error calling out /sbin/mpath_prio_hds_modular 66:128
> error calling out /sbin/mpath_prio_hds_modular 66:112
> error calling out /sbin/mpath_prio_hds_modular 66:96
> error calling out /sbin/mpath_prio_hds_modular 66:80
> error calling out /sbin/mpath_prio_hds_modular 66:64
> error calling out /sbin/mpath_prio_hds_modular 66:48
> error calling out /sbin/mpath_prio_hds_modular 66:32
> error calling out /sbin/mpath_prio_hds_modular 66:16
> error calling out /sbin/mpath_prio_hds_modular 66:0
> error calling out /sbin/mpath_prio_hds_modular 65:240
> error calling out /sbin/mpath_prio_hds_modular 65:224
> error calling out /sbin/mpath_prio_hds_modular 65:208
> error calling out /sbin/mpath_prio_hds_modular 8:224
> error calling out /sbin/mpath_prio_hds_modular 8:208
> error calling out /sbin/mpath_prio_hds_modular 8:192
> error calling out /sbin/mpath_prio_hds_modular 8:176
> error calling out /sbin/mpath_prio_hds_modular 8:160
> error calling out /sbin/mpath_prio_hds_modular 8:144
> error calling out /sbin/mpath_prio_hds_modular 8:128
> error calling out /sbin/mpath_prio_hds_modular 8:112
> error calling out /sbin/mpath_prio_hds_modular 8:96
> error calling out /sbin/mpath_prio_hds_modular 8:80
> error calling out /sbin/mpath_prio_hds_modular 8:64
> error calling out /sbin/mpath_prio_hds_modular 8:48
> error calling out /sbin/mpath_prio_hds_modular 8:32
> error calling out /sbin/mpath_prio_hds_modular 8:16
> 66:144: size 2097152, expected 487825408. Discard
> 66:128: size 2097152, expected 487825408. Discard
> 66:112: size 2097152, expected 487825408. Discard
> 66:96: size 2097152, expected 487825408. Discard
> 66:80: size 2097152, expected 487825408. Discard
> 66:64: size 2097152, expected 487825408. Discard
> 66:32: size 2097152, expected 487825408. Discard
> 66:16: size 2097152, expected 487825408. Discard
> 66:0: size 2097152, expected 487825408. Discard
> 65:240: size 2097152, expected 487825408. Discard
> 65:224: size 2097152, expected 487825408. Discard
> 65:208: size 2097152, expected 487825408. Discard
> 8:208: size 2097152, expected 487825408. Discard
> 8:192: size 2097152, expected 487825408. Discard
> 8:176: size 2097152, expected 487825408. Discard
> 8:160: size 2097152, expected 487825408. Discard
> 8:144: size 2097152, expected 487825408. Discard
> 8:128: size 2097152, expected 487825408. Discard
> 8:96: size 2097152, expected 487825408. Discard
> 8:80: size 2097152, expected 487825408. Discard
> 8:64: size 2097152, expected 487825408. Discard
> 8:48: size 2097152, expected 487825408. Discard
> 8:32: size 2097152, expected 487825408. Discard
> 8:16: size 2097152, expected 487825408. Discard
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
