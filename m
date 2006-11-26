From: Petteri Heinonen <petteri.j.heinonen@kolumbus.fi>
Subject: I/O error during path failover
Date: Sun, 26 Nov 2006 15:27:08 +0200 (EET)
Message-ID: <27284436.1305071164547629015.JavaMail.petteri.j.heinonen@kolumbus.fi>
Reply-To: petteri.j.heinonen@kolumbus.fi,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; Charset=iso-8859-1; Format=Flowed
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

I have a system with Qlogic QLA2312 HBAs. System is running RHEL 4u4:

[root@cpn-0 etc]# uname -a
Linux cpn-0.chas1A.ucs2.net 2.6.9-42.ELsmp #1 SMP Wed Jul 12 23:27:17 EDT 2006 i686 i686 i386 GNU/Linux
[root@cpn-0 etc]# rpm -qa | grep device
device-mapper-1.02.07-4.0.RHEL4
device-mapper-multipath-0.4.5-18.1.RHEL4
[root@cpn-0 etc]#

Storage is EMC Cx500. Multipath.conf is at the end of the mail. I have tested the system by running I/O directly to multipath device file, e.g. like this:

dd if=/dev/mpath/dm-0 of=/dev/null count=10000000

Now, when I pull the cable to cause path change, dd usually stops in the middle, and gives error message indicating I/O error. Any suggestions?

- Petteri Heinonen

[root@cpn-0 etc]# cat /etc/multipath.conf
defaults {
  multipath_tool                  "/sbin/multipath -v0"
  udev_dir                        /dev
  polling_interval                10
}

devnode_blacklist {
  devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
  devnode "^hd[a-z][[0-9]*]"
  devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}

multipaths {
  multipath {
    wwid                    360060160df651000a83bbca2f1eeda11
    alias                   global_data
    path_grouping_policy    failover
    no_path_retry           fail
    path_selector           "round-robin 0"
    failback                manual
  }

  multipath {
    wwid                    360060160df651000a2dac95713d1da11
    alias                   global_sw
    path_grouping_policy    failover
    no_path_retry           fail
    path_selector           "round-robin 0"
    failback                manual
  }

  multipath {
    wwid                    360060160df651000a93bbca2f1eeda11
    alias                   global_log
    path_grouping_policy    failover
    no_path_retry           fail
    path_selector           "round-robin 0"
    failback                manual
  }

  multipath {
    wwid                    360060160df651000445c248c15d1da11
    alias                   global_backup
    path_grouping_policy    failover
    no_path_retry           fail
    path_selector           "round-robin 0"
    failback                manual
  }

}
devices {
  device {
    vendor                  "DGC"
    product                 "*"
    getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
    prio_callout            "/sbin/mpath_prio_emc /dev/%n"
    path_checker            emc_clariion
    hardware_handler        "1 emc"
  }
}
