From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH v2 0/1] Fix false removes
Date: Thu, 29 Nov 2018 16:26:20 -0600
Message-ID: <1543530381-12303-1-git-send-email-bmarzins@redhat.com>
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

This is a resend of my previous patch 2/2, incorporating both of
Martin's suggestions.

Benjamin Marzinski (1):
  libmultipath: fix false removes in dmevents polling code

 libmpathpersist/mpath_persist.c |  4 ++--
 libmultipath/devmapper.c        | 41 +++++++++++++++++++++++++++++------------
 multipath/main.c                |  2 +-
 multipathd/dmevents.c           |  8 ++++++--
 multipathd/main.c               |  2 +-
 5 files changed, 39 insertions(+), 18 deletions(-)

-- 
2.7.4
