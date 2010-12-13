From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: Re: rdac.c patch not quite right.
Date: Mon, 13 Dec 2010 14:37:44 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED709114205@inbmail01.lsi.com>
References: <alpine.DEB.2.00.1011291838420.15702@sphinx.andrew.cmu.edu>
	<1291759024.4430.2.camel@zezette>
	<B2FD678A64EAAD45B089B123FDFC3ED709113EE5@inbmail01.lsi.com>
	<20101208213936.GB5205@us.ibm.com>
	<B2FD678A64EAAD45B089B123FDFC3ED709114050@inbmail01.lsi.com>
	<20101209151742.GA25922@us.ibm.com>
	<B2FD678A64EAAD45B089B123FDFC3ED709114065@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED709114065@inbmail01.lsi.com>
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
List-Id: dm-devel.ids

On Thurs December 09, 2010 9:11 PM Vijay Chauhan wrote:
> >
> > Vijay, in your patch, the second expression is not a comparison to be
> > precise!  Based on your explanation, you really want (inq.PQ_PDT ==
> > 0x7F) rather than the current expression (inq.PQ_PDT & 0x7F).
> Yes, I agree with you. I will correct the patch with your inputs. Thanks.
Resubmitting the patch with the change in second expression.

Thanks,
Vijay
 
---
In case of not connected device, only first expression is checked for PQ in rdac path checker. This patch
corrects the first expression by masking MSB 3 bits and comparing it with 0x20. Second expression compares with 0x7f. 

Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
---
--- multipath-tools-orig/libmultipath/checkers/rdac.c	2010-12-06 02:59:40.000000000 -0600
+++ multipath-tools/libmultipath/checkers/rdac.c	2010-12-09 10:34:52.000000000 -0600
@@ -107,7 +107,7 @@ libcheck_check (struct checker * c)
 	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq))) {
 		ret = PATH_DOWN;
 		goto done;
-	} else if ((inq.PQ_PDT & 0x20) || (inq.PQ_PDT & 0x7f)) {
+	} else if (((inq.PQ_PDT & 0xE0) == 0x20) || (inq.PQ_PDT == 0x7f)) {
 		/* LUN not connected*/
 		ret = PATH_DOWN;
 		goto done;
--
