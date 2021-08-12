Return-Path: <SRS0=gpIH=ND=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4301CC4338F
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 10:25:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C986060FC4
	for <dm-devel@archiver.kernel.org>; Thu, 12 Aug 2021 10:25:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C986060FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-dCV2vmDcNu2rIQvxwbqvPw-1; Thu, 12 Aug 2021 06:25:52 -0400
X-MC-Unique: dCV2vmDcNu2rIQvxwbqvPw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A83721008064;
	Thu, 12 Aug 2021 10:25:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63F955D9D5;
	Thu, 12 Aug 2021 10:25:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1135E4BB7C;
	Thu, 12 Aug 2021 10:25:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17CAN7g8012205 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 12 Aug 2021 06:23:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8F88C10FAA8; Thu, 12 Aug 2021 10:23:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84474113B54
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 10:23:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 763848D139B
	for <dm-devel@redhat.com>; Thu, 12 Aug 2021 10:23:04 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-197-3YWEE4QZMkSZXE5Ol0dw1A-1;
	Thu, 12 Aug 2021 06:23:02 -0400
X-MC-Unique: 3YWEE4QZMkSZXE5Ol0dw1A-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2111.outbound.protection.outlook.com [104.47.17.111])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-12-mrrMvNqpMvSt405PysblFQ-1; Thu, 12 Aug 2021 12:23:00 +0200
X-MC-Unique: mrrMvNqpMvSt405PysblFQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5385.eurprd04.prod.outlook.com (2603:10a6:10:83::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17;
	Thu, 12 Aug 2021 10:22:59 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1%5]) with mapi id 15.20.4415.015;
	Thu, 12 Aug 2021 10:22:59 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/5] multipath.conf: fix typo in ghost_delay description
Thread-Index: AQHXhMMsDvAs1PvYD0Wv983nOUxYvqtvvoQA
Date: Thu, 12 Aug 2021 10:22:58 +0000
Message-ID: <f9efd221d3d5e7eefd67bc3d4d9c7c949cf22b43.camel@suse.com>
References: <1627595165-19980-1-git-send-email-bmarzins@redhat.com>
	<1627595165-19980-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1627595165-19980-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 622a8043-8884-47f2-cc6e-08d95d7b2873
