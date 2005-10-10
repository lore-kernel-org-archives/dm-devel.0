From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: RE: DM configuration
Date: Mon, 10 Oct 2005 17:19:45 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA002CC6311@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, "P S,  Suresh (STSD)" <suresh.pathamadai@hp.com>
List-Id: dm-devel.ids

Christophe,
The one mentioned below will be success for the regular expressions that
matches anywhere in the string. Can we modify strcmp_chomp(...) in
<multipath-src>/libmultipath/utils.c  as below:

# diff util.c util.c.mod=20
29c29
<       return(strcmp(s1,s2));
---
>       return(strncmp(s1,s2,strlen(s1)));
=20
so that both the partial string and the complete string can be compared.


Thanks and regards
-Murthy


-----Original Message-----
From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]=20
Sent: Wednesday, October 05, 2005 7:15 PM
To: Murthy, Narasimha Doraswamy (STSD)
Cc: christophe varoqui; device-mapper development; Reilly, Stephen
(MRO); P S, Suresh (STSD)
Subject: Re: DM configuration

On Tue, Oct 04, 2005 at 03:29:51PM +0530, Murthy, Narasimha Doraswamy
(STSD) wrote:
> 2) I am not able to give partial product ID string (substring) in
> /etc/multipath.conf as DM expects complete product string. This
> requirement is needed to cater different product id strings for same
> product. The XP array has the ids based on the emulation type of each
> LUN.   With the current settings available in /etc/multipath.conf, the
> only option is to have separate "device" structs mentioning about the
> policies/features for each LUN.
>=20
Does this work for you ?

--- 58814af76c619b85440d3853a8f97927e7c3aebe/libmultipath/config.c
(mode:100644)
+++ ef58245012d71b4dae8873898889f61c85ec41b8/libmultipath/config.c
(mode:100644)
@@ -1,6 +1,7 @@
 #include <stdio.h>
 #include <string.h>

+#include "regex.h"
 #include "memory.h"
 #include "util.h"
 #include "debug.h"
@@ -19,11 +20,15 @@
 {
        int i;
        struct hwentry * hwe;
+       regex_t vre, pre;

        vector_foreach_slot (hwtable, hwe, i) {
-               if (strcmp_chomp(hwe->vendor, vendor) =3D=3D 0 &&
-                   (hwe->product[0] =3D=3D '*' ||
-                   strcmp_chomp(hwe->product, product) =3D=3D 0))
+               if (regcomp(&vre, hwe->vendor, REG_EXTENDED|REG_NOSUB))
+                       return NULL;
+               if (regcomp(&pre, hwe->product, REG_EXTENDED|REG_NOSUB))
+                       return NULL;
+               if (!regexec(&vre, vendor, 0, NULL, 0) &&
+                   !regexec(&pre, product, 0, NULL, 0))
                        return hwe;
        }
        return NULL;


Regards,
cvaroqui
