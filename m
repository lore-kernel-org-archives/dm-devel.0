Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36AE2C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 19:59:23 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-js53yd5xMnG9AVJjTdWO3Q-1; Thu, 10 Feb 2022 14:59:18 -0500
X-MC-Unique: js53yd5xMnG9AVJjTdWO3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0B908519E1;
	Thu, 10 Feb 2022 19:59:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DF606107E;
	Thu, 10 Feb 2022 19:59:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0EB3C1809CB8;
	Thu, 10 Feb 2022 19:59:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AJsUio002327 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 14:54:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8590A492D4F; Thu, 10 Feb 2022 19:54:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 809DA492D47
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 19:54:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6658C85A5A8
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 19:54:30 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-149-vquj7lNJMNiJ-n_Ak9kkqg-1; Thu, 10 Feb 2022 14:54:28 -0500
X-MC-Unique: vquj7lNJMNiJ-n_Ak9kkqg-1
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur01lp2056.outbound.protection.outlook.com [104.47.0.56]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-23-LoEwCnPGNte15Tbj-WGLLg-1; Thu, 10 Feb 2022 20:54:26 +0100
X-MC-Unique: LoEwCnPGNte15Tbj-WGLLg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AS8PR04MB7655.eurprd04.prod.outlook.com (2603:10a6:20b:292::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19;
	Thu, 10 Feb 2022 19:54:25 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Thu, 10 Feb 2022 19:54:24 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "maier@linux.ibm.com"
	<maier@linux.ibm.com>
Thread-Topic: [PATCH 2/2] libmultipath: add %L path wildcard for 64-bit hex LUN
Thread-Index: AQHYHe3iS3oLHzFNUkOQ1m/L5JsNM6yNH/OAgAAUMgA=
Date: Thu, 10 Feb 2022 19:54:24 +0000
Message-ID: <99e3cb401b56ee9afbf0949fa3f10eac818b48be.camel@suse.com>
References: <20220209194713.56556-1-maier@linux.ibm.com>
	<20220209194713.56556-3-maier@linux.ibm.com>
	<20220210184207.GF24684@octiron.msp.redhat.com>
In-Reply-To: <20220210184207.GF24684@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62a5ce44-0752-4e35-2264-08d9eccf2394
x-ms-traffictypediagnostic: AS8PR04MB7655:EE_
x-microsoft-antispam-prvs: <AS8PR04MB76555DFFA9D5F3962BC2D5FCFC2F9@AS8PR04MB7655.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:800
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SW5mggMSx5BogusVCM+whCC7c+1MDpAlsOfcVhsSNX0OWPzRLuEJx9bYNla+lHVcNL4uDMlo5KrewI5sQ8GDu7N/UdQkYfONBGyMhyQXbPaEVYy2M4WvnhtfBO65COyKG5KOdLwD3i/qLnvIqZb/FZnFGDpLs1ayAmHqTzfMlpC9GujLgxUnfWMTC7vPhGvniLz7beBbxrzN/rgcYqXgvQ6HpHEk56MbprPQpmZOe6JPeml+1j0RbS2knSy6T7JrtohNxoshlUOqbeiDk2H+eoTOAyWKFZZtDYnE0QgZ9Zv+zTksFaZ9wsnspNE+MXuGcYw3OkuW9ZgI6bfF73AVQ/ie7OnS1ZfFpeyQDwQw/DZTc9jxN1QZDKuuanUnz5kF+lg635vu7VxNFZwxKsjD1ZtTZuayVqH1xNOp3xiTvh4e1bEnCgeOaeeE6CFZ5W6jNywBKVoukWMWQBGJxQtT0aecYaHxOrkO8Q8ftNO7m6wDcHgZnmza8NBQt8qcNDhuYIjBhLHvqDm7+kOPIlqmEMcYhqclV9oiJkD2pI+8vQvCNtVPmqPi8ah2EJge5hnGzi5sSeUPw9qugiy6Lnx4OhijgbN1s/8Ez0yrVBf5DgYlOeIf/hrWj0zMk5ghZ0l+nN2tlBQuIQ0jrxlEEE+q/V1pUgqOH9uZSlP6sKcFLN9XeEZRTpJOlq15bNQkkdkFGYv+k/Z7VlvxHrjXMGKj4A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(66446008)(8676002)(66476007)(38070700005)(5660300002)(4326008)(66556008)(508600001)(86362001)(91956017)(66946007)(76116006)(44832011)(6506007)(110136005)(6486002)(64756008)(26005)(38100700002)(2616005)(316002)(8936002)(36756003)(54906003)(6512007)(2906002)(186003)(122000001)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?ZHnsrD49W2HX9pP9QUtLrOW5I2qGXPVE35X6ggRnMwhZv3ogqOMsdCu7U?=
	=?iso-8859-15?Q?PXN/mKaGHzEPHMSM96I1ZmYXdcRFqQhZn5OlM7AY8qcxv5Mb0lVe8d4zs?=
	=?iso-8859-15?Q?RZvTt7t+ps4qGRGtEOHF5bAQHU/QeAQeleDz6UgOENyEtY2Jgrj5zA7pd?=
	=?iso-8859-15?Q?eeHCFRwcaBYxlOZ1bfgRz0jq6dLmbwE/38yWVvQa1V9uVPr6mkRDwAmPS?=
	=?iso-8859-15?Q?/3TwlI89/Iwv1kEU+nL2LBolaHWKgn38MW4rkp0ykuLE5kgreyOe+mVln?=
	=?iso-8859-15?Q?5Rn4ZFsEptTCXIL2ietdAaFlULZHVzD4fT98P6nwP2e16Tapj3y792+we?=
	=?iso-8859-15?Q?JAMguomnvZGXAsJSeNzob4LQwfeWf0si3BkMeAUwet0TqpCka35J//Vkx?=
	=?iso-8859-15?Q?pSMROJZGHK0SNj4/e9fRGWZ4DEKEnJCywDakv3Lsl33WKEYpcIHNpSZ0U?=
	=?iso-8859-15?Q?di8yUQaVgycHnEBslTVmil0inuKku9pFG3BnD42AHZ6drUeuhWsKKVoZH?=
	=?iso-8859-15?Q?TpqhADxTKetqimnrxwF1MxlX9XbAa1eH4prac2dE09haTfUiWglOMxwB5?=
	=?iso-8859-15?Q?0/nykG3z3wh1jPLWc01tS/hmEbdZxVKpL1Y4rAkZtdybvr3S9yzMl9T30?=
	=?iso-8859-15?Q?zQpo8KmvDdyXqe+GZ/NuAzCxi7uk+NjVLRzmXK+cNa+ls4qvYEPANFtLt?=
	=?iso-8859-15?Q?6prvDaNtuT4jiWwJyC6Ht4WChtfJyasPjKXmRrBy1JvdVYDdaF+T7oK6z?=
	=?iso-8859-15?Q?Lv0L8t74xhVNz+4Aaindw1L7oe6jQ0knVZ8M6IBk9eeJ4h6kBxzdYBY9B?=
	=?iso-8859-15?Q?A06hkQadJJmY75SXQaMkqeCrZCJvpgGMqZSqMv5/jQPZqXaJMalsS9swr?=
	=?iso-8859-15?Q?T2zlHabdLdPvRWQv02K6wUKb3ZiVgIuullpvh2AU7Jg4BhdPInN9+4wqH?=
	=?iso-8859-15?Q?bRaxoGlsOMfT6NTWkVVBV8ppFFfHUmQGtrhIP8Xcv5vDt5AUdgCFULMNx?=
	=?iso-8859-15?Q?iogj3gnZdUps/TDPxxvtgIpt4f22ZlUktMS9vk3C4IGXKhbf0lJxPykBq?=
	=?iso-8859-15?Q?1vWvDmrLjVk4x+JJw4a0yXLaxWBeaZcRoFOtcCXj5JBYfxqwfzCO2lBiv?=
	=?iso-8859-15?Q?GOAOgvI91OfYTMDOOBt56+Hym5aj944vodu0nQ/u32ms0qkOR5D8j4F0r?=
	=?iso-8859-15?Q?vVFEIfiYjHmQpdh9qHZwCnAP1YDE+Zhf983SghNLAFhXe2aj/lITKnILR?=
	=?iso-8859-15?Q?P2LdcEpwhoSGY37NSfdyq56oV/MQCibiNGbLQu1vKI5PDFq3jq58zeIjg?=
	=?iso-8859-15?Q?MaMywuEu6u9hgkNNUUJJbh/Q6ln0/6A6QBm6zI6vUWmCtF9Fv9x78shuc?=
	=?iso-8859-15?Q?2M/w2ody/bHz8jXtQTvRZCUpVQRgmWeTE1UGMjoxm9WkteaBfJxoa+W1q?=
	=?iso-8859-15?Q?33PDEXUuAmcH+H++hL2hsWvbsfzUWGFD6XM2tG4vR2gPXNQqtauM1vTfJ?=
	=?iso-8859-15?Q?M2etP3H5GqcwuusWHLOEKcgb3Z1F7jc7GZWGZUnMqXgB2lSi0VKmdhaza?=
	=?iso-8859-15?Q?9D8SDVpxoSUloWRIVqmVqAUC35vSciG2oUqae1NlFhNJJxncwwzUnmgNK?=
	=?iso-8859-15?Q?4XASd5nTbXewMlaOK5W8cPA2IESed7+WQFxTPg6IqC+3inJbED41kSZYK?=
	=?iso-8859-15?Q?Z/l9ZodiGO0FJr1eCExbN0oP8XVHqU2dhoom17vTf7QMrh0=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a5ce44-0752-4e35-2264-08d9eccf2394
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 19:54:24.7838 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 23b3EpB6oDmYSxDlS7axbc/Li9x0tPKpUlZglIjZKWvlFykdVVjGtgJVSxjxibONFzMIdP/xUOrmq2rHwgLrOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7655
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21AJsUio002327
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"shivakrishna.merla@netapp.com" <shivakrishna.merla@netapp.com>
Subject: Re: [dm-devel] [PATCH 2/2] libmultipath: add %L path wildcard for
	64-bit hex LUN
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2BDB4061BB51EA4A900C8C9E915324BD@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-02-10 at 12:42 -0600, Benjamin Marzinski wrote:
> On Wed, Feb 09, 2022 at 08:47:13PM +0100, Steffen Maier wrote:
> > Complements v0.6.0 commit
> > 01ab2a468ea2 ("libmultipath: Add additional path wildcards") as
> > well as
> > ("libmultipath: support host adapter name lookup for s390x ccw
> > bus").
> >=20
> > With that we can easily get the full FCP addressing triplet
> > (HBA, WWPN, FCPLUN) from multipath tools without additional tools
> > and correlation:
> >=20
> > $ multipathd -k'show paths format "%w|%a|%r|%L"'
> > uuid=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |host adapter|target WWPN=A0=A0=A0=A0=A0=A0
> > |LUN hex
> > 36005076400820293e8000000000000a0|0.0.5080=A0=A0=A0
> > |0x500507680b25c449|0x00a0000000000000
> > 36005076400820293e8000000000000a0|0.0.5080=A0=A0=A0
> > |0x500507680b25c448|0x00a0000000000000
> > 36005076400820293e8000000000000a0|0.0.50c0=A0=A0=A0
> > |0x500507680b26c449|0x00a0000000000000
> > 36005076400820293e8000000000000a0|0.0.50c0=A0=A0=A0
> > |0x500507680b26c448|0x00a0000000000000
> >=20
> > Likewise, add a field lun_hex for JSON path output.
> >=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

