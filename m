From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 0/2] multipath-tools: Licence housekeeping
Date: Thu, 30 Jun 2016 16:39:51 +0200
Message-ID: <1467297593-20514-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Xose Vazquez Perez (2):
  multipath-tools: replace FSF address with a www pointer
  multipath-tools: replace COPYING with a fresh copy from gnu.org

 COPYING                           | 22 ++++++++++------------
 kpartx/dasd.c                     |  4 +---
 kpartx/dasd.h                     |  4 +---
 kpartx/efi.h                      |  3 +--
 kpartx/gpt.c                      |  3 +--
 kpartx/gpt.h                      |  3 +--
 libmpathcmd/mpath_cmd.h           |  6 ++----
 libmultipath/checkers/cciss_tur.c |  6 +-----
 libmultipath/sysfs.c              |  3 +--
 libmultipath/uevent.c             |  3 +--
 10 files changed, 20 insertions(+), 37 deletions(-)

-- 
2.7.4
