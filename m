Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05ABDE71072
	for <dm-devel@archiver.kernel.org>; Thu, 21 Sep 2023 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695305577;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zyd2o44ndzI1hpqCOUXMQigbpA+B8Y+nouUOb05r4Z8=;
	b=BqjbTn0fIUpoe1/+f/+dUa7m1S3RY9TR9JTAKJ+HAmD1fqlN2o1eyREWRxIAHwZSkr2NZx
	9x5nHuK6HODoyZSKWQEkw1LK3VNZ4iM0PY2RRQnTPLA8fBg89YEYASlQhVRnzEcY6AlAwu
	mi8uKkFv2o68MzTcqZvmzgQpqJoK5qY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-NdzdqGusM22gEJcTGIn6Mw-1; Thu, 21 Sep 2023 10:12:51 -0400
X-MC-Unique: NdzdqGusM22gEJcTGIn6Mw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E741185A790;
	Thu, 21 Sep 2023 14:12:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4BA84C158BA;
	Thu, 21 Sep 2023 14:12:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 01DA11946595;
	Thu, 21 Sep 2023 14:12:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2212D1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Sep 2023 14:09:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3AE910F1BE8; Thu, 21 Sep 2023 14:09:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EBD5210F1BE7
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 14:09:20 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7BF4803DBD
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 14:09:20 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-HTEhYpCwNbCx6pvzA2gQuw-1; Thu,
 21 Sep 2023 10:09:17 -0400
X-MC-Unique: HTEhYpCwNbCx6pvzA2gQuw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 6FCF7338AC;
 Thu, 21 Sep 2023 14:09:15 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3DDFF13513;
 Thu, 21 Sep 2023 14:09:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id TohKDYtODGX0TQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 21 Sep 2023 14:09:15 +0000
Message-ID: <a628e5d3a414f0675ba3604f30e2545f5c392c20.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Muneendra Kumar <muneendra.kumar@broadcom.com>, dm-devel@redhat.com, 
 bmarzins@redhat.com
Date: Thu, 21 Sep 2023 16:09:14 +0200
In-Reply-To: <20230921034115.3118511-1-muneendra.kumar@broadcom.com>
References: <20230921034115.3118511-1-muneendra.kumar@broadcom.com>
User-Agent: Evolution 3.48.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-09-20 at 20:41 -0700, Muneendra Kumar wrote:
> From: Muneendra <muneendra.kumar@broadcom.com>
>=20
> =A0=A0=A0 This patch adds the support to handle FPIN-Li for FC-NVMe.
> =A0=A0=A0 On receiving the FPIN-Li events this patch moves the devices
> paths
> =A0=A0=A0 which are affected due to link integrity to marginal path group=
s.
> =A0=A0=A0 The paths which are set to marginal path group will be unset
> =A0=A0=A0 on receiving the RSCN events
>=20
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>


Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

