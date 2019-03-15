From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 0/9] multipath-tools: avoid I/O during uevent
	processing
Date: Fri, 15 Mar 2019 18:19:21 +0100
Message-ID: <20190315171930.28335-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Christophe, hi Ben,

the bulk of this series attempts to avoid unnecessary I/O for "multipath -u"
calls from udev rules. I came up with it in a recent attempt to debug
avoid "multipath -u" hangups during boot. I found that the detect_alua()
call in the get_refwwid->pathinfo->scsi_ioctl_pathinfo call sequence would
cause an sg ioctl to be sent for every "multipath -u" invocation. That's
obvious nonsense, we don't need to detect ALUA capabilities to find out
if a device is a potential multipath member.

So, rather than setting pp->tpgs in pathinfo, I resorted to a "lazy"
approach where ALUA capabilities are probed when they are needed, no
sooner. I also cleaned up the ALUA code a bit (still some more to go),
and made it attempt to read INQUIRY data from sysfs.

Regards,
Martin

Changes wrt v1:

 - 6/9: remove one remaining direct access to pp->tpgs
 - 9/9: use non-personal email address for maintainer

Martin Wilck (9):
  libmultipath: add sysfs_get_inquiry()
  libmultipath: alua: make API more consistent
  libmultipath: alua: try to retrieve inquiry data from sysfs
  libmultipath: constify sysfs_get_timeout()
  libmultipath: detect_alua(): use system timeout
  libmultipath: lazy tpgs probing
  libmultipath: don't link alua_rtpg.o twice
  libmultipath: check_rdac(): pre-check in hwtable
  libmultipath: hwtable: add Lenovo DE series

 libmultipath/discovery.c              | 46 +++++++++++++++++++--------
 libmultipath/discovery.h              | 10 +++---
 libmultipath/hwtable.c                | 20 ++++++++++++
 libmultipath/prioritizers/Makefile    |  3 --
 libmultipath/prioritizers/alua.c      |  4 +--
 libmultipath/prioritizers/alua_rtpg.c | 45 ++++++++++++++++++++------
 libmultipath/prioritizers/alua_rtpg.h |  7 ++--
 libmultipath/propsel.c                | 33 +++++++++++++------
 multipathd/main.c                     |  7 ++--
 9 files changed, 127 insertions(+), 48 deletions(-)

-- 
2.21.0
