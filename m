From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 3/3] dm-mpath: add service-time oriented
 dynamic load balancer
Date: Fri, 15 May 2009 12:09:21 +0900
Message-ID: <4A0CDCE1.50409@ct.jp.nec.com>
References: <49F1729A.1000906@ct.jp.nec.com> <49F17362.7080205@ct.jp.nec.com>
	<20090509004959.GJ1320@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060203020507080700050706"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090509004959.GJ1320@agk-dp.fab.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------060203020507080700050706
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Alasdair,

Thank you for the review and comments.
I'm totally agree with your comments.

I found that you have already updated the patch in your editing tree, thanks.
But I'm considering to update the patch to be simpler.
Please see below.

On 05/09/2009 09:49 AM +0900, Alasdair G Kergon wrote:
> On Fri, Apr 24, 2009 at 05:08:02PM +0900, Kiyoshi Ueda wrote:
>> +	struct selector *s = (struct selector *) ps->context;
>> +		     status_type_t type, char *result, unsigned int maxlen)
>> +	int sz = 0;
>> +			DMEMIT("%u %lu ", atomic_read(&pi->in_flight_size),
> 
> (similar comments)
 
OK, you have already fixed the pointer cast, the sz type and
the print format for in_flight_size.
I'll fix the type of maxlen.


>> +/*
>> + * Returns:
>> + * < 0 : pi1 is better
>> + * 0   : no difference between pi1 and pi2
>> + * > 0 : pi2 is better
>> + */
> 
> Please document the parameters and algorithm.
> Nothing explains what the performance value is for and examples of anticipated values.

OK, I'll add comments and documentation like the attached patch.
 

>> +			DMEMIT("%u %lu ", pi->repeat_count, pi->perf);
> 
> Need to handle both 32 and 64 bit archs: cast to llu.
>
>> +	if ((argc == 2) && (sscanf(argv[1], "%lu", &perf) != 1)) {
> 
> Please do sscanf for size_t the same way as dm-crypt does.
> (Or scan for lu, if the intent is to impose a size limit ahead of the later
> do_div() then cast explicitly.)
>
>> +	do_div(sz1, pi1->perf);
>> +	do_div(sz2, pi2->perf);
> 
> Or sector_div ?
>
> But what's the performance of those divisions like?
> Is there a better way of getting the same answer?
> Is there validation limiting the size of 'perf'?

I tried to use multiplication before, but it didn't work well,
because overflow happened when 'in_flight_size' and 'perf' had
pretty big values, and then I got wrong comparison results.
So I decided to use division.

However, if I limit the 'perf' value in smaller range (e.g. 0 to 100),
such overflow shouldn't happen.  So I should be able to use
multiplication.  Also, I don't need to use size_t for 'perf',
because 'unsinged' should be enough for such small values.

 
> (Also, did you check there's adequate locking & memory barriers around all the
> atomics?)

Yes, I did and I found no problem in both dm-queue-length and
dm-service-time.

Thanks,
Kiyoshi Ueda

--------------060203020507080700050706
Content-Type: text/plain;
 name="rqdm-dlb-04-service-time-dlb-document.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="rqdm-dlb-04-service-time-dlb-document.patch"

Add documents/comments for dm-service-time.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 Documentation/device-mapper/dm-service-time.txt |   87 ++++++++++++++++++++++++
 drivers/md/dm-service-time.c                    |   26 +++++--
 2 files changed, 107 insertions(+), 6 deletions(-)

Index: 2.6.30-rc5/Documentation/device-mapper/dm-service-time.txt
===================================================================
--- /dev/null
+++ 2.6.30-rc5/Documentation/device-mapper/dm-service-time.txt
@@ -0,0 +1,87 @@
+dm-service-time
+===============
+
+dm-service-time is a path selector module for device-mapper targets,
+which selects a path with the shortest estimated service time for
+the incoming I/O.
+
+The service time for each path is estimated by dividing the total size
+of in-flight I/Os on a path with the performance value of the path.
+The performance value is a relative throughput value among all paths
+in a path-group, and it can be specified as a table argument.
+
+The path selector name is 'service-time'.
+
+Table parameters for each path: [<repeat_count> [<performance>]]
+	<repeat_count>: The number of I/Os to dispatch using the selected
+			path before switching to the next path.
+			If not given, internal default is used.  To check
+			the default value, see the activated table.
+	<performance>: The relative throughput value of the path
+		       among all paths in the path-group.
+		       If not given, minimum value '1' is used.
+		       If '0' is given, the path isn't selected while
+		       other paths having a positive value are available.
+
+Status for each path: <status> <fail-count> <in-flight-size> <performance>
+	<status>: 'A' if the path is active, 'F' if the path is failed.
+	<fail-count>: The number of path failures.
+	<in-flight-size>: The size of in-flight I/Os on the path.
+	<performance>: The relative throughput value of the path
+		       among all paths in the path-group.
+
+
+Algorithm
+=========
+
+dm-service-time adds the I/O size to 'in-flight-size' when the I/O is
+dispatched and substracts when completed.
+Basically, dm-service-time selects a path having minimum service time
+which is calculated by:
+
+	('in-flight-size' + 'size-of-incoming-io') / 'performance'
+
+However, some optimizations below are used to reduce the calculation
+as much as possible.
+
+	1. If the paths have the same 'performance', skip the division
+	   and just compare the 'in-flight-size'.
+
+	2. If the paths have the same 'in-flight-size', skip the division
+	   and just compare the 'performance'.
+
+	3. If some paths have non-zero 'performance' and others have zero
+	   'performance', ignore those paths with zero 'performance'.
+
+If such optimizations can't be applied, calculate service time, and
+compare service time.
+If calculated service time is equal, the path having maximum 'performance'
+may be better.  So compare 'performance' then.
+
+
+Examples
+========
+In case that 2 paths (sda and sdb) are used with repeat_count == 128
+and sda has an average throughput 1GB/s and sdb has 4GB/s, 'performance'
+value may be '1' for sda and '4' for sdb.
+
+# echo "0 10 multipath 0 0 1 1 service-time 0 2 2 8:0 128 1 8:16 128 4" \
+  dmsetup create test
+#
+# dmsetup table
+test: 0 10 multipath 0 0 1 1 service-time 0 2 2 8:0 128 1 8:16 128 4
+#
+# dmsetup status
+test: 0 10 multipath 2 0 0 0 1 1 E 0 2 2 8:0 A 0 0 1 8:16 A 0 0 4
+
+
+Or '2' for sda and '8' for sdb would be also true.
+
+# echo "0 10 multipath 0 0 1 1 service-time 0 2 2 8:0 128 2 8:16 128 8" \
+  dmsetup create test
+#
+# dmsetup table
+test: 0 10 multipath 0 0 1 1 service-time 0 2 2 8:0 128 2 8:16 128 8
+#
+# dmsetup status
+test: 0 10 multipath 2 0 0 0 1 1 E 0 2 2 8:0 A 0 0 2 8:16 A 0 0 8
Index: 2.6.30-rc5/drivers/md/dm-service-time.c
===================================================================
--- 2.6.30-rc5.orig/drivers/md/dm-service-time.c
+++ 2.6.30-rc5/drivers/md/dm-service-time.c
@@ -105,22 +105,27 @@ static int st_add_path(struct path_selec
 	unsigned repeat_count = ST_MIN_IO;
 	unsigned long long tmpll = 1;
 
+	/*
+	 * Arguments: [<repeat_count> [<performance>]]
+	 * 	<repeat_count>: The number of I/Os before switching path.
+	 * 			If not given, default (ST_MIN_IO) is used.
+	 * 	<performance>: The relative throughput value of the path
+	 *		       among all paths in the path-group.
+	 *		       If not given, minimum value '1' is used.
+	 *		       If '0' is given, the path isn't selected while
+	 * 		       other paths having a positive value are
+	 * 		       available.
+	 */
 	if (argc > 2) {
 		*error = "service-time ps: incorrect number of arguments";
 		return -EINVAL;
 	}
 
-	/* First path argument is number of I/Os before switching path. */
 	if ((argc > 0) && (sscanf(argv[0], "%u", &repeat_count) != 1)) {
 		*error = "service-time ps: invalid repeat count";
 		return -EINVAL;
 	}
 
-	/*
-	 * Second path argument is a relative performance value.
-	 * If 0 is given, the path isn't used while other paths having
-	 * a positive value are available.
-	 */
 	if ((argc == 2) && (sscanf(argv[1], "%llu", &tmpll) != 1)) {
 		*error = "service-time ps: invalid performance value";
 		return -EINVAL;
@@ -164,10 +169,19 @@ static int st_reinstate_path(struct path
 }
 
 /*
+ * Compare the estimated service time of 2 paths, pi1 and pi2,
+ * for the incoming I/O.
+ *
  * Returns:
  * < 0 : pi1 is better
  * 0   : no difference between pi1 and pi2
  * > 0 : pi2 is better
+ *
+ * Description:
+ * Basically, the service time is estimated by:
+ *     ('pi->in-flight-size' + 'incoming') / 'pi->perf'
+ * To reduce the calculation, some optimizations are made.
+ * (See comments inline)
  */
 static int st_compare_load(struct path_info *pi1, struct path_info *pi2,
 			   size_t incoming)

--------------060203020507080700050706
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------060203020507080700050706--
