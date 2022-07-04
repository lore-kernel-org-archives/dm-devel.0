Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D3EAC43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656941053;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=d3YMtWFTVwgStoBL8VNWx8XdT09VhEztzPs9scgQ0ac=;
	b=YLV3l41vMXxOTjajNwhtl8vY4YkTlD365ggB1JldGbkh6ijpdYXBDE7nx17j1xoAwuAqBB
	bfWs64jUZozpaaiN1FCn12eNON/AvccstCRxzJUMA9bWLqbbjYML/h9MF+xw2itquF8jVB
	+GaVdad4NnUf+mbjhpWOjg8HrFBYf0Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-X68c7PBPN1GYa13eV_S31g-1; Mon, 04 Jul 2022 09:24:09 -0400
X-MC-Unique: X68c7PBPN1GYa13eV_S31g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 348028339A6;
	Mon,  4 Jul 2022 13:24:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 21F77112131B;
	Mon,  4 Jul 2022 13:24:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E2E7B1947041;
	Mon,  4 Jul 2022 13:24:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 179BD194704A
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 13:24:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 07F294619F4; Mon,  4 Jul 2022 13:24:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 02CA5456CD9
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:24:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF0CA1C00129
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 13:24:04 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-uUi8diHYO2iMMhaQXgzKxg-1; Mon, 04 Jul 2022 09:24:03 -0400
X-MC-Unique: uUi8diHYO2iMMhaQXgzKxg-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="204767372"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO
 NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 21:24:00 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Mon, 4 Jul
 2022 13:23:58 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 13:23:58 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 11/17] block: remove queue_max_open_zones and
 queue_max_active_zones
