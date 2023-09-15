Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB43EE6459
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 11:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694778399;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FZLS6MnwsfpvGxqWUtAnAF+Y1iDOTO74IYozG7ky/w0=;
	b=SZEI6ALuhDDhI+3OSFem6bGAbkgvVSPPJa/4qZVDVjWXcfmOGe5oUKUttxJ1ZGDTMqBpZN
	Six8kh7EsxJfsEUCFtaEgCh1ZfZ0yW36m48SDnNSHAVcH8dd+gNTAWCn7YMybF9F2Z8lLo
	xXqoEUvSxx6EtJ2LJdFBTAN2DCbusis=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-zEHrWWi3OHK7lj-_rwyRTQ-1; Fri, 15 Sep 2023 07:46:36 -0400
X-MC-Unique: zEHrWWi3OHK7lj-_rwyRTQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80826101A550;
	Fri, 15 Sep 2023 11:46:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 505742026D68;
	Fri, 15 Sep 2023 11:46:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 02F751946594;
	Fri, 15 Sep 2023 11:46:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5423A1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 11:44:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1CC5E2026D68; Fri, 15 Sep 2023 11:43:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1524A2026D4B
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 11:43:53 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B83B8811E7E
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 11:43:53 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-RnVcur5RMlOvk4-rrd1fbQ-1; Fri,
 15 Sep 2023 07:43:52 -0400
X-MC-Unique: RnVcur5RMlOvk4-rrd1fbQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 750DC21865;
 Fri, 15 Sep 2023 11:43:50 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3FECD13251;
 Fri, 15 Sep 2023 11:43:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id SmyADXZDBGXEKQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 11:43:50 +0000
Message-ID: <3e3992fede771bd4ac30ab3aa8d061fce3d80486.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Muneendra Kumar <muneendra.kumar@broadcom.com>, dm-devel@redhat.com, 
 bmarzins@redhat.com
Date: Fri, 15 Sep 2023 13:43:49 +0200
In-Reply-To: <20230914215546.2875790-1-muneendra.kumar@broadcom.com>
References: <20230914215546.2875790-1-muneendra.kumar@broadcom.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello Muneendra,

On Thu, 2023-09-14 at 14:55 -0700, Muneendra Kumar wrote:
> From: Muneendra <muneendra.kumar@broadcom.com>
>=20
> This patch adds the support to handle FPIN-Li for FC-NVMe.
> On receiving the FPIN-Li events this patch moves the devices paths
> which are affected due to link integrity to marginal path groups.
> The paths which are set to marginal path group will be unset
> on receiving the RSCN events
>=20
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>

Thanks! This looks mostly good to me, some comments below.


> ---
> =A0multipathd/fpin_handlers.c | 177 ++++++++++++++++++++++++++++-------
> --
> =A01 file changed, 136 insertions(+), 41 deletions(-)
>=20
> diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
> index aa0f63c9..94f390ec 100644
> --- a/multipathd/fpin_handlers.c
> +++ b/multipathd/fpin_handlers.c
> @@ -203,61 +203,153 @@ fpin_add_marginal_dev_info(uint32_t host_num,
> char *devname)
> =A0}
> =A0
> =A0/*
> - * This function goes through the vecs->pathvec, and for
> - * each path, check that the host=A0 number,
> - * the target WWPN associated with the path matches
> - * with the els wwpn and sets the path and port state to
> + * This function compares Transport Address Controller Port pn,
> + * Host Transport Address Controller Port pn with the els wwpn
> ,attached_wwpn
> + * and return 0 on success
> + */
> +static int=A0 extract_nvme_addresses_chk_path_pwwn(const char
> *address,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uint64_t els_wwpn, uint64_t=
 els_attached_wwpn)
