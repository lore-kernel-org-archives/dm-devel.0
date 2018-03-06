From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/6] Fixes for config file parsing
Date: Tue,  6 Mar 2018 23:56:27 +0100
Message-ID: <20180306225633.12028-1-mwilck@suse.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This series was motivated by the real-world problem that a user couldn't
figure out how to write a blacklist entry for a device called '1.8" SSD'.
Fixing this for good turned out to be a little tricky, therefore I also
added a test suite.

Martin Wilck (6):
  tests/uevent: fix -Wcast-qual errors
  tests: add unit tests for config file parser
  libmultipath: config parser: don't strip whitepace between quotes
  libmultipath: config parser: Allow '"' in strings
  libmultipath: config parser: fix corner case for double quotes
  multipath.conf(5): improve syntax documentation

 libmultipath/parser.c      |  65 ++++--
 multipath/multipath.conf.5 |  17 ++
 tests/Makefile             |   2 +-
 tests/globals.c            |   1 +
 tests/parser.c             | 497 +++++++++++++++++++++++++++++++++++++++++++++
 tests/uevent.c             |   8 +-
 6 files changed, 566 insertions(+), 24 deletions(-)
 create mode 100644 tests/parser.c

-- 
2.16.1
