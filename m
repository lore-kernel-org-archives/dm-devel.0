From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/4] multipath: fixes for invalid path device
	handling
Date: Thu,  7 Feb 2019 17:52:58 -0600
Message-ID: <20190207235302.21635-1-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

I recently got a bug from a user with a bad property
blacklist_exceptions line, where multipath tried to use a zram device,
which caused multipathd to crash. This patch set fixes that crash, and
then adds some additional safeguards to prevent things like this
happening in the future.

The first patch fixes the crash. This crash could be triggered by any
path device that isn't part of a multipath device, and has it's checker
fail to check the path correctly.

The second patch blacklists zram devices specifically. The third patch
fixes up some code weirdness that doesn't really cause any problems,
aside from the messages it prints.

The fourth patch changes how pathinfo works so that it now drops devices
of an unknown type if they can't get a wwid.  The biggest reason to do
this is so that multipath won't hold an open file descriptor for these
devices, which are almost definitely not multipathable (and occasionally
send them TUR ioctls, which are bound to fail, since they aren't scsi
devices).

As an aside, is there a good reason why multipath uses a devnode
blacklist to individually blacklist device types, instead of
blacklisting all denodes, and adding exceptions for the device types
that we do support?

Benjamin Marzinski (4):
  multipathd: avoid null pointer dereference in LOG_MSG
  multipath: blacklist zram devices
  multipathd: fix pp->initialized state ping-ponging
  multipathd: don't resend change events for unknown devices

 libmultipath/blacklist.c   |  2 +-
 libmultipath/checkers.c    |  2 +-
 libmultipath/discovery.c   | 10 +++++++---
 libmultipath/structs.h     |  1 +
 multipath/multipath.conf.5 |  2 +-
 multipathd/main.c          | 10 +++++++---
 6 files changed, 18 insertions(+), 9 deletions(-)

-- 
2.17.2
