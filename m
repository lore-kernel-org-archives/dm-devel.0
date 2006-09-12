From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Re: lvresize fails with "reload ioctl failed: Invalid
	argument"
Date: Mon, 11 Sep 2006 20:19:14 -0400
Message-ID: <4505FD02.10309@ce.jp.nec.com>
References: <ee20kk$s7u$1@sea.gmane.org>	<20060910221427.GF13859@agk.surrey.redhat.com>	<20060911141916.GC13522@percy.comedia.it>	<450592C5.50905@free.fr>
	<20060911170527.GE13522@percy.comedia.it>
	<4505C3BB.1050000@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010806080001090906040800"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4505C3BB.1050000@free.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010806080001090906040800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Laurent,

Laurent Riffard wrote:
>>>>>>  device-mapper: reload ioctl failed: Invalid argument
...
>> works for me with 2.6.17-4mdv kernel
>> maybe something related to your kernel version?
> 
> Yes, you seem to be right: it does work with 2.6.17-2mdv or 2.6.17-4mdv, 
> but it fails with 2.6.18-rc6-mm1.

I reproduced the problem on my host, too.
I found a change in -mm which would cause this problem
and attached patch fixed it.

I'll post it to linux-kernel as well.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------010806080001090906040800
Content-Type: text/x-patch;
 name="correct-add_bd_holder-return-value.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="correct-add_bd_holder-return-value.patch"

If a matching bd_holder is found in bd_holder_list,
add_bd_holder() completes its job by just incrementing the reference count.
In this case, it should be considered as success but it used to return 'fail'
to let the caller free bd_holder.
Fixed it to return success and free given object by itself.

Also, if either one of symlinking fails, the bd_holder should not
be added to the list so that it can be discarded later.
Otherwise, the caller will free bd_holder which is in the list.

This patch is neccessary only for -mm (later than 2.6.18-rc1-mm1).

 fs/block_dev.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -urp linux-2.6.18-rc5-mm1.orig/fs/block_dev.c linux-2.6.18-rc5-mm1/fs/block_dev.c
--- linux-2.6.18-rc5-mm1.orig/fs/block_dev.c	2006-09-11 19:33:35.000000000 -0400
+++ linux-2.6.18-rc5-mm1/fs/block_dev.c	2006-09-11 19:21:46.000000000 -0400
@@ -655,8 +655,8 @@ static void free_bd_holder(struct bd_hol
  * If there is no matching entry with @bo in @bdev->bd_holder_list,
  * add @bo to the list, create symlinks.
  *
- * Returns 0 if @bo was added to the list.
- * Returns -ve if @bo wasn't used by any reason and should be freed.
+ * Returns 0 if symlinks are created or already there.
+ * Returns -ve if something fails and @bo can be freed.
  */
 static int add_bd_holder(struct block_device *bdev, struct bd_holder *bo)
 {
@@ -669,7 +669,9 @@ static int add_bd_holder(struct block_de
 	list_for_each_entry(tmp, &bdev->bd_holder_list, list) {
 		if (tmp->sdir == bo->sdir) {
 			tmp->count++;
-			return -EEXIST;
+			/* We've already done what we need to do here. */
+			free_bd_holder(bo);
+			return 0;
 		}
 	}
 
@@ -682,7 +684,8 @@ static int add_bd_holder(struct block_de
 		if (ret)
 			del_symlink(bo->sdir, bo->sdev);
 	}
-	list_add_tail(&bo->list, &bdev->bd_holder_list);
+	if (ret == 0)
+		list_add_tail(&bo->list, &bdev->bd_holder_list);
 	return ret;
 }

--------------010806080001090906040800
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010806080001090906040800--
