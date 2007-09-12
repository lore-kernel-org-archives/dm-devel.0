From: Mark Ruys <mark@paracas.nl>
Subject: multipath: invalid number of priority groups
Date: Wed, 12 Sep 2007 09:13:17 +0200
Message-ID: <46E7918D.2000806@paracas.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Within RHEL5, we have a seemingly good working configuration with iSCSI 
and multipath to on EMC AX150i. However, in the message log, we so a 
*lot* error messages continuously passing by:

Sep 12 09:04:43 quentin kernel: device-mapper: multipath emc: long 
trespass command will be send
Sep 12 09:04:43 quentin kernel: device-mapper: multipath emc: honor 
reservation bit will not be set (default)
Sep 12 09:04:43 quentin kernel: device-mapper: table: 253:6: multipath: 
invalid number of priority groups
Sep 12 09:04:43 quentin kernel: device-mapper: ioctl: error adding 
target to table
Sep 12 09:04:43 quentin multipathd: root_joel: failed in domap for 
addition of new path sdg
Sep 12 09:04:43 quentin multipathd: root_joel: uev_add_path sleep

This repeats every second. How should we interpretate these loggings? 
How to stop it.

Thanks for some insight,

Mark Ruys
in2sports


device-mapper-multipath-0.4.7-8.el5
iscsi-initiator-utils-6.2.0.742-0.6.el5
kernel-xen-2.6.18-8.1.6.el5


$ sudo multipath -ll
martin (360060160b9781b00a0df8ff2875bdc11) dm-5 DGC,RAID 10
[size=50G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=2][active]
 \_ 20:0:0:1 sdn 8:208 [active][ready]
 \_ 21:0:0:1 sdr 65:16 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 22:0:0:1 sdd 8:48  [active][ready]
 \_ 19:0:0:1 sdh 8:112 [active][ready]
mysql_master (360060160b9781b00e4cb7c28de39dc11) dm-12 DGC,RAID 10
[size=50G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=2][active]
 \_ 20:0:0:4 sdp 8:240 [active][ready]
 \_ 21:0:0:4 sdu 65:64 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 22:0:0:4 sdm 8:192 [active][ready]
 \_ 19:0:0:4 sdk 8:160 [active][ready]
root_joel (360060160b9781b01ac19288156f3db11) dm-6 DGC,RAID 10
[size=5.0G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=2][active]
 \_ 20:0:0:0 sdl 8:176 [active][ready]
 \_ 21:0:0:0 sdq 65:0  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 22:0:0:0 sdc 8:32  [active][ready]
 \_ 19:0:0:0 sdg 8:96  [active][ready]
packages (360060160b9781b00c26acb074d02dc11) dm-7 DGC,RAID 10
[size=15G][features=1 queue_if_no_path][hwhandler=1 emc]
\_ round-robin 0 [prio=2][active]
 \_ 22:0:0:2 sdi 8:128 [active][ready]
 \_ 19:0:0:2 sdj 8:144 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 20:0:0:2 sdo 8:224 [active][ready]
 \_ 21:0:0:2 sdt 65:48 [active][ready]

$ sudo grep "^[^#]" /etc/iscsi/iscsid.conf
node.startup = automatic
node.session.timeo.replacement_timeout = 10
node.conn[0].timeo.login_timeout = 15
node.conn[0].timeo.logout_timeout = 15
node.conn[0].timeo.noop_out_interval = 10
node.conn[0].timeo.noop_out_timeout = 15
node.session.iscsi.InitialR2T = Yes
node.session.iscsi.ImmediateData = No
node.session.iscsi.FirstBurstLength = 262144
node.session.iscsi.MaxBurstLength = 16776192
node.conn[0].iscsi.MaxRecvDataSegmentLength = 65536
node.conn[0].iscsi.HeaderDigest = None
node.conn[0].iscsi.DataDigest = None
