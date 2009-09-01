From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Removing a failed device from LVM2/DM
Date: Tue, 01 Sep 2009 12:16:15 -0400
Message-ID: <1251821775.5459.21.camel@cail>
References: <1251731770.6817.31.camel@cail>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Q+ErSgA/CicJjk2+kQRh"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1251731770.6817.31.camel@cail>
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


--=-Q+ErSgA/CicJjk2+kQRh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The vgreduce --removemissing helped a lot, thanks! But I still remain
with all these error messages about the removed device. I tried
everything again - using devices sda, sdab & sdad (failing sdab), and
now every time I issue an LVM2/DM command I get all sorts of error
messages about /dev/sdab failures. The 'pvs -a -o +devices' command not
only puts out a ton - but also has a messed up display about the devices
left working:

# pvs -a -o +devices
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  Volume group name (null) has invalid characters
  Skipping volume group (null)
...
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  PV         VG   Fmt  Attr PSize   PFree   Devices    
  /dev/sda   vg   lvm2 a-   271.34G 239.34G /dev/sda(0)
  /dev/sda   vg   lvm2 a-   271.34G 239.34G            
  /dev/sda   vg   lvm2 a-   271.34G 239.34G            
  /dev/sdad  vg   lvm2 a-   271.34G 271.34G            
  /dev/sdad  vg   lvm2 a-   271.34G 271.34G

Why the 5 lines for 2 devices?

I've attached a log of commands & results.

I have tried adding in "/dev/sdab" as being filtered out
in /etc/lvm/lvm.conf but that doesn't change things. Here is first part
of the output from lvm dumpconfig:

# lvm dumpconfig
  devices {
  	dir="/dev"
  	scan="/dev"
  	preferred_names=[]
  	filter=["r|sdab|", "a/.*/"]
  	cache_dir="/etc/lvm/cache"
  	cache_file_prefix=""
  	write_cache_state=1
  	sysfs_scan=1
  	md_component_detection=1
  	md_chunk_alignment=1
  	ignore_suspended_devices=0
  }

but commands still error on /dev/sdab:

# lvs
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  LV   VG   Attr   LSize  Origin Snap%  Move Log     Copy%  Convert
  lv   vg   mwi-a- 32.00G                    lv_mlog 100.00

So, how do I stop LVM2/DM from "looking at" /dev/sdab?

Thanks,
Alan

--=-Q+ErSgA/CicJjk2+kQRh
Content-Disposition: attachment; filename="lvm_log.txt"
Content-Type: text/plain; name="lvm_log.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit


# pvcreate --metadatasize 192k /dev/sda /dev/sdab /dev/sdad
  Physical volume "/dev/sda" successfully created
  Physical volume "/dev/sdab" successfully created
  Physical volume "/dev/sdad" successfully created

# vgcreate vg /dev/sda /dev/sdab /dev/sdad
  Volume group "vg" successfully created

# lvcreate -L 32g -m 1 -n lv vg
  Logical volume "lv" created

# watch -n 5 lvs
Every 5.0s: lvs                                         Tue Sep  1 09:32:03 2009

  LV   VG   Attr   LSize  Origin Snap%  Move Log     Copy%  Convert
  lv   vg   mwi-a- 32.00G                    lv_mlog   6.08

...

  LV   VG   Attr   LSize  Origin Snap%  Move Log     Copy%  Convert
  lv   vg   mwi-a- 32.00G                    lv_mlog 100.00

# lvs -a -o +devices
  LV            VG   Attr   LSize  Origin Snap%  Move Log     Copy%  Convert Devices                      
  lv            vg   mwi-a- 32.00G                    lv_mlog 100.00         lv_mimage_0(0),lv_mimage_1(0)
  [lv_mimage_0] vg   iwi-ao 32.00G                                           /dev/sda(0)                  
  [lv_mimage_1] vg   iwi-ao 32.00G                                           /dev/sdab(0)                 
  [lv_mlog]     vg   lwi-ao  4.00M                                           /dev/sdad(0)

*** FAILED /dev/sdab ***

# lvs
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  LV   VG   Attr   LSize  Origin Snap%  Move Log Copy%  Convert
  lv   vg   -wi-a- 32.00G

# vgreduce --removemissing --test /dev/vg
  Test mode: Metadata will NOT be updated.
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  Volume group "vg" is already consistent

# vgreduce --removemissing /dev/vg
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  Volume group "vg" is already consistent

# pvs
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  PV         VG   Fmt  Attr PSize   PFree  
  /dev/sda   vg   lvm2 a-   271.34G 239.34G
  /dev/sdad  vg   lvm2 a-   271.34G 271.34G

# pvs -a -o +devices
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  /dev/sdab: read failed after 0 of 512 at 0: Input/output error
  /dev/sdab: read failed after 0 of 512 at 291347562496: Input/output error
  /dev/sdab: read failed after 0 of 512 at 291347632128: Input/output error
  /dev/sdab: read failed after 0 of 512 at 0: Input/output error
  /dev/sdab: read failed after 0 of 512 at 4096: Input/output error
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  PV         VG   Fmt  Attr PSize   PFree   Devices    
  /dev/sda   vg   lvm2 a-   271.34G 239.34G /dev/sda(0)
  /dev/sda   vg   lvm2 a-   271.34G 239.34G            
  /dev/sda   vg   lvm2 a-   271.34G 239.34G            
  /dev/sdad  vg   lvm2 a-   271.34G 271.34G            
  /dev/sdad  vg   lvm2 a-   271.34G 271.34G

