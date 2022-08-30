Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68B0DECAAA1
	for <dm-devel@archiver.kernel.org>; Tue, 30 Aug 2022 19:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661887870;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YXAagYH+wEMlyk4RH9ER3U9KDBF5ikllUR9kp3ycDE4=;
	b=ajMDt26qOejLUuVuEkw51XynJvDcCRw2OhCwOs4iBY+/9tMtRlZfh9cxpGcyKPULpLZ+61
	x/lzmjF6Get4uamAYA8SqJXLkbyt0fNwf4bKOkoEg0pboDm2tdi9pq99g4KSgPpdbtRqH3
	nTpvwJaPoGiHnecv3tMVChIXl/9ymxA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-ORrkNjRDMs23lrzLnTEjkA-1; Tue, 30 Aug 2022 15:31:08 -0400
X-MC-Unique: ORrkNjRDMs23lrzLnTEjkA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F179A294EDC2;
	Tue, 30 Aug 2022 19:31:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DFE642026D4C;
	Tue, 30 Aug 2022 19:31:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB2901946A42;
	Tue, 30 Aug 2022 19:31:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9F4771946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 Aug 2022 19:31:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 81E14C15BBA; Tue, 30 Aug 2022 19:31:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D142C15BB3
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 19:31:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 605241020BDA
 for <dm-devel@redhat.com>; Tue, 30 Aug 2022 19:31:05 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130083.outbound.protection.outlook.com [40.107.13.83]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-Bhh1r1ZUPJOxTHQoY3Le0g-1; Tue, 30 Aug 2022 15:31:03 -0400
