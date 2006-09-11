From: Jie Gao <J.Gao@isu.usyd.edu.au>
Subject: /dev/mdX won't shutdown
Date: Mon, 11 Sep 2006 10:26:27 +1000 (EST)
Message-ID: <Pine.GSO.4.58.0609111015210.4522@banquo.ucc.usyd.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi All

Redhat Enterprise Linux AS update 4 patched up-to-date:
2.6.9-42.0.2.ELsmp #1 SMP Thu Aug 17 17:57:31 EDT 2006 x86_64 x86_64 x86_64 GNU/Linux
-------------------------------------------------------------------------------------

I reckon somebody must have encountered this, but I will report this anyway.

I have set up mirroring as /dev/md1 on the following multipath devices

/dev/mapper/3600d02300067d2b107ad9a43303d8200
/dev/mapper/3600d02300067d2f707d12552c2821300.

I have used lvms to create physical volume, volume group, and a logical
volume on it.

I can shutdown /dev/md1 using "mdadm --stop /dev/md1" and restart it
after all the above steps except the logical volume creation. I cannot
shut down /dev/md1 once the logical volume is created: I get the
following message:

mdadm: fail to stop array /dev/md1: Device or resource busy

The device is not mounted.

dmesetup says:

> dmsetup info -c
Name             Maj Min Stat Open Targ Event  UUID
www_vg_01-www_lv_01 253   2 L--w    1    1      0
LVM-138joBnlTj4A60wh1AqTEriQ2Tfczwyj8ckKOs70a8K2FcQjhwdx6M1e6ge48GVH
3600d02300067d2b107ad9a43303d8200 253   0 L--w    1    1      1 mpath-3600d02300067d2b107ad9a43303d8200
3600d02300067d2f707d12552c2821300 253   1 L--w    1    1      1 mpath-3600d02300067d2f707d12552c2821300

Regards,



Jie
