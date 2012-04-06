From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: Re: [PATCH] multipath: blacklist all the management Luns
 by	default
Date: Fri, 6 Apr 2012 21:17:48 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B04BD86@SACEXCMBX03-PRD.hq.netapp.com>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B01AFE9@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B01AFE9@SACEXCMBX02-PRD.hq.netapp.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: "christophe.varoqui@gmail.com" <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Christophe,  Can you please merge  these patches when you get a chance..

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-
> bounces@redhat.com] On Behalf Of Moger, Babu
> Sent: Wednesday, March 14, 2012 4:20 PM
> To: device-mapper development
> Subject: [dm-devel] [PATCH] multipath: blacklist all the management Luns by
> default
> 
> This patch adds the blacklisting for all the management luns. Otherwise user
> has to manually add blacklisting in multipath.conf for these luns.
> 
> Signed-off-by: Babu Moger <babu.moger@netapp.com>
> ---
> --- multipath-tools/libmultipath/hwtable.c.orig	2012-03-14
> 15:10:04.000000000 -0500
> +++ multipath-tools/libmultipath/hwtable.c	2012-03-14
> 15:27:11.000000000 -0500
> @@ -448,6 +448,7 @@ static struct hwentry default_hw[] = {
>  		/* IBM FAStT 1722-600 */
>  		.vendor        = "IBM",
>  		.product       = "^1722-600",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = "1 queue_if_no_path",
>  		.hwhandler     = "1 rdac",
> @@ -466,6 +467,7 @@ static struct hwentry default_hw[] = {
>  		/* IBM DS4100 */
>  		.vendor        = "IBM",
>  		.product       = "^1724",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = "1 queue_if_no_path",
>  		.hwhandler     = "1 rdac",
> @@ -484,6 +486,7 @@ static struct hwentry default_hw[] = {
>  		/* IBM DS3200 / DS3300 / DS3400 */
>  		.vendor        = "IBM",
>  		.product       = "^1726",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = "1 queue_if_no_path",
>  		.hwhandler     = "1 rdac",
> @@ -502,6 +505,7 @@ static struct hwentry default_hw[] = {
>  		/* IBM DS4400 / DS4500 / FAStT700 */
>  		.vendor        = "IBM",
>  		.product       = "^1742",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = DEFAULT_FEATURES,
>  		.hwhandler     = "1 rdac",
> @@ -519,6 +523,7 @@ static struct hwentry default_hw[] = {
>  	{
>  		.vendor        = "IBM",
>  		.product       = "^1745|^1746",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = "2 pg_init_retries 50",
>  		.hwhandler     = "1 rdac",
> @@ -537,6 +542,7 @@ static struct hwentry default_hw[] = {
>  	    /* IBM DS4700 */
>  		.vendor        = "IBM",
>  		.product       = "^1814",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = DEFAULT_FEATURES,
>  		.hwhandler     = "1 rdac",
> @@ -555,6 +561,7 @@ static struct hwentry default_hw[] = {
>  	    /* IBM DS4800 */
>  		.vendor        = "IBM",
>  		.product       = "^1815",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = DEFAULT_FEATURES,
>  		.hwhandler     = "1 rdac",
> @@ -573,6 +580,7 @@ static struct hwentry default_hw[] = {
>  	    /* IBM DS5000 */
>  		.vendor        = "IBM",
>  		.product       = "^1818",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = DEFAULT_FEATURES,
>  		.hwhandler     = "1 rdac",
> @@ -591,6 +599,7 @@ static struct hwentry default_hw[] = {
>  		/* IBM Netfinity Fibre Channel RAID Controller Unit */
>  		.vendor        = "IBM",
>  		.product       = "^3526",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = DEFAULT_FEATURES,
>  		.hwhandler     = "1 rdac",
> @@ -869,6 +878,7 @@ static struct hwentry default_hw[] = {
>  		/* DELL MD3000 */
>  		.vendor        = "DELL",
>  		.product       = "MD3000",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = "2 pg_init_retries 50",
>  		.hwhandler     = "1 rdac",
> @@ -887,6 +897,7 @@ static struct hwentry default_hw[] = {
>  		/* DELL MD3000i */
>  		.vendor        = "DELL",
>  		.product       = "MD3000i",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = "2 pg_init_retries 50",
>  		.hwhandler     = "1 rdac",
> @@ -905,6 +916,7 @@ static struct hwentry default_hw[] = {
>  		/* DELL MD32xx */
>  		.vendor        = "DELL",
>  		.product       = "MD32xx",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = "2 pg_init_retries 50",
>  		.hwhandler     = "1 rdac",
> @@ -923,6 +935,7 @@ static struct hwentry default_hw[] = {
>  		/* DELL MD32xxi */
>  		.vendor        = "DELL",
>  		.product       = "MD32xxi",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = "2 pg_init_retries 50",
>  		.hwhandler     = "1 rdac",
> @@ -1053,6 +1066,7 @@ static struct hwentry default_hw[] = {
>  	{
>  		.vendor        = "SGI",
>  		.product       = "TP9[45]00",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = DEFAULT_FEATURES,
>  		.hwhandler     = "1 rdac",
> @@ -1070,6 +1084,7 @@ static struct hwentry default_hw[] = {
>  	{
>  		.vendor        = "SGI",
>  		.product       = "IS.*",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = "2 pg_init_retries 50",
>  		.hwhandler     = "1 rdac",
> @@ -1111,6 +1126,7 @@ static struct hwentry default_hw[] = {
>  	{
>  		.vendor        = "STK",
>  		.product       = "OPENstorage D280",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = DEFAULT_FEATURES,
>  		.hwhandler     = "1 rdac",
> @@ -1190,6 +1206,7 @@ static struct hwentry default_hw[] = {
>  	{
>  		.vendor        = "SUN",
>  		.product       = "CSM200_R",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = DEFAULT_FEATURES,
>  		.hwhandler     = "1 rdac",
> @@ -1208,6 +1225,7 @@ static struct hwentry default_hw[] = {
>  	{
>  		.vendor        = "SUN",
>  		.product       = "LCSM100_[IEFS]",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = DEFAULT_FEATURES,
>  		.hwhandler     = "1 rdac",
> @@ -1226,6 +1244,7 @@ static struct hwentry default_hw[] = {
>  	{
>  		.vendor        = "(LSI|ENGENIO)",
>  		.product       = "INF-01-00",
> +		.bl_product    = "Universal Xport",
>  		.getuid        = DEFAULT_GETUID,
>  		.features      = "2 pg_init_retries 50",
>  		.hwhandler     = "1 rdac",
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
