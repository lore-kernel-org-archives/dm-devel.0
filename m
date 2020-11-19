Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEECBC5519F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:22:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E649722264
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E649722264
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nxp.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-qtzOZ63cO9m1HY5yggLIYA-1; Fri, 20 Nov 2020 04:22:53 -0500
X-MC-Unique: qtzOZ63cO9m1HY5yggLIYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54F581DDE1;
	Fri, 20 Nov 2020 09:22:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 333CE60853;
	Fri, 20 Nov 2020 09:22:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C1D99180954D;
	Fri, 20 Nov 2020 09:22:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJITLE9024419 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 13:29:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B92B8DAF2B; Thu, 19 Nov 2020 18:29:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1F0DDAF39
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 18:29:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99D9318A01A0
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 18:29:21 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-eopbgr70077.outbound.protection.outlook.com [40.107.7.77]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-425-xgLTzLybN4Wi5lWoUV-4qQ-1; Thu, 19 Nov 2020 13:29:18 -0500
X-MC-Unique: xgLTzLybN4Wi5lWoUV-4qQ-1
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
	(2603:10a6:803:1c::25) by VI1PR04MB5501.eurprd04.prod.outlook.com
	(2603:10a6:803:d3::11) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22;
	Thu, 19 Nov 2020 18:29:16 +0000
Received: from VI1PR0402MB3712.eurprd04.prod.outlook.com
	([fe80::ade4:e169:1f4a:28c]) by
	VI1PR0402MB3712.eurprd04.prod.outlook.com
	([fe80::ade4:e169:1f4a:28c%4]) with mapi id 15.20.3564.028;
	Thu, 19 Nov 2020 18:29:16 +0000
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <20200716115538.GA31461@gondor.apana.org.au>
	<8eefed8b-5ad5-424b-ab32-85e0cbac0a15@nxp.com>
	<20200722072932.GA27544@gondor.apana.org.au>
