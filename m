Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBDCC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 09:37:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23E4D23104
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 09:37:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23E4D23104
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-ZgC964SePRmxZHJ3atsqlw-1; Tue, 26 Jan 2021 04:37:18 -0500
X-MC-Unique: ZgC964SePRmxZHJ3atsqlw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5477C1005504;
	Tue, 26 Jan 2021 09:37:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C012C5F9B7;
	Tue, 26 Jan 2021 09:37:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 755CC180954D;
	Tue, 26 Jan 2021 09:37:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10Q9bAJk004934 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 04:37:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 35F7690A00; Tue, 26 Jan 2021 09:37:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C631909F7
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 09:37:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A0B5101A53F
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 09:37:07 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-81-4WEtsQMAMPaar-qiRSLGdg-1;
	Tue, 26 Jan 2021 04:37:02 -0500
X-MC-Unique: 4WEtsQMAMPaar-qiRSLGdg-1
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur02lp2053.outbound.protection.outlook.com [104.47.4.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-17-urYAgOedM4m1eIJWhCd1Bw-1; Tue, 26 Jan 2021 10:37:00 +0100
X-MC-Unique: urYAgOedM4m1eIJWhCd1Bw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR04MB2999.eurprd04.prod.outlook.com (2603:10a6:6:5::20) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.3784.13; Tue, 26 Jan 2021 09:36:59 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3784.017;
	Tue, 26 Jan 2021 09:36:59 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmpathpersist: fix thread safety of default functions
Thread-Index: AQHW86R3vwBPJEgCl0yYZ/QVg4jpnKo5pkwA
Date: Tue, 26 Jan 2021 09:36:59 +0000
Message-ID: <6841a7ef1f82a5d2d9614b9eeccf3e4b2c6f2e65.camel@suse.com>
References: <1611639064-8187-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1611639064-8187-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [84.58.19.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd58062c-af87-448e-6c4b-08d8c1ddeda1
x-ms-traffictypediagnostic: DB6PR04MB2999:
x-microsoft-antispam-prvs: <DB6PR04MB2999F20ABE6564EC22B3CC95FCBC0@DB6PR04MB2999.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zQSrjIQ8vTn7eidhnRh+czljXgt94os8dJPu8NhZSdpMkKHkVZJMqYkxHTXeocW0k/2eXsAi+OFXjc/ifLZIHd+h4/nUpUXYix3Fm8+AKnJMWzowkWQdTd5HJBDtMmMOiG7aPPSo/GeMfmXlY8hB9/1C+k+PzXPtmR86Q/wLEx7NBvwLOPtjzYs7Ht+WDqPJQaTdL88HnMd5ZDuSR5+AP+n9HNp4YnfQ8pAh9YGngfxdeZKF5HhJCHazoYomnTDfyMOhsB8IQCbqiFNltG9M868JVfPl13mzHk/xQug0q1buXE2454xDH7pfJPeqmO9T0kLuPbVqsObJcq5lxzEoioSeW+cBcovhh6coyMNZT0IxF/iw1JnbFbsyDQ+mCDXFfvUFVJsEqR8qsoiUsN8k/U65Nc+T9lA5t1iPsHsxiJC4zE6+Le/Tcevm+Pf21aEsxBfu4VAteZheyj4vAesJeREOonI14LxWLGclI+cCork9+kshuogo7W6GlVRpyxotRezv7nhePHLSzHCLFYunzw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(346002)(376002)(39840400004)(396003)(136003)(6512007)(26005)(316002)(66946007)(66446008)(2906002)(91956017)(4326008)(186003)(6486002)(4744005)(110136005)(76116006)(66556008)(66476007)(2616005)(64756008)(44832011)(5660300002)(6506007)(478600001)(86362001)(71200400001)(8676002)(8936002)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?htAaSiUavm4XM+bj0OK9wXTjfBcfR4SdtQjFaqw3YtIKhzMWCWtzVB2GF?=
	=?iso-8859-15?Q?fQZ0kXLTTiS6qhWXawtbK7aEtutLYHhsW1WrxSjswdyNRAXacTFOZr1XU?=
	=?iso-8859-15?Q?zlZlCEP8Dsl3z20/25c0n2VXXacIJ0D6kZK36w0B+Y3u+BR2QWgpb2+F6?=
	=?iso-8859-15?Q?anhCoU1sDqoq8CzmtVyZnEAdRJSffsel04HXf+8iyvZRks7PGW+FFaw9X?=
	=?iso-8859-15?Q?dOBtHMx34AZHoiterPqknBrpdmS8xQt9sGm6QOr+L63d85Iy7/xFM3tqR?=
	=?iso-8859-15?Q?4m8eEJZYrmAEDiXCla4/vv7AoNQK9djTaMW/PuRtBtxTlZOpGJOy2vHV7?=
	=?iso-8859-15?Q?qnC7pvo5y/X54wh6UvHdy8s1h5Of78M2ysx77ftXeoNMdnn+zpRIq2y9o?=
	=?iso-8859-15?Q?PXqHvWPTGsmw3/O1D/Isgx8cqSTMvZ6qlqQg/lqYSS8Vrub2IUndWMt4m?=
	=?iso-8859-15?Q?V7JZi8b9ckffP+DOgVIhF3g5SxO44RKvch4nX93jQEJqktmVn0llHf+Ri?=
	=?iso-8859-15?Q?QRfGsxZceOFJbZXuH5PoJIN/mZUb9iw8TvtlBSU6eWSAhydPSJFxQTCEt?=
	=?iso-8859-15?Q?KDAHOl9Pd2ykuoVVPC1naFzZsFxCnzsaXXrDZeIIpJa3vqexy5AaZugXY?=
	=?iso-8859-15?Q?SOD7NGh+A9+QHMhTs4AnOsHKNV+8wgKqMfxIbgJ47r0/htKB+/zd9cSrx?=
	=?iso-8859-15?Q?CTeAgk2SrlbsdJrINw3D6u8/82Oe0EJnyglpHuaObgBHipdX1Vt4BOp9c?=
	=?iso-8859-15?Q?PCiPhbH+19zDWGLG9b6GnrN9i5in6wGUfZSsDgtfY1jfgjEoPrKAS7SY+?=
	=?iso-8859-15?Q?YOK/Ciye17IbcqiDwc0QL7jBpI+XMFANxTJVoiu7Nlo8sw3n3mWPwVxNt?=
	=?iso-8859-15?Q?u91XcdlGZf3CfopZIv7sKetiQP9c02mFYZlTWyxvIDyzJqNvol9Mp1aG+?=
	=?iso-8859-15?Q?uCBD7MvLdpDUHQYfclvZ7xanyQy0Eovow8JFWNV3Kl+fFcq5cPt9JR4qW?=
	=?iso-8859-15?Q?jr3bI8+EFx+nZDz2Kk3KsNlP9BupC26mrfIAdgCXyygeRgMUlohNYOz6w?=
	=?iso-8859-15?Q?pF2wSbw/cemS3UPaQ1qOK/Ghl+w28nVew+3oH/CsUFEanMinqY/C3xbls?=
	=?iso-8859-15?Q?XjND7?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd58062c-af87-448e-6c4b-08d8c1ddeda1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 09:36:59.0668 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CZM9r2mo3t7y9RqYSxsUJtSXvl4fd49PSzVFnumRF0sMgKskW3SSKKZmk6e2sdKFAArIaamnllOchnB4C4emGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2999
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10Q9bAJk004934
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] libmpathpersist: fix thread safety of
	default functions
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A8A56C7C30B9D140ABE08658BB28EE8E@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-01-25 at 23:31 -0600, Benjamin Marzinski wrote:
> commit a839e39e ("libmpathpersist: factor out initialization and
> teardown") made mpath_presistent_reserve_{in,out} use share variables
> for curmp and pathvec.=A0 There are users of this library that call
> these
> functions in a multi-threaded process, and this change causes their
> application to crash. config and udev are also shared variables, but
> libmpathpersist doesn't write to the config in
> mpath_presistent_reserve_{in,out}, and looking into the libudev code,
> I
> don't see any place where libmpathpersist uses the udev object in a
> way
> that isn't thread-safe.
>=20
> This patch makes mpath_presistent_reserve_{in,out} go back to using
> local variables for curmp and pathvec, so that multiple threads won't
> be operating on these variables at the same time.

Reviewed-by: Martin Wilck <mwilck@suse.com>

Out of curiosity: what's the multi-threaded application?

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

