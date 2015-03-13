From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 3/3] Add find_multipaths to multipath.conf man
	page
Date: Fri, 13 Mar 2015 13:27:27 -0500
Message-ID: <1426271247-21345-4-git-send-email-bmarzins@redhat.com>
References: <1426271247-21345-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426271247-21345-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

find_multipaths wasn't listed in the multipath.conf man page. Add it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 3fe56bc..d60dc2e 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -91,6 +91,28 @@ directory where the dynamic shared objects are stored; default is system
 dependent, commonly
 .I /lib/multipath
 .TP
+.B find_multipaths
+If set to
+.I yes
+, instead of trying to create a multipath device for every non-blacklisted
+path, multipath will only create a device if one of three condidions are
+met.
+.I 1
+There are at least two non-blacklisted paths with the same wwid,
+.I 2
+the user manually forces the creation, by specifying a device with the multipath
+command, or
+.I 3
+a path has the same WWID as a multipath device that was previously created
+while find_multipaths was set (even if that multipath device doesn't currently
+exist).
+Whenever a multipath device is created with find_multipaths set, multipath will
+remeber the WWID of the device, so that it will automatically create the
+device again, as soon as it sees a path with that WWID. This should allow most
+users to have multipath automatically choose the correct paths to make into
+multipath devices, without having to edit the blacklist; Default is
+.I no
+.TP
 .B verbosity
 default verbosity. Higher values increase the verbosity level. Valid
 levels are between 0 and 6; default is
-- 
1.8.3.1
