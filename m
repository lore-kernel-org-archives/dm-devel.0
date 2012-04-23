From: Tarak Reddy <tarak.reddy@in.ibm.com>
Subject: device mapper / multipath
Date: Mon, 23 Apr 2012 22:15:58 +0530
Message-ID: <OF5CA12C90.9321E971-ON652579E9.005B82AE-652579E9.005C1A4E@in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: dm-devel@redhat.com, multipath@lists.linux.ibm.com
Cc: Malahal Naineni <naineni@us.ibm.com>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
List-Id: dm-devel.ids



Hello,

I am facing one issue on LVM & Multipath setup on scsi devices. This test
was running with blast and blast got hung after couple hours run. At this
particular time multipath -ll show as all paths are faulty even though
lsscsi command able to show attached devices and corresponding HBA was
online. This test was running with scsi_logging_level=6 and multipath is
not able to updates his paths as it complains "test unit ready" command is
not working on any of those paths.

I have collected the dump and I/O got blocked for device mapper devices not
for underlying scsi devices( as device mapper could able get which path it
can use from path selector in dm-multipath). Below has some debug logs.

What is device-mapper-multipth behavior on IO request already placed in
queue and going to be queued when no path is available or path went off? In
my case as paths were not available in b/w and I/O seems to blocked which
made application(blast) to be hung.

What might be the problem for multipath path_checker can fail with "TEST
UNIT READY" to the device when lsscsi command able to show the devices.


Logs
Test Loop 9 on device name /media/temp2/folder4 at 04/23/2012 08:54:18
   Loop Seed ... 0x00000B12
Created Directory /media/temp2/folder4/test0 rc = 0 at 04/23/2012 08:54:19
Created Directory /media/temp2/folder7/test1 rc = 0 at 04/23/2012 08:54:22
Created Directory /media/temp2/folder5/test1 rc = 0 at 04/23/2012 08:54:23
Copy Files complete to /media/temp2/folder9/test1 rc = 8995 at 04/23/2012
08:54:24
Comparing files in /media/temp2/folder9/test1
Copy Files complete to /media/temp2/folder2/test1 rc = 8995 at 04/23/2012
08:54:25
Comparing files in /media/temp2/folder2/test1
Created Directory /media/temp2/folder12/test1 rc = 0 at 04/23/2012 08:54:26
Compare Files complete to /media/temp2/folder8/test1 rc = 8991 at
04/23/2012 08:54:27
Compare Files complete to /media/temp2/folder2/test1 rc = 8991 at
04/23/2012 08:54:29
File write complete to /media/temp2/folder3/test0 at 04/23/2012 08:54:29
Verifying files in /media/temp2/folder3/test0
File write complete to /media/temp2/folder16/test0 at 04/23/2012 08:54:31
Verifying files in /media/temp2/folder16/test0
File write complete to /media/temp2/folder10/test0 at 04/23/2012 08:54:33
Verifying files in /media/temp2/folder10/test0
File write complete to /media/temp2/folder4/test0 at 04/23/2012 08:54:34
Verifying files in /media/temp2/folder4/test0

>>> Blast got hung here.

[root@r17lp48 tracing]# lsscsi
[0:0:10:1082933281]disk    IBM      2107900          .221  /dev/sdc
[0:0:10:1082998817]disk    IBM      2107900          .221  /dev/sdb
[0:0:10:1083129889]disk    IBM      2107900          .221  /dev/sdp
[1:0:14:1082933281]disk    IBM      2107900          .221  /dev/sdg
[1:0:14:1082998817]disk    IBM      2107900          .221  /dev/sdh
[1:0:14:1083064353]disk    IBM      2107900          .221  /dev/sdm
[1:0:14:1083129889]disk    IBM      2107900          .221  /dev/sdi
[1:0:15:1082933281]disk    IBM      2107900          .221  /dev/sdf
[1:0:15:1082998817]disk    IBM      2107900          .221  /dev/sdd
[1:0:15:1083064353]disk    IBM      2107900          .221  /dev/sdn

