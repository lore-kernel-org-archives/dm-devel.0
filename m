Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A503C76195
	for <dm-devel@archiver.kernel.org>; Tue, 28 Mar 2023 07:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679989977;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TGEBZMbRuInDhWe2fPoOxlUF4n2ARqBE3pYgwts+oqs=;
	b=dN7kdw8OnEPGke522XlqTqZoMrgyjuSG676cAgzrD9He4nFt7pGQuaoExHdDQyn3CsBnus
	OmJ2NgPH5Udx3/hNTVPiNNbFOLoQLKwy11LqgfTYi0F+apmUzupYQzHweOs7PSD8CRUZLA
	9riLy6XgYmuEiAg5UyxrT43cp2hvI48=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-cM4EZf0gOFqKCGj_yiZSYQ-1; Tue, 28 Mar 2023 03:52:54 -0400
X-MC-Unique: cM4EZf0gOFqKCGj_yiZSYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 111851C04346;
	Tue, 28 Mar 2023 07:52:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDFBC1121330;
	Tue, 28 Mar 2023 07:52:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A804D194658D;
	Tue, 28 Mar 2023 07:52:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 256F6194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Mar 2023 07:52:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E2BB714171BC; Tue, 28 Mar 2023 07:52:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA9E014171BB
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 07:52:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDB333C02183
 for <dm-devel@redhat.com>; Tue, 28 Mar 2023 07:52:49 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-394-CJw1QKSzPlClmmdRyjzhPg-1; Tue,
 28 Mar 2023 03:52:48 -0400
X-MC-Unique: CJw1QKSzPlClmmdRyjzhPg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id D59CE1FD81;
 Tue, 28 Mar 2023 07:52:46 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8D7931390D;
 Tue, 28 Mar 2023 07:52:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id DC/+IM6cImR9DwAAMHmgww
 (envelope-from <mwilck@suse.com>); Tue, 28 Mar 2023 07:52:46 +0000
Message-ID: <207a735ad9023da3d13b434ba70e34a5406f310c.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: dgilbert@interlog.com, Hannes Reinecke <hare@suse.de>
Date: Tue, 28 Mar 2023 09:52:45 +0200
In-Reply-To: <3f02a075-cc30-5584-704b-da88be1d6b31@interlog.com>
References: <20230327132459.29531-1-mwilck@suse.com>
 <3f02a075-cc30-5584-704b-da88be1d6b31@interlog.com>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [RFC PATCH 0/3] sg3_utils: udev rules: restrict use
 of ambiguous device IDs
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
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>, Franck Bui <fbui@suse.de>,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-03-27 at 19:58 -0400, Douglas Gilbert wrote:
>=20
> Lets see if anything happens. Applied as sg3_utils revision 1019 and
> pushed to https://github.com/doug-gilbert/sg3_utils=A0.
>=20
> Didn't see any effect on an Ubuntu 22.10 when sg3_utils deb package
> built and installed. No sign of 00-scsi-sg3_config.rules being placed
> anywhere by Ubuntu. Does Suse install those rules?

No, not yet. That's why I sent these patches, I intend to get rid of
the legacy symlinks on openSUSE with upstream's blessing.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

