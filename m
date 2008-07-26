From: Adam Hamsik <haaaad@gmail.com>
Subject: NetBSD snapshot creation problem
Date: Sat, 26 Jul 2008 19:42:57 +0200
Message-ID: <DBA90821-ABED-4526-87B9-8A9B9E908646@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: multipart/mixed; boundary="===============0165494298=="
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: blymn <blymn@internode.on.net>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============0165494298==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg=pgp-sha1; boundary="Apple-Mail-20-416293172"
Content-Transfer-Encoding: 7bit

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-20-416293172
Content-Type: multipart/mixed; boundary=Apple-Mail-19-416293067


--Apple-Mail-19-416293067
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Hi, folks

This summer I'm working on NetBSD LVM. I have written our own device- 
mapper
driver which works quite fine now. In the second part of GSOC I want  
to work on
lvm snapshots.

When I try to create snapshot I got an error which is really strange  
and I was not able to
find what is bad in my implementation that it behaves like this. I  
have attached full log from
lvcreate and pasted only small part of it.

_tree_action is called from lv_suspend=>_lv_preload->...->_tree_action

_tree_action add lv->name lv1
vg00-lv1 --- Setting minor to 0 -1----1 this is begining of my  
problems here dm_tree_add_new_dev sets info.exists to 0.
         Checking kernel supports striped segment type for lv1
vg00-lv1-real --- Setting minor to 0 0---0
         Checking kernel supports striped segment type for lv1-real
vg00-snap0 --- Setting minor to 0 -1----1
         Checking kernel supports snapshot segment type for snap0
vg00-snap0-cow --- Setting minor to 0 0---0
         Checking kernel supports snapshot segment type for snap0-cow
dm_preload_children here :(null) -- 0
0---0
dm_preload_children here :vg00-lv1 -- 0
-1----1
dm_preload_children here :vg00-lv1-real -- 0
0---0
dm_preload_chidren end
dm BBBBBB
Creating vg00-lv1-real
dm_task_run
dmt type  create
Ioctl type  create---516
         vg00-lv1-real: Stacking NODE_ADD (169,3) 0:0 0600
dm_task_get_info vg00-lv1-real ---- 1
_create_node 1
dm CCCCCC
     Loading vg00-lv1-real table
         Adding target: 0 24576 linear /dev/wd2a 384
dm_task_run
dmt type  reload
dm_task_run
dmt type  table
Ioctl type  table---20
dm_task_run
dmt type  reload
Ioctl type  reload---516
dm_task_get_info vg00-lv1-real ---- 1
     Suppressed vg00-lv1-real identical table reload.
dm DDDDD
dm EEEEEE
dm_preload_chidren end -> vg00-lv1-real created and loaded
dm BBBBBB [line 1538]
Creating vg00-lv1 Because info.exists = 0 _create_node is called.
dm_task_run
dmt type  create
Ioctl type  create---516
_do_dm_ioctl 17 -> EEXIST -> because vg00-lv1 already exist and  
therefore I can't create
			     device with equal name again.
_create_node 0
dm_preload_chidren end
   Failed to suspend origin lv1

I have spent 2 days with debugging lvm2tools and libdevmapper :) and I  
was not
able to find why I can't create snapshots. Do you have any idea where  
can be a problem ?



--Apple-Mail-19-416293067
Content-Disposition: attachment;
	filename=lvcreate_log.txt
Content-Type: text/plain; x-mac-creator=54784D74; x-unix-mode=0644;
	name="lvcreate_log.txt"
Content-Transfer-Encoding: 7bit

