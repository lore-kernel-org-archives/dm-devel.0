From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/2] multipath-tools: add +x to doc-preclean.pl
	and split-man.pl
Date: Sun, 13 May 2018 00:39:41 +0200
Message-ID: <20180512223942.23898-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: DM ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

It is not strictly necessary, but it helps identify bin files.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libdmmp/docs/doc-preclean.pl | 0
 libdmmp/docs/split-man.pl    | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100644 => 100755 libdmmp/docs/doc-preclean.pl
 mode change 100644 => 100755 libdmmp/docs/split-man.pl

diff --git a/libdmmp/docs/doc-preclean.pl b/libdmmp/docs/doc-preclean.pl
old mode 100644
new mode 100755
diff --git a/libdmmp/docs/split-man.pl b/libdmmp/docs/split-man.pl
old mode 100644
new mode 100755
-- 
2.17.0
