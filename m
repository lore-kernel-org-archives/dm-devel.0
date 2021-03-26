Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFA1C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 16:50:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3416361A1A
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 16:50:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3416361A1A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-D4wzcO9mOlOocjTSALNbFg-1; Fri, 26 Mar 2021 12:50:16 -0400
X-MC-Unique: D4wzcO9mOlOocjTSALNbFg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEF5180791A;
	Fri, 26 Mar 2021 16:50:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A82810013C1;
	Fri, 26 Mar 2021 16:50:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 141FC180B451;
	Fri, 26 Mar 2021 16:50:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QGo8B4004141 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 12:50:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 116581032B6; Fri, 26 Mar 2021 16:50:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A6CE1032B0
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 16:50:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4CA5101A52C
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 16:50:05 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-399-6dZQODJPN5mTBbVLT028LQ-1;
	Fri, 26 Mar 2021 12:50:03 -0400
X-MC-Unique: 6dZQODJPN5mTBbVLT028LQ-1
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-5-8lwGlep3P5GzAgZppQZgmg-1; Fri, 26 Mar 2021 17:50:01 +0100
X-MC-Unique: 8lwGlep3P5GzAgZppQZgmg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB9PR04MB8345.eurprd04.prod.outlook.com (2603:10a6:10:246::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29;
	Fri, 26 Mar 2021 16:50:00 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3977.026;
	Fri, 26 Mar 2021 16:50:00 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/4] libmultipath: avoid infinite loop with bad vpd page
	83 identifier
Thread-Index: AQHXIdpfH3vAGhMT1UWzw93FH46mB6qWfGaA
Date: Fri, 26 Mar 2021 16:49:59 +0000
Message-ID: <10967072985d334ea9b07641911c8eabe6317836.camel@suse.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
	<1616719966-10221-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1616719966-10221-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 312b6b42-d9ef-4ad1-39c5-08d8f07731f5
