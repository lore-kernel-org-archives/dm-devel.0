From: Gris Ge <fge@redhat.com>
Subject: [PATCH 0/4] multipath-tools: libdmmp improvements.
Date: Tue, 21 Nov 2017 22:09:13 +0800
Message-ID: <20171121140917.18298-1-fge@redhat.com>
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
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

 * Patch 1/4 is a resend.
 * Patch 2/4, 3/4, and 4/4 add new functions to libdmmp library.

Gris Ge (4):
  multipathd daemon: Fix incorrect use of CLOCK_MONOTONIC in pthread
  multipath-tools: libdmmp: Allow log function as NULL.
  multipath-tools: libdmmp: Add new function dmmp_last_error_msg()
  multipath-tools: libdmmp: Add new error DMMP_ERR_PERMISSION_DENY

 libdmmp/Makefile            |  2 +-
 libdmmp/libdmmp.c           | 20 ++++++++++++++++++++
 libdmmp/libdmmp/libdmmp.h   | 23 ++++++++++++++++++++++-
 libdmmp/libdmmp_misc.c      |  1 +
 libdmmp/test/libdmmp_test.c | 12 ++++++++----
 multipathd/cli.c            |  2 +-
 6 files changed, 53 insertions(+), 7 deletions(-)

-- 
2.15.0
