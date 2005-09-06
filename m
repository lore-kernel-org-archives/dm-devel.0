From: gistolero@gmx.de
Subject: Re: Re: Problems with multipathd
Date: Tue, 06 Sep 2005 18:46:14 +0200
Message-ID: <431DC7D6.1010900@gmx.de>
References: <20050831152928.GA53290@sysconfig.de>
	<1125518162.6375.52.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1125518162.6375.52.camel@zezette>
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

Hi,

 > Also know the 0.4.5 snapshots are largely better suited to the task.
 > Consider upgrading.

Now, I use multipath-tools-0.4.5, udev-068 and device-mapper-1.01.03.


 > Lower the timeouts in your Qlogic driver.

===> I found some settings in /sys/module/qla2xxx/parameters/...,
but most of them are read-only values. I have changed ql2xretrycount
and ql2xsuspendcount but without success. Any suggestions for
this driver?


I.) --- udev and udevstart ---


 > Default udev.rules file has a directive to ignore dm-*
 > Something like :
 > KERNEL=="dm-[0-9]*", OPTIONS+="ignore_device"
 >
 > /etc/udev/rules.d/20-multipath.rules is useless unless you you comment
 > out this rule.

I have commented this line, but udev still has difficulties to create this
links. Therefore I have changed /etc/dev.d/block/multipath.dev (the script
is attached at the end of this post) and added debug messages. The most
important modification is that kpartx uses the block-device-files in
/dev/mapper/... instead of /dev/...
===> Why isn't that the default? Are there any disadvantages?


testhalde2 ~ # multipath /dev/sda
create: 150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0
  \_ 0:0:0:1 sda 8:0  [ready]
  \_ 1:0:0:1 sdb 8:16 [ready]

testhalde2 ~ # multipath -ll
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:1 sda 8:0  [active][ready]
  \_ 1:0:0:1 sdb 8:16 [active][ready]

testhalde2 ~ # dmsetup table
150gb1: 0 64197 linear 254:0 63
150gb: 0 314572800 multipath 0 0 1 1 round-robin 0 2 1 8:0 1000 8:16 1000
150gb2: 0 314504505 linear 254:0 64260

testhalde2 ~ # ls -lF /dev/mapper/
total 0
brw-------  1 root root 254,  0 Sep  6 15:04 150gb
brw-------  1 root root 254,  1 Sep  6 15:04 150gb1
brw-------  1 root root 254,  2 Sep  6 15:04 150gb2
crw-rw----  1 root root  10, 63 Sep  6  2005 control

testhalde2 ~ # ls -lF /dev/1*
ls: /dev/1*: No such file or directory

testhalde2 ~ # udevstart

testhalde2 ~ # ls -lF /dev/1*
lrwxrwxrwx  1 root root 4 Sep  6 15:10 /dev/150gb -> dm-0
lrwxrwxrwx  1 root root 4 Sep  6 15:11 /dev/150gb1 -> dm-1
lrwxrwxrwx  1 root root 4 Sep  6 15:11 /dev/150gb2 -> dm-2


===> Without "udevstart" udev doesn't create the /dev/150gb*
links! Is this a udev bug?



II.) --- Using multipathd ---



testhalde2 ~ # multipathd -v4
testhalde2 ~ # ps ax | fgrep multipathd
11024 pts/1    SL     0:00 multipathd -v4
11025 pts/1    SL     0:00 multipathd -v4
11026 pts/1    SL     0:00 multipathd -v4
11029 pts/1    SL     0:00 multipathd -v4
11030 pts/1    SL     0:00 multipathd -v4
11031 pts/1    SL     0:00 multipathd -v4
11032 pts/1    SL     0:00 multipathd -v4
11071 pts/1    S+     0:00 fgrep multipathd
testhalde2 ~ # cat /var/run/multipathd.pid
11024

Yeah! Version 0.4.5 creates a pid and a socket file :-)
It's important that I start "multipath /dev/sda" _before_
multipathd! If I change this order, multipathd does nothing.
/var/log/messages shows "tick", "map garbage collection"
etc. and nothing about /dev/sda or /dev/sdb. It seems that
multipathd doesn't read the device-mapper table at startup.
===> Is this behavior ok?


