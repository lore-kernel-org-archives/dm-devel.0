From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: dm-log.c-2.4.26-rc1.patch
Date: Thu, 2 Feb 2006 21:39:12 +0100
Message-ID: <20060202203912.GD23661@redhat.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
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
To: dm-devel@redhat.com
Cc: hjm@redhat.com
List-Id: dm-devel.ids


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


dm-log.c constructor doesn't pay attention to the NOSYNC flag while
initializing the lc->sync_bits bitset.

Regards,
Heinz    -- The LVM Guy --

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dm-log.c.2.4.26-rc1.patch"

--- linux-2.4.32/drivers/md/dm-log.c.2.4.26-rc1	2006-02-02 21:35:48.000000000 +0100
+++ linux-2.4.32/drivers/md/dm-log.c	2006-02-02 21:36:25.000000000 +0100
@@ -220,7 +220,7 @@
 		kfree(clog);
 		return -ENOMEM;
 	}
-	memset(clog->sync_bits, 0, bitset_size);
+	memset(lc->sync_bits, (sync == NOSYNC) ? -1 : 0, bitset_size);
 	clog->sync_count = (sync == NOSYNC ) ? region_count : 0;
 
 	clog->recovering_bits = vmalloc(bitset_size);

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--UugvWAfsgieZRqgk--
