From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [RESEND][PATCH]multipath-tools: Adding Netapp as a
 brand name for RDAC
Date: Tue, 20 Sep 2011 08:18:09 -0500
Message-ID: <1316524689.9298.55.camel@chandra-lucid.austin.ibm.com>
References: <EE2129A8E578DC4E94D643D6C1C1C67D05D03DDA@BTCMVEXC2-PRD.hq.netapp.com>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <EE2129A8E578DC4E94D643D6C1C1C67D05D03DDA@BTCMVEXC2-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Cc: dm-devel@redhat.com, "Moger, Babu" <Babu.Moger@netapp.com>, Christophe Varoqui <christophe.varoqui@free.fr>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>
List-Id: dm-devel.ids

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Fri, 2011-09-02 at 18:52 +0530, Chauhan, Vijay wrote:
> Resending this patch. Previous post had indentation issue due to my mail settings.
> 
> ---
> Adding NetApp as brand name for RDAC.
> 
> Signed-off-by: Vijay Chauhan <Vijay.chauhan@netapp.com>
> Reviewed-by: Bob Stankey <Robert.stankey@netapp.com> 
> Reviewed-by: Babu Moger <Babu.moger@netapp.com>
> 
> ---
> diff -uprN multipath-tools-orig/libmultipath/hwtable.c multipath-tools/libmultipath/hwtable.c
> --- multipath-tools-orig/libmultipath/hwtable.c	2011-08-26 16:19:58.000000000 +0530
> +++ multipath-tools/libmultipath/hwtable.c	2011-08-30 19:13:57.000000000 +0530
> @@ -1168,7 +1168,7 @@ static struct hwentry default_hw[] = {
>  		.prio_name     = PRIO_RDAC,
>  		.prio_args     = NULL,
>  	},
> -	/* LSI Generic rdac storage */
> +	/* LSI/Engenio/NetApp E-Series RDAC storage */
>  	{
>  		.vendor        = "(LSI|ENGENIO)",
>  		.product       = "INF-01-00",
> diff -uprN multipath-tools-orig/multipath/multipath.conf.5 multipath-tools/multipath/multipath.conf.5
> --- multipath-tools-orig/multipath/multipath.conf.5	2011-08-26 16:19:58.000000000 +0530
> +++ multipath-tools/multipath/multipath.conf.5	2011-08-30 19:17:37.000000000 +0530
> @@ -165,7 +165,7 @@ Generate the path priority based on the 
>  Generate the path priority for NetApp arrays.
>  .TP
>  .B rdac
> -Generate the path priority for LSI/Engenio RDAC controller.
> +Generate the path priority for LSI/Engenio/NetApp E-Series RDAC controller.
>  .TP
>  .B hp_sw
>  Generate the path priority for Compaq/HP controller in
> @@ -229,7 +229,7 @@ state.
>  Check the path state for HP storage arrays with Active/Standby firmware.
>  .TP
>  .B rdac
> -Check the path state for LSI/Engenio RDAC storage controller.
> +Check the path state for LSI/Engenio/NetApp E-Series RDAC storage controller.
>  .TP
>  .B directio
>  Read the first sector with direct I/O.
> @@ -445,7 +445,7 @@ The following hardware handler are imple
>  Hardware handler for EMC storage arrays.
>  .TP
>  .B 1 rdac
> -Hardware handler for LSI/Engenio RDAC storage controller.
> +Hardware handler for LSI/Engenio/NetApp E-Series RDAC storage controller.
>  .TP
>  .B 1 hp_sw
>  Hardware handler for Compaq/HP storage arrays in active/standby
> 
> --
