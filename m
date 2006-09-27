From: Ming Zhang <mingz@ele.uri.edu>
Subject: dm-snapshot-ex too high in 2.4.27 with dm patch?
Date: Wed, 27 Sep 2006 09:40:34 -0400
Message-ID: <1159364434.2705.22.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu,
	device-mapper development <dm-devel@redhat.com>
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

a 2.4.27 box with linux-2.4.27-devmapper-ioctl.patch patch got a OOM
several days ago. one workmate here claimed to only create several
snapshots on a 100GB LV. unfortunately, i could not reproduce the
error. 

fortunately i have the system monitor running on the box and got the
slabinfo file right before OOM. i noticed that this dm-snapshot-ex is
extremely high.

slabinfo - version: 1.1 (SMP)
kmem_cache            87     87    132    3    3    1 :  252  126
target_cmnd            0      0     60    0    0    1 :  252  126
iscsi_cmnd             0      0    124    0    0    1 :  252  126
dm-snapshot-in       128    180     40    2    2    1 :  252  126
dm-snapshot-ex    43236805 43237000     16 216185 216185    1 :  252
126
kcopyd-jobs          512    520    192   26   26    1 :  252  126
dm io               3328   3444     28   28   28    1 :  252  126
tcp_tw_bucket          0      0    128    0    0    1 :  252  126
tcp_bind_bucket        3    112     32    1    1    1 :  252  126
tcp_open_request       0      0     64    0    0    1 :  252  126

so under what kind of scenario, this dm-snapshot-ex can reach this high?
i know the exception is used when some write on snapshot in 2.6.x, is
this still hold true for 2.4.x?

also i browse the patch and could not find where the dm-snapshot-ex is
freed except when freeing the whole table. is this correct?

thanks!

Ming
