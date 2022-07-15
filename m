Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2545C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 22:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657923043;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/m3rGkCeEmI3FqAoW7KWNEDVbHPABrdCjv9dXhX13tc=;
	b=gpRFpb1Rz5INyHmZvQ2qtYUM9zfRRJJMuE5qvTYD9snwbbXpwvTU40bYGEVIzNs6xCSNGM
	UxxNyV3NdfHsn0dBnK8bKaJEoTwmYfRXjz+QIi9AjXd0zx92e5+K6DwaRuRapn6kiu5VkD
	SpqVe08e9TzWPTg1Ys6zErc9MitYWlk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-jwGEyrvXM-C_af-qprPToA-1; Fri, 15 Jul 2022 18:10:40 -0400
X-MC-Unique: jwGEyrvXM-C_af-qprPToA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C63531C068D2;
	Fri, 15 Jul 2022 22:10:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9271A2166B26;
	Fri, 15 Jul 2022 22:10:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6BF961947041;
	Fri, 15 Jul 2022 22:10:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CF4D519466DF
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Jul 2022 22:10:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A407140E8B05; Fri, 15 Jul 2022 22:10:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EC8D40E8B04
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 22:10:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 830143802B88
 for <dm-devel@redhat.com>; Fri, 15 Jul 2022 22:10:35 +0000 (UTC)
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50081.outbound.protection.outlook.com [40.107.5.81]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-OfDsvW8rN6-t-OIJQAREuw-1; Fri, 15 Jul 2022 18:10:33 -0400
X-MC-Unique: OfDsvW8rN6-t-OIJQAREuw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by VI1PR0401MB2461.eurprd04.prod.outlook.com (2603:10a6:800:55::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Fri, 15 Jul
 2022 22:10:30 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::e9df:371c:4db4:5dc4]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::e9df:371c:4db4:5dc4%4]) with mapi id 15.20.5438.012; Fri, 15 Jul 2022
 22:10:30 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "bmarzins@redhat.com"
 <bmarzins@redhat.com>
Thread-Topic: [PATCH] libmultipath: unset detect_checker for clariion / Unity
 arrays
Thread-Index: AQHYesBA6PR50V8MFEqY2TtKCigfDK1FldnYgAGy7WeAON/tgIAAES+A
Date: Fri, 15 Jul 2022 22:10:30 +0000
Message-ID: <59728aac114115349f6ed5f368f65e9b2b423ebd.camel@suse.com>
References: <1654641901-12324-1-git-send-email-bmarzins@redhat.com>
 <1675cd007bfee3f944c986e7e8a9eec8969487cd.camel@suse.com>
 <20220608144006.GW5254@octiron.msp.redhat.com>
 <b5ad7b428d5998e39863a3144d57e40d32f72c1d.camel@suse.com>
 <20220609163652.GC5254@octiron.msp.redhat.com>
 <8dbb3068-0b27-44b5-ba95-0b6494e1db0c@gmail.com>
