From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 11/21] [libmultipath] Fix typo on
 blacklist_exceptions handler
Date: Mon, 21 May 2007 11:24:23 +0200
Message-ID: <20070521092423.86CE6D44CA@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


blacklist_exceptions_handler() has a typo which prevents the handler
from working.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/dict.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index c705cc6..4572a7d 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -270,7 +270,7 @@ blacklist_exceptions_handler(vector strv
 	conf->elist_wwid = vector_alloc();
 	conf->elist_device = vector_alloc();
 
-	if (!conf->elist_devnode || !conf->elist_wwid || !conf->blist_device)
+	if (!conf->elist_devnode || !conf->elist_wwid || !conf->elist_device)
 		return 1;
 
 	return 0;
-- 
1.4.3.4
