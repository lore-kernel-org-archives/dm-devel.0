Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC41C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:56:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 733216124D
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:56:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 733216124D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-JSVB9ftCPEqT6WRLFMHacA-1; Thu, 04 Nov 2021 16:56:06 -0400
X-MC-Unique: JSVB9ftCPEqT6WRLFMHacA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 160CC18125C1;
	Thu,  4 Nov 2021 20:56:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDB5F5BAF0;
	Thu,  4 Nov 2021 20:55:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FEF81806D03;
	Thu,  4 Nov 2021 20:55:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4KtmBK024813 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 16:55:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 073252026D64; Thu,  4 Nov 2021 20:55:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0066C2026D46
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:55:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FA55811E7A
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:55:44 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-368-b0sYsCFrPJuP85FGFd7NAg-1;
	Thu, 04 Nov 2021 16:55:42 -0400
X-MC-Unique: b0sYsCFrPJuP85FGFd7NAg-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-27-Q3QnhGnvMoqtxn2ODTupJw-1; Thu, 04 Nov 2021 21:55:40 +0100
X-MC-Unique: Q3QnhGnvMoqtxn2ODTupJw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5227.eurprd04.prod.outlook.com (2603:10a6:10:17::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Thu, 4 Nov 2021 20:55:39 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 20:55:39 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/8] libmulitpath: add section name to invalid keyword
	output
