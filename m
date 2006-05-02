From: Tom Kalus <tkalus@us.xyratex.com>
Subject: [PATCH] pp_aula/spc.h
Date: Tue, 02 May 2006 15:32:02 -0700
Message-ID: <4457DDE2.6050607@us.xyratex.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080606070303020300070302"
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

This is a multi-part message in MIME format.
--------------080606070303020300070302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

path_priority/pp_aula/spc.h

Isn't the inquiry_data.product_identifier 16 bytes long? or do I need a 
later draft of SPC3... 21d - Feb 2005
Bug doesn't effect existing code, but it's still a bug.
Rest looks ok, so far as I can tell.

See attached patch.



--------------080606070303020300070302
Content-Type: text/plain;
 name="spc3.h.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="spc3.h.patch"

diff --git a/path_priority/pp_alua/spc3.h b/path_priority/pp_alua/spc3.h
index 11f5dbd..bddbbdd 100644
--- a/path_priority/pp_alua/spc3.h
+++ b/path_priority/pp_alua/spc3.h
@@ -148,10 +148,10 @@ struct inquiry_data {
 					/* ......x. = command queue support  */
 					/* .......x = vs2                    */
 	unsigned char	vendor_identification[8];
-	unsigned char	product_identification[8];
+	unsigned char	product_identification[16];
 	unsigned char	product_revision[4];
 	unsigned char	vendor_specific[20];
-	unsigned char	b48;		/* xxxx.... = reserved               */
+	unsigned char	b56;		/* xxxx.... = reserved               */
 					/* ....xx.. = clocking               */
 					/* ......x. = qas                    */
 					/* .......x = ius                    */

--------------080606070303020300070302
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080606070303020300070302--
