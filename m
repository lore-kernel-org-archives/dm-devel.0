From: Brian Bunker <brian@purestorage.com>
Subject: path coalescing in multipath
Date: Fri, 11 Apr 2014 10:18:04 -0700
Message-ID: <4091EA33-EEDB-4F1B-8A09-C18E2D618AAA@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
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

I have a question about mulitpath and the device mapper that we have not been able to figure out here. We run into problems where a dm device is coalescing paths from LUNs which do not have the same number, or the same underlying serial number using either inquiry page 0x80 or inquiry page 0x83. We see output like this:

[root@r12init20 ~]# multipath -l
3624a9370cd8a605eb05916bd00010004 dm-11 PURE,FlashArray
size=500G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=0 status=active
  |- 1:0:0:12 sdm  8:192  active undef running
  |- 1:0:1:12 sdy  65:128 active undef running
  |- 0:0:0:12 sdak 66:64  active undef running
  |- 0:0:1:12 sdaw 67:0   active undef running
  |- 1:0:1:10 sdw  65:96  active undef running
  |- 0:0:0:10 sdai 66:32  active undef running
  |- 1:0:0:10 sdk  8:160  active undef running
  |- 0:0:1:10 sdau 66:224 active undef running
  |- 0:0:2:10 sdbs 68:96  active undef running
  |- 1:0:2:10 sdbn 68:16  active undef running
  |- 1:0:3:10 sdce 69:32  active undef running
  `- 0:0:3:10 sdcq 69:224 active undef running

There are 8 real paths to the device which seem to be all correct. They are the the LUN 10 paths. Why are the LUN 12 paths ending up under this dm device? 

Here is a sample path of LUN 10:
[root@r12init20 ~]# sg_inq /dev/sdw
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x06  [SPC-4]
  [AERC=0]  [TrmTsk=0]  NormACA=1  HiSUP=0  Resp_data_format=2
  SCCS=1  ACC=0  TPGS=1  3PC=1  Protect=0  BQue=0
  EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=96 (0x60)   Peripheral device type: disk
 Vendor identification: PURE    
 Product identification: FlashArray      
 Product revision level: 9999
 Unit serial number: CD8A605EB05916BD0001000B

Here is a sample path of LUN 12:
[root@r12init20 ~]# sg_inq /dev/sdm
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x06  [SPC-4]
  [AERC=0]  [TrmTsk=0]  NormACA=1  HiSUP=0  Resp_data_format=2
  SCCS=1  ACC=0  TPGS=1  3PC=1  Protect=0  BQue=0
  EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=96 (0x60)   Peripheral device type: disk
 Vendor identification: PURE    
 Product identification: FlashArray      
 Product revision level: 9999
 Unit serial number: CD8A605EB05916BD00010004

You can see that the LUN serial numbers do not match, the page 0x83 data for these devices are:

[root@r12init20 ~]# sg_inq /dev/sdw -p0x83
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x24a937
      Vendor Specific Identifier: 0xcd8a605e
      Vendor Specific Identifier Extension: 0xb05916bd0001000b
      [0x624a9370cd8a605eb05916bd0001000b]

[root@r12init20 ~]# sg_inq /dev/sdm -p0x83
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x24a937
      Vendor Specific Identifier: 0xcd8a605e
      Vendor Specific Identifier Extension: 0xb05916bd00010004
      [0x624a9370cd8a605eb05916bd00010004]

Under what logic could multipath be coalescing the paths? I initially suspected friendly names since that involved a file lookup that I thought might be causing the problem, but this happens with friendly names off as well, as this example shows.

Is there any debugging level that I could turn on to see where multipath is getting confused? It seems that the target is doing exactly the right thing.

[root@r12init20 ~]# modinfo dm_multipath
filename:       /lib/modules/2.6.32-431.el6.x86_64/kernel/drivers/md/dm-multipath.ko
license:        GPL
author:         Sistina Software <dm-devel@redhat.com>
description:    device-mapper multipath target
srcversion:     9A8CF697599A7D9C9CF4BF7
depends:        dm-mod
vermagic:       2.6.32-431.el6.x86_64 SMP mod_unload modversions 

device-mapper-multipath.x86_64   0.4.9-72.el6

This will certainly lead to data corruption in this state. I see that there are problems that could happen on boot, but in this case the initiator has not rebooted and gotten itself into this state. 

Thanks,
Brian

Brian Bunker
brian@purestorage.com
