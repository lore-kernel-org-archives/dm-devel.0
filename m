From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/5] ALUA prioritizer: Remove an unused variable
Date: Fri, 18 Jul 2014 14:52:42 +0200
Message-ID: <53C9189A.3070204@acm.org>
References: <53C91871.9070402@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53C91871.9070402@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com
Cc: device-mapper development <dm-devel@redhat.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 libmultipath/prioritizers/alua.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index b967ec7..39ed1c8 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -55,7 +55,6 @@ get_alua_info(int fd)
 {
 	int	rc;
 	int	tpg;
-	int	aas;
 
 	rc = get_target_port_group_support(fd);
 	if (rc < 0)
@@ -72,7 +71,6 @@ get_alua_info(int fd)
 	rc = get_asymmetric_access_state(fd, tpg);
 	if (rc < 0)
 		return -ALUA_PRIO_GETAAS_FAILED;
-	aas = (rc & 0x0f);
 
 	condlog(3, "aas = %02x [%s]%s", rc, aas_print_string(rc),
 		(rc & 0x80) ? " [preferred]" : "");
-- 
1.8.4.5
