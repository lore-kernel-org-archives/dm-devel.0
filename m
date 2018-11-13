From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/2] multipathd: fix irritating "minor number
	mismatch" message
Date: Tue, 13 Nov 2018 22:30:51 +0100
Message-ID: <20181113213052.2009-2-mwilck@suse.com>
References: <20181113213052.2009-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181113213052.2009-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This is really an alias mismatch, not a minor number mismatch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 6289718d..0dddddb3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -778,8 +778,8 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 		goto out;
 	}
 	if (strcmp(mpp->alias, alias)) {
-		condlog(2, "%s: minor number mismatch (map %d, event %d)",
-			mpp->alias, mpp->dmi->minor, minor);
+		condlog(2, "%s: map alias mismatch: have \"%s\", got \"%s\")",
+			uev->kernel, mpp->alias, alias);
 		goto out;
 	}
 
-- 
2.19.1
