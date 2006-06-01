From: MAHMOUD HANAFI <hanafim@asc.hpc.mil>
Subject: wrong fs type when trying to mount after a reboot
Date: Thu, 01 Jun 2006 14:01:48 -0400
Message-ID: <447F2B8C.4020706@asc.hpc.mil>
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

I am running 2.6.9-22.ELsmp kernel with device-mapper-multipath-0.4.5-6.0.RHEL4. I have multipath 
configure and working. My HBA's are Emulex LP11000.

[root@io1 device-mapper-multipath-0.4.5]# ls -l  /dev/mpath/*
lrwxrwxrwx  1 root root 7 May 31 17:21 /dev/mpath/2000b080009001474 -> ../dm-0
lrwxrwxrwx  1 root root 7 May 31 17:21 /dev/mpath/2000b08000b001474 -> ../dm-1
[root@io1 device-mapper-multipath-0.4.5]# lvmdiskscan
   /dev/hda                     [      238.12 MB]
   /dev/mpath/2000b080009001474 [        1.22 TB] LVM physical volume
   /dev/sda1                    [       62.72 MB]
   /dev/mpath/2000b08000b001474 [      150.73 GB] LVM physical volume
   /dev/sda2                    [      509.88 MB]
   /dev/io1_vg1/io1_lv1         [        1.22 TB] LVM physical volume
   /dev/sda3                    [        7.81 GB]
   /dev/root                    [        7.81 GB]
   /dev/sda6                    [       52.05 GB]
   2 disks
   4 partitions
   0 LVM physical volume whole disks
   3 LVM physical volumes

I can create an ext3 filesystem on /dev/dm-1 and mount it. But if I reboot the node and try mounting 
the filesystem I get the following error:

[root@io1 device-mapper-multipath-0.4.5]# mount -t ext3 /dev/dm-1 /nfswork/
mount: wrong fs type, bad option, bad superblock on /dev/dm-1,
        or too many mounted file systems


----- /etc/multipath.conf ----
defaults {
         multipath_tool  "/sbin/multipath -v0"
         udev_dir        /dev
         polling_interval 10
         default_selector        "round-robin 0"
         default_path_grouping_policy    multibus
         default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
         default_prio_callout    "/bin/true"
         default_features        "0"
         rr_wmin_io              100
         failback                immediate
}
devnode_blacklist {

         devnode "^(sda|hda)[0-9]*"

}
-----------------------------------------------

-Mahmoud
