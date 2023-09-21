Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1326AE7108D
	for <dm-devel@archiver.kernel.org>; Thu, 21 Sep 2023 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695310260;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b0FTJafh2jtvlidCrCidY7NCEYxy/6UgWzjcLVg2BO0=;
	b=bc2tgtGotVl3bMg/IvdHODUma13ss6s5BLMCiU0NPPxSdL3eFzI2hFUAGSwl8gRmlS04m+
	N3BdnBKTaTKvVTQhvAyc77JOWGJmJIaI1L1hrT+ZrDs2Lte81FZo4KvV6wPCIbgB0tAraF
	mn/oMTnGjxyXq9n3siJVU7575uGmWSY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-689-fcjZtXnBMpOikVcepe8oEQ-1; Thu, 21 Sep 2023 11:30:57 -0400
X-MC-Unique: fcjZtXnBMpOikVcepe8oEQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 534B4185A78E;
	Thu, 21 Sep 2023 15:30:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DEC089A;
	Thu, 21 Sep 2023 15:30:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 921091946595;
	Thu, 21 Sep 2023 15:30:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F15ED1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Sep 2023 15:29:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C17FB492B05; Thu, 21 Sep 2023 15:29:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9C28492C37
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 15:29:26 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CF9D811E7D
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 15:29:26 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-30-NvmE-oHXMDuH6w0hooTpfw-1; Thu,
 21 Sep 2023 11:29:22 -0400
X-MC-Unique: NvmE-oHXMDuH6w0hooTpfw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 7B5653368C;
 Thu, 21 Sep 2023 15:29:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4EDFB134B0;
 Thu, 21 Sep 2023 15:29:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id o0vAEVFhDGUxeAAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 21 Sep 2023 15:29:21 +0000
Message-ID: <ebda40ae4b189ee2d6993d0ef2b1ca47aae34f3a.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Muneendra Kumar <muneendra.kumar@broadcom.com>, dm-devel@redhat.com, 
 bmarzins@redhat.com
Date: Thu, 21 Sep 2023 17:29:20 +0200
In-Reply-To: <a628e5d3a414f0675ba3604f30e2545f5c392c20.camel@suse.com>
References: <20230921034115.3118511-1-muneendra.kumar@broadcom.com>
 <a628e5d3a414f0675ba3604f30e2545f5c392c20.camel@suse.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2] multipathd: Added support to handle
 FPIN-Li events for FC-NVMe
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-09-21 at 16:09 +0200, Martin Wilck wrote:
> On Wed, 2023-09-20 at 20:41 -0700, Muneendra Kumar wrote:
> > From: Muneendra <muneendra.kumar@broadcom.com>
> >=20
> > =A0=A0=A0 This patch adds the support to handle FPIN-Li for FC-NVMe.
> > =A0=A0=A0 On receiving the FPIN-Li events this patch moves the devices
> > paths
> > =A0=A0=A0 which are affected due to link integrity to marginal path
> > groups.
> > =A0=A0=A0 The paths which are set to marginal path group will be unset
> > =A0=A0=A0 on receiving the RSCN events
> >=20
> > Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>

There was a minor compilation error for 32 bit architectures (%lx vs
%llx format specifier), which I've fixed on my queue branch:

https://github.com/openSUSE/multipath-tools/tree/queue

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

