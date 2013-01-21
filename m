From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/11] Final round of SLES resync patches
Date: Mon, 21 Jan 2013 08:15:42 +0100
Message-ID: <50FCEB1E.8050607@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
	<50F97F4E.6050007@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090601000005050708020908"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50F97F4E.6050007@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------090601000005050708020908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx4-phx2.redhat.com id r0L7FkFD018537

On 01/18/2013 05:58 PM, Xose Vazquez Perez wrote:
> On 01/17/2013 03:59 PM, Hannes Reinecke wrote:
>
>> and this is now the final round of SLES resync patches.
>
> Hannes, I do miss support for HSV3[46]0 devices.
>
Oh. Correct.

Christophe, could you apply the patch?

Thanks.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

--------------090601000005050708020908
Content-Type: text/x-patch;
 name="multipath-add-hp-p6300.patch"
Content-Disposition: attachment;
 filename="multipath-add-hp-p6300.patch"
Content-Transfer-Encoding: 7bit

From 9631beb23e3f873ceac4a80746cd3013891d33b6 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Thu, 28 Jun 2012 18:19:48 +0200
Subject: [PATCH] Add definitions for HP P6300

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index c5b4071..d7292ee 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -133,7 +133,7 @@ static struct hwentry default_hw[] = {
 	{
 		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000 */
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]0",
+		.product       = "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.pgpolicy      = GROUP_BY_PRIO,

--------------090601000005050708020908
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--------------090601000005050708020908--
