From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/3] multipath-tools: compilation fixes
Date: Tue,  8 Jan 2019 12:32:43 +0100
Message-ID: <20190108113246.5903-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Christophe,

my late NVMe patch series broke compilatioin with older
kernel headers. This series fixes that, and adds two other
minor build-related fixes.

Regards,
Martin

Martin Wilck (3):
  libmultipath: fix compilation with older kernel headers
  multipath: fix gcc 4.8 uninitialized variable warning
  multipath_tools: remove ENABLE_RADOS

 Makefile.inc                         |  4 +-
 libmultipath/Makefile                | 11 ++---
 libmultipath/foreign/Makefile        |  7 ++-
 libmultipath/nvme/linux/nvme_ioctl.h | 67 ++++++++++++++++++++++++++++
 multipath/main.c                     |  9 +---
 5 files changed, 76 insertions(+), 22 deletions(-)
 create mode 100644 libmultipath/nvme/linux/nvme_ioctl.h

-- 
2.19.2
