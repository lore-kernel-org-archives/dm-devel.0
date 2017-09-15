From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/4] NVMe path failover update
Date: Fri, 15 Sep 2017 08:30:26 +0200
Message-ID: <1505457030-119611-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

the current NVMe support is fairly rudimentary, and we've had reports
about spurious path failures under high load.
Which is a bit disappointing, seeing that high load is exactly what
NVMe is about ...
So here's a patchset to clean up the situation somewhat.
In particular:
- I've fixed up the discovery to fall in line with the other transports,
  like filling out the sg_id fields (so that we're not greeted with weird
  hashes in the topology output)
- I've added a 'none' checker, which doesn't do anything but rather returns
  the passed-in path state. Thing is, NVMe keeps the 'state' attribute in
  sync with the actual operation, so we can rely on that to reflect the
  current state of the connection. As we're evaluating this state via the
  path_offline() call prior to calling any checker there's no need for a
  checker whatsoever, and we can use the 'state' attribute as-is.
  Which is what the 'none' checker does.
  Incidentally, we _might_ get away with using the 'none' checker for
  FC, too; but this is to be tested.

As usual, comments and reviews are welcome.

Hannes Reinecke (4):
  discovery: sanitize NVMe discovery
  libmultipath/discovery: modify NVMe path states
  Add 'none' checker
  hwtable: set 'none' as default checker for NVMe

 libmultipath/checkers.c    | 22 +++++++++++++------
 libmultipath/checkers.h    |  3 ++-
 libmultipath/discovery.c   | 54 +++++++++++++++++++++++++++-------------------
 libmultipath/discovery.h   |  2 +-
 libmultipath/hwtable.c     |  2 +-
 multipath/multipath.conf.5 |  3 +++
 multipathd/main.c          |  2 +-
 7 files changed, 56 insertions(+), 32 deletions(-)

-- 
1.8.5.6