Thread-Index: AQHYj6QEmgIxmDiTeEOZXJPM+9ovBQ==
Date: Mon, 4 Jul 2022 13:23:58 +0000
Message-ID: <PH0PR04MB7416CAFBC111056F2E3198509BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-12-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcfd5a33-6d4e-4488-9d71-08da5dc073cf
x-ms-traffictypediagnostic: SN6PR04MB4640:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SK+951zZldt1w8qI29434ohu3d8mGrmmt1lzIJtMcgdef4F/R3R4NeUih7G6T89QVORw79FHFsA1gSo94D+dV9/5OeOG1veJrh9nkK+yt7O3KW20hwRUpaYGIlM0PS1AByMHlZtQXTBILa35MFZ3LdZyUk8TaJ9bkk2SedRoEEvOqEStKt7SX8X3sD8NEgW5C8M98sSjAqoUpylQB+t24rW5b3+CRXCHhFD7xQQtttFA/RHlGmeW03dj9bgsaqzl1+Kvm45isLjrjlnBTebgfjiTaQ2GM3dJhLSmZIzTb3KoyQxpqGLkbp80wjfTGXFU/6z09r65vvcgii8JRk2d/707kGHmtZ2owzeXsHXLPOHOmyVkEbIwR4lsgGiVTxrSpSsOIxUGgkyaklV5Z7/j66mYA5KAWu0wwcSdpb3VWTNX0HxX9wREXSvPo2AEbvsY3RgS5jz32zjATSTtj6eyNkUF93ynh/bHk/59a3kgvCWbZ2FHbCn32A9gZoEnCvuMNZ4ygKEBhOPxUVN5cW+YCYTW93/8ZAfU3HzBDm5U5fOJOF3/g+4vCWSLivSMQ1r3A8HwScBzVD7qFHrxf+Vcp4XmYYRVS1DSi5s/079iURt7xqUqm8gPp19MESW1Sgcksrf+c/ObpHdp2Wr5HPwovcardf/qv1lG+pUnMbzqPGng9loTFjf6YC2kqHqJJnMLhHxXX3Az/H1Va2hXHazizUym/aorK43RIpc+v717oIhK0jYa/yFLsjlOm84fdVErhwII7t+O1Thh1Tj9S9lHYVHQVjMkjBNwn0G22glK5YQNh3aSmOR6/fcNLGWdmkKN
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(33656002)(38070700005)(4270600006)(122000001)(2906002)(5660300002)(558084003)(186003)(82960400001)(478600001)(55016003)(19618925003)(316002)(8676002)(66556008)(66946007)(41300700001)(66446008)(110136005)(8936002)(64756008)(52536014)(76116006)(54906003)(4326008)(66476007)(71200400001)(9686003)(7696005)(38100700002)(91956017)(6506007)(86362001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wQBq2qElQeVltf4bcQRWUS2qIZXfg37BoJ5oWkXx5G+jYUG55fiSV1+NIHYE?=
 =?us-ascii?Q?9wf+gp/wKPZ1X0F0aw1UIEPnvXmVPmILp0bjPmDFYaShnUEn61EBTPgbzU5p?=
 =?us-ascii?Q?1zKWoEHZApglFI9eMcJPe+wI1JCQGZkVEXKM5LBBCkpbDQZKyW1nNpaIz2PK?=
 =?us-ascii?Q?rIzPd6R63nmY5gOTZ/TeEyufqVcb0KbWfKx7j9JsaFpcKWMA/26KQ6HGE7f0?=
 =?us-ascii?Q?NNsSi1a1GI9bhIikzWyBFJjBJ0xRmqn3p1DoPOvEw7DRd9EHd8tj9RR2qEcg?=
 =?us-ascii?Q?w1W+oY/o3A+SUMu3ZBis40Y5CBfZ2xovQE3nfc6NDISZnKYMn57bBiPAhEoI?=
 =?us-ascii?Q?vjMs5khu2hs7HAoLHwXUTsS43FihTPqifPTSKK1nWcZS7NN6tSYHF7+CZw5I?=
 =?us-ascii?Q?IwZ1A4qHCsau+pCE0v97bzAJEZCvs77NxG/QDQ1hXyVzD/KE1PDX3OFptvj3?=
 =?us-ascii?Q?1TzmVgL/QJyyqyrOw/v0h6q4Jm7QPPSM/Q1QrAODDX7SZuYtoRzYheUxJGx3?=
 =?us-ascii?Q?b0pgF/wrjdlvy8T32oJHltXpIzzdQY1J3B7n7DBpou05yHdjwkvNkDxGGtvh?=
 =?us-ascii?Q?y3O8jg5nnHLzGrMYuL+2IIoDA53M194veBZIYD9Qf8r+NoaE0MObxfM8Q0XM?=
 =?us-ascii?Q?h6jHecB2d2+mhd3GcrJUgQpf1cggn8SU/MNIvQzDsHwXlG7oVwiq07rR7uTG?=
 =?us-ascii?Q?DBqeRtYQqOJwHnkxvNu4O3iPwJ5AUlc2a7R4Vu11dqsB64NAvJ/9XNoKBIDQ?=
 =?us-ascii?Q?Y1+rNCGMNuxF2v3E0Q4yD0NoBwi4LG0/RwxMZt/biNdKSgeaOgYqizraI5HW?=
 =?us-ascii?Q?TQl16V5rPd7mRQ1K4FmTaJZMorZb/U4opQvkVjtId8jmdmDxyP3Ot0H58f6m?=
 =?us-ascii?Q?nj8PE/45g0AOXGm1KElLqEY8ocg0M0vdF3di7ebNGladn13a+jH+fNIKH67h?=
 =?us-ascii?Q?S77Psmk5yGA+pBjhWzpCwYamXkRwaEgAIW999tT957GLUpB/7kzTonBWTu+o?=
 =?us-ascii?Q?DN6z2r2+bsxRr5vUzZmuoC9cWXaNH2s5CGdTavXSylI+ejo+A9dq7NlNbk5i?=
 =?us-ascii?Q?VURys9jKtlYlqnJGXLBwG80xOv10laOOZH7e2Wl+jfcBmnzKWkxi8OsykPgk?=
 =?us-ascii?Q?F6AB8dzF8L9gmJxsBARsaHQ65SJxpXKcT+weTj2a69nwR11D9bafY1n5CX9k?=
 =?us-ascii?Q?W1DKWxGYxcfELdBMsRaKpDzKbCLbqGxZf9qq0elLstKqo3ZPmVXcZmd0dtUS?=
 =?us-ascii?Q?Sse/5KxHgscqFVeuIXSGiSi/jU1Xkiq/qzf5iQ57Ihbvcn0APcRdyLU0ooXv?=
 =?us-ascii?Q?MAWAoMjwP23PZVzFTtTdSH2nnfWopyV5R8BUDFAIFrNcCBIKnL+Lpf1jjbF3?=
 =?us-ascii?Q?kEGf82pPb8RZtzYK/Lme78KVrDcsG+DjQ8XVWN+I6imt+eEcgOUNpESpC8zK?=
 =?us-ascii?Q?VhNtkh15McVSG2jGVR/EOoI//So0UyY0EmUsm+mhozs5Yjay3tARMhPHTOEV?=
 =?us-ascii?Q?dikyIMsE/TzUlzRRJlk7jTm0q30u46xPRZieDDsgoII82HmP/WiUaPLwWetc?=
 =?us-ascii?Q?z18Dx/Q3qYlmX5lLGcZYKxwS8Y859u4pFg1KwlOhjz+a7y/W1YIPd+TUk3sJ?=
 =?us-ascii?Q?WGVxIFTUVMUjqou8nLf71IIMLvHzMLL8SCU2ftB+ruOdejvY91pYg4apUE0V?=
 =?us-ascii?Q?8CZJVZQCjI1JmtPKXPfvnVMUvHM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcfd5a33-6d4e-4488-9d71-08da5dc073cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 13:23:58.3811 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ImQYNk01FyPJ5DPgwAWNT94Or1WDHzmRAm6WOE07/15NBt6VwzvpEsHtx8ceTBS6qKPrhrwvMjeU59KiWZTUqU28CCuoJjHfFvluADoYEOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4640
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 11/17] block: remove queue_max_open_zones and
 queue_max_active_zones
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