testhalde2 ~ # less /var/log/messages
...
/etc/dev.d/multipath.dev (10904): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/dm-0, $ACTION=add, $@=block
/etc/dev.d/multipath.dev (10904): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (10904): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (10904): Getting /block/dm-0 major and minor number
/etc/dev.d/multipath.dev (10904): /block/dm-0 major:minor = 254:0
/etc/dev.d/multipath.dev (10904): Getting /block/dm-0 alias
/etc/dev.d/multipath.dev (10904): /block/dm-0 alias = /dev/mapper/150gb
/etc/dev.d/multipath.dev (10904): /sbin/kpartx -v -a /dev/mapper/150gb
/etc/dev.d/multipath.dev (10935): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/dm-1, $ACTION=add, $@=block
/etc/dev.d/multipath.dev (10935): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (10935): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (10935): Getting /block/dm-1 major and minor number
/etc/dev.d/multipath.dev (10935): /block/dm-1 major:minor = 254:1
/etc/dev.d/multipath.dev (10935): Getting /block/dm-1 alias
/etc/dev.d/multipath.dev (10963): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/dm-2, $ACTION=add, $@=block
/etc/dev.d/multipath.dev (10963): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (10963): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (10963): Getting /block/dm-2 major and minor number
/etc/dev.d/multipath.dev (10963): /block/dm-2 major:minor = 254:2
/etc/dev.d/multipath.dev (10963): Getting /block/dm-2 alias
/etc/dev.d/multipath.dev (10935): /block/dm-1 alias = /dev/mapper/150gb1
/etc/dev.d/multipath.dev (10935): /sbin/kpartx -v -a /dev/mapper/150gb1
/etc/dev.d/multipath.dev (10963): /block/dm-2 alias = /dev/mapper/150gb2
/etc/dev.d/multipath.dev (10963): /sbin/kpartx -v -a /dev/mapper/150gb2
multipathd: --------start up--------
multipathd: read /etc/multipath.conf
multipathd: fd0 blacklisted
...
multipathd: hda blacklisted
multipathd: path sda not found in pathvec
multipathd: ===== path sda =====
multipathd: bus = 1
multipathd: dev_t = 8:0
multipathd: size = 314572800
multipathd: vendor = HP
multipathd: product = HSV100
multipathd: rev = 3025
multipathd: h:b:t:l = 0:0:0:1
multipathd: tgt_node_name = 0x50001fe150051d20
multipathd: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
multipathd: uid = 3600508b40010079d0001900000460000 (callout)
multipathd: path sdb not found in pathvec
multipathd: ===== path sdb =====
multipathd: bus = 1
multipathd: dev_t = 8:16
multipathd: size = 314572800
multipathd: vendor = HP
multipathd: product = HSV100
multipathd: rev = 3025
multipathd: h:b:t:l = 1:0:0:1
multipathd: tgt_node_name = 0x50001fe150051d20
multipathd: getuid = /sbin/scsi_id -g -u -s /block/%n (controler setting)
multipathd: uid = 3600508b40010079d0001900000460000 (callout)
multipathd: dm-0 blacklisted
multipathd: dm-1 blacklisted
multipathd: dm-2 blacklisted
multipathd: discovered map 150gb
multipathd: *word = 0, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = round-robin, len = 11
multipathd: *word = 0, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 8:0, len = 3
multipathd: *word = 8:16, len = 4
multipathd: *word = 1, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 0, len = 1
multipathd: 8:0 ownership set
multipathd: 8:16 ownership set
multipathd: pgfailback = -2 (LUN setting)
multipathd: 150gb: event checker started
multipathd: path checkers start up
multipathd: tick
multipathd: ===== path sda =====
multipathd: bus = 1
multipathd: dev_t = 8:0
multipathd: size = 314572800
multipathd: vendor = HP
multipathd: product = HSV100
multipathd: rev = 3025
multipathd: h:b:t:l = 0:0:0:1
multipathd: tgt_node_name = 0x50001fe150051d20
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: path checker = tur (controler setting)
multipathd: 8:0: tur checker reports path is up
multipathd: 8:0: reinstated
multipathd: *word = 0, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = round-robin, len = 11
multipathd: *word = 0, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 8:0, len = 3
multipathd: *word = 8:16, len = 4
multipathd: *word = 1, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 0, len = 1
multipathd: ===== path sda =====
multipathd: getprio = /bin/true (internal default)
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: ===== path sdb =====
multipathd: getprio = /bin/true (internal default)
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: path prio refresh
multipathd: ===== path sda =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: ===== path sdb =====
multipathd: bus = 1
multipathd: dev_t = 8:16
multipathd: size = 314572800
multipathd: vendor = HP
multipathd: product = HSV100
multipathd: rev = 3025
multipathd: h:b:t:l = 1:0:0:1
multipathd: tgt_node_name = 0x50001fe150051d20
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: path checker = tur (controler setting)
multipathd: 8:16: tur checker reports path is up
multipathd: 8:16: reinstated
multipathd: *word = 0, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = round-robin, len = 11
multipathd: *word = 0, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 8:0, len = 3
multipathd: *word = 8:16, len = 4
multipathd: *word = 1, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 0, len = 1
multipathd: ===== path sda =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: ===== path sdb =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: path prio refresh
multipathd: ===== path sdb =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: map garbage collection
multipathd: tick
last message repeated 5 times
multipathd: map garbage collection
multipathd: tick
last message repeated 4 times
multipathd: 8:0: tur checker reports path is up
multipathd: 8:0: delay next check 20s
multipathd: path prio refresh
multipathd: ===== path sda =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: 8:16: tur checker reports path is up
multipathd: 8:16: delay next check 20s
multipathd: path prio refresh
multipathd: ===== path sdb =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: tick
multipathd: map garbage collection
multipathd: tick
last message repeated 5 times
multipathd: map garbage collection
multipathd: tick
last message repeated 5 times
multipathd: map garbage collection
multipathd: tick
last message repeated 5 times
multipathd: map garbage collection
multipathd: tick
multipathd: tick
multipathd: 8:0: tur checker reports path is up
multipathd: 8:0: delay next check 40s
multipathd: path prio refresh
multipathd: ===== path sda =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: 8:16: tur checker reports path is up
multipathd: 8:16: delay next check 40s
multipathd: path prio refresh
multipathd: ===== path sdb =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: tick
...



