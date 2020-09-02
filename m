From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 09/14] libmultipath: check whether mp->features
 is NULl in, assemble_map
Date: Wed, 2 Sep 2020 15:21:15 +0800
Message-ID: <40cf77df-eaa3-fb72-69fd-9f865d12dc34@huawei.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

In assemble_map func, if add_feature fails and mp->features is
default value (NULL), STRDUP(mp->features) will cause a seg-fault.
In addition, f = STRDUP(mp->features) is just used for APPEND().
We can directly pass mp->features to APPEND().

Here, we firstly check whether mp->features is null.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/dmparser.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 482e9d0e..12182bf5 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -65,7 +65,7 @@ assemble_map (struct multipath * mp, char * params, int len)
 	int i, j;
 	int minio;
 	int nr_priority_groups, initial_pg_nr;
-	char * p, * f;
+	char * p;
 	const char *const end = params + len;
 	char no_path_retry[] = "queue_if_no_path";
 	char retain_hwhandler[] = "retain_attached_hw_handler";
@@ -86,9 +86,12 @@ assemble_map (struct multipath * mp, char * params, int len)
 	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0))
 		add_feature(&mp->features, retain_hwhandler);

-	f = STRDUP(mp->features);
+	if (!mp->features) {
+		condlog(0, "mp->features is still NULL.");
+		goto err;
+	}

-	APPEND(p, end, "%s %s %i %i", f, mp->hwhandler, nr_priority_groups,
+	APPEND(p, end, "%s %s %i %i", mp->features, mp->hwhandler, nr_priority_groups,
 	       initial_pg_nr);

 	vector_foreach_slot (mp->pg, pgp, i) {
@@ -110,12 +113,10 @@ assemble_map (struct multipath * mp, char * params, int len)
 		}
 	}

-	FREE(f);
 	condlog(4, "%s: assembled map [%s]", mp->alias, params);
 	return 0;

 err:
-	FREE(f);
 	return 1;
 }

-- 