# lvcreate -s -L4M -n snap0 vg00/lv1                                           
      Setting log/indent to 1
      Setting log/prefix to   
      Setting log/command_names to 0
      Setting global/test to 0
      Setting log/overwrite to 0
      Setting log/file to /tmp/lvm2.log
      log/activation not found in config: defaulting to 0
    Logging initialised at Sat Jul 26 19:30:26 2008
      Setting global/umask to 63
    Set umask to 0077
      Setting devices/dir to /dev
      Setting global/proc to /proc
      Setting global/activation to 1
      global/suffix not found in config: defaulting to 1
      Setting global/units to h
      activation/readahead not found in config: defaulting to auto
      devices/preferred_names not found in config file: using built-in preferences
      devices/filter not found in config file: no regex filter installed
      Setting devices/ignore_suspended_devices to 0
      Setting devices/cache_dir to /etc/lvm/cache
      Setting devices/write_cache_state to 1
        Opened /etc/lvm/cache/.cache RO
        /dev/rwd0b: Added to device cache
        /dev/rwd0a: Added to device cache
        /dev/rwd0d: Added to device cache
        /dev/rwd1a: Added to device cache
        /dev/rwd1d: Added to device cache
        /dev/rwd2a: Added to device cache
        /dev/rwd2d: Added to device cache
      Loaded persistent filter cache from /etc/lvm/cache/.cache
        Closed /etc/lvm/cache/.cache
      Setting activation/reserved_stack to 256
      Setting activation/reserved_memory to 8192
      Setting activation/process_priority to -18
      Initialised format: lvm1
      Initialised format: pool
      Adding text format metadata dir: /etc/lvm/metadata
      Initialised format: lvm2
      global/format not found in config: defaulting to lvm2
        lvmcache: initialised VG #orphans_lvm1
        lvmcache: initialised VG #orphans_pool
        lvmcache: initialised VG #orphans_lvm2
      Initialised segtype: striped
      Initialised segtype: zero
      Initialised segtype: error
      Initialised segtype: free
      Initialised segtype: snapshot
      Initialised segtype: mirror
      Setting backup/retain_days to 30
      Setting backup/retain_min to 10
      Setting backup/archive_dir to /etc/lvm/archive
      Setting backup/backup_dir to /etc/lvm/backup
      global/fallback_to_lvm1 not found in config: defaulting to 0
        Parsing: lvcreate -s -L4M -n snap0 vg00/lv1
        Processing: lvcreate -s -L4M -n snap0 vg00/lv1
        O_DIRECT will be used
      Setting global/locking_type to 1
      File-based locking selected.
      Setting global/locking_dir to /var/lock/lvm
    Setting chunksize to 8 sectors.
      Getting target version for snapshot
dm_task_run
dmt type  version
Ioctl type  version---197
dm_task_run
dmt type  targets
Ioctl type  targets---4
      Getting target version for snapshot-origin
dm_task_run
dmt type  targets
Ioctl type  targets---4
    Setting logging type to disk
      Setting activation/mirror_region_size to 512
    Finding volume group "vg00"
      Locking /var/lock/lvm/V_vg00 WB
        Opened /dev/rwd0a RW O_DIRECT
        /dev/rwd0a: block size is 512 bytes
      /dev/rwd0a: No label detected
        Closed /dev/rwd0a
        Opened /dev/rwd0b RW O_DIRECT
        /dev/rwd0b: block size is 512 bytes
      /dev/rwd0b: lvm2 label detected
        lvmcache: /dev/rwd0b: now in VG #orphans_lvm2 (#orphans_lvm2)
  Incorrect metadata area header checksum
        Closed /dev/rwd0b
        Opened /dev/rwd0d RW O_DIRECT
        /dev/rwd0d: block size is 512 bytes
      /dev/rwd0d: No label detected
        Closed /dev/rwd0d
        Opened /dev/rwd1a RW O_DIRECT
        /dev/rwd1a: block size is 512 bytes
      /dev/rwd1a: lvm2 label detected
        lvmcache: /dev/rwd1a: now in VG #orphans_lvm2 (#orphans_lvm2)
        /dev/rwd1a: Found metadata at 23040 size 2899 (in area at 4096 size 192512) for vg00 (wbJxbs-22oG-1f2p-EbnP-ST2o-Xc25-R3ZMkr)
        lvmcache: /dev/rwd1a: now in VG vg00 with 1 mdas
        lvmcache: /dev/rwd1a: setting vg00 VGID to wbJxbs22oG1f2pEbnPST2oXc25R3ZMkr
        lvmcache: /dev/rwd1a: VG vg00: Set creation host to .
        Opened /dev/rwd1d RW O_DIRECT
        /dev/rwd1d: block size is 512 bytes
      /dev/rwd1d: No label detected
        Closed /dev/rwd1d
        Opened /dev/rwd2a RW O_DIRECT
        /dev/rwd2a: block size is 512 bytes
      /dev/rwd2a: lvm2 label detected
        lvmcache: /dev/rwd2a: now in VG #orphans_lvm2 (#orphans_lvm2)
        /dev/rwd2a: Found metadata at 23040 size 2899 (in area at 4096 size 192512) for vg00 (wbJxbs-22oG-1f2p-EbnP-ST2o-Xc25-R3ZMkr)
        lvmcache: /dev/rwd2a: now in VG vg00 (wbJxbs22oG1f2pEbnPST2oXc25R3ZMkr) with 1 mdas
        Opened /dev/rwd2d RW O_DIRECT
        /dev/rwd2d: block size is 512 bytes
      /dev/rwd2d: No label detected
        Closed /dev/rwd2d
        Opened /etc/lvm/metadata/vg00 RO
        Closed /etc/lvm/metadata/vg00
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read volume group vg00 from /etc/lvm/metadata/vg00
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Opened /etc/lvm/metadata/vg00 RO
        Closed /etc/lvm/metadata/vg00
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read volume group vg00 from /etc/lvm/metadata/vg00
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read vg00 metadata (10) from /dev/rwd1a at 23040 size 2899
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read vg00 metadata (10) from /dev/rwd2a at 23040 size 2899
        /dev/rwd1a 0:      0     12: NULL(0:0)
        /dev/rwd2a 0:      0      3: lv1(0:0)
        /dev/rwd2a 1:      3     21: NULL(0:0)
        Getting device info for vg00-lv1
