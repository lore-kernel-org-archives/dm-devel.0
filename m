Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09439C6FD1D
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 11:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679572405;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+QvBOId0VwRLKUDNYAYDnPT31gT5QGqCcS2HZpkoc/I=;
	b=S6d32P42o8GK2PWjiPLj8nj859SJVXupPsaQ+haVj30pQShoIVDNwkLb6TfoAwOOrSEEFf
	9bAzp6CCGWcy6pzmjPeNXEyj/GECdKYQsfczr2H/2aoybUXDkaeQSWInXpHxXlqsYmm5lk
	6BBFpHW5JNaYmsIziRb2DOtaWsI8QQU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-GrC53bvxN1-Ll-q25vG1jA-1; Thu, 23 Mar 2023 07:53:22 -0400
X-MC-Unique: GrC53bvxN1-Ll-q25vG1jA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 425391C09508;
	Thu, 23 Mar 2023 11:53:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 986B818EC7;
	Thu, 23 Mar 2023 11:53:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6FBA41946589;
	Thu, 23 Mar 2023 11:53:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EB3601946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 11:53:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DAB1F40CF916; Thu, 23 Mar 2023 11:53:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D3B7C40CF8F2
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 11:53:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B79E83C0ED67
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 11:53:16 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-246-H_qUYUtKO026jr5aw9KvaQ-1; Thu,
 23 Mar 2023 07:53:15 -0400
X-MC-Unique: H_qUYUtKO026jr5aw9KvaQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 8791722653;
 Thu, 23 Mar 2023 11:53:13 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 59312132C2;
 Thu, 23 Mar 2023 11:53:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id BYjLE6k9HGTLIAAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 23 Mar 2023 11:53:13 +0000
Message-ID: <66ea3909c6446445a64d70eee0c68a6e1f15b33d.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
 <bmarzins@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Thu, 23 Mar 2023 12:53:12 +0100
In-Reply-To: <20230320155550.7326-1-mwilck@suse.com>
References: <20230320155550.7326-1-mwilck@suse.com>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] multipath-tools Makefiles: handle dependency
 files correctly
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Xose, Ben,

when this gets a Reviewed-by, I'd prepare a new submission to
Christophe (unless someone objects).

Martin

On Mon, 2023-03-20 at 16:55 +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> Some generated .d files were not correctly included, and not
> removed with "make dep_clean". Fix it.
>=20
> Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
> =A0libmultipath/Makefile | 4 ++--
> =A0multipathd/Makefile=A0=A0 | 4 ++--
> =A02 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 61aa611..85767ab 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -71,7 +71,7 @@ uninstall:
> =A0clean: dep_clean
> =A0=A0=A0=A0=A0=A0=A0=A0$(Q)$(RM) core *.a *.o *.so *.so.* *.abi nvme-ioc=
tl.c nvme-
> ioctl.h autoconfig.h $(NV_VERSION_SCRIPT)
> =A0
> -include $(wildcard $(OBJS:.o=3D.d))
> +include $(wildcard $(OBJS:.o=3D.d) $(OBJS-T:.o=3D.d))
> =A0
> =A0dep_clean:
> -=A0=A0=A0=A0=A0=A0=A0$(Q)$(RM) $(OBJS:.o=3D.d)
> +=A0=A0=A0=A0=A0=A0=A0$(Q)$(RM) $(OBJS:.o=3D.d) $(OBJS-T:.o=3D.d)
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 9d53132..dca8e10 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -81,7 +81,7 @@ uninstall:
> =A0clean: dep_clean
> =A0=A0=A0=A0=A0=A0=A0=A0$(Q)$(RM) core *.o $(EXEC) $(CLI)
> =A0
> -include $(wildcard $(OBJS:.o=3D.d))
> +include $(wildcard $(OBJS:.o=3D.d) $(CLI_OBJS:.o=3D.d))
> =A0
> =A0dep_clean:
> -=A0=A0=A0=A0=A0=A0=A0$(Q)$(RM) $(OBJS:.o=3D.d)
> +=A0=A0=A0=A0=A0=A0=A0$(Q)$(RM) $(OBJS:.o=3D.d) $(CLI_OBJS:.o=3D.d)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

