Return-Path: <SRS0=NHnu=EJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF70C2D0A3
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 09:00:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6C27422403
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 09:00:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C27422403
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-6R77URjINt2B0tPvVpkO_A-1; Tue, 03 Nov 2020 04:00:19 -0500
X-MC-Unique: 6R77URjINt2B0tPvVpkO_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAF2B80364B;
	Tue,  3 Nov 2020 09:00:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8112A5B4D6;
	Tue,  3 Nov 2020 09:00:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4B8FE1800B70;
	Tue,  3 Nov 2020 09:00:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A390Bp5018980 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 3 Nov 2020 04:00:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E5682110F0A8; Tue,  3 Nov 2020 09:00:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E09F7110F0AB
	for <dm-devel@redhat.com>; Tue,  3 Nov 2020 09:00:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3678811E83
	for <dm-devel@redhat.com>; Tue,  3 Nov 2020 09:00:08 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [51.163.158.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-417-IAhjIOKQNaq8YoI4vEvWwA-1;
	Tue, 03 Nov 2020 04:00:04 -0500
X-MC-Unique: IAhjIOKQNaq8YoI4vEvWwA-1
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur03lp2050.outbound.protection.outlook.com [104.47.9.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-27-9Y_cUZlCOveu3Jour73EKw-1; Tue, 03 Nov 2020 10:00:02 +0100
X-MC-Unique: 9Y_cUZlCOveu3Jour73EKw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5387.eurprd04.prod.outlook.com (2603:10a6:10:8b::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27;
	Tue, 3 Nov 2020 08:59:57 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2%4]) with mapi id 15.20.3499.032;
	Tue, 3 Nov 2020 08:59:57 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 4/5] libmultipath: only read 0xc9 vpd page for devices
	with rdac checker
Thread-Index: AQHWqYGm1ba+s8gN/kCXi+qIM5RPBqmwr8+AgAT5lgCAAIL8AA==
Date: Tue, 3 Nov 2020 08:59:56 +0000
Message-ID: <9d8889ce2b6491ea58b83c8a3bdf326000e7878e.camel@suse.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-5-git-send-email-bmarzins@redhat.com>
	<acd021d7918335d91fac742da1f7e604ed3e2ee6.camel@suse.com>
	<20201103011105.GX3384@octiron.msp.redhat.com>
In-Reply-To: <20201103011105.GX3384@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [88.73.133.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57203dfd-d441-4c04-2bf5-08d87fd6d698
x-ms-traffictypediagnostic: DB7PR04MB5387:
x-microsoft-antispam-prvs: <DB7PR04MB53873D64F6669570BAC087ACFC110@DB7PR04MB5387.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: w4t1mwEf5Ge+EuFgqZ386RTIMTdw846FWz4GgWo07P3JoYF4prt2mt45iZ9Ogtd5OufjknFiLWLBrGxo9WiEC3l76ibYf2U6cuCVUpoCwJUwE3x7BB1fCTnIeiW8qPgXZ3+0yk76C1QoLWyNZWTIxAaCrvmftOkK519UJ82QgAp5SHopsmcXey8VLAtZ6FI2mkHPWz4lT1bplP5oO+mgxkBbZ6Aq3ccO6Z3ZZLNFsCOLvGSoeEyEHK8Og1hb4qsArw27bAGkcOm1sMzY+OX5Cj6PLSNWjrz0Q6bXR+sTGprouSjsasGZfn3EXca8jBVn
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(136003)(39860400002)(346002)(376002)(396003)(36756003)(6512007)(6916009)(64756008)(66446008)(66556008)(8676002)(8936002)(4326008)(54906003)(5660300002)(186003)(71200400001)(6506007)(86362001)(6486002)(316002)(2616005)(44832011)(26005)(2906002)(76116006)(66476007)(66946007)(478600001)(83380400001)(91956017);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: dFCB1FYAdWkSbCob4I+lXuOYDzhZX9+u7cKkFW4qSWo+qY0NW8X7WcB4MsIeKhbNsgceQqhZr/vxQ4//ELxLpBB5Ut6nkdt+iZ3MC2cgXKwEo4oQG4VLB3NzyEHcoMvMs0251dXPp8xv9VHuLHtqBlx3DbZkhl7ncWKpozHQrMotRCz0b+NwYHoGvQAB2UtvzNhvdqCNdGfbnHJz8NVEtNGSawsxL6S8vDQjnGmOLt4eZgHbqzyXd+PEkSlBO+paWIxosqdgFOGy0A0Oy0L3Qk+6ZFourJe923hwRZzruuS544FIu/5KQ+NqhdKdZe4XnOuxmRQdeiAOwq/OvZs0Rf/0BQT6WTAGu6b17UtY+Fu9huC8JsRSbg1ST8I+w+ynPK6l7hUptrYQUznR+kkHDy2RHJ1wMTvIMiWFoMUC8L6rEP1q2gDhcYx3fyW8OPkbaBV98JmJQchTzUbvKoOOA+1kKgoQKnb2MmerpNIqDAHZSciBIJoZ0ijXlZlbpvzIQAWJ6e3qmRvbf3JovwiJ5FVVVsHiFk1M7RojMrhqLZ37OQ4tfAJS/9ijEt7jNNxi1eK2v6a/yKRIzuxm0pZHiuXTC1uji/GbL8zW0btxWtk2+M2BIvrHOL/5+w6NnJ8/4D5Hb3U4Vr4+rVrI2WptdA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57203dfd-d441-4c04-2bf5-08d87fd6d698
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 08:59:57.0942 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HLSgJAJ8FrYdubZoquba+lfcRMZk6XdmqL3CxQtW2LlPwFSQdR+Tc9G8EUqHIgW1LnIBsKggu4PaBARQSzW4DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5387
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0A390Bp5018980
X-loop: dm-devel@redhat.com
Cc: "ng-eseries-upstream-maintainers@netapp.com"
	<ng-eseries-upstream-maintainers@netapp.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"sschremm@netapp.com" <sschremm@netapp.com>
Subject: Re: [dm-devel] [PATCH 4/5] libmultipath: only read 0xc9 vpd page
 for devices with rdac checker
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9D4FE4437DAF4A4896CE9B4AF3D7D33B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-11-02 at 19:11 -0600, Benjamin Marzinski wrote:
> On Fri, Oct 30, 2020 at 09:12:46PM +0000, Martin Wilck wrote:
> >=20
> > Suggestion: we could try to retrieve VPD 0 (supported VPDs) before
> > checking VPD 0xc9. That would avoid the errors on non-Netapp
> > hardware,
> > while still allowing us to autodetect RDAC systems that are missing
> > in
> > the hwtable.
>=20
> When this idea was brought up in discussions about how to solve this,
> there was a worry that older rdac devices might not not support vpd
> page
> 0 correctly. I'm not sure how valid that worry is.

These old devices should be in the hwtable.

The algorithm would be something like this:

 A) if hwtable says "rdac", goto D)
 B) if hwtable says nothing, goto E)
 C) otherwise use hwtable settings, END
 D) try VPD 0xc9
    1) if it works as expected, use RDAC, END
    2) otherwise, goto F)
 E) try VPD 0
    1) if it fails, goto F)
    2) if it works and page c9 is listed, goto D)
    3) if it works and c9 is not listed, goto F)
 F) use defaults, END

I suppose "hwtable" means all built-in and user configuration here,
including "overrides". But I haven't thought that through yet.

Cheers,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

