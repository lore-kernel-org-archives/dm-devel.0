From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 8/8] dm: dm-target.c Convert  kmalloc + memset  to
 kzalloc
Date: Tue, 24 Jul 2007 05:11:39 -0400 (EDT)
Message-ID: <33136714.1185268299275.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
Reply-To: "Robert P. J. Day" <rpjday@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935224AbXGXJWU@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



-----Original Message-----
>From: Dmitry Monakhov <dmonakhov@openvz.org>
>Sent: Jul 24, 2007 4:59 AM
>To: linux-kernel@vger.kernel.org
>Cc: device-mapper development <dm-devel@redhat.com>
>Subject: [PATCH 8/8] dm: dm-target.c Convert  kmalloc + memset  to kzalloc
>
>Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>---
> drivers/md/dm-target.c |    6 ++----
> 1 files changed, 2 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
>index 477a041..835cf95 100644
>--- a/drivers/md/dm-target.c
>+++ b/drivers/md/dm-target.c
>@@ -88,12 +88,10 @@ void dm_put_target_type(struct target_type *t)
> 
> static struct tt_internal *alloc_target(struct target_type *t)
> {
>-	struct tt_internal *ti = kmalloc(sizeof(*ti), GFP_KERNEL);
>+	struct tt_internal *ti = kzalloc(sizeof(*ti), GFP_KERNEL);
> 
>-	if (ti) {
>-		memset(ti, 0, sizeof(*ti));
>+	if (ti)
> 		ti->tt = *t;
>-	}
> 
> 	return ti;
> }
>-- 
>1.5.2.2
>
>

would it not have made more sense to have submitted all those related,
single-change patches as one patch?

rday
