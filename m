Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37702C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 13:18:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-gjPP8QGjNmuHu1_z6e_IHA-1; Tue, 12 Apr 2022 09:18:52 -0400
X-MC-Unique: gjPP8QGjNmuHu1_z6e_IHA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F23E86B8A4;
	Tue, 12 Apr 2022 13:18:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 819F2401E97;
	Tue, 12 Apr 2022 13:18:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4BEA2194036A;
	Tue, 12 Apr 2022 13:18:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 81BAD1940365
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 13:18:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 71C7A40EC00C; Tue, 12 Apr 2022 13:18:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B78840EC000
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 13:18:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5281A811E78
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 13:18:41 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-k23MByGcMaWRjYBjVmumFw-1; Tue, 12 Apr 2022 09:18:39 -0400
X-MC-Unique: k23MByGcMaWRjYBjVmumFw-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2112.outbound.protection.outlook.com [104.47.17.112]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-25-N3Fte5niOtOYEOBzTkxWtQ-1; Tue, 12 Apr 2022 15:18:37 +0200
X-MC-Unique: N3Fte5niOtOYEOBzTkxWtQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AS8PR04MB7830.eurprd04.prod.outlook.com (2603:10a6:20b:2ac::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Tue, 12 Apr
 2022 13:18:36 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 13:18:36 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/9] Add protocol specific config subsection
Thread-Index: AQHYThEKdbrAhr5xHE2kaVKyN3MnNw==
Date: Tue, 12 Apr 2022 13:18:36 +0000
Message-ID: <887ad074ae20bb1861c420c254d851d33cb18e57.camel@suse.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
 <95a66d760a1ad8ac943de611ebb3e61d5a41afdb.camel@suse.com>
