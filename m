From: Christian Robert <christian.robert@polymtl.ca>
Subject: Unable to delete snapshots
Date: Wed, 06 Apr 2005 18:33:52 -0400
Message-ID: <425463D0.5232BE61@polymtl.ca>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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


Hi,

 I have a recent problem with a volume group from where I can no longer
 delete snapshots.

# vgdisplay
  --- Volume group ---
  VG Name               vg01
  System ID             
  Format                lvm2
  Metadata Areas        6
  Metadata Sequence No  670
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                65
  Open LV               34
  Max PV                0
  Cur PV                6
  Act PV                6
  VG Size               576.79 GB
  PE Size               4.00 MB
  Total PE              147659
  Alloc PE / Size       117264 / 458.06 GB
  Free  PE / Size       30395 / 118.73 GB
  VG UUID               zDVNh2-LhS0-5EJs-jiZy-87Oy-znmZ-IqfpHr
   

Last thing I did two weeks ago was to add a logical volume and a snapshot
to this logical volume. ( so I went from 63 logical volumes to 65 )

# lvscan | fgrep Original | wc -l
     31
# lvscan | fgrep Snapshot | wc -l
     31
# lvscan | egrep -v "Original|Snapshot" | wc -l
      3

I have 31 LVs with each a snapshot and 3 normal LVs.


// Trying to remove a snapshot

# lvremove -ff /dev/vg01/Sproduct
  device-mapper ioctl cmd 9 failed: Cannot allocate memory
  Couldn't load device 'vg01-Sproduct'.
  Unable to deactivate logical volume "Sproduct"

# dmesg | tail -3
ReiserFS: dm-125: Using r5 hash to sort names
device-mapper: Could not create kcopyd client
device-mapper: error adding target to table


// Here lvremove of an other snapshot LV wirh -vvv debugging switches


