From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: retry the DID_SOFT_ERROR for rdac
 checker commands
Date: Wed, 11 Jul 2012 10:05:23 +0200
Message-ID: <1341993923.23291.0.camel@lapoo.opensvc.com>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B07E5F4B9@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B07E5F4B9@SACEXCMBX02-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mar., 2012-07-10 at 19:12 +0000, Moger, Babu wrote:
> Sometimes we have seen immediate path failures for DID_SOFT_ERROR status. Just add a retry as other statuses.
> It will basically add 5 retries.
> 
Applied.
Thanks.

> Here are the messages.
> Jun  4 17:46:42 ictc-billy kernel: mpt2sas0: log_info(0x31120100): originator(PL), code(0x12), sub_code(0x0100)
> Jun  4 17:46:42 ictc-billy kernel: sd 1:0:0:47: [sdn] Unhandled error code
> Jun  4 17:46:42 ictc-billy kernel: sd 1:0:0:47: [sdn] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
> Jun  4 17:46:42 ictc-billy kernel: sd 1:0:0:47: [sdn] CDB: Write(10): 2a 00 00 06 e4 a0 00 00 20 00
> Jun  4 17:46:42 ictc-billy kernel: device-mapper: multipath: Failing path 8:208.
> Jun  4 17:46:42 ictc-billy multipathd: 8:208: mark as failed
> Jun  4 17:46:42 ictc-billy multipathd: mpathat: remaining active paths: 1
> 
> 
> Signed-off-by: Babu Moger <babu.moger@netapp.com>
> ---
> --- multipath-tools/libmultipath/checkers/rdac.c.orig	2012-07-10 13:35:34.000000000 -0500
> +++ multipath-tools/libmultipath/checkers/rdac.c	2012-07-10 13:36:07.000000000 -0500
> @@ -166,6 +166,7 @@ retry:
>  		switch (io_hdr.host_status) {
>  		case DID_BUS_BUSY:
>  		case DID_ERROR:
> +		case DID_SOFT_ERROR:
>  		case DID_TRANSPORT_DISRUPTED:
>  			/* Transport error, retry */
>  			if (--retry_rdac)
> 
> 
