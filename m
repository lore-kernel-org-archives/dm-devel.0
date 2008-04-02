From: "Lancashire, Pete" <plancashire@ci.portland.or.us>
Subject: w/o attachments Need some help - i/o errors
	HDS-USP/Qlogic/RHEL5. 1/
Date: Wed, 2 Apr 2008 09:01:00 -0700
Message-ID: <7EF5BBDCF35CD944A9FDB06AB82AF39909BC8D21@CITYEMAIL2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

files can be found as
  http://petelancashire.com/tsmserver.city.tar.gz
  http://petelancashire.com/system_info-033108_113409.tar.gz
  http://petelancashire.com/QLogicDiag-033108_065720-1.9.tgz

I've just been handed a Linux based system that is being used
as a IBM Tivoli TSM Server. I'm more a Solairs/AIX admin, so
please be kind :)

The person who configured it is no longer with us, and there is
no documentation.

The issue is with the SAN based storage that lives on a Hitachi / HDS
USP SAN. When a backup client writes to the SAN, I get I/O errors and
paths start dropping out, sometimes to the point where all paths have
be pulled off line, and the filesystem will then get corrupted.

I can read and write files all day, last weekend > 12 TB of them
with out a single I/O error. The errors only occure with TSM is backing
up a client. The difference that I can see is that when TSM writes it
does it across many files and such is more random.

I've had the motherboard replace, the HBA replaced. Tivoli/TSM generates
no errors, and the SAN/Director show no errors.

The setup 

Server HP DL585-Gen 1 (x86-64) and has RHEL5.1 on it. 

The HBA in question is a Qlogic QLA2342

The SAN is a HDS USP (OPEN-V)

There are 4 paths from the Director to the HBA, two physical with each
have 2 logical paths.

I've attached the output from the HP and QLogic analysis tools

some config files
-----------------
modprobe.conf
-------------
alias scsi_hostadapter1 qla2xxx_conf
alias scsi_hostadapter2 qla2xxx
alias scsi_hostadapter3 qla2300
alias scsi_hostadapter4 qla2400
#Added by HP rpm installer
alias scsi_hostadapter_mptbase_module mptbase
alias scsi_hostadapter_mptscsih_module mptscsih
alias scsi_hostadapter_mptspi_module mptspi
alias scsi_hostadapter_mptsas_module mptsas
options qla2xxx  ql2xmaxqdepth=16 qlport_down_retry=64
ql2xloginretrycount=16 ql2xfailover=0 ql2xlbType=0 ql2xautorestore=0x0
ConfigRequired=0 ql2xprocessrscn=1 ql2xextended_error_logging=1
#remove qla2xxx /sbin/modprobe -r --first-time --ignore-remove qla2xxx && {
/sbin/modprobe -r --ignore-remove qla2xxx_conf; }

multipath.conf
--------------
defaults {
        udev_dir                /dev
        polling_interval        30
        selector                "round-robin 0"
        path_grouping_policy    multibus
        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
        prio_callout            /bin/true
#       rr_min_io               1000
#       rr_weight               uniform
#       failback                10
#       no_path_retry           10
        user_friendly_name      yes
}
[chop]
multipaths {
        multipath {
                wwid                    360060e80042962000000296200000532
                alias                   TSM-small-disk
        }
        multipath {
                wwid                    360060e80042962000000296200001300
                alias                   lun_1300
        }
[chop]
devices {
device {
               vendor                  "(HITACHI|HP)"
               product                 "OPEN-.*"
               getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
               features                "0"
               hardware_handler        "0"
               path_grouping_policy    multibus
               failback                immediate
               rr_weight               uniform
               ##rr_min_io               100
              #path_checker             readsector0

       }

}
