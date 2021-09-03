Return-Path: <SRS0=d4ru=NZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15722C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  3 Sep 2021 08:20:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8D612610D2
	for <dm-devel@archiver.kernel.org>; Fri,  3 Sep 2021 08:20:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8D612610D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-vKogOxmzO6esaMipidNUDA-1; Fri, 03 Sep 2021 04:20:40 -0400
X-MC-Unique: vKogOxmzO6esaMipidNUDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52709824FAA;
	Fri,  3 Sep 2021 08:20:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB0825C232;
	Fri,  3 Sep 2021 08:20:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4693244A59;
	Fri,  3 Sep 2021 08:20:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1838KThD030853 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Sep 2021 04:20:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DE1E020357AF; Fri,  3 Sep 2021 08:20:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D85B32030BFB
	for <dm-devel@redhat.com>; Fri,  3 Sep 2021 08:20:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB6A5100B8C0
	for <dm-devel@redhat.com>; Fri,  3 Sep 2021 08:20:24 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-141-cVFk5YFxPNe3vTK3mg8auA-1;
	Fri, 03 Sep 2021 04:20:23 -0400
X-MC-Unique: cVFk5YFxPNe3vTK3mg8auA-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2056.outbound.protection.outlook.com [104.47.13.56])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-20-HAs7QfzXO3u3UHFzGLFnFQ-1; Fri, 03 Sep 2021 10:20:21 +0200
X-MC-Unique: HAs7QfzXO3u3UHFzGLFnFQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB7162.eurprd04.prod.outlook.com (2603:10a6:10:12c::13)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22;
	Fri, 3 Sep 2021 08:20:19 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::5158:3113:295b:d9c1%5]) with mapi id 15.20.4478.020;
	Fri, 3 Sep 2021 08:20:19 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 3/6] multipath: print warning if multipathd is not
	running.
Thread-Index: AQHXoEWbIz3Xkwkv9UGBr5LVJPvjyquR+IMA
Date: Fri, 3 Sep 2021 08:20:18 +0000
Message-ID: <b84f6831e2e7ecd76e6690fb49a67ccca40153fe.camel@suse.com>
References: <1630619869-12251-1-git-send-email-bmarzins@redhat.com>
	<1630619869-12251-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1630619869-12251-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd6e3fb5-d6c1-4f01-4af2-08d96eb3aa9f
