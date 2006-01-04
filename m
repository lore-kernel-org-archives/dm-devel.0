From: "Phil Lowden (plowden)" <plowden@cisco.com>
Subject: LVM2, RHEL 4: incorrect open status on logical volumes
Date: Wed, 4 Jan 2006 13:42:51 -0500
Message-ID: <013350FE9CC8AC4EB602045723F47222FAF8FD@xmb-rtp-215.amer.cisco.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On RHEL4 update 2 in some cases LVM2 won't
remove or deactivate logical volumes or volume
groups due to their being open, but the open count is 0:

# dmsetup info -c vgtest1-lvtest1
Name             Maj Min Stat Open Targ Event  UUID
vgtest1-lvtest1  253 128 L--w    0    1      0
iR59EFyd6g26fCGazrriGlhRBNYp9S7N8axDoKhnJFPpfzhVSQjoOTxUchar6517

# lvremove /dev/vgtest1/lvtest1
  Can't remove open logical volume "lvtest1"

Removing the dm table entry allows this to work:

# dmsetup remove vgtest1-lvtest1

# lvremove /dev/vgtest1/lvtest1
  Logical volume "lvtest1" successfully removed

Same behavior for these commands:

# vgchange -a n vgtest1
  Can't deactivate volume group "vgtest1" with 1 open logical volume(s)

# lvchange -a n vgtest1/lvtest1
  LV vgtest1/lvtest1 in use: not removing

This happens on some VGs with both striped and non-striped LVs,=20
on PVs built on both sd and multipath devices.  Reproduced on EMC
Clariion,
EMC Symmetrix and IBM SAN volume controller storage (in front
of the same EMC Symmetrix).  It only happens for some volume
groups, but when it happens it's consistent (i.e. lvremove
either works without "dmsetup remove" or it doesn't).=20

Environment details below. =20

Thanks in advance for any help,
Phil Lowden

# uname -a
Linux <removed> 2.6.9-22.0.1.ELsmp #1 SMP Tue Oct 18 18:39:27 EDT 2005
i686 i686 i386 GNU/Linux
# cat /etc/redhat-release
Red Hat Enterprise Linux AS release 4 (Nahant Update 2)
# lvremove --version
  LVM version:     2.01.14 (2005-08-04)
  Library version: 1.01.04 (2005-08-02)
  Driver version:  4.4.0
# lvm dumpconfig
devices {
        dir=3D"/dev"
        scan=3D"/dev"
        filter=3D["a|^/dev/mapper/.*|", "a|^/dev/sdx|", "r/.*/"]
        cache=3D"/etc/lvm/.cache"
        write_cache_state=3D1
        types=3D["device-mapper", 1]
        sysfs_scan=3D1
        md_component_detection=3D0
}
activation {
        missing_stripe_filler=3D"/dev/ioerror"
        mirror_region_size=3D512
        reserved_stack=3D256
        reserved_memory=3D8192
        process_priority=3D-18
}
global {
        umask=3D63
        test=3D0
        activation=3D1
        proc=3D"/proc"
        locking_type=3D1
        locking_dir=3D"/var/lock/lvm"
}
shell {
        history_size=3D100
}
backup {
        backup=3D1
        backup_dir=3D"/etc/lvm/backup"
        archive=3D1
        archive_dir=3D"/etc/lvm/archive"
        retain_min=3D10
        retain_days=3D30
}
log {
        verbose=3D0
        syslog=3D1
        overwrite=3D0
        level=3D0
        indent=3D1
        command_names=3D0
        prefix=3D"  "
}

# lvdisplay vgtest1/lvtest1
  --- Logical volume ---
  LV Name                /dev/vgtest1/lvtest1
  VG Name                vgtest1
  LV UUID                wTrWm1-qhtc-Ov1z-0Jws-ogOT-wkF6-81CK42
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                16.00 MB
  Current LE             4
  Segments               1
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:128

# lvs -o +devices  vgtest1/lvtest1
  LV      VG      Attr   LSize  Origin Snap%  Move Log Copy%  Devices

  lvtest1 vgtest1 -wi-ao 16.00M
/dev/dm-110(0)   =20
                      =20
# vgs
  VG      #PV #LV #SN Attr  VSize VFree
  vgtest1  64   1   0 wz--n 1.75G 1.73G

# multipath -l 360050768018080bad000000000000011=20
[size=3D32 MB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [active]
  \_ 1:0:1:15 sdev 129:112 [active]
  \_ 0:0:1:15 sdx  65:112  [active]

# lvremove -vvvv /dev/vgtest1/lvtest1
[output trimmed due to size - 64 PVs in vgtest1]
#lvmcmdline.c:836         Processing: lvremove -vvvv
/dev/vgtest1/lvtest1
#lvmcmdline.c:839         O_DIRECT will be used
#config/config.c:773       Setting global/locking_type to 1
#config/config.c:758       Setting global/locking_dir to /var/lock/lvm
#locking/locking.c:139       File-based locking enabled.
#toollib.c:130     Using logical volume(s) on command line
#locking/file_locking.c:164       Locking /var/lock/lvm/V_vgtest1 WB
#filters/filter-regex.c:188         /dev/ramdisk: Skipping (regex)
[snip]
#filters/filter-regex.c:188         /dev/sdx: Skipping (regex)
[snip]
#filters/filter-regex.c:188         /dev/sdef: Skipping (regex)
[snip]
#device/dev-io.c:425         Opened /dev/dm-110 RW O_DIRECT
#device/dev-io.c:134         /dev/dm-110: block size is 4096 bytes
#label/label.c:168       /dev/dm-110: lvm2 label detected
#cache/lvmcache.c:426         lvmcache: /dev/dm-110 now orphaned
#cache/lvmcache.c:426         lvmcache: /dev/dm-110 now in VG vgtest1
[snip]
#label/label.c:168       /dev/dm-110: lvm2 label detected
[snip]
#label/label.c:168       /dev/dm-50: lvm2 label detected
#format_text/format-text.c:311         Read vgtest1 metadata (89) from
/dev/dm-1
24 at 49152 size 9144
#metadata/pv_manip.c:242         /dev/dm-110 0:      0      4:
lvtest1(0:0)
#metadata/pv_manip.c:242         /dev/dm-110 1:      4      3: NULL(0:0)
#metadata/pv_manip.c:242         /dev/dm-111 0:      0      7: NULL(0:0)
[snip]
#config/config.c:758       Setting activation/missing_stripe_filler to
/dev/ioer
ror
#activate/dev_manager.c:1048         Getting device info for
vgtest1-lvtest1
#ioctl/libdm-iface.c:1326         dm version   O =20
#ioctl/libdm-iface.c:1326         dm info
iR59EFyd6g26fCGazrriGlhRBNYp9S7NeyMR2
uDRyetvFPXlvNKK9rMrVweI3lmE O =20
#lvremove.c:59   Can't remove open logical volume "lvtest1"
#locking/file_locking.c:59       Unlocking /var/lock/lvm/V_vgtest1
[snip]
#device/dev-io.c:456         Closed /dev/dm-110
