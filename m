From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Constructing RAID 1+0 w/ LVM2/DM
Date: Thu, 24 Jan 2008 09:16:02 -0500
Message-ID: <47989DA2.1070201@hp.com>
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

I'm attempting to create a RAID 1+0 environment using only LVM/DM and 
running into a strange problem: I can't use the underlying mirrored 
devices. I was able to create a RAID 0+1 environment easy enough, so I'm 
perplexed by this.

I have 24 devices (12 each behind an FC RAID array), I first pvcreate those:

/sbin/pvcreate -f -y /dev/sdu
/sbin/pvcreate -f -y /dev/sdw
/sbin/pvcreate -f -y /dev/sdx
/sbin/pvcreate -f -y /dev/sdz
/sbin/pvcreate -f -y /dev/sdab
/sbin/pvcreate -f -y /dev/sdad
/sbin/pvcreate -f -y /dev/sdaf
/sbin/pvcreate -f -y /dev/sdah
/sbin/pvcreate -f -y /dev/sdaj
/sbin/pvcreate -f -y /dev/sdal
/sbin/pvcreate -f -y /dev/sdao
/sbin/pvcreate -f -y /dev/sdap
/sbin/pvcreate -f -y /dev/sds
/sbin/pvcreate -f -y /dev/sdt
/sbin/pvcreate -f -y /dev/sdv
/sbin/pvcreate -f -y /dev/sdy
/sbin/pvcreate -f -y /dev/sdaa
/sbin/pvcreate -f -y /dev/sdac
/sbin/pvcreate -f -y /dev/sdae
/sbin/pvcreate -f -y /dev/sdag
/sbin/pvcreate -f -y /dev/sdai
/sbin/pvcreate -f -y /dev/sdak
/sbin/pvcreate -f -y /dev/sdam
/sbin/pvcreate -f -y /dev/sdan

I then mirror pairs of those:

/sbin/vgcreate vg00 /dev/sdu /dev/sds
/sbin/lvcreate -m 1 --corelog --nosync -n lv00 -L 65G vg00
/sbin/vgcreate vg01 /dev/sdw /dev/sdt
/sbin/lvcreate -m 1 --corelog --nosync -n lv01 -L 65G vg01
/sbin/vgcreate vg02 /dev/sdx /dev/sdv
/sbin/lvcreate -m 1 --corelog --nosync -n lv02 -L 65G vg02
/sbin/vgcreate vg03 /dev/sdz /dev/sdy
/sbin/lvcreate -m 1 --corelog --nosync -n lv03 -L 65G vg03
/sbin/vgcreate vg04 /dev/sdab /dev/sdaa
/sbin/lvcreate -m 1 --corelog --nosync -n lv04 -L 65G vg04
/sbin/vgcreate vg05 /dev/sdad /dev/sdac
/sbin/lvcreate -m 1 --corelog --nosync -n lv05 -L 65G vg05
/sbin/vgcreate vg06 /dev/sdaf /dev/sdae
/sbin/lvcreate -m 1 --corelog --nosync -n lv06 -L 65G vg06
/sbin/vgcreate vg07 /dev/sdah /dev/sdag
/sbin/lvcreate -m 1 --corelog --nosync -n lv07 -L 65G vg07
/sbin/vgcreate vg08 /dev/sdaj /dev/sdai
/sbin/lvcreate -m 1 --corelog --nosync -n lv08 -L 65G vg08
/sbin/vgcreate vg09 /dev/sdal /dev/sdak
/sbin/lvcreate -m 1 --corelog --nosync -n lv09 -L 65G vg09
/sbin/vgcreate vg10 /dev/sdao /dev/sdam
/sbin/lvcreate -m 1 --corelog --nosync -n lv10 -L 65G vg10
/sbin/vgcreate vg11 /dev/sdap /dev/sdan
/sbin/lvcreate -m 1 --corelog --nosync -n lv11 -L 65G vg11

Now, I'd like to stripe over those mirrors, and would expect that the 
first step would be to pvcreate the new lv's  (lv00-lv11), before doing so:

# lvs
  LV   VG   Attr   LSize  Origin Snap%  Move Log Copy%
  lv00 vg00 Mwi-a- 65.00G                        100.00
  lv01 vg01 Mwi-a- 65.00G                        100.00
  lv02 vg02 Mwi-a- 65.00G                        100.00
  lv03 vg03 Mwi-a- 65.00G                        100.00
  lv04 vg04 Mwi-a- 65.00G                        100.00
  lv05 vg05 Mwi-a- 65.00G                        100.00
  lv06 vg06 Mwi-a- 65.00G                        100.00
  lv07 vg07 Mwi-a- 65.00G                        100.00
  lv08 vg08 Mwi-a- 65.00G                        100.00
  lv09 vg09 Mwi-a- 65.00G                        100.00

# vgs
  VG   #PV #LV #SN Attr   VSize   VFree
  vg00   2   3   0 wz--n- 135.66G 5.66G
  vg01   2   3   0 wz--n- 135.66G 5.66G
  vg02   2   3   0 wz--n- 135.66G 5.66G
  vg03   2   3   0 wz--n- 135.66G 5.66G
  vg04   2   3   0 wz--n- 135.66G 5.66G
  vg05   2   3   0 wz--n- 135.66G 5.66G
  vg06   2   3   0 wz--n- 135.66G 5.66G
  vg07   2   3   0 wz--n- 135.66G 5.66G
  vg08   2   3   0 wz--n- 135.66G 5.66G
  vg09   2   3   0 wz--n- 135.66G 5.66G

But then:

# pvcreate -ff -y -v /dev/vg00/lv00
    Wiping cache of LVM-capable devices
    Wiping internal VG cache
  Device /dev/vg00/lv00 not found (or ignored by filtering).

I did run w/ -vvv, and extracted this pertinent looking stuff:

    Wiping internal VG cache
      Locking /var/lock/lvm/P_orphans WB
        dm status   (253:2) OF   [16384]
        /dev/dm-2: Skipping: Suspended dm device
  Device /dev/vg00/lv00 not found (or ignored by filtering).
      Unlocking /var/lock/lvm/P_orphans

I don't understand why the device is suspended - due to the --nosync the 
copy% is at 100, and the device read/writes just fine. I'm using:

# pvcreate --version
  LVM version:     2.02.29 (2007-12-05)
  Library version: 1.02.24 (2007-12-20)
  Driver version:  4.12.0

and 2.6.24-rc6 kernel.

As noted previously, I could invert the operation, and things worked 
fine (RAID 0+1 - mirror 2 stripes constructed from 12 devices each).

Any help would be much appreciated, thanks,
Alan
