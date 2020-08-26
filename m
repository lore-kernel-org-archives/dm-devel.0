From: mwilck@suse.com
Subject: [PATCH v2 09/10] libmultipath: alloc_strvec:
	NULL-initialize strvec elements
Date: Wed, 26 Aug 2020 11:59:06 +0200
Message-ID: <20200826095907.5576-10-mwilck@suse.com>
References: <20200826095907.5576-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200826095907.5576-1-mwilck@suse.com>
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

From: Martin Wilck <mwilck@suse.com>

The statement assigning a real token to a strvec element may
never be reached. Thus set the element to NULL beforehand to
make sure later code can recognized the non-properly initialized
element.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/parser.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 3875174..e6753c4 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -237,6 +237,7 @@ alloc_strvec(char *string)
 		if (!vector_alloc_slot(strvec))
 			goto out;
 
+		vector_set_slot(strvec, NULL);
 		start = cp;
 		if (*cp == '"' && !(in_string && *(cp + 1) == '"')) {
 			cp++;
-- 
2.28.0
