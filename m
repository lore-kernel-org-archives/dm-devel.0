From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/57] multipathd: Do not print misleading
	message 'not found in pathvec'
Date: Wed, 27 Apr 2016 13:10:20 +0200
Message-ID: <1461755458-29225-20-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When looking up a path in the existing configuration it is perfectly
possible for the path not to be present.
This should not generate a message as it might be errorneously
interpreted as an error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/structs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index b773d1c..39b2e05 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -404,7 +404,6 @@ find_path_by_dev (vector pathvec, char * dev)
 		if (!strcmp(pp->dev, dev))
 			return pp;
 
-	condlog(3, "%s: not found in pathvec", dev);
 	return NULL;
 }
 
@@ -421,7 +420,6 @@ find_path_by_devt (vector pathvec, char * dev_t)
 		if (!strcmp(pp->dev_t, dev_t))
 			return pp;
 
-	condlog(3, "%s: not found in pathvec", dev_t);
 	return NULL;
 }
 
-- 
2.6.6
