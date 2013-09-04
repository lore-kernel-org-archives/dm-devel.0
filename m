From: Ross Anderson <rosander@dsotm.net>
Subject: multipath 4k partition block issues.
Date: Wed, 04 Sep 2013 16:01:53 -0500
Message-ID: <52279FC1.4000707@dsotm.net>
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

Greetings,


The current git version of multipath-tools doesn't properly handle 4k 
block sizes and partions creation. There very little verbose output but 
I will post what I can find. I would appreciate any help getting this 
working.

The raw devices detect the 4k partition.

A manual run of kpartx -a creates the dm points.

Thanks for the assistance,
Ross

##Log Errors w/multipathd -v4
[   15.760507] sd 8:0:1:2: [sdn] Attached SCSI disk
[   15.760709]  sdp: sdp1 sdp2
[   15.760781] sd 7:0:1:2: [sdq] 681574400 4096-byte logical blocks: 
(2.79 TB/2.53 TiB)
[   15.760854] sd 7:0:1:1: [sdo] Attached SCSI disk
[   15.760953] sd 8:0:1:3: [sdp] 57671680 4096-byte logical blocks: (236 
GB/220 GiB)
[   15.761056] sd 7:0:1:0: [sdm] Attached SCSI disk
[   15.761484] sd 7:0:1:2: [sdq] Attached SCSI disk
[   15.761496] sd 8:0:1:3: [sdp] Attached SCSI disk
[   15.762166]  sdr: sdr1 sdr2
[   15.762400] sd 7:0:1:3: [sdr] 57671680 4096-byte logical blocks: (236 
GB/220 GiB)
[   15.762935] sd 7:0:1:3: [sdr] Attached SCSI disk
[   36.699314] device-mapper: table: 253:6: multipath: error getting device
[   36.699318] device-mapper: ioctl: error adding target to table
[   36.699709] device-mapper: table: 253:6: multipath: error getting device
[   36.699711] device-mapper: ioctl: error adding target to table
  [multipathd] emc-test: load table [0 114224640 multipath 1 
queue_if_no_path 0 1 1 service-time 0 2 1 8:112 4 8:96 4]_
  [multipathd] emc-bak: load table [0 8239795200 multipath 1 
queue_if_no_path 0 1 1 service-time 0 2 1 8:160 4 8:128 4]_
  [multipathd] sfx4k: load table [0 165076992 multipath 0 0 1 1 
service-time 0 2 1 8:192 4 8:144 4]_
  [multipathd] general: load table [0 1258291200 multipath 0 0 1 1 
service-time 0 2 1 8:224 4 8:176 4]_
  [multipathd] audio: load table [0 5452595200 multipath 0 0 1 1 
service-time 0 2 1 65:0 4 8:208 4]_
  [multipathd] samplelib: load table [0 461373440 multipath 0 0 1 1 
service-time 0 2 1 65:16 4 8:240 4]_
  [multipathd] ST3250310AS_5RY18PMP: ignoring map_
  [multipathd] emc-test: event checker started_
[multipathd] emc-bak: event checker started_
  [multipathd] sfx4k: event checker started_
  [multipathd] general: event checker started_
[multipathd] audio: event checker started_
  [multipathd] samplelib: event checker started_
  [multipathd] path checkers start up_
  [   36.699314] device-mapper: table: 253:6: multipath: error getting 
device
  [   36.699318] device-mapper: ioctl: error adding target to table
  [   36.699709] device-mapper: table: 253:6: multipath: error getting 
device
  [   36.699711] device-mapper: ioctl: error adding target to table
  [multipathd] sdr: ownership set to samplelib_
  [multipathd] sdr: not found in pathvec_
  [multipathd] sdr: mask = 0xc_
  [multipathd] sdr: path state = running__
  [multipathd] sdr: get_state_
  [multipathd] uevent 'add' from '/devices/virtual/block/dm-3'_
  [multipathd] sdr: state = up_
  [multipathd] sdr: const prio = 1_
  [multipathd] sdp: ownership set to samplelib_
  [multipathd] sdp: not found in pathvec_
  [multipathd] sdp: mask = 0xc_
  [multipathd] sdp: path state = running__
  [multipathd] sdp: get_state_
  [multipathd] sdp: state = up_
  [multipathd] sdp: const prio = 1_
  [multipathd] samplelib: pgfailback = -2 (config file default)_
  [multipathd] samplelib: pgpolicy = multibus (config file default)_
  [multipathd] samplelib: selector = service-time 0 (LUN setting)_
