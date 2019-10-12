From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 40/72] libmpathpersist: fix copy-paste error in
 mpath_format_readresv()
Date: Sat, 12 Oct 2019 21:28:27 +0000
Message-ID: <20191012212703.12989-41-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

This would swap bytes for the wrong field.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_pr_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 209892f6..05b30b56 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -188,8 +188,8 @@ static void mpath_format_readkeys(struct prin_resp *pr_buff)
 static void mpath_format_readresv(struct prin_resp *pr_buff)
 {
 
-	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readkeys.prgeneration);
-	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readkeys.additional_length);
+	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readresv.prgeneration);
+	convert_be32_to_cpu(&pr_buff->prin_descriptor.prin_readresv.additional_length);
 
 	return;
 }
-- 
2.23.0
