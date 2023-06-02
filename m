Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58033C7EE24
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jun 2023 08:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685695807;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/v3bDncYMHu+2A/7o81rpqhBHTB3quSfUeRBuggIwjI=;
	b=cNF4SkDmAJent9VboPauACDyVej5Im1lGgXLZ0SQ0D1IOWGiEqYaGJlVkgNjDoXcM6BUeY
	ZADltYwWV9rahlEfC3UNFrq8EzGHWXdYXetV79s8a5kYJGmhZvdeCmIsY4utkKtAsB9HSw
	nLvzxpGU5I7E/dDGJTPZFX/Ei24kRR8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-C9zt_F4bOVCRuuwg6X9I0Q-1; Fri, 02 Jun 2023 04:50:05 -0400
X-MC-Unique: C9zt_F4bOVCRuuwg6X9I0Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 618B085A5BE;
	Fri,  2 Jun 2023 08:50:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 56A0014171BB;
	Fri,  2 Jun 2023 08:50:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 309B61946595;
	Fri,  2 Jun 2023 08:49:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFE7B194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  2 Jun 2023 08:49:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AF5F240C6CD7; Fri,  2 Jun 2023 08:49:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A7A0B40C6EC4
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 08:49:57 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7152F3C025B2
 for <dm-devel@redhat.com>; Fri,  2 Jun 2023 08:49:57 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01on2071.outbound.protection.outlook.com [40.107.15.71]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333--Bk7CgFJOvSDTjO92S9bXA-1; Fri, 02 Jun 2023 04:49:54 -0400
X-MC-Unique: -Bk7CgFJOvSDTjO92S9bXA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PA4PR04MB7822.eurprd04.prod.outlook.com (2603:10a6:102:b8::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Fri, 2 Jun
 2023 08:49:51 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6455.024; Fri, 2 Jun 2023
 08:49:50 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 4/5] multipath-tools tests: add tests for group_by_tpg
 policy
Thread-Index: AQHZiqX5kbej4m74xEu6OQG2zGRhWq92TkVfgAD6z4A=
Date: Fri, 2 Jun 2023 08:49:50 +0000
Message-ID: <9d6a69867638aa577e5410731559ac2e5eb40fe6.camel@suse.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
 <1684537332-23033-5-git-send-email-bmarzins@redhat.com>
 <8ae8ff6b0d7d02d33da5b894c3ff1b0e4cdd8a9e.camel@suse.com>
 <20230601175158.GN24096@octiron.msp.redhat.com>