In-Reply-To: <95a66d760a1ad8ac943de611ebb3e61d5a41afdb.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1666db5-4b55-45c7-384d-08da1c86f39f
x-ms-traffictypediagnostic: AS8PR04MB7830:EE_
x-microsoft-antispam-prvs: <AS8PR04MB78302C0947F9C4306D92C3E0FCED9@AS8PR04MB7830.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: iNAsqBbzsttjzQUyc4JiyWWStTkGA2bwQWU8QoJzRUxrI2UFfcq9VryLAfsyQrwcxwSWDnwpVvzRj0uNnWcvYHr6VI/7mcqmWu0kA8XAbZzjk3wtFjZyu0J+uiY3pCwzihJRbLGmQyDoiZR1GqleTWtExwPgQ5V1YjjxTmP1+gYHe4WbXQz9d58iMbWDEtvr6DHdTw9uDJF7EFIYkut2MPGAvNUAiAk2B6I2UvtYxyEvgnhTNQ1shS8AWcXDGA5HtDKyf4rLwyBoOnABmFL9l/uttzgBlL7638NxQE3kYFzEtaIsSl4t4QraSmp1+PRekbPYZLh43FJP+02C27m9dv4Jy8lI64VRSsJDEsmFa4TvZDvc4KUQSB+okiM12e3MkpLb8zrrEgNFYtJ7wNWVzl8a1yZR/6DYqaKasSVa648fG45cIxm6ll0EW5x9fBKxlzZGzJ2GY2EMb5U0OYEX9Oup5PhzBq5fEao1KUHV05ReQUambcIjimD/4LFzHY9UKpuKa41LOkU08X8ss4PNC7s9LYPnmRnBxFUXY7bUkd/mvkH5WNnjH/gxiXr6Fv7IgTO241t6Us0jOwa4sbMNCpLk9+ZRDXCdYk/FxPpgEoaRqc0oi7M1qZxn8aNHBAz9rmbyGvnAT/OuQ6YAhP5k7oBMY8m3iOoZFYMkUadG1RXQITYaDkSp6ixfSJlX0Mpy4HpZd3ljdzDFF1lA1LieyQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(2906002)(26005)(186003)(86362001)(38070700005)(44832011)(5660300002)(6512007)(316002)(71200400001)(4744005)(2616005)(66476007)(66946007)(76116006)(6506007)(8676002)(6486002)(8936002)(91956017)(66446008)(66556008)(38100700002)(4326008)(110136005)(36756003)(83380400001)(122000001)(508600001)(64756008);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?fjSYwo+z12riBokhno0HFcSOUvor0ax3LA+YG5ccn3aCi4mYQUcMsdl82?=
 =?iso-8859-15?Q?f0Ssc7zw9wK/QFKrZvllydV1/uBdA8e/V361x9bXv2reiXvaOQVSaArLB?=
 =?iso-8859-15?Q?wggII99cJPfhpojdSS0DFV02RNU1aBJfwr3nG5lKiN6Snijnn+iwV3J/F?=
 =?iso-8859-15?Q?gNmViM3rodHIuHCRM57luZTtaFY2CYhCSbuzUMSWJnjqwwJtjIw0+RJDJ?=
 =?iso-8859-15?Q?/p13SOBsccKE33NTZxSWSRimeE2lrdvo7IqiXCmU5b1JtWi1S4qfEWRPM?=
 =?iso-8859-15?Q?yG38ixDZXtPRlydDWcAq8axxZF6zlg+Vr17XwMkNO9vusqhy1v3RzWPS7?=
 =?iso-8859-15?Q?nshDb+oQ38fwveoFuw6Hdwn1Rdqqff3PSZnbufTz0MFHIAv6QR4jfttB+?=
 =?iso-8859-15?Q?k2fRKzEG7ExM30b4Anr8tUvYAdm42NOLj95hI6e3wpWvIhDAWtJ3eJ1U4?=
 =?iso-8859-15?Q?nQ2WSxRzC3NVzOl37Urgw5oPAGpi5lt3M0kQq9Sq7XbTwKuazKnp8xVYK?=
 =?iso-8859-15?Q?6VTOnj7CYb4j+aUgdeQgEymqRZNEe5pvvhJYTmoHiYI2WhxBIclgiVRtH?=
 =?iso-8859-15?Q?jdyuymR4eNCKlMNkbhdWliD3VcS9b5NPA6ml/oKIOnOb+ddTF3QcS1Y2B?=
 =?iso-8859-15?Q?JTOqeo0kMJSM+R/QVf95bLDNWbnayr+DrD/uoh4/oLSXVNbpQr7vROcNn?=
 =?iso-8859-15?Q?zZ1j9iO/6M3K067lOkkqy+8SSBqJQQch6TlsUr1GST5/SheFZcWHCliCp?=
 =?iso-8859-15?Q?jmB2jCVosAJHbZpS32pQroAppkwFOiy3dtPpPHhObryK3qdtLPitMaaa3?=
 =?iso-8859-15?Q?XmXaW8w0ExrOVLyXvSlIL8KdyrmwUnd7b7jQPTPmICbiu+0+KRoKdHZKA?=
 =?iso-8859-15?Q?XPT8drnuXqyBQmxrUdEpTqP3Suh3r/rYdsb+i7LvjDmSyK5NqicnxhCW7?=
 =?iso-8859-15?Q?G7dZBNec6XMtSSi50EFNHrBDZs+/v2iQtoCwCGkr1brNrUDEQQqSZL8Zx?=
 =?iso-8859-15?Q?Ek17txFq+nVO82QkvuWDULJEIhK2lpaL/E3x9DuMGwvMQ0dde4adw8SCg?=
 =?iso-8859-15?Q?HpBOCk9GzhdUKq6gRQiuhLTI2OM/JNvB866meas/5iozO10hB3nDrjoqF?=
 =?iso-8859-15?Q?+GTXFKFETDVrpgwPODD3V/dK4wpYXWQzEG0YXcSywRvmpZaPGoIcK0tR2?=
 =?iso-8859-15?Q?oVQfGeP55HXuMY5v32ZVSLbYBSLu6X8aV+8G4RmMty2AT1lmEeuwwxePp?=
 =?iso-8859-15?Q?xWv8Qw4lqUc19eHC35D1RRg4cyW7PzFOFvZU8TpBMzvaqOG7gdDXbU4E7?=
 =?iso-8859-15?Q?XZ0ugVVcG4o7EKqQMkSOkd9sOzjpmSp+czWj46taHT0yTpWpMlkx/S+um?=
 =?iso-8859-15?Q?/SgkcsZl+BFUGwlkrspG7yHfoeQjXhtsQL1Lb/d1SSM/6Lv09rrqwd9Rx?=
 =?iso-8859-15?Q?Iha/g4wI8wHNYe/WJDUyatvCXGNwatV4Gs6R1vYxsnEarVpL5YqhAgTNv?=
 =?iso-8859-15?Q?qb3rhM0SU4QfWMgJyQ1GsAQTzgBW0bVZ4PoXBbxrRUOWybSrwmBWvGMRE?=
 =?iso-8859-15?Q?DgOEZQR5OP9KsmPFzBh/FxscMqg3LqABERtz3j6UNZH8cUwBlINE7y1fQ?=
 =?iso-8859-15?Q?VnwLg/HKnLD2xZPPAPoXshdp/am9BncVnQolnqmKCMaZ2ikodGx6Ucesb?=
 =?iso-8859-15?Q?7uux6ibyFIiYbWDc5qBjqv9xgHDeEtSWgvLaeN4FLTdKfZfdG1WnigEkx?=
 =?iso-8859-15?Q?B2wYProrEOk6R1B9plp21oQ1e8f733d8X9Dbp/oBVE32B8/YQGj6cg7fi?=
 =?iso-8859-15?Q?kTZJ1J4TWztDXI+AkSs1HbHyE03CrKrNLWhtDBy1s3L903TQjFQgXiVcn?=
 =?iso-8859-15?Q?ktYo=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1666db5-4b55-45c7-384d-08da1c86f39f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 13:18:36.3433 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DdIiUPInw6m4ZGdngXX2HUCDpFREDj+wVAWTUp2P77NRiczyig1h1TiG9Yy4V6vZaMFQlTpH+I0OrCh+gUabrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7830
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 0/9] Add protocol specific config subsection
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <E5988E263D3F8B4088B1C1552FF05C3A@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-04-12 at 12:31 +0200, Martin Wilck wrote:
> On Mon, 2022-04-11 at 20:59 -0500, Benjamin Marzinski wrote:
> > Some storage arrays can be accessed using multiple protocols at the
> > same
> > time.=A0 I've have customers request the ability to set different
> > values
> > for the path specific timeouts, like fast_io_fail_tmo, based on the
> > protocol used to access the path. In order to make this possible,
> > this
> > patchset adds a new protocol subsection to the device subsection
> > and
> > the
> > overrides section. This allows users to set a device config's path
> > specific timeouts, such as dev_loss_tmo, fast_io_fail_tmo, and
> > eh_deadline on a per-protocol basis.
>=20
> Sigh... I am not happy about this amount of additional complexity in
> the multipath configuration.

I'll postpone a detailed review of patch 03 ff. of this series until
we agree how the user-facing side should look like.=20

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

