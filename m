From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] Next try: systemd watchdog integration
Date: Fri, 13 Dec 2013 10:11:16 +0100
Message-ID: <1386925879-31225-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

here is now a clean version of the systemd watchdog integration.
It's now completely optional, and will only be enabled if the
user / admin manually modifies the service file.
So that should cover all objections Ben had.

Hannes Reinecke (3):
  multipathd: enable core dumps for systemd
  Use correct systemd unit directory
  multipathd: Implement systemd watchdog integration

 Makefile.inc                  |  2 +-
 libmultipath/config.h         |  3 +++
 multipath/multipath.conf.5    |  7 +++++--
 multipathd/main.c             | 23 +++++++++++++++++++++-
 multipathd/multipathd.8       | 45 ++++++++++++++++++++++++++++++++++++++++++-
 multipathd/multipathd.service |  1 +
 6 files changed, 76 insertions(+), 5 deletions(-)

-- 
1.8.1.4
