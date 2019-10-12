From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 25/72] libmultipath: get_ana_info(): remove
	unused parameter
Date: Sat, 12 Oct 2019 21:28:08 +0000
Message-ID: <20191012212703.12989-26-martin.wilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/ana.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/prioritizers/ana.c b/libmultipath/prioritizers/ana.c
index 2673d9d9..bcb1dbf8 100644
--- a/libmultipath/prioritizers/ana.c
+++ b/libmultipath/prioritizers/ana.c
@@ -106,7 +106,7 @@ static int get_ana_state(__u32 nsid, __u32 anagrpid, void *ana_log,
 	return -ANA_ERR_GETANAS_NOTFOUND;
 }
 
-int get_ana_info(struct path * pp, unsigned int timeout)
+static int get_ana_info(struct path * pp)
 {
 	int	rc;
 	__u32 nsid;
@@ -209,7 +209,7 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
 	if (pp->fd < 0)
 		rc = -ANA_ERR_NO_INFORMATION;
 	else
-		rc = get_ana_info(pp, timeout);
+		rc = get_ana_info(pp);
 
 	switch (rc) {
 	case NVME_ANA_OPTIMIZED:
-- 
2.23.0
