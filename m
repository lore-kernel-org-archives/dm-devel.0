From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/11] SLES resync
Date: Fri, 13 Dec 2013 13:14:03 +0100
Message-ID: <1386936854-8399-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
List-Id: dm-devel.ids

Hi Christophe,

here are some more patches which have accumulated in my SLES
repository.
Please apply.

Hannes Reinecke (11):
  Remove trailing spaces from sysfs attributes
  Document 'wwids_file' and 'reservation_key'
  libmultipath: Fix typo in retain_attached_hw_handler
  multipath: do not print 'path is up' for removed paths
  libmultipath: proactively remove path
  multipath: do not call tur in sync mode if pthread_cancel fails
  multipathd: Update manpage
  Reset timezone information on reconfigure
  multipathd: Correctly initialize udev context
  multipathd: add path when transitioned from 'blocked' state
  Make 'multipath -t' able to run as normal user

 libmultipath/checkers.c     |  1 +
 libmultipath/checkers.h     |  5 +++++
 libmultipath/checkers/tur.c |  7 +++----
 libmultipath/config.c       |  1 -
 libmultipath/discovery.c    | 17 +++++++++++++----
 libmultipath/log.c          |  1 +
 libmultipath/propsel.c      |  2 +-
 libmultipath/sysfs.c        |  2 +-
 libmultipath/util.c         |  3 ++-
 libmultipath/util.h         |  2 +-
 multipath.conf.annotated    | 17 ++++++++++++++++-
 multipath/main.c            | 22 +++++++++++++---------
 multipathd/main.c           | 35 ++++++++++++++++++++++++++++++-----
 multipathd/multipathd.8     |  6 +++---
 14 files changed, 90 insertions(+), 31 deletions(-)

-- 
1.8.1.4
