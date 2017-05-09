From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/6] small multipath fixes
Date: Tue,  9 May 2017 11:56:59 -0500
Message-ID: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Here are a number of small multipath fixes. These patches are based on
top of my and Martin's previous patch sets.

Benjamin Marzinski (6):
  libmultipath: print alias with no_path_retry message
  multipathd: force reload device on all resizes
  libmultipath: refactor calls to get dm device info
  libmultipath: fix suspended devs from failed reloads
  kpartx: fix device checks
  mpath_persist: Don't join threads that don't exist

 kpartx/kpartx.c                 |  23 +++--
 libmpathpersist/mpath_persist.c |  34 +++++---
 libmpathpersist/mpath_persist.h |   3 +-
 libmultipath/devmapper.c        | 184 +++++++++++-----------------------------
 libmultipath/devmapper.h        |   4 +-
 libmultipath/propsel.c          |   2 +-
 multipathd/cli_handlers.c       |  25 ++----
 7 files changed, 100 insertions(+), 175 deletions(-)

-- 
1.8.3.1
