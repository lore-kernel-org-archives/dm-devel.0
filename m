From: Laurent Riffard <laurent.riffard@free.fr>
Subject: lvresize fails with "reload ioctl failed: Invalid
	argument"
Date: Sun, 10 Sep 2006 23:38:27 +0200
Message-ID: <ee20kk$s7u$1@sea.gmane.org>
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

Hello,

I'm unable to resize any LV, it fails with such a message:

[root@calimero ~]# lvresize --extents +1 /dev/vglinux1/lvswap2
  Extending logical volume lvswap2 to 1.00 GB
  device-mapper: reload ioctl failed: Invalid argument
  Failed to suspend lvswap2

[root@calimero ~]# lvm2 version
  LVM version:     2.02.06 (2006-05-12)
  Library version: 1.02.09 (2006-08-15)
  Driver version:  4.8.0
[root@calimero ~]# cat /proc/version 
Linux version 2.6.18-rc6-mm1 (laurent@calimero.antadix) (gcc version 4.1.1 20060724 (prerelease) (4.1.1-3mdk)) #145 Sun Sep 10 20:48:49 CEST 2006

Is it a known problem ? 


I can't tell precisely when it started to fails. This failure
appeared when I udpated my distro from Mandriva 2006.0 to 2007.0
beta. So I guess I was working with lvm 2.01.09 and libdevmapper
1.01.00. 

Here is some additional info on my environment:
[root@calimero ~]# vgs
  VG       #PV #LV #SN Attr   VSize  VFree 
  vglinux1   2  13   0 wz--n- 36.41G 13.10G
[root@calimero ~]# pvs
  PV         VG       Fmt  Attr PSize  PFree
  /dev/sda4  vglinux1 lvm2 a-   19.07G 3.56G
  /dev/sdb7  vglinux1 lvm2 a-   17.34G 9.54G
[root@calimero ~]# lvs
  LV          VG       Attr   LSize   Origin Snap%  Move Log Copy% 
  lvccache    vglinux1 -wc-ao   2.00G                              
  lvfreenet   vglinux1 -wi-ao   3.27G                              
  lvhome      vglinux1 -wn-ao   7.00G                              
  lvkernel    vglinux1 -wi-ao   2.00G                              
  lvkernel-r4 vglinux1 -wi-a-   2.00G                              
  lvroot      vglinux1 -wi-ao 256.00M                              
  lvroot-old  vglinux1 -wi-a- 256.00M                              
  lvswap      vglinux1 -wi-ao   1.00G                              
  lvswap2     vglinux1 -wi-ao   1.00G                              
  lvtmp       vglinux1 -wi-ao  64.00M                              
  lvusr       vglinux1 -wi-ao   3.50G                              
  lvvar       vglinux1 -wi-ao 504.00M                              
  lvvar-old   vglinux1 -wn-a- 500.00M                              
[root@calimero ~]# lvdisplay -m /dev/vglinux1/lvswap2
  --- Logical volume ---
  LV Name                /dev/vglinux1/lvswap2
  VG Name                vglinux1
  LV UUID                d0jM40-7psI-O7uP-ocsn-cuIL-AJN0-eYxtMo
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                1.00 GB
  Current LE             256
  Segments               1
  Allocation             inherit
  Read ahead sectors     0
  Block device           254:9
   
  --- Segments ---
  Logical extent 0 to 255:
    Type                linear
    Physical volume     /dev/sdb7
    Physical extents    1681 to 1936
   
[root@calimero ~]# lvresize -vvv --extents +1 /dev/vglinux1/lvswap2
.....
    Loading vglinux1-lvswap2 table
        Adding target: 0 2097152 linear 8:23 13771136
        Adding target: 2097152 8192 linear 8:23 23683456
        dm table   (254:9) O   [16384]
        dm reload   (254:9) N   [16384]
  device-mapper: reload ioctl failed: Invalid argument
  Failed to suspend lvswap2
        Wiping pre-committed vglinux1 metadata from /dev/sda4 header at 2048
        Wiping pre-committed vglinux1 metadata from /dev/sdb7 header at 2048
      Unlocking /var/lock/lvm/V_vglinux1
        Closed /dev/sda4
        Closed /dev/sdb7
[root@calimero ~]#

Thanks for your help
~~
laurent
