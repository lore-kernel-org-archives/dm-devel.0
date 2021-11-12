Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F06C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 10:55:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C3CE60F39
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 10:55:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7C3CE60F39
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-WYoOuUcwODm16xAN836Flg-1; Fri, 12 Nov 2021 05:54:59 -0500
X-MC-Unique: WYoOuUcwODm16xAN836Flg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADFBB15721;
	Fri, 12 Nov 2021 10:54:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B08DA5DA60;
	Fri, 12 Nov 2021 10:54:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C07054A703;
	Fri, 12 Nov 2021 10:54:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACAsjSw021933 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 05:54:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0E39B2026D6B; Fri, 12 Nov 2021 10:54:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08B602026D48
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 10:54:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11EF31066560
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 10:54:40 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-297-Fi8iDOMVPvKbJDweavaseQ-1;
	Fri, 12 Nov 2021 05:54:38 -0500
X-MC-Unique: Fi8iDOMVPvKbJDweavaseQ-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2050.outbound.protection.outlook.com [104.47.12.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-7-jsl_GXIbOnqdK9wMYOx42g-1; Fri, 12 Nov 2021 11:54:36 +0100
X-MC-Unique: jsl_GXIbOnqdK9wMYOx42g-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6843.eurprd04.prod.outlook.com (2603:10a6:10:11b::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16;
	Fri, 12 Nov 2021 10:54:34 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Fri, 12 Nov 2021 10:54:34 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: don't return error on invalid values
Thread-Index: AQHX12QTlLH8RjYRFEuagJHzb3xJPav/uJGA
Date: Fri, 12 Nov 2021 10:54:33 +0000
Message-ID: <a30da030d3f003e7a2cf185c0547f53fc86e2fea.camel@suse.com>
References: <1636680271-27908-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636680271-27908-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e123f421-9acd-4fec-9cc4-08d9a5cad00e
x-ms-traffictypediagnostic: DB8PR04MB6843:
x-microsoft-antispam-prvs: <DB8PR04MB6843B4CC3C4D347E81C40786FC959@DB8PR04MB6843.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3cHBORSkM64te2caj9sHopl/L6AZ8Vx5VDWBfj0pqNCzKXYNVVCwxqvAw7bREndY2SnUUDQ8k1CPjhWDuq2G7wwylOTarxrN62Q7Pzc1Xxx2uVfxKEZB7HqaWonnNtfpJ6S/JhX8ynU2SFLpeJKIdkRl1MtRQSb5jz5CnroHbFr43jqSgwT2vv69C/u2r4vrrZVDBjPlqDO9dSTAiD5bZsoVVaEnoQxmqGOIJiUXEpT0KhSi6WjhnRWsKyKakaehtRvanWyGlDlBPZnXGRbS8xOErrRKzcfVL8QIRWJVLGpcyFvOSOBtyNmxbHCaiU2V+2fyQHe4D6fzYYWDbGutOyQI84d9s3fUu19PLRN1WVXYD2Y3KcuZFgCCd5634WeE/J2PMTlEIhKmcv8odX/Sh/gVvPNSDbuL1S7aSAXoeD3bW2gMHCVLetp3b1J92GX6OxzHHS1o41QTwKeM4RpNln+znDq4bGGiRlvgv+4LHi76PXcVNgfJza1gi14SaSJGvRbirxKXe6IHMgyLFjz99TiJSuSA4/5vNLM/cZFRF82vMwC00r1gnJzpss/AdcGPd202C3mdJE6L8H/MX9v2ZYKpoHZlfyrpw31f94nvL+8Lv007mOMNcVBwpl+uqF2gUjQtNRzTxmJ6WC6EWYVmQm4ASMNHs14PWhb7Z2tsx1+OqcOg5J2tKGSx2TV7ikeTM1mNK2OJB9XvuBD64+bfvA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(26005)(110136005)(38070700005)(6512007)(38100700002)(508600001)(4001150100001)(6506007)(186003)(4326008)(5660300002)(8676002)(64756008)(66556008)(2906002)(2616005)(316002)(8936002)(122000001)(44832011)(66446008)(86362001)(76116006)(71200400001)(91956017)(66946007)(66476007)(36756003)(4744005)(6486002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?dByBMEpPsODe/xKhooaJ1J1wV4+RuYEZhqZjJDRRa1Gj6xgDqGzv5ZT+P?=
	=?iso-8859-15?Q?40zlKOIRI+yC//P0bq0Tbh+mLdz/aPR9w7XBrue5bBAHQJapQ8p9V2VY0?=
	=?iso-8859-15?Q?P+hwWdb/OegKen42wAQ/b+Yjx9bYHelzQbLkRb87LW4WklcpURDkkcNMk?=
	=?iso-8859-15?Q?Yl5MoF3y3DKawxxtkitTk4glrIJED7oQlWVsYCoC6oTWx2MUPHKScM9uG?=
	=?iso-8859-15?Q?KO3OKGy5tf6bOw5rcw21+XZNDgIcQRQLu2l9S68FLFdHrj7walS7RmGDN?=
	=?iso-8859-15?Q?E42MYmq4FWqDyVMSUSL0hPBamXnBmC7eayArcgwKjW8XeT6YC05hkHG2P?=
	=?iso-8859-15?Q?bieOxVDhRKKYlkj7DDZHKKIQ4biN4xei+bZVOSWxxYLdLORPoQtfUSZna?=
	=?iso-8859-15?Q?JwMkzDus+zdddUp3cJxC8wFeIefw/nL+6M1RHDeusCSYVyre/qf2PdkLK?=
	=?iso-8859-15?Q?Znu7FK1LBt73MxLkDMR/qLj0IADlMzwDYEAB1lzCKRbk2/6+L/xHDg6+e?=
	=?iso-8859-15?Q?j+etZkh26oyeCFV4QWmMYKrmgOgkckyujIzYuh7B4cCSwI3JtKv7Lv/p8?=
	=?iso-8859-15?Q?ISoURVMl3vbiPcVlVl2nEvV2O0ARvMv9FRQWfidGpWv/LnjHXlXbVmve9?=
	=?iso-8859-15?Q?Xw2H5qVPaXSKiyK3sXndcGcCrUJ22J1koj6TX6/Ym3PXLvsehDe9BbNv5?=
	=?iso-8859-15?Q?UZPy/p7yM086R5NYYy6pdNkt0YbiNQL/jQwnQhrQpLOqfqPMd0u3wPLF+?=
	=?iso-8859-15?Q?3AhGLvemz4oLrdvBF0mrWegPkadwNqJtnygu3JkX910983yDBfHE/yIXA?=
	=?iso-8859-15?Q?x+2uasat8tx8o1XWcSH5Pg8HkMuD8ZcntBDlG+q1DxKUam3Nak3h5Yvqj?=
	=?iso-8859-15?Q?60r54BXtxxs3XrgJRXepgiMYP/7eWy4O7yumuw2HcJhtIGTus51g0lyFV?=
	=?iso-8859-15?Q?5lenUS3OpJiF3zjaaMGAMT/HFYn8TQirLfkb0tsSfEtvhcK3QEW0ESzJ2?=
	=?iso-8859-15?Q?rUIvqEW8iN+98DkfogyzdxZ5rzT7YwYpJF929WNpyozQW8h1eIpDTi2BA?=
	=?iso-8859-15?Q?B3qmBXxNXKclfqpER8heyPRcDbMcmN59Z+Jf/OStHsL6PTUZAgmrKt5v2?=
	=?iso-8859-15?Q?525Zt7d+OaUbd09dnvfj7NYKVVgoc9/j1OVMuLiPM931XGEqQq2+JM6Oe?=
	=?iso-8859-15?Q?00tw2SPdOzqMuofhFUH0zQWavdlRO5dEn500Xi+7hzc5fe1cfcYIy3Iu0?=
	=?iso-8859-15?Q?2JSwoIUveFp2tS1oy70+PKBId4aVMmDS2vQrXI9DTHZcjMDXf5kHxBoR4?=
	=?iso-8859-15?Q?oDr/tc1cQYlBzUrqGb5wZqjcLPnqdEuKg1Z672XXHZIC7LqF28Qk1hKRh?=
	=?iso-8859-15?Q?PS3EouwRWtPmYm0O8LAL8HHxT3dTdgQf9fEGGoM2hwjF3nXUWWU/YdyuD?=
	=?iso-8859-15?Q?hw541GYnQkS8OqullvVmU78x/zAIXz1+2a+DXvTp9Ov4p7IuBvzhri1qW?=
	=?iso-8859-15?Q?TJ0eGq6HNKygXI30FR/wl2m5RrsiS3+paBTMBljzzzpnq0oWJbBT1QTE4?=
	=?iso-8859-15?Q?30YjQ5VJ7Bal7saoqyinHrmQXnPh5zzd6SO6JnNE6XENc+4F9YjEjEwe5?=
	=?iso-8859-15?Q?JABxAzuye2drM6t1Ea9eWza/nHIYoDgH6oO3qNjoOew/JzE6fIBF+MFnP?=
	=?iso-8859-15?Q?kNOJs50ntHDIOhqDev4hFur2ynVVYDiqnCLfa3ot50MwObc=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e123f421-9acd-4fec-9cc4-08d9a5cad00e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 10:54:34.0582 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 71haaTS/I71zCiKVgz4+apI5rcPRnPgtIdIcTbflybPXz7Up/AXP03/td9vzWosnnqDIDBLv3s1oRZxDriT2jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6843
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ACAsjSw021933
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: don't return error on invalid
	values
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
Content-ID: <49F44FBAB74E9442A68A869D58E13A58@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2021-11-11 at 19:24 -0600, Benjamin Marzinski wrote:
> do_set_int and set_uint return 1 for invalid values. This can cause
> multipath to fail completely, while reading the config. The config
> handlers should only return a non-zero value if there is an internal
> error, not if there is just an invalid value.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