[multipathd] samplelib: features = 0 (config file default)_
  [multipathd] samplelib: hwhandler = 0 (internal default)_
  [multipathd] samplelib: rr_weight = 2 (LUN setting)_
  [multipathd] samplelib: minio = 4 rq (config file default)_
  [multipathd] samplelib: no_path_retry = -1 (config file default)_
  [multipathd] mode = 0644 (config file default)_
  [multipathd] uid = 0 (config file default)_
  [multipathd] samplelib: fast_io_fail_tmo = 5 (config file default)_
  [multipathd] samplelib: retain_attached_hw_handler = 1 (config file 
default)_
  [multipathd] samplelib: remove queue_if_no_path from '0'_
  [multipathd] samplelib: assembled map [0 0 1 1 service-time 0 2 1 
65:16 4 8:240 4]_
[multipathd] samplelib: set ACT_CREATE (map does not exist)_
  [multipathd] uevent 'add' from '/devices/virtual/block/dm-4'_
  [multipathd] samplelib: load table [0 461373440 multipath 0 0 1 1 
service-time 0 2 1 65:16 4 8:240 4]_
  [multipathd] samplelib: unset queue_if_no_path feature_
  [multipathd] samplelib: discover_
  [multipathd] samplelib: disassemble map [0 0 1 1 service-time 0 2 2 
65:16 4 1 8:240 4 1 ]_
  [multipathd] samplelib: disassemble status [2 0 0 0 1 1 A 0 2 2 65:16 
A 0 4096 1 8:240 A 0 0 1 ]_
  [multipathd] uevent 'add' from '/devices/virtual/block/dm-6'_
  [multipathd] uevent 'remove' from '/devices/virtual/block/dm-6'_


##Kpart output
  kpartx -v /dev/mapper/samplelib
samplelib1 : 0 262144 /dev/mapper/samplelib 48
samplelib2 : 0 461107200 /dev/mapper/samplelib 264192

## /dev/mapper/
ls -l
total 0
brw-r--r-- 1 root root 253,   4 Sep  4 15:40 audio
crw------- 1 root root  10, 236 Sep  4 15:38 control
brw-r--r-- 1 root root 253,   1 Sep  4 15:40 emc-bak
brw-r--r-- 1 root root 253,   0 Sep  4 15:40 emc-test
brw-r--r-- 1 root root 253,   3 Sep  4 15:40 general
brw-r--r-- 1 root root 253,   5 Sep  4 15:40 samplelib
brw-r--r-- 1 root root 253,   2 Sep  4 15:40 sfx4k

## output after kpartx -a of each 4k device.
brw-r--r-- 1 root root 253,   4 Sep  4 15:40 audio
crw------- 1 root root  10, 236 Sep  4 15:38 control
brw-r--r-- 1 root root 253,   1 Sep  4 15:40 emc-bak
brw-r--r-- 1 root root 253,   0 Sep  4 15:40 emc-test
brw-r--r-- 1 root root 253,   3 Sep  4 15:40 general
brw-r--r-- 1 root root 253,   5 Sep  4 15:40 samplelib
brw-r--r-- 1 root root 253,   9 Sep  4 15:52 samplelib1
brw------- 1 root root 253,   6 Sep  4 15:51 samplelib2
brw-r--r-- 1 root root 253,   2 Sep  4 15:40 sfx4k
brw-r--r-- 1 root root 253,   7 Sep  4 15:52 sfx4k1
brw-r--r-- 1 root root 253,   8 Sep  4 15:52 sfx4k2
