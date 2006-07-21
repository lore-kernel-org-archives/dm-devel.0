From: "Mindaugas" <mind@bi.lt>
Subject: dm multipath on HP MSA1500
Date: Fri, 21 Jul 2006 14:11:34 +0300
Message-ID: <030a01c6acb6$6df9f180$f20214ac@bite.lt>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1257"
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


  Hello,

  Posted this to RHEL4 list bot got no answer. So trying to ask here.
Also I found this document:
http://h20000.www2.hp.com/bc/docs/support/SupportManual/c00635587/c00635587.pdf?jumpid=reg_R1002_USEN
  and it says that dm multipath is not supported for active-passive
storage.

------------------------------------------------------------------------

  I'm trying to upgrade our RHEL3 machine to RHEL4 and now have problems
with multipath.

  System is HP DL385 (Opteron) server with two QLogic 2312 FC controllers
connected to HP MSA1500 storage (active/passive).

  Like specified in documents I edited /etc/multipath.conf file but have
few problems.

  First if I add the following line to /etc/fstab:
/dev/mpath/mpath0p1 /stor ext3 noatime,data=writeback  1 2

  during boot I got such fsck errors:

Checking root filesystem
/dev/VolGroup00/root: clean, 27140/524288 files, 220798/1048576 blocks
                                                           [  OK  ]
Remounting root filesystem in read-write mode:             [  OK  ]
Setting up Logical Volume Management:                      [  OK  ]
Checking filesystems
/boot: clean, 34/26104 files, 13499/104388 blocks
/dev/VolGroup00/ora: clean, 27/13107200 files, 434800/262144001blocks
/dev/VolGroup00/var: clean, 168/1310720 files, 60040/2621440 blocks
fsck.ext3/dev/mpath/mpath0p1:
The superblock could not be read or does not describe a correct
filesystem.  If the device is valid and it really contains an ext2
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>

: No such file or directory while trying to open /dev/mpath/mpath0p1

  It looks like /dev/mpath/mpath0p1 symlink is created a bit later. But what
to specify in /etc/fstab? /dev/dm-5 is clearly not a solution since it can
change after any reboot.

  /etc/multipath.conf is below. multipath output:
# multipath -ll
mpath0 (3600508b300908600ac54cf7b31f50003)
[size=143 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 0:0:0:3 sda 8:0  [active][ghost]
\_ round-robin 0 [enabled]
 \_ 1:0:0:3 sdb 8:16 [active][ready]

  Also what to put for path_grouping_policy and path_checker? And dmesg
is being filled with such messages:
Device sda not ready.
end_request: I/O error, dev sda, sector 4255
device-mapper: dm-multipath: Failing path 8:0.

  I tried to call our HP representative (we bought RHEL via HP) but got an
answer that supported solution by HP is QLogic driver.

  Thanks,

  Mindaugas

defaults {
        user_friendly_names yes
}
defaults {
        udev_dir                /dev
        polling_interval        10
        selector                "round-robin 0"
        path_grouping_policy    failover
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            /bin/true
        path_checker            hp_sw
        rr_min_io               100
        rr_weight               priorities
        failback                immediate
        no_path_retry           fail
        user_friendly_name      yes
}
devnode_blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z]"
        devnode "^cciss!c[0-9]d[0-9]*"
}