# lvremove -vvvff /dev/vg01/Smail1
        Processing: lvremove -vvvff /dev/vg01/Smail1
        O_DIRECT will be used
      Setting global/locking_type to 1
      Setting global/locking_dir to /var/lock/lvm
      File-based locking enabled.
    Using logical volume(s) on command line
      Locking /var/lock/lvm/V_vg01 WB
        Opened /dev/hda1 RW
        /dev/hda1: block size is 4096 bytes
      /dev/hda1: No label detected
        Opened /dev/hde1 RW
        /dev/hde1: block size is 512 bytes
      /dev/hde1: lvm2 label detected
        lvmcache: /dev/hde1 now orphaned
        lvmcache: /dev/hde1 now in VG vg01
        Opened /dev/hdg1 RW
        /dev/hdg1: block size is 1024 bytes
      /dev/hdg1: lvm2 label detected
        lvmcache: /dev/hdg1 now orphaned
        lvmcache: /dev/hdg1 now in VG vg01
        Opened /dev/hda2 RW
        /dev/hda2: block size is 4096 bytes
      /dev/hda2: No label detected
        Opened /dev/hda3 RW
        /dev/hda3: block size is 512 bytes
      /dev/hda3: No label detected
        Opened /dev/hda4 RW
        /dev/hda4: block size is 2048 bytes
      /dev/hda4: lvm2 label detected
        lvmcache: /dev/hda4 now orphaned
        lvmcache: /dev/hda4 now in VG vg01
        Opened /dev/hdb1 RW
        /dev/hdb1: block size is 512 bytes
      /dev/hdb1: lvm2 label detected
        lvmcache: /dev/hdb1 now orphaned
        lvmcache: /dev/hdb1 now in VG vg01
        Opened /dev/hdf1 RW
        /dev/hdf1: block size is 512 bytes
      /dev/hdf1: lvm2 label detected
        lvmcache: /dev/hdf1 now orphaned
        lvmcache: /dev/hdf1 now in VG vg01
        Opened /dev/hdh1 RW
        /dev/hdh1: block size is 512 bytes
      /dev/hdh1: lvm2 label detected
        lvmcache: /dev/hdh1 now orphaned
        lvmcache: /dev/hdh1 now in VG vg01
      /dev/hde1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hde1 at 186880 size 25011
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hdg1 at 52736 size 25011
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hda4 at 186880 size 25011
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hdb1 at 186880 size 25011
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hdf1 at 186880 size 25011
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hdh1 at 186880 size 25011
      Setting activation/missing_stripe_filler to /dev/ioerror
        Getting device info for vg01-Smail1
        dm version   O  
        dm info  zDVNh2LhS05EJsjiZy87OyznmZIqfpHrDb1mzcEgKaNaLmq8pzRnO5nZMAFm25L6 O  
    Archiving volume group "vg01" metadata.
        Locking LV zDVNh2LhS05EJsjiZy87OyznmZIqfpHrDb1mzcEgKaNaLmq8pzRnO5nZMAFm25L6 (NL)
      Finding volume group for uuid zDVNh2LhS05EJsjiZy87OyznmZIqfpHrDb1mzcEgKaNaLmq8pzRnO5nZMAFm25L6
      /dev/hde1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hde1 at 186880 size 25011
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hdg1 at 52736 size 25011
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hda4 at 186880 size 25011
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hdb1 at 186880 size 25011
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hdf1 at 186880 size 25011
      /dev/hda4: lvm2 label detected
      /dev/hdb1: lvm2 label detected
      /dev/hde1: lvm2 label detected
      /dev/hdf1: lvm2 label detected
      /dev/hdh1: lvm2 label detected
      /dev/hdg1: lvm2 label detected
        Read vg01 metadata (670) from /dev/hdh1 at 186880 size 25011
    Found volume group "vg01"
        Getting device info for vg01-Smail1
        dm info  zDVNh2LhS05EJsjiZy87OyznmZIqfpHrDb1mzcEgKaNaLmq8pzRnO5nZMAFm25L6 O  
      Locking memory
        memlock_count inc to 1
        dm names   O  
        Found existing layer 'vg01-Stomcatp'
        Getting device info for vg01-Stomcatp
        dm info vg01-Stomcatp  N  
        Found existing layer 'vg01-polyc'
        Getting device info for vg01-polyc
        dm info vg01-polyc  N  
        Found existing layer 'vg01-c4'
        Getting device info for vg01-c4
        dm info vg01-c4  N  
        Found existing layer 'vg01-Soraprod-cow'
        Getting device info for vg01-Soraprod-cow
        dm info vg01-Soraprod-cow  N  
        Found existing layer 'vg01-tomcatp-real'
        Getting device info for vg01-tomcatp-real
        dm info vg01-tomcatp-real  N  
        Found existing layer 'vg01-antivir-real'
        Getting device info for vg01-antivir-real
        dm info vg01-antivir-real  N  
        Found existing layer 'vg01-sasi-real'
        Getting device info for vg01-sasi-real
        dm info vg01-sasi-real  N  
        Found existing layer 'vg01-c3-real'
        Getting device info for vg01-c3-real
        dm info vg01-c3-real  N  
        Found existing layer 'vg01-ecole01-real'
        Getting device info for vg01-ecole01-real
        dm info vg01-ecole01-real  N  
        Found existing layer 'vg01-saprod-real'
        Getting device info for vg01-saprod-real
        dm info vg01-saprod-real  N  
        Found existing layer 'vg01-sasi'
        Getting device info for vg01-sasi
        dm info vg01-sasi  N  
        Found existing layer 'vg01-c3'
        Getting device info for vg01-c3
        dm info vg01-c3  N  
        Found existing layer 'vg01-Smail3-cow'
        Getting device info for vg01-Smail3-cow
        dm info vg01-Smail3-cow  N  
        Found existing layer 'vg01-websv01-real'
        Getting device info for vg01-websv01-real
        dm info vg01-websv01-real  N  
        Found existing layer 'vg01-websv02'
        Getting device info for vg01-websv02
        dm info vg01-websv02  N  
        Found existing layer 'vg01-Smail1'
        Getting device info for vg01-Smail1
        dm info vg01-Smail1  N  
        Found existing layer 'vg01-Swebsv02'
        Getting device info for vg01-Swebsv02
        dm info vg01-Swebsv02  N  
        Found existing layer 'vg01-adsm'
        Getting device info for vg01-adsm
        dm info vg01-adsm  N  
        Found existing layer 'vg01-Stomcatp-cow'
        Getting device info for vg01-Stomcatp-cow
        dm info vg01-Stomcatp-cow  N  
        Found existing layer 'vg01-releve'
        Getting device info for vg01-releve
        dm info vg01-releve  N  
        Found existing layer 'vg01-oratest-real'
        Getting device info for vg01-oratest-real
        dm info vg01-oratest-real  N  
        Found existing layer 'vg01-c2'
        Getting device info for vg01-c2
        dm info vg01-c2  N  
        Found existing layer 'vg01-Ssmtp'
        Getting device info for vg01-Ssmtp
        dm info vg01-Ssmtp  N  
        Found existing layer 'vg01-websv01'
        Getting device info for vg01-websv01
        dm info vg01-websv01  N  
        Found existing layer 'vg01-Sadp'
        Getting device info for vg01-Sadp
        dm info vg01-Sadp  N  
        Found existing layer 'vg01-adp-real'
        Getting device info for vg01-adp-real
        dm info vg01-adp-real  N  
        Found existing layer 'vg01-Santispm-cow'
        Getting device info for vg01-Santispm-cow
        dm info vg01-Santispm-cow  N  
        Found existing layer 'vg01-Swebsv01'
        Getting device info for vg01-Swebsv01
        dm info vg01-Swebsv01  N  
        Found existing layer 'vg01-mail1-real'
        Getting device info for vg01-mail1-real
        dm info vg01-mail1-real  N  
        Found existing layer 'vg01-Sadsm-cow'
        Getting device info for vg01-Sadsm-cow
        dm info vg01-Sadsm-cow  N  
        Found existing layer 'vg01-polyc-real'
        Getting device info for vg01-polyc-real
        dm info vg01-polyc-real  N  
        Found existing layer 'vg01-c4-real'
        Getting device info for vg01-c4-real
        dm info vg01-c4-real  N  
        Found existing layer 'vg01-Sproduct-cow'
        Getting device info for vg01-Sproduct-cow
        dm info vg01-Sproduct-cow  N  
        Found existing layer 'vg01-websv02-real'
        Getting device info for vg01-websv02-real
        dm info vg01-websv02-real  N  
        Found existing layer 'vg01-Sdetruit-cow'
        Getting device info for vg01-Sdetruit-cow
        dm info vg01-Sdetruit-cow  N  
        Found existing layer 'vg01-service'
        Getting device info for vg01-service
        dm info vg01-service  N  
        Found existing layer 'vg01-vpn01'
        Getting device info for vg01-vpn01
        dm info vg01-vpn01  N  
        Found existing layer 'vg01-mail3'
        Getting device info for vg01-mail3
        dm info vg01-mail3  N  
        Found existing layer 'vg01-Sservice'
        Getting device info for vg01-Sservice
        dm info vg01-Sservice  N  
        Found existing layer 'vg01-service-real'
        Getting device info for vg01-service-real
        dm info vg01-service-real  N  
        Found existing layer 'vg01-vpn01-real'
        Getting device info for vg01-vpn01-real
        dm info vg01-vpn01-real  N  
        Found existing layer 'vg01-product'
        Getting device info for vg01-product
        dm info vg01-product  N  
        Found existing layer 'vg01-Sproduct'
        Getting device info for vg01-Sproduct
        dm info vg01-Sproduct  N  
        Found existing layer 'vg01-Svpn01-cow'
        Getting device info for vg01-Svpn01-cow
        dm info vg01-Svpn01-cow  N  
        Found existing layer 'vg01-Swebsv01-cow'
        Getting device info for vg01-Swebsv01-cow
        dm info vg01-Swebsv01-cow  N  
        Found existing layer 'vg01-backup'
        Getting device info for vg01-backup
        dm info vg01-backup  N  
        Found existing layer 'vg01-oratest'
        Getting device info for vg01-oratest
        dm info vg01-oratest  N  
        Found existing layer 'vg01-Ssage'
        Getting device info for vg01-Ssage
        dm info vg01-Ssage  N  
        Found existing layer 'vg01-Soratest'
        Getting device info for vg01-Soratest
        dm info vg01-Soratest  N  
        Found existing layer 'vg01-Ssaprod'
        Getting device info for vg01-Ssaprod
        dm info vg01-Ssaprod  N  
        Found existing layer 'vg01-Swww41'
        Getting device info for vg01-Swww41
        dm info vg01-Swww41  N  
        Found existing layer 'vg01-mail1'
        Getting device info for vg01-mail1
        dm info vg01-mail1  N  
        Found existing layer 'vg01-mail3-real'
        Getting device info for vg01-mail3-real
        dm info vg01-mail3-real  N  
        Found existing layer 'vg01-slack'
        Getting device info for vg01-slack
        dm info vg01-slack  N  
        Found existing layer 'vg01-detruit-real'
        Getting device info for vg01-detruit-real
        dm info vg01-detruit-real  N  
        Found existing layer 'vg01-smtp'
        Getting device info for vg01-smtp
        dm info vg01-smtp  N  
        Found existing layer 'vg01-antispm'
        Getting device info for vg01-antispm
        dm info vg01-antispm  N  
        Found existing layer 'vg01-Swebsv02-cow'
        Getting device info for vg01-Swebsv02-cow
        dm info vg01-Swebsv02-cow  N  
        Found existing layer 'vg01-antivir'
        Getting device info for vg01-antivir
        dm info vg01-antivir  N  
        Found existing layer 'vg01-Santispm'
        Getting device info for vg01-Santispm
        dm info vg01-Santispm  N  
        Found existing layer 'vg01-Ssage-cow'
        Getting device info for vg01-Ssage-cow
        dm info vg01-Ssage-cow  N  
        Found existing layer 'vg01-Soratest-cow'
        Getting device info for vg01-Soratest-cow
        dm info vg01-Soratest-cow  N  
        Found existing layer 'vg01-smtp-real'
        Getting device info for vg01-smtp-real
        dm info vg01-smtp-real  N  
        Found existing layer 'vg01-Santivir'
        Getting device info for vg01-Santivir
        dm info vg01-Santivir  N  
        Found existing layer 'vg01-Secole01-cow'
        Getting device info for vg01-Secole01-cow
        dm info vg01-Secole01-cow  N  
        Found existing layer 'vg01-Spolyc-cow'
        Getting device info for vg01-Spolyc-cow
        dm info vg01-Spolyc-cow  N  
        Found existing layer 'vg01-Slock-cow'
        Getting device info for vg01-Slock-cow
        dm info vg01-Slock-cow  N  
        Found existing layer 'vg01-Sc4'
        Getting device info for vg01-Sc4
        dm info vg01-Sc4  N  
        Found existing layer 'vg01-adsm-real'
        Getting device info for vg01-adsm-real
        dm info vg01-adsm-real  N  
        Found existing layer 'vg01-Sadp-cow'
        Getting device info for vg01-Sadp-cow
        dm info vg01-Sadp-cow  N  
        Found existing layer 'vg01-bernard-real'
        Getting device info for vg01-bernard-real
        dm info vg01-bernard-real  N  
        Found existing layer 'vg01-Swww41-cow'
        Getting device info for vg01-Swww41-cow
        dm info vg01-Swww41-cow  N  
        Found existing layer 'vg01-tomcatt-real'
        Getting device info for vg01-tomcatt-real
        dm info vg01-tomcatt-real  N  
        Found existing layer 'vg01-oraprod'
        Getting device info for vg01-oraprod
        dm info vg01-oraprod  N  
        Found existing layer 'vg01-Scourriel-cow'
        Getting device info for vg01-Scourriel-cow
        dm info vg01-Scourriel-cow  N  
        Found existing layer 'vg01-Soraprod'
        Getting device info for vg01-Soraprod
        dm info vg01-Soraprod  N  
        Found existing layer 'vg01-Sc2-cow'
        Getting device info for vg01-Sc2-cow
        dm info vg01-Sc2-cow  N  
        Found existing layer 'vg01-ecole01'
        Getting device info for vg01-ecole01
        dm info vg01-ecole01  N  
        Found existing layer 'vg01-saprod'
        Getting device info for vg01-saprod
        dm info vg01-saprod  N  
        Found existing layer 'vg01-Sc3'
        Getting device info for vg01-Sc3
        dm info vg01-Sc3  N  
        Found existing layer 'vg01-product-real'
        Getting device info for vg01-product-real
        dm info vg01-product-real  N  
        Found existing layer 'vg01-Secole01'
        Getting device info for vg01-Secole01
        dm info vg01-Secole01  N  
        Found existing layer 'vg01-Spolyc'
        Getting device info for vg01-Spolyc
        dm info vg01-Spolyc  N  
        Found existing layer 'vg01-Slock'
        Getting device info for vg01-Slock
        dm info vg01-Slock  N  
        Found existing layer 'vg01-bernard'
        Getting device info for vg01-bernard
        dm info vg01-bernard  N  
        Found existing layer 'vg01-tomcatt'
        Getting device info for vg01-tomcatt
        dm info vg01-tomcatt  N  
        Found existing layer 'vg01-Sbernard'
        Getting device info for vg01-Sbernard
        dm info vg01-Sbernard  N  
        Found existing layer 'vg01-Stomcatt'
        Getting device info for vg01-Stomcatt
        dm info vg01-Stomcatt  N  
        Found existing layer 'vg01-Scourriel'
        Getting device info for vg01-Scourriel
        dm info vg01-Scourriel  N  
        Found existing layer 'vg01-Sservice-cow'
        Getting device info for vg01-Sservice-cow
        dm info vg01-Sservice-cow  N  
        Found existing layer 'vg01-sage'
        Getting device info for vg01-sage
        dm info vg01-sage  N  
        Found existing layer 'vg01-Sc2'
        Getting device info for vg01-Sc2
        dm info vg01-Sc2  N  
        Found existing layer 'vg01-rsync'
        Getting device info for vg01-rsync
        dm info vg01-rsync  N  
        Found existing layer 'vg01-oraprod-real'
        Getting device info for vg01-oraprod-real
        dm info vg01-oraprod-real  N  
        Found existing layer 'vg01-Ssasi'
        Getting device info for vg01-Ssasi
        dm info vg01-Ssasi  N  
        Found existing layer 'vg01-Smail1-cow'
        Getting device info for vg01-Smail1-cow
        dm info vg01-Smail1-cow  N  
        Found existing layer 'vg01-courriel'
        Getting device info for vg01-courriel
        dm info vg01-courriel  N  
        Found existing layer 'vg01-Sc3-cow'
        Getting device info for vg01-Sc3-cow
        dm info vg01-Sc3-cow  N  
        Found existing layer 'vg01-courriel-real'
        Getting device info for vg01-courriel-real
        dm info vg01-courriel-real  N  
        Found existing layer 'vg01-www41'
        Getting device info for vg01-www41
        dm info vg01-www41  N  
        Found existing layer 'vg01-Sadsm'
        Getting device info for vg01-Sadsm
        dm info vg01-Sadsm  N  
        Found existing layer 'vg01-charles'
        Getting device info for vg01-charles
        dm info vg01-charles  N  
        Found existing layer 'vg01-Scharles'
        Getting device info for vg01-Scharles
        dm info vg01-Scharles  N  
        Found existing layer 'vg01-Ssmtp-cow'
        Getting device info for vg01-Ssmtp-cow
        dm info vg01-Ssmtp-cow  N  
        Found existing layer 'vg01-Ssaprod-cow'
        Getting device info for vg01-Ssaprod-cow
        dm info vg01-Ssaprod-cow  N  
        Found existing layer 'vg01-detruit'
        Getting device info for vg01-detruit
        dm info vg01-detruit  N  
        Found existing layer 'vg01-Sbernard-cow'
        Getting device info for vg01-Sbernard-cow
        dm info vg01-Sbernard-cow  N  
        Found existing layer 'vg01-Stomcatt-cow'
        Getting device info for vg01-Stomcatt-cow
        dm info vg01-Stomcatt-cow  N  
        Found existing layer 'vg01-Sdetruit'
        Getting device info for vg01-Sdetruit
        dm info vg01-Sdetruit  N  
        Found existing layer 'vg01-Sreleve-cow'
        Getting device info for vg01-Sreleve-cow
        dm info vg01-Sreleve-cow  N  
        Found existing layer 'vg01-lock-real'
        Getting device info for vg01-lock-real
        dm info vg01-lock-real  N  
        Found existing layer 'vg01-antispm-real'
        Getting device info for vg01-antispm-real
        dm info vg01-antispm-real  N  
        Found existing layer 'vg01-Ssasi-cow'
        Getting device info for vg01-Ssasi-cow
        dm info vg01-Ssasi-cow  N  
        Found existing layer 'vg01-adp'
        Getting device info for vg01-adp
        dm info vg01-adp  N  
        Found existing layer 'vg01-releve-real'
        Getting device info for vg01-releve-real
        dm info vg01-releve-real  N  
        Found existing layer 'vg01-Svpn01'
        Getting device info for vg01-Svpn01
        dm info vg01-Svpn01  N  
        Found existing layer 'vg01-c2-real'
        Getting device info for vg01-c2-real
        dm info vg01-c2-real  N  
        Found existing layer 'vg01-Smail3'
        Getting device info for vg01-Smail3
        dm info vg01-Smail3  N  
        Found existing layer 'vg01-sage-real'
        Getting device info for vg01-sage-real
        dm info vg01-sage-real  N  
        Found existing layer 'vg01-Santivir-cow'
        Getting device info for vg01-Santivir-cow
        dm info vg01-Santivir-cow  N  
        Found existing layer 'vg01-Sreleve'
        Getting device info for vg01-Sreleve
        dm info vg01-Sreleve  N  
        Found existing layer 'vg01-Sc4-cow'
        Getting device info for vg01-Sc4-cow
        dm info vg01-Sc4-cow  N  
        Found existing layer 'vg01-www41-real'
        Getting device info for vg01-www41-real
        dm info vg01-www41-real  N  
        Found existing layer 'vg01-Scharles-cow'
        Getting device info for vg01-Scharles-cow
        dm info vg01-Scharles-cow  N  
        Found existing layer 'vg01-charles-real'
        Getting device info for vg01-charles-real
        dm info vg01-charles-real  N  
        Found existing layer 'vg01-lock'
        Getting device info for vg01-lock
        dm info vg01-lock  N  
        Found existing layer 'vg01-tomcatp'
        Getting device info for vg01-tomcatp
        dm info vg01-tomcatp  N  
        Found active lv rsync
        Found active lv mail1
        Found active lv smtp
        Found active lv c2
        Found active lv c3
        Found active lv c4
        Found active lv lock
        Found active lv adp
        Found active lv polyc
        Found active lv sasi
        Found active lv saprod
        Found active lv charles
        Found active lv oratest
        Found active lv oraprod
        Found active lv sage
        Found active lv vpn01
        Found active lv websv02
        Found active lv tomcatt
        Found active lv websv01
        Found active lv adsm
        Found active lv service
        Found active lv antispm
        Found active lv releve
        Found active lv ecole01
        Found active lv www41
        Found active lv bernard
        Found active lv courriel
        Found active lv tomcatp
        Found active lv detruit
        Found active lv antivir
        Found active lv mail3
        Found active lv slack
        Found active lv Smail3
        Found active lv Ssmtp
        Found active lv Sc2
        Found active lv Sc3
        Found active lv Sc4
        Found active lv Slock
        Found active lv Sadp
        Found active lv Spolyc
        Found active lv Ssasi
        Found active lv Ssaprod
        Found active lv Scharles
        Found active lv Soratest
        Found active lv Soraprod
        Found active lv Ssage
        Found active lv Svpn01
        Found active lv Swebsv02
        Found active lv Stomcatt
        Found active lv Stomcatp
        Found active lv Swebsv01
        Found active lv Sadsm
        Found active lv Sservice
        Found active lv Santispm
        Found active lv Santivir
        Found active lv Sreleve
        Found active lv Secole01
        Found active lv Swww41
        Found active lv Sbernard
        Found active lv Scourriel
        Found active lv Sdetruit
        Found active lv product (suspended)
        Found active lv Smail1
        Found active lv Sproduct (suspended)
        Found active lv backup
      Getting target version for snapshot
        dm versions   O  
      Getting target version for snapshot-origin
        dm versions   O  
      Suspending vg01-mail1
        dm suspend vg01-mail1  N  
      Suspending vg01-Smail1
        dm suspend vg01-Smail1  N  
      Suspending vg01-mail1-real
        dm suspend vg01-mail1-real  N  
    Loading vg01-mail1-real
        Adding target: 0 10485760 linear /dev/hde1 181494144
        dm reload  zDVNh2LhS05EJsjiZy87OyznmZIqfpHrr9YYp2SvowPFRHTg32YmtElsb81MCo0z-real N  
      Activated vg01-mail1-real zDVNh2LhS05EJsjiZy87OyznmZIqfpHrr9YYp2SvowPFRHTg32YmtElsb81MCo0z-real 253:002
      Suspending vg01-Smail1-cow
        dm suspend vg01-Smail1-cow  N  
    Loading vg01-Smail1-cow
        Adding target: 0 2097152 linear /dev/hdf1 227639680
        dm reload  zDVNh2LhS05EJsjiZy87OyznmZIqfpHrDb1mzcEgKaNaLmq8pzRnO5nZMAFm25L6-cow N  
      Activated vg01-Smail1-cow zDVNh2LhS05EJsjiZy87OyznmZIqfpHrDb1mzcEgKaNaLmq8pzRnO5nZMAFm25L6-cow 253:001
    Loading vg01-Smail1
        Adding target: 0 10485760 snapshot 253:002 253:001 P 16
        dm reload  zDVNh2LhS05EJsjiZy87OyznmZIqfpHrDb1mzcEgKaNaLmq8pzRnO5nZMAFm25L6 N  
  device-mapper ioctl cmd 9 failed: Cannot allocate memory
  Couldn't load device 'vg01-Smail1'.
      Unlocking memory
        memlock_count dec to 0
  Unable to deactivate logical volume "Smail1"
      Unlocking /var/lock/lvm/V_vg01
        Closed /dev/hda1
        Closed /dev/hde1
        Closed /dev/hdg1
        Closed /dev/hda2
        Closed /dev/hda3
        Closed /dev/hda4
        Closed /dev/hdb1
        Closed /dev/hdf1
        Closed /dev/hdh1
