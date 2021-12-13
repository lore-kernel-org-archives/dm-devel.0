Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BB8EC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Dec 2021 12:05:51 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-24-vCd6iQy-PSCMTevfAvvCpg-1; Mon, 13 Dec 2021 07:05:48 -0500
X-MC-Unique: vCd6iQy-PSCMTevfAvvCpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B16C101F7A4;
	Mon, 13 Dec 2021 12:05:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 005605C23A;
	Mon, 13 Dec 2021 12:05:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C53564BB7C;
	Mon, 13 Dec 2021 12:05:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BDC5ZJc022168 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 07:05:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2CCA0492CA3; Mon, 13 Dec 2021 12:05:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 277A8492C3B
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 12:05:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09739185A7BA
	for <dm-devel@redhat.com>; Mon, 13 Dec 2021 12:05:35 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-385-NHKiDtAKOdiOhbNpNtRTnQ-1; Mon, 13 Dec 2021 07:05:31 -0500
X-MC-Unique: NHKiDtAKOdiOhbNpNtRTnQ-1
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur02lp2051.outbound.protection.outlook.com [104.47.6.51]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-5-GCFTQhkwMP2OAyMWlp5GPA-1; Mon, 13 Dec 2021 13:05:28 +0100
X-MC-Unique: GCFTQhkwMP2OAyMWlp5GPA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB3PR0402MB3644.eurprd04.prod.outlook.com (2603:10a6:8:c::17) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17;
	Mon, 13 Dec 2021 12:05:26 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4778.017;
	Mon, 13 Dec 2021 12:05:26 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "erwin@erwinvanlonden.net" <erwin@erwinvanlonden.net>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "muneendra.kumar@broadcom.com"
	<muneendra.kumar@broadcom.com>
Thread-Topic: [dm-devel] [PATCH] multipathd: handle fpin events
Thread-Index: AQHX4cN3WHkLuxT/XU2rhrfCJFDyL6wwBsBLgABpJYA=
Date: Mon, 13 Dec 2021 12:05:26 +0000
Message-ID: <e3636bf7966fbd3924653f6508d7b61f882a5dc1.camel@suse.com>
References: <20211124232132.746480-1-muneendra.kumar@broadcom.com>
	<465ba608d807895d5697554d9cc21086493c0b8e.camel@suse.com>
	<bf4de4b36163c2dceb85df22241c1db310ccc8b9.camel@suse.com>
	<e36a235ee7c626221415d1b94d50c1fe0b801763.camel@erwinvanlonden.net>