> +
> +{
> +=A0=A0=A0=A0=A0=A0=A0uint64_t traddr;
> +=A0=A0=A0=A0=A0=A0=A0uint64_t host_traddr;
> +
> +=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0 *=A0 Find the position of "traddr=3D" and "host_tr=
addr=3D"
> +=A0=A0=A0=A0=A0=A0=A0 *=A0 and the address will be in the below format
> +=A0=A0=A0=A0=A0=A0=A0 *=A0 "traddr=3Dnn-0x200400110dff9400:pn-0x20040011=
0dff9400,
> +=A0=A0=A0=A0=A0=A0=A0 *=A0 host_traddr=3Dnn-0x200400110dff9400:pn-0x2004=
00110dff9400"
> +=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0const char *traddr_start =3D strstr(address, "tradd=
r=3D");
> +=A0=A0=A0=A0=A0=A0=A0const char *host_traddr_start =3D strstr(address,
> "host_traddr=3D");
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!traddr_start || !host_traddr_start)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> +
> +=A0=A0=A0=A0=A0=A0=A0/* Extract traddr pn */
> +=A0=A0=A0=A0=A0=A0=A0if (sscanf(traddr_start, "traddr=3Dnn-%*[^:]:pn-%" =
SCNx64,
> &traddr) !=3D 1)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> +
> +=A0=A0=A0=A0=A0=A0=A0/* Extract host_traddr pn*/
> +=A0=A0=A0=A0=A0=A0=A0if (sscanf(host_traddr_start, "host_traddr=3Dnn-%*[=
^:]:pn-%"
> SCNx64,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0&host_traddr) !=3D 1)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> +=A0=A0=A0=A0=A0=A0=A0condlog(4, "traddr 0x%lx hosttraddr 0x%lx els_wwpn =
0x%lx
> els_host_traddr 0x%lx",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0tra=
ddr, host_traddr,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
_wwpn, els_attached_wwpn);
> +=A0=A0=A0=A0=A0=A0=A0if ((host_traddr =3D=3D els_attached_wwpn) && (trad=
dr =3D=3D
> els_wwpn))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0return -EINVAL;

Please don't return -EINVAL to indicate that the addresses don't match.
The function should return 1 (match) or 0 (no match) or a negative
error code if something is actually wrong.


> +}
> +
> +/*
> + * This function check that the Transport Address Controller Port
> pn,
> + * Host Transport Address Controller Port pn associated with the
> path matches
> + * with the els wwpn ,attached_wwpn and sets the path state to
> =A0 * Marginal
> =A0 */
> -static int=A0 fpin_chk_wwn_setpath_marginal(uint16_t host_num,=A0 struct
> vectors *vecs,
> +static void fpin_check_set_nvme_path_marginal(uint16_t host_num,
> struct path *pp,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uint64_t els_wwpn, uint64_t=
 attached_wwpn)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct udev_device *ctl =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0const char *address =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0ctl =3D udev_device_get_parent_with_subsystem_devty=
pe(pp->udev,
> "nvme", NULL);
> +=A0=A0=A0=A0=A0=A0=A0if (ctl =3D=3D NULL) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: No parent d=
evice for ", pp->dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0address =3D udev_device_get_sysattr_value(ctl, "add=
ress");
> +=A0=A0=A0=A0=A0=A0=A0if (!address) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: unable to g=
et the address ", pp-
> >dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0condlog(4, "\n address %s: dev :%s\n", address, pp-=
>dev);
> +=A0=A0=A0=A0=A0=A0=A0ret =3D extract_nvme_addresses_chk_path_pwwn(addres=
s, els_wwpn,
> attached_wwpn);
> +=A0=A0=A0=A0=A0=A0=A0if (ret < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +=A0=A0=A0=A0=A0=A0=A0ret =3D fpin_path_setmarginal(pp);
> +=A0=A0=A0=A0=A0=A0=A0if (ret < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +=A0=A0=A0=A0=A0=A0=A0fpin_add_marginal_dev_info(host_num, pp->dev);

I think that you should call fpin_add_marginal_dev_info() first, and
only set the path to marginal state if it has succeeded.
I realize the same applies to the SCSI code flow.

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

