From: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Subject: RE: Some issues noticed in my testing.
Date: Thu, 10 Feb 2005 11:24:13 -0800
Message-ID: <EA4DC661A6353747A2E5C0DE8792DDDE07C16E28@orsmsx404.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Sorry for the delay in the response. I am resending the patch. BTW the
code snippet that you have suggested below does not seem to take care of
trailing whitespaces in either the vendor or product strings failing the
match in find_hw. My suggestion is to chomp off trailing ws before doing
the strcmp.=20

diff -u -r /home/rcaushik/multipath-tools-0.4.2/libmultipath/hwtable.c
multipath-tools-0.4.2/libmultipath/hwtable.c
--- /home/rcaushik/multipath-tools-0.4.2/libmultipath/hwtable.c
2005-01-23 14:48:05.000000000 -0800
+++ multipath-tools-0.4.2/libmultipath/hwtable.c	2005-02-03
19:07:39.000000000 -0800
@@ -9,6 +9,8 @@
 #include "../libcheckers/checkers.h"
 #include "../multipath/pgpolicies.h"
=20
+int  strcmp_chomp(char *str1, char *str2);
+
 extern struct hwentry *
 find_hw (vector hwtable, char * vendor, char * product)
 {
@@ -17,9 +19,9 @@
=20
 	vector_foreach_slot (hwtable, hwe, i)
 		if (hwe->vendor && hwe->product &&
-		    strcmp(hwe->vendor, vendor) =3D=3D 0 &&
+		    strcmp_chomp(hwe->vendor, vendor) =3D=3D 0 &&
 		    (hwe->product[0] =3D=3D '*' ||
-			strcmp(hwe->product, product) =3D=3D 0))
+			strcmp_chomp(hwe->product, product) =3D=3D 0))
 			return hwe;
 	return NULL;
 }
@@ -56,4 +58,19 @@
 	ADDHWE_EXT(hw, "IBM", "3542", GROUP_BY_SERIAL, DEFAULT_GETUID,
 		   NULL, "0", "0", "tur");
 }
+int  strcmp_chomp(char *str1, char *str2)
+{
+	int i;
+	char s1[PARAMS_SIZE],s2[PARAMS_SIZE];
=20
+        if(!str1 || !str2)
+		return 1;
+	strncpy(s1,str1,PARAMS_SIZE);
+	strncpy(s2,str2,PARAMS_SIZE);
+	=09
+	for(i=3Dstrlen(s1)-1;i >=3D0 && isspace(s1[i]); --i) ;
+	s1[++i]=3D'\0';
+	for(i=3Dstrlen(s2)-1;i >=3D0 && isspace(s2[i]); --i) ;
+	s2[++i]=3D'\0';
+	return(strcmp(s1,s2));
+}

diff -u -r /home/rcaushik/multipath-tools-0.4.2/multipath/main.c
multipath-tools-0.4.2/multipath/main.c
--- /home/rcaushik/multipath-tools-0.4.2/multipath/main.c
2005-01-23 14:48:05.000000000 -0800
+++ multipath-tools-0.4.2/multipath/main.c	2005-02-07
11:34:48.000000000 -0800
@@ -402,7 +402,7 @@
 		mpp->mpe =3D find_mp(pp1->wwid);
 		mpp->hwe =3D find_hw(conf->hwtable,
 				   pp1->vendor_id, pp1->product_id);
-
+		select_alias(mpp);
 		mpp->paths =3D vector_alloc();
 		vector_alloc_slot (mpp->paths);
 		vector_set_slot (mpp->paths, pp1);
@@ -669,7 +669,7 @@
 			}
 			if (found) {
 				found =3D 0;
-				break;
+				/* break; */
 			} else
 				return 1;
 		}
  =20
Regards,

Ramesh.


-----Original Message-----
From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
Sent: Tuesday, February 08, 2005 1:56 PM
To: Caushik, Ramesh
Cc: device-mapper development
Subject: Re: Some issues noticed in my testing.

Caushik, Ramesh wrote:

>Hi Christophe,
> =20
>
Hello,

>I noticed a failure in multipath-tools-0.4.2 when executing the
>following scenario.
>
>i) Run multipathd & multipath with 1 of 2 paths in the system
available.
>ii)activate the other path.
>iii) run multipath again.
>
>Expect the newly inserted path to be incorporated into the original
path
>groups. Does not happen. Traced it to a problem in the pgcmp2 function.
>Patch below should fix it.
>
I can't see this patch attached.
Can you resend it. (In diff -u format if possible)

> Also in step iii) above running multipath
>with a parameter (conf->dev) will not include the additional path into
>the particular mp because the select_alias function not called in the
>coalesce_paths function so the strncmp(mpp->alias,conf->dev,....) in
>main will always fail. Patch below should fix it.=20
>
> =20
>
Mr Goggin, EMC, already spotted this and a patch is present in my tree.=20
Thanks.

>Also while testing with a modified scsi_debug driver (to expose
multiple
>paths to the same device) noticed that sysfs vendor name for the
>scsi_debug device is "Linux   " which fails to match with a "Linux"
>vendor name in the conf name and so device specific settings are not
>picked up. Think it is a good idea to chomp off trailing whitespace
from
>vendor and product names. See patches below.  Regards,
>
> =20
>
Can you tell me if the following fits your needs here ?

--- multipath-tools-0.4.2/libmultipath/hwtable.c        2005-01-23=20
14:48:05.830203168 -0800
+++ multipath-tools-0.4.3-pre1/libmultipath/hwtable.c   2005-02-08=20
13:42:57.203660896 -0800
@@ -12,14 +12,18 @@
 extern struct hwentry *
 find_hw (vector hwtable, char * vendor, char * product)
 {
-       int i;
+       int i, vendor_len, product_len;
        struct hwentry * hwe;

+       vendor_len =3D strlen(vendor);
+       product_len =3D strlen(product);
+
        vector_foreach_slot (hwtable, hwe, i)
-               if (hwe->vendor && hwe->product &&
-                   strcmp(hwe->vendor, vendor) =3D=3D 0 &&
+               if (hwe->vendor && vendor_len =3D=3D strlen(hwe->vendor) =
&&
+                   strncmp(hwe->vendor, vendor, vendor_len) =3D=3D 0 &&
+                   hwe->product && product_len =3D=3D strlen(hwe->produc=
t)
&&
                    (hwe->product[0] =3D=3D '*' ||
-                       strcmp(hwe->product, product) =3D=3D 0))
+                    strncmp(hwe->product, product, product_len) =3D=3D 0=
))
                        return hwe;
        return NULL;
 }

Regards,
cvaroqui


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