# free
             total       used       free     shared    buffers     cached
Mem:       1035280     255028     780252          0      27020      66004
-/+ buffers/cache:     162004     873276
Swap:       987956          0     987956


// a "strace" on the lvremove command show that an ioctl() return  NOMEM

[...]

read(6, " \"Text Format Volume Group\"\nvers"..., 1024) = 1024
brk(0)                                  = 0x8158000
brk(0x815a000)                          = 0x815a000
ioctl(13, 0xc134fd07, 0x810f438)        = 0
mlockall(MCL_CURRENT|MCL_FUTURE)        = 0
brk(0)                                  = 0x815a000
brk(0x895a000)                          = 0x895a000
brk(0)                                  = 0x895a000
brk(0x8b42000)                          = 0x8b42000
getpriority(PRIO_PROCESS, 0)            = 20
setpriority(PRIO_PROCESS, 0, -18)       = 0
ioctl(13, 0xc134fd02, 0x810f438)        = 0
ioctl(13, 0xc134fd07, 0x8127618)        = 0
ioctl(13, 0xc134fd07, 0x8127618)        = 0
ioctl(13, 0xc134fd07, 0x8127618)        = 0

[...]

ioctl(13, 0xc134fd07, 0x8127618)        = 0
ioctl(13, 0xc134fd0d, 0x810f438)        = 0
ioctl(13, 0xc134fd0d, 0x810f438)        = 0
ioctl(13, 0xc134fd06, 0x810f438)        = 0
ioctl(13, 0xc134fd06, 0x810f438)        = 0
ioctl(13, 0xc134fd06, 0x810f438)        = 0
ioctl(13, 0xc134fd09, 0x810f438)        = 0
ioctl(13, 0xc134fd06, 0x810f438)        = 0
ioctl(13, 0xc134fd09, 0x810f438)        = 0
ioctl(13, 0xc134fd09, 0x810f438)        = -1 ENOMEM (Cannot allocate memory)



Note, I am able to delete a LV without a snapshot.


Any help to resolve this problem would be apreciated.
Tell me if you need more info. Mail me a copy of your
replys (for speed) because I only receive noon daily digests.


thanks,
Christian Robert.
