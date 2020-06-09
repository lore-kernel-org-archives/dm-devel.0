From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 0/3] multipath: change default devnode
	blacklist
Date: Tue,  9 Jun 2020 16:35:26 -0500
Message-ID: <1591738529-26810-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

I recently got a request to add the Oracle ASM filer driver devices to
multipath's builtin devnode blacklist.  However, instead of having to do
always this for each device type individually, I decided to make
multipath blacklist all non scsi, nvme, and dasd devnodes by default.
This is what the multipath udev rules already do.

Changes from v1:
Everything. Martin suggested an alternative method for doing this, which
is to treat an exclamation mark at the start of the blacklist/exceptions
regexes as inverting the matching on the rest of the regex.

Benjamin Marzinski (3):
  libmultipath: remove _blacklist_exceptions functions
  libmultipath: fix parser issue with comments in strings
  libmultipath: invert regexes that start with exclamation point

 libmultipath/blacklist.c   | 103 +++++++++++++++-------------------
 libmultipath/blacklist.h   |   3 +
 libmultipath/parser.c      |   4 +-
 multipath/multipath.conf.5 |  17 ++++--
 tests/blacklist.c          | 110 +++++++++++++++++++++++++++++++++++++
 tests/parser.c             |  42 ++++++++++++++
 tests/test-lib.c           |   2 +-
 7 files changed, 215 insertions(+), 66 deletions(-)

-- 
2.17.2
