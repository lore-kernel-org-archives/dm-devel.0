Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F095CE79AE
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 07:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695194837;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=RWQ4IP3rNCYTZOQ3YbfUpXoRtHisKOUdAACemhnVjsc=;
	b=d7138tl/liB8jGtEaEhd5RP+FapiHmA/lUWzJsRVbhvFfr1eDV1u+d1WtXUD5E3mTbDRym
	eqbuqG3xW29EgGGzJM9rPTGBknDf+fcz2TsJzxlvz46uZpn28IVgLEIH42zeZAFewzTDI7
	fLylHECnBGBFeCkONO0BmBLzh+hmOXE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-z6gY769QO16e3JigNMIqvQ-1; Wed, 20 Sep 2023 03:27:08 -0400
X-MC-Unique: z6gY769QO16e3JigNMIqvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D2221875048;
	Wed, 20 Sep 2023 07:27:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 502E720268C8;
	Wed, 20 Sep 2023 07:27:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0E3B9194658F;
	Wed, 20 Sep 2023 07:27:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B620194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 05:07:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 04B81140E962; Wed, 20 Sep 2023 05:07:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F1072140E950
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 05:07:18 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA632802D35
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 05:07:18 +0000 (UTC)
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com
 [209.85.210.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-A_IE10xoOfyf4sjk6q3KbA-1; Wed, 20 Sep 2023 01:07:13 -0400
X-MC-Unique: A_IE10xoOfyf4sjk6q3KbA-1
Received: by mail-pf1-f174.google.com with SMTP id
 d2e1a72fcca58-690ba63891dso1725913b3a.2
 for <dm-devel@redhat.com>; Tue, 19 Sep 2023 22:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=broadcom.com; s=google; t=1695186432; x=1695791232; darn=redhat.com;
 h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
 :references:from:from:to:cc:subject:date:message-id:reply-to;
 bh=S+ZgL1NFMc0E7k5YU69gOk6saC2YzaTRhl55Gi7YmDQ=;
 b=EtoEQYePNdfD+2zXZL4sM7azT83c+xeYx2ci5cGtXbQ7zwf+lDNHcfA/nPkSfXtzXs
 9SU5joQXR0JF90F0iftR2/Qn7hdlb2XtvtaVuYbglm4Y0ljVwUBK5D2KE8471YhTLxNB
 6KKAi8guDQV1HvxX4jRwMbTEEqvrgcFOuJQRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695186432; x=1695791232;
 h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
 :references:from:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=S+ZgL1NFMc0E7k5YU69gOk6saC2YzaTRhl55Gi7YmDQ=;
 b=ppfdKNwDOSkG5KM7kDrAsLVqWUsYeDvrwsvRpZCjrsR2r3+J2hCPcFcNAN63iUDrQY
 ka38QtvITVNPFAELG0yfErLyC2P1p5zexK71AFnI72qjvs7IjymsJ+DyAt5RLBejvlN0
 UcMEsFuPleIp+inXM+nW5eFidA/zXozkQE4tmcJlJJJvBGi0qplPBjlWlHqDmBxZMN8U
 y2HLOH0HtumOIbULP/M/veIRSxR4peLAnRwaMt4hy3ac46s0iHOaNNxifYrIsPhoYrTA
 iz6U7xLh/oteWBUYa6WCGzdm7BBkj44HAkGRWTOhzpwh3Z/yXnwW8ocjt2FniqxIWDL0
 vfyA==
X-Gm-Message-State: AOJu0Yww0ABFfFWILfYFhwB9EcuQbtRlNBqo35MJuMHRzQ0bGTpxyZmH
 JOJrqsy3D87KmLIiIj+QB62A/4gvbACgJdri6Qf77cd/Lq3P/ppY+63DsTzTMciu7MuHMf5FXWr
 buA/mCxY94yDQhNsnTnZRaFZlYZ0WCA==
X-Google-Smtp-Source: AGHT+IGVdVXb3B22ZjyohUYdubgRUpqcqcnPXIJtXpfDkgL19Zr+49VWSETHA2YwRv3Qnt82E2YzA0hR9839CPjvwAY=
X-Received: by 2002:a05:6a20:4323:b0:14e:b4d5:782d with SMTP id
 h35-20020a056a20432300b0014eb4d5782dmr1688764pzk.2.1695186431939; Tue, 19 Sep
 2023 22:07:11 -0700 (PDT)
From: Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <20230914215546.2875790-1-muneendra.kumar@broadcom.com>
 <3e3992fede771bd4ac30ab3aa8d061fce3d80486.camel@suse.com>
In-Reply-To: <3e3992fede771bd4ac30ab3aa8d061fce3d80486.camel@suse.com>
MIME-Version: 1.0
Thread-Index: AQJDwK8C4Wyc/KcI9Y8LixUH89+uZQIgbXQQrz57CkA=
Date: Wed, 20 Sep 2023 10:37:08 +0530
Message-ID: <1b0b2db9765da00d92ba132b9abaf520@mail.gmail.com>
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com, bmarzins@redhat.com
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 20 Sep 2023 07:19:02 +0000
Subject: Re: [dm-devel] [PATCH] multipathd: Added support to handle FPIN-Li
 events for FC-NVMe
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: mkumar@redhat.com
Content-Type: multipart/mixed; boundary="===============8379118528477717270=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4

--===============8379118528477717270==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000001fa8a50605c3592e"

--0000000000001fa8a50605c3592e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Martin,
Thanks for the review.
I will incorporate your review comments and will post the v2 soon.

Regards,
Muneendra.

-----Original Message-----
From: Martin Wilck <mwilck@suse.com>
Sent: Friday, September 15, 2023 5:14 PM
To: Muneendra Kumar <muneendra.kumar@broadcom.com>; dm-devel@redhat.com;
bmarzins@redhat.com
Cc: mkumar@redhat.com
Subject: Re: [PATCH] multipathd: Added support to handle FPIN-Li events
for FC-NVMe

Hello Muneendra,

On Thu, 2023-09-14 at 14:55 -0700, Muneendra Kumar wrote:
> From: Muneendra <muneendra.kumar@broadcom.com>
>
> This patch adds the support to handle FPIN-Li for FC-NVMe.
> On receiving the FPIN-Li events this patch moves the devices paths
> which are affected due to link integrity to marginal path groups.
> The paths which are set to marginal path group will be unset on
> receiving the RSCN events
>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

Thanks! This looks mostly good to me, some comments below.


> ---
> =C2=A0multipathd/fpin_handlers.c | 177 ++++++++++++++++++++++++++++------=
-
> --
> =C2=A01 file changed, 136 insertions(+), 41 deletions(-)
>
> diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
> index aa0f63c9..94f390ec 100644
> --- a/multipathd/fpin_handlers.c
> +++ b/multipathd/fpin_handlers.c
> @@ -203,61 +203,153 @@ fpin_add_marginal_dev_info(uint32_t host_num,
> char *devname)
> =C2=A0}
>
> =C2=A0/*
> - * This function goes through the vecs->pathvec, and for
> - * each path, check that the host=C2=A0 number,
> - * the target WWPN associated with the path matches
> - * with the els wwpn and sets the path and port state to
> + * This function compares Transport Address Controller Port pn,
> + * Host Transport Address Controller Port pn with the els wwpn
> ,attached_wwpn
> + * and return 0 on success
> + */
> +static int=C2=A0 extract_nvme_addresses_chk_path_pwwn(const char
> *address,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0uint64_t els_wwpn, uint64_t els_attached_wwpn)
> +
> +{
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint64_t traddr;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint64_t host_traddr;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/*
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=C2=A0 Find the position of =
"traddr=3D" and "host_traddr=3D"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=C2=A0 and the address will =
be in the below format
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=C2=A0 "traddr=3Dnn-0x200400=
110dff9400:pn-0x200400110dff9400,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *=C2=A0 host_traddr=3Dnn-0x20=
0400110dff9400:pn-0x200400110dff9400"
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const char *traddr_start =3D s=
trstr(address, "traddr=3D");
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const char *host_traddr_start =
=3D strstr(address,
> "host_traddr=3D");
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!traddr_start || !host_tra=
ddr_start)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return -EINVAL;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Extract traddr pn */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (sscanf(traddr_start, "trad=
dr=3Dnn-%*[^:]:pn-%" SCNx64,
> &traddr) !=3D 1)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return -EINVAL;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Extract host_traddr pn*/
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (sscanf(host_traddr_start, =
"host_traddr=3Dnn-%*[^:]:pn-%"
> SCNx64,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&host_traddr) !=3D 1)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return -EINVAL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0condlog(4, "traddr 0x%lx hostt=
raddr 0x%lx els_wwpn 0x%lx
> els_host_traddr 0x%lx",
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0traddr, h=
ost_traddr,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0els_wwpn,=
 els_attached_wwpn);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if ((host_traddr =3D=3D els_at=
tached_wwpn) && (traddr =3D=3D
> els_wwpn))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return 0;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return -EINVAL;

Please don't return -EINVAL to indicate that the addresses don't match.
The function should return 1 (match) or 0 (no match) or a negative error
code if something is actually wrong.


> +}
> +
> +/*
> + * This function check that the Transport Address Controller Port
> pn,
> + * Host Transport Address Controller Port pn associated with the
> path matches
> + * with the els wwpn ,attached_wwpn and sets the path state to
> =C2=A0 * Marginal
> =C2=A0 */
> -static int=C2=A0 fpin_chk_wwn_setpath_marginal(uint16_t host_num,=C2=A0 =
struct
> vectors *vecs,
> +static void fpin_check_set_nvme_path_marginal(uint16_t host_num,
> struct path *pp,
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0uint64_t els_wwpn, uint64_t attached_wwpn) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct udev_device *ctl =3D NU=
LL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const char *address =3D NULL;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int ret =3D 0;
> +
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ctl =3D udev_device_get_parent=
_with_subsystem_devtype(pp->udev,
> "nvme", NULL);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ctl =3D=3D NULL) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0condlog(2, "%s: No parent device for ", pp->dev);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0address =3D udev_device_get_sy=
sattr_value(ctl, "address");
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!address) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0condlog(2, "%s: unable to get the address ", pp-
> >dev);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0condlog(4, "\n address %s: dev=
 :%s\n", address, pp->dev);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D extract_nvme_addresses=
_chk_path_pwwn(address, els_wwpn,
> attached_wwpn);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret < 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D fpin_path_setmarginal(=
pp);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret < 0)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0return;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0fpin_add_marginal_dev_info(hos=
t_num, pp->dev);

