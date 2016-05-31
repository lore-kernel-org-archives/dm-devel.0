From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/7] multipathd: handler fixes
Date: Tue, 31 May 2016 18:16:44 -0500
Message-ID: <1464736610-20027-2-git-send-email-bmarzins@redhat.com>
References: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
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

We now have unlocked handlers, but these can't be used to call functions
that will access the pathvec, mpvec, or conf, since these are what the
vecs lock protects. cli_list_config and cli_list_blacklist both need to
access conf, so they can't be unlocked handlers.

Also, if parse_cmd fails to lock the vecs->lock when it calls
pthread_mutex_timedlock, we can't call unlock() on it, because unlocking
a mutex you haven't locked causes undefined behviour. So we need to
only execute the handler if didn't timeout trying to acquire the lock.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli.c  | 2 +-
 multipathd/main.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index d991cd0..1925d82 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -496,7 +496,7 @@ parse_cmd (char * cmd, char ** reply, int * len, void * data, int timeout )
 			pthread_testcancel();
 			r = h->fn(cmdvec, reply, len, data);
 		}
-		lock_cleanup_pop(vecs->lock);
+		pthread_cleanup_pop(!r);
 	} else
 		r = h->fn(cmdvec, reply, len, data);
 	free_keys(cmdvec);
diff --git a/multipathd/main.c b/multipathd/main.c
index 2c7486d..77c802b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1132,8 +1132,8 @@ uxlsnrloop (void * ap)
 	set_handler_callback(LIST+MAP+TOPOLOGY, cli_list_map_topology);
 	set_handler_callback(LIST+MAP+FMT, cli_list_map_fmt);
 	set_handler_callback(LIST+MAP+RAW+FMT, cli_list_map_fmt);
-	set_unlocked_handler_callback(LIST+CONFIG, cli_list_config);
-	set_unlocked_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
+	set_handler_callback(LIST+CONFIG, cli_list_config);
+	set_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
 	set_handler_callback(LIST+DEVICES, cli_list_devices);
 	set_handler_callback(LIST+WILDCARDS, cli_list_wildcards);
 	set_handler_callback(ADD+PATH, cli_add_path);
-- 
1.8.3.1
