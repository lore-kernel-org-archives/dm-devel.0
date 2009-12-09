From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: todays git regression (2.6.32-04008.g3ff6a46): lot of device mapper warnings
Date: Wed, 9 Dec 2009 10:49:12 +0100
Message-ID: <200912091049.12604.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_YK3HLwfrEUtecl3"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753479AbZLIJtO@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

--Boundary-00=_YK3HLwfrEUtecl3
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

with todays git I got a huge amount of warnings for device mapper:
device-mapper: uevent: version 1.0.3                                                                              
device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com                                  
device-mapper: table: 252:0: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=196608                                                                                
device-mapper: table: 252:0: target device dasde1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=196608                                                                                
device-mapper: table: 252:0: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=196608                                                                                
device-mapper: table: 252:0: target device dasde1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=196608                                                                                
device-mapper: table: 252:1: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=5368905728                                                                            
device-mapper: table: 252:1: target device dasde1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=5368905728                                                                            
device-mapper: table: 252:1: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=5368905728                                                                            
device-mapper: table: 252:1: target device dasde1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=5368905728                                                                            
device-mapper: table: 252:2: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=6979518464                                                                            
device-mapper: table: 252:2: target device dasde1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=6979518464                                                                            
device-mapper: table: 252:2: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=6979518464                                                                            
device-mapper: table: 252:2: target device dasde1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=6979518464                                                                            
device-mapper: table: 252:3: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=7189233664 
[...]

But the system seems to work fine.
The same devices produce no warning with a 2.6.32 vanilla kernel.

[root@t63lp34 ~]# pvdisplay                                                                                                   
  --- Physical volume ---                                                                                                                                    
  PV Name               /dev/dasdf1                                                                                                                          
  VG Name               space                                                                                                                                
  PV Size               22.49 GB / not usable 2.28 MB                                                                                                        
  Allocatable           yes                                                                                                                                  
  PE Size (KByte)       4096                                                                                                                                                        
  Total PE              5758                                                                                                                                                        
  Free PE               3                                                                                                                                                           
  Allocated PE          5755                                                                                                                                                        
  PV UUID               Uocvlz-I6wv-JtLH-8W5L-ziib-pP7h-4Qdzgz                                                                                                                      
                                                                                                                                                                                    
  --- Physical volume ---
  PV Name               /dev/dasde1
  VG Name               space
  PV Size               22.49 GB / not usable 2.28 MB
  Allocatable           yes
  PE Size (KByte)       4096
  Total PE              5758
  Free PE               15
  Allocated PE          5743
  PV UUID               UuM16H-GUdC-gfA3-3yvE-c5Af-UVPW-Cfe2no

  --- Physical volume ---
  PV Name               /dev/dasdd1
  VG Name               space
  PV Size               4.59 GB / not usable 3.38 MB
  Allocatable           yes (but full)
  PE Size (KByte)       4096
  Total PE              1173
  Free PE               0
  Allocated PE          1173
  PV UUID               800CzR-0hjD-lL6Z-yQPt-vRcl-WlYp-cUtZwJ

  --- Physical volume ---
  PV Name               /dev/dasdc1
  VG Name               space
  PV Size               4.59 GB / not usable 3.38 MB
  Allocatable           yes
  PE Size (KByte)       4096
  Total PE              1173
  Free PE               12
  Allocated PE          1161
  PV UUID               hG8bJE-xYJL-eo0N-tsD5-kdcH-AONB-FGdtAK

[root@t63lp34 ~]# vgdisplay
  --- Volume group ---
  VG Name               space
  System ID
  Format                lvm2
  Metadata Areas        4
  Metadata Sequence No  96
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                65
  Open LV               4
  Max PV                0
  Cur PV                4
  Act PV                4
  VG Size               54.15 GB
  PE Size               4.00 MB
  Total PE              13862
  Alloc PE / Size       13832 / 54.03 GB
  Free  PE / Size       30 / 120.00 MB
  VG UUID               AcRPg8-6DaJ-ND6i-s3H7-Sh5V-8KWa-KtKRmv