From: Iuliana Prodan <iuliana.prodan@nxp.com>
Message-ID: <71b6f739-d4a8-8b26-bf78-ce9acf9a0f99@nxp.com>
Date: Thu, 19 Nov 2020 20:29:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.2
In-Reply-To: <20200722072932.GA27544@gondor.apana.org.au>
X-Originating-IP: [188.26.141.79]
X-ClientProxiedBy: AM4PR0501CA0055.eurprd05.prod.outlook.com
	(2603:10a6:200:68::23) To VI1PR0402MB3712.eurprd04.prod.outlook.com
	(2603:10a6:803:1c::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.5] (188.26.141.79) by
	AM4PR0501CA0055.eurprd05.prod.outlook.com
	(2603:10a6:200:68::23) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
	id 15.20.3589.20 via Frontend Transport;
	Thu, 19 Nov 2020 18:29:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f9095ab-e9de-482f-8572-08d88cb9053d
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5501B8607750C285604AFE1C8CE00@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: TKQqSWdp+lAJcOXKtrhEdABIV2QRaeie4U8n+1RT6vmG8rQAcqQ0YZxUePcq4TyoQbhkmsH7bo9aToYNF+FzSlv3wfftRZ6clmGLp1Y9j7wYlSmyOgN1vaY7lA/aFjA4TOSZnKcGhBhmnhMZK9waDbBtH21+eYNTT4LVbzMWO2PYvPFGqp+JSgEMCq+3YBTSVN7BBK3pIdCVPAZeWzaRHS1D0EajjNoJ4MyinLCtl2f1iP8aFaOZt+ghvEoyTUlSQtWbdQEik3u5tTGkgk3ru/FtCpZuW5RDkQYzntgKCmn4hHc672FfRtBat8ZrotCWKCBaLhYVBPshYE8kPQqV5e4lcY4KmnkQ4OG610jJfXkfK5NAkdWrRAELXzEGmPiuDQGYeYozoyCgNU3e5zfvXWHFha9H047juRiDcgEWVo6IUgVG0pTtI6p5nebzQBkCjCUEvPNvwefFNqfrh2HGuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:VI1PR0402MB3712.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(966005)(31686004)(36756003)(31696002)(4326008)(6486002)(26005)(956004)(2616005)(66946007)(478600001)(66476007)(54906003)(8936002)(2906002)(66556008)(86362001)(45080400002)(186003)(8676002)(52116002)(16526019)(83380400001)(16576012)(110136005)(44832011)(5660300002)(316002)(53546011)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData: EauyW3szrujTVUeRhdgIdiKACJVweluW6JsVl4Xp0doXL53wEhoBdl57o7JoVuQMqOvbu9oaq54YcydESSR8zgPnaBYcF8Fp6k9Kv6gVLkEeP5+qlIdotHFkg8l7qawxJFoU4L+CNeGRQukPTi3qZPAtdSObo4v6nk5xUB1W27Pmxn4gbsTRWxsa25QcA+uQl/re7KFHpB3z+Dt4MtPXztMb0ZzXX5l6caS5BhLTcam3rm6luD3YWVoAXIlOwsoJ8HjY74AMmq/TrZPTNWDM3gQFVYcebG6ISR/mBhSsIV6Wc49c7WevGjV9CiJimZfkq5puNKbWevCDJF7CVCMag7QH8dWaHHjU8Ryp5QBmtdEkHRFxGNAezYOgRw73G92PkcgckrxVXvmURojGUr2nzSrQ5O7Ajw/CZQt0Bt8NM19gS4QAAFPDM2aPfEUEkYvY4nJujo9jMTBvj2n19C3hOIMi7Fv8KtPv+gd+SAvC0DjbLFnWu6pvIFfc9cZc67DZshTj/HvMN1rfxiMXqOJHOsTFJaTkgvY3POuieOQDu7YO/DSTvm6Li7MvvSacAQrNrQ2i4knUtRzq/aSl+DziaSZFdkXcwYctwwz3ipg0jIPnmueVDnRvGDmilKCGABk0877g9M88wIM+Ij44Xb4PBqzHm+dCgMlB7JtzoLGRJ0C+xLJetSBEueEXVERpT1MKsgq6xNW2Yl39CWnkwkBoqgTRvQ/7iBXKXfMfRW0isKlpPwdMkHFJtmBDev/chbAohqOhOERa1eRKLYeIPAW8mEVN4dC2/XpfosKy8LsW+T5DTH0L1QCvlCXbQXUC/YHAEQG2QnfqP5FzF+nQ1WTppe3e25FlmpHuWZab+iLn9rMqbsvHqoSPhks74bbakv3IvdOEKBFixF1dvbD2/Nawow==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f9095ab-e9de-482f-8572-08d88cb9053d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3712.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 18:29:16.0010 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5zIgxluNjMLbFKacYbyrVRvAT8bj4Eleeo8N4PIgbaH7rWOFwyJruuIRs0eDvDrIGkODi1oy0qLia6t+G5hFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AJITLE9024419
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 20 Nov 2020 04:22:46 -0500
Cc: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
	Franck LENORMAND <franck.lenormand@nxp.com>, dm-devel@redhat.com,
	mpatocka@redhat.com, linux-crypto@vger.kernel.org,
	Silvano Di Ninno <silvano.dininno@nxp.com>,
	dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [dm-devel] [PATCH v2 0/7] crypto: add
	CRYPTO_ALG_ALLOCATES_MEMORY
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