*** Disabling san-port from HBA-1... ***


testhalde2 ~ # multipath -ll
[ sleeping 35 seconds ]
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:1 sda 8:0  [active][faulty]
  \_ 1:0:0:1 sdb 8:16 [active][ready]

testhalde2 ~ # multipath -ll
[ sleeping 10 seconds ]
failed to open /dev/sda
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:1 sda 8:0  [failed][faulty]
  \_ 1:0:0:1 sdb 8:16 [active][ready]

testhalde2 ~ # multipath -ll
[ sleeping 10 seconds ]
failed to open /dev/sda
150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:1 sda 8:0  [active][ready]
  \_ 1:0:0:1 sdb 8:16 [active][ready]


testhalde2 ~ # ls /sys/block/
dm-0  fd0    loop1  loop4  loop7  ram10  ram13  ram2  ram5  ram8
dm-1  hda    loop2  loop5  ram0   ram11  ram14  ram3  ram6  ram9
dm-2  loop0  loop3  loop6  ram1   ram12  ram15  ram4  ram7  sdb


testhalde2 ~ # dmsetup table
150gb1: 0 64197 linear 254:0 63
150gb: 0 314572800 multipath 0 0 1 1 round-robin 0 2 1 8:0 1000 8:16 1000
150gb2: 0 314504505 linear 254:0 64260


