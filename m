From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH]: dm-snap.c fix passing wrong type of argument
Date: Fri, 20 Feb 2009 16:59:41 -0600
Message-ID: <1235170781.24593.4.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Perhaps the ordering could change a little, but from my point of view,
the following patches are prerequisites to this patch:
  1) dm-exception-store-introduce-registry.patch
  2) dm-exception-store-move-dm_target-pointer.patch
  3) dm-exception-store-move-chunk_fields.patch
  4) dm-exception-store-move-cow-pointer.patch
  5) dm-snapshot-remove-dm_snap-header-use.patch
  6) dm-snapshot-remove-dm_snap-header.patch
  7) dm-snapshot-use-DMEMIT-macro-for-status.patch
  8) dm-snapshot-move-ctr-parsing-to-exception-store.patch
  9) dm-snapshot-move-status-to-exception-store.patch
  10) dm-exception-store-generalize-table-args.patch
  11) dm-snapshot-new-ctr-table-format.patch
  12) dm-snapshot-cleanup.patch

 brassow

The 'toupper' function returns an integer, but 'dm_exception_store_create'
takes a (char *).

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -594,6 +594,7 @@ static int create_exception_store(struct
 {
 	unsigned param_count;
 	char *tmp_argv[2];
+	char buf[8];
 
 	*store = NULL;
 
@@ -608,9 +609,10 @@ static int create_exception_store(struct
 		tmp_argv[1] = argv[2];  /* chunk size */
 
 		*args_used = 3;
+		buf[0] = toupper(*argv[1]);
+		buf[1] = '\0';
 
-		return dm_exception_store_create(toupper(*argv[1]), ti, 2,
-						 tmp_argv, store);
+		return dm_exception_store_create(buf, ti, 2, tmp_argv, store);
 	}
 
 	if (sscanf(argv[1], "%u", &param_count) != 1) {
