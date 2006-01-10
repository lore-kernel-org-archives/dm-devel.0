From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] hwtable.c segfault
Date: Tue, 10 Jan 2006 13:09:37 -0800
Message-ID: <1136927377.23077.6.camel@markh3.pdx.osdl.net>
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
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Christophe,

I built the latest git tree of the multipath tools and had a segfault
starting multipath.  I think that the increment of the hwe pointer is
wrong.  Here is a patch.

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a39520e..71728de 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -462,7 +462,7 @@ setup_default_hwtable (vector hw)
 
 	while (hwe->vendor) {
 		r += store_hwe(hw, hwe);
-		hwe += sizeof(struct hwentry);
+		hwe++;
 	}
 	return r;
 }

-- 
Mark Haverkamp <markh@osdl.org>