I think that you should call fpin_add_marginal_dev_info() first, and only
set the path to marginal state if it has succeeded.
I realize the same applies to the SCSI code flow.

Regards,
Martin

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--0000000000001fa8a50605c3592e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQeAYJKoZIhvcNAQcCoIIQaTCCEGUCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3PMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVcwggQ/oAMCAQICDEnRSel9Ku9INR0BhDANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAxMTEyMDBaFw0yNTA5MTAxMTEyMDBaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGjAYBgNVBAMTEU11bmVlbmRyYSBLdW1hciBNMSswKQYJKoZI
hvcNAQkBFhxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAtQQvnxcsdOGW38ZD+Gdkf+xOxem4VKla3ycybq0cdHFrxEezBWW85kI9lXax
xNi6c/2Km1c55KnNVb90FgbQa+b3gh4+r3RqfuwhufYputOUQviJRVSQG761XsXlE7EO6qksW6wf
x64zL6TlQwTu1SSbMFqjBoqrDV5+//TLqVAb2xIzfI8Y8fOCtnBnPjKEgv2oulIhQO8BBv/xsen/
ys9fYL+GlV3PS9wS3h0MI90cAfs5ZQjER5eWqMBARhfrW70fFVMSdZzBpXljqRjD+GOJm711FgvN
RsH9iq2Ndn7XY7jpnxND6cwSKympBXWuvQ54YyFDLr0m9eC6BNU5bQIDAQABo4IB3TCCAdkwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAnBgNVHREEIDAegRxtdW5lZW5kcmEua3VtYXJAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsG
AQUFBwMEMB8GA1UdIwQYMBaAFJYz0eZYF1s0dYqBVmTVvkjeoY/PMB0GA1UdDgQWBBTJvvnIS4Qf
Z+gEeC51xAB2l3lqOzANBgkqhkiG9w0BAQsFAAOCAQEAE6G8pLIpwrdO0Dmi603StqsNLN3t3i5m
SU/J+ZHnSeVNQFmfJjYSlZHSeAYrw+nsLEw08xiT4N2dPLbnowDKw0cVDRV5hL6+Uis2nqNkp9Kk
dXMVNlGeqGqBo98QRdRdzLgc/3FBQp3XIGUo2VDOMYW/RPbI1muHQOBKaVx4q8jqitNbqThvZkt/
t8KBiojEq4d7/scDRRtEsaL6Hl7cAYNMrS5EpijZrYjNYercaQNHcHP38l/XM9n36jllylt12koc
Dfj3D142STRRnexoNURmkc9EAKyZPRv/JRGz6YP0i2y1JqgpjF8CggD2osV3pA9e8ecXWQ7/ZJly
zHlFgjGCAm0wggJpAgEBMGswWzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExMTAvBgNVBAMTKEdsb2JhbFNpZ24gR0NDIFIzIFBlcnNvbmFsU2lnbiAyIENBIDIwMjACDEnR
Sel9Ku9INR0BhDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg4MmvxXSqYk5WbM7S
kx5jyuKxh19Do+T8NShGszux8pMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjMwOTIwMDUwNzEyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAGsSimTY7Cy+V6vP5w/GodoI0v7fe47eeAa0
w0lepmBRVC6ue4wQpdmXiyVqgAAtllFMEK66btUtH43u4K281eW2y3ntqLc2mdtNELn4plOxKMab
lzHItgRKp5io3yBtUNrretv1fUXMq3li1b3hr4WeH8r65OFOysEy3pMaVm7Tbrylin7aj1o3+RSz
Ag2LSv0m3bZQEoY5t/Z5HuW44t5tT//hJNEBOuowdy706y/HxSH8Lt/uBENYTI9Iu4T0tikuTi9v
VMCW/6bsoEFRc10KdpSFqnkem1D0DRqDdCxoTYE/7Ev0Mkn19/mfHCTvE5CJcB9LhE1DVxTH/yIL
N4g=
--0000000000001fa8a50605c3592e--


--===============8379118528477717270==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============8379118528477717270==--

