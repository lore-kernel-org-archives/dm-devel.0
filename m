From: Guido Guenther <agx@sigxcpu.org>
Subject: [multipath 1/1] EMC Clariion path checker: change scsi
	read buffer size to 4096 bytes
Date: Mon, 30 Jul 2007 18:04:11 +0200
Message-ID: <20070730160411.GA15413@bogon.ms20.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

648833108fc5a95cbe15bd779289e98165c34d25 changed the scsi read buffer to 4096
bytes but forgot the emc patch checker. This fixes an immediate segfault on
startup.

Signed-off-by: Guido Guenther <agx@bogon.sigxcpu.org>
---
 libcheckers/emc_clariion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libcheckers/emc_clariion.c b/libcheckers/emc_clariion.c
index d801b42..6c7167e 100644
--- a/libcheckers/emc_clariion.c
+++ b/libcheckers/emc_clariion.c
@@ -176,7 +176,7 @@ int emc_clariion(struct checker * c)
 	 * Issue read on active path to determine if inactive snapshot.
 	 */
 	if (sense_buffer[4] == 2) {/* if active path */
-		unsigned char buf[512];
+		unsigned char buf[4096];
 
 		ret = sg_read(c->fd, &buf[0], sbb = &sb[0]);
 		if (ret == PATH_DOWN) {
-- 
1.5.2.4
