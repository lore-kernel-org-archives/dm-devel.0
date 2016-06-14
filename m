From: <Menny_Hamburger@dell.com>
Subject: Re: [PATCH] multipath-tools: add Pure Storage device to
 hardware table
Date: Tue, 14 Jun 2016 12:37:01 +0000
Message-ID: <1465907821099.6145@Dell.com>
References: <1465835437-18350-1-git-send-email-xose.vazquez@gmail.com>,
	<dc5c07f3-361b-9d32-c926-a394c1543c9a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <dc5c07f3-361b-9d32-c926-a394c1543c9a@gmail.com>
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
To: xose.vazquez@gmail.com, christophe.varoqui@opensvc.com, dm-devel@redhat.com, brian@purestorage.com
List-Id: dm-devel.ids

If driver names are different between tophat and magichat you can stick with different names instead of an alias in modprobe.conf and do "install x modprobe install y" in modprobe.conf
________________________________________
From: dm-devel-bounces@redhat.com <dm-devel-bounces@redhat.com> on behalf of Xose Vazquez Perez <xose.vazquez@gmail.com>
Sent: Tuesday, June 14, 2016 3:32 PM
To: Christophe Varoqui; device-mapper development; Brian Bunker
Subject: Re: [dm-devel] [PATCH] multipath-tools: add Pure Storage device to hardware table

On 06/13/2016 06:30 PM, Xose Vazquez Perez wrote:

> based on documentation provided by the manufacturer:
> https://support.purestorage.com/@api/deki/files/1733/=Pure_Storage_Oracle_DB_Best_Practices.pdf?revision=2
>
> vendor                  "PURE"
> product                 "FlashArray"  (extracted from outputs)

Please DROP this one. It was already included by Brian Bunker <brian@purestorage.com>

> +     {
> +             .vendor        = "PURE",
> +             .product       = "FlashArray",
> +             .selector      = "round-robin 0",
> +             .pgpolicy      = MULTIBUS,
> +             .minio         = 1,
> +             .checker_name  = TUR,
> +             .fast_io_fail  = 10,
> +             .dev_loss      = 30,
> +     },

Though it's a bit different. Why ?

+               .vendor        = "PURE",
+               .product       = "FlashArray",
+               .features      = DEFAULT_FEATURES,
+               .hwhandler     = DEFAULT_HWHANDLER,
+               .selector      = "queue-length 0",
+               .pgpolicy      = MULTIBUS,
+               .pgfailback    = -FAILBACK_IMMEDIATE,
+               .checker_name  = TUR,
+               .fast_io_fail  = 10,
+               .user_friendly_names = USER_FRIENDLY_NAMES_OFF,
+               .prio_name     = DEFAULT_PRIO,
+               .no_path_retry = 0,
+               .dev_loss      = 60,
+               .prio_args     = NULL,

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
