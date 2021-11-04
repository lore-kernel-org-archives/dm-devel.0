Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA859C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:55:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 36EB66124A
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:55:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 36EB66124A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-K4XSHxnqOzO7-BR5ayuHzA-1; Thu, 04 Nov 2021 16:55:22 -0400
X-MC-Unique: K4XSHxnqOzO7-BR5ayuHzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E0A210A8E01;
	Thu,  4 Nov 2021 20:55:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C84445D9D3;
	Thu,  4 Nov 2021 20:55:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A4C3A1819AC1;
	Thu,  4 Nov 2021 20:55:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4KtGKP024655 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 16:55:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3E353400F3E6; Thu,  4 Nov 2021 20:55:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 396BA401A994
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:55:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 173E5185A7A4
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:55:16 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-518-3R97EJ41PqiYhGnuyswOPA-1;
	Thu, 04 Nov 2021 16:55:14 -0400
X-MC-Unique: 3R97EJ41PqiYhGnuyswOPA-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2059.outbound.protection.outlook.com [104.47.12.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-33-dzRntTVXPLGc3RxuRlXuag-1; Thu, 04 Nov 2021 21:55:12 +0100
X-MC-Unique: dzRntTVXPLGc3RxuRlXuag-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5227.eurprd04.prod.outlook.com (2603:10a6:10:17::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Thu, 4 Nov 2021 20:55:12 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 20:55:11 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/8] libmultipath: print the correct file when parsing
	fails
Thread-Index: AQHXuu1koqWgOi34B0qEXdasldSStKv0BqiA
Date: Thu, 4 Nov 2021 20:55:11 +0000
Message-ID: <1221436cdd96957adee4b896d682d6cf085bf3ee.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6600a2d-6e8d-45c3-75ef-08d99fd564ec
x-ms-traffictypediagnostic: DB7PR04MB5227:
x-microsoft-antispam-prvs: <DB7PR04MB5227872347D96A28CD7296FFFC8D9@DB7PR04MB5227.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:383
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: k2aXJ2tc1HIeffQqe7tgnJC1IT5OgncLCMgYDfyTeifnNhuVsrHOBXjPtLtDYyBIw308PM1Ifn49H9UsjN6lWY2C+GJMb09xWoiqdsXhrZr2xB6Ri3VKJX5E+qS8Dk2C60GQGHSQReEQeW3yuRjltuNTeC6N38y0hcVQSl3S4GURAASTkgDaFKMvCzk+Cmtix0jseT5dGUKcxagD93KmlvfGI02jfiBWDpaOe5MIgiOuir4dTzVzfaM9V27m6YqWrBN/UeQyK0cuHfpYhcBgc+4YAnvt/j8q/dRzbtQCs9vhKLJxb+oslhVdr6Bl9NC9E9TzwEpVB48URieg3aMefKnmp6cqD45kjQpUu+BXBJ5+pqgY/fi1DvDe80MjvSWYuulMJnBRpee/RznlTr6SNq536rFIqlE/BN4ssi0XC9W1yPgRW1XcHZvKSUzPFGf5H33pxl3MBkg5Iu6I2fMEb5EbqwaC9nT/J7BfOzGoMQNPJplDNAKILJOoY/zcBGyv9MVCeVST+BDSzqk7pmSpXb/8Vzd+5mG3W00oH9oNu6eDIZ0OAfNFsL6mMeOuFaCjMB+Bd0DTUkLOJfAnORw1J5wnK+mRmuPOUb881Ybl5grAA8eLKKWW7MRbD2G83/5uA/sjqLZtm6OheR4wPvcQCvRY0w+czdTQG32m47Op4XSdglWjjr3KdLUIbIt1+zf1ULN5zrX15vuu6CXMAsC6Bw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(71200400001)(6486002)(66946007)(86362001)(8676002)(5660300002)(558084003)(91956017)(38100700002)(6506007)(2906002)(186003)(2616005)(38070700005)(110136005)(508600001)(4326008)(122000001)(76116006)(64756008)(83380400001)(66476007)(66556008)(6512007)(44832011)(66446008)(26005)(8936002)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?Mn0hTznBTP07Qt4YWShFd+V8uG/FnjfKA2s/04kV0AVzyuf28nUwI0UlQ?=
	=?iso-8859-15?Q?yBkbfXsDMlpwmJf4WliPhyAjD1JOF2pBdVTAOG2HRW/k3712RpR5Ivc2R?=
	=?iso-8859-15?Q?isLDMfDNFXmHImBgvQ5LVfHp7xhzbtX1WX8Pu+wq61p4V3ZoiGK4zvL0I?=
	=?iso-8859-15?Q?VYi+tf7LH1OiD1w3+L+fUgUMos6FWn6gBsSpkYpwVsvwe4UgrDvzpTKr3?=
	=?iso-8859-15?Q?bSABhOdRDBEHpt5kkFr700xG7yX6VeJ0jzrwwW4IZTTNHW8WrN591hQWz?=
	=?iso-8859-15?Q?4nZsotAtj7WG7o4tiqpGmWVeI6x58a7H56qXIR7U/P9JlD82LACxzXS7i?=
	=?iso-8859-15?Q?iqCxb3OXX3AjpGXA8VmoGiJhE0OaOPfLKMj4jpT56ygXWQDOsd7X11KXi?=
	=?iso-8859-15?Q?xjBTzr8vuGYLQDGeU6lFXveSIEYWIORq9EKoDG38izsFcssu5jGxQU6D0?=
	=?iso-8859-15?Q?WnVWULfYf6GtyS7WnY9kFhWJJCNi14vg1OxSd7cE59Ip8l+bgEdp5k2tv?=
	=?iso-8859-15?Q?15f2OxP5vDJREOUXoIT5DrgxxjQIUPiuV/mkRs8YwhTqQGaFhk6eY5mEN?=
	=?iso-8859-15?Q?GPTpAzTIXmOLt0APGeps4JR57HgyIL4d/oyhx4AXQXq0M86VEVunljjyB?=
	=?iso-8859-15?Q?x0TwcBE2yOK434D2NgXJhhvyjhzMO9KjiUtNbJD1RmJ3+ewidaiEsbBIB?=
	=?iso-8859-15?Q?n2o/3fPCBEDr6nvePhvAiRZ1hUlibtQi5QG4oseFqG1moUFp5Otg8xndL?=
	=?iso-8859-15?Q?wVwgQSEIBfJ6L+364oPgfW4EUFMngOpXOtw/xjZn/hcsdn9PQy8NaMtb+?=
	=?iso-8859-15?Q?8VGL5W2r4ELtzuWt2D2phUZTGmQ2QEEJXpP4YjnUUJoBBA0/ukOTXH3bN?=
	=?iso-8859-15?Q?9HBCQPvDuRZWIneLMrSTEV9pIbUoF/0gbfIGRYQFqEg0W3mOGqglGVM9C?=
	=?iso-8859-15?Q?9YaualBtY8YJihLuiY/zlvJNIg9MNhvkmVoWV3M84JEx1tFpJ0wwK26Q8?=
	=?iso-8859-15?Q?moAqpAjoOEmnuGGMU8tjQ+AITdCkMLufr9QAyv1y9ozjpS7V89upqHMZH?=
	=?iso-8859-15?Q?4JKWLddLGUf+UU3/mQa0oCg0ViY8TYl9VhMvsqB2zoqzcO9wkWKQ2+Zkg?=
	=?iso-8859-15?Q?UAVblgr4/+4sYbGT+TQ5uEGBCg6vOyqZ1RvHBWm+gYFmLGVBNSrZdqiWi?=
	=?iso-8859-15?Q?sFLHYjnhzwrQv7npZYI3504S0WG00xsUpMXyL+y/QZzpULsCOqYF+lHYk?=
	=?iso-8859-15?Q?uF6jB6Y1srXkvPFbr0bKtqUY2CPJTpsUhmLA2iR+9gfaV+9jGz9g6w81w?=
	=?iso-8859-15?Q?J3/CaIhtPLv+D1sMYFBC0WgAFrUvhsCaMDgoyhY36KNzFyCsArREzSwSf?=
	=?iso-8859-15?Q?4IeBUQu8/8D5n0ahbPq8HM+83dsPrRdg5nrrhR2I+COkkst8Qt0MDddGp?=
	=?iso-8859-15?Q?sKpag1I3zFbh6w15SpToml9fOXf89R6swS8hA0TM/bMBK7bwqktjN0EW4?=
	=?iso-8859-15?Q?+G7At6PQD7/DvV4jS2ax+dG2Tpu+82PkuvnLnzKBV/QxdIdj3/yRBSfle?=
	=?iso-8859-15?Q?2iTqUVCi8zcpIBifMw5vIShu8we5rPcxmPmpkXkc6QWrHOu822XIWKSRL?=
	=?iso-8859-15?Q?JjWmGg3W1wOQ9zx59mnX/pTaZIhdeopy+bScwL4a6kOAJ0DxuMhPAxAR3?=
	=?iso-8859-15?Q?y7Jc/MARzbQFNGLXFPOpQkpoBKpaCsH3Bw+b57u0Th9fuz0=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6600a2d-6e8d-45c3-75ef-08d99fd564ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 20:55:11.8605 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oz5+dnEmgBr4Ob7yjesKWo75vg5zaAp+uAVE04s5k0m0HJGWTuTFG3YUX9nV4ih2HGdVbhyL7ajXO/1hy5hiaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5227
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4KtGKP024655
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/8] libmultipath: print the correct file
 when parsing fails
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
Content-ID: <86060893AA244245834B611A136FB532@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> Don't assume that parsing failed on multipath.conf
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/parser.c | 4 ++--
> =A01 file changed, 2 insertions(+), 2 deletions(-)


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

