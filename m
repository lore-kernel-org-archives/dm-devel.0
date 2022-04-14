Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D01DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 07:53:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-bbHj-3j9NTGYvJv9q-1Kxg-1; Thu, 14 Apr 2022 03:53:42 -0400
X-MC-Unique: bbHj-3j9NTGYvJv9q-1Kxg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82DA93802ACE;
	Thu, 14 Apr 2022 07:53:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3181940E80E0;
	Thu, 14 Apr 2022 07:53:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 880DA1940345;
	Thu, 14 Apr 2022 07:53:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A56B21940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 07:53:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0644740E80F4; Thu, 14 Apr 2022 07:53:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0170340E80E0
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 07:53:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD847185A7BA
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 07:53:34 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-j_GQfMnQMLKNupK4kgSUAw-1; Thu, 14 Apr 2022 03:53:33 -0400
X-MC-Unique: j_GQfMnQMLKNupK4kgSUAw-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-40-R6qrs5lwPOeRyHpj9ErrFA-1; Thu, 14 Apr 2022 09:53:30 +0200
X-MC-Unique: R6qrs5lwPOeRyHpj9ErrFA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM7PR04MB7079.eurprd04.prod.outlook.com (2603:10a6:20b:11d::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 07:53:29 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 07:53:29 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 6/7] libmultipath: fix eh_deadline documentation
Thread-Index: AQHYT7gE3BKu1gWXvEyNVdhZrd0FZKzvCgQA
Date: Thu, 14 Apr 2022 07:53:29 +0000
Message-ID: <e9fe69eb8f82527915f728b8b61fb49ed1d9cf6c.camel@suse.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
 <1649910461-25263-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ae1bc3c-17c5-42bb-38a8-08da1debdd35
