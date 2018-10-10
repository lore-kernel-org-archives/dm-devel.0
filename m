From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/8]  various multipath-tools patches
Date: Wed, 10 Oct 2018 22:04:58 +0200
Message-ID: <20181010200506.15796-1-mwilck@suse.com>
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

this series contains some patches I had on my list for
some time,  plus some stuff that came up during the discussion
about Ben's last large patch series.

This goes on top of the "[PATCH 0/6] More misc multipath patches"
series that Ben sent today.

Regards,
Martin

Martin Wilck (8):
  test-kpartx: add test for invocation on image file
  libmultipath: scsi_ioctl_pathinfo doesn't fail
  libmultipath: cciss_ioctl_pathinfo doesn't fail
  multipath.rules: add comment about DM_MULTIPATH_DEVICE_PATH=2
  multipath.8: man page update
  libmultipath: test code for "zombie" TUR threads
  libmultipath: handle TUR threads that can't be cancelled
  multipathd: handle repeated udev retrigger failure

 kpartx/test-kpartx          |  24 +++-
 libmultipath/checkers/tur.c |  69 ++++++++-
 libmultipath/discovery.c    |  33 ++---
 multipath/multipath.8       | 273 ++++++++++++++++++++++--------------
 multipath/multipath.rules   |   4 +
 multipathd/main.c           |  32 +++--
 6 files changed, 297 insertions(+), 138 deletions(-)

-- 
2.19.0
