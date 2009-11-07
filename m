From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH v4 10/12] string: factorize skip_spaces and
	export it to be generally available
Date: Sat,  7 Nov 2009 13:16:18 -0200
Message-ID: <c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com>
References: <cover.1257602781.git.andre.goddard@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1257602781.git.andre.goddard@gmail.com>
In-Reply-To: <cover.1257602781.git.andre.goddard@gmail.com>
References: <cover.1257602781.git.andre.goddard@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com, Michael Holzheu <holzheu@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-f>
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
List-Id: dm-devel.ids

On the following sentence:
    while (*s && isspace(*s))
        s++;

If *s =3D=3D 0, isspace() evaluates to ((_ctype[*s] & 0x20) !=3D 0), whic=
h
evaluates to ((0x08 & 0x20) !=3D 0) which equals to 0 as well.
If *s =3D=3D 1, we depend on isspace() result anyway.

In other words, "a char equals zero is never a space". So remove this che=
ck.
Also, *s !=3D 0 is by far the most common case (non-empty string).

Signed-off-by: Andr=C3=A9 Goddard Rosa <andre.goddard@gmail.com>
---
 include/linux/string.h |    1 +
 lib/string.c           |   19 +++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index b850886..3bba9ee 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -62,6 +62,7 @@ extern char * strnchr(const char *, size_t, int);
 #ifndef __HAVE_ARCH_STRRCHR
 extern char * strrchr(const char *,int);
 #endif
+extern const char * __must_check skip_spaces(const char *);
 extern char * __must_check strstrip(char *);
 #ifndef __HAVE_ARCH_STRSTR
 extern char * strstr(const char *,const char *);
diff --git a/lib/string.c b/lib/string.c
index b19b87a..d9a51d5 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -330,6 +330,20 @@ EXPORT_SYMBOL(strnchr);
 #endif
=20
 /**
+ * skip_spaces - Removes leading whitespace from @s.
+ * @s: The string to be stripped.
+ *
+ * Returns a pointer to the first non-whitespace character in @s.
+ */
+const char *skip_spaces(const char *str)
+{
+	while (isspace(*str))
+		++str;
+	return str;
+}
+EXPORT_SYMBOL(skip_spaces);
+
+/**
  * strstrip - Removes leading and trailing whitespace from @s.
  * @s: The string to be stripped.
  *
@@ -352,10 +366,7 @@ char *strstrip(char *s)
 		end--;
 	*(end + 1) =3D '\0';
=20
-	while (*s && isspace(*s))
-		s++;
-
-	return s;
+	return (char *)skip_spaces(s);
 }
 EXPORT_SYMBOL(strstrip);
=20
--=20
1.6.5.2.153.g6e31f.dirty
