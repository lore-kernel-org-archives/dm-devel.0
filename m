From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] sysfs prioritizer
Date: Fri, 15 Jul 2016 08:48:54 +0200
Message-ID: <1468565337-5178-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

this is a resend of a previous patchset for adding a 'sysfs'
prioritizer. This prioritizer uses the sysfs attributes
'access_state' and 'exclusive_pref_bit' to generate the
path priority.
Priority values are identical to those from the 'alua'
prioritizer.

Note: the mentioned sysfs attributes are filled in by
every device handler, but only the 'alua' handler has
enough logic to keep them up-to-date.
So use with caution for other device handlers.

Hannes Reinecke (3):
  libmultipath: call get_vpd_uid() if no uid_attribute is set
  alua prioritizer: Fix typo 'perf'
  multipathd: Add 'sysfs' prioritizer

 libmultipath/discovery.c           | 36 ++++++++++++++++++++++
 libmultipath/discovery.h           |  2 ++
 libmultipath/prio.h                |  1 +
 libmultipath/prioritizers/Makefile |  3 +-
 libmultipath/prioritizers/alua.c   |  8 ++---
 libmultipath/prioritizers/sysfs.c  | 61 ++++++++++++++++++++++++++++++++++++++
 libmultipath/propsel.c             |  6 +++-
 multipath/multipath.conf.5         | 19 ++++++++++--
 8 files changed, 127 insertions(+), 9 deletions(-)
 create mode 100644 libmultipath/prioritizers/sysfs.c

-- 
2.6.6
