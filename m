From: mwilck@suse.com
Subject: [PATCH 06/11] libmultipath: eliminate more
	signed/unsigned comparisons
Date: Tue, 12 May 2020 00:39:26 +0200
Message-ID: <20200511223931.18261-7-mwilck@suse.com>
References: <20200511223931.18261-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200511223931.18261-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

Fix some more compiler warnings about signed/unsigned comparison.
I've observed these only on 32bit builds, therefore they went unnoticed
before.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c      |  2 +-
 libmultipath/print.c                  | 12 ++++++------
 libmultipath/prioritizers/alua_spc3.h |  2 +-
 multipathd/cli_handlers.c             | 20 ++++++++++----------
 multipathd/main.c                     |  2 +-
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index fadc9e10..126601c3 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -238,7 +238,7 @@ static void mpath_format_readfullstatus(struct prin_resp *pr_buff)
 	uint32_t additional_length, k, tid_len_len = 0;
 	char tempbuff[MPATH_MAX_PARAM_LEN];
 	struct prin_fulldescr fdesc;
-	static const int pbuf_size =
+	static const unsigned int pbuf_size =
 		sizeof(pr_buff->prin_descriptor.prin_readfd.private_buffer);
 
 	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readfd.prgeneration);
diff --git a/libmultipath/print.c b/libmultipath/print.c
index b944ef32..298b3764 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1958,25 +1958,25 @@ char *snprint_config(const struct config *conf, int *len,
 		}
 
 		c = reply + snprint_defaults(conf, reply, maxlen);
-		if ((c - reply) == maxlen)
+		if (c == reply + maxlen)
 			continue;
 
 		c += snprint_blacklist(conf, c, reply + maxlen - c);
-		if ((c - reply) == maxlen)
+		if (c == reply + maxlen)
 			continue;
 
 		c += snprint_blacklist_except(conf, c, reply + maxlen - c);
-		if ((c - reply) == maxlen)
+		if (c == reply + maxlen)
 			continue;
 
 		c += snprint_hwtable(conf, c, reply + maxlen - c,
 				     hwtable ? hwtable : conf->hwtable);
-		if ((c - reply) == maxlen)
+		if (c == reply + maxlen)
 			continue;
 
 		c += snprint_overrides(conf, c, reply + maxlen - c,
 				       conf->overrides);
