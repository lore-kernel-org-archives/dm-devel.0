From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath state discrepancies between user and
	kernel space
Date: Sat, 02 Jul 2005 00:01:09 +0200
Message-ID: <1120255269.8721.22.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AB3B@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AB3B@SRMANNING.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On ven, 2005-07-01 at 17:30 -0400, goggin, edward wrote:
> 
> (2) Two path state values, one for user space and one for the kernel
> resident multipath target driver,
> will be shown whenever the cached device configuration information is hot.
> Otherwise, "multipath -l"
> shows only the kernel driver's path state value since the user space path
> state value is not displayed
> if its value is PATH_UNCHECKED which it will be (for "multipath -l") if the
> saved device configuration
> cache is not used.
> 
> Seems like either one value should always be displayed or two values should
> always be displayed --
> I would certainly prefer that only one value be displayed at all times.
> Seems like a simple change.
> 
Like that ?

--- b40790b47efc2b5e50b241945bfca58c569e91ee/multipath/main.c
(mode:100644)
+++ uncommitted/multipath/main.c  (mode:100644)
@@ -173,22 +173,25 @@
        if (pp->dev_t)
                printf("%-7s ", pp->dev_t);

-       switch (pp->state) {
-       case PATH_UP:
-               printf("[ready ]");
-               break;
-       case PATH_DOWN:
-               printf("[faulty]");
-               break;
-       case PATH_GHOST:
-               printf("[ghost ]");
-               break;
-       case PATH_SHAKY:
-               printf("[shaky ]");
-               break;
-       default:
-               break;
+       if (conf->list > 1) {
+               switch (pp->state) {
+               case PATH_UP:
+                       printf("[ready ]");
+                       break;
+               case PATH_DOWN:
+                       printf("[faulty]");
+                       break;
+               case PATH_GHOST:
+                       printf("[ghost ]");
+                       break;
+               case PATH_SHAKY:
+                       printf("[shaky ]");
+                       break;
+               default:
+                       break;
+               }
        }
+
        switch (pp->dmstate) {
        case PSTATE_ACTIVE:
                printf("[active]");


-- 
christophe varoqui <christophe.varoqui@free.fr>
