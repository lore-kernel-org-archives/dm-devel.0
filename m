From: mwilck@suse.com
Subject: [PATCH 07/11] libmultipath: set_uint: fix parsing for
	32bit
Date: Tue, 12 May 2020 00:39:27 +0200
Message-ID: <20200511223931.18261-8-mwilck@suse.com>
References: <20200511223931.18261-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200511223931.18261-1-mwilck@suse.com>
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

On architectures where sizeof(long) == sizeof(int), the code wouldn't
work as intended. Use strtoul instead. As strtoul happily parses
negative numbers as input, require the number to begin with a digit.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 3e25e74f..0e9ea387 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -60,19 +60,22 @@ static int
 set_uint(vector strvec, void *ptr)
 {
 	unsigned int *uint_ptr = (unsigned int *)ptr;
-	char *buff, *eptr;
-	long res;
+	char *buff, *eptr, *p;
+	unsigned long res;
 	int rc;
 
 	buff = set_value(strvec);
 	if (!buff)
 		return 1;
 
-	res = strtol(buff, &eptr, 10);
+	p = buff;
+	while (isspace(*p))
+		p++;
+	res = strtoul(p, &eptr, 10);
 	if (eptr > buff)
 		while (isspace(*eptr))
 			eptr++;
-	if (*buff == '\0' || *eptr != '\0' || res < 0 || res > UINT_MAX) {
+	if (*buff == '\0' || *eptr != '\0' || !isdigit(*p) || res > UINT_MAX) {
 		condlog(1, "%s: invalid value for %s: \"%s\"",
 			__func__, (char*)VECTOR_SLOT(strvec, 0), buff);
 		rc = 1;
-- 
2.26.2