testhalde2 ~ # less /var/log/messages
...
kernel: qla2300 0000:03:01.0: LOOP DOWN detected.
multipathd: tick
...
kernel:  rport-0:0-3: blocked FC remote port time out: removing target
multipathd: 8:0: tur checker reports path is down
multipathd: checker failed path 8:0 in map 150gb
kernel: device-mapper: dm-multipath: Failing path 8:0.
multipathd: 150gb: devmap event #2
multipathd: 8:16: tur checker reports path is up
multipathd: 8:16: delay next check 40s
multipathd: path prio refresh
multipathd: ===== path sdb =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: discovered map 150gb
multipathd: *word = 0, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = round-robin, len = 11
multipathd: *word = 0, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 8:0, len = 3
multipathd: *word = 8:16, len = 4
multipathd: *word = 1, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = F, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 0, len = 1
multipathd: 8:0 ownership set
multipathd: 8:16 ownership set
multipathd: pgfailback = -2 (LUN setting)
/etc/dev.d/multipath.dev (11579): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sda/sda1, $ACTION=remove, $@=block
/etc/dev.d/multipath.dev (11579): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11579): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11579): Exiting: $ACTION != "add"
/etc/dev.d/multipath.dev (11571): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sda/sda2, $ACTION=remove, $@=block
/etc/dev.d/multipath.dev (11571): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11571): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11571): Exiting: $ACTION != "add"
/etc/dev.d/multipath.dev (11604): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sda, $ACTION=remove, $@=block
/etc/dev.d/multipath.dev (11604): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11604): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11604): Exiting: $ACTION != "add"
multipathd: tick
multipathd: map garbage collection
multipathd: tick
multipathd: tick
multipathd: Got request [dump pathvec]
multipathd: *word = dump, len = 4
multipathd: *word = pathvec, len = 7
multipathd: tick
last message repeated 3 times
multipathd: map garbage collection
multipathd: tick
last message repeated 3 times
multipathd: 8:0: tur checker reports path is up
multipathd: 8:0: reinstated
multipathd: *word = 0, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = round-robin, len = 11
multipathd: *word = 0, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 8:0, len = 3
multipathd: *word = 8:16, len = 4
multipathd: *word = 1, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 0, len = 1
multipathd: ===== path sda =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: ===== path sdb =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: path prio refresh
multipathd: ===== path sda =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: 150gb: devmap event #3
multipathd: discovered map 150gb
multipathd: *word = 0, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = round-robin, len = 11
multipathd: *word = 0, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = 8:0, len = 3
multipathd: *word = 8:16, len = 4
multipathd: *word = 1, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 2, len = 1
multipathd: *word = 0, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 1, len = 1
multipathd: *word = A, len = 1
multipathd: *word = 0, len = 1
multipathd: 8:0 ownership set
multipathd: 8:16 ownership set
multipathd: pgfailback = -2 (LUN setting)
kernel: scsi0 (0:1): rejecting I/O to dead device
multipathd: Got request [dump pathvec]
multipathd: *word = dump, len = 4
multipathd: *word = pathvec, len = 7
multipathd: tick
multipathd: tick
multipathd: map garbage collection
multipathd: tick
last message repeated 5 times
multipathd: map garbage collection
multipathd: tick
last message repeated 2 times
multipathd: 8:0: tur checker reports path is up
multipathd: 8:0: delay next check 20s
multipathd: path prio refresh
multipathd: ===== path sda =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
kernel: scsi0 (0:1): rejecting I/O to dead device
multipathd: tick
last message repeated 2 times
multipathd: map garbage collection
multipathd: tick
multipathd: Got request [dump pathvec]
multipathd: *word = dump, len = 4
multipathd: *word = pathvec, len = 7
multipathd: tick
last message repeated 4 times
multipathd: map garbage collection
multipathd: tick
last message repeated 5 times
multipathd: map garbage collection
multipathd: tick
last message repeated 3 times
multipathd: 8:16: tur checker reports path is up
multipathd: 8:16: delay next check 40s
multipathd: path prio refresh
multipathd: ===== path sdb =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: tick
multipathd: tick
multipathd: 8:0: tur checker reports path is up
multipathd: 8:0: delay next check 40s
multipathd: path prio refresh
multipathd: ===== path sda =====
multipathd: prio = 0
multipathd: uid = 3600508b40010079d0001900000460000 (cache)
multipathd: map garbage collection
kernel: scsi0 (0:1): rejecting I/O to dead device
multipathd: tick
...


===> First multipathd says "8:0: tur checker reports
path is down" and multipath prints sda "failed" (ok).
After a few seconds sda is "ready" and multipathd says
"8:0: tur checker reports path is up"?! I have changed
nothing during this time.




*** Enabling san-switch port from HBA-1 ***


testhalde2 ~ # multipath -ll
testhalde2 ~ # dmsetup table
150gb1: 0 64197 linear 254:0 63
150gb2: 0 314504505 linear 254:0 64260


