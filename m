From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/2] Additional prkeys work
Date: Thu, 21 Sep 2017 12:35:07 -0500
Message-ID: <1506015309-29123-1-git-send-email-bmarzins@redhat.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

These are the changes from the v3 version of my prkeys patches, since
that version is already upstream.

Benjamin Marzinski (2):
  mpathpersist: Fix invalid condition check
  multipath: add man page info for my prkey changes

 libmpathpersist/mpath_persist.c |  5 +++--
 multipath/multipath.conf.5      | 17 +++++++++++++++++
 multipathd/multipathd.8         | 16 ++++++++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

-- 
2.7.4