x-ms-traffictypediagnostic: DB9PR04MB8345:
x-microsoft-antispam-prvs: <DB9PR04MB83455409D69BCC29E0FFFEF2FC619@DB9PR04MB8345.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: QdArqTX93P6KJg+G9EwMdrXMPU3s1s4Aj/BDXnNSJGruJqw58HydCrJJYO3ePzF0BOIbRF7Wy0LWGbEcQ5xAFTYBW0Xk8TGMR0p7gxBUOyg0itGCXljy8bLieNJLavRavvbYQ9oID/iQY5w4kKhVmOZVXLycxg2jIdyXgqfG6c8Gi2Vr+E94OsSv5CzlT9s7pLyarZGCLSUWTOYUW7PxfupCMVxBvR5U4bDSrXlGYZOhZvLIxzi6XFHKai57keNpLZX8MRoncU3pFrgMMv7WlkGAUOIRSKqDOS6306exkbwEIPqC0Bmq3QGRRabQ3kbtynHgXYBoXxgezzHVffHkHmb4OcHrL4r5bnwRVUc4IClJD8yYqX7dO4QU6TZ24aQqKrWQNVxirgHDnWcH5eHA+q/zrrsJmVU40wsISdrSNTI8jkZt0Tw6qc6PCxWbzjzmaqMn+gcCz6y9JNL+UZTltfFmnSOGu22lec7T93VbjpegnhTu0qGespr44vjLmRzN200dbvMYu3IJluFF8rEoPL+ENQS7U+Bkosj1h/WhJl3GtEda58HdpwODgSGUq3UqAsn9tCYwM/utNGC0CHGmwJUYHCn5oS8omAkcafIjHDS4hdJtob7exkNzOgkIE6l1o05rmIvwIxbDKACD2vAmLw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(346002)(136003)(396003)(366004)(39860400002)(86362001)(316002)(6506007)(5660300002)(36756003)(4744005)(8676002)(71200400001)(2906002)(6512007)(186003)(38100700001)(8936002)(478600001)(26005)(91956017)(64756008)(66446008)(76116006)(66476007)(4326008)(110136005)(6486002)(66556008)(2616005)(66946007)(44832011);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?xQcbMgE47OwTjhwqrYYbG1wE0OdywFeFEkry0qB19G00QyM9RpgOf7zOz?=
	=?iso-8859-15?Q?l1j9FpQj1Cpr04pD3Ust8ehPXbckq5EdV7K6RzGcNxpSW4VFMif0xFfv5?=
	=?iso-8859-15?Q?nmjKRhhy1QHj99xdmRdBD7E6rNYMNJe7B5DBGNoPmVqJiJRnbhn6a+BXv?=
	=?iso-8859-15?Q?FYMLZHYdA3NZXUw6OwHqY58bEaeOg7qeciUSRNBb7Zvv/y1SemjeirVKp?=
	=?iso-8859-15?Q?lDgUsB8AGVXFWoVM273mCKVP/kdWDzhhrRm2FgsEcn+uXXW4834AmrIoi?=
	=?iso-8859-15?Q?6LlsHDwxuzJhDC3CGlJhdecbexAVR0+YRuRwz5L2HzQRcZ5fDyUCFfgdB?=
	=?iso-8859-15?Q?vN//zazz2Ohgao1WCBFp+B6LDKB+53AYRT68GN5qSxYZdv/FiO/IsfEak?=
	=?iso-8859-15?Q?RQ1gr/Avm77q/gblG6VtfHagb3RXFnMsOpLpT1Ixp0SHhnkxN8KBhqy9T?=
	=?iso-8859-15?Q?0PHNpfWXG80eodecX8pyArSjgM/yRI1X24UkULPxXPeV7Sms8PKePU9fs?=
	=?iso-8859-15?Q?BksFWblL4Hdxk4lCuRuP5XgQUQ/krk+Y3HXuFvjS47tGs3qG47tnyhG4/?=
	=?iso-8859-15?Q?/ViRjwx/jDa54Rm6miyIUrNZVyU0yV2Wgx/z2gKQ366qwG8glek3xuG/z?=
	=?iso-8859-15?Q?9eKS8YwNz4y3SnPHL7j1ruJxjZbHXSbZ3NqTg7Bm28gvQNvFNwAVk3149?=
	=?iso-8859-15?Q?h1CMTV2PcY94eOmgncVjzuwCTCUII0agD9LJCo7CpH0BotGMb7JvPxIiV?=
	=?iso-8859-15?Q?RXMs2CRdoCQVjtgP01hUf1wOeprs0PAfiJtqm33TjUeDO6uYZhy0kjh7y?=
	=?iso-8859-15?Q?Vj/8PZt6+mR9eJBXBMr9y/01sTEBHWZtwphCFJ8rn8rtVYXqp+4xLVP1t?=
	=?iso-8859-15?Q?JfqUeqQD/NKFSToCM7GpXZ+20g5jTh2NUrr8g/n5PinlTMV45mGjdsRrw?=
	=?iso-8859-15?Q?BMs0+RMtJ6izzKZps6a93l7norWNSHPFvnkhDsR1DXelXAOEwba0/kwJq?=
	=?iso-8859-15?Q?kYTNdPS5y6pS2/cdc2xLS+u2h03mo69lfxNFP1m1no5B3qk8mKM1SwdxI?=
	=?iso-8859-15?Q?5sYdPUpAbSOBb/oD4uH5NPqH1uQXXNgmseXc3G1PlOkanSlj04C9ToV/n?=
	=?iso-8859-15?Q?tNEXZpK6nqdjhPLhvPdidb6gzdXt287yX6TWmgD2xqDoz/DWY1mUgyBXO?=
	=?iso-8859-15?Q?f0U7BCwB8CewpMx/u5ZDutlsQkJ1IBzj5+7tPcbrJc47ypoemTWKicXOM?=
	=?iso-8859-15?Q?/2X6x6lTCZtzGxUIiGxek47nO/NaUC5Di0Jzm6AtgaoTuAYOkOYFyDNa8?=
	=?iso-8859-15?Q?dLqC4kRk28jAdmckJDAPXo0uTHDX8GTVwUnxTOcm5F4aIe1NZa0rhiLXy?=
	=?iso-8859-15?Q?n7RxEQKRS5XhX0R1TT4JPpu0eCBTNzbRE?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312b6b42-d9ef-4ad1-39c5-08d8f07731f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 16:50:00.1685 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MOucbTs0jZATTP8RM9PjFHsqXeNO7Wjv2gb9yYEXuxJJFuatIN4faCNGsuGodWmvsAa8hvgrNBDMKctoPFjYvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8345
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12QGo8B4004141
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/4] libmultipath: avoid infinite loop with
 bad vpd page 83 identifier
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F7399637672D9C408E6F06F4777D2188@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-25 at 19:52 -0500, Benjamin Marzinski wrote:
> If a device with a scsi name identifier has an unknown prefix,
> parse_vpd_pg83() needs to advance to the next identifier, instead of
> simply trying the same one again in an infinite loop.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Ouch.
Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