[root@r17lp48 ~]# ll /dev/mapper/
total 0
crw-rw---- 1 root root 10, 57 Apr 23 07:12 control
lrwxrwxrwx 1 root root      7 Apr 23 08:54 mpatha -> ../dm-3
lrwxrwxrwx 1 root root      7 Apr 23 08:54 mpathb -> ../dm-1
lrwxrwxrwx 1 root root      7 Apr 23 08:54 mpathc -> ../dm-0
lrwxrwxrwx 1 root root      7 Apr 23 08:53 mpathcp1 -> ../dm-4
lrwxrwxrwx 1 root root      7 Apr 23 08:53 mpathcp2 -> ../dm-5
lrwxrwxrwx 1 root root      7 Apr 23 08:53 mpathcp3 -> ../dm-6
lrwxrwxrwx 1 root root      8 Apr 23 08:53 mpathcp4 -> ../dm-11
lrwxrwxrwx 1 root root      7 Apr 23 08:35 mpathcp5 -> ../dm-8
lrwxrwxrwx 1 root root      7 Apr 23 08:47 mpathd -> ../dm-2
lrwxrwxrwx 1 root root      7 Apr 23 08:19 vg1-lvl1 -> ../dm-9
lrwxrwxrwx 1 root root      8 Apr 23 08:19 vg2-lvl2 -> ../dm-10
[root@r17lp48 ~]# multipath -ll
mpathd (36005076305ffc1ae000000000000218f) dm-2 IBM,2107900
size=10G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=enabled
  `- 1:0:14:1083129889 sdi   8:128 failed faulty running
mpathc (36005076305ffc1ae000000000000218c) dm-0 IBM,2107900
size=10G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=enabled
  |- 1:0:15:1082933281 sdf   8:80  failed faulty running
  |- 1:0:14:1082933281 sdg   8:96  failed faulty running
  `- 0:0:10:1082933281 sdc   8:32  failed faulty running
mpathb (36005076305ffc1ae000000000000218d) dm-1 IBM,2107900
size=10G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=enabled
  |- 1:0:14:1082998817 sdh   8:112 failed faulty running
  |- 1:0:15:1082998817 sdd   8:48  failed faulty running
  `- 0:0:10:1082998817 sdb   8:16  failed faulty running
mpatha (36005076305ffc1ae000000000000218e) dm-3 IBM,2107900
size=10G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=enabled
  |- 1:0:14:1083064353 sdm   8:192 failed faulty running
  `- 1:0:15:1083064353 sdn   8:208 failed faulty running

