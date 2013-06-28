From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/8] multipath: miscellaneous fixes and features
Date: Fri, 28 Jun 2013 18:26:13 -0500
Message-ID: <1372461981-6333-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Here's some patches that have been piling up.

Benjamin Marzinski (8):
  Add multipath path format wildcard
  load the dm-multipath module on multipathd startup
  Fix multipath rename from user_friendly_name to wwid
  Turn off user_friendly_names for netapp devices
  Don't detect prioritizers that don't work
  Only load a multipath device RO if RW load fails with EROFS
  signal waiter thread to stop waiting on dm events
  fix mutipath -W on empty wwids file

 libmultipath/configure.c      |  7 ----
 libmultipath/devmapper.c      | 98 +++++++++++--------------------------------
 libmultipath/devmapper.h      |  3 --
 libmultipath/hwtable.c        |  1 +
 libmultipath/print.c          | 11 +++++
 libmultipath/propsel.c        | 13 ++++--
 libmultipath/waiter.c         |  9 ++++
 libmultipath/wwids.c          |  6 +++
 multipathd/main.c             |  8 ++++
 multipathd/multipathd.service |  1 +
 10 files changed, 70 insertions(+), 87 deletions(-)

-- 
1.8.2
