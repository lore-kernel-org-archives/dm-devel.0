From: Erez Zilber <erezz@voltaire.com>
Subject: About using multipath in SLES 10
Date: Mon, 28 Jan 2008 17:33:28 +0200
Message-ID: <479DF5C8.6050909@Voltaire.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

I guess that I'm missing something:

I started /etc/init.d/multipathd on SLES 10 sp1 and now I see the
following devices:

seed1:~ # multipath -ll
SATA_HDS728080PLA380_PFDB32E8TPKR5Mdm-0 ATA,HDS728080PLA380
[size=77G][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 3:0:0:0  sdb 8:16  [active][ready]
3600c0ff000d508d7def2894702000000dm-1 DotHill,R/Evo 2730-2R
[size=82G][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 16:0:0:0 sdc 8:32  [active][ready]
\_ round-robin 0 [prio=1][enabled]
 \_ 17:0:0:0 sdd 8:48  [active][ready]
3600c0ff000d508d7dff2894701000000dm-2 DotHill,R/Evo 2730-2R
[size=82G][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][active]
 \_ 18:0:0:0 sde 8:64  [active][ready]
\_ round-robin 0 [prio=1][enabled]
 \_ 19:0:0:0 sdf 8:80  [active][ready]

I understand that sdc & sdd are mapped to dm-1. However, I don't
understand how to use dm-1. For example, I can't run INQUIRY on it:

seed1:~ # sg_inq /dev/dm-1
Both SCSI INQUIRY and fetching ATA information failed on /dev/dm-1

I guess that I'm doing something wrong here... What should I do?

Thanks,
Erez
