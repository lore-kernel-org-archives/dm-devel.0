From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 2/3] dm-mpath: add queue-length oriented
 dynamic load balancer
Date: Thu, 14 May 2009 15:14:15 +0900
Message-ID: <4A0BB6B7.9020503@ct.jp.nec.com>
References: <49F1729A.1000906@ct.jp.nec.com> <49F1733E.70006@ct.jp.nec.com>
	<20090509003136.GI1320@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000803050400060401000202"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090509003136.GI1320@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, stefan.bader@canonical.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000803050400060401000202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Alasdair,

Thank you for the review and comments.
I'm totally agree with your comments.

I found that you have already updated the patch in your editing tree, thanks.
I attached patches for remaining parts of your comments.

Please review and apply.


On 05/09/2009 09:31 AM +0900, Alasdair G Kergon wrote:
> On Fri, Apr 24, 2009 at 05:07:26PM +0900, Kiyoshi Ueda wrote:
>> +	unsigned int		repeat_count;
> 
> Just 'unsigned repeat_count'

OK. (You have already fixed this.)
 

>> +	struct selector *s = (struct selector *) ps->context;
> 
> Drop the cast when it's from void.
> 
> 	struct selector *s = ps->context;

OK. (You have already fixed this.)

 
>> +static int ql_status(struct path_selector *ps, struct dm_path *path,
>> +		     status_type_t type, char *result, unsigned int maxlen)
> 
> unsigned maxlen

OK, fixed in rqdm-dlb-02-queue-length-dlb-type-fixes.patch


