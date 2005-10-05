From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: DM configuration
Date: Wed, 5 Oct 2005 15:45:05 +0200
Message-ID: <20051005134505.GB6195@free.fr>
References: <3456F611E9329441B12FBB24447B3FA002C73E05@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3456F611E9329441B12FBB24447B3FA002C73E05@bgeexc01.asiapacific.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Cc: device-mapper development <dm-devel@redhat.com>, "P S,  Suresh (STSD)" <suresh.pathamadai@hp.com>, christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

On Tue, Oct 04, 2005 at 03:29:51PM +0530, Murthy, Narasimha Doraswamy (STSD) wrote:
> 
> 1) Under all path failure condition or the device is removed from array
> (using management station), IO continues if "queue_if_no_path" feature
> is enabled. As all the requests are cached all the memory gets used out
> for this. Can there be any mechanism where the all path failure is
> detected and marked, devices can be suspended or removed after some time
> (user configurable). By doing this the OS stalling can be avoided when
> the LUN is in dead state for prolonged period of time.
> 
Wouldn't it be adequate to solve this issue in the queue_if_no_path
limiting framework that should be worked on (time-based, queue depth-based,
both, ...?)

After all, the admin should "multipath -f $sssu_wants_to_kill_me") before,
shouldn't it ? Think of mounted FS, for example ... the admin *has* to
do something on the system anyway.

>    
> 
> 2) I am not able to give partial product ID string (substring) in
> /etc/multipath.conf as DM expects complete product string. This
> requirement is needed to cater different product id strings for same
> product. The XP array has the ids based on the emulation type of each
> LUN.   With the current settings available in /etc/multipath.conf, the
> only option is to have separate "device" structs mentioning about the
> policies/features for each LUN.
> 
Does this work for you ?

--- 58814af76c619b85440d3853a8f97927e7c3aebe/libmultipath/config.c  (mode:100644)
+++ ef58245012d71b4dae8873898889f61c85ec41b8/libmultipath/config.c  (mode:100644)
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
-               if (strcmp_chomp(hwe->vendor, vendor) == 0 &&
-                   (hwe->product[0] == '*' ||
-                   strcmp_chomp(hwe->product, product) == 0))
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