x-ms-traffictypediagnostic: DB8PR04MB7162:
x-microsoft-antispam-prvs: <DB8PR04MB716242582D8BD08F9FF357C4FCCF9@DB8PR04MB7162.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FzWNU8Q0NUnDVeWU7o20OCw11HK/IF8sSpPCQCeEgps6LaFY1IJQZ94YqGeMuJyMNZz6qRWWtQZcxFyAivI9UkMvhr3WsOA73DpZ445cf0VB7f146F7p4pzwHtUnzq38NVK69ZElDdWgZ4H6bY/t82ZNMQhburz86yLp29I7ZxBE/HyK7wrLbR9kI6uB/wGEkrfJdmde58F0NTzIoIjPZKrw3YlsbEtH6GhCfU9N22H5HrOdf7PFbzYcAeSJWrGB4bS2ZrXZFIt7s6v9GuAAA/0KIzhkhZTiySShvM1U6yuWt3tEQ6nu8e9q/FExXL4VgC/d5+WYPzc+Mb1LqHQ0NBw/10F+NSDIlyiKmrD/5QQOQffbcNuEAVFEbio5EaLzMIt0yXjGCa97EjrfXZLmL6z3UY8I7nAp9sA/HLLzS6eKeMhvgcWgrEIl1zBZgScjd2T9p/qhMaALhGLBZZgnKsZoFL2nrt0/DEcNSA+IjnZ0O+8W6vdfQR4LGETq8JQ4AjnomprHvPbSmw4fBb3hwyKQxQcj+2AFwornh+602Q6kZnU1u9bTzghzyd+AcI6dTXfykW6zcRgvPYyuHq1WUfNZVP0psqlx5JBf5Mw49t84LiEpTxfxu09J/0cyI8AGukDm0gZmNz4Ka5o004LvWeqtKABY8lz3Ecvc6HQmzcD11RCiqhbV2Sv1PJCC7UJIsQechr0slmfVuTK9yQY3+A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(86362001)(38070700005)(558084003)(44832011)(8676002)(2906002)(6512007)(8936002)(4326008)(66476007)(76116006)(508600001)(26005)(186003)(66556008)(66446008)(36756003)(64756008)(83380400001)(110136005)(5660300002)(38100700002)(122000001)(316002)(91956017)(6506007)(71200400001)(66946007)(2616005)(6486002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?vfxcqDcD73U6P2gnWrautgDpRIGLM/D8jYxWlV5CKb2DE/U5N//uZC4DI?=
	=?iso-8859-15?Q?rWdVD9rOysVx/B0rAOF6t0Ffo+y/QaOSaNEnlHiS95bynO5oRbwHASBVw?=
	=?iso-8859-15?Q?jrPq1U6J2AwKIEiCQ6COdQM51oCs+K8pfoVIS0EDs0RftStUfvhQQ/tFJ?=
	=?iso-8859-15?Q?ThS6AQ1/eVnw87OcfhE7g7VZxS2Sf6LoAu1XmQUeGSAbI/SgMQ2wPgG1H?=
	=?iso-8859-15?Q?Aj+i9CyAMjARQapKxfbCe078ccbPBybbIVH8/fNRAGs4jFXutxBn4GSBJ?=
	=?iso-8859-15?Q?s2f0H0RA0Hd4prV+kynelv0n1zdtY9Lr4xMywFkds4y948SC5dgB/iDsQ?=
	=?iso-8859-15?Q?Oy0PCTaEuB7SIjCscZ5HiLd1LNP+4MaSBk8In3TnoSkQxv4ZLOGz73w97?=
	=?iso-8859-15?Q?kMYmy4nDOgaC5NCgYtio5HKnkEEcUHtZh2EJbBv0G99/hMaPhOy2jkDpy?=
	=?iso-8859-15?Q?A4h4DTdCUq1Yp96eDKrLs2Mw/6JoY5PH3uWZdcRyIc2ANZ0QaF2d/RiVw?=
	=?iso-8859-15?Q?tiYLJnRv3vqOgrEBnJRg5LygsbxvqujVVGk6jEDQgpOY2x/kquGdlsToA?=
	=?iso-8859-15?Q?zgPvyvyEHaAi0vfJDgCMZ6X4UF/eOMxweBFm5C1/6kldtqYtwoeyIV9Jb?=
	=?iso-8859-15?Q?1xUt34VEgpj9QUjsGIJwJnG8i7t8ZNxKiaPeAqzYiQ8n4saMBqwLRriOA?=
	=?iso-8859-15?Q?SY8sw7nrpqX+CgtOeQvGi/+hCLRLIu/i1yr1pI0K/xY/CRQ1A7KupUS8i?=
	=?iso-8859-15?Q?1baGZTC3erFjN2G5ORcdgKDe/ohLcpkOFbPuaOYO3C8mjqycpYqgtUc8a?=
	=?iso-8859-15?Q?dA8fn04kydO4ClR5Z0xgiuverQRULMvIvlhPoH6jIkTv4KrbKZ2o7Y6q+?=
	=?iso-8859-15?Q?VNWtzLZnhgVUMvK7vDyJARBS//G7zJrllEIbQlu7HyDBd7mdGk4YicCc4?=
	=?iso-8859-15?Q?cbDj4TxzHIapKeB6blRHXBYzsCUaGx04g1StCuxIMH7Y1X4WDtWRceWY5?=
	=?iso-8859-15?Q?+dfmK0ntJE0xgJ6v42agHFHbUk2aAXrCBXzaN/R/4xdMFvEEARHL0h+WI?=
	=?iso-8859-15?Q?C9iimz3nPNvs0GlcpApIAp4kX4p/LY5ecXzSR4LrhqBYyDPH0Vv7W1deN?=
	=?iso-8859-15?Q?VtABX7k+zbcLCXU4mClRmGktTSbS1Ys2lOKd7lwqlQsjKVUIKaaZF33t4?=
	=?iso-8859-15?Q?dE/ZMgNkc96sJgFSHUMGHsLGvjRW0q9JTmqJmfm6/a0u4q/4tbreFPSS9?=
	=?iso-8859-15?Q?P1KBfm+ckVfYzfUnWwB3WnMNZyJokxIspIwgc2qNA6D4AYRw2Mt8QtA/7?=
	=?iso-8859-15?Q?n16DzshtNi4y1HMexhAR4WyRG7Jz+2M+ZC6ZWBLug4dBjfa6UwJ23Ayew?=
	=?iso-8859-15?Q?0MtSRUNOn8qWBZxWNuYF3sb1URB0Xt6Jf?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd6e3fb5-d6c1-4f01-4af2-08d96eb3aa9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 08:20:18.9623 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jDnNjjav9uGFiSCh6kaDeb1zQ8kCkWvvUk430sN6ff3aCdFdjnYtYWZHdOPIYnBeiFAQhZirgyD716GxGqGSkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7162
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1838KThD030853
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 3/6] multipath: print warning if
 multipathd is not running.
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
Content-ID: <C01A95120047E84094DD9DCDC9674DE9@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2021-09-02 at 16:57 -0500, Benjamin Marzinski wrote:
> If multipath notices that multipath devices exist or were created, and
> multipathd is not running, it now prints a warning message, so users
> are
> notified of the issue.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

