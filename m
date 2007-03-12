From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] dmsetup: detect write failure
Date: Mon, 12 Mar 2007 15:25:10 +0100
Message-ID: <87abyipmih.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Since "fd" may be open on a writable file handle, it's
important to test for close failure.  Otherwise, the code
could fail to detect a write error.

2007-03-11  Jim Meyering  <meyering@redhat.com>

	* dmsetup/dmsetup.c (_loop_table): Detect close failure.

Index: dmsetup/dmsetup.c
===================================================================
RCS file: /cvs/dm/device-mapper/dmsetup/dmsetup.c,v
retrieving revision 1.87
diff -u -p -r1.87 dmsetup.c
--- dmsetup/dmsetup.c	14 Feb 2007 15:12:16 -0000	1.87
+++ dmsetup/dmsetup.c	12 Mar 2007 14:16:47 -0000
@@ -1920,7 +1920,10 @@ static int _loop_table(char *table, size
 	blksize = fsbuf.f_frsize;
 #endif

-	close(fd);
+	if (close(fd)) {
+		fd = -1;
+		goto error;
+	}

 	if (dm_snprintf(table, tlen, "%llu %llu loop %s %llu\n", 0ULL,
 			(long long unsigned)sectors, file, off) < 0)
