From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 0/2] dm-ioband v0.0.3: The I/O bandwidth
 controller: Introduction
Date: Tue, 05 Feb 2008 19:17:35 +0900 (JST)
Message-ID: <20080205.191735.193708307.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

Hi everyone,

This is dm-ioband version 0.0.3 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper driver,
which gives specified bandwidth to each job running on the same physical
device.

Changes since 0.0.2 (23rd January):
   - Ported to linux-2.6.24.
   - Rename the name of this device-mapper device as "ioband."
   - The output format of "dmsetup table" can be recognized by "dmsetup
     create/load/reload."
   - Add a new feature to block processes requesting BIOs in case the number
     of the uncompleted BIOs becomes too large.
   - Gid can be used as an ioband group type.
   - Support "dmsetup suspend --noflush."
   - Fix the problem that "dmsetup detach" doesn't wait the completion of
     all the BIOs in the detaching group.
   - Fix the problem that "dmsetup message attach" can't accept ID 0.
   - Code cleanups. Use prefix "dm_" for the global symbols.
   - Add examples in the document.

Thanks,
Ryo Tsuruta