[root@r17lp48 tracing]# iostat 2
Linux 2.6.32 (r17lp48) 	Monday 23 April 2012 	_s390x_	(3 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.47    0.03    8.90   14.37   11.98   62.25

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
dasda             0.15         1.27         0.00       8424          0
dasdb             2.28        78.59        35.49     519408     234544
dm-0            144.55      2566.30      1009.85   16959878    6673792
dm-1            139.66     11001.47     12401.54   72705432   81958088
dm-2             59.63      6475.87      7295.55   42797058   48214080
dm-3            182.62     13842.21     14335.35   91479034   94738032
dm-4            112.47       647.30       252.47    4277840    1668520
dm-5            112.68       648.97       252.50    4288816    1668704
dm-6            110.17       628.97       252.42    4156680    1668168
dm-8            111.66       640.85       252.46    4235160    1668400
dasdc             0.13         1.09         0.04       7200        288
dm-9             10.69         0.23        85.25       1522     563416
dm-10          3539.75     24843.54     26750.16  164183474  176783760
sdd               0.05         4.84        12.09      32008      79904
sdg               0.05         1.21         0.00       8002          0
sdh               0.18         7.04        12.71      46504      83976
sdi               0.05         4.57         8.04      30224      53120
sdm               0.19         2.88        13.78      19032      91040
sdf               0.07         2.66         0.00      17584          0
sdn               0.15         3.07         7.51      20272      49648
dm-11             0.00         0.00         0.00         12          0
sdc               0.07         3.26         0.00      21560          0
sdb               2.67       279.33       161.89    1846040    1069912
sdp               0.00         0.01         0.00         96          0

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.00   85.31    0.00   14.69

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
dasda             0.00         0.00         0.00          0          0
dasdb             0.00         0.00         0.00          0          0
dm-0              0.00         0.00         0.00          0          0
dm-1              0.00         0.00         0.00          0          0
dm-2              0.00         0.00         0.00          0          0
dm-3              0.00         0.00         0.00          0          0
dm-4              0.00         0.00         0.00          0          0
dm-5              0.00         0.00         0.00          0          0
dm-6              0.00         0.00         0.00          0          0
dm-8              0.00         0.00         0.00          0          0
dasdc             0.00         0.00         0.00          0          0
dm-9              0.00         0.00         0.00          0          0
dm-10             0.00         0.00         0.00          0          0
sdd               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh               0.00         0.00         0.00          0          0
sdi               0.00         0.00         0.00          0          0
sdm               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdn               0.00         0.00         0.00          0          0
dm-11             0.00         0.00         0.00          0          0
sdc               0.00         0.00         0.00          0          0
sdb               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.00    0.00    0.17  107.99    0.00    0.00

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
dasda             0.00         0.00         0.00          0          0
dasdb             0.00         0.00         0.00          0          0
dm-0              0.00         0.00         0.00          0          0
dm-1              0.00         0.00         0.00          0          0
dm-2              0.00         0.00         0.00          0          0
dm-3              0.00         0.00         0.00          0          0
dm-4              0.00         0.00         0.00          0          0
dm-5              0.00         0.00         0.00          0          0
dm-6              0.00         0.00         0.00          0          0
dm-8              0.00         0.00         0.00          0          0
dasdc             0.00         0.00         0.00          0          0
dm-9              0.00         0.00         0.00          0          0
dm-10             0.00         0.00         0.00          0          0
sdd               0.00         0.00         0.00          0          0
sdg               0.00         0.00         0.00          0          0
sdh               0.00         0.00         0.00          0          0
sdi               0.00         0.00         0.00          0          0
sdm               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sdn               0.00         0.00         0.00          0          0
dm-11             0.00         0.00         0.00          0          0
sdc               0.00         0.00         0.00          0          0
sdb               0.00         0.00         0.00          0          0
sdp               0.00         0.00         0.00          0          0
[root@r17lp48 ~]# multipath -v 3 -ll
Apr 23 09:22:34 | ram0: device node name blacklisted
Apr 23 09:22:34 | ram1: device node name blacklisted
Apr 23 09:22:34 | ram2: device node name blacklisted
Apr 23 09:22:34 | ram3: device node name blacklisted
Apr 23 09:22:34 | ram4: device node name blacklisted
Apr 23 09:22:34 | ram5: device node name blacklisted
Apr 23 09:22:34 | ram6: device node name blacklisted
Apr 23 09:22:34 | ram7: device node name blacklisted
Apr 23 09:22:34 | ram8: device node name blacklisted
Apr 23 09:22:34 | ram9: device node name blacklisted
Apr 23 09:22:34 | ram10: device node name blacklisted
Apr 23 09:22:34 | ram11: device node name blacklisted
Apr 23 09:22:34 | ram12: device node name blacklisted
Apr 23 09:22:34 | ram13: device node name blacklisted
Apr 23 09:22:34 | ram14: device node name blacklisted
Apr 23 09:22:34 | ram15: device node name blacklisted
Apr 23 09:22:34 | loop0: device node name blacklisted
Apr 23 09:22:34 | loop1: device node name blacklisted
Apr 23 09:22:34 | loop2: device node name blacklisted
Apr 23 09:22:34 | loop3: device node name blacklisted
Apr 23 09:22:34 | loop4: device node name blacklisted
Apr 23 09:22:34 | loop5: device node name blacklisted
Apr 23 09:22:34 | loop6: device node name blacklisted
Apr 23 09:22:34 | loop7: device node name blacklisted
Apr 23 09:22:34 | dasda: not found in pathvec
Apr 23 09:22:34 | dasda: mask = 0x5
Apr 23 09:22:34 | dasda: dev_t = 94:0
Apr 23 09:22:34 | dasda: size = 14424480
Apr 23 09:22:34 | dasda: subsystem = ccw
Apr 23 09:22:34 | dasda: vendor = IBM
Apr 23 09:22:34 | dasda: product = S/390 DASD ECKD
Apr 23 09:22:34 | dasda: h:b:t:l = 0:0:13211:0
Apr 23 09:22:34 | dasda: get_state
Apr 23 09:22:34 | dasda: path checker = directio (controller setting)
Apr 23 09:22:34 | dasda: checker timeout = 300000 ms (internal default)
Apr 23 09:22:34 | directio: starting new request
Apr 23 09:22:34 | directio: io finished 4096/0
Apr 23 09:22:34 | dasda: state = 3
Apr 23 09:22:34 | dasdb: not found in pathvec
Apr 23 09:22:34 | dasdb: mask = 0x5
Apr 23 09:22:34 | dasdb: dev_t = 94:4
Apr 23 09:22:34 | dasdb: size = 14424480
Apr 23 09:22:34 | dasdb: subsystem = ccw
Apr 23 09:22:34 | dasdb: vendor = IBM
Apr 23 09:22:34 | dasdb: product = S/390 DASD ECKD
Apr 23 09:22:34 | dasdb: h:b:t:l = 0:0:13208:0
Apr 23 09:22:34 | dasdb: get_state
Apr 23 09:22:34 | dasdb: path checker = directio (controller setting)
Apr 23 09:22:34 | dasdb: checker timeout = 300000 ms (internal default)
Apr 23 09:22:34 | directio: starting new request
Apr 23 09:22:34 | directio: io finished 4096/0
Apr 23 09:22:34 | dasdb: state = 3
Apr 23 09:22:34 | dm-11: device node name blacklisted
Apr 23 09:22:34 | dm-0: device node name blacklisted
Apr 23 09:22:34 | dm-1: device node name blacklisted
Apr 23 09:22:34 | dm-2: device node name blacklisted
Apr 23 09:22:34 | dm-3: device node name blacklisted
Apr 23 09:22:34 | dm-4: device node name blacklisted
Apr 23 09:22:34 | dm-5: device node name blacklisted
Apr 23 09:22:34 | dm-6: device node name blacklisted
Apr 23 09:22:34 | dm-8: device node name blacklisted
Apr 23 09:22:34 | sdp: not found in pathvec
Apr 23 09:22:34 | sdp: mask = 0x5
Apr 23 09:22:34 | sdp: dev_t = 8:240
Apr 23 09:22:34 | sdp: size = 20971520
Apr 23 09:22:34 | sdp: subsystem = scsi
Apr 23 09:22:34 | sdp: vendor = IBM
Apr 23 09:22:34 | sdp: product = 2107900
Apr 23 09:22:34 | sdp: rev = .221
Apr 23 09:22:34 | sdp: h:b:t:l = 0:0:10:1083129889
Apr 23 09:22:34 | sdp: tgt_node_name = 0xffffffffffffffff
Apr 23 09:22:34 | sdp: get_state
Apr 23 09:22:34 | loading /lib64/multipath/libchecktur.so checker
Apr 23 09:22:34 | sdp: path checker = tur (controller setting)
Apr 23 09:22:34 | sdp: checker timeout = 30000 ms (sysfs setting)
Apr 23 09:22:34 | sdp: state = running
Apr 23 09:22:34 | sdp: state = 2
Apr 23 09:22:34 | sdp: checker msg is "tur checker reports path is down"
Apr 23 09:22:34 | sdd: not found in pathvec
Apr 23 09:22:34 | sdd: mask = 0x5
Apr 23 09:22:34 | sdd: dev_t = 8:48
Apr 23 09:22:34 | sdd: size = 20971520
Apr 23 09:22:34 | sdd: subsystem = scsi
Apr 23 09:22:34 | sdd: vendor = IBM
Apr 23 09:22:34 | sdd: product = 2107900
Apr 23 09:22:34 | sdd: rev = .221
Apr 23 09:22:34 | sdd: h:b:t:l = 1:0:15:1082998817
Apr 23 09:22:34 | sdd: tgt_node_name = 0xffffffffffffffff
Apr 23 09:22:34 | sdd: get_state
Apr 23 09:22:34 | sdd: path checker = tur (controller setting)
Apr 23 09:22:34 | sdd: checker timeout = 30000 ms (sysfs setting)
Apr 23 09:22:34 | sdd: state = running
Apr 23 09:22:34 | sdd: state = 2
Apr 23 09:22:34 | sdd: checker msg is "tur checker reports path is down"
Apr 23 09:22:34 | sdg: not found in pathvec
Apr 23 09:22:34 | sdg: mask = 0x5
Apr 23 09:22:34 | sdg: dev_t = 8:96
Apr 23 09:22:34 | sdg: size = 20971520
Apr 23 09:22:34 | sdg: subsystem = scsi
Apr 23 09:22:34 | sdg: vendor = IBM
Apr 23 09:22:34 | sdg: product = 2107900
Apr 23 09:22:34 | sdg: rev = .221
Apr 23 09:22:34 | sdg: h:b:t:l = 1:0:14:1082933281
Apr 23 09:22:34 | sdg: tgt_node_name = 0xffffffffffffffff
Apr 23 09:22:34 | sdg: get_state
Apr 23 09:22:34 | sdg: path checker = tur (controller setting)
Apr 23 09:22:34 | sdg: checker timeout = 30000 ms (sysfs setting)
Apr 23 09:22:34 | sdg: state = running
Apr 23 09:22:34 | sdg: state = 2
Apr 23 09:22:34 | sdg: checker msg is "tur checker reports path is down"
Apr 23 09:22:34 | sdh: not found in pathvec
Apr 23 09:22:34 | sdh: mask = 0x5
Apr 23 09:22:34 | sdh: dev_t = 8:112
Apr 23 09:22:34 | sdh: size = 20971520
Apr 23 09:22:34 | sdh: subsystem = scsi
Apr 23 09:22:34 | sdh: vendor = IBM
Apr 23 09:22:34 | sdh: product = 2107900
Apr 23 09:22:34 | sdh: rev = .221
Apr 23 09:22:34 | sdh: h:b:t:l = 1:0:14:1082998817
Apr 23 09:22:34 | sdh: tgt_node_name = 0xffffffffffffffff
Apr 23 09:22:34 | sdh: get_state
Apr 23 09:22:34 | sdh: path checker = tur (controller setting)
Apr 23 09:22:34 | sdh: checker timeout = 30000 ms (sysfs setting)
Apr 23 09:22:34 | sdh: state = running
Apr 23 09:22:34 | sdh: state = 2
Apr 23 09:22:34 | sdh: checker msg is "tur checker reports path is down"
Apr 23 09:22:34 | sdi: not found in pathvec
Apr 23 09:22:34 | sdi: mask = 0x5
Apr 23 09:22:34 | sdi: dev_t = 8:128
Apr 23 09:22:34 | sdi: size = 20971520
Apr 23 09:22:34 | sdi: subsystem = scsi
Apr 23 09:22:34 | sdi: vendor = IBM
Apr 23 09:22:34 | sdi: product = 2107900
Apr 23 09:22:34 | sdi: rev = .221
Apr 23 09:22:34 | sdi: h:b:t:l = 1:0:14:1083129889
Apr 23 09:22:34 | sdi: tgt_node_name = 0xffffffffffffffff
Apr 23 09:22:34 | sdi: get_state
Apr 23 09:22:34 | sdi: path checker = tur (controller setting)
Apr 23 09:22:34 | sdi: checker timeout = 30000 ms (sysfs setting)
Apr 23 09:22:34 | sdi: state = running
Apr 23 09:22:34 | sdi: state = 2
Apr 23 09:22:34 | sdi: checker msg is "tur checker reports path is down"
Apr 23 09:22:34 | sdm: not found in pathvec
Apr 23 09:22:34 | sdm: mask = 0x5
Apr 23 09:22:34 | sdm: dev_t = 8:192
Apr 23 09:22:34 | sdm: size = 20971520
Apr 23 09:22:34 | sdm: subsystem = scsi
Apr 23 09:22:34 | sdm: vendor = IBM
Apr 23 09:22:34 | sdm: product = 2107900
Apr 23 09:22:34 | sdm: rev = .221
Apr 23 09:22:34 | sdm: h:b:t:l = 1:0:14:1083064353
Apr 23 09:22:34 | sdm: tgt_node_name = 0xffffffffffffffff
Apr 23 09:22:34 | sdm: get_state
Apr 23 09:22:34 | sdm: path checker = tur (controller setting)
Apr 23 09:22:34 | sdm: checker timeout = 30000 ms (sysfs setting)
Apr 23 09:22:34 | sdm: state = running
Apr 23 09:22:34 | sdm: state = 2
Apr 23 09:22:34 | sdm: checker msg is "tur checker reports path is down"
Apr 23 09:22:34 | dasdc: not found in pathvec
Apr 23 09:22:34 | dasdc: mask = 0x5
Apr 23 09:22:34 | dasdc: dev_t = 94:8
Apr 23 09:22:34 | dasdc: size = 14424480
Apr 23 09:22:34 | dasdc: subsystem = ccw
Apr 23 09:22:34 | dasdc: vendor = IBM
Apr 23 09:22:34 | dasdc: product = S/390 DASD ECKD
Apr 23 09:22:34 | dasdc: h:b:t:l = 0:0:13209:0
Apr 23 09:22:34 | dasdc: get_state
Apr 23 09:22:34 | dasdc: path checker = directio (controller setting)
Apr 23 09:22:34 | dasdc: checker timeout = 300000 ms (internal default)
Apr 23 09:22:34 | directio: starting new request
Apr 23 09:22:34 | directio: io finished 4096/0
Apr 23 09:22:34 | dasdc: state = 3
Apr 23 09:22:34 | sdf: not found in pathvec
Apr 23 09:22:34 | sdf: mask = 0x5
Apr 23 09:22:34 | sdf: dev_t = 8:80
Apr 23 09:22:34 | sdf: size = 20971520
Apr 23 09:22:34 | sdf: subsystem = scsi
Apr 23 09:22:34 | sdf: vendor = IBM
Apr 23 09:22:34 | sdf: product = 2107900
Apr 23 09:22:34 | sdf: rev = .221
Apr 23 09:22:34 | sdf: h:b:t:l = 1:0:15:1082933281
Apr 23 09:22:34 | sdf: tgt_node_name = 0xffffffffffffffff
Apr 23 09:22:34 | sdn: not found in pathvec
Apr 23 09:22:34 | sdn: mask = 0x5
Apr 23 09:22:34 | sdn: dev_t = 8:208
Apr 23 09:22:34 | sdn: size = 20971520
Apr 23 09:22:34 | sdn: subsystem = scsi
Apr 23 09:22:34 | sdn: vendor = IBM
Apr 23 09:22:34 | sdn: product = 2107900
Apr 23 09:22:34 | sdn: rev = .221
Apr 23 09:22:34 | sdn: h:b:t:l = 1:0:15:1083064353
Apr 23 09:22:34 | sdn: tgt_node_name = 0xffffffffffffffff
Apr 23 09:22:34 | sdn: get_state
Apr 23 09:22:34 | sdn: path checker = tur (controller setting)
Apr 23 09:22:34 | sdn: checker timeout = 30000 ms (sysfs setting)
Apr 23 09:22:34 | sdn: state = running
Apr 23 09:22:34 | sdn: state = 2
Apr 23 09:22:34 | sdn: checker msg is "tur checker reports path is down"
Apr 23 09:22:34 | sdc: not found in pathvec
Apr 23 09:22:34 | sdc: mask = 0x5
Apr 23 09:22:34 | sdc: dev_t = 8:32
Apr 23 09:22:34 | sdc: size = 20971520
Apr 23 09:22:34 | sdc: subsystem = scsi
Apr 23 09:22:34 | sdc: vendor = IBM
Apr 23 09:22:34 | sdc: product = 2107900
Apr 23 09:22:34 | sdc: rev = .221
Apr 23 09:22:34 | sdc: h:b:t:l = 0:0:10:1082933281
Apr 23 09:22:34 | sdc: tgt_node_name = 0xffffffffffffffff
Apr 23 09:22:34 | sdc: get_state
Apr 23 09:22:34 | sdc: path checker = tur (controller setting)
Apr 23 09:22:34 | sdc: checker timeout = 30000 ms (sysfs setting)
Apr 23 09:22:34 | sdc: state = running
Apr 23 09:22:34 | sdc: state = 2
Apr 23 09:22:34 | sdc: checker msg is "tur checker reports path is down"
Apr 23 09:22:34 | sdb: not found in pathvec
Apr 23 09:22:34 | sdb: mask = 0x5
Apr 23 09:22:34 | sdb: dev_t = 8:16
Apr 23 09:22:34 | sdb: size = 20971520
Apr 23 09:22:34 | sdb: subsystem = scsi
Apr 23 09:22:34 | sdb: vendor = IBM
Apr 23 09:22:34 | sdb: product = 2107900
Apr 23 09:22:34 | sdb: rev = .221
Apr 23 09:22:34 | sdb: h:b:t:l = 0:0:10:1082998817
Apr 23 09:22:34 | sdb: tgt_node_name = 0xffffffffffffffff
Apr 23 09:22:34 | sdb: get_state
Apr 23 09:22:34 | sdb: path checker = tur (controller setting)
Apr 23 09:22:34 | sdb: checker timeout = 30000 ms (sysfs setting)
Apr 23 09:22:34 | sdb: state = running
Apr 23 09:22:34 | sdb: state = 2
Apr 23 09:22:34 | sdb: checker msg is "tur checker reports path is down"
Apr 23 09:22:34 | dm-9: device node name blacklisted
Apr 23 09:22:34 | dm-10: device node name blacklisted
===== paths list =====
uuid hcil              dev   dev_t pri dm_st chk_st vend/prod/rev
dev_st
     0:0:13211:0       dasda 94:0  -1  undef ready  IBM,S/390 DASD ECKD
runnin
     0:0:13208:0       dasdb 94:4  -1  undef ready  IBM,S/390 DASD ECKD
runnin
     0:0:10:1083129889 sdp   8:240 -1  undef faulty IBM,2107900
runnin
     1:0:15:1082998817 sdd   8:48  -1  undef faulty IBM,2107900
runnin
     1:0:14:1082933281 sdg   8:96  -1  undef faulty IBM,2107900
runnin
     1:0:14:1082998817 sdh   8:112 -1  undef faulty IBM,2107900
runnin
     1:0:14:1083129889 sdi   8:128 -1  undef faulty IBM,2107900
runnin
     1:0:14:1083064353 sdm   8:192 -1  undef faulty IBM,2107900
runnin
     0:0:13209:0       dasdc 94:8  -1  undef ready  IBM,S/390 DASD ECKD
runnin
     1:0:15:1082933281 sdf   8:80  -1  undef faulty IBM,2107900
runnin
     1:0:15:1083064353 sdn   8:208 -1  undef faulty IBM,2107900
runnin
     0:0:10:1082933281 sdc   8:32  -1  undef faulty IBM,2107900
runnin
     0:0:10:1082998817 sdb   8:16  -1  undef faulty IBM,2107900
runnin
Apr 23 09:22:34 | params = 1 queue_if_no_path 0 1 1 round-robin 0 1 1 8:128
1
Apr 23 09:22:34 | status = 2 192 0 0 1 1 E 0 1 0 8:128 F 1
Apr 23 09:22:34 | sdi: mask = 0x8
Apr 23 09:22:34 | sdi: state = running
Apr 23 09:22:34 | sdi: prio = const (controller setting)
Apr 23 09:22:34 | sdi: const prio = 1
mpathd (36005076305ffc1ae000000000000218f) dm-2 IBM,2107900
size=10G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=enabled
  `- 1:0:14:1083129889 sdi   8:128 failed faulty running
Apr 23 09:22:34 | params = 1 queue_if_no_path 0 1 1 round-robin 0 3 1 8:80
1 8:96 1 8:32 1
Apr 23 09:22:34 | status = 2 11 0 0 1 1 E 0 3 0 8:80 F 1 8:96 F 1 8:32 F 1
Apr 23 09:22:34 | sdf: mask = 0x8
Apr 23 09:22:34 | sdg: mask = 0x8
Apr 23 09:22:34 | sdg: state = running
Apr 23 09:22:34 | sdg: prio = const (controller setting)
Apr 23 09:22:34 | sdg: const prio = 1
Apr 23 09:22:34 | sdc: mask = 0x8
Apr 23 09:22:34 | sdc: state = running
Apr 23 09:22:34 | sdc: prio = const (controller setting)
Apr 23 09:22:34 | sdc: const prio = 1
mpathc (36005076305ffc1ae000000000000218c) dm-0 IBM,2107900
size=10G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=enabled
  |- 1:0:15:1082933281 sdf   8:80  failed faulty running
  |- 1:0:14:1082933281 sdg   8:96  failed faulty running
  `- 0:0:10:1082933281 sdc   8:32  failed faulty running
Apr 23 09:22:34 | params = 1 queue_if_no_path 0 1 1 round-robin 0 3 1 8:112
1 8:48 1 8:16 1
Apr 23 09:22:34 | status = 2 202 0 0 1 1 E 0 3 0 8:112 F 1 8:48 F 1 8:16 F
1
Apr 23 09:22:34 | sdh: mask = 0x8
Apr 23 09:22:34 | sdh: state = running
Apr 23 09:22:34 | sdh: prio = const (controller setting)
Apr 23 09:22:34 | sdh: const prio = 1
Apr 23 09:22:34 | sdd: mask = 0x8
Apr 23 09:22:34 | sdd: state = running
Apr 23 09:22:34 | sdd: prio = const (controller setting)
Apr 23 09:22:34 | sdd: const prio = 1
Apr 23 09:22:34 | sdb: mask = 0x8
Apr 23 09:22:34 | sdb: state = running
Apr 23 09:22:34 | sdb: prio = const (controller setting)
Apr 23 09:22:34 | sdb: const prio = 1
mpathb (36005076305ffc1ae000000000000218d) dm-1 IBM,2107900
size=10G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=enabled
  |- 1:0:14:1082998817 sdh   8:112 failed faulty running
  |- 1:0:15:1082998817 sdd   8:48  failed faulty running
  `- 0:0:10:1082998817 sdb   8:16  failed faulty running
Apr 23 09:22:34 | params = 1 queue_if_no_path 0 1 1 round-robin 0 2 1 8:192
1 8:208 1
Apr 23 09:22:34 | status = 2 195 0 0 1 1 E 0 2 0 8:192 F 1 8:208 F 1
Apr 23 09:22:34 | sdm: mask = 0x8
Apr 23 09:22:34 | sdm: state = running
Apr 23 09:22:34 | sdm: prio = const (controller setting)
Apr 23 09:22:34 | sdm: const prio = 1
Apr 23 09:22:34 | sdn: mask = 0x8
Apr 23 09:22:34 | sdn: state = running
Apr 23 09:22:34 | sdn: prio = const (controller setting)
Apr 23 09:22:34 | sdn: const prio = 1
mpatha (36005076305ffc1ae000000000000218e) dm-3 IBM,2107900
size=10G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=enabled
  |- 1:0:14:1083064353 sdm   8:192 failed faulty running
  `- 1:0:15:1083064353 sdn   8:208 failed faulty running
crash> dev -d
MAJOR GENDISK            NAME       REQUEST QUEUE      TOTAL ASYNC  SYNC
DRV
   94 0xfc465800         dasda      0xedd1ee60             0     0     0
0
   94 0xebedd400         dasdb      0xf44e2f60             0     0     0
0
   94 0xfc541400         dasdc      0xedd1e338             0     0     0
0
  253 0xfc46cc00         dm-0       0xf3390438            15     3    12
15
  253 0xeba87c00         dm-1       0xec441060             4     0     4
4
  253 0xf3ab1c00         dm-2       0xec440538             3     0     3
3
  253 0xf4fd4400         dm-3       0xeb5d1160           146   128    18
146
  253 0xf4b34c00         dm-4       0xec5a5260             0     0     0
0
  253 0xee7df400         dm-5       0xec5a4738             0     0     0
0
  253 0xfc407c00         dm-6       0xeb5d0638             0     0     0
0
  253 0xf9383c00         dm-7       0xee7f9360             0     0     0
0
  253 0xfbe38000         dm-8       0xee7f8838             0     0     0
0
  253 0xfc47e800         dm-9       0xed1fcb60             0     0     0
0
  253 0xee7dfc00         dm-10      0xed1fc038             0     0     0
0
    8 0x1fa9e000         sdb        0xf1aa4f60             0     0     0
0
    8 0x15d91c00         sda        0x7230538              0     0     0
0
    8 0x8b5e0000         sdc        0xdaab5260             0     0     0
0
    8 0xc9753000         sde        0xc0e6a038             0     0     0
0
    8 0xfc455400         sdg        0x5de0c738             0     0     0
0
    8 0x85f3e800         sdd        0xc0e6ab60             0     0     0
0
    8 0x46d6400          sdj        0x52f8a138             0     0     0
0
    8 0x5bee9400         sdl        0xd45cc238             0     0     0
0
    8 0x7e0d2400         sdm        0xe504e60              0     0     0
0
    8 0x11a44400         sdn        0xe504338              0     0     0
0
    8 0x5f796000         sdp        0x6c504438             0     0     0
0
    8 0xfbf2f800         sdo        0x6c504f60             0     0     0
0
    8 0xf89d9400         sdi        0x52f8ac60             0     0     0
0
    8 0x1ac24400         sdk        0xd45ccd60             0     0     0
0
    8 0x85cb0400         sdh        0x3c94838              0     0     0
0
    8 0x845c400          sdf        0xeb640e60             0     0     0
0
crash>