CkhpIEhlcmJlcnQsCgpPbiA3LzIyLzIwMjAgMTA6MjkgQU0sIEhlcmJlcnQgWHUgd3JvdGU6Cj4g
T24gRnJpLCBKdWwgMTcsIDIwMjAgYXQgMDU6NDI6NDNQTSArMDMwMCwgSG9yaWEgR2VhbnTEgyB3
cm90ZToKPj4KPj4gTG9va3MgbGlrZSB0aGVyZSdzIG5vIG1lbnRpb24gb2YgYSBsaW1pdCBvbiBz
cmMsIGRzdCBzY2F0dGVybGlzdHMgc2l6ZQo+PiB0aGF0IGNyeXB0byBpbXBsZW1lbnRhdGlvbnMg
Y291bGQgdXNlIHdoZW4gcHJlLWFsbG9jYXRpbmcgbWVtb3J5Cj4+IGFuZCBjcnlwdG8gdXNlcnMg
bmVlZGluZyBDUllQVE9fQUxHX0FMTE9DQVRFU19NRU1PUlkgc2hvdWxkIGJlIGF3YXJlIG9mCj4+
IChmb3IgdGhlIGNvbnRyYWN0IHRvIGJlIGhvbm91cmVkKToKPj4gaHR0cHM6Ly9ldXIwMS5zYWZl
bGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGbG9yZS5rZXJu
ZWwub3JnJTJGbGludXgtY3J5cHRvJTJGNzgwY2I1MDAtMjI0MS02MWJjLWViNDQtNmY4NzJhZDU2
N2QzJTQwbnhwLmNvbSZhbXA7ZGF0YT0wMiU3QzAxJTdDaXVsaWFuYS5wcm9kYW4lNDBueHAuY29t
JTdDYTA3Nzc4MmNlNDVjNGFkMzQ1OGIwOGQ4MmUxMTAwYWMlN0M2ODZlYTFkM2JjMmI0YzZmYTky
Y2Q5OWM1YzMwMTYzNSU3QzAlN0MxJTdDNjM3MzA5OTk3ODU1MzUxMTAwJmFtcDtzZGF0YT1UOVJM
akElMkI0bDN6cHhVU2tGVUdUeEdRRnU0a1dmZ2hRQUtHeWZVY28lMkZiOCUzRCZhbXA7cmVzZXJ2
ZWQ9MAo+IAo+IEdvb2QgcG9pbnQuICBJIHRoaW5rIHdlIHNob3VsZCBsaW1pdCB0aGlzIGZsYWcg
b25seSB0byB0aGUgY2FzZXMKPiBhcHBsaWNhYmxlIHRvIGRtLWNyeXB0LCB3aGljaCBzZWVtcyB0
byBiZSA0IGVudHJpZXMgbWF4aW11bS4KPiAKPiBBbnl0aGluZyBlbHNlIHNob3VsZCBiZSBhbGxv
d2VkIHRvIGFsbG9jYXRlIGV4dHJhIG1lbW9yeSBhcyBuZWVkZWQuCgpJJ20gd29ya2luZyBvbiBy
ZW1vdmluZyB0aGUgQ1JZUFRPX0FMR19BTExPQ0FURVNfTUVNT1JZIGZsYWcgZnJvbSBDQUFNLgpG
b3IgbWVtb3J5IGFsbG9jYXRpb24gSSB3YW50IHRvIHVzZSB0aGUgY3J5cHRvIHJlcXVlc3Qgb2Jq
ZWN0IGFuZCBzZXQgCnRoZSBzaXplIG5lZWRlZCBpbiByZXFzaXplIChhcyBzdWdnZXN0ZWQgYnkg
eW91IApodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jcnlwdG8vMjAyMDA2MTAwMTA0NTAu
R0E2NDQ5QGdvbmRvci5hcGFuYS5vcmcuYXUvKS4KQnV0IENBQU0gbmVlZHMgRE1BLWFibGUgbWVt
b3J5IGFuZCB0aGUgY3VycmVudCBtZWNoYW5pc20gZG9lc24ndCBhbGxvdyBpdC4KCkkgd2FudCB0
byB1c2UgSG9yaWEncyBzb2x1dGlvbiBmcm9tIGEgY291cGxlIG9mIHllYXJzIGFnbyAKKGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNyeXB0by8xNDI2MjY2ODgyLTMxNjI2LTEtZ2l0LXNl
bmQtZW1haWwtaG9yaWEuZ2VhbnRhQGZyZWVzY2FsZS5jb20vKSwgCmJ1dCBtb2RpZnkgcmVxdWVz
dCBvYmplY3QgYWxsb2NhdGlvbiBvbmx5IGluIENyeXB0byBBUEkuCgpXaGF0IGRvIHlvdSB0aGlu
az8KClRoYW5rcywKSXVsaWEKCgoKCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRl
dmVs

