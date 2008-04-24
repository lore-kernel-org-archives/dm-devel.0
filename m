From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v0.0.4:
 Introduction
Date: Thu, 24 Apr 2008 20:18:57 +0900 (JST)
Message-ID: <20080424.201857.183035295.ryov@valinux.co.jp>
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
Cc: agk@sourceware.org
List-Id: dm-devel.ids

Hi everyone,

This is dm-ioband version 0.0.4 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

Changes since 0.0.3 (5th February):
   - Improve the performance when many processes are issuing I/Os
     simultaneously. 
   - Change the table format to fully support dmsetup table/load commands.
     The table format consists all configuration parameters.
   - Port to linux-2.6.25.

An administration tool is available. It makes it easy to configure
bandwidths of disk partitions.
You can download it and find the manual at
http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/

For more details, please refer to:
http://people.valinux.co.jp/~ryov/dm-ioband/

Thanks,
Ryo Tsuruta
