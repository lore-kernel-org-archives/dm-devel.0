From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] multipath-tools: fix a porting bug for random
	libprio
Date: Thu, 20 Dec 2007 13:13:50 -0500 (EST)
Message-ID: <20071220.131350.71084304.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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

Hi Christophe,

The random prioritizer were not converted to the new scheme.
It should return the priority instead of print it.

--- git-20071214/libprio/random.c	2007-12-14 15:48:28.000000000 -0500
+++ random-prio-fix/libprio/random.c	2007-12-19 18:05:50.000000000 -0500
@@ -7,10 +7,11 @@
 
 int prio_random(struct path * pp)
 {
+	int ret;
 	struct timeval tv;
 	
 	gettimeofday(&tv, NULL);
 	srand((unsigned int)tv.tv_usec);
-	printf("%i\n", 1+(int) (10.0*rand()/(RAND_MAX+1.0)));
-	return 0;
+	ret = 1 + (int)(10.0 * rand() / (RAND_MAX + 1.0));
+	return ret;
 }

Thanks,
Kiyoshi Ueda
