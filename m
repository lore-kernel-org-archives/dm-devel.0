From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] dm-multipath: fix multipath description with
	system-config-services
Date: Mon, 30 Apr 2007 13:23:10 -0500
Message-ID: <20070430182309.GB7089@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="eAbsdosE1cNLO4uF"
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
List-Id: dm-devel.ids


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The multipath description doesn't correctly appear in system-config-services on
redhat machines, due to a blank line in /etc/init.d/multipath.d. This patch
from bz #237429 removes the line.

-Ben

--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="multipath_s-c-s_description.patch"

diff -urpN a/multipathd/multipathd.init.redhat b/multipathd/multipathd.init.redhat
--- a/multipathd/multipathd.init.redhat	2006-02-02 19:54:57.000000000 -0600
+++ b/multipathd/multipathd.init.redhat	2007-04-30 13:15:13.000000000 -0500
@@ -1,5 +1,4 @@
 #!/bin/bash
-
 #
 #	/etc/rc.d/init.d/multipathd
 #

--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--eAbsdosE1cNLO4uF--
