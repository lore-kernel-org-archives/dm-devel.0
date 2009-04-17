From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/4] Various small multipath-tools improvements
Date: Fri, 17 Apr 2009 18:07:56 -0400
Message-ID: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Just a few cleanup patches.

Mike Snitzer (4):
  multipath-tools: update scsi_id arguments
  multipath-tools: install libmultipath.so in $syslibdir
  multipath-tools: update multipathd.init.redhat
  multipath-tools: change default location for bindings file

 Makefile.inc                      |    1 +
 libmultipath/Makefile             |    6 +-
 libmultipath/defaults.h           |    4 +-
 libmultipath/hwtable.c            |    6 +-
 multipath.conf.annotated          |    6 +-
 multipath.conf.defaults           |   78 ++++++++++++++++++------------------
 multipath.conf.synthetic          |    4 +-
 multipath/Makefile                |    1 +
 multipath/multipath.conf.5        |    2 +-
 multipathd/multipathd.init.redhat |   30 +++++++--------
 10 files changed, 69 insertions(+), 69 deletions(-)
