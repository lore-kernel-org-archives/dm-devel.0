From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 18/30] libmultipath: fix parsing of SCSI name
	string, iqn format
Date: Fri,  7 Jun 2019 15:05:40 +0200
Message-ID: <20190607130552.13203-19-mwilck@suse.com>
References: <20190607130552.13203-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190607130552.13203-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Do not overwrite the leading '8'.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 10306b22..45c2931e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1037,12 +1037,11 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 				}
 			} else {
 				out[0] = '8';
-				len = 1;
 				vpd += 4;
 				vpd_len -= 4;
 				if (vpd_len > out_len - 2)
 					vpd_len = out_len - 2;
-				memcpy(out, vpd, vpd_len);
+				memcpy(out + 1, vpd, vpd_len);
 				len = vpd_len + 1;
 				out[len] = '\0';
 			}
-- 
2.21.0