In-Reply-To: <e36a235ee7c626221415d1b94d50c1fe0b801763.camel@erwinvanlonden.net>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98864afa-2bf3-40cd-6e52-08d9be30d98b
x-ms-traffictypediagnostic: DB3PR0402MB3644:EE_
x-microsoft-antispam-prvs: <DB3PR0402MB36441301F6898C5B13EC9836FC749@DB3PR0402MB3644.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4IurGStVk3ab+euvRs4hYeuecC9jpjbQD1KnFObz0lHnASXaKfvrPS9Un5fAYh/rItvQycgJJ0C6TtRRJdMQWIKkuCT1a4Fg+EQMlTAHsPHa8FCakrafL8dNFuo6AxpJ2Dojbd74GKHZ4dxXIFScfzSionzYtVWGd2OPanUyynbR9ZPOUqMrDfetNf22jLC7GDLYop0F+tzp9mWVdQKiVwQy6aS5m8uyJx0Cayy+AYFaCQ7jDHGwcnuuFnejnZvGxiJN17VZxyfpyNBTsdxC7+28GZF6Aah+b1ZrExFa6IDOEk0t4w1cpQXpd8NAKWsInjpEdo09PGMCrIPnv3q1Z27L3Vz/+csc7V8r8HhmKbJPTndAEVzxbZ1W0v5A9gQjvHLnBb5jO8YP9UDJBScHUhZu8EECkkKfCBeiZ/dc/Yglb2EiDgnih4XLcKp4mijkW0a6lJK6TpG9+HilQhemPx2vZYST4muDHoidHZsJkD7+mFtX6MBytdkCl/yii4e45/mIE7G10BX+LMkcDB28SNfYG/zSsyrZWL0iolQHRiZBqiikar6tjljItRehAqkAzKItTKeQyJzcX+L8pKs1n/8Fl48Ucdm5vDS3yD+zW85N1JSfT3QgD1b6yiyVPedn9NTI2xxClxfcAuUpMC35aG4dx5gvYy4Q0jiSr5rKrqQaQ6H2i3564BNdbetBOZpQ1ZNV5YhidC2q82Bh7pF1ZA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(5660300002)(36756003)(4326008)(6486002)(86362001)(316002)(4001150100001)(110136005)(44832011)(83380400001)(186003)(8676002)(8936002)(66556008)(66446008)(64756008)(76116006)(91956017)(66946007)(71200400001)(6506007)(2616005)(38070700005)(6512007)(38100700002)(26005)(122000001)(508600001)(2906002)(66476007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?iUaafGLaRP5OEQYEfCf+J8CH1FkqQj+6Z4APqt89TcBT+ohbpGonmPowl?=
	=?iso-8859-15?Q?Bad3fqGhB5JqdflSyjyAeKtbZvvj4pOtOxFC7+pCj3k05JRKxPY1D9WNi?=
	=?iso-8859-15?Q?3CeoyMI+pxrN0Jgz9i8p3m0FfVsfAnYC/erkW/nuM1w0zV0mg/doiDZxJ?=
	=?iso-8859-15?Q?FhcdTCMONT8og8w69aI5FKI9kWzllBlJ////A3T4YZPzZG0NlOOmuKthv?=
	=?iso-8859-15?Q?Ap5NceRq9dwh0XzDQhtzTtTAMwAIVJO7YPDkJkTkw4SHZFwuyYME3fwrD?=
	=?iso-8859-15?Q?J1XL7yqYk3xMHMaHTZd1BS8t9ulYnR6QGANK1Cdo1HQmnKmYEMzskgfq4?=
	=?iso-8859-15?Q?sB/AONcAWFPndVdH3TeoLCQvk5G0uriXOjtVeQFQvGQr4q3XyuUNoKwLT?=
	=?iso-8859-15?Q?5h/PQxtPWiSWIh841YUog1X6Jy4sfUJKtc0dFi/66IBSlssC5MeupQPXB?=
	=?iso-8859-15?Q?5M/BctV7HvHEIxcIA2oGwZkXEM+n7SQwY46lSoS9iOJq1rAwRK6bo/XkI?=
	=?iso-8859-15?Q?HfVC5Wq1TFlPLXicyOp4iAMzv+NkS7t5oPL8EuZTgnKD3V0H5P0U2ohYr?=
	=?iso-8859-15?Q?YPl79wbem3IlzbO/j16TX+SrG0UwDCyGik/EeaZzxs4g6iAowj87eN5p0?=
	=?iso-8859-15?Q?B+oYmhpTSL67qj9dF9pIxyzuHXbvwYbTzhtdvDG/cI/ZxymqPX96wh6RO?=
	=?iso-8859-15?Q?iuK9GV6lWtR7vBZHRDsYL9NBzJN8hOtCjzaPQ1YcKUhST6YI5PFjOwUhF?=
	=?iso-8859-15?Q?iy1pF7wDJSGB1qCDM2Wfzd2MYWAW3myOnISU7WSN8ux3BAGa4WwzLcqgc?=
	=?iso-8859-15?Q?Sndpgqn50iLYzAF5u512Kwf2RF3cHf5ybrxQPQnrNV6RoT6qHYIwYG4+h?=
	=?iso-8859-15?Q?JwPBadlWG7W4TigQLUyXau49DAfyD4QTZ1bPovivJPt9MIuF6JUThqC33?=
	=?iso-8859-15?Q?5PMBS6l/QYB6v+oXZnhaBb7zRyPdgckyipCOjmhbKCbB26K1tHtdcFhat?=
	=?iso-8859-15?Q?78J872zPKMAcbQyffppNwenCnedw4o6ukRyl3aBLtKWTEyRxeIZrfNQzl?=
	=?iso-8859-15?Q?hORVlrkRCO+uLOygGPjjswiZBXlIPwGUdRw8Bd0xvckq/F6qXSDuA/7t9?=
	=?iso-8859-15?Q?a22xoNcuWbGtjvPvD9SYYV59xds4gpcZZuQdL39nvpn0DmDIQrWguQtrP?=
	=?iso-8859-15?Q?P2rp3wob4sFT0k7sO2QrVVUVICUuQviObtYLw4OBHTQ7chk+ztO6q3Hmd?=
	=?iso-8859-15?Q?kGlV+73T9Xxm+HVyV9+0q2Q/4Fg42u1wKFCuapjNJBfll6MkhqhQqrbjn?=
	=?iso-8859-15?Q?KJNNSfJj0W/cJ2isAWRIYWTP/jtOZahhZJoCaXNKuMcod8hqJWWCrdVbc?=
	=?iso-8859-15?Q?Dxb+aRbSM/rMFxN52vKplyyLU1HpT41fd1wgaiEqwV9utr11ol+PM0Msz?=
	=?iso-8859-15?Q?6V7oOZyFQhVS0uFhiKOcLc6G2lZfhk+2dB87pqVWlfECYWdFzQ2lMsJqp?=
	=?iso-8859-15?Q?KqXEi4rqiHN4FB2+5jM1uXDqE83iUnZVL2OmG8RSk3X0czoKoyO36r0zi?=
	=?iso-8859-15?Q?jUoQm6fBYakWvPQ+3xs4jdYYuWvsyputZvwdQkgKtycQ+bVhnJYumelXu?=
	=?iso-8859-15?Q?smgCx1b95wCA5Hp2TR26zt8ic5oyfiOdxgd1tqWLr/7J45tRcAG0GjcdW?=
	=?iso-8859-15?Q?LdyqbwttzRjuI521DRrBe4BH83beDv3hMiKhgtLtRSP1Oyg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98864afa-2bf3-40cd-6e52-08d9be30d98b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 12:05:26.5637 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: no/tocSWQgyPB/4e5QirU6FDUJ+OBIooV20uSzCzygxUf+DVX7n/LwUS06jkiNtFlo/8DqQrzZDBb9iyvGIWeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3644
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BDC5ZJc022168
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <0E7A63522FBDAA46BAF9AEEE3EE99067@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2021-12-13 at 15:40 +1000, Erwin van Londen wrote:
> Hello Martin,
> 
> That is exactly the reason why we would need to modularise this.
> Access characteristics between different transport protocols can
> differ significantly and thus are susceptible to different
> indicators, tolerances and other variations that would need a
> different config setup. You don't really want to mix and match config
> options between the various options as that would significantly
> increase complexity and thus make the setup more errorprone. Things
> may often seem very clear cut from a develop(ers/ment) perspective
> however from a system administration side it gets often very
> confusing when even the smallest things start to contradict each
> other.
> 
> When tcp packets timeout from a iscsi based device we're 100% relying
> on tcp to sort itself out based on RTT values and slow start
> behaviour whereas FC is far more reliant on all upper levels from
> scsi/nvme-o-f side. These tolerances should be configurable
> independantly.

Hm, I don't know. Configuration is yet another issue. The nice thing
about Muneendra's FPIN patches it that they don't need _any_ device-
specific configuration on multipathd's part. The notifications are
received from the fabric, and multipathd just passively reacts on them.
If there's any configuration, it's done on the fabric level, which is
where it belongs IMHO. 

Consider the complex configuration parameters that we currently use for
marginal path detection ("marginal_path_err_rate_threshold" etc.). We
allow configuring them at all levels that multipathd supports
(defaults, device, multipath, overrides). I wonder if anybody is using
multiple sets of these parameters for different arrays (or even
multipaths). It sounds daunting to figure out the right settings for
the given environment, and doing that separately for different targets
seems almost impossible. Since this feature was first created, I've
thought we need a simple setup that "just works" for most users, most
of the time, with just one or even zero parameters, rather than this
intimidating complexity. That would probably boost adoption of this
feature quite a bit. I can't create a simplified parameter set because
I don't have access to networks suitable for testing and deriving
proper parameter sets.

Moreover, I believe that configuring this for individual multipath maps
or storage array vendor/product makes very little sense in general. As
you say correctly, what matters here is properties of the transport and
fabric (type, site-specific configuration, and topology, like
distance). We don't support fabric-specific configuration currently,
and we can't support anything site-specific except via the "defaults"
configuration section.

What I can currently conceive of for the future is this:
 - use FPIN for FC (perhaps just for certain ports)
 - (maybe) use some other to-be-developed notification mechanism for
other transports (ideally also configured in the fabric, with zero
config parameters in multipath-tools)
 - use either marginal_path_err_rate_threshold or nothing for the rest,
but just with one set of parameters.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

