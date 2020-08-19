From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [PATCH 5/5] libmultipath fix daemon memory leak in
	disassemble_map
Date: Wed, 19 Aug 2020 09:50:27 +0800
Message-ID: <e15fee1e-145b-2880-c84a-aba7b1496555@huawei.com>
References: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5ef5f58e-3a27-8959-3abb-4b4c401cc309@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: linfeilong@huawei.com, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids

When one iscsi device logs in and logs out with the "multipath -r"
executed at the same time, memory leak happens in multipathd
process.

The reason is following. When "multipath -r" is executed, the path
will be free in configure function. Before path_discovery executed,
iscsi device logs out. Then path_discovery will not find any path and
there is no path in the gvecs->pathvec. When map_discovery function
is executed, disassemble_map function will be called. Because
gvecs->pathvec->slot is empty and is_deamon is 1, a path will be
allocated and is not stored in gvecs->pathvec but store in
mpp->pg. But when the mpp is removed and freed by remove_map
function, the path will not be free and can't be find anymore.

The procedure details given as follows,
1."multipath -r" is executed
main
	->child
		->reconfigure
			->configure
				->path_discovery //after iscsi logout
				->map_discovery
					->update_multipath_table
						->disassemble_map
							->alloc_path
2.then "multipath -r" is executed again
main
main
	->child
		->reconfigure
			->remove_maps_and_stop_waiters
				->remove_maps

If checking is_deamon is deleted, there are many other things need be done like in
https://www.redhat.com/archives/dm-devel/2020-July/msg00245.html. And this
branch develops from 0.8.3 but upstream_queue is mainline which develops from
0.8.4.
Here, we skip alloc_path if pp isn't find in pathvec and process is daemon.  In
daemon, we should not store path with incomplete information to pathvec.  The
pathvec stores all paths in daemon, so it is reasonable keep same with pathvec.

Reported-by: Tianxiong Li <lutianxiong@huawei.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 libmultipath/dmparser.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index f02c551..0f370e9 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -314,6 +314,16 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 			}

 			if (!pp) {
+				/* daemon should keep same with pathvec */
+				/* pp is not find in pathvec, skip it */
+				if (is_daemon) {
+					FREE(word);
+					for (k = 0; k < num_paths_args; k++) {
+						p += get_word(p, NULL);
+					}
+					continue;
+				}
+
 				pp_unfound = 1;
 				pp = alloc_path();

@@ -326,8 +336,8 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 					strncpy(pp->wwid, mpp->wwid,
 						WWID_SIZE - 1);
 				}
-				/* Only call this in multipath client mode */
-				if (!is_daemon && store_path(pathvec, pp)) {
+
+				if (store_path(pathvec, pp)) {
 					free_path(pp);
 					goto out1;
 				}
--