dm_task_run
dmt type  info
Ioctl type  info---516
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---516
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---516
dm_task_get_info vg00-lv1 ---- 1
    Archiving volume group "vg00" metadata (seqno 10).
    Creating logical volume snap0
        Allowing allocation on /dev/rwd1a start PE 0 length 12
        Allowing allocation on /dev/rwd2a start PE 3 length 21
        /dev/rwd1a 0:      0     12: NULL(0:0)
        /dev/rwd2a 0:      0      3: lv1(0:0)
        /dev/rwd2a 1:      3      1: snap0(0:0)
        /dev/rwd2a 2:      4     20: NULL(0:0)
        Writing vg00 metadata to /etc/lvm/metadata/.lvm__291_1287895899
        Writing vg00 metadata to /dev/rwd1a at 26112 len 1319
        Writing vg00 metadata to /dev/rwd2a at 26112 len 1319
        Pre-Committing vg00 metadata (11) to /dev/rwd1a header at 4096
        Pre-Committing vg00 metadata (11) to /dev/rwd2a header at 4096
    Creating volume group backup "/etc/lvm/backup/vg00" (seqno 11).
        Writing vg00 metadata to /etc/lvm/backup/.lvm__291_1439608824
        Committing vg00 metadata (11)
        Renaming /etc/lvm/backup/vg00.tmp to /etc/lvm/backup/vg00
        Committing vg00 metadata (11)
        Renaming /etc/lvm/metadata/vg00.tmp to /etc/lvm/metadata/vg00
        Committing vg00 metadata (11) to /dev/rwd1a header at 4096
        Committing vg00 metadata (11) to /dev/rwd2a header at 4096
      Locking LV wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS (EX)
      Finding volume group for uuid wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Opened /etc/lvm/metadata/vg00 RO
        Closed /etc/lvm/metadata/vg00
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read volume group vg00 from /etc/lvm/metadata/vg00
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read vg00 metadata (11) from /dev/rwd1a at 26112 size 1319
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read vg00 metadata (11) from /dev/rwd2a at 26112 size 1319
    Found volume group "vg00"
        Getting device info for vg00-snap0
