From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 00/16] multipath path classification
Date: Fri, 19 Jan 2018 01:29:00 +0100
Message-ID: <20180119002916.10323-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This patch series implements the recommendation in my recent posting
"Multipath path classification revisited". My testing has been surprisingly
successful so far; more testing is of course needed.
Anyway, I think it's in a shape that I can ask for review.

I've seen Ben's detailed reply to my posting, but his comments haven't been
taken into account in this series yet.

Benjamin Marzinski (1):
  libmultipath: trigger change uevent on new device creation

Martin Wilck (15):
  Revert "multipath: ignore -i if find_multipaths is set"
  Revert "multipathd: imply -n if find_multipaths is set"
  libmultipath: add mpvec param to should_multipath()
  libmultipath: should_multipath: keep existing maps
  multipath -u -i: change logic for find_multipaths
  libmultipath: let ignore_wwids be set in config file
  multipathd: replace -n with !ignore_wwids
  multipath.conf.5: document "ignore_wwids"
  multipath.8: adapt documentation of '-i'
  multipathd.8: document that '-n' is now ignored
  multipath: common code path for CMD_VALID_PATH
  multipath -u/-c: change output to environment/key format
  multipath -u/-c: add "$DEV is maybe a valid path"
  multipath.rules: find_multipaths+ignore_wwids logic
  libmultipath: trigger path uevent only when necessary

 libmultipath/config.c      |  1 +
 libmultipath/config.h      |  1 -
 libmultipath/configure.c   | 48 ++++++++++++++++++++++++++++++++---
 libmultipath/configure.h   |  1 +
 libmultipath/defaults.h    |  1 +
 libmultipath/dict.c        |  4 +++
 libmultipath/wwids.c       | 13 +++++++---
 libmultipath/wwids.h       |  2 +-
 multipath/main.c           | 58 ++++++++++++++++++++++--------------------
 multipath/multipath.8      |  3 ++-
 multipath/multipath.conf.5 | 31 +++++++++++++++++++++++
 multipath/multipath.rules  | 63 +++++++++++++++++++++++++++++++++++++++++++---
 multipathd/main.c          | 16 +++---------
 multipathd/multipathd.8    |  5 ++--
 14 files changed, 192 insertions(+), 55 deletions(-)

-- 
2.15.1
