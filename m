From: Oren Held <oren@held.org.il>
Subject: [PATCH] Remove prio_callout as a valid option from man
	page
Date: Sun, 21 Aug 2011 13:05:22 +0300
Message-ID: <20110821100522.GA10122@orenhe-laptop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii; format=fixed
Content-Disposition: inline


Signed-off-by: Oren Held <orenhe@il.ibm.com>
---
 multipath/multipath.conf.5 |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)


--0OAP2g/MAC+5xKAE
Content-Type: text/x-patch; charset=us-ascii;
	name="0001-Remove-prio_callout-as-a-valid-option-from-man-page.patch"
Content-Disposition: attachment;
	filename="0001-Remove-prio_callout-as-a-valid-option-from-man-page.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 6e6b021..8419955 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -475,8 +475,6 @@ section:
 .TP
 .B features
 .TP
-.B prio_callout
-.TP
 .B failback
 .TP
 .B rr_weight

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--0OAP2g/MAC+5xKAE--
