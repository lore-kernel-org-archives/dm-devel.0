From: ml ml <mliebherr99@googlemail.com>
Subject: Need help with multipathd
Date: Thu, 18 Aug 2011 15:25:49 +0200
Message-ID: <CANFxOjAnx2HZNxuovXC3f9fRTrQPKpO1JPc2pR2Fs5F_Q+VbTA@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello List,

i am trying to set up multipathd with a Qlogic FC HBA. In my debian
squeeze i can see 4 scsi devices:
- sda
- sdb
- sdc
- sdd

Here my /etc/etc/multipath.conf file (this config is kind of guessed):
I actually would like to have redundancy/fallback, not round robin....:
===============================================
blacklist {
        devnode "sda"
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z][[0-9]*]"

}

defaults {
        user_friendly_names no
        udev_dir                /dev
        polling_interval        10
        verbosity               3
        path_grouping_policy    failover

}

multipaths {
       multipath {
               wwid                    3600a0b80001f7557000032864ce4aff3
               alias                   SAN
               path_grouping_policy    failover
               path_selector           "round-robin 0"
               failback                manual
               rr_weight               priorities
               no_path_retry           5
               rr_min_io               100
       }
}

devices {
       device {
               vendor                  "IBM"
               product                 "1722-600"
               path_grouping_policy    failover
       }
}


