Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1071C43334
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 17:01:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-Nn77s8MuOZ-1UaQ_WBVRUg-1; Thu, 09 Jun 2022 13:00:58 -0400
X-MC-Unique: Nn77s8MuOZ-1UaQ_WBVRUg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 640FE185A7A4;
	Thu,  9 Jun 2022 17:00:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4BA90C53360;
	Thu,  9 Jun 2022 17:00:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1D87D1947061;
	Thu,  9 Jun 2022 17:00:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 01CC61947040
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Jun 2022 17:00:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E3A39C53361; Thu,  9 Jun 2022 17:00:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DF58EC53360
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 17:00:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C81543815D23
 for <dm-devel@redhat.com>; Thu,  9 Jun 2022 17:00:54 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-g1Tm5yKwOAKVmmG9VntEjQ-1; Thu, 09 Jun 2022 13:00:51 -0400
X-MC-Unique: g1Tm5yKwOAKVmmG9VntEjQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id A15991F992;
 Thu,  9 Jun 2022 17:00:49 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5308313A8C;
 Thu,  9 Jun 2022 17:00:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 6ptMEkEnomK9MQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 09 Jun 2022 17:00:49 +0000
Message-ID: <f0179be809d54aeaaa13eb2edb320542d07d0513.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, "Schremmer, Steven"
 <Steve.Schremmer@netapp.com>
Date: Thu, 09 Jun 2022 19:00:48 +0200
In-Reply-To: <7510d16e-b821-3030-16cf-ef39854109f5@gmail.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
 <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
 <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
 <SN6PR06MB44955631FFA648B74BB939318CD09@SN6PR06MB4495.namprd06.prod.outlook.com>
 <6d6f31c7e9c03eead93cc5b528bcd8979446fc91.camel@suse.com>
 <SN6PR06MB4495843B676A209F9AA0085A8CD99@SN6PR06MB4495.namprd06.prod.outlook.com>
 <f29d01dd-676d-0d1e-77b0-df951fb7f99a@gmail.com>
 <8ab798a93edf33a550f0c78f113d8943d76916b6.camel@suse.com>
 <7510d16e-b821-3030-16cf-ef39854109f5@gmail.com>
User-Agent: Evolution 3.44.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 4/9] multipath-tools: add NetApp E-Series
 NVMe to hardware table
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
Cc: "George, Martin" <Martin.George@netapp.com>,
 Hannes Reinecke <hare@suse.com>,
 ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-06-09 at 18:56 +0200, Xose Vazquez Perez wrote:
> On 6/9/22 18:49, Martin Wilck wrote:
>=20
> > IIUC NetApp's concern is not the generic entry, but the entries
> > mentioning E-Series or it's OEM products in NVMe configuration
> > explicitly. I also have some trouble understanding the concern, but
> > NetApp is in charge of these entries, so I believe we should
> > respect
> > what they're saying.
> >=20
> > With the late patches I submitted, the generic NVMe defaults would
> > work
> > for the NetApp devices without those being explicitly mentioned. I
> > hope
> > this is ok for everyone. Only the no_path_retry setting would get
> > lost,
> > which is acceptable IMO because this is rather an admin setting
> > than
> > product-specific.
>=20
> And now (IMO) it is worse, because NetApp NVMe arrays are under a
> generic config.
>=20
> What do they hate?=A0 just ".product =3D "NetApp E-Series"" ???

I can't speak for Steve, but yes, this is what I understood. The
concern is that someone would read the entry and conclude that this
configuration is officially endorsed and supported by NetApp.
This is why I added the disclaimer in the man page.

Regards,
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