x-ms-traffictypediagnostic: AM7PR04MB7079:EE_
x-microsoft-antispam-prvs: <AM7PR04MB7079AF3D12AD3A7B16B51558FCEF9@AM7PR04MB7079.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: +k3KC+FRhED99Vz7M505k6Y8LqRNGCHCoKbWAcp3O2gtDKPiLfyny+VxInHeZPiUgwCXoRafI8MgPGgTt7gS8C8GBYDpTZp9ljddWdmzvWz58597UIrROPbCGbNwpoyaP9SR5IBX9A4/7kaFi+zvUeuGo4ZALbESo0qXtZ9STvT69CnjOCX4Yj9tGrciZVPbDGcdYVD/ZURdJTFSAR3IdQ3yT+SdYOU/tJ+2OZ5STbI8AEQRh9DTGmNjJBP2nPo3F3AQgt66znGItVvR9lhCzajqZh/odT8lQH4Yd4CQgNu/zi8WB5plh6/y+InFEOYYPJbt1o0aIyu08A8hWfDO7s45oLmHfpkJClgSLGzUHk6P31MI24P1PK3nHYtuBrm48Nh/JqoHDU/M2vommaEdSokKMNGT/igP7NXdkUZQlaWrEjVR2cAB0qI14k2QMRAKV9tFkUFchH+0rki9zn8lCdL4ZPUuY+s6572TUh0WWjwueriHEeiuSvBvOQjdfQ2YcLCIY7DtBzfgmxq5H62yWO1EzxAb6llWADxsky8bOcwfzPIRRmBoka/RaO2ULJQ1HReOyDOAtUb3jgw5ilO1M7dKdxh/sqCvhdOfFPGMD9KoZgeuXe96dPVNBKgEcvavu3dbmJ2lzYy8DsczEoUFF2R8v1YQ+UAGQYDKvDM9a8Vx91tX8QzI3llji6ijKeD3H5GFyggkJMTbB7RLd9pFkA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6486002)(2906002)(5660300002)(8936002)(71200400001)(508600001)(66946007)(64756008)(36756003)(66556008)(66476007)(8676002)(316002)(4326008)(86362001)(91956017)(76116006)(66446008)(38070700005)(38100700002)(558084003)(44832011)(110136005)(122000001)(186003)(2616005)(6512007)(26005)(6506007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?IkPYO4GQnY08gVRsghwdGN1OWhZbhfKKasOk9RYc96lwYXtZ9kS1atBTE?=
 =?iso-8859-15?Q?D2iIw0m/IFWHSJNaQNXVmxApXbLKzNkJROX12rvbFOEInySw+v/7Me16r?=
 =?iso-8859-15?Q?OxjBziw+Nm2GxKgtLVcSc8C7694aH2VFAO4J1yUNMQ3zvcXM79MOu0D9V?=
 =?iso-8859-15?Q?pXwz5DvfZFgaO+UCmU+GavJt93Qz6LhsHxAQ7nsF7+Fu087kLmcdaAilg?=
 =?iso-8859-15?Q?O7J2cWDAmALYQuJx0wheO83EjmsigkV/cpn1FoP4JYYlgTvwvAeFwJfUs?=
 =?iso-8859-15?Q?vOdXqWBw2YuUyuK/KFsRPdvUA6F5GIgdYRM0MJTqMKIfxt4FSW8COJAJb?=
 =?iso-8859-15?Q?NrVEw9k2ptLS/pVJX/e3tQTf7LGOPyoB3eXBcj9haFxvnkKux+lA9L4H+?=
 =?iso-8859-15?Q?kPU/rgW+HvnVHRV2uskwkkDf81Y3+Kdo5vtTvz1/Jnf/SUqikGWsI555x?=
 =?iso-8859-15?Q?7RCL0l5UwAfOKLwnKF+SAGa1WrL9s+B9AAtb/dlde78UFrwePwK273fBl?=
 =?iso-8859-15?Q?nzLCu5t+1XThiJvyTUFQ5QUs0gY3dkb6BnPI8LyQLCMqEt6uzjWWx0CDO?=
 =?iso-8859-15?Q?gqMVknbqvvYeeUVV5fAX6stivnD+KDpPYXG6wbtT5KjUEvM+hkEV/+4Lo?=
 =?iso-8859-15?Q?LKUe3ED3gsblIYij4u//q/OIntSjbM0nRneqzBw+lFgWDRwSFDwQUsA9J?=
 =?iso-8859-15?Q?xkoT7ivC71OI855ngrWU8e7pgeLzIJdjAVzxoqykwaItvAZXSbsBc63VH?=
 =?iso-8859-15?Q?kTFwcfsOb0BhcFAQjZwOsad08F6W5ko4XHici1Ldin4zKyxAi4XExo7KA?=
 =?iso-8859-15?Q?1/a3apg583KV9SUhFxb0kyxyYPZmAwQxCtMu1iO3k1AyGfIBNiSjKfKCh?=
 =?iso-8859-15?Q?2IlNS3IWipQEm3EVjzLMiakNJHGrset9xv4sQkwNKvXu3vUy1ZX7D9tIG?=
 =?iso-8859-15?Q?oiFqyPAza3CdE4HfLjfFrj48yZRQ+qnpyd+PVRc5ccX8bvRIpNGS81xva?=
 =?iso-8859-15?Q?S4Tk9WyEqQdwDNj0BLbXiGWIluME20ofpmiOrhbbYi6kpvxNFPgN39NdH?=
 =?iso-8859-15?Q?RNdIUXtO2tlXnZl+MUjhtLRZcQXAxKoXDIgDcqGXkYPwTkI6ySYRFU7rr?=
 =?iso-8859-15?Q?/70UMufBDl4ufwukk7AJmac8fqkv/LtfDTWSacUsOym+Els6APLBBwNJG?=
 =?iso-8859-15?Q?UO9JKo52B9i7bXTHIzCNi+sFgGm/K0A6YN+hnAp15L4T2rK8swj3N1781?=
 =?iso-8859-15?Q?cV5VLaR7Fqc0cJA18YRBR7lp2cZSh+1Y8hlKyjzLGTQKZdukh8GdCX4pE?=
 =?iso-8859-15?Q?60gXH2WiRq2nc3WslKDBykrA7DHfLeCe4RMQYxhHCoAAPoVvrwXa89Wns?=
 =?iso-8859-15?Q?d+WKyZf4Ox7xMSwM80LY50ejF4X/WISMiyG1FaXtxIMrrjZk+q3zL9OW9?=
 =?iso-8859-15?Q?VooHOgeSJ9jpbBIFnw5aRuLEg25MwylUeU8JL595g3lbYiUIxExpH/RNv?=
 =?iso-8859-15?Q?Mh6Mh+snaqc27Upk7gBiC5mhfdugNXdR+arNHJv9cGg/gcXEle7/3004N?=
 =?iso-8859-15?Q?E9Bbi/43aW/ZTTRM4zQcjRVvEEek6DNsJiZJfyB3gqYad5m/7qad2TTgq?=
 =?iso-8859-15?Q?YJQ6IXMDR1N3hZz5nD4Srwa5+do8ZbDqoVMKsMv2Ni3hXw6zpfee8xhjp?=
 =?iso-8859-15?Q?m6WAeosPT6FwVTQtnMq9nTxkL5ffHH0kzuvl+HLkZI4wzkNFEs0hurB5q?=
 =?iso-8859-15?Q?YkN4ixLsFVow1QUbCKV0lFhVST55QWY25XyUK4vUjiVes4bomXAuRHGnC?=
 =?iso-8859-15?Q?I7ZuSP4IU41ocBIJyGb/FhmYTdbzvcp5YBjaKnmgquFzL/Ik1qmjiTpqr?=
 =?iso-8859-15?Q?tBDs=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ae1bc3c-17c5-42bb-38a8-08da1debdd35
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 07:53:29.1494 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6uOTy6aYwXgMz5lQS1Ai1/iSGjzea0+tT7kmoOOI11qAhsZ3oHxfpyFKNutlmdKyHGqFQyI5qQbnwOhlkus+LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7079
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 6/7] libmultipath: fix eh_deadline
 documentation
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <AF8807A568EED14BAB544ADD0059ECD5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2022-04-13 at 23:27 -0500, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

