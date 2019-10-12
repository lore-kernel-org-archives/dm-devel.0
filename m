From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 50/72] libmultipath: set_int(): add error check
	and set_uint()
Date: Sat, 12 Oct 2019 21:28:39 +0000
Message-ID: <20191012212703.12989-51-martin.wilck@suse.com>
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

Use strtol() to check for valid input, but don't return error
as that would cause config file parsing to fail because of a
single typo. Also, add set_uint() to parse an unsigned parameter.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 48 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 2b046e1d..c23d525b 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -31,16 +31,58 @@ static int
 set_int(vector strvec, void *ptr)
 {
 	int *int_ptr = (int *)ptr;
-	char * buff;
+	char *buff, *eptr;
+	long res;
+	int rc;
 
 	buff = set_value(strvec);
 	if (!buff)
 		return 1;
 
-	*int_ptr = atoi(buff);
+	res = strtol(buff, &eptr, 10);
+	if (eptr > buff)
+		while (isspace(*eptr))
+			eptr++;
+	if (*buff == '\0' || *eptr != '\0' || res > INT_MAX || res < INT_MIN) {
+		condlog(1, "%s: invalid value for %s: \"%s\"",
+			__func__, (char*)VECTOR_SLOT(strvec, 0), buff);
+		rc = 1;
+	} else {
+		rc = 0;
+		*int_ptr = res;
+	}
 
 	FREE(buff);
-	return 0;
+	return rc;
+}
+
+static int
+set_uint(vector strvec, void *ptr)
+{
+	unsigned int *uint_ptr = (unsigned int *)ptr;
+	char *buff, *eptr;
+	long res;
+	int rc;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	res = strtol(buff, &eptr, 10);
+	if (eptr > buff)
+		while (isspace(*eptr))
+			eptr++;
+	if (*buff == '\0' || *eptr != '\0' || res < 0 || res > UINT_MAX) {
+		condlog(1, "%s: invalid value for %s: \"%s\"",
+			__func__, (char*)VECTOR_SLOT(strvec, 0), buff);
+		rc = 1;
+	} else {
+		rc = 0;
+		*uint_ptr = res;
+	}
+
+	FREE(buff);
+	return rc;
 }
 
 static int
-- 
2.23.0
