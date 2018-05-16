From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/2] multipath.conf.5: clarify property whitelist
	handling
Date: Wed, 16 May 2018 17:43:27 -0500
Message-ID: <1526510607-21144-2-git-send-email-bmarzins@redhat.com>
References: <1526510607-21144-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1526510607-21144-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index f689795..96d1b66 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1181,10 +1181,9 @@ and
 keywords. For a full description of these keywords please see the \fIdevices\fR
 section description.
 .LP
-The \fIproperty\fR blacklist and whitelist handling is different from the usual
-handling in the sense that the whitelist \fIhas\fR to be set, otherwise the
-device will be blacklisted. In these cases the message \fIblacklisted, udev
-property missing\fR will be displayed.
+The \fIproperty\fR whitelist handling is different from the usual
+handling in the sense that the device \fIhas\fR to have a udev property that
+matches the whitelist, otherwise the device will be blacklisted. In these cases the message \fIblacklisted, udev property missing\fR will be displayed.
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.7.4
