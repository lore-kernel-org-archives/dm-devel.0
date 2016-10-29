From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 00/10] misc. multipath patches.
Date: Fri, 28 Oct 2016 21:55:16 -0500
Message-ID: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
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

Here are a number of multipath patches. The first two are resends of the
skip_kpartx patches that didn't get merged from my last patchset.  I didn't see
any complaints about them, so I just rebased them. If there are any questions
or objections, please let me know.

The third and ninth patches both deal with paths that change wwids while in
use. Ususally this happens because of LUN remapping, which is not multipath's
fault. However, not dealing with it can cause multipathd to crash. It's also
nice to give users the chance to disable the device before it accidentally
writes to the wrong LUN.

The INIT_REQUESTED_UDEV code is currently broken, but my fix does mean
that multipathd now grabs the vecs lock on all path change events.  It did
this for years, so I don't know it that is controversial or not. If it is
I can probably work around it. The disable_changed_wwids also needs to grab
the vecs lock on change events, but only if the user enables it (it's off
by default).

Benjamin Marzinski (10):
  libmultipath: add skip_kpartx option
  kpartx.rules: respect skip_kpartx flag
  do not allow in-use path to change wwid
  multipathd: add "map failures" format wildcard
  mpath: don't wait for udev if all paths are down
  multipath: set cookie before using it.
  recover from errors in multipathd startup
  fix INIT_REQUESTED_UDEV code
  add disable_changed_wwids option
  set retrigger_tries to 0 for multipath

 kpartx/kpartx.rules        |   2 +
 libmultipath/config.c      |   3 +
 libmultipath/config.h      |   4 ++
 libmultipath/configure.c   |  13 +++--
 libmultipath/defaults.h    |   2 +
 libmultipath/devmapper.c   |  47 +++++++++++-----
 libmultipath/devmapper.h   |   8 ++-
 libmultipath/dict.c        |  17 ++++++
 libmultipath/discovery.c   |  15 +++--
 libmultipath/discovery.h   |   1 +
 libmultipath/dmparser.c    |   8 +++
 libmultipath/print.c       |   7 +++
 libmultipath/propsel.c     |  18 ++++++
 libmultipath/propsel.h     |   1 +
 libmultipath/structs.h     |   9 +++
 libmultipath/structs_vec.c |  28 ++++++----
 multipath/main.c           |   1 +
 multipath/multipath.conf.5 |  17 ++++++
 multipathd/cli_handlers.c  |  15 ++++-
 multipathd/main.c          | 136 +++++++++++++++++++++++++++++----------------
 20 files changed, 261 insertions(+), 91 deletions(-)

-- 
1.8.3.1
