From: John DeFranco <defranco@cup.hp.com>
Subject: Device-mapper Question
Date: Mon, 28 Feb 2005 13:20:05 -0800
Message-ID: <200502281320.05297.defranco@cup.hp.com>
Reply-To: defranco@cup.hp.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
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

Hello all,

I have a question that I believe is related to the device-mapper but may 
easily be lvm2 instead. In any even here goes. For the purposes of this 
discussion I have two volume groups defined, vg1 and vg2, each with one 
logical volume (lvol0 for each). When I activate a volume group the logical 
volume(s) appear under the /dev/mapper directory such as:

# vgchange -a y vg2
# ll /dev/mapper
total 181
drwxr-xr-x   2 root root    104 Feb 25 09:34 .
drwxr-xr-x  35 root root 185472 Feb 25 09:34 ..
lrwxrwxrwx   1 root root     16 Feb 16 17:34 control -> ../device-mapper
brw-------   1 root root 253, 0 Feb 25 09:34 vg2-lvol0
#

And

# vgchange -a y vg1
# ll /dev/mapper
total 181
drwxr-xr-x   2 root root    136 Feb 28 12:26 .
drwxr-xr-x  36 root root 185496 Feb 28 12:26 ..
lrwxrwxrwx   1 root root     16 Feb 16 17:34 control -> ../device-mapper
brw-------   1 root root 253, 1 Feb 28 12:26 vg1-lvol0
brw-------   1 root root 253, 0 Feb 25 09:46 vg2-lvol0
# 

So no problems. Now if I deactivate them and reactivate them in a different 
order I get different minor numbers:
# vgchange -a n vg1
  0 logical volume(s) in volume group "vg1" now active
# vgchange -a n vg2
  0 logical volume(s) in volume group "vg2" now active
# vgchange -a y vg1
  1 logical volume(s) in volume group "vg1" now active
# vgchange -a y vg2
  1 logical volume(s) in volume group "vg2" now active
# !ll
ll /dev/mapper
total 181
drwxr-xr-x   2 root root    136 Feb 28 12:27 .
drwxr-xr-x  36 root root 185496 Feb 28 12:27 ..
lrwxrwxrwx   1 root root     16 Feb 16 17:34 control -> ../device-mapper
brw-------   1 root root 253, 0 Feb 28 12:27 vg1-lvol0
brw-------   1 root root 253, 1 Feb 28 12:27 vg2-lvol0
# 

Overall this is ok except in the case of nfs. If I'm exporting these 
filesystems and the minor numbers change the client gets a 'stale file 
handle'. Is there anyway to keep the same minor numbers or otherwise a way 
around this?

Thanks!



 

-- 
==========

John DeFranco
Hewlett-Packard Company
Availability Clusters Solution Division
19111 Pruneridge Ave, M/S 4101
Cupertino, CA 95014 
phone: 408-447-7543
mailto: john.defranco@hp.com
