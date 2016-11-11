From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/3] more multipath config options
Date: Fri, 11 Nov 2016 16:58:20 -0600
Message-ID: <1478905103-9735-1-git-send-email-bmarzins@redhat.com>
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

Here are two new mutipath config options, and the documentation for
disable_changed_wwids.

Benjamin Marzinski (3):
  document "disable_changed_wwids" config parameter
  allow multipath to retry removes of in-use devices
  add "max_sectors_kb" config parameter

 libmultipath/config.c      |  3 +++
 libmultipath/config.h      |  4 ++++
 libmultipath/configure.c   |  2 ++
 libmultipath/defaults.h    |  1 +
 libmultipath/devmapper.c   | 38 ++++++++++++++++++++------------------
 libmultipath/devmapper.h   |  4 ++--
 libmultipath/dict.c        | 17 +++++++++++++++++
 libmultipath/discovery.c   | 23 +++++++++++++++++++++++
 libmultipath/discovery.h   |  1 +
 libmultipath/propsel.c     | 16 ++++++++++++++++
 libmultipath/propsel.h     |  1 +
 libmultipath/structs.h     |  6 ++++++
 multipath/main.c           | 17 ++++++++++++-----
 multipath/multipath.8      |  7 +++++++
 multipath/multipath.conf.5 | 35 +++++++++++++++++++++++++++++++++++
 15 files changed, 150 insertions(+), 25 deletions(-)

-- 
1.8.3.1
