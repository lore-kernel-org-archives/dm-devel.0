From: Mario Mech <mech@meteo.uni-koeln.de>
Subject: RE: failover does not work with rdac device handler
Date: Wed, 24 Jun 2009 18:09:02 +0200
Message-ID: <4A424F9E.1050403@meteo.uni-koeln.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
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

Hi,

I need help with a similar or even the same issue as in the thread mentioned in the Subject 
(https://www.redhat.com/archives/dm-devel/2008-October/msg00130.html).

On two PowerEdge 2970 with CentOS 5.3 connected to a MD3000i I get the following messages in /var/log/messages

Jun 24 17:57:49 ninja multipathd: dm-3: add map (uevent)
Jun 24 17:57:49 ninja kernel: end_request: I/O error, dev sdc, sector 530184
Jun 24 17:57:49 ninja kernel: device-mapper: multipath: Failing path 8:32.
Jun 24 17:57:49 ninja multipathd: dm-3: devmap already registered
Jun 24 17:57:49 ninja multipathd: 8:32: mark as failed
Jun 24 17:57:49 ninja multipathd: mpath8: remaining active paths: 3
Jun 24 17:57:49 ninja multipathd: dm-3: add map (uevent)
Jun 24 17:57:49 ninja kernel: end_request: I/O error, dev sdd, sector 530184
Jun 24 17:57:49 ninja kernel: device-mapper: multipath: Failing path 8:48.
Jun 24 17:57:49 ninja kernel: device-mapper: multipath: Cannot failover device because scsi_dh_rdac was not loaded.
Jun 24 17:57:49 ninja kernel: device-mapper: multipath: Failing path 8:80.
Jun 24 17:57:49 ninja kernel: device-mapper: multipath: Could not failover device. Error 15.
Jun 24 17:57:49 ninja kernel: device-mapper: multipath: Cannot failover device because scsi_dh_rdac was not loaded.
Jun 24 17:57:49 ninja kernel: device-mapper: multipath: Failing path 8:64.
Jun 24 17:57:49 ninja kernel: device-mapper: multipath: Could not failover device. Error 15.
Jun 24 17:57:49 ninja kernel: GFS2: fsid=ninjo_cluster:gfsfs.0: gfs2_quotad: statfs error -5
Jun 24 17:57:49 ninja multipathd: dm-3: devmap already registered
Jun 24 17:57:50 ninja multipathd: dm-3: add map (uevent)
Jun 24 17:57:50 ninja multipathd: dm-3: devmap already registered
Jun 24 17:57:50 ninja multipathd: dm-3: add map (uevent)
Jun 24 17:57:50 ninja multipathd: dm-3: devmap already registered
Jun 24 17:57:50 ninja multipathd: 8:48: mark as failed
Jun 24 17:57:50 ninja multipathd: mpath8: remaining active paths: 2
Jun 24 17:57:50 ninja multipathd: 8:64: mark as failed
Jun 24 17:57:50 ninja multipathd: mpath8: remaining active paths: 1
Jun 24 17:57:50 ninja multipathd: 8:80: mark as failed
Jun 24 17:57:50 ninja multipathd: mpath8: remaining active paths: 0
Jun 24 17:57:54 ninja multipathd: 8:32: reinstated
Jun 24 17:57:54 ninja multipathd: mpath8: remaining active paths: 1
Jun 24 17:57:54 ninja multipathd: dm-3: add map (uevent)
Jun 24 17:57:54 ninja multipathd: dm-3: devmap already registered
Jun 24 17:57:55 ninja multipathd: 8:64: reinstated
Jun 24 17:57:55 ninja multipathd: mpath8: remaining active paths: 2
Jun 24 17:57:55 ninja multipathd: 8:80: reinstated
Jun 24 17:57:55 ninja multipathd: mpath8: remaining active paths: 3
Jun 24 17:57:55 ninja multipathd: 8:48: reinstated
Jun 24 17:57:55 ninja multipathd: mpath8: remaining active paths: 4
Jun 24 17:57:55 ninja multipathd: dm-3: add map (uevent)
Jun 24 17:57:55 ninja multipathd: dm-3: devmap already registered
Jun 24 17:57:55 ninja multipathd: dm-3: add map (uevent)
Jun 24 17:57:55 ninja multipathd: dm-3: devmap already registered
Jun 24 17:57:55 ninja multipathd: dm-3: add map (uevent)
Jun 24 17:57:55 ninja multipathd: dm-3: devmap already registered

The following additional information can I provide.

[root@ninja redhat]# lsmod | egrep 'rdac|multi'
scsi_dh_rdac           40897  1
dm_multipath           55257  2 dm_round_robin
scsi_dh                41665  2 scsi_dh_rdac,dm_multipath
dm_mod                100369  18 dm_multipath,dm_raid45,dm_snapshot,dm_zero,dm_mirror,dm_log
scsi_mod              196569  10 scsi_dh_rdac,ib_iser,iscsi_tcp,libiscsi,scsi_transport_iscsi,scsi_dh,sg,libata,megaraid_sas,sd_mod

[root@ninja redhat]# multipath -ll
mpath8 (360024e80004ec0de000010324a373eeb) dm-3 DELL,MD3000i
[size=7.5T][features=0][hwhandler=1 rdac][rw]
\_ round-robin 0 [prio=200][enabled]
  \_ 7:0:0:0  sde 8:64  [active][ghost]
  \_ 5:0:0:0  sdf 8:80  [active][ghost]
\_ round-robin 0 [prio=0][enabled]
  \_ 8:0:0:0  sdd 8:48  [active][ready]
  \_ 6:0:0:0  sdc 8:32  [active][ready]

The multipath version shipped with CentOS 5.3 is multipath-tools v0.4.7 (03/12, 2006).

As I've seen in the mentioned thread something like

echo rdac > /sys/block/sd?/device/dh_state

should fix at least the failover problem.

But I do not see any dh_state in /sys/block/sd?/device/ and I'm not allowed (even as root) to do anything like:

for i in c d e f; do echo rdac > /sys/block/sd$i/device/dh_state; done

At the moment I'd like to avoid building the multipath package by myself with the patch provided in the afore mentioned thread.

Do you have any ideas? Or is a different problem I have.

Every help is appreciated.

All best

Mario

-- 
Dr. Mario Mech

Institute for Geophysics and Meteorology
University of Cologne
Zuelpicherstr. 49a
50674 Cologne
Germany

t: +49 (0)221 - 470 - 1776
f: +49 (0)221 - 470 - 5198
e: mech@meteo.uni-koeln.de
w: http://www.meteo.uni-koeln.de/~mmech/
