From: Martin George <marting@netapp.com>
Subject: Re: PATCH - change netapp maintainer in pp_netapp.c
Date: Fri, 22 Sep 2006 12:39:21 +0530
Message-ID: <45138C21.6020003@netapp.com>
References: <7026BCCA258BA2438F885772CA0B431303BEEB6C@exbtc01.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7026BCCA258BA2438F885772CA0B431303BEEB6C@exbtc01.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,
    As the maintainer's name is already updated in hwtable.c as 
submitted in 
https://www.redhat.com/archives/dm-devel/2006-August/msg00076.html, this 
patch which I had submitted earlier is not required.

    The only change that is required here is the removal of the author's 
mail id as it is no longer valid. Submitting the new patch below:

Regards,

Martin George


Signed-off-by: Martin George <marting@netapp.com>
Acked-by: Raghavendra Shenoy <shenoy@netapp.com>
Index: multipath-tools/path_priority/pp_netapp/pp_netapp.c
===================================================================
--- multipath-tools.orig/path_priority/pp_netapp/pp_netapp.c	2005-11-22 
04:58:32.000000000 +0530
+++ multipath-tools/path_priority/pp_netapp/pp_netapp.c	2006-09-22 
12:21:31.000000000 +0530
@@ -1,6 +1,6 @@
  /*
   * Copyright 2005 Network Appliance, Inc., All Rights Reserved
- * Author:  David Wysochanski available at davidw@netapp.com
+ * Author:  David Wysochanski
   *
   * This program is free software; you can redistribute it and/or modify
   * it under the terms of the GNU General Public License version 2 as


>  
> 
> -----Original Message-----
> From: Martin George [mailto:marting@netapp.com] 
> Sent: Thursday, September 21, 2006 9:22 PM
> To: dm-devel@redhat.com
> Subject: [dm-devel] PATCH - change netapp maintainer in pp_netapp.c
> 
> Signed-off-by: Martin George <marting netapp com>
> Acked-by: Raghavendra Shenoy <shenoy netapp com>
> Index: multipath-tools/path_priority/pp_netapp/pp_netapp.c
> ===================================================================
> --- multipath-tools.orig/path_priority/pp_netapp/pp_netapp.c
> 2005-11-22 
> 04:58:32.000000000 +0530
> +++ multipath-tools/path_priority/pp_netapp/pp_netapp.c	2006-09-21 
> 19:05:49.000000000 +0530
> @@ -1,6 +1,6 @@
>   /*
>    * Copyright 2005 Network Appliance, Inc., All Rights Reserved
> - * Author:  David Wysochanski available at davidw@netapp.com
> + * Author:  Martin George available at marting@netapp.com
>    *
>    * This program is free software; you can redistribute it and/or
> modify
>    * it under the terms of the GNU General Public License version 2 as
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