In-Reply-To: <8dbb3068-0b27-44b5-ba95-0b6494e1db0c@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f89e601-fe7d-444d-f9ff-08da66aed471
x-ms-traffictypediagnostic: VI1PR0401MB2461:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: NvwEm+oCpNLe4P4PlWQ6d1MrBJGxWgY8UYSiszJzWSB8c23aQL4W5Hu2H72gm5GA0zemwNWdfLi5IT9aRLskJ8OuBOefRcduV2CgeSULaqOF/wSakwgryCQC1j0DgIM4MpmOSGRRmlT0GgLgSEFRAaXP6Bv1yLewYmmA49mW/lQEig/PVFKlWZN0c8szYnaom6vW8UZLRX2oN4j66OzjFgR6gxG0ry257Ud6w5viy0LSPqZSBFisjT5lS9ri8Snp61OO+PT932w/fAJMZsKuJjjfNrZsHrvW/UISk6CBoUV1o1nxrpnboOPMLCl8bL2aFVK2Nvxc1vfRpYByBX0tSp7+nM/XdVdYSe7gdkRVcwZxjpnIbu0Dmc9zSNAWIThwWV2DmDCUS0ev4Va9o7UQ5OixiUlkibsMzF9Za+g2BlD6ba5ahaPBdkqPJllEVxwB0RL/8OQa8Yyfr1H+Py22GKe+FoC+v19QFJeCYCFCFft64SnhUzzRN6KwGPVih4Uaj/DKA9hRxi+sUMtCRJEolkmZSq+jIO85LKbtHlnjrtD5UQoo5Yg/0TRpnE7ZSHNVzfydk4eob92CuGFPfCAAFH/qojCnNVGkQmuffK4N57wdJKAgrS9DDOxKMmt1DNnqrV6xs/+dM1hBTe5vMVQ9tDXMwqiEp1UkjaO2yP/gitsi85jTHny0nSdUM/+L7m/J0Bml4avhny/Us1uBcl7g+mCnKxtLbBPIQTKCV9yYK3w3ufYC6u2Ex9amYx13d5+kdt+GZJVlvvjeWImU/G6viyravBRmDdAon3Nx25CpL2gcw2mUTcT5O7Q1wFFqIx9l
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(376002)(346002)(39860400002)(136003)(396003)(366004)(71200400001)(66946007)(26005)(6486002)(478600001)(110136005)(36756003)(38100700002)(558084003)(186003)(41300700001)(316002)(76116006)(91956017)(2616005)(6506007)(54906003)(66556008)(44832011)(4326008)(6512007)(5660300002)(2906002)(66476007)(64756008)(8676002)(8936002)(66446008)(83380400001)(38070700005)(86362001)(122000001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?IqCsz6fhxm4lS34Ae/+Uuay4eyJp3qU6cT69V8CtYlQvh820mL2y+F8k6?=
 =?iso-8859-15?Q?wc8eFyyCkFyOiII/GTGCsm6E+v+ZTMF+PQHVK7uqxzwN4el9xowqi8cwW?=
 =?iso-8859-15?Q?O2moZZWVXhSRtQ54IHlX92WWQhsyKaeXw9sk4L6EG//o4h3NsrNqrPxk2?=
 =?iso-8859-15?Q?6MuAzLHt7UrOzpz4I7Ll4ixrGv6u7HNjxIS6RFL/9OMOzATVWETmbjYmS?=
 =?iso-8859-15?Q?tC/qBnPfHQYjtbdmcmBwsT1V7hEq8KjG+ZaA3vqxzGECIEpTOHl5qpX0e?=
 =?iso-8859-15?Q?FQBBkXXeHn9xswU7jHCopisaP4GEDlB6eFPAGRBZIk5aYN7bIrC3teYtR?=
 =?iso-8859-15?Q?H/66gKhTEqmfSpudx0cRSnibAYXi38B9Wd5oLpSb46edrDzUjkKYTsEdY?=
 =?iso-8859-15?Q?BjSjtl4NrYIiWAV2xssyi+M9zPCn+rOn0bv7syxNdq5WIoRoi47bzYrWN?=
 =?iso-8859-15?Q?zQolNiXqXb5CbebrFfwa5ahh3xLga1RxUBzojHFddH6wiwiC7lrBLuuJe?=
 =?iso-8859-15?Q?B3EgChJ+7vvGow1vxwYIVJG5JuTLcarrUOxGZeMP4IGlmCqG1Mi3eYaNR?=
 =?iso-8859-15?Q?hV9LdycVADYvzcbFyugQo/WkCJlUViv+9jm0bLafyO8enozhhKWmCS+ax?=
 =?iso-8859-15?Q?lHKBhBCEEtti13VWJhqfdgaZmOu6VipQHTprn6weRL1usFooScFATIT3r?=
 =?iso-8859-15?Q?R+HaB4aqgtOT3zMZ2gyQ8PkL+yj1lqvejWAtYS2Tf9X6pd4nps5L+P163?=
 =?iso-8859-15?Q?p//ndUWDr2zIRBH0o3/eD3N/++CbUNakudgaBeiXO84uDlHzH+aS8IYIr?=
 =?iso-8859-15?Q?lqQeP0/rk8Yr+FJezlmRDv15HUWncTUS2f8+6yi0mtTc+Bk4jcr2vWMtf?=
 =?iso-8859-15?Q?a+bZFtHKs//L77eLVCkOvFFE8Lez2kbqiXWx+hz+ZdlNtbO/cZkUSdiem?=
 =?iso-8859-15?Q?+AUhyGKAwjn+JhAeEy6bQoFgvJUenk7hnCSM/1CgRCdFtgz4yQnWrqFel?=
 =?iso-8859-15?Q?21p2ZEZUdRuu9H+f316VMJPV0EKbsZi2e6MgFzoH1isV3pe1/EveerUvE?=
 =?iso-8859-15?Q?j0eOcoCLd454KurNuYah3XxORhyGTW2dRgqBwIT3DQgFM9S/XXWAUciey?=
 =?iso-8859-15?Q?RNswgTCJ/wqy8+UfQnn1rGX+5ASgPrGE1CNVKapfsQ96nX2yYNw4zFLrG?=
 =?iso-8859-15?Q?5QUDfI+OSnSLIVkJ5zWKzP9OA/C9j+XSYEv22Fp31x/gf7fa8GNw7Dqzk?=
 =?iso-8859-15?Q?zZJQuJ2JVyLWF7yxV0rwvWmYOJcyRbpbuSrI4yZ4JW/AUB7D8KonXDGru?=
 =?iso-8859-15?Q?FwI7VJW5x+eKVDf45SdFNcXvRjLBm23CRr3bPpd3sDYAgLPlmAsy/8m7T?=
 =?iso-8859-15?Q?PC11oVqsI+5wzhlQ9fu4Xitwz0FHq8vyGc+5OKp/SLWMo30cBHITFoIva?=
 =?iso-8859-15?Q?mhqLNL67IZy7YN3R0W7ykh0+fV1Kr4rLRf0qW4gAo6+eqm02qVG498yPc?=
 =?iso-8859-15?Q?3yFpaoBwKpLtIdozFeHTHJr5Yr6imcDrpvQ1H/SJYq9AiaaU7Xdeni74S?=
 =?iso-8859-15?Q?jlzZPqxZr/wpf21iwWRbED63WaenVgvNHHFGjC0X78LP55zYGoXkXFuO+?=
 =?iso-8859-15?Q?BtQzgWThdzqsjtMVKJeb0yGi0bXDa00rd1fNXcxO00MXsbkD4nJwFEiur?=
 =?iso-8859-15?Q?eQDdQRW9Pl2mBy+InOH430A3EQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f89e601-fe7d-444d-f9ff-08da66aed471
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 22:10:30.0459 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9w7PyH6icOJeBweK3e4UYawG8pJWsXv++iNl+nn3KiQQEv3odALgz5LORML6vpaHcfnX1aeEQ+Wz7p/WR9HJwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2461
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] libmultipath: unset detect_checker for
 clariion / Unity arrays
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
Cc: "vincent.chen1@dell.com" <vincent.chen1@dell.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <ED8ED8D928F5524A8BCBA30857E882B9@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 2022-07-15 at 23:08 +0200, Xose Vazquez Perez wrote:
> This patch is still pending.

Thanks for the reminder, pushed.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

