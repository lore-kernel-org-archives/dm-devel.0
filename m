From: lixiaokeng <lixiaokeng@huawei.com>
Subject: [dm-level] upstream-queue-libmultipath: fix memory leak
 when iscsi login/out and "multipath -r" executed
Date: Sat, 25 Jul 2020 13:47:01 +0800
Message-ID: <1694e42f-92e7-e380-bc8c-ac3ec47cafdc@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: linfeilong@huawei.com, dm-devel@redhat.com, liuzhiqiang26@huawei.com, lutianxiong@huawei.com
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

Here, we delete checking is_deamon. Because whether the process is a
daemon process or not, we think the path should be add to gvecs->pathvec.

Reported-by: Tianxiong Li <lutianxiong@huawei.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>

---
 libmultipath/dmparser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index b856a07f..d556f642 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -315,7 +315,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 						WWID_SIZE);
 				}
 				/* Only call this in multipath client mode */
-				if (!is_daemon && store_path(pathvec, pp))
+				if (store_path(pathvec, pp))
 					goto out1;
 			} else {
 				if (!strlen(pp->wwid) &&
--