X-MC-Unique: Bhh1r1ZUPJOxTHQoY3Le0g-1
Received: from PA4PR04MB8047.eurprd04.prod.outlook.com (2603:10a6:102:cf::21)
 by HE1PR04MB3291.eurprd04.prod.outlook.com (2603:10a6:7:18::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 19:30:57 +0000
Received: from PA4PR04MB8047.eurprd04.prod.outlook.com
 ([fe80::d114:d68f:301:95b0]) by PA4PR04MB8047.eurprd04.prod.outlook.com
 ([fe80::d114:d68f:301:95b0%9]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 19:30:57 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] multipathd: check for command overflow
Thread-Index: AQHYvKcGs7cOVdnajEu7DM3IdXe8tA==
Date: Tue, 30 Aug 2022 19:30:56 +0000
Message-ID: <3ec672dc6708e083c65bf0f373f6cc3cd4f785f5.camel@suse.com>
References: <1661793425-25103-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1661793425-25103-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11bda201-a88a-4c87-2327-08da8abe296b
x-ms-traffictypediagnostic: HE1PR04MB3291:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 8ia/9EE8VyJyNvshVWpO5CJgYZN+GqFUMVBy2lBfbCkZnhYyfAcXBhl+5XbVDlSEn4wV9gO0El+1GJOlLSchhbsSkLgkqQWyYw2XxC0i6XtqH0/OvGdIkHfQyHfm9SllAisx7XKN0oms50Idz3uiV9JMFcrFru0eDCrg5TtYmYdJLdFxwloPIUt0+cqglzG7FziCGwQ9jJwu/lt5kGzzBJnidz5JcCqNmUJj6inAlcxOh+1rFqFPpfjop14cR4MnXERXIoCic3nUDyLW8a3vZxcOmIl3dq3fEdMi319HLtHejKXPc+MxdQ93AegZxE5wmIgWoPe+vVOGpMMOjxP1sBNQmsZ4/9i+lrkH6TkU2hG15QeLQfiv01YpEf84Im9aYqfeBA2TV+XaGrJj4Ajo2rZxTl5LFqpCb7icJ8Esx8DeRMr6xU+DlB+X5fZK1Z/pmw7lTeMbnhs1djHnu2RpIk+waC1VTcwewIB9Ku+TR0w8S47FtmoTn3vGB4HSirV4ujjItOu3ILdtX9r1nc/AJWA5MPzrXYEYbOCz2ao6HiF6TxdVz66cNC8LFnEi7b9xYz2Yu5fT9f7c77YF4iC29w/HD5ie8/Mdkpw7lVxtVOQVG+vuAbXHRIQuEnF7y2y8szF8uMf2AwzLZHVUDgSuKIqpRxnVwHS2oQeqleFTY0R/lG+oClbIYQCmDwqnIU27Lhc8nlgp/L84QT0dGXYLAlQRXTClEOxudaa7pd3FVh9OOzd2N8UBdk1rt4B3LpuCs8kjtMMPEVpcMq5UpIVMmQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PA4PR04MB8047.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(39860400002)(396003)(136003)(376002)(366004)(346002)(186003)(2616005)(71200400001)(316002)(36756003)(2906002)(6512007)(6506007)(4744005)(44832011)(26005)(66476007)(76116006)(38070700005)(86362001)(122000001)(38100700002)(8936002)(5660300002)(6486002)(41300700001)(91956017)(478600001)(110136005)(66556008)(66946007)(64756008)(8676002)(66446008)(4326008);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?3abYz0EApRqsHuzQl2y3U3945cvaWreMPj60iplJVCkkSZ+6AFDm4BPDF?=
 =?iso-8859-15?Q?PPcPt8JaYj6RyShpRtEJ6vzaoFvwOACbellzkoJNemVlfO+AQC5vZXfUM?=
 =?iso-8859-15?Q?2/eFBKXJ+oBR7vMvVkJQk9CqxqXBL9u3A4HOQy7TXXLNdutKxkggP7nrv?=
 =?iso-8859-15?Q?n6UoD8T2c37x5MbRRfOY9r2Zafmry6ISQkXQuhtVeklFZpioo+3zMj/ss?=
 =?iso-8859-15?Q?55BUR8mlM7NSHbQIaiqbGEPNXCOsyC2coxvIHrG2XSrhSsEcsDhdmeRaZ?=
 =?iso-8859-15?Q?16HcMmD7lRTT3eFEL8dJTYD8pM6J89c8fPirQyghyxpPSonVaM2GpRP8c?=
 =?iso-8859-15?Q?djgzXBLxAqA6aNHjLCDI+ebEpSi+rE/r9fIa8E3ZPWnKZFgs5m3yj8MZk?=
 =?iso-8859-15?Q?mlm2YFvNQaCOoxU+l/w8kAp4didm0xS9Fu8PElBMBtMw4zmczQbTjzABg?=
 =?iso-8859-15?Q?yZBXlavuoalovB282PmNE9zt16idY/jIUKYkDYh8Mt6s6y+dx3d6d2mFG?=
 =?iso-8859-15?Q?0tAFiaWgcokL1+3u5wfZeKtV5DgnmLdf5LQ4uKYM8rb3kZrTK7n2dfIYp?=
 =?iso-8859-15?Q?7xzR9DbktS/t2WFCGgcKrWFJUxHFREVZPuG8g3Fhvx7YELmx8ox4nu307?=
 =?iso-8859-15?Q?IthAGN3f8vn3yDBO5lukmx9gZpiYyc10jJyh3jvwUg9Z8pinLwANAnkSp?=
 =?iso-8859-15?Q?1IYVMP8FmYw65HRkg3CC1MhirH/tNIJB7TnHgLiqTuqQuHpqDWhlflVzG?=
 =?iso-8859-15?Q?A3/ES89NzEdRO06BFuZYkJ6/kSKmJC08zAN8pGQNhSTT/tor+7O9rTcoo?=
 =?iso-8859-15?Q?ZIM89JbK28oenONvGra4WgKxOvUZdGGaySgC7hzghpMONGwWD8Fa/8DJk?=
 =?iso-8859-15?Q?zOPATlgAYtvk4MAcUnQv5QMm8iOoow2n0VLzK1iYTdlm+QoB+uNEhZjAu?=
 =?iso-8859-15?Q?6G3Ww6Fr82EzY/DC4Ti2IKh6Gibu/qFkpXEZwQiGRBHF17YaW3h54kd2N?=
 =?iso-8859-15?Q?tRIpYRQhHp7+I55DGyyD/kJUfgl2Mk/exp0MwpHmXV/upHqrXJOuZXKAT?=
 =?iso-8859-15?Q?lQFh1RpvPqOcxUWw561h3xfdmCQZBDt+AYgLFzjlaZpf/jQJXK8w5SOb6?=
 =?iso-8859-15?Q?jQTrvY8qVpM1WTE3pr8Qq30R8RTFh0mFZE8PK2rzE7AFsD/KEdB9De4dx?=
 =?iso-8859-15?Q?HWnad3dYUNVxoKMricuuiEm7vNXknSRPYlNE+pBhsMZtonA9qgsDE56ma?=
 =?iso-8859-15?Q?gjh3sYHBF08Xs43rsGQNEY0loMWkTi2fOO2co6UFP1F1WeMnwnZ0lYv6H?=
 =?iso-8859-15?Q?4WNKFEaN03ZFK6sVZssCEvL/EICmYzONjIJsdU/EXQXAHCzk0BzVxgVx8?=
 =?iso-8859-15?Q?v6ZZrHnjKTDagzMGZn+STSZec1NzW77DKOvaBzaoS51ltV5CHTA9KyAwo?=
 =?iso-8859-15?Q?986kOxpYMY96uk6OEI0rO/RC1nkdbltJxXc1CYIn7C64BdJSDK04DVhng?=
 =?iso-8859-15?Q?XPtNB5vfBdDsN6eT/UVG00G7snXH+fheMTZDYrPcuq0C1H2rlziqE8wzr?=
 =?iso-8859-15?Q?4W53nAQD1Aemm4IKUNokVEpv5TwWKhaAXSPDwyzJ59JfRsMQrb7lYP3rr?=
 =?iso-8859-15?Q?AtwbS7cCOklJrdOn7sH1Zkvp9wAmjiyweEyy0KPtR7ATtpDJHDROUB+J6?=
 =?iso-8859-15?Q?oLQ7a8hSrA6cXsFEfAA9qAJwMg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB8047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11bda201-a88a-4c87-2327-08da8abe296b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 19:30:56.9496 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Lq7Rt4nTuB+bLxYMtIquKx3nU5G8TU3J7Oz6J4CMeZquD2fgcRUvNZzFB7o5gJ/FskhWWrXoB31Jz1sSDrxcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3291
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] multipathd: check for command overflow
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <050FBBC5746C934798199E80E9AF3BFD@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-08-29 at 12:17 -0500, Benjamin Marzinski wrote:
> The code to build the command string calls snprintf() in a loop,
> adding
> the return value to the start pointer, c. Since snprintf() can return
> more characters than it actually printed if it runs out of space, c
> can
> end up pointing past the end of the command string buffer on
> sebsequent
> loops.=A0 Since the size argument to snprintf() is unsigned, after an
> overflow it will be a huge number, instead of a negative one, meaning
> that it will continue printing past the end of the buffer. Check for
> overflow after each snprintf() to avoid this.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

