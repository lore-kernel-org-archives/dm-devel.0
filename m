From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/3] multipathd per-device waiter fixes
Date: Fri, 16 Mar 2018 16:31:04 -0500
Message-ID: <1521235867-29476-1-git-send-email-bmarzins@redhat.com>
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

These patches fix some issues in the old waiter code that I noticed
when writing my the polling waiter code. Neither of them is particularly
likely to cause a problem in real world situations, but I don't think
the fixes should be that controversial.

These patches are based on top of my "multipath: new and rebased patches"
set.

Benjamin Marzinski (3):
  multipathd: fix waiter thread cancelling
  multipathd: move __setup_multipath to multipathd
  multipathd: stop waiter in __setup_multipath

 libmultipath/structs_vec.c | 103 ---------------------------------------------
 libmultipath/structs_vec.h |   4 --
 multipathd/dmevents.c      |   1 +
 multipathd/main.c          | 103 +++++++++++++++++++++++++++++++++++++++++++++
 multipathd/main.h          |   4 ++
 multipathd/waiter.c        |  22 ++++++++--
 6 files changed, 127 insertions(+), 110 deletions(-)

-- 
2.7.4