> (We're doing things like this in all new patches, but only changing existing
> code when it's touched for some other reason.)

OK, I followed the style of dm-round-robin and I understand your
preference now.
I'll also check the request-based dm patch-set, too, when I update
and repost it.


>> +	int sz = 0;
> 
> signed or unsigned sz?
> (It's already used inconsistently, I know - but is unsigned better here?)

Yes, I think unsigned is better. (You have already fixed this.)

 
>> +		case STATUSTYPE_INFO:
>> +			DMEMIT("%u ", atomic_read(&pi->qlen));
> 
> Signed or unsigned?

qlen should be always >= 0, but atomic_t is defined as signed.
So I use signed here.
Fixed in rqdm-dlb-02-queue-length-dlb-type-fixes.patch


>> +	/* Parse the arguments */
> 
> Please document parameters and selection algorithm in Documentation dir and
> maybe in inline comments too - it's not immediately obvious exactly how it
> behaves.
> 
>> +static struct dm_path *ql_select_path(struct path_selector *ps,
>> +				      unsigned *repeat_count, size_t nr_bytes)

OK, added comments/documentaion in
rqdm-dlb-02-queue-length-dlb-document.patch.

Thanks,
Kiyoshi Ueda

--------------000803050400060401000202
Content-Type: text/plain; name="rqdm-dlb-02-queue-length-dlb-type-fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="rqdm-dlb-02-queue-length-dlb-type-fixes.patch"

o Use 'unsigned' instead of 'unsigned int' for maxlen in dm-queue-length.

o Fix the print format to use %d for qlen in dm-queue-length, since
  atomic_t is defined as 'int', not 'unsigned int'.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-queue-length.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.30-rc5/drivers/md/dm-queue-length.c
===================================================================
--- 2.6.30-rc5.orig/drivers/md/dm-queue-length.c
+++ 2.6.30-rc5/drivers/md/dm-queue-length.c
@@ -82,7 +82,7 @@ static void ql_destroy(struct path_selec
 }
 
 static int ql_status(struct path_selector *ps, struct dm_path *path,
-		     status_type_t type, char *result, unsigned int maxlen)
+		     status_type_t type, char *result, unsigned maxlen)
 {
 	unsigned sz = 0;
 	struct path_info *pi;
@@ -95,7 +95,7 @@ static int ql_status(struct path_selecto
 
 		switch (type) {
 		case STATUSTYPE_INFO:
-			DMEMIT("%u ", atomic_read(&pi->qlen));
+			DMEMIT("%d ", atomic_read(&pi->qlen));
 			break;
 		case STATUSTYPE_TABLE:
 			DMEMIT("%u ", pi->repeat_count);

--------------000803050400060401000202
Content-Type: text/plain;
 name="rqdm-dlb-02-queue-length-dlb-document.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="rqdm-dlb-02-queue-length-dlb-document.patch"

Add documents/comments for dm-queue-length.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 Documentation/device-mapper/dm-queue-length.txt |   39 ++++++++++++++++++++++++
 drivers/md/dm-queue-length.c                    |   12 +++++--
 2 files changed, 48 insertions(+), 3 deletions(-)

Index: 2.6.30-rc5/Documentation/device-mapper/dm-queue-length.txt
===================================================================
--- /dev/null
+++ 2.6.30-rc5/Documentation/device-mapper/dm-queue-length.txt
@@ -0,0 +1,39 @@
+dm-queue-length
+===============
+
+dm-queue-length is a path selector module for device-mapper targets,
+which selects a path having the least number of in-flight I/Os.
+The path selector name is 'queue-length'.
+
+Table parameters for each path: [<repeat_count>]
+	<repeat_count>: The number of I/Os to dispatch using the selected
+			path before switching to the next path.
+			If not given, internal default is used. To check
+			the default value, see the activated table.
+
+Status for each path: <status> <fail-count> <in-flight>
+	<status>: 'A' if the path is active, 'F' if the path is failed.
+	<fail-count>: The number of path failures.
+	<in-flight>: The number of in-flight I/Os on the path.
+
+
+Algorithm
+=========
+
+dm-queue-length increments/decrements 'in-flight' when an I/O is
+dispatched/completed respectively.
+dm-queue-length selects a path having minimum 'in-flight'.
+
+
+Examples
+========
+In case that 2 paths (sda and sdb) are used with repeat_count == 128.
+
+# echo "0 10 multipath 0 0 1 1 queue-length 0 2 1 8:0 128 8:16 128" \
+  dmsetup create test
+#
+# dmsetup table
+test: 0 10 multipath 0 0 1 1 queue-length 0 2 1 8:0 128 8:16 128
+#
+# dmsetup status
+test: 0 10 multipath 2 0 0 0 1 1 E 0 2 1 8:0 A 0 0 8:16 A 0 0
Index: 2.6.30-rc5/drivers/md/dm-queue-length.c
===================================================================
--- 2.6.30-rc5.orig/drivers/md/dm-queue-length.c
+++ 2.6.30-rc5/drivers/md/dm-queue-length.c
@@ -35,7 +35,7 @@ struct path_info {
 	struct list_head	list;
 	struct dm_path		*path;
 	unsigned		repeat_count;
-	atomic_t		qlen;
+	atomic_t		qlen;	/* the number of in-flight I/Os */
 };
 
 static struct selector *alloc_selector(void)
@@ -113,13 +113,16 @@ static int ql_add_path(struct path_selec
 	struct path_info *pi;
 	unsigned repeat_count = QL_MIN_IO;
 
-	/* Parse the arguments */
+	/*
+	 * Arguments: [<repeat_count>]
+	 * 	<repeat_count>: The number of I/Os before switching path.
+	 * 			If not given, default (QL_MIN_IO) is used.
+	 */
 	if (argc > 1) {
 		*error = "queue-length ps: incorrect number of arguments";
 		return -EINVAL;
 	}
 
-	/* First path argument is number of I/Os before switching path. */
 	if ((argc == 1) && (sscanf(argv[0], "%u", &repeat_count) != 1)) {
 		*error = "queue-length ps: invalid repeat count";
 		return -EINVAL;
@@ -161,6 +164,9 @@ static int ql_reinstate_path(struct path
 	return 0;
 }
 
+/*
+ * Select a path having the minimum number of in-flight I/Os
+ */
 static struct dm_path *ql_select_path(struct path_selector *ps,
 				      unsigned *repeat_count, size_t nr_bytes)
 {

--------------000803050400060401000202
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000803050400060401000202--
