From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Info on bytes flow during polling
Date: Thu, 11 Jul 2013 10:54:57 +0200
Message-ID: <CAG2kNCwAMw6-7ss0g2OpQ62BmsOTprb707njiHnDc3s_c88TDw@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,
where can I find information about the amount of bytes involved during
a path polling based on the possible configurations?
Did it changed between rh el 5.9 and rh el 6.3, that means somehow between
device-mapper-multipath-0.4.7-54.el5_9.1
and
device-mapper-multipath-0.4.9-56.el6.x86_64

In my case:
- polling interval not set in multipath.conf for rh el 6
So it should be 5 seconds stabilized then to 20 seconds
Set to 30 for rh el 5.9

- path_checker = tur
for both

- number of paths for every device = 8
I have my RH E 6.3 and rh el 5.9 systems connected to a netapp FAS3240
in metrocluster configuration via FC
in rh el 6.3 device-mapper-multipath-0.4.9-56.el6.x86_64

An example of lun is:
$ sudo multipath -l 360a9800037543544465d424130536f6f
360a9800037543544465d424130536f6f dm-15 NETAPP,LUN
size=10G features='3 queue_if_no_path pg_init_retries 50' hwhandler='1
alua' wp=rw
|-+- policy='round-robin 0' prio=0 status=active
| |- 3:0:0:12 sdn  8:208  active undef running
| |- 3:0:1:12 sdab 65:176 active undef running
| |- 4:0:2:12 sdbr 68:80  active undef running
| `- 4:0:3:12 sdcf 69:48  active undef running
`-+- policy='round-robin 0' prio=0 status=enabled
  |- 4:0:0:12 sdap 66:144 active undef running
  |- 4:0:1:12 sdbd 67:112 active undef running
  |- 3:0:2:12 sdct 70:16  active undef running
  `- 3:0:3:12 sddh 70:240 active undef running

- checks are for both active and enabled groups, correct?

- path_grouping_policy  is set to  group_by_prio for both
Is it correct to say that the enabled group should be composed by the
paths towards the second head of netapp?


All these questions for general knowledge and based on questions I
received about my rh le 6.3 systems sending greater amount of I/O to
the second head of netapp vs rh el 5.9 and VMware.

Some examples from "lun stat -o" on netapp console 4 hours after a
reset of counters

The lun above in 6.3
    /vol/ORAUGDM_UGDMPRE_RDOF_vol/ORAUGDM_UGDMPRE_RDOF  (4 hours, 48
minutes, 1 second)
        Read (kbytes)   Write (kbytes)  Read Ops  Write Ops  Other Ops
 QFulls  Partner Ops Partner KBytes
        30604           16832724        7647      49280      47331
 0       15986       10400

so about 10Mbytes and 15986 ops through the second head.

At he same time another lun on a rh el 5.9 server shows 2304
operations on the other head but 0 Kbytes:

/vol/ORAUGOL_UGOLPRO_CTRL_vol/ORAUGOL_UGOLPRO_CTRL  (4 hours, 48
minutes, 1 second)
        Read (kbytes)   Write (kbytes)  Read Ops  Write Ops  Other Ops
 QFulls  Partner Ops Partner KBytes
        0               342412          0         25775      6912
 0       2304        0

where the lun i of kind:
$ sudo /sbin/multipath -l 360a9800037543544465d424130536671
360a9800037543544465d424130536671 dm-11 NETAPP,LUN
[size=1.0G][features=3 queue_if_no_path pg_init_retries
50][hwhandler=1 alua][rw]
\_ round-robin 0 [prio=0][active]
 \_ 8:0:1:1  sdas 66:192 [active][undef]
 \_ 7:0:0:1  sdc  8:32   [active][undef]
 \_ 7:0:1:1  sdp  8:240  [active][undef]
 \_ 8:0:0:1  sdx  65:112 [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 7:0:2:1  sdan 66:112 [active][undef]
 \_ 8:0:2:1  sdbj 67:208 [active][undef]
 \_ 7:0:3:1  sdcc 69:0   [active][undef]
 \_ 8:0:3:1  sdce 69:32  [active][undef]

also for bigger luns on another 5.9 server with more accesses:
    /vol/ORASTUD_DB1_RDOF_vol/ORASTUD_DB1_RDOF  (4 hours, 48 minutes, 1 second)
        Read (kbytes)   Write (kbytes)  Read Ops  Write Ops  Other Ops
 QFulls  Partner Ops Partner KBytes
        26539148        30920888        120309    119041     6864
 0       2288        0

So 56Gb of I/O and zero KBytes on the other head and only  2288 ops on it

VMware luns stats are aligned with rh el 5.9 behavior:
    /vol/vmfs1a4x/vmfs1a44  (4 hours, 48 minutes, 1 second)
        Read (kbytes)   Write (kbytes)  Read Ops  Write Ops  Other Ops
 QFulls  Partner Ops Partner KBytes
        85351           5675378         5980      927689     13144
 0       6494        0


Thanks in advance for any insight.

Gianluca