testhalde2 ~ # less /var/log/messages
...
multipathd: tick
kernel: qla2300 0000:03:01.0: LIP reset occured (f7f7).
kernel: qla2300 0000:03:01.0: LOOP UP detected (2 Gbps).
...
kernel: SCSI device sdc: drive cache: write through
kernel:  sdc: sdc1 sdc2
kernel: Attached scsi disk sdc at scsi0, channel 0, id 0, lun 1
kernel: Attached scsi generic sg1 at scsi0, channel 0, id 0, lun 1,  type 0
scsi.agent[11856]: disk at /devices/pci0000:03/0000:03:01.0/host0/rport-0:0-3/target0:0:0/0:0:0:1
/etc/dev.d/multipath.dev (11909): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sdc, $ACTION=add, $@=block
/etc/dev.d/multipath.dev (11909): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11909): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11909): Checking/Creating multipath device-mapper table with multipath-tool
/etc/dev.d/multipath.dev (11909): multipath -v0 /dev/sdc
multipathd: Got request [dump pathvec]
multipathd: *word = dump, len = 4
multipathd: *word = pathvec, len = 7
multipathd: tick
multipathd: tick
multipathd: Got request [dump pathvec]
multipathd: *word = dump, len = 4
multipathd: *word = pathvec, len = 7
multipathd: tick
last message repeated 2 times
multipathd: map garbage collection
kernel: device-mapper: dm-multipath: error getting device
kernel: device-mapper: error adding target to table
/etc/dev.d/multipath.dev (11944): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sdc/sdc2, $ACTION=add, $@=block
/etc/dev.d/multipath.dev (11944): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11944): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11959): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sdc/sdc1, $ACTION=add, $@=block
/etc/dev.d/multipath.dev (11959): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11959): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11959): Checking/Creating multipath device-mapper table with multipath-tool
/etc/dev.d/multipath.dev (11959): multipath -v0 /dev/sdc1
multipathd: Got request [dump pathvec]
multipathd: *word = dump, len = 4
multipathd: *word = pathvec, len = 7
logger: /etc/dev.d/multipath.dev (11944): Checking/Creating multipath device-mapper table with multipath-tool
logger: /etc/dev.d/multipath.dev (11944): multipath -v0 /dev/sdc2
multipathd: Got request [dump pathvec]
multipathd: *word = dump, len = 4
multipathd: *word = pathvec, len = 7
multipathd: tick
last message repeated 2 times
multipathd: Got request [dump pathvec]
multipathd: *word = dump, len = 4
multipathd: *word = pathvec, len = 7
multipathd: tick
multipathd: tick
kernel: device-mapper: dm-multipath: error getting device
kernel: device-mapper: error adding target to table
kernel: device-mapper: device doesn't appear to be in the dev hash table.
multipathd: tick
multipathd: map garbage collection
multipathd: 150gb: remove dead map
multipathd: 150gb: reap event checker
multipathd: 8:0 is orphaned
multipathd: 8:16 is orphaned
multipathd: SIGHUP received
multipathd: tick
multipathd: tick
/etc/dev.d/multipath.dev (12002): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/dm-3, $ACTION=remove, $@=block
/etc/dev.d/multipath.dev (12002): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (12002): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (12002): Exiting: $ACTION != "add"
/etc/dev.d/multipath.dev (12018): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/dm-4, $ACTION=remove, $@=block
/etc/dev.d/multipath.dev (12018): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (12018): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (12018): Exiting: $ACTION != "add"
multipathd: tick
...


===> An error occurs while device-mapper tries to update
the dm-table and deletes the "150gb" entry.



III.) --- Using multipath-tools without multipath ---



Now, I try the same _without_ starting multipathd...


testhalde2 ~ # ps ax | fgrep multipathd
testhalde2 ~ #

testhalde2 ~ # multipath /dev/sda
create: 150gb (3600508b40010079d0001900000460000)
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0
  \_ 0:0:0:1 sda 8:0  [ready]
  \_ 1:0:0:1 sdb 8:16 [ready]

testhalde2 ~ # multipath -ll
150gb ()
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:1 sda 8:0  [active][ready]
  \_ 1:0:0:1 sdb 8:16 [active][ready]

testhalde2 ~ # dmsetup table
150gb1: 0 64197 linear 254:0 63
150gb: 0 314572800 multipath 0 0 1 1 round-robin 0 2 1 8:0 1000 8:16 1000
150gb2: 0 314504505 linear 254:0 64260

testhalde2 ~ # ls /dev/mapper/
150gb  150gb1  150gb2  control


