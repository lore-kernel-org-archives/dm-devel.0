From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/4] Coverity fixes
Date: Fri, 17 May 2019 11:14:06 -0500
Message-ID: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

These are fixes to some issues that coverity pointed out.

Benjamin Marzinski (4):
  libmultipath: handle clock_gettime failures in tur checker
  kpartx: fail if dup() of dasd file descriptor fails
  multipathd: fix REALLOC_REPLY with max length reply
  multipathd: handle NULL return from genhelp_handler

 kpartx/dasd.c               |  2 ++
 libmultipath/checkers/tur.c | 19 +++++++++++++++----
 multipathd/cli.c            |  6 +++++-
 multipathd/cli.h            | 17 +++++++++--------
 4 files changed, 31 insertions(+), 13 deletions(-)

-- 
2.17.2