Thread-Index: AQHXuu1ikDzv972gE0WjBDRG9qbuD6v0BsqA
Date: Thu, 4 Nov 2021 20:55:39 +0000
Message-ID: <3214cb1e9be6070086dfada89deef4c7977de9e0.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86fab7ca-31d1-42e3-84db-08d99fd5756d
x-ms-traffictypediagnostic: DB7PR04MB5227:
x-microsoft-antispam-prvs: <DB7PR04MB522790A9C4CA61349638073FFC8D9@DB7PR04MB5227.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BviG9qwEQ7vUwTIB/7YU/yWCtwDS0F4wgqve9rp7sLWBxiSstsh0I+hXcUv09u+ovQYhTNecnwu5tfpTYXR7pz+jIvos0tAuXsQPAgwulhtbL+UfK0WdxixALyKMqA1XB5tvYIsMZB7vlt3oy7egwQFJ2lk9lnM9/skDIVpvDlFOUAQFubbk9s7r9sHjsVEov608q85aIGTrlNdWDRxf6dw20wVbjP4c1LNyClTrNeu1wYceLl92jgpTkViL3Dgmvenq9oNSikh1h011od/OqgrTWaRLviAvYPscEgfea4OwPYrsh+3B/nUHWAUntmnO9Cto4+JnGYLCWbOmX4hvMxZnBebB50jeFkVf14tKhIm/E8WI71ehlbbViBJSXkpExWcKx4Rzo31ky7usFeKwmgcJOtgiYNr8uQ/w9YljdNakXkgQqGO7sAnSoZQQH6BAnlhJFeP5aTJYulnWf/vKX0hMnbI2Ng7l8TEo/XnQhoyAyjVTIrnbvMN5Bx1sHy5UIoNu4qP3PnSk41LSLsL09vcV52WqdbTD2E0C+RKr18cBDl18BnFu9rmyfQJ+gO9TXjmhBJ64OH513zhyl+F42+5QbWZiL0Z4TTb4iJ2ROBBdP0FmuaLDYobpQ73xbZVfCb4ewzwmZkvbnNQYbyHq3DUv0SArx8oLcT2TNnQfwzAjqwnlwvq+ALCCjgIIe6jQ+8YKGxKaEFDm/UUrTPBPdA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(71200400001)(6486002)(66946007)(86362001)(8676002)(5660300002)(91956017)(38100700002)(6506007)(2906002)(186003)(2616005)(38070700005)(110136005)(4744005)(508600001)(4326008)(122000001)(76116006)(64756008)(83380400001)(66476007)(66556008)(6512007)(44832011)(66446008)(26005)(8936002)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?nCmwiVeLlWWYWUGERiFzdhyd8M5aqLoRsi46vITxWlztINKlNeE6yYWEW?=
	=?iso-8859-15?Q?L+1hHvcm2lsqt0EMefRsxE0PFrZmRz7qzT/bF5WFroEKuqLEmq3rZhzNT?=
	=?iso-8859-15?Q?fjxzkmhi1WdVBeToZ0qU4elg8IMjOiiiuxNkbe/elDVSyK5upuNNp1QFb?=
	=?iso-8859-15?Q?4qJMiYJLa92KpntcoLiNII0UHzit5V6wove64MLdXrw7syORuL1KEnLLG?=
	=?iso-8859-15?Q?g7apNp1yeaZBSnhQ9hMZgHd0PFmipKzdVrlysoEkiZjkUzMrW4uUv/S4p?=
	=?iso-8859-15?Q?YxAT5mKKRWJ9pWW7tGZnjibf67/KF45DRiEaFSh/A4XLudZRFPsIwj6IN?=
	=?iso-8859-15?Q?tOIcyW6FyqEZD+ptm6pbmHWmbb5JNaq0lZ2vulEHpmxG+qEGbY97q2Yo7?=
	=?iso-8859-15?Q?MxUlex3V5z/LLyDz7Cojw5OZH5W9W/6+bAY6S0AzhSnX8DzGCkL7t/rfb?=
	=?iso-8859-15?Q?vfj616/B6rzrP0lrpWpQR+hjzmeGsRAPh0vtVr9opxRUxqsKSOlvC6HSp?=
	=?iso-8859-15?Q?f1we+DaxDlVJFmWEA96/S9f72s/s/mr3Wf6i4mMWkXp7JjdbIgJhdBE7E?=
	=?iso-8859-15?Q?RJMp/sgHIlHS8HldiTOPhCdLKvzmHMyPak8pWLudGkbuuRsRvPvTAXKcc?=
	=?iso-8859-15?Q?iC1D2BwsZp2WlslXdEwM6eZ8+fZfWAyXZTG1YE6qx6BAri1yhQIOBNt8B?=
	=?iso-8859-15?Q?a5iqjxhKj30M76HsRkUHOfBV8U5I73QASSxF2Q+UOy7pqQY+6cabViTJt?=
	=?iso-8859-15?Q?GIQqsbqsXhwivbBkTeRobsDqSRe/ZOLH2F+jDXkg6xmjZYPFFiOdu2izF?=
	=?iso-8859-15?Q?DGlnb5QAXVX5nLAminRqhZBpVCq0ReYZaPNaM74SASxfQ4d6EksK4/UFk?=
	=?iso-8859-15?Q?mGaFRA1FnrqOrWp6GdKcijvjbdmxiGCyIiOxntGAiPMf7pyMLhHQDocV2?=
	=?iso-8859-15?Q?YXilx4xRlUN1uqxXYG3sTfD8VIc6xMERoORnj8WPN+Hhs61EdirlQAjwK?=
	=?iso-8859-15?Q?wmptr81qL8o4998nZkrMVbnlQjGkUsajHo3APe4pAYmM89cOj/5UTXqbu?=
	=?iso-8859-15?Q?ZlQLzJiZefKrhdQ8pKhG39j9+Jg0kUrJXt8EbmfsBFolwLZH+58yN3mPN?=
	=?iso-8859-15?Q?kipzyPu9xvBBUWD+UQ4PU/dopqW2nC3K5JD09N3TESD4Xp1fN5uHKkztk?=
	=?iso-8859-15?Q?5qrG2Gu3DdPsCj4cfjJAPfiv0CnMNqIV1vKR1tnNO5dIY5Tp01gZkiRPW?=
	=?iso-8859-15?Q?BxYbeAsrltZ8rUcMok00gepDrJVDN8kO2UUkKWMmBhPMM5mcYjUQtPBpi?=
	=?iso-8859-15?Q?lNOlZ1In3FSk/1ZCYx8g+rELbH+hZyE3+jsD1y5pWRAKguYW9FM2KvFc8?=
	=?iso-8859-15?Q?XuuXwvVM3rCRSFaGNqfhCL3jL8+nvRyBomhUWIaIQ6aggTYG3aRVCsonf?=
	=?iso-8859-15?Q?wtwbU4x7At+xCmHyf2Sc1N2UpU8n2XzZWEOQcv4Z3kmBmT0ssXhOP3LjB?=
	=?iso-8859-15?Q?muSRKBJYi1JXSYLsUMGUA7xLbq26VmrM7cBPLYT8cv9NV7qbaNid8ZYRa?=
	=?iso-8859-15?Q?nHfgMtHn32tOUt4roW/wNHBRLILj7Wj2c98bPerP/ZOR/Ql4lPQastSM2?=
	=?iso-8859-15?Q?HmmpulSv9dXIsy5X3yNQ1bqFztJPhlrr0hFD2TBaucObdpTMGvRBuW7D9?=
	=?iso-8859-15?Q?k50q5ojA+D7lpk6x6bTbaamtWSbxm91H4BmRW9XMgbVmS3M=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86fab7ca-31d1-42e3-84db-08d99fd5756d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 20:55:39.5628 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: amRRlUbPH8dr5Sa9NUyqne7GwMIUyeq0rNpeOJYWO2HY04yqOTixerHezHnxssZ7cqS1TMfZMiUSAR5XZb4Yvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5227
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4KtmBK024813
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/8] libmulitpath: add section name to
 invalid keyword output
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <159F1B9BFA34C0468DDA32412CC73FA2@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> If users forget the closing brace for a section in multipath.conf,
> multipath has no way to detect that. When it sees the keyword at the
> start of the next section, it will complain that there is an invalid
> keyword, because that keyword doesn't belong in previous section
> (which
> was never ended with a closing brace). This can confuse users. To
> make
> this easier to understand, when multipath prints and invalid keyword
> message, it now also prints the current section name, which can give
> users a hint that they didn't end the previous section.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Apart from typo in the subject:

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

