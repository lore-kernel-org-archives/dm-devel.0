Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D641C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 20:26:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-Y3GO9ix3OEK6ODv7MXWAxA-1; Thu, 10 Feb 2022 15:26:45 -0500
X-MC-Unique: Y3GO9ix3OEK6ODv7MXWAxA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A9481800D50;
	Thu, 10 Feb 2022 20:26:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2EA26AB90;
	Thu, 10 Feb 2022 20:26:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5BE551809CB9;
	Thu, 10 Feb 2022 20:26:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AKMncS005802 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 15:22:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EBA7D401E95; Thu, 10 Feb 2022 20:22:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6FD1401E9F
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 20:22:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC02285A5BC
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 20:22:48 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-554-F7FKPslmPTeUF7asBeqhbA-1; Thu, 10 Feb 2022 15:22:47 -0500
X-MC-Unique: F7FKPslmPTeUF7asBeqhbA-1
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur01lp2055.outbound.protection.outlook.com [104.47.0.55]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-2-Aq-0HglJMqOHM5OlUX5dhA-1; Thu, 10 Feb 2022 21:22:44 +0100
X-MC-Unique: Aq-0HglJMqOHM5OlUX5dhA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM6PR0402MB3431.eurprd04.prod.outlook.com (2603:10a6:209:e::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12;
	Thu, 10 Feb 2022 20:22:43 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Thu, 10 Feb 2022 20:22:43 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>
Thread-Topic: [PATCH v3] multipathd: handle fpin events
Thread-Index: AQHYHmebN4b6TWOhBUe6OTftFkCXxA==
Date: Thu, 10 Feb 2022 20:22:43 +0000
Message-ID: <3b4bbcded95dbd375821cbabff5dbb1f2247f0fe.camel@suse.com>
References: <20220210032810.714821-1-muneendra.kumar@broadcom.com>
	<bb2333d75ac49ee865a7c17c8a2c68a3421099f0.camel@suse.com>
In-Reply-To: <bb2333d75ac49ee865a7c17c8a2c68a3421099f0.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b973b0ff-0109-43c0-ebd6-08d9ecd31828
x-ms-traffictypediagnostic: AM6PR0402MB3431:EE_
x-microsoft-antispam-prvs: <AM6PR0402MB343126F01E3E5216A1C92EA8FC2F9@AM6PR0402MB3431.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: TTie3n87HqQxT/a2pEW77UlHR4b4pDD6z+hSZXV+yvgcdiRqn8EPZG4Fd3RsH06DPCHW7Q2yT1jFeCMfMTmLuheg++KuGjh+dYd5Cel5+pUfVPp2kZ2eAA6rLdkehUo4iQFPXejjK9YshLrRvPoeCDBahK5IL+eQGqjHMR4q9fZ6fpr+Hb7etCMjLGXE7KJisi86MQjzmlKPg/ukh3Mtws/Rj8bzw2MNEThos7xEoEG25s5qhd4EAzdbAcJXPPAafYtRAfuKoojyZJl2SX4fWiK9lsEFUVPEVNrjZLaTw2JseB8gR5hA/ys3DrAgiVnGPD0VKdNLSsvH8cMifwa+YmzWHfpHxHizxIBp8YJN8yH0Cotg3M4Qnm1Laf6qR2C6hERv0hJRYD0gmAWrSG9D70lgLaBmqkYU5TBoGoDQJj7KCM2GY1YbUuscPrc2UuJEBOtFunApCz/3bphUPiRGgq7rhYJ3/vSNlqBRX/Bf/sK0S0R9hP7ASK0jT1FpW4bqAUywPiKe49qCKdzIDzzC/78ddw1k57yaQedDzUwg6wuXbo/h3PuhcSFkuRPyq6wcUa4lAKxf/Zig1quMmZHgW1EOFhbrEApg9r2Nsf8zgiCQ1wL0pko7MyAmEAXncQB+VP0OjArn3cihz4Hu3YC4aJJ7auXryymwxbMTFjhcLLIAC95I0JFaFRQ377ohHVNxYNQGOo/ZVGcHPz0BJc062g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(8936002)(38070700005)(66946007)(6486002)(4326008)(5660300002)(8676002)(66446008)(64756008)(66556008)(66476007)(76116006)(36756003)(508600001)(83380400001)(6512007)(91956017)(2616005)(86362001)(71200400001)(2906002)(558084003)(44832011)(186003)(26005)(110136005)(122000001)(316002)(38100700002)(6506007)(54906003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?FbhrfwUDutv0wJ6YVEISamzq4iXLjpHFRiaHPS6lbNCJOAooawwCjG3QV?=
	=?iso-8859-15?Q?nO6elBXblOYg3H3pBlQP/z2kADk9nLCRyFiJGi8KxXzKs6rsJWbsP7iYP?=
	=?iso-8859-15?Q?p6V7b0AnHGa5OTlMATHH3wgGTVIsdzlTqfLyQnyF5MQ3g8VZEo6LmMioP?=
	=?iso-8859-15?Q?K3Y+TV8sl8b7LjtbbFSVS9lDptHGlOf81Fg/MJ6KWhUCsviIqs/yvLEH6?=
	=?iso-8859-15?Q?TdnpHWQFkxFWLBoSTEXGlDmyZNsJgwGFb4K1F8sw1/tgDzgUmtQtosWwD?=
	=?iso-8859-15?Q?RoztWjrj6h8o6f1rKRh/ea40A7QFYjDCht7XdkPpu79HmqD6xxG+47cPf?=
	=?iso-8859-15?Q?mxgdYLWGgRm5rOtQAHcc2gO4uj6CyraEsbV9eP7d8Qv0OGngaSafsBC5A?=
	=?iso-8859-15?Q?Ht+K0Af46ZlNye4kWAzCN9uwZX4TNWja0sONEikz8MzPsyNLUBKPcMOSH?=
	=?iso-8859-15?Q?3F+al+tEQNFm+REM3ul8C50A4tPLsdXnyl6nSXFu/bx9p8+YG1aMFUsmc?=
	=?iso-8859-15?Q?fXeDvzu4Wqz7xQ4lW6ummuGEYceomST5sSGWl5s/5Twdx3oB+oOleXcyC?=
	=?iso-8859-15?Q?ZIoc8VUbPvFxS+lnVuJdT3318sZrwmIdc2UE8S93xuI46bwf8ZlEakj5Y?=
	=?iso-8859-15?Q?Q9BuvdzosVunKtvnj9nbeANNCEz42z8Z9PDJ9hn3q4joxjzwzSelvqFSN?=
	=?iso-8859-15?Q?jZ+xUg5dvI6O/E0PMxaW/PgvEnVYvKjhycfGBVLMEGf+MBqYW3IxHHF/C?=
	=?iso-8859-15?Q?ZdyS0nLnqaj1mVRBbo3+I0LsbN2HBqzU1lf6g+fhlObQMHNylJhi2JeIZ?=
	=?iso-8859-15?Q?qfr1/14LuNhmMPrtQic2fILinvDoBn+nzCHXDJ9eA/+x8F7eWcnPbgUqM?=
	=?iso-8859-15?Q?qVb0iFy0FSZaA/oYZ+GvFRxBXxgLAlaQhu+xmzoEDMoQ0C2te7XeAVYjq?=
	=?iso-8859-15?Q?xZW64/0slXTLY9QNHZwzAjSCH2Pevugv2aPeuoNHDj9Td9hXroWpHUQce?=
	=?iso-8859-15?Q?musK1vuj9PQhvYOIoqAMt2MuY2ET3Um+AeKdfA+qBjoS3y8vyFxF34H2B?=
	=?iso-8859-15?Q?mVFWTGYRFkMAAlxp2WHvnrCxww8aiEqTiVRf97Hdn8lhT+HobCm+U/BP4?=
	=?iso-8859-15?Q?Yvy1cU5a9ojgmXBStSvRgWLFApcvAO2MPsEtqc8pfoQrroJ8cXYX/cn2Y?=
	=?iso-8859-15?Q?8suNcm4ktnBbARd8D15B3vGSlYvQGZEqZxA/vYXaGf0bTt47sq49ZOd49?=
	=?iso-8859-15?Q?qPDaggLEVf+19Fc8Epnjkiu+HVvz/FQAjS7kW3SovZQO/d4KaCW+fXk+s?=
	=?iso-8859-15?Q?o76YiinBepHkxMacyrmA+Py6Yl/JUbcFgWApNlMfd0jId1jhhQyc1xVPt?=
	=?iso-8859-15?Q?Vci9NF8sHA8u+hz2pG1/HiCHfwVaSjqKdI8PtJsEFzjFsMXEUW5u0dlqO?=
	=?iso-8859-15?Q?NNx2yORaKrddogxBBah0QMhRrNsiEddsGRKXZCorVKhExanmIcvnZvONs?=
	=?iso-8859-15?Q?jcylg93M+frkGS4iyu+rapOXL8GX2/L4dwX6EM8kWoD+IGEPHdiweZdYq?=
	=?iso-8859-15?Q?oKEiJj8VA1lpJxDAiuOsoZoYElIDSyOnVwpUAzSddn/meHHM4Wbc58zDJ?=
	=?iso-8859-15?Q?MPhNfsJHqC/2760kI6zjn1pCmok7vrXPricVKHOWIAwFudi7dPBXy+NLF?=
	=?iso-8859-15?Q?e+L/dpatCJu8uyhqTNSHXKyuIIIemeZCeLaRJCUoI42gt28=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b973b0ff-0109-43c0-ebd6-08d9ecd31828
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 20:22:43.6287 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EHJvF7cYh6Kj21Dlu9C+N6n5zrBErm07atGTNiHBr41/hXjJKQgQoTflx1RmJK6npMaPv3hMRpKwIQMdxnmhLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3431
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21AKMncS005802
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH v3] multipathd: handle fpin events
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
Content-ID: <7C1EE9806B340A43861E2A1DF2388119@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2022-02-10 at 18:00 +0100, Martin Wilck wrote:
> Hi Muneendra, 
> 
> coverity found some defects in your patch.

I went through them, and found that all were false positives. No need
to worry. It was good to have a closer look though.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

