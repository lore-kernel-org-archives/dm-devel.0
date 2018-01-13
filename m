From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 12/20] multipathd.socket: add
	WantedBy=sockets.target
Date: Sat, 13 Jan 2018 22:19:30 +0100
Message-ID: <20180113211938.31552-13-mwilck@suse.com>
References: <20180113211938.31552-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180113211938.31552-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Without this, "systemctl enable multipathd.service" spits out
an error message.
---
 multipathd/multipathd.socket | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/multipathd/multipathd.socket b/multipathd/multipathd.socket
index 921706d5d333..0ed4a1f7958b 100644
--- a/multipathd/multipathd.socket
+++ b/multipathd/multipathd.socket
@@ -5,3 +5,6 @@ Before=sockets.target
 
 [Socket]
 ListenStream=@/org/kernel/linux/storage/multipathd
+
+[Install]
+WantedBy=sockets.target
-- 
2.15.1
