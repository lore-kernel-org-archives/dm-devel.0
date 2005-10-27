From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: LVM2, RHEL 4 update 2: can't remove logical volume
Date: Thu, 27 Oct 2005 10:58:22 +0200
Message-ID: <OF29A33E0B.95E7850F-ONC12570A7.002EDB85-C12570A7.0031344E@de.ibm.com>
References: <013350FE9CC8AC4EB602045723F47222B9A304@xmb-rtp-215.amer.cisco.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <013350FE9CC8AC4EB602045723F47222B9A304@xmb-rtp-215.amer.cisco.com>
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

We got something similar here. Try to change the filter rules to exclude 
the
volume group devices. What you want is the devices created by the
multipath-tools included but not the devices created by lvm2.
Otherwise the tools will have the lv open at the time they should be
removed.

Stefan Bader

SW Linux on zSeries Development & Services
Stefan.Bader@de.ibm.com
----------------------------------------------------------------------------------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 26.10.2005 22:30:58:

> I'm getting an error when trying to remove an LV
> that has no mounted filesystem or raw volume on it:
> 
> # raw -qa
> # mount|grep lvtest1
> # lvremove /dev/vgtest2/lvstripe1
>   Can't remove open logical volume "lvstripe1"
> 
> Per lsof and fuser, the only process I can see
> opening any device files is multipathd:
> 
> # fuser /dev/sd*
> /dev/sda:             8910
> /dev/sdb:             8910
> /dev/sdc:             8910
> /dev/sdd:             8910
> /dev/sde:             8910
> /dev/sdf:             8910
> /dev/sdg:             8910
> /dev/sdh:             8910
> 
> # ps -ef|grep multipathd
> root      8910     1  0 14:51 pts/0    00:00:00 /sbin/multipathd 
> 
> But shutting it down doesn't help:
> 
> # service multipathd stop
> Stopping multipathd daemon:                                [  OK  ]
> # lvremove /dev/vgtest2/lvstripe1
>   Can't remove open logical volume "lvstripe1"
> 
> The lvremove -vvvv output is below.  Any thoughts
> on what I can do here? 
> 
> I'm using LVM2 with device-mapper-multipath 0.4.5 on GA RHEL 4 update 2 
> release, kernel version 2.6.9-22.ELsmp.  Storage is 4 Clariion CX600
> LUNs.
> 
> TIA,
> Phil Lowden
> 
> The volume is striped across all 4 PVs.
> 
> # lvs
>   LV        VG      Attr   LSize   Origin Snap%  Move Log Copy% 
>   lvstripe1 vgtest2 -wi-a- 400.00M 
> # vgs
>   VG      #PV #LV #SN Attr  VSize VFree
>   vgtest2   4   1   0 wz--n 9.98G 9.59G
> # pvs
>   PV                                            VG      Fmt  Attr PSize
> PFree 
>   /dev/mapper/3600601604b600d00743e69d8862fda11 vgtest2 lvm2 a-
> 1020.00M 920.00M
>   /dev/mapper/3600601604b600d00753e69d8862fda11 vgtest2 lvm2 a-
> 2.00G   1.90G
>   /dev/mapper/3600601604b600d00763e69d8862fda11 vgtest2 lvm2 a-
> 3.00G   2.90G
>   /dev/mapper/3600601604b600d00773e69d8862fda11 vgtest2 lvm2 a-
> 4.00G   3.90G
> 
> # lvremove -vvvv /dev/vgtest2/lvstripe1
> #lvmcmdline.c:836         Processing: lvremove -vvvv
> /dev/vgtest2/lvstripe1
> #lvmcmdline.c:839         O_DIRECT will be used
> #config/config.c:773       Setting global/locking_type to 1
> #config/config.c:758       Setting global/locking_dir to /var/lock/lvm
> #locking/locking.c:139       File-based locking enabled.
> #toollib.c:130     Using logical volume(s) on command line
> #locking/file_locking.c:164       Locking /var/lock/lvm/V_vgtest2 WB
> #device/dev-io.c:425         Opened
> /dev/mapper/3600601604b600d00773e69d8862fda11 RW O_DIRECT
> #device/dev-io.c:134
> /dev/mapper/3600601604b600d00773e69d8862fda11: block size is 4096 bytes
> #label/label.c:168       /dev/mapper/3600601604b600d00773e69d8862fda11:
> lvm2 label detected
> #cache/lvmcache.c:426         lvmcache:
> /dev/mapper/3600601604b600d00773e69d8862fda11 now orphaned
> #cache/lvmcache.c:426         lvmcache:
> /dev/mapper/3600601604b600d00773e69d8862fda11 now in VG vgtest2
> #device/dev-io.c:425         Opened
> /dev/mapper/3600601604b600d00763e69d8862fda11 RW O_DIRECT
> #device/dev-io.c:134
> /dev/mapper/3600601604b600d00763e69d8862fda11: block size is 4096 bytes
> #label/label.c:168       /dev/mapper/3600601604b600d00763e69d8862fda11:
> lvm2 label detected
> #cache/lvmcache.c:426         lvmcache:
> /dev/mapper/3600601604b600d00763e69d8862fda11 now orphaned
> #cache/lvmcache.c:426         lvmcache:
> /dev/mapper/3600601604b600d00763e69d8862fda11 now in VG vgtest2
> #device/dev-io.c:425         Opened
> /dev/mapper/3600601604b600d00753e69d8862fda11 RW O_DIRECT
> #device/dev-io.c:134
> /dev/mapper/3600601604b600d00753e69d8862fda11: block size is 4096 bytes
> #label/label.c:168       /dev/mapper/3600601604b600d00753e69d8862fda11:
> lvm2 label detected
> #cache/lvmcache.c:426         lvmcache:
> /dev/mapper/3600601604b600d00753e69d8862fda11 now orphaned
> #cache/lvmcache.c:426         lvmcache:
> /dev/mapper/3600601604b600d00753e69d8862fda11 now in VG vgtest2
> #device/dev-io.c:425         Opened
> /dev/mapper/3600601604b600d00743e69d8862fda11 RW O_DIRECT
> #device/dev-io.c:134
> /dev/mapper/3600601604b600d00743e69d8862fda11: block size is 4096 bytes
> #label/label.c:168       /dev/mapper/3600601604b600d00743e69d8862fda11:
> lvm2 label detected
> #cache/lvmcache.c:426         lvmcache:
> /dev/mapper/3600601604b600d00743e69d8862fda11 now orphaned
> #cache/lvmcache.c:426         lvmcache:
> /dev/mapper/3600601604b600d00743e69d8862fda11 now in VG vgtest2
> #device/dev-io.c:425         Opened /dev/vgtest2/lvstripe1 RW O_DIRECT
> #device/dev-io.c:134         /dev/vgtest2/lvstripe1: block size is 4096
> bytes
> #label/label.c:189       /dev/vgtest2/lvstripe1: No label detected
> #label/label.c:279         <backtrace>
> #label/label.c:168       /dev/mapper/3600601604b600d00773e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00763e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00753e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00743e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00773e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00763e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00753e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00743e69d8862fda11:
> lvm2 label detected
> #format_text/format-text.c:311         Read vgtest2 metadata (5) from
> /dev/mapper/3600601604b600d00773e69d8862fda11 at 9216 size 1266
> #label/label.c:168       /dev/mapper/3600601604b600d00773e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00763e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00753e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00743e69d8862fda11:
> lvm2 label detected
> #format_text/format-text.c:311         Read vgtest2 metadata (5) from
> /dev/mapper/3600601604b600d00763e69d8862fda11 at 8192 size 1266
> #label/label.c:168       /dev/mapper/3600601604b600d00773e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00763e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00753e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00743e69d8862fda11:
> lvm2 label detected
> #format_text/format-text.c:311         Read vgtest2 metadata (5) from
> /dev/mapper/3600601604b600d00753e69d8862fda11 at 7168 size 1266
> #label/label.c:168       /dev/mapper/3600601604b600d00773e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00763e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00753e69d8862fda11:
> lvm2 label detected
> #label/label.c:168       /dev/mapper/3600601604b600d00743e69d8862fda11:
> lvm2 label detected
> #format_text/format-text.c:311         Read vgtest2 metadata (5) from
> /dev/mapper/3600601604b600d00743e69d8862fda11 at 6144 size 1266
> #metadata/pv_manip.c:242
> /dev/mapper/3600601604b600d00773e69d8862fda11 0:      0     25:
> lvstripe1(0:0)
> #metadata/pv_manip.c:242
> /dev/mapper/3600601604b600d00773e69d8862fda11 1:     25    998:
> NULL(0:0)
> #metadata/pv_manip.c:242
> /dev/mapper/3600601604b600d00763e69d8862fda11 0:      0     25:
> lvstripe1(0:1)
> #metadata/pv_manip.c:242
> /dev/mapper/3600601604b600d00763e69d8862fda11 1:     25    742:
> NULL(0:0)
> #metadata/pv_manip.c:242
> /dev/mapper/3600601604b600d00753e69d8862fda11 0:      0     25:
> lvstripe1(0:2)
> #metadata/pv_manip.c:242
> /dev/mapper/3600601604b600d00753e69d8862fda11 1:     25    486:
> NULL(0:0)
> #metadata/pv_manip.c:242
> /dev/mapper/3600601604b600d00743e69d8862fda11 0:      0     25:
> lvstripe1(0:3)
> #metadata/pv_manip.c:242
> /dev/mapper/3600601604b600d00743e69d8862fda11 1:     25    230:
> NULL(0:0)
> #config/config.c:758       Setting activation/missing_stripe_filler to
> /dev/ioerror
> #activate/dev_manager.c:1048         Getting device info for
> vgtest2-lvstripe1
> #ioctl/libdm-iface.c:1326         dm version   O 
> #ioctl/libdm-iface.c:1326         dm info
> aiFWOXpuHkPrVsSng5Qlg9TKnDUA7QroT1yHNXkplLWCwIjXrQZYIuPbvoQuF3Vp O 
> #lvremove.c:59   Can't remove open logical volume "lvstripe1"
> #locking/file_locking.c:59       Unlocking /var/lock/lvm/V_vgtest2
> #device/dev-io.c:456         Closed
> /dev/mapper/3600601604b600d00773e69d8862fda11
> #device/dev-io.c:456         Closed
> /dev/mapper/3600601604b600d00763e69d8862fda11
> #device/dev-io.c:456         Closed
> /dev/mapper/3600601604b600d00753e69d8862fda11
> #device/dev-io.c:456         Closed
> /dev/mapper/3600601604b600d00743e69d8862fda11
> #device/dev-io.c:456         Closed /dev/vgtest2/lvstripe1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
