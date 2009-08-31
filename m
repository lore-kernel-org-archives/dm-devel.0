From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Removing a failed device from LVM2/DM
Date: Mon, 31 Aug 2009 11:16:10 -0400
Message-ID: <1251731770.6817.31.camel@cail>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

I constructed a 1-copy mirror with the following commands:

# pvcreate --metadatasize 192k /dev/sdcn /dev/sdfj /dev/sdfa
  Physical volume "/dev/sdcn" successfully created
  Physical volume "/dev/sdfj" successfully created
  Physical volume "/dev/sdfa" successfully created
# vgcreate vg /dev/sdcn /dev/sdfj /dev/sdfa
  Volume group "vg" successfully created
# lvcreate -L 32g -m 1 -n lv vg
  Logical volume "lv" created

The status showed:

# lvs -a -o +devices
  LV            VG   Attr   LSize  Origin Snap%  Move Log     Copy%
Convert Devices                      
  lv            vg   mwi-a- 32.00G                    lv_mlog  29.72
lv_mimage_0(0),lv_mimage_1(0)
  [lv_mimage_0] vg   Iwi-ao
32.00G                                           /dev/sdcn(0)                 
  [lv_mimage_1] vg   Iwi-ao
32.00G                                           /dev/sdfj(0)                 
  [lv_mlog]     vg   lwi-ao
4.00M                                           /dev/sdfa(0)                 

Then I forced /dev/sdfj to fail (removing the unit from the FC SAN), and
the state of the mirror went to:

# lvs
  /dev/sdfj: read failed after 0 of 2048 at 0: Input/output error
  LV   VG   Attr   LSize  Origin Snap%  Move Log Copy%  Convert
  lv   vg   -wi-a- 32.00G           

At this point I know I can do:

# vgreduce -a vg
  /dev/sdfj: read failed after 0 of 2048 at 0: Input/output error
  Physical volume "/dev/sdcn" still in use
  Removed "/dev/sdfa" from volume group "vg"

But I run into two problems:

(1) I'd like to be able to live without the constant errors
about /dev/sdfj, and tried:

# pvremove -f /dev/sdfj
  /dev/sdfj: read failed after 0 of 2048 at 0: Input/output error
  No physical volume label read from /dev/sdfj
  /dev/sdfj: read failed after 0 of 2048 at 0: Input/output error
  Labels on physical volume "/dev/sdfj" successfully wiped

but that didn't stop it. 

and:

(2) I'd like to be able to recreate the 1-copy mirror from the currently
linear volume, but can't (easily):

# pvcreate --metadatasize 192k /dev/sdp
  Physical volume "/dev/sdp" successfully created
# vgextend vg /dev/sdp
  ... errors from sdfj omitted...
  Volume group "vg" successfully extended
# vgs
  /dev/sdfj: read failed after 0 of 2048 at 0: Input/output error
  VG   #PV #LV #SN Attr   VSize   VFree  
  vg     2   1   0 wz--n- 542.67G 510.67G
# lvconvert -m 1 /dev/vg/lv
  /dev/sdfj: read failed after 0 of 2048 at 0: Input/output error
  Insufficient suitable allocatable extents for logical volume : 8192
more required
  Unable to allocate extents for mirror(s).

I can use the alloc anywhere options, but I'm at a loss as to why that's
needed:

# lvconvert -m1 --alloc anywhere /dev/vg/lv
  /dev/sdfj: read failed after 0 of 2048 at 0: Input/output error
  /dev/vg/lv: Converted: 1.3%
  /dev/vg/lv: Converted: 2.6%
  /dev/vg/lv: Converted: 3.8%
...


Any pointers on how to remove /dev/sdfj from the scan (other than, I
guess, updated /etc/lvm.conf to filter it out) or an explanation as to
why the 'alloc anywhere' is needed for the lvconvert would be muchly
appreciated.

Alan D. Brunelle
Hewlett-Packard 
