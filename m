From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 0/3] dm: allow mempool and bioset reserves to
	be tuned
Date: Fri, 13 Sep 2013 17:08:11 -0400
Message-ID: <1379106494-16366-1-git-send-email-snitzer@redhat.com>
References: <20130913203005.GA8635@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130913203005.GA8635@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

You can pull these changes from the 'devel' branch of:
git://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git

To browse, see:
https://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel

v3 changes:
Added bounds checking (if 0 reset to default, if > 1024 reset to 1024)

v2 changes:
Simplified the implementation.  Dropped the peak_reserved_rq_based_ios
tracking, we'll use the tracepoint patch Jun'ichi Nomura suggested:
http://www.redhat.com/archives/dm-devel/2013-September/msg00048.html

Mike Snitzer (3):
  dm: lower bio-based mempool reservation
  dm: add reserved_rq_based_ios module parameter
  dm: add reserved_bio_based_ios module parameter

 drivers/md/dm-io.c    |    7 ++---
 drivers/md/dm-mpath.c |    6 ++--
 drivers/md/dm.c       |   60 +++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/dm.h       |    3 ++
 4 files changed, 65 insertions(+), 11 deletions(-)
