From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: rdac.c patch not quite right.
Date: Wed, 8 Dec 2010 13:39:36 -0800
Message-ID: <20101208213936.GB5205@us.ibm.com>
References: <alpine.DEB.2.00.1011291838420.15702@sphinx.andrew.cmu.edu>
	<1291759024.4430.2.camel@zezette>
	<B2FD678A64EAAD45B089B123FDFC3ED709113EE5@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED709113EE5@inbmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Chauhan, Vijay [Vijay.Chauhan@lsi.com] wrote:
> 
> In case of not connected device, only first condition is checked for PQ in rdac path checker. This patch
> corrects the check by masking MSB 3 bits and comparing it with 0x20. 
> 
> Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> ---
> --- multipath-tools-orig/libmultipath/checkers/rdac.c	2010-12-06 02:59:40.000000000 -0600
> +++ multipath-tools/libmultipath/checkers/rdac.c	2010-12-06 04:01:37.000000000 -0600
> @@ -107,7 +107,7 @@ libcheck_check (struct checker * c)
>  	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq))) {
>  		ret = PATH_DOWN;
>  		goto done;
> -	} else if ((inq.PQ_PDT & 0x20) || (inq.PQ_PDT & 0x7f)) {
> +	} else if (((inq.PQ_PDT & 0xE0) == 0x20) || (inq.PQ_PDT & 0x7f)) {
>  		/* LUN not connected*/
>  		ret = PATH_DOWN;
>  		goto done;

I think this new patch has the same issue as the old one. In  other
words, the second expression in the parenthesis is true if the first one
is true. So you could as well just use the second expression. If you
really want to use PQ as well as PDT with separate checks, you can do
something like this:


	} else if (((inq.PQ_PDT & 0xE0) == 0x20) || (inq.PQ_PDT & 0x1F)) {
		/* LUN not connected or not a Direct Access device */
		ret = PATH_DOWN;
		goto done;

Please note the 7f to 1F change and the comment change to reflect the code
check.

Thanks, Malahal.