--Boundary-00=_YK3HLwfrEUtecl3
Content-Type: text/plain;
  charset="UTF-8";
  name="lvdisplay.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lvdisplay.txt"

  --- Logical volume ---
  LV Name                /dev/space/space
  VG Name                space
  LV UUID                fdSSaQ-yXkL-EoK2-Ai52-Gzjw-J4jz-DWGVIu
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                10.00 GB
  Current LE             2560
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0
   
  --- Segments ---
  Logical extent 0 to 2559:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	0 to 1279
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	0 to 1279
   
   
  --- Logical volume ---
  LV Name                /dev/space/usr
  VG Name                space
  LV UUID                m46wUu-2P22-VNgE-vHuI-GD0l-MwlD-5rvxgS
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                3.00 GB
  Current LE             768
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:1
   
  --- Segments ---
  Logical extent 0 to 767:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	1280 to 1663
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	1280 to 1663
   
   
  --- Logical volume ---
  LV Name                /dev/space/r1
  VG Name                space
  LV UUID                o3nium-c6HG-9zfQ-CKXR-jQDa-vSB1-o28prX
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:2
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	1664 to 1713
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	1664 to 1713
   
   
  --- Logical volume ---
  LV Name                /dev/space/s1
  VG Name                space
  LV UUID                vGsxRn-Zeko-WpJ9-mFSv-Q0F7-3jz4-fcASPn
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:3
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	1714 to 1763
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	1714 to 1763
   
   
  --- Logical volume ---
  LV Name                /dev/space/r2
  VG Name                space
  LV UUID                82xvhL-T117-x5X0-knbx-CDYc-VrRS-a91A9o
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:4
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	1764 to 1813
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	1764 to 1813
   
   
  --- Logical volume ---
  LV Name                /dev/space/s2
  VG Name                space
  LV UUID                dKgX5f-Zp7d-0EN2-sobR-ZCbA-ksZS-nhAds2
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:5
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	1814 to 1863
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	1814 to 1863
   
   
  --- Logical volume ---
  LV Name                /dev/space/r3
  VG Name                space
  LV UUID                U07Suj-iDZZ-vjcR-3xCa-r0EF-Oljt-Mq2LqU
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:6
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	1864 to 1913
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	1864 to 1913
   
   
  --- Logical volume ---
  LV Name                /dev/space/s3
  VG Name                space
  LV UUID                RCPF1v-p6ab-dgAo-1mcl-evPJ-q7md-ozUSVw
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:7
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	1914 to 1963
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	1914 to 1963
   
   
  --- Logical volume ---
  LV Name                /dev/space/r4
  VG Name                space
  LV UUID                8pVIKo-23jG-cTLF-Pd87-zD4T-kCRd-Txnq9L
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:8
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	1964 to 2013
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	1964 to 2013
   
   
  --- Logical volume ---
  LV Name                /dev/space/s4
  VG Name                space
  LV UUID                KtdttC-9LVf-eyna-mGDm-W3qe-4eC7-Iu2CSE
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:9
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2014 to 2063
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2014 to 2063
   
   
  --- Logical volume ---
  LV Name                /dev/space/r5
  VG Name                space
  LV UUID                fenrJT-jooG-HK90-IDVT-3tqg-neTn-CecfGY
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:10
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2064 to 2113
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2064 to 2113
   
   
  --- Logical volume ---
  LV Name                /dev/space/s5
  VG Name                space
  LV UUID                CCqiL9-u5G6-DbKi-9Bc5-p6M2-n1jb-vcfjuW
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:11
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2114 to 2163
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2114 to 2163
   
   
  --- Logical volume ---
  LV Name                /dev/space/r6
  VG Name                space
  LV UUID                gqC4u6-a7v8-8bXW-Kpx0-OS9y-Ewpg-JHjUGP
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:12
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2164 to 2213
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2164 to 2213
   
   
  --- Logical volume ---
  LV Name                /dev/space/s6
  VG Name                space
  LV UUID                82lRZ1-zcJk-VZi8-ieEt-r9di-tIc0-UDhLbX
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:13
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2214 to 2263
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2214 to 2263
   
   
  --- Logical volume ---
  LV Name                /dev/space/r7
  VG Name                space
  LV UUID                uGqt2G-H2So-qd9J-Iy7x-To0d-rZ10-MhrVnu
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:14
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2264 to 2313
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2264 to 2313
   
   
  --- Logical volume ---
  LV Name                /dev/space/s7
  VG Name                space
  LV UUID                OK1kke-R0O3-T5Yk-2ZWR-g8P2-HWch-5ZJY9J
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:15
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2314 to 2363
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2314 to 2363
   
   
  --- Logical volume ---
  LV Name                /dev/space/r8
  VG Name                space
  LV UUID                NnzKJe-AELf-tOjG-exG2-AHal-PIY3-5tGMuB
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:16
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2364 to 2413
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2364 to 2413
   
   
  --- Logical volume ---
  LV Name                /dev/space/s8
  VG Name                space
  LV UUID                SfJPIf-tkBA-YFYC-H1YI-9Rn4-Zr6t-L4oMo8
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:17
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2414 to 2463
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2414 to 2463
   
   
  --- Logical volume ---
  LV Name                /dev/space/r9
  VG Name                space
  LV UUID                gpU8VX-DmtK-R0cI-elfq-8qce-SxsI-BVdEn3
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:18
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2464 to 2513
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2464 to 2513
   
   
  --- Logical volume ---
  LV Name                /dev/space/s9
  VG Name                space
  LV UUID                8L28qG-rro7-3Y1b-dSTf-pAL2-38eG-6KQhG8
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:19
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2514 to 2563
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2514 to 2563
   
   
  --- Logical volume ---
  LV Name                /dev/space/r10
  VG Name                space
  LV UUID                acfVZU-NRig-d8dY-7L7X-A44b-8TOM-3J4SCj
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:20
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2564 to 2613
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2564 to 2613
   
   
  --- Logical volume ---
  LV Name                /dev/space/s10
  VG Name                space
  LV UUID                f8CLD0-Gza6-aZ7t-7KIO-rm3G-vioT-Cb716z
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:21
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2614 to 2663
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2614 to 2663
   
   
  --- Logical volume ---
  LV Name                /dev/space/r11
  VG Name                space
  LV UUID                aisdqd-jf74-nse1-VxNL-Jri9-VIPd-1GuRln
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:22
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2664 to 2713
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2664 to 2713
   
   
  --- Logical volume ---
  LV Name                /dev/space/s11
  VG Name                space
  LV UUID                M9GbxM-MTyu-FaBj-l0Cl-y9h8-QkUF-bPiiks
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:23
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2714 to 2763
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2714 to 2763
   
   
  --- Logical volume ---
  LV Name                /dev/space/r12
  VG Name                space
  LV UUID                46DYju-U0V1-W7aJ-aa5B-JLuZ-EJgc-esbBlS
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:24
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2764 to 2813
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2764 to 2813
   
   
  --- Logical volume ---
  LV Name                /dev/space/s12
  VG Name                space
  LV UUID                4bwv3V-URGq-xvuc-sEce-Xjet-vBoL-0u1Aak
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:25
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2814 to 2863
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2814 to 2863
   
   
  --- Logical volume ---
  LV Name                /dev/space/r13
  VG Name                space
  LV UUID                1Tho0H-d9S3-HzFR-bexS-dxt9-EyXI-qBVYub
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:26
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2864 to 2913
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2864 to 2913
   
   
  --- Logical volume ---
  LV Name                /dev/space/s13
  VG Name                space
  LV UUID                RVynkA-84fe-JhZv-EO1I-7gtq-m2C0-y83V5j
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:27
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2914 to 2963
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2914 to 2963
   
   
  --- Logical volume ---
  LV Name                /dev/space/r14
  VG Name                space
  LV UUID                xMTHOQ-n4sI-QBIC-PMEq-Brl3-kQ0f-Qbyr1R
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:28
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	2964 to 3013
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	2964 to 3013
   
   
  --- Logical volume ---
  LV Name                /dev/space/s14
  VG Name                space
  LV UUID                s1Qaz1-2YZw-EEjZ-KpTi-GzRg-uXt4-Bbux2O
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:29
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3014 to 3063
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3014 to 3063
   
   
  --- Logical volume ---
  LV Name                /dev/space/r15
  VG Name                space
  LV UUID                8QDZ1W-dcPh-tJ2f-zYnn-8PG8-qf9Z-jsat6A
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:30
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3064 to 3113
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3064 to 3113
   
   
  --- Logical volume ---
  LV Name                /dev/space/s15
  VG Name                space
  LV UUID                VHNDmh-zq4w-zbBz-APRX-dkdx-d1KK-OY01bX
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:31
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3114 to 3163
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3114 to 3163
   
   
  --- Logical volume ---
  LV Name                /dev/space/r16
  VG Name                space
  LV UUID                H44ecz-206z-1H2S-13q7-rvSR-gYkP-ceZ70x
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:32
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3164 to 3213
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3164 to 3213
   
   
  --- Logical volume ---
  LV Name                /dev/space/s16
  VG Name                space
  LV UUID                Y0IOTb-e1mj-5dUv-kufE-1hju-mg50-TBqzzI
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:33
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3214 to 3263
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3214 to 3263
   
   
  --- Logical volume ---
  LV Name                /dev/space/r17
  VG Name                space
  LV UUID                JITLuv-AWLR-72Hy-V5pz-W9pJ-yYUE-tpb4yn
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:34
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3264 to 3313
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3264 to 3313
   
   
  --- Logical volume ---
  LV Name                /dev/space/s17
  VG Name                space
  LV UUID                8DQw1j-nHpr-gHqV-9JZj-uybI-vwbm-gKVGfg
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:35
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3314 to 3363
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3314 to 3363
   
   
  --- Logical volume ---
  LV Name                /dev/space/r18
  VG Name                space
  LV UUID                GTKsW2-BPzX-HuT3-gYBz-MoVV-H2PL-83td7w
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:36
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3364 to 3413
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3364 to 3413
   
   
  --- Logical volume ---
  LV Name                /dev/space/s18
  VG Name                space
  LV UUID                yE3meh-7kaZ-wlu2-miwc-V0gb-Qbuv-V2f8eW
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:37
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3414 to 3463
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3414 to 3463
   
   
  --- Logical volume ---
  LV Name                /dev/space/r19
  VG Name                space
  LV UUID                M0GVJd-yycc-D2K9-pfDM-DV3w-bQUU-nRCuw6
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:38
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3464 to 3513
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3464 to 3513
   
   
  --- Logical volume ---
  LV Name                /dev/space/s19
  VG Name                space
  LV UUID                wZ052N-kYxj-ZDiL-RFwe-jAS8-3iXO-WQOooP
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:39
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3514 to 3563
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3514 to 3563
   
   
  --- Logical volume ---
  LV Name                /dev/space/r20
  VG Name                space
  LV UUID                9cgPqm-DfnZ-AjDe-d5uy-JeUf-PqEh-7AX65L
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:40
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3564 to 3613
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3564 to 3613
   
   
  --- Logical volume ---
  LV Name                /dev/space/s20
  VG Name                space
  LV UUID                avxJgg-vsfb-izSX-9myu-BsoE-KKo0-YRflc7
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:41
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3614 to 3663
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3614 to 3663
   
   
  --- Logical volume ---
  LV Name                /dev/space/r21
  VG Name                space
  LV UUID                030nCm-YOdA-wI2w-2vJ2-c935-C79p-DgLqEs
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:42
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3664 to 3713
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3664 to 3713
   
   
  --- Logical volume ---
  LV Name                /dev/space/s21
  VG Name                space
  LV UUID                HnDXYc-TSf8-1647-dvJN-N1kz-Ng9h-IAvX01
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:43
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3714 to 3763
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3714 to 3763
   
   
  --- Logical volume ---
  LV Name                /dev/space/r22
  VG Name                space
  LV UUID                nyZwn2-JjVl-bZFf-CpA5-iUJ8-a3rE-nbWPKU
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:44
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3764 to 3813
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3764 to 3813
   
   
  --- Logical volume ---
  LV Name                /dev/space/s22
  VG Name                space
  LV UUID                e9zlAg-YWug-0liK-1xUj-sdbF-Nayk-YKb0xN
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:45
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3814 to 3863
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3814 to 3863
   
   
  --- Logical volume ---
  LV Name                /dev/space/r23
  VG Name                space
  LV UUID                m6k1my-ZIj3-LLOy-3lWg-jFO7-QdZF-8G2dHJ
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:46
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3864 to 3913
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3864 to 3913
   
   
  --- Logical volume ---
  LV Name                /dev/space/s23
  VG Name                space
  LV UUID                oqR9qP-nl12-dxL7-2eFx-F7Eb-sbFH-lt9YbF
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:47
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3914 to 3963
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3914 to 3963
   
   
  --- Logical volume ---
  LV Name                /dev/space/r24
  VG Name                space
  LV UUID                vjlw4o-kJYy-33n0-GdjJ-tXO4-EuBC-uFcspf
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:48
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	3964 to 4013
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	3964 to 4013
   
   
  --- Logical volume ---
  LV Name                /dev/space/s24
  VG Name                space
  LV UUID                BMO9eP-XCUF-jYT0-3jji-3H0Q-Ameh-2cHmra
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:49
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	4014 to 4063
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	4014 to 4063
   
   
  --- Logical volume ---
  LV Name                /dev/space/root
  VG Name                space
  LV UUID                0jL8uk-9ttB-vUUU-iAHw-aZUT-VjL6-omcLHp
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                512.00 MB
  Current LE             128
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:50
   
  --- Segments ---
  Logical extent 0 to 127:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	4448 to 4511
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	4448 to 4511
   
   
  --- Logical volume ---
  LV Name                /dev/space/home
  VG Name                space
  LV UUID                zqzWBR-orl5-c4N0-XNcP-hqtr-e3qa-TCwNLe
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                5.00 GB
  Current LE             1280
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:51
   
  --- Segments ---
  Logical extent 0 to 1279:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	4512 to 5151
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	4512 to 5151
   
   
  --- Logical volume ---
  LV Name                /dev/space/ccache
  VG Name                space
  LV UUID                JUYgLy-ua53-N45B-6NEw-FHI5-33d0-76nLkE
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                4.00 GB
  Current LE             1024
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:52
   
  --- Segments ---
  Logical extent 0 to 1023:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdd1
      Physical extents	0 to 511
    Stripe 1:
      Physical volume	/dev/dasdf1
      Physical extents	5152 to 5663
   
   
  --- Logical volume ---
  LV Name                /dev/space/base
  VG Name                space
  LV UUID                FPhFLU-1xTK-XtG4-STmI-u3D5-KhCR-FmlcCO
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                4.00 GB
  Current LE             1024
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:53
   
  --- Segments ---
  Logical extent 0 to 1023:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	0 to 511
    Stripe 1:
      Physical volume	/dev/dasdd1
      Physical extents	512 to 1023
   
   
  --- Logical volume ---
  LV Name                /dev/space/r25
  VG Name                space
  LV UUID                YkxecI-bINo-6xdh-bA2C-vDwX-ml07-TXlUBH
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:54
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	512 to 561
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	5152 to 5201
   
   
  --- Logical volume ---
  LV Name                /dev/space/s25
  VG Name                space
  LV UUID                GHY2yh-a5ST-cyow-1Fzi-F570-OWYW-ilVJeg
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:55
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	562 to 611
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	5202 to 5251
   
   
  --- Logical volume ---
  LV Name                /dev/space/r26
  VG Name                space
  LV UUID                W0hbZp-boum-J0GD-ENK2-ew6M-mW05-LQ9ZEj
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:56
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	612 to 661
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	5252 to 5301
   
   
  --- Logical volume ---
  LV Name                /dev/space/s26
  VG Name                space
  LV UUID                TIiZGG-4taN-jLyb-9pb1-aib2-slE6-TlqG3x
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:57
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	662 to 711
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	5302 to 5351
   
   
  --- Logical volume ---
  LV Name                /dev/space/r27
  VG Name                space
  LV UUID                NZjmkE-AT6H-974g-nGvw-epxD-nKJJ-4r1ks5
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:58
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	712 to 761
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	5352 to 5401
   
   
  --- Logical volume ---
  LV Name                /dev/space/s27
  VG Name                space
  LV UUID                l7KiyI-HJ7X-TaSr-nBYW-tYCU-EF0f-dwEHe0
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:59
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	762 to 811
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	5402 to 5451
   
   
  --- Logical volume ---
  LV Name                /dev/space/r28
  VG Name                space
  LV UUID                emN7S1-eBtk-mUxQ-itc5-ZrvH-Tacx-VHzytU
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:60
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	812 to 861
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	5452 to 5501
   
   
  --- Logical volume ---
  LV Name                /dev/space/s28
  VG Name                space
  LV UUID                74cqP9-PDi5-CVq1-LAV9-Er0r-HeB9-5TeTIz
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:61
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	862 to 911
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	5502 to 5551
   
   
  --- Logical volume ---
  LV Name                /dev/space/r29
  VG Name                space
  LV UUID                EdZKbD-HXu4-ac6K-b6co-9zTC-dd4Z-Zuwy6W
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:62
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	912 to 961
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	5552 to 5601
   
   
  --- Logical volume ---
  LV Name                /dev/space/s29
  VG Name                space
  LV UUID                p1NTvB-Y41N-YM1q-odyn-GiLD-bcsc-Tx9LwN
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                400.00 MB
  Current LE             100
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:63
   
  --- Segments ---
  Logical extent 0 to 99:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	962 to 1011
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	5602 to 5651
   
   
  --- Logical volume ---
  LV Name                /dev/space/test
  VG Name                space
  LV UUID                IwGDO2-j2cx-whbr-mcLQ-7MPi-FIWJ-lPw0LX
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                4.88 GB
  Current LE             1248
  Segments               3
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:64
   
  --- Segments ---
  Logical extent 0 to 767:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdf1
      Physical extents	4064 to 4447
    Stripe 1:
      Physical volume	/dev/dasde1
      Physical extents	4064 to 4447
   
  Logical extent 768 to 1065:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasdc1
      Physical extents	1012 to 1160
    Stripe 1:
      Physical volume	/dev/dasdd1
      Physical extents	1024 to 1172
   
  Logical extent 1066 to 1247:
    Type		striped
    Stripes		2
    Stripe size		64 KB
    Stripe 0:
      Physical volume	/dev/dasde1
      Physical extents	5652 to 5742
    Stripe 1:
      Physical volume	/dev/dasdf1
      Physical extents	5664 to 5754
   
   

--Boundary-00=_YK3HLwfrEUtecl3--
