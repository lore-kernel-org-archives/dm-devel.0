From: Mike Snitzer <snitzer@redhat.com>
Subject: multipath-tools fixes
Date: Wed, 29 Apr 2009 16:10:41 -0400
Message-ID: <20090429201041.GB3062@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Christophe,

Please feel free to pull in the following changes with:
git pull http://people.redhat.com/msnitzer/multipath-tools.git +for-upstream

Mike Snitzer (6):
  multipathd: add error checking to client's process_req
  avoid NULL pointers in discovery code
  do not allow relative path names to be added to the pathvec
  cleanup various MALLOC/REALLOC callers
  fix small issues in cli_handlers
  multipathd: restrict /var/run/multipathd.sock permissions further

 libmultipath/config.c     |    2 +-
 libmultipath/config.h     |    1 +
 libmultipath/dict.c       |    8 ++++----
 libmultipath/discovery.c  |   15 ++++++++++++---
 libmultipath/parser.c     |   15 +++++++++------
 libmultipath/prio.c       |    2 +-
 libmultipath/uevent.c     |    2 +-
 libmultipath/uxsock.c     |    2 ++
 multipathd/cli_handlers.c |    6 +++---
 multipathd/main.c         |    9 +++++++++
 multipathd/uxclnt.c       |   11 ++++++-----
 11 files changed, 49 insertions(+), 24 deletions(-)