*** Disabling san-switch port from HBA-1 ***


testhalde2 ~ # multipath -ll
[ sleeping 35 seconds ]
150gb ()
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:1 sda 8:0  [active][faulty]
  \_ 1:0:0:1 sdb 8:16 [active][ready]

testhalde2 ~ # multipath -ll
[ sleeping 10 seconds ]
150gb ()
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ #:#:#:#      8:0 [active]
  \_ 1:0:0:1 sdb 8:16 [active][ready]

testhalde2 ~ # ls /sys/block/
dm-0  fd0    loop1  loop4  loop7  ram10  ram13  ram2  ram5  ram8
dm-1  hda    loop2  loop5  ram0   ram11  ram14  ram3  ram6  ram9
dm-2  loop0  loop3  loop6  ram1   ram12  ram15  ram4  ram7  sdb

testhalde2 ~ # dmsetup table
150gb1: 0 64197 linear 254:0 63
150gb: 0 314572800 multipath 0 0 1 1 round-robin 0 2 1 8:0 1000 8:16 1000
150gb2: 0 314504505 linear 254:0 64260


testhalde2 ~ # less /var/log/messages
...
kernel: qla2300 0000:03:01.0: LOOP DOWN detected.
kernel:  rport-0:0-3: blocked FC remote port time out: removing target
/etc/dev.d/multipath.dev (11186): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sda/sda1, $ACTION=remove, $@=block
/etc/dev.d/multipath.dev (11186): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11186): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11186): Exiting: $ACTION != "add"
/etc/dev.d/multipath.dev (11200): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sda/sda2, $ACTION=remove, $@=block
/etc/dev.d/multipath.dev (11200): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11200): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11200): Exiting: $ACTION != "add"
/etc/dev.d/multipath.dev (11217): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sda, $ACTION=remove, $@=block
/etc/dev.d/multipath.dev (11217): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11217): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11217): Exiting: $ACTION != "add"
...



*** Enabling san-switch port from HBA-1 ***


testhalde2 ~ # multipath -ll
[ sleeping 5 seconds ]
150gb ()
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ #:#:#:#      8:0  [active]
  \_ 1:0:0:1 sdb 8:16 [active][ready]

testhalde2 ~ # multipath -ll
150gb ()
[size=150 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
  \_ 1:0:0:1 sdb 8:16 [active][ready]
  \_ 0:0:0:1 sdc 8:32 [active][ready]

testhalde2 ~ # dmsetup table
150gb1: 0 64197 linear 254:0 63
150gb: 0 314572800 multipath 0 0 1 1 round-robin 0 2 1 8:16 1000 8:32 1000
150gb2: 0 314504505 linear 254:0 64260

testhalde2 ~ # ls /dev/mapper/
150gb  150gb1  150gb2  control


testhalde2 ~ # less /var/log/messages
...
kernel:  sdc: sdc1 sdc2
kernel: Attached scsi disk sdc at scsi0, channel 0, id 0, lun 1
kernel: Attached scsi generic sg1 at scsi0, channel 0, id 0, lun 1,  type 0
scsi.agent[11271]: disk at /devices/pci0000:03/0000:03:01.0/host0/rport-0:0-3/target0:0:0/0:0:0:1
/etc/dev.d/multipath.dev (11325): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sdc, $ACTION=add, $@=block
/etc/dev.d/multipath.dev (11325): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11325): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11325): Checking/Creating multipath device-mapper table with multipath-tool
/etc/dev.d/multipath.dev (11325): multipath -v0 /dev/sdc
/etc/dev.d/multipath.dev (11356): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sdc/sdc2, $ACTION=add, $@=block
/etc/dev.d/multipath.dev (11356): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11356): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11356): Checking/Creating multipath device-mapper table with multipath-tool
/etc/dev.d/multipath.dev (11356): multipath -v0 /dev/sdc2
/etc/dev.d/multipath.dev (11377): Parameters: $0=/etc/dev.d/block/multipath.dev, $DEVPATH=/block/sdc/sdc1, $ACTION=add, $@=block
/etc/dev.d/multipath.dev (11377): Logging to local file is enabled: log file is /root/multipath.dev.log
/etc/dev.d/multipath.dev (11377): Logging to syslog ist enabled: facility.priority is daemon.info
/etc/dev.d/multipath.dev (11377): Checking/Creating multipath device-mapper table with multipath-tool
/etc/dev.d/multipath.dev (11377): multipath -v0 /dev/sdc1
...


