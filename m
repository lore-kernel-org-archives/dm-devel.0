From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Some issues noticed in my testing.
Date: Tue, 08 Feb 2005 22:55:45 +0100
Message-ID: <42093561.9070008@free.fr>
References: <EA4DC661A6353747A2E5C0DE8792DDDE07B82237@orsmsx404.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <EA4DC661A6353747A2E5C0DE8792DDDE07B82237@orsmsx404.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Caushik, Ramesh wrote:

>Hi Christophe,
>  
>
Hello,

>I noticed a failure in multipath-tools-0.4.2 when executing the
>following scenario.
>
>i) Run multipathd & multipath with 1 of 2 paths in the system available.
>ii)activate the other path.
>iii) run multipath again.
>
>Expect the newly inserted path to be incorporated into the original path
>groups. Does not happen. Traced it to a problem in the pgcmp2 function.
>Patch below should fix it.
>
I can't see this patch attached.
Can you resend it. (In diff -u format if possible)

> Also in step iii) above running multipath
>with a parameter (conf->dev) will not include the additional path into
>the particular mp because the select_alias function not called in the
>coalesce_paths function so the strncmp(mpp->alias,conf->dev,....) in
>main will always fail. Patch below should fix it. 
>
>  
>
Mr Goggin, EMC, already spotted this and a patch is present in my tree. 
Thanks.

>Also while testing with a modified scsi_debug driver (to expose multiple
>paths to the same device) noticed that sysfs vendor name for the
>scsi_debug device is "Linux   " which fails to match with a "Linux"
>vendor name in the conf name and so device specific settings are not
>picked up. Think it is a good idea to chomp off trailing whitespace from
>vendor and product names. See patches below.  Regards,
>
>  
>
Can you tell me if the following fits your needs here ?

--- multipath-tools-0.4.2/libmultipath/hwtable.c        2005-01-23 
14:48:05.830203168 -0800
+++ multipath-tools-0.4.3-pre1/libmultipath/hwtable.c   2005-02-08 
13:42:57.203660896 -0800
@@ -12,14 +12,18 @@
 extern struct hwentry *
 find_hw (vector hwtable, char * vendor, char * product)
 {
-       int i;
+       int i, vendor_len, product_len;
        struct hwentry * hwe;

+       vendor_len = strlen(vendor);
+       product_len = strlen(product);
+
        vector_foreach_slot (hwtable, hwe, i)
-               if (hwe->vendor && hwe->product &&
-                   strcmp(hwe->vendor, vendor) == 0 &&
+               if (hwe->vendor && vendor_len == strlen(hwe->vendor) &&
+                   strncmp(hwe->vendor, vendor, vendor_len) == 0 &&
+                   hwe->product && product_len == strlen(hwe->product) &&
                    (hwe->product[0] == '*' ||
-                       strcmp(hwe->product, product) == 0))
+                    strncmp(hwe->product, product, product_len) == 0))
                        return hwe;
        return NULL;
 }

Regards,
cvaroqui

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