x-ms-traffictypediagnostic: DB7PR04MB5385:
x-microsoft-antispam-prvs: <DB7PR04MB53851ED35936C96D594A69C7FCF99@DB7PR04MB5385.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:626
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: nSt08iFtxb3jEVC7Ad4z6mHGdX1pSg0tL1W4vO9TyM8w7THTtNHjZMyIuy1/v/vVPeQOdaMg8B/6/FhkuaW0adhswi0uhaAtxCgJt5GT+F2y8Gi2cKeMMg0o4YuiFXIJfO172ffDuEHfDkOKyMUDJp8tmvaePmfH3JOPMYjVWG9UBjVOHtAakFYuYqrBfSWJUWxAcuE/H1xfxRy499sklT+bFyZPuNV8psFE+38y9oW3+HLL1WXxwPqMr1xqpDnw4mBEnEMJ+X4w1gPVLHUQXOHrddQMetQe6Wi1s3Ocq7aRuU5wWO0xBkVWGkQS5m0dwCpxzQv4+FOYamidw/5eK3H6O/evzGgZz2EL+++z10A9GKw0Vq7giKGoL7gtxmGnY0d+wBKXRRaBWrgQjlp1j71+gn0dkmuWZf56En4G4m4Ci3dBmcgI2xWkLDe/qa3vwoLkObGx4sjZNe0EXfZg3KFkUksCrafJ/7pcGHM3RYguec8WyoObRpSqQG26bGZoAhIZV41HxDQCCUaQ5Z98NOjSpdH1vL+HVP0g8QZeE70LJpYGnCcQrGAAb+NSGo6Wll0yt54FadvmSUHcU/MjqcRplE7jtn2e/MtDhu39iVt5dO3jzVud5Ths586LH8GSqSmOb0++DBvUAGs7OvklFW+vjokv4EUiMQ1Zyxr3SKtxBHzWJ1/X3cjHiWkox9TgO7z8X7enS2szHfhlHpjp7A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(71200400001)(66476007)(66556008)(66446008)(64756008)(66946007)(6486002)(91956017)(86362001)(44832011)(2906002)(38070700005)(5660300002)(36756003)(8936002)(76116006)(2616005)(8676002)(558084003)(6506007)(508600001)(26005)(38100700002)(122000001)(4326008)(6512007)(316002)(186003)(110136005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?Hm3o2dfKXMzURoRe5aKI+IFY00emtMoMSgWVuZ/bYDe1C73p5wCe0EroY?=
	=?iso-8859-15?Q?5T7pGOGggl8Qeg22rhJmRvd/UNAGQeP0gvdJp0xZRCTgBbPCOq4DL4G5a?=
	=?iso-8859-15?Q?fYpLIfxfhE72/qroGXlFGp4akIWPg1Faag1e5Pm2AqWxj+5leS4oDoAxO?=
	=?iso-8859-15?Q?ehAja9H6SJ2b6mhJcLGZUXQd7tqH0qCFWLQjLzzMPiIb2nJLDbk8wCJG2?=
	=?iso-8859-15?Q?RABNTK6ru0zB5+C3VLtTMGwusTupQP7DjZwZzrZzML8YTl3X3eL4UNrRJ?=
	=?iso-8859-15?Q?IOqVCqyyg43BdyCsN1KFVyFSi80KYMkKb2zGbFvqEnfE546os/gO35peJ?=
	=?iso-8859-15?Q?N2iy/F9ZvdhVkdTbG3SapoNXhFquG5XTtugwhJNXSBPug1DAVtJTTVVVo?=
	=?iso-8859-15?Q?Mw6dKEr3mGG0JImqReYJGJSD+19xsXcfcD1y5xzs8pH9O0fNcprVK5HAP?=
	=?iso-8859-15?Q?aJAxQBVnaEZ2C9aU8YwiEChKJEQ02/BHqBa6a2J+fbunjX/HiRooATRoh?=
	=?iso-8859-15?Q?jiL3VUmxBTLkNiv4yqrLnWtnv6/FALGxKVgfMDJ5la/mCPZ4ghIjmvHSB?=
	=?iso-8859-15?Q?pgQNuHCBn6HDu0Q/RO46mYj+B+PulFoRSqRpRPLslnGgM/n9AH3AC/5vs?=
	=?iso-8859-15?Q?Nd/MO9nxgJg4VOlxsjMtcsTV5SiyXvVz0hy9jrNtLeSrzkkdwKnfTWfVf?=
	=?iso-8859-15?Q?//iGi+XfCXjraODxw7y+/8gEdSwBiwzRI4T70z+K5Tu4jxXEmQ6SWemWl?=
	=?iso-8859-15?Q?EerZWwbEUGWB7JLvRR5KZ08AFqiDcQfSzGwj3VoGl+sIrQBwGQFmQNCVa?=
	=?iso-8859-15?Q?OyXQoQGrgsDvB+ombK/eaelMPqZzb5xWgkkUaMl8UDv8YptlGe7gaSd++?=
	=?iso-8859-15?Q?H+e+4/b91LgEibOj+671/IgJdiwfXWJ5sgDBoc3CsrHsUjYJFUUsotSem?=
	=?iso-8859-15?Q?qwu42k6uJquZtaPwgLW2AQ2V3sV3jm9kzwR5OKE6JI4/3gLQ/ufaSIetR?=
	=?iso-8859-15?Q?VTbG3qfF6F6psBNTeA/fjRfXboLo/EuZ67zVvbf4+So+rS/74me292hwu?=
	=?iso-8859-15?Q?WUh1KadVbWxsIuPjrmbQsvB2dILlbcbds0NfNLYY3Z19RV0YGp6Nvwk2Q?=
	=?iso-8859-15?Q?EQ2qB+syyW4teGb9OafoTF5XwI6yQUjlAp3G0lUWKBrdz+ca+Ogp8ErCl?=
	=?iso-8859-15?Q?NWj6FL+5zEha5TUPPO0fVe7EbCdLHNtjuwOB68vT8/8gBqNZskuCFkK0l?=
	=?iso-8859-15?Q?euj4kfsRSflp5NDKETo9kLkJv9l6yvwlaJYq8g5IM+rGzwcuMUvKYOKQZ?=
	=?iso-8859-15?Q?/L/ibtqp5aAD+c7hsixEx4pL0hMWTX3sL66mcUuMCpE6TnresgmDAgrZU?=
	=?iso-8859-15?Q?+ywxMj2PYHnpuLWdxxUY5tOcdT1IwCU4Z?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 622a8043-8884-47f2-cc6e-08d95d7b2873
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 10:22:58.9844 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TK+W9r4tFMNXwDaFWDgiG5J5azeYrgKjIZzsWEjJhVieK+hEUl5PVwLkoHVxHcbZKdsRg1EssKb/4l4LKGhtZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5385
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17CAN7g8012205
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/5] multipath.conf: fix typo in ghost_delay
	description
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <4B91813218AD6A49BCEE3911973516E7@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Do, 2021-07-29 at 16:46 -0500, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

