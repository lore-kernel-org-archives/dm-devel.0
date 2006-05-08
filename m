From: Kevin Corry <kevcorry@us.ibm.com>
Subject: [PATCH] dmsetup: Remove limitation on table file line
	length
Date: Mon, 8 May 2006 13:59:32 -0500
Message-ID: <200605081359.32562.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: DevMapper <dm-devel@redhat.com>
List-Id: dm-devel.ids

Greetings,

The dmsetup tool currently has a limit of 1024 characters for the length of a 
line in a table file when running the 'create' or 'load' command. When have 
run into scenarios where we've exceeded this length, usually due to creating 
large striped devices with unusually long names for the underlying disks.

To get around this limitation, I wrote a patch that simply changes from using 
fgets() to getline() in the _parse_file() routine. The getline() routine will 
automatically allocate (or reallocate) space as needed to read in an entire 
line from a file.

I have tested this patch successfully with table lines of at least 1300 
characters.

Thanks,
-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/


Use getline() instead of fgets() to remove the line-size limitation when
parsing the input file in dmsetup. 

Signed-Off-By: Kevin Corry <kevcorry@us.ibm.com>

Index: device-mapper.1.02.05/dmsetup/dmsetup.c
===================================================================
--- device-mapper.1.02.05.orig/dmsetup/dmsetup.c
+++ device-mapper.1.02.05/dmsetup/dmsetup.c
@@ -117,7 +117,8 @@ static struct dm_tree *_dtree;
  */
 static int _parse_file(struct dm_task *dmt, const char *file)
 {
-	char buffer[LINE_SIZE], ttype[LINE_SIZE], *ptr, *comment;
+	char *buffer = NULL, ttype[LINE_SIZE], *ptr, *comment;
+	size_t buffer_size = 0;
 	FILE *fp;
 	unsigned long long start, size;
 	int r = 0, n, line = 0;
@@ -132,7 +133,7 @@ static int _parse_file(struct dm_task *d
 	} else
 		fp = stdin;
 
-	while (fgets(buffer, sizeof(buffer), fp)) {
+	while (getline(&buffer, &buffer_size, fp) > 0) {
 		line++;
 
 		/* trim trailing space */
@@ -166,6 +167,7 @@ static int _parse_file(struct dm_task *d
       out:
 	if (file)
 		fclose(fp);
+	free(buffer);
 	return r;
 }
 