dm_task_run
dmt type  info
Ioctl type  info---516
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---516
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---516
dm_task_get_info vg00-snap0 ---- 0
      Locking memory
        memlock_count inc to 1
      Setting activation/missing_stripe_filler to /dev/ioerror
        Getting device info for vg00-snap0 [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0 ---- 0
        Getting device info for vg00-snap0-real [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS-real]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0-real ---- 0
        Getting device info for vg00-snap0-cow [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS-cow]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0-cow ---- 0
        Getting device info for vg00-snap0_mlog [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS-_mlog]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0_mlog ---- 0
_tree_action get root=snap0,
 dlib=LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS
_tree_action add lv->name snap0
vg00-snap0 --- Setting minor to 0 -1----1
        Checking kernel supports striped segment type for snap0
      Getting target version for linear
dm_task_run
dmt type  targets
Ioctl type  targets---4
      Getting target version for striped
dm_task_run
dmt type  targets
Ioctl type  targets---4
dm_preload_children here :(null) -- 0
0---0
dm_preload_children here :vg00-snap0 -- 0
-1----1
dm_preload_chidren end 
dm BBBBBB
Creating vg00-snap0dm_task_run
dmt type  create
Ioctl type  create---516
        vg00-snap0: Stacking NODE_ADD (169,2) 0:0 0600
dm_task_get_info vg00-snap0 ---- 1
_create_node 1
dm CCCCCC
    Loading vg00-snap0 table
        Adding target: 0 8192 linear /dev/wd2a 24960
dm_task_run
dmt type  reload
dm_task_run
dmt type  table
Ioctl type  table---20
dm_task_run
dmt type  reload
Ioctl type  reload---516
dm_task_get_info vg00-snap0 ---- 1
    Suppressed vg00-snap0 identical table reload.
dm DDDDD
dm_preload_chidren end 
        Getting device info for vg00-snap0 [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0 ---- 1
dm_task_run
dmt type  deps
Ioctl type  deps---4
dm_task_get_info  ---- 1
        Getting device info for vg00-snap0-real [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS-real]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0-real ---- 0
        Getting device info for vg00-snap0-cow [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS-cow]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0-cow ---- 0
        Getting device info for vg00-snap0_mlog [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS-_mlog]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0_mlog ---- 0
_tree_action get root=snap0,
 dlib=LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS
      Unlocking memory
        memlock_count dec to 0
        Created /dev/mapper/vg00-snap0
      Linking /dev/vg00/rsnap0 -> /dev/mapper/rvg00-snap0
      Linking /dev/vg00/snap0 -> /dev/mapper/vg00-snap0
    Clearing start of logical volume "snap0"
        /dev/vg00/snap0: Added to device cache
        Opened /dev/vg00/snap0 RW O_DIRECT
        Wiping /dev/vg00/snap0 at sector 0 length 8 sectors
        /dev/vg00/snap0: block size is 512 bytes
        Closed /dev/vg00/snap0
        /dev/rwd1a 0:      0     12: NULL(0:0)
        /dev/rwd2a 0:      0      3: lv1(0:0)
        /dev/rwd2a 1:      3      1: snap0(0:0)
        /dev/rwd2a 2:      4     20: NULL(0:0)
        Writing vg00 metadata to /etc/lvm/metadata/.lvm__291_342797521
        Writing vg00 metadata to /dev/rwd1a at 27648 len 1542
        Writing vg00 metadata to /dev/rwd2a at 27648 len 1542
        Pre-Committing vg00 metadata (12) to /dev/rwd1a header at 4096
        Pre-Committing vg00 metadata (12) to /dev/rwd2a header at 4096
      Locking LV wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrw09PV2xmC2Qn5Of0R6V9GRqm3w4Zv2na (W)
      Finding volume group for uuid wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrw09PV2xmC2Qn5Of0R6V9GRqm3w4Zv2na
      /dev/rwd1a: lvm2 label detected
        lvmcache: /dev/rwd1a: now in VG #orphans_lvm2 (#orphans_lvm2) with 1 mdas
        /dev/rwd1a: Found metadata at 26112 size 1319 (in area at 4096 size 192512) for vg00 (wbJxbs-22oG-1f2p-EbnP-ST2o-Xc25-R3ZMkr)
        lvmcache: /dev/rwd1a: now in VG vg00 (wbJxbs22oG1f2pEbnPST2oXc25R3ZMkr) with 1 mdas
      /dev/rwd2a: lvm2 label detected
        lvmcache: /dev/rwd2a: now in VG #orphans_lvm2 (#orphans_lvm2) with 1 mdas
        /dev/rwd2a: Found metadata at 26112 size 1319 (in area at 4096 size 192512) for vg00 (wbJxbs-22oG-1f2p-EbnP-ST2o-Xc25-R3ZMkr)
        lvmcache: /dev/rwd2a: now in VG vg00 (wbJxbs22oG1f2pEbnPST2oXc25R3ZMkr) with 1 mdas
        Opened /etc/lvm/metadata/vg00 RO
        Closed /etc/lvm/metadata/vg00
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read volume group vg00 from /etc/lvm/metadata/vg00
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read vg00 metadata (11) from /dev/rwd1a at 26112 size 1319
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read vg00 metadata (11) from /dev/rwd2a at 26112 size 1319
    Found volume group "vg00"
      Finding volume group for uuid wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrw09PV2xmC2Qn5Of0R6V9GRqm3w4Zv2na
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Opened /etc/lvm/metadata/vg00.tmp RO
        Closed /etc/lvm/metadata/vg00.tmp
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read volume group vg00 from /etc/lvm/metadata/vg00.tmp
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read vg00 pre-commit metadata (12) from /dev/rwd1a at 27648 size 1542
        Using cached label for /dev/rwd1a
        Using cached label for /dev/rwd2a
        Read vg00 pre-commit metadata (12) from /dev/rwd2a at 27648 size 1542
    Found volume group "vg00"
        Getting device info for vg00-lv1
dm_task_run
dmt type  info
Ioctl type  info---709
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---516
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---516
dm_task_get_info vg00-lv1 ---- 1
        Getting device info for vg00-lv1 [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrw09PV2xmC2Qn5Of0R6V9GRqm3w4Zv2na]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-lv1 ---- 1
dm_task_run
dmt type  deps
Ioctl type  deps---4
dm_task_get_info  ---- 1
        Getting device info for vg00-lv1-real [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrw09PV2xmC2Qn5Of0R6V9GRqm3w4Zv2na-real]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-lv1-real ---- 0
        Getting device info for vg00-lv1-cow [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrw09PV2xmC2Qn5Of0R6V9GRqm3w4Zv2na-cow]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-lv1-cow ---- 0
        Getting device info for vg00-lv1_mlog [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrw09PV2xmC2Qn5Of0R6V9GRqm3w4Zv2na-_mlog]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-lv1_mlog ---- 0
        Getting device info for vg00-snap0 [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0 ---- 1
dm_task_run
dmt type  deps
Ioctl type  deps---4
dm_task_get_info  ---- 1
        Getting device info for vg00-snap0-real [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS-real]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0-real ---- 0
        Getting device info for vg00-snap0-cow [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS-cow]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0-cow ---- 0
        Getting device info for vg00-snap0_mlog [LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrzR9ekPGWB61ZThm8yGHWdXDvPUeDcJeS-_mlog]
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info  ---- 0
dm_task_run
dmt type  info
Ioctl type  info---4
dm_task_get_info vg00-snap0_mlog ---- 0
_tree_action get root=lv1,
 dlib=LVM-wbJxbs22oG1f2pEbnPST2oXc25R3ZMkrw09PV2xmC2Qn5Of0R6V9GRqm3w4Zv2na
_tree_action add lv->name lv1
vg00-lv1 --- Setting minor to 0 -1----1
        Checking kernel supports striped segment type for lv1
vg00-lv1-real --- Setting minor to 0 0---0
        Checking kernel supports striped segment type for lv1-real
vg00-snap0 --- Setting minor to 0 -1----1
        Checking kernel supports snapshot segment type for snap0
vg00-snap0-cow --- Setting minor to 0 0---0
        Checking kernel supports snapshot segment type for snap0-cow
dm_preload_children here :(null) -- 0
0---0
dm_preload_children here :vg00-lv1 -- 0
-1----1
dm_preload_children here :vg00-lv1-real -- 0
0---0
dm_preload_chidren end 
dm BBBBBB
Creating vg00-lv1-realdm_task_run
dmt type  create
Ioctl type  create---516
        vg00-lv1-real: Stacking NODE_ADD (169,3) 0:0 0600
dm_task_get_info vg00-lv1-real ---- 1
_create_node 1
dm CCCCCC
    Loading vg00-lv1-real table
        Adding target: 0 24576 linear /dev/wd2a 384
dm_task_run
dmt type  reload
dm_task_run
dmt type  table
Ioctl type  table---20
dm_task_run
dmt type  reload
Ioctl type  reload---516
dm_task_get_info vg00-lv1-real ---- 1
    Suppressed vg00-lv1-real identical table reload.
dm DDDDD
dm EEEEEE
dm_preload_chidren end 
dm BBBBBB
Creating vg00-lv1dm_task_run
dmt type  create
Ioctl type  create---516
_do_dm_ioctl 17
_create_node 0
dm_preload_chidren end 
  Failed to suspend origin lv1
        Wiping pre-committed vg00 metadata from /dev/rwd1a header at 4096
        Wiping pre-committed vg00 metadata from /dev/rwd2a header at 4096
      Unlocking /var/lock/lvm/V_vg00
        Closed /dev/rwd1a
        Closed /dev/rwd2a
        Completed: lvcreate -s -L4M -n snap0 vg00/lv1
      Dumping persistent device cache to /etc/lvm/cache/.cache
      Locking /etc/lvm/cache/.cache (F_WRLCK, 3)
      Unlocking fd 5
    Wiping internal VG cache
        Created /dev/mapper/vg00-lv1-real
--Apple-Mail-19-416293067
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit




Regards

Adam.


--Apple-Mail-19-416293067--

--Apple-Mail-20-416293172
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFIi2IilIxPgX3Go0MRAo58AJ9sTmxX4Zp16lfH3M3FmtOeDvuQ4gCgzPRW
HgGz5gdn4+LJ7jnkLtrOuqU=
=9kvp
-----END PGP SIGNATURE-----

--Apple-Mail-20-416293172--


--===============0165494298==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0165494298==--