However, i dont seem to get a device-mapper device. Here is some logfile info:
Aug 15 11:14:07 www-neu multipathd: loading
/lib/multipath/libcheckdirectio.so checker
Aug 15 11:14:07 www-neu multipathd: loading
/lib/multipath/libprioconst.so prioritizer
Aug 15 11:14:07 www-neu multipathd: sda: device node name blacklisted
Aug 15 11:14:07 www-neu multipathd: sdb: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdb: mask = 0x1f
Aug 15 11:14:07 www-neu multipathd: sdb: dev_t = 8:16
Aug 15 11:14:07 www-neu multipathd: sdb: size = 524288000
Aug 15 11:14:07 www-neu multipathd: sdb: subsystem = scsi
Aug 15 11:14:07 www-neu multipathd: sdb: vendor = IBM
Aug 15 11:14:07 www-neu multipathd: sdb: product = 1722-600
Aug 15 11:14:07 www-neu multipathd: sdb: rev = 0914
Aug 15 11:14:07 www-neu multipathd: sdb: h:b:t:l = 2:0:0:0
Aug 15 11:14:07 www-neu multipathd: sdb: tgt_node_name = 0x200400a0b816fb7
Aug 15 11:14:07 www-neu multipathd: sdb: serial = 1T64056377
Aug 15 11:14:07 www-neu multipathd: sdb: get_state
Aug 15 11:14:07 www-neu multipathd: loading
/lib/multipath/libcheckrdac.so checker
Aug 15 11:14:07 www-neu multipathd: sdb: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdb: state = running
Aug 15 11:14:07 www-neu multipathd: sdb: state = 3
Aug 15 11:14:07 www-neu multipathd: loading
/lib/multipath/libpriordac.so prioritizer
Aug 15 11:14:07 www-neu multipathd: sdb: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdb: rdac prio = 3
Aug 15 11:14:07 www-neu multipathd: sdb: getuid = /lib/udev/scsi_id
--whitelisted --device=/dev/%n (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdb: uid =
3600a0b80001f7557000032864ce4aff3 (callout)
Aug 15 11:14:07 www-neu multipathd: sdc: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdc: mask = 0x1f
Aug 15 11:14:07 www-neu multipathd: sdc: dev_t = 8:32
Aug 15 11:14:07 www-neu multipathd: sdc: size = 524288000
Aug 15 11:14:07 www-neu multipathd: sdc: subsystem = scsi
Aug 15 11:14:07 www-neu multipathd: sdc: vendor = IBM
Aug 15 11:14:07 www-neu multipathd: sdc: product = 1722-600
Aug 15 11:14:07 www-neu multipathd: sdc: rev = 0914
Aug 15 11:14:07 www-neu multipathd: sdc: h:b:t:l = 3:0:0:0
Aug 15 11:14:07 www-neu multipathd: sdc: tgt_node_name = 0x200400a0b816fb7
Aug 15 11:14:07 www-neu multipathd: sdc: serial = 1T64056377
Aug 15 11:14:07 www-neu multipathd: sdc: get_state
Aug 15 11:14:07 www-neu multipathd: sdc: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdc: state = running
Aug 15 11:14:07 www-neu multipathd: sdc: state = 3
Aug 15 11:14:07 www-neu multipathd: sdc: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdc: rdac prio = 3
Aug 15 11:14:07 www-neu multipathd: sdc: getuid = /lib/udev/scsi_id
--whitelisted --device=/dev/%n (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdc: uid =
3600a0b80001f7557000032864ce4aff3 (callout)
Aug 15 11:14:07 www-neu multipathd: sdd: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdd: mask = 0x1f
Aug 15 11:14:07 www-neu multipathd: sdd: dev_t = 8:48
Aug 15 11:14:07 www-neu multipathd: sdd: size = 524288000
Aug 15 11:14:07 www-neu multipathd: sdd: subsystem = scsi
Aug 15 11:14:07 www-neu multipathd: sdd: vendor = IBM
Aug 15 11:14:07 www-neu multipathd: sdd: product = 1722-600
Aug 15 11:14:07 www-neu multipathd: sdd: rev = 0914
Aug 15 11:14:07 www-neu multipathd: sdd: h:b:t:l = 2:0:1:0
Aug 15 11:14:07 www-neu multipathd: sdd: tgt_node_name = 0x200400a0b816fb7
Aug 15 11:14:07 www-neu multipathd: sdd: serial = 1T53176340
Aug 15 11:14:07 www-neu multipathd: sdd: get_state
Aug 15 11:14:07 www-neu multipathd: sdd: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdd: state = running
Aug 15 11:14:07 www-neu multipathd: sdd: state = 5
Aug 15 11:14:07 www-neu multipathd: sdd: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdd: rdac prio = 4
Aug 15 11:14:07 www-neu multipathd: sdd: getuid = /lib/udev/scsi_id
--whitelisted --device=/dev/%n (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdd: uid =
3600a0b80001f7557000032864ce4aff3 (callout)
Aug 15 11:14:07 www-neu multipathd: sde: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sde: mask = 0x1f
Aug 15 11:14:07 www-neu multipathd: sde: dev_t = 8:64
Aug 15 11:14:07 www-neu multipathd: sde: size = 524288000
Aug 15 11:14:07 www-neu multipathd: sde: subsystem = scsi
Aug 15 11:14:07 www-neu multipathd: sde: vendor = IBM
Aug 15 11:14:07 www-neu multipathd: sde: product = 1722-600
Aug 15 11:14:07 www-neu multipathd: sde: rev = 0914
Aug 15 11:14:07 www-neu multipathd: sde: h:b:t:l = 3:0:1:0
Aug 15 11:14:07 www-neu multipathd: sde: tgt_node_name = 0x200400a0b816fb7
Aug 15 11:14:07 www-neu multipathd: sde: serial = 1T53176340
Aug 15 11:14:07 www-neu multipathd: sde: get_state
Aug 15 11:14:07 www-neu multipathd: sde: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sde: state = running
Aug 15 11:14:07 www-neu multipathd: sde: state = 5
Aug 15 11:14:07 www-neu multipathd: sde: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sde: rdac prio = 4
Aug 15 11:14:07 www-neu multipathd: sde: getuid = /lib/udev/scsi_id
--whitelisted --device=/dev/%n (controller setting)
Aug 15 11:14:07 www-neu multipathd: sde: uid =
3600a0b80001f7557000032864ce4aff3 (callout)
Aug 15 11:14:07 www-neu multipathd: sr0: device node name blacklisted
Aug 15 11:14:07 www-neu multipathd: loop0: device node name blacklisted
Aug 15 11:14:07 www-neu multipathd: loop1: device node name blacklisted
Aug 15 11:14:07 www-neu multipathd: loop2: device node name blacklisted
Aug 15 11:14:07 www-neu multipathd: loop3: device node name blacklisted
Aug 15 11:14:07 www-neu multipathd: loop4: device node name blacklisted
Aug 15 11:14:07 www-neu multipathd: loop5: device node name blacklisted
Aug 15 11:14:07 www-neu multipathd: loop6: device node name blacklisted
Aug 15 11:14:07 www-neu multipathd: loop7: device node name blacklisted
Aug 15 11:14:07 www-neu multipathd: sdb: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sdb: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdb: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sdb: get_state
Aug 15 11:14:07 www-neu multipathd: sdb: state = running
Aug 15 11:14:07 www-neu multipathd: sdb: state = 3
Aug 15 11:14:07 www-neu multipathd: sdb: rdac prio = 3
Aug 15 11:14:07 www-neu multipathd: sdc: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sdc: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdc: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sdc: get_state
Aug 15 11:14:07 www-neu multipathd: sdc: state = running
Aug 15 11:14:07 www-neu multipathd: sdc: state = 3
Aug 15 11:14:07 www-neu multipathd: sdc: rdac prio = 3
Aug 15 11:14:07 www-neu multipathd: sdd: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sdd: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdd: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sdd: get_state
Aug 15 11:14:07 www-neu multipathd: sdd: state = running
Aug 15 11:14:07 www-neu multipathd: sdd: state = 5
Aug 15 11:14:07 www-neu multipathd: sdd: rdac prio = 4
Aug 15 11:14:07 www-neu multipathd: sde: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sde: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sde: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sde: get_state
Aug 15 11:14:07 www-neu multipathd: sde: state = running
Aug 15 11:14:07 www-neu multipathd: sde: state = 5
Aug 15 11:14:07 www-neu multipathd: sde: rdac prio = 4
Aug 15 11:14:07 www-neu multipathd: SAN: pgfailback = -1 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: pgpolicy = failover (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: selector = round-robin 0 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: features = 1 queue_if_no_path
(controller setting)
Aug 15 11:14:07 www-neu multipathd: SAN: hwhandler = 1 rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: SAN: rr_weight = 2 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: minio = 100 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: no_path_retry = 5 (multipath setting)
Aug 15 11:14:07 www-neu multipathd: pg_timeout = NONE (internal default)
Aug 15 11:14:07 www-neu multipathd: SAN: set ACT_CREATE (map does not exist)
Aug 15 11:14:07 www-neu kernel: [   62.975868] device-mapper: table:
254:0: multipath: error getting device
Aug 15 11:14:07 www-neu kernel: [   62.975943] device-mapper: ioctl:
error adding target to table
Aug 15 11:14:07 www-neu kernel: [   62.990289] device-mapper: table:
254:0: multipath: error getting device
Aug 15 11:14:07 www-neu kernel: [   62.990355] device-mapper: ioctl:
error adding target to table
Aug 15 11:14:07 www-neu multipathd: SAN: domap (0) failure for create/reload map
Aug 15 11:14:07 www-neu multipathd: sdb: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sdb: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdb: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sdb: get_state
Aug 15 11:14:07 www-neu multipathd: sdb: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdb: state = running
Aug 15 11:14:07 www-neu multipathd: sdb: state = 3
Aug 15 11:14:07 www-neu multipathd: sdb: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdb: rdac prio = 3
Aug 15 11:14:07 www-neu multipathd: sdc: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sdc: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdc: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sdc: get_state
Aug 15 11:14:07 www-neu multipathd: sdc: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdc: state = running
Aug 15 11:14:07 www-neu multipathd: sdc: state = 3
Aug 15 11:14:07 www-neu multipathd: sdc: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdc: rdac prio = 3
Aug 15 11:14:07 www-neu multipathd: sdd: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sdd: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdd: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sdd: get_state
Aug 15 11:14:07 www-neu multipathd: sdd: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdd: state = running
Aug 15 11:14:07 www-neu multipathd: sdd: state = 5
Aug 15 11:14:07 www-neu multipathd: sdd: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdd: rdac prio = 4
Aug 15 11:14:07 www-neu multipathd: sde: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sde: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sde: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sde: get_state
Aug 15 11:14:07 www-neu multipathd: sde: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sde: state = running
Aug 15 11:14:07 www-neu multipathd: sde: state = 5
(...SNIP...)
Aug 15 11:14:07 www-neu multipathd: sdc: get_state
Aug 15 11:14:07 www-neu multipathd: sdc: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdc: state = running
Aug 15 11:14:07 www-neu multipathd: sdc: state = 3
Aug 15 11:14:07 www-neu multipathd: sdc: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdc: rdac prio = 3
Aug 15 11:14:07 www-neu multipathd: sdd: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sdd: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdd: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sdd: get_state
Aug 15 11:14:07 www-neu multipathd: sdd: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdd: state = running
Aug 15 11:14:07 www-neu multipathd: sdd: state = 5
Aug 15 11:14:07 www-neu multipathd: sdd: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdd: rdac prio = 4
Aug 15 11:14:07 www-neu multipathd: sde: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sde: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sde: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sde: get_state
Aug 15 11:14:07 www-neu multipathd: sde: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sde: state = running
Aug 15 11:14:07 www-neu multipathd: sde: state = 5
Aug 15 11:14:07 www-neu multipathd: sde: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sde: rdac prio = 4
Aug 15 11:14:07 www-neu multipathd: SAN: pgfailback = -1 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: pgpolicy = failover (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: selector = round-robin 0 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: features = 1 queue_if_no_path
(controller setting)
Aug 15 11:14:07 www-neu multipathd: SAN: hwhandler = 1 rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: SAN: rr_weight = 2 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: minio = 100 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: no_path_retry = 5 (multipath setting)
Aug 15 11:14:07 www-neu multipathd: pg_timeout = NONE (internal default)
Aug 15 11:14:07 www-neu multipathd: SAN: set ACT_CREATE (map does not exist)
Aug 15 11:14:07 www-neu kernel: [   63.052995] device-mapper: table:
254:0: multipath: error getting device
Aug 15 11:14:07 www-neu kernel: [   63.053064] device-mapper: ioctl:
error adding target to table
Aug 15 11:14:07 www-neu kernel: [   63.066467] device-mapper: table:
254:0: multipath: error getting device
Aug 15 11:14:07 www-neu kernel: [   63.066533] device-mapper: ioctl:
error adding target to table
Aug 15 11:14:07 www-neu multipathd: SAN: domap (0) failure for create/reload map
Aug 15 11:14:07 www-neu multipathd: sdb: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sdb: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdb: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sdb: get_state
Aug 15 11:14:07 www-neu multipathd: sdb: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdb: state = running
Aug 15 11:14:07 www-neu multipathd: sdb: state = 3
Aug 15 11:14:07 www-neu multipathd: sdb: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdb: rdac prio = 3
Aug 15 11:14:07 www-neu multipathd: sdc: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sdc: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdc: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sdc: get_state
Aug 15 11:14:07 www-neu multipathd: sdc: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdc: state = running
Aug 15 11:14:07 www-neu multipathd: sdc: state = 3
Aug 15 11:14:07 www-neu multipathd: sdc: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdc: rdac prio = 3
Aug 15 11:14:07 www-neu multipathd: sdd: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sdd: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sdd: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sdd: get_state
Aug 15 11:14:07 www-neu multipathd: sdd: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sdd: state = running
Aug 15 11:14:07 www-neu multipathd: sdd: state = 5
Aug 15 11:14:07 www-neu multipathd: sdd: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sdd: rdac prio = 4
Aug 15 11:14:07 www-neu multipathd: sde: ownership set to SAN
Aug 15 11:14:07 www-neu multipathd: sde: not found in pathvec
Aug 15 11:14:07 www-neu multipathd: sde: mask = 0xc
Aug 15 11:14:07 www-neu multipathd: sde: get_state
Aug 15 11:14:07 www-neu multipathd: sde: path checker = rdac
(controller setting)
Aug 15 11:14:07 www-neu multipathd: sde: state = running
Aug 15 11:14:07 www-neu multipathd: sde: state = 5
Aug 15 11:14:07 www-neu multipathd: sde: prio = rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: sde: rdac prio = 4
Aug 15 11:14:07 www-neu multipathd: SAN: pgfailback = -1 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: pgpolicy = failover (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: selector = round-robin 0 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: features = 1 queue_if_no_path
(controller setting)
Aug 15 11:14:07 www-neu multipathd: SAN: hwhandler = 1 rdac (controller setting)
Aug 15 11:14:07 www-neu multipathd: SAN: rr_weight = 2 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: minio = 100 (LUN setting)
Aug 15 11:14:07 www-neu multipathd: SAN: no_path_retry = 5 (multipath setting)
Aug 15 11:14:07 www-neu multipathd: pg_timeout = NONE (internal default)
Aug 15 11:14:07 www-neu multipathd: SAN: set ACT_CREATE (map does not exist)
Aug 15 11:14:07 www-neu kernel: [   63.085217] device-mapper: table:
254:0: multipath: error getting device
Aug 15 11:14:07 www-neu kernel: [   63.085289] device-mapper: ioctl:
error adding target to table
Aug 15 11:14:07 www-neu kernel: [   63.099267] device-mapper: table:
254:0: multipath: error getting device
Aug 15 11:14:07 www-neu kernel: [   63.099334] device-mapper: ioctl:
error adding target to table
Aug 15 11:14:07 www-neu multipathd: SAN: domap (0) failure for create/reload map
Aug 15 11:14:07 www-neu multipathd: reading events from udev socket.
Aug 15 11:14:07 www-neu multipathd: path checkers start up
Aug 15 11:14:07 www-neu multipathd: uevent 'remove' from
'/devices/virtual/block/dm-0'
Aug 15 11:14:07 www-neu multipathd: UDEV_LOG=3
Aug 15 11:14:07 www-neu multipathd: ACTION=remove
Aug 15 11:14:07 www-neu multipathd: DEVPATH=/devices/virtual/block/dm-0
Aug 15 11:14:07 www-neu multipathd: SUBSYSTEM=block
Aug 15 11:14:07 www-neu multipathd: DM_COOKIE=4390912
Aug 15 11:14:07 www-neu multipathd: DEVNAME=/dev/dm-0
Aug 15 11:14:07 www-neu multipathd: DEVTYPE=disk
Aug 15 11:14:07 www-neu multipathd: SEQNUM=1244
Aug 15 11:14:07 www-neu multipathd: MAJOR=254
Aug 15 11:14:07 www-neu multipathd: MINOR=0
Aug 15 11:14:07 www-neu multipathd: DEVLINKS=/dev/block/254:0
Aug 15 11:14:07 www-neu multipathd: DM_UDEV_DISABLE_DM_RULES_FLAG=1
Aug 15 11:14:07 www-neu multipathd: DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG=1
Aug 15 11:14:07 www-neu multipathd: DM_UDEV_PRIMARY_SOURCE_FLAG=1
Aug 15 11:14:07 www-neu multipathd: uevent 'remove' from
'/devices/virtual/block/dm-0'
Aug 15 11:14:07 www-neu multipathd: UDEV_LOG=3
Aug 15 11:14:07 www-neu multipathd: ACTION=remove
Aug 15 11:14:07 www-neu multipathd: DEVPATH=/devices/virtual/block/dm-0
Aug 15 11:14:07 www-neu multipathd: SUBSYSTEM=block
Aug 15 11:14:07 www-neu multipathd: DEVNAME=dm-0
Aug 15 11:14:07 www-neu multipathd: DEVTYPE=disk
Aug 15 11:14:07 www-neu multipathd: SEQNUM=1246
Aug 15 11:14:07 www-neu multipathd: MAJOR=254
Aug 15 11:14:07 www-neu multipathd: MINOR=0


Anyone an idea why it wont create the device mapper device?

Thanks,
Mario