-		if ((c - reply) == maxlen)
+		if (c == reply + maxlen)
 			continue;
 
 		if (VECTOR_SIZE(conf->mptable) > 0 ||
@@ -1984,7 +1984,7 @@ char *snprint_config(const struct config *conf, int *len,
 			c += snprint_mptable(conf, c, reply + maxlen - c,
 					     mpvec);
 
-		if ((c - reply) < maxlen) {
+		if (c < reply + maxlen) {
 			if (len)
 				*len = c - reply;
 			return reply;
diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
index 18b495ef..7ba2cf4c 100644
--- a/libmultipath/prioritizers/alua_spc3.h
+++ b/libmultipath/prioritizers/alua_spc3.h
@@ -284,7 +284,7 @@ struct rtpg_data {
 #define RTPG_FOR_EACH_PORT_GROUP(p, g) \
 		for( \
 			g = &(p->data[0]); \
-			(((char *) g) - ((char *) p)) < get_unaligned_be32(p->length); \
+			((char *) g) < ((char *) p) + get_unaligned_be32(p->length); \
 			g = (struct rtpg_tpg_dscr *) ( \
 				((char *) g) + \
 				sizeof(struct rtpg_tpg_dscr) + \
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 7d878c88..31c3d9fd 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -66,7 +66,7 @@ show_paths (char ** r, int * len, struct vectors * vecs, char * style,
 		c += snprint_foreign_paths(c, reply + maxlen - c,
 					   style, pretty);
 
-		again = ((c - reply) == (maxlen - 1));
+		again = (c == reply + maxlen - 1);
 
 		REALLOC_REPLY(reply, again, maxlen);
 	}
@@ -102,7 +102,7 @@ show_path (char ** r, int * len, struct vectors * vecs, struct path *pp,
 
 		c += snprint_path(c, reply + maxlen - c, style, pp, 0);
 
-		again = ((c - reply) == (maxlen - 1));
+		again = (c == reply + maxlen - 1);
 
 		REALLOC_REPLY(reply, again, maxlen);
 	}
@@ -131,7 +131,7 @@ show_map_topology (char ** r, int * len, struct multipath * mpp,
 		c = reply;
 
 		c += snprint_multipath_topology(c, reply + maxlen - c, mpp, 2);
-		again = ((c - reply) == (maxlen - 1));
+		again = (c == reply + maxlen - 1);
 
 		REALLOC_REPLY(reply, again, maxlen);
 	}
@@ -171,7 +171,7 @@ show_maps_topology (char ** r, int * len, struct vectors * vecs)
 		}
 		c += snprint_foreign_topology(c, reply + maxlen - c, 2);
 
-		again = ((c - reply) == (maxlen - 1));
+		again = (c == reply + maxlen - 1);
 
 		REALLOC_REPLY(reply, again, maxlen);
 	}
@@ -209,7 +209,7 @@ show_maps_json (char ** r, int * len, struct vectors * vecs)
 		c = reply;
 
 		c += snprint_multipath_topology_json(c, maxlen, vecs);
-		again = ((c - reply) == maxlen);
+		again = (c == reply + maxlen);
 
 		REALLOC_REPLY(reply, again, maxlen);
 	}
@@ -238,7 +238,7 @@ show_map_json (char ** r, int * len, struct multipath * mpp,
 		c = reply;
 
 		c += snprint_multipath_map_json(c, maxlen, mpp);
-		again = ((c - reply) == maxlen);
+		again = (c == reply + maxlen);
 
 		REALLOC_REPLY(reply, again, maxlen);
 	}
@@ -487,7 +487,7 @@ show_map (char ** r, int *len, struct multipath * mpp, char * style,
 		c += snprint_multipath(c, reply + maxlen - c, style,
 				       mpp, pretty);
 
-		again = ((c - reply) == (maxlen - 1));
+		again = (c == reply + maxlen - 1);
 
 		REALLOC_REPLY(reply, again, maxlen);
 	}
@@ -533,7 +533,7 @@ show_maps (char ** r, int *len, struct vectors * vecs, char * style,
 		}
 		c += snprint_foreign_multipaths(c, reply + maxlen - c,
 						style, pretty);
-		again = ((c - reply) == (maxlen - 1));
+		again = (c == reply + maxlen - 1);
 
 		REALLOC_REPLY(reply, again, maxlen);
 	}
@@ -1297,7 +1297,7 @@ show_blacklist (char ** r, int * len)
 
 		c = reply;
 		c += snprint_blacklist_report(conf, c, maxlen);
-		again = ((c - reply) == maxlen);
+		again = (c == reply + maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 	}
 	pthread_cleanup_pop(1);
@@ -1339,7 +1339,7 @@ show_devices (char ** r, int * len, struct vectors *vecs)
 
 		c = reply;
 		c += snprint_devices(conf, c, maxlen, vecs);
-		again = ((c - reply) == maxlen);
+		again = (c == reply + maxlen);
 		REALLOC_REPLY(reply, again, maxlen);
 	}
 	pthread_cleanup_pop(1);
diff --git a/multipathd/main.c b/multipathd/main.c
index 8baf9abe..6b7db2c0 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2374,7 +2374,7 @@ checkerloop (void *ap)
 				conf = get_multipath_config();
 				max_checkint = conf->max_checkint;
 				put_multipath_config(conf);
-				if (diff_time.tv_sec > max_checkint)
+				if (diff_time.tv_sec > (time_t)max_checkint)
 					condlog(1, "path checkers took longer "
 						"than %lu seconds, consider "
 						"increasing max_polling_interval",
-- 
2.26.2
