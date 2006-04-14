From: Alasdair G Kergon <agk@redhat.com>
Subject: LVM2 release 2.02.03 / device-mapper 1.02.04
Date: Fri, 14 Apr 2006 22:43:57 +0100
Message-ID: <20060414214357.GE4521@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
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
To: linux-lvm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Some bug fixes and minor enhancements. (See the WHATS_NEW files.)

  ftp://sources.redhat.com/pub/dm/device-mapper.1.02.04.tgz
  ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.03.tgz

The tools should cope better now if faced with multiple distinct
VGs with the same name.  'pvs -P /dev/whatever -o+vg_uuid' output
should be reliable, and vgrename accepts a VG uuid as first
argument.

And libdevmapper has support again for older 2.6 kernels that 
can't handle mapped device referencing by device number.

Alasdair
-- 
agk@redhat.com
