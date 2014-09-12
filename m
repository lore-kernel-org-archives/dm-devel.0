From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/6] Misc multipath patches
Date: Fri, 12 Sep 2014 12:44:46 -0500
Message-ID: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
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

Here are some various patches I've had waiting to go upstream

Benjamin Marzinski (6):
  libmultipath: cleanup rlookup_binding
  Add support for EMC XtremIO
  libmultipath: Add additional path wildcards
  Fix missing frees and null terminations
  multipath.conf: add all_devs device option
  Always put watchdog in the config structure

 kpartx/devmapper.c                       |  3 +-
 libmultipath/alias.c                     | 30 +++++-----
 libmultipath/blacklist.c                 |  7 +++
 libmultipath/config.c                    | 59 ++++++++++++++++++++
 libmultipath/config.h                    |  3 +-
 libmultipath/dict.c                      | 38 +++++++++++++
 libmultipath/hwtable.c                   | 13 +++++
 libmultipath/print.c                     | 95 +++++++++++++++++++++++++++++++-
 libmultipath/prioritizers/iet.c          |  2 +
 libmultipath/prioritizers/weightedpath.c |  5 +-
 libmultipath/propsel.c                   |  2 +-
 libmultipath/util.c                      |  2 +-
 12 files changed, 237 insertions(+), 22 deletions(-)

-- 
1.8.3.1
