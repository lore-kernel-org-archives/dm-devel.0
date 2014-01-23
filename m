From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [LVM PATCH 0/4] New cachepool and cache segment types
Date: Thu, 23 Jan 2014 09:05:44 -0600
Message-ID: <1390489548-18076-1-git-send-email-jbrassow@redhat.com>
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
To: dm-devel@redhat.com
Cc: agk@redhat.com, zkabelac@redhat.com
List-Id: dm-devel.ids

The following patches add the cache and cachepool segment types and
fill-out the device-mapper (userspace) interface.

 brassow

p.s.  I noticed after assembling the patches that the comments leading
the 'dm_get_status_cache' function in the 4th patch are not from the
latest kernel update.  The code is up-to-date.  I'll have to update that
comment before the final check-in.

Jonathan Brassow (4):
  Misc: New function for reading lvm config file, 'dm_config_get_int'
  cache:  New 'cachepool' segment type
  cache:  New 'cache' segment type
  cache:  Add device-mapper interface for retrieving a cache's status

 configure                        |   32 +++++-
 configure.in                     |   22 +++
 lib/Makefile.in                  |   11 ++-
 lib/commands/toolcontext.c       |    9 +-
 lib/metadata/metadata-exported.h |    7 +
 lib/metadata/segtype.h           |   10 ++
 lib/misc/configure.h.in          |    3 +
 libdm/libdevmapper.h             |   62 +++++++++-
 libdm/libdm-config.c             |   14 ++
 libdm/libdm-deptree.c            |  267 +++++++++++++++++++++++++++++++++++++-
 10 files changed, 426 insertions(+), 11 deletions(-)

-- 
1.7.7.6
