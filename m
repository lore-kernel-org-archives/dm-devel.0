Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37425C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 20:03:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-yXQlHsxmNuuAUi0isqs4-g-1; Thu, 24 Mar 2022 16:03:52 -0400
X-MC-Unique: yXQlHsxmNuuAUi0isqs4-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65C893C01DA5;
	Thu, 24 Mar 2022 20:03:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B954814582EE;
	Thu, 24 Mar 2022 20:03:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 17843194034B;
	Thu, 24 Mar 2022 20:03:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BDDB01940341
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 20:03:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 94CA914582F6; Thu, 24 Mar 2022 20:03:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9093A14582EE
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 20:03:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 726CE1C05AE4
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 20:03:45 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-S0sCbAhFP4O_QgrkwGdmJg-1; Thu, 24 Mar 2022 16:03:43 -0400
X-MC-Unique: S0sCbAhFP4O_QgrkwGdmJg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 23E10210F4;
 Thu, 24 Mar 2022 20:03:42 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DC2CB12FF7;
 Thu, 24 Mar 2022 20:03:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id YImEM53OPGLbEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 24 Mar 2022 20:03:41 +0000
Message-ID: <067497de85adb17c3807ae083879a95c002c4d98.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Christophe Varoqui
 <christophe.varoqui@opensvc.com>
Date: Thu, 24 Mar 2022 21:03:41 +0100
In-Reply-To: <20220324173039.6155-1-xose.vazquez@gmail.com>
References: <20220324173039.6155-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] multipath-tools: add Martin and Benjamin as
 maintainers
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-03-24 at 18:30 +0100, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

I'm fine with this... Christophe remains the only person who commits to
the main repository.

Christophe, do you agree?

Regards,
Martin


> ---
> =A0README.md | 6 ++++--
> =A01 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/README.md b/README.md
> index 15478625..10ddf463 100644
> --- a/README.md
> +++ b/README.md
> @@ -129,10 +129,12 @@ pre-0.4.5:
> https://web.archive.org/web/20070309224034/http://christophe.varoqui.
> =A0post-0.4.5:
> https://github.com/opensvc/multipath-tools/commits/master
> =A0
> =A0
> -Maintainer
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Maintainers
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =A0
> =A0Christophe Varoqui <christophe.varoqui@opensvc.com>
> +Benjamin Marzinski <bmarzins@redhat.com>
> +Martin Wilck <mwilck@suse.com>
> =A0Device-mapper development mailing list <dm-devel@redhat.com>
> =A0
> =A0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

