Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 050FAC4332F
	for <dm-devel@archiver.kernel.org>; Fri,  2 Dec 2022 17:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670003856;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A5hi6sM+2ruja5lEzrdcKrNWMCCz8rYnm1o5l1Wozgo=;
	b=OU/X1yVfkRQQPz8+klECxz/HK2yelHLlN7ydM8PpQD8lUJ3OJeVEN6XKZvgxaleI9fE+95
	a5ph65I4l6wDlThUUPPRxdoKSPQeYk+zEW8Jz+a5xR446RZH3bPVjF4LKPIc+pfnGj4bAt
	jwE5/C2vg8YpAGfxzTrx+dLbnLCGMfI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-GxpABT5zMgaJqWwgKq1XIw-1; Fri, 02 Dec 2022 12:57:33 -0500
X-MC-Unique: GxpABT5zMgaJqWwgKq1XIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1BC738173CB;
	Fri,  2 Dec 2022 17:57:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9930763A79;
	Fri,  2 Dec 2022 17:57:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 692B1194658F;
	Fri,  2 Dec 2022 17:57:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A8C8F1946587
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Dec 2022 17:57:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D599640C83EC; Fri,  2 Dec 2022 17:57:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE62940C83BB
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 17:57:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0C7C38173CB
 for <dm-devel@redhat.com>; Fri,  2 Dec 2022 17:57:23 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-398-5yXgN4SsNrePYw6q3m1O0A-1; Fri,
 02 Dec 2022 12:57:19 -0500
X-MC-Unique: 5yXgN4SsNrePYw6q3m1O0A-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 4D6F321C49;
 Fri,  2 Dec 2022 17:57:18 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 1BBD013644;
 Fri,  2 Dec 2022 17:57:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap1.suse-dmz.suse.de with ESMTPSA id jmzxBH48imNwUwAAGKfGzw
 (envelope-from <mwilck@suse.com>); Fri, 02 Dec 2022 17:57:18 +0000
Message-ID: <90467d9459a95a6910f55f3e0f93163a6541429a.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
 <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 02 Dec 2022 18:57:17 +0100
In-Reply-To: <1d35c16a-105f-a2aa-ca5d-a952e505d9b0@gmail.com>
References: <20221201103238.2601-1-mwilck@suse.com>
 <20221201103238.2601-2-mwilck@suse.com>
 <1d35c16a-105f-a2aa-ca5d-a952e505d9b0@gmail.com>
User-Agent: Evolution 3.46.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 2/2] multipath.conf(5): improve documentation
 of dev_loss_tmo
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
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-12-02 at 18:31 +0100, Xose Vazquez Perez wrote:
> On 12/1/22 11:32, mwilck@suse.com=A0wrote:
>=20
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > The statement that the default is 600 is wrong in most cases.
> > Improve the description of the default and the dependency of this
> > parameter on other parameters.
>=20
> I did change this patch to move "default value" to bottom.

The problem is that there is no easily explained default value for this
parameter. Nice as the common "default value" format is, it doesn't
apply=A0here.

If you have a suggestion for improving the formatting or wording,
please speak up.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

