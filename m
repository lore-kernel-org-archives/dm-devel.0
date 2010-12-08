From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: Re: rdac.c patch not quite right.
Date: Wed, 8 Dec 2010 11:43:59 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED709113EE5@inbmail01.lsi.com>
References: <alpine.DEB.2.00.1011291838420.15702@sphinx.andrew.cmu.edu>
	<1291759024.4430.2.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1291759024.4430.2.camel@zezette>
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
To: "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed December 08, 2010 3:27 AM, Christophe Varoqui Wrote:
> On lun., 2010-11-29 at 19:03 -0500, Chaskiel Grundman wrote:
> > commit 362d2e5f215894818b52a0d03b723b75917390fb
> > added the following block to rdac.c:
> >
> >         } else if ((inq.PQ_PDT & 0x20) || (inq.PQ_PDT & 0x7f)) {
> >                 /* LUN not connected*/
> >                 ret = PATH_DOWN;
> >                 goto done;
> >         }
> >
> > I don't know what the intended effect actually was, but since
> > (inq.PQ_PDT & 0x20) will be true if (inq.PQ_PDT & 0x7f), the code is
> > incorrect as-is. I have some dell RDAC devices, but I cannot delete
> > targets on any of them to test this.
> >
> > Update, after reading some scsi docs: If RDAC is using the standard
> > peripheral qualifier semantics, I think the following is what should be
> > used instead
> >
> >
> >         } else if ((inq.PQ_PDT & 0xE0) == 0x20 || inq.PQ_PDT == 0x7f) {
> >
> > This form checks for the PQ bits being 001 or 011, and if 011, also
> > that the device type has the standard value for an unsupported
> > lun.
> >
> > Alternatively,
> >
> >         } else if ((inq.PQ_PDT & 0xC0) == 0x20) {
> >
> > does not validate the device type bits in case the PQ is 011
> >
> As the original author of the aforementioned change, do you ack this
> patch ?

Chaskiel,

Thanks for your findings and inputs.

Christophe,

Please include this fix in rdac path checker.

Thanks,
Vijay

---

In case of not connected device, only first condition is checked for PQ in rdac path checker. This patch
corrects the check by masking MSB 3 bits and comparing it with 0x20. 

Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
---
--- multipath-tools-orig/libmultipath/checkers/rdac.c	2010-12-06 02:59:40.000000000 -0600
+++ multipath-tools/libmultipath/checkers/rdac.c	2010-12-06 04:01:37.000000000 -0600
@@ -107,7 +107,7 @@ libcheck_check (struct checker * c)
 	if (0 != do_inq(c->fd, 0xC9, &inq, sizeof(struct volume_access_inq))) {
 		ret = PATH_DOWN;
 		goto done;
-	} else if ((inq.PQ_PDT & 0x20) || (inq.PQ_PDT & 0x7f)) {
+	} else if (((inq.PQ_PDT & 0xE0) == 0x20) || (inq.PQ_PDT & 0x7f)) {
 		/* LUN not connected*/
 		ret = PATH_DOWN;
 		goto done;
--