In-Reply-To: <20230601175158.GN24096@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PA4PR04MB7822:EE_
x-ms-office365-filtering-correlation-id: d67c989e-3124-434a-67b4-08db634653d4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ODp+4jgGa78NtpoOHJ8HHlKXgG2W1q41iSmWvUr/CS/dyCgFqD8WAvjtheEQKWuxN2luPHBB64fBAhSyft0Zn2Wgc68NE+9h4qsnpCTybzpJqi1c+Sbq8FCt94Si1ZlgRWiYmwHzQRGj8M8q/7p2LmFl6b7gDm02b3E2PpmhGsP7Pm/vulMzy8bEVNO1AXkDxNRxpMfKc2jX/5KgIc3hbC/dtuakWL3SAXzUm3s5HKXq4yaSG3jtu7K0kasI/le+aHyAeqC7BaOgGmDTmgFsLFLNYYHn6YgkGJKvFJPeGkQv4pr8+7Io2FcleeLO62liptXXAfp2wkvox31nxHsBLIsrVG5JzKugwEwh6QEXLxrbyBEOEmsX7FzjFV8jjEHXvFVElA7yGQLDXSdv6TquDhigcNoyXVR6eBnYt7ybBsqMpfW8bq+FUa+8HOztw0am3inGiQfDsXbbvFJoNairrWlKSVcquxUyoFZDgZtsgW5oRaw0ogd9IX3yFDPCUmSUq3fqGseVVpBlu/8wSIgJtagNrSBtS1KaGSjj+3xDiv/xDmkhOnnT5auFtF6LbR1LNn/kyzLo1D/7c6CDssdXX5b380reexctw8J+t+DChPZhb60nwewp5dF3VI5JWsn7
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(71200400001)(6486002)(38070700005)(83380400001)(86362001)(38100700002)(2616005)(36756003)(6506007)(6512007)(26005)(122000001)(4744005)(2906002)(4326008)(64756008)(66946007)(91956017)(66476007)(66446008)(76116006)(6916009)(66556008)(54906003)(8936002)(5660300002)(8676002)(186003)(44832011)(41300700001)(478600001)(316002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?FV2DsxZBZU3Fr9edV/HqEr1fQhtQ05gmR1OdQsvDK7i2lVpIQCblE9GvM?=
 =?iso-8859-15?Q?uOTtnxjQo8f2g9uBSz5qALx7QSgsumAV+wtiycum/Fdwkqpg+wE2fbFs1?=
 =?iso-8859-15?Q?tBCkyy9kD9cNlGanP9hgiGgMaZFmUQkALqPuNlaEN2wgSwNRNv+Gl8npp?=
 =?iso-8859-15?Q?ZQzVCkPQyWExQ/8Rga3JNde/CjRYRVhdHE89w4ZzbmstnCER0Rgnys3kI?=
 =?iso-8859-15?Q?DCnEkFlMvXvNd5BswMQSK4v/14gy+7wHZcEFjbPEfwrqOQlyOIVK4ct90?=
 =?iso-8859-15?Q?z2mWlDt4Ydo0AfZY8OBGytxI9Aahzh0YoVNEGMZw6+DO2ExBfXOG8DzF3?=
 =?iso-8859-15?Q?KnDXUADz9PLuHZdNTEHntjGclvhwo6VehXpHPtPXhw4OMRVpimVcknS9/?=
 =?iso-8859-15?Q?GMR55WurS1bCZqXToeooGiKHpdTT7KO9Mj8Ioj9j8ibmjPt4bkCCtlstj?=
 =?iso-8859-15?Q?Ze6713kTGjMjqmbXgJUIXlPAFZnBoOEmqriKdfbid9fRSxgBxNDRfvQYm?=
 =?iso-8859-15?Q?KU0RC4IfCJpaJQv2b7b6URjelkR5UjkyGgM9s+Si5bW44xSEMRw0OsBBP?=
 =?iso-8859-15?Q?Z10H5Wi7H8fI+qvqvoa06mWJn5ynCHc4DkbWdrgy3AR4AdUKKS7EanYPi?=
 =?iso-8859-15?Q?VNpTKhPH50LaOhXR+3Pm7IjZxH2Lmzba7HgzwK7K9Ma+sMJMMqBNRxCjv?=
 =?iso-8859-15?Q?Zp/WV7IEotsOijL4R2J8dpNwAYfZusKkbD6V+ebKhEALbziSh9aOVsJnc?=
 =?iso-8859-15?Q?hD7/5gMZzmaD46Iis1E6HaPfEH7+LrN2HKqbXfEGesZZlNRG6fL9OfroY?=
 =?iso-8859-15?Q?i+Jtj4j+wzIwdZ5Az5CjjyLIBAgJtxAcqeNZsngRoeeOxzSsZW7y//u2S?=
 =?iso-8859-15?Q?cNHTpa7NIW7cTWoAeakcCzeqd0k97eoomRB7VgMgoSxq/TAhhutfaXAGr?=
 =?iso-8859-15?Q?ZYCUUfmWN7Vmp0GbfydENbPV4y2tPdy378TFnSGI/6CTtkabfb64cdAZq?=
 =?iso-8859-15?Q?/Az7FuzKzeKNsGYyKR6Vbk7hmeHnOe4045YaSYHYEo1BqjtyI5Qd+Xj9x?=
 =?iso-8859-15?Q?CPcNkCj3ItL11NGca94RpcOAwH3GtG050d1K3SVNoE+JyM4UufzyY9JiZ?=
 =?iso-8859-15?Q?yyx8MmGwsSVm9CmZq2FptUMKf/MqMujRJT+XtajYxNJtFEDgBMgsQe22i?=
 =?iso-8859-15?Q?LitS3A1LZU89Qkb/IdIWG1oLnYi9d6mcbxEdueueJHz/keD4PEb8zVg8W?=
 =?iso-8859-15?Q?EtKAPsg1rGkiEDW7Xn8sYaz8nwudovn71Ae4dIlAHagYDLXi/x3HUn/8x?=
 =?iso-8859-15?Q?NU5OTzbH8c71ix+STs78m0IR/gTRJlufCxg4YIC2LzEih1yBOlpi/LTQg?=
 =?iso-8859-15?Q?jC5n1m3hNUMchQGEVBoE0hRpjtQ10iZrOo0QTxCFU66d1pwB9b0t081Ux?=
 =?iso-8859-15?Q?Iz30ljL/Lb5kAtSAuPfYzU9D6n1MMuI/L3TRptXUeXxJDFTbujFfMhaCj?=
 =?iso-8859-15?Q?vBLo9fUKVFTjpkP79MMbwbBoZDVeUlXNGjeZhdRbTAv0s46BHnI98mHhn?=
 =?iso-8859-15?Q?JFIz6w8U5+XQmBr7TNDbX+TfFjmiuDiOAGurxJR+bg63+HrejIEvFsz+6?=
 =?iso-8859-15?Q?PuBpVsBovV3F9+0xh7lY/oA7mVttKmpFXD+aZAeSZZOUEzJXoIp4U1qDQ?=
 =?iso-8859-15?Q?mfSD?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d67c989e-3124-434a-67b4-08db634653d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2023 08:49:50.8100 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rfPxOEiXyUZ3lCZbScex90uXm3z1ZxSNOxUvCjKxGNGhDlHnlldthe3AXX+Qd9rZiqVAn9OPxBtyu2YGq4kbDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7822
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 4/5] multipath-tools tests: add tests for
 group_by_tpg policy
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <B923B4061BBDC748B97EE6357CDF783E@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2023-06-01 at 12:51 -0500, Benjamin Marzinski wrote:
> On Wed, May 31, 2023 at 03:30:02PM +0000, Martin Wilck wrote:
> > On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > 
> > I wonder if it might make sense for group_by_tpg to mock calls to
> > getprio (assigning the prio from the path's TPG ID) rather than
> > calling
> > set_priority() directly.
> 
> It seems like it should be. I just continued with what the existing
> tests were
> already doing. Can improving these tests happen outside of this
> patchset?
> 

Yes.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

