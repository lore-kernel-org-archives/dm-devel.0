From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: 3PAR transparent failover with Linux
Date: Thu, 11 Sep 2014 14:58:19 +0200
Message-ID: <20140911125818.GC29930@glanzmann.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello,
we have two 3PARs 7400 which are configured for transparent failover. In
the following manner:

Active           Passive
3PAR-1 - RCOPY - 3PAR-2
  \                 /
   \               /
Active          Standby
Optimized        /
      \         /
       Linux Box

When we run multipath -l before the failover two paths were 'active' the
other paths 'failed'. Once we failed over and the ALUA state changed,
all paths went to 'failed':

360002ac0000000000000000a0000cc14 dm-17 3PARdata,VV
size=50G features='0' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=0 status=enabled
  |- 6:0:6:0   sdak 66:64  failed undef running
  |- 6:0:7:0   sdal 66:80  failed undef running
  |- 7:0:6:0   sdbw 68:160 failed undef running
  `- 7:0:7:0   sdbx 68:176 failed undef running

But we were able to continue I/O. So I wonder why multipath reported 'failed'
but allowed to continue I/O. So from our standpoint the I/O was continuing. The
transparent failover successfull. This is not supported by 3PAR for Linux but
it is for VMware ESX.

wrz3164:~ # sg_inq /dev/sdak
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x06  [SPC-4]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=1  3PC=1  Protect=0  [BQue=0]
  EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=1  Sync=1  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=168 (0xa8)   Peripheral device type: disk
 Vendor identification: 3PARdata
 Product identification: VV
 Product revision level: 3131
 Unit serial number:  <removed>

I would like to know if other people have experimented with 3PAR and
transparent failover. The above was with SLES 11SP3 and SuSE packaged
multipathd 0.4.9. We tried the HP configuration and the configuration
which was in the git head of multipath-tools which I also used during
the failover test: 

       device {
               vendor "3PARdata"
               product "VV"
               path_grouping_policy "multibus"
               path_checker "directio"
               features "0"
               hardware_handler "0"
               prio "const"
               rr_weight "uniform"
       }

Cheers,
        Thomas