# root@dl785b(root):pvcreate /dev/sdfi
  Physical volume "/dev/sdfi" successfully created

# vgextend vg /dev/sdfi
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  /dev/sdab: read failed after 0 of 512 at 0: Input/output error
  /dev/sdab: read failed after 0 of 512 at 291347562496: Input/output error
  /dev/sdab: read failed after 0 of 512 at 291347632128: Input/output error
  /dev/sdab: read failed after 0 of 512 at 0: Input/output error
  /dev/sdab: read failed after 0 of 512 at 4096: Input/output error
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  Volume group "vg" successfully extended

# pvs
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  PV         VG   Fmt  Attr PSize   PFree  
  /dev/sda   vg   lvm2 a-   271.34G 239.34G
  /dev/sdad  vg   lvm2 a-   271.34G 271.34G
  /dev/sdfi  vg   lvm2 a-   271.34G 271.34G

# lvdisplay -m
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  --- Logical volume ---
  LV Name                /dev/vg/lv
  VG Name                vg
  LV UUID                L0n377-sqiL-282A-wVjZ-ipB4-N21I-wMwa7U
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                32.00 GB
  Current LE             8192
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:3
   
  --- Segments ---
  Logical extent 0 to 8191:
    Type		linear
    Physical volume	/dev/sda
    Physical extents	0 to 8191

# lvconvert -m 1 /dev/vg/lv
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  /dev/vg/lv: Converted: 2.2%
  /dev/vg/lv: Converted: 4.4%
  /dev/vg/lv: Converted: 6.7%
...
  /dev/vg/lv: Converted: 95.8%
  /dev/vg/lv: Converted: 98.0%
  /dev/vg/lv: Converted: 100.0%
  Logical volume lv converted.

# lvdisplay -m
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  --- Logical volume ---
  LV Name                /dev/vg/lv
  VG Name                vg
  LV UUID                L0n377-sqiL-282A-wVjZ-ipB4-N21I-wMwa7U
  LV Write Access        read/write
  LV Status              available
  # open                 0
  LV Size                32.00 GB
  Current LE             8192
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:3
   
  --- Segments ---
  Logical extent 0 to 8191:
    Type		mirror
    Mirrors		2
    Mirror size		8192
    Mirror log volume	lv_mlog
    Mirror region size	512.00 KB
    Mirror original:
      Logical volume	lv_mimage_0
      Logical extents	0 to 8191
    Mirror destinations:
      Logical volume	lv_mimage_1
      Logical extents	0 to 8191
   

# pvs -a -o +devices
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  /dev/sdab: read failed after 0 of 512 at 0: Input/output error
  /dev/sdab: read failed after 0 of 512 at 291347562496: Input/output error
  /dev/sdab: read failed after 0 of 512 at 291347632128: Input/output error
  /dev/sdab: read failed after 0 of 512 at 0: Input/output error
  /dev/sdab: read failed after 0 of 512 at 4096: Input/output error
  /dev/sdab: read failed after 0 of 2048 at 0: Input/output error
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  Volume group name (null) has invalid characters
  Skipping volume group (null)
  PV         VG   Fmt  Attr PSize   PFree   Devices     
  /dev/sda   vg   lvm2 a-   271.34G 239.34G /dev/sda(0) 
  /dev/sda   vg   lvm2 a-   271.34G 239.34G             
  /dev/sda   vg   lvm2 a-   271.34G 239.34G             
  /dev/sdad  vg   lvm2 a-   271.34G 239.34G /dev/sdad(0)
  /dev/sdad  vg   lvm2 a-   271.34G 239.34G             
  /dev/sdad  vg   lvm2 a-   271.34G 239.34G             
  /dev/sdfi  vg   lvm2 a-   271.34G 271.33G /dev/sdfi(0)
  /dev/sdfi  vg   lvm2 a-   271.34G 271.33G             
  /dev/sdfi  vg   lvm2 a-   271.34G 271.33G

# lvm dumpconfig
  devices {
  	dir="/dev"
  	scan="/dev"
  	preferred_names=[]
  	filter=["r|sdab|", "a/.*/"]
  	cache_dir="/etc/lvm/cache"
  	cache_file_prefix=""
  	write_cache_state=1
  	sysfs_scan=1
  	md_component_detection=1
  	md_chunk_alignment=1
  	ignore_suspended_devices=0
  }
  dmeventd {
  	mirror_library="libdevmapper-event-lvm2mirror.so"
  	snapshot_library="libdevmapper-event-lvm2snapshot.so"
  }
  activation {
  	missing_stripe_filler="error"
  	reserved_stack=256
  	reserved_memory=8192
  	process_priority=-18
  	mirror_region_size=512
  	readahead="auto"
  	mirror_log_fault_policy="allocate"
  	mirror_device_fault_policy="remove"
  }
  global {
  	umask=63
  	test=0
  	units="h"
  	activation=1
  	proc="/proc"
  	locking_type=1
  	fallback_to_clustered_locking=1
  	fallback_to_local_locking=1
  	locking_dir="/var/lock/lvm"
  }
  shell {
  	history_size=100
  }
  backup {
  	backup=1
  	backup_dir="/etc/lvm/backup"
  	archive=1
  	archive_dir="/etc/lvm/archive"
  	retain_min=10
  	retain_days=30
  }
  log {
  	verbose=0
  	syslog=1
  	overwrite=0
  	level=0
  	indent=1
  	command_names=0
  	prefix="  "
  }

--=-Q+ErSgA/CicJjk2+kQRh
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-Q+ErSgA/CicJjk2+kQRh--
