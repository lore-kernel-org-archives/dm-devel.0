Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92367C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 07:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657870049;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DlYfUoggUOIHCc/khnNUfPqbDwuuTsRqvwPMjYUxuPc=;
	b=gjUnirsMdV+304/tpw63NxICpixvuzbvrnIcRGbpoiy4lETW5a5/Rk6Vn8JUnOIxBhVpwU
	zZsAg46N374gRY5pxmwx0UOYUuFRW76q+pq7pm7kH/6rMhrtFElbDn2ygii3oglKCOQMzp
	gZ3Kq0il26mGoeEQs2vwdjC9wRgQOGg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-MsVBd64PO82NNMkq574P4Q-1; Fri, 15 Jul 2022 03:27:26 -0400
X-MC-Unique: MsVBd64PO82NNMkq574P4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C260101A58D;
	Fri, 15 Jul 2022 07:27:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2BF2A40E80E0;
	Fri, 15 Jul 2022 07:27:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E75D0194706F;
	Fri, 15 Jul 2022 07:27:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6EB9B19466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 07:27:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4DD2A18EB5; Fri, 15 Jul 2022 07:27:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A21818EAA
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 07:27:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EA1F29AA2EF
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 07:27:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-cRVOFS2oOLuN1WaAy31UkA-1; Fri, 15 Jul 2022 03:27:13 -0400
X-MC-Unique: cRVOFS2oOLuN1WaAy31UkA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id C8BDF1FBB6;
 Fri, 15 Jul 2022 07:27:05 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7618C13754;
 Fri, 15 Jul 2022 07:27:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 4EMjG8kW0WLRCgAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 15 Jul 2022 07:27:05 +0000
Message-ID: <6acc06c9ea278af92003d7c8695f8770e2c8acef.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20220709230709.35516-1-xose.vazquez@gmail.com>
References: <20220709230709.35516-1-xose.vazquez@gmail.com>
Date: Tue, 12 Jul 2022 21:24:12 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.44.2
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 0/2] update hwtable
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
Cc: Zou Ming <zouming.zouming@huawei.com>, chengjike.cheng@huawei.com,
 DM-DEVEL ML <dm-devel@redhat.com>, sunao.sun@huawei.com,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Zhouweigang <zhouweigang09@huawei.com>, jiangtao62@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sun, 2022-07-10 at 01:07 +0200, Xose Vazquez Perez wrote:
> Xose Vazquez Perez (2):
> =A0 multipath-tools: update Huawei OceanStor NVMe vendor id
> =A0 multipath-tools: update "Generic NVMe" vendor regex in hwtable
>=20
> =A0libmultipath/hwtable.c | 4 ++--
> =A01 file changed, 2 insertions(+), 2 deletions(-)

For the set:
Reviewed-by: Martin Wilck <mwilck@suse.com>


>=20
> Cc: <chengjike.cheng@huawei.com>
> Cc: <sunao.sun@huawei.com>
> Cc: <jiangtao62@huawei.com>
> Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
> Cc: Zou Ming <zouming.zouming@huawei.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

