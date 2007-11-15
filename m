From: "Paul Cote" <paul.cote@incipient.com>
Subject: checker msg is "emc_clariion_checker: Path not correctly
	configured for failover"
Date: Thu, 15 Nov 2007 13:31:56 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F2611B8C3A@exch-2003.incipient.waltham>
References: <342d47870711151000o8bc5e6aw31394e039370c42c@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <342d47870711151000o8bc5e6aw31394e039370c42c@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


Hi

I've recently added an EMC CX3-80 ... And provisioned volumes to my
RHEL4-4 running with multipath tools v4.7.

I've added the recommend settings by EMC for the CX to the
multipath.conf file (below) but I am seeing the following errors;

devices {
## Device attributes requirements for EMC Symmetrix
## are part of the default definitions and do not require separate
## definition.
## Device attributes for EMC CLARiiON
device {
vendor "DGC "
product "*"
path_grouping_policy group_by_prio
getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
prio_callout "/sbin/mpath_prio_emc /dev/%n"
path_checker emc_clariion
path_selector "round-robin 0"
features "1 queue_if_no_path"
no_path_retry 300
hardware_handler "1 emc"
failback immediate
}
}

error calling out /sbin/scsi_id -g -u -s /block/sda
sdd: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sde: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdf: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdg: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdh: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdi: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdj: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdk: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdl: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdm: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdn: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdo: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdd: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdg: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdj: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdm: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sde: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdh: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdk: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdn: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdf: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdi: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdl: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
sdo: checker msg is "emc_clariion_checker: Path not correctly configured
for failover"
[root@ldm1066 log]# multipath -F

I'm thinking this is a configuration issue on the CX ...=20

Any comments / suggestions?

Thanks,
Paul


Messages show the following;

[root@ldm1066 log]# tail -50 ./messages
Nov 15 11:00:50 localhost last message repeated 2 times
Nov 15 11:05:02 localhost kernel: device-mapper: dm-emc: long trespass
command will be send
Nov 15 11:05:02 localhost kernel: device-mapper: dm-emc: honor
reservation bit will not be set (default)
Nov 15 11:05:02 localhost kernel: device-mapper: dm-emc: emc_pg_init:
sending switch-over command
Nov 15 11:05:02 localhost kernel: Device sdl not ready.
Nov 15 11:05:02 localhost kernel: end_request: I/O error, dev sdl,
sector 72
Nov 15 11:05:02 localhost kernel: device-mapper: dm-multipath: Failing
path 8:176.
Nov 15 11:38:16 localhost sshd(pam_unix)[7939]: session opened for user
root by (uid=3D0)
Nov 15 11:43:39 localhost kernel: device-mapper: dm-emc: long trespass
command will be send
Nov 15 11:43:39 localhost kernel: device-mapper: dm-emc: honor
reservation bit will not be set (default)
Nov 15 11:43:40 localhost kernel: device-mapper: dm-emc: long trespass
command will be send
Nov 15 11:43:40 localhost kernel: device-mapper: dm-emc: honor
reservation bit will not be set (default)
Nov 15 11:43:40 localhost kernel: device-mapper: dm-emc: long trespass
command will be send
Nov 15 11:43:40 localhost kernel: device-mapper: dm-emc: honor
reservation bit will not be set (default)
Nov 15 11:43:40 localhost kernel: device-mapper: dm-emc: emc_pg_init:
sending switch-over command
Nov 15 11:43:40 localhost kernel: device-mapper: dm-emc: emc_pg_init:
sending switch-over command
Nov 15 11:43:40 localhost kernel: Device sdl not ready.
Nov 15 11:43:40 localhost kernel: end_request: I/O error, dev sdl,
sector 72
Nov 15 11:43:40 localhost kernel: device-mapper: dm-multipath: Failing
path 8:176.
Nov 15 11:43:40 localhost kernel: Device sdj not ready.
Nov 15 11:43:40 localhost kernel: end_request: I/O error, dev sdj,
sector 72
Nov 15 11:43:40 localhost kernel: device-mapper: dm-multipath: Failing
path 8:144.
Nov 15 11:43:41 localhost kernel: device-mapper: dm-emc: emc_pg_init:
sending switch-over command
Nov 15 11:43:41 localhost kernel: Device sdk not ready.
Nov 15 11:43:41 localhost kernel: end_request: I/O error, dev sdk,
sector 72
Nov 15 11:43:41 localhost kernel: device-mapper: dm-multipath: Failing
path 8:160.
Nov 15 12:19:34 localhost kernel: device-mapper: dm-emc: long trespass
command will be send
Nov 15 12:19:34 localhost kernel: device-mapper: dm-emc: honor
reservation bit will not be set (default)
Nov 15 12:19:34 localhost kernel: device-mapper: dm-emc: long trespass
command will be send
Nov 15 12:19:34 localhost kernel: device-mapper: dm-emc: honor
reservation bit will not be set (default)
Nov 15 12:19:34 localhost kernel: device-mapper: dm-emc: long trespass
command will be send
Nov 15 12:19:34 localhost kernel: device-mapper: dm-emc: honor
reservation bit will not be set (default)
Nov 15 12:19:34 localhost kernel: device-mapper: dm-emc: emc_pg_init:
sending switch-over command
Nov 15 12:19:34 localhost kernel: Device sdl not ready.
Nov 15 12:19:34 localhost kernel: end_request: I/O error, dev sdl,
sector 72
Nov 15 12:19:34 localhost kernel: device-mapper: dm-multipath: Failing
path 8:176.
Nov 15 12:19:34 localhost kernel: Device sdl not ready.
Nov 15 12:19:34 localhost kernel: end_request: I/O error, dev sdl,
sector 209715192
Nov 15 12:19:35 localhost kernel: device-mapper: dm-emc: emc_pg_init:
sending switch-over command
Nov 15 12:19:35 localhost kernel: Device sdj not ready.
Nov 15 12:19:35 localhost kernel: end_request: I/O error, dev sdj,
sector 72
Nov 15 12:19:35 localhost kernel: device-mapper: dm-multipath: Failing
path 8:144.
Nov 15 12:19:35 localhost kernel: Device sdj not ready.
Nov 15 12:19:35 localhost kernel: end_request: I/O error, dev sdj,
sector 209715192
Nov 15 12:19:35 localhost kernel: device-mapper: dm-emc: emc_pg_init:
sending switch-over command
Nov 15 12:19:35 localhost kernel: Device sdk not ready.
Nov 15 12:19:35 localhost kernel: end_request: I/O error, dev sdk,
sector 72
Nov 15 12:19:35 localhost kernel: device-mapper: dm-multipath: Failing
path 8:160.
Nov 15 12:19:35 localhost kernel: Device sdk not ready.
Nov 15 12:19:35 localhost kernel: end_request: I/O error, dev sdk,
sector 209715192
[root@ldm1066 log]# time



devices {
## Device attributes requirements for EMC Symmetrix
## are part of the default definitions and do not require separate
## definition.
## Device attributes for EMC CLARiiON
device {
vendor "DGC "
product "*"
path_grouping_policy group_by_prio
getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
prio_callout "/sbin/mpath_prio_emc /dev/%n"
path_checker emc_clariion
path_selector "round-robin 0"
features "1 queue_if_no_path"
no_path_retry 300
hardware_handler "1 emc"
failback immediate
}
}