VI.) --- Summary ---


===> Multipathing seems to work without but not with multipathd.
It's very slow, but Christophe Varoqui wrote that I have to lower
the HBA timeouts (unfortunately, I don't know how to do this,
see above). Does I really need multipathd? I suppose so :-)



 > And consider updating the wiki FAQ with the response you found to be
 > enlightening :/

As soon as I have running multipath I will write a step-by-step
documentation.


Thanks again for your help,
Simon



#--- My /etc/dev.d/block/multipath.dev - Begin ---

#!/bin/sh

# log to local file? (0 or 1)
# (print log file with "sort $logFile [| less]")
logToFile=1

# log to syslog? (0 or 1)
logToSyslog=1

# path to log file
# (only used if $logToFile==1)
logFile="/root/multipath.dev.log"

# syslog facility.priority (man syslog.conf)
# (only used if $logToSyslog==1)
syslogFacPrio="daemon.info"

# timeout for getting ${DEVPATH} alias in seconds
timeout=10

# be verbose in log file and/or syslog?
# (only used if $logToFile==1 and/or $logToSyslog==1)
verbose=1

# Don't touch
pid=$$
logCount=1;

log()
{
   if [ ${logToFile} -eq 1 ]
   then
     msg="PID ${pid} - $(date +%Y%m%d-%H%M%S) -"
     msg="${msg} Log entry ${logCount}: ${1}"
     echo "${msg}" >> $logFile
     logCount=$(($logCount + 1))
   fi

   if [ ${logToSyslog} -eq 1 ]
   then
     logger -p ${syslogFacPrio} "/etc/dev.d/multipath.dev (${pid}): ${1}"
   fi
}

  die()
{
   log "DIED WITH ERROR: ${1}"
   exit 1
}

exe()
{
   log "${1}"
   if ! ${1}
   then
     die "\"${1}\" failed (device blacklisted?)"
   fi
}

end()
{
   if [ ! -z ${1} ]
   then
     log "${1}"
   fi
   exit 0
}

if [ ${verbose} -eq 1 ]
then
   msg="Parameters: \$0=${0}, \$DEVPATH=${DEVPATH},"
   msg="${msg} \$ACTION=${ACTION}, \$@=${@}"
   log "${msg}"

   if [ ${logToFile} -eq 1 ]
   then
     log "Logging to local file is enabled: log file is ${logFile}"
   fi

   if [ ${logToSyslog} -eq 1 ]
   then
     msg="Logging to syslog is enabled:"
     msg="${msg} facility.priority is ${syslogFacPrio}"
     log "${msg}"
   fi
fi

if [ ! "${ACTION}" = add ]
then
   if [ ${verbose} -eq 1 ]
   then
     log "Exiting: \$ACTION != \"add\""
   fi
   end
fi

if [ "${DEVPATH:7:3}" = "dm-" ]
then
   log "Getting ${DEVPATH} major and minor number"
   devMajorMinor=$(</sys${DEVPATH}/dev)
   if [ -z ${devMajorMinor} ]
   then
     die "Getting ${DEVPATH} major and minor number failed"
   else
     log "${DEVPATH} major:minor = ${devMajorMinor}"
   fi

   log "Getting ${DEVPATH} alias"
   count=0
   devAlias="none"
   while [ ! -b ${devAlias} ] && [ ${count} -le ${timeout} ]
   do
     devAlias="/dev/mapper/$(devmap_name ${devMajorMinor})"
     if [ ${count} -ne 0 ]
     then
       sleep 1
     fi
     count=$(($count + 1))
   done

   if [ ${count} -gt ${timeout} ]
   then
     msg="Getting ${DEVPATH} alias failed (Found ${devAlias}, but"
     msg="${msg} this isn't a block device)"
     die "${msg}"
   else
     log "${DEVPATH} alias = ${devAlias}"
   fi

   exe "/sbin/kpartx -v -a ${devAlias}"

else
   log "Checking/Creating multipath device-mapper table with multipath-tool"
   exe "multipath -v0 ${DEVNAME}"
fi

#--- /etc/dev.d/block/multipath.dev - End ---

-- 

Simon
gistolero@gmx.de
