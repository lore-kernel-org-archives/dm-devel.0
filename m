From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 0/1] update to v2 Fix false removes
Date: Tue, 11 Dec 2018 15:23:03 -0600
Message-ID: <1544563384-9721-1-git-send-email-bmarzins@redhat.com>
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

I accidentally didn't include Christophe in my

[PATCH v2 0/1] Fix false removes

patchset, so v1 of "libmultipath: fix false removes in dmevents polling   
code" went in.  This commit just patches the code to my v2 version.
Sorry for the confusion. I've included Martin's Reviewed-by as the end
result is the same as what he reviewed, and no intervening commits have
touched libmultipath/devmapper.c or multipathd/dmevents.c

Benjamin Marzinski (1):
  libmultipath: dm_is_mpath cleanup

 libmultipath/devmapper.c | 21 ++++++++++++---------
 multipathd/dmevents.c    |  4 +++-
 2 files changed, 15 insertions(+), 10 deletions(-)

-- 
2.7.4
