From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 10/16] multipathd.8: document that '-n' is
	now ignored
Date: Fri, 19 Jan 2018 01:29:10 +0100
Message-ID: <20180119002916.10323-11-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

---
 multipathd/multipathd.8 | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 5c96680c0514..ccf23606c0ff 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -25,7 +25,6 @@ multipathd \- Multipath daemon.
 .RB [\| \-v\ \c
 .IR verbosity \|]
 .RB [\| \-B \|]
-.RB [\| \-n \|]
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -73,8 +72,8 @@ be viewed by entering '\fIhelp\fR'. When you are finished entering commands, pre
 .
 .TP
 .B \-n
-Ignore new devices. multipathd will not create a multipath device unless the
-WWID for the device is already listed in the WWIDs file.
+\fBDEPRECATED\fR. This parameter is ignored. Use the config file parameter
+\fB"ignore_wwids = no"\fR to obtain the effect this option used to have.
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.15.1
