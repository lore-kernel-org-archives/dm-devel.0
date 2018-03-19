From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/2] Fix recently introduced inconsistencies
Date: Mon, 19 Mar 2018 09:23:49 -0700
Message-ID: <20180319162351.28950-1-bart.vanassche@wdc.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Christophe,

Analysis of recently introduced inconsistencies learned me the following:
- Not all .c files in the multipath-tools include the corresponding header
  files so the compiler cannot verify consistency of declarations and
  definitions for all declarations.
- A recent change of call-by-reference into call-by-value was incomplete.

This patch series addresses both issues. Please consider these patches for
the official multipath-tools repository.

Thanks,

Bart.

Bart Van Assche (2):
  Allow the compiler to verify consistency of declarations and
    definitions
  libmultipath: Fix recently introduced inconsistencies

 libmultipath/callout.c    |  1 +
 libmultipath/config.c     |  4 ++--
 libmultipath/debug.c      |  1 +
 libmultipath/defaults.c   |  1 +
 libmultipath/dict.c       |  1 +
 libmultipath/dict.h       | 14 +++++++-------
 libmultipath/dmparser.c   |  1 +
 libmultipath/hwtable.c    |  1 +
 libmultipath/propsel.c    | 45 +++++++++++++++++++++++----------------------
 libmultipath/propsel.h    |  4 ++--
 mpathpersist/main.c       |  1 +
 multipathd/cli_handlers.c |  1 +
 multipathd/uxclnt.c       |  1 +
 13 files changed, 43 insertions(+), 33 deletions(-)

-- 
2.16.2
