Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B00C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 18:03:16 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-zXcB-U5mNzSc36Wg4zOWiQ-1; Thu, 10 Feb 2022 13:03:12 -0500
X-MC-Unique: zXcB-U5mNzSc36Wg4zOWiQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB9BF1091DAB;
	Thu, 10 Feb 2022 18:03:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20366838E8;
	Thu, 10 Feb 2022 18:03:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2D5C41809CBA;
	Thu, 10 Feb 2022 18:03:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AI31RA024766 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 13:03:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1D0C31121335; Thu, 10 Feb 2022 18:03:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 169AA1120AA8
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 18:02:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F365C811E76
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 18:02:57 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-620-Wd-aQ1WtMcOGiFc-1hiqKw-1; Thu, 10 Feb 2022 13:02:55 -0500
X-MC-Unique: Wd-aQ1WtMcOGiFc-1hiqKw-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2059.outbound.protection.outlook.com [104.47.1.59]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-38-6xdGXhgGPT-R9ntjn6iF8Q-1; Thu, 10 Feb 2022 19:02:53 +0100
X-MC-Unique: 6xdGXhgGPT-R9ntjn6iF8Q-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM0PR04MB5041.eurprd04.prod.outlook.com (2603:10a6:208:bf::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19;
	Thu, 10 Feb 2022 18:02:51 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Thu, 10 Feb 2022 18:02:51 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>
Thread-Topic: [PATCH v3] multipathd: handle fpin events
Thread-Index: AQHYHmebN4b6TWOhBUe6OTftFkCXxA==
Date: Thu, 10 Feb 2022 18:02:51 +0000
Message-ID: <2897ed41e17e2c2076335fe6ea6bbcc6fbf85ce2.camel@suse.com>
References: <20220210032810.714821-1-muneendra.kumar@broadcom.com>
	<d564d33320acaea31144f7f224a515556e786976.camel@suse.com>
	<133eed88a2cd40da76e53829a4422ca6f6faea18.camel@suse.com>
In-Reply-To: <133eed88a2cd40da76e53829a4422ca6f6faea18.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82d810b3-28d5-4117-75af-08d9ecbf8dd7
x-ms-traffictypediagnostic: AM0PR04MB5041:EE_
x-microsoft-antispam-prvs: <AM0PR04MB5041E6F832D4F3BBA3E55FB7FC2F9@AM0PR04MB5041.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Z9bYUCgzoFWCmDQWgxHCYO+6/I/5/dlsy0WBZptv37B1XrL1ezvGdcJZ/FYtMxU5M4n4nwGRRzV5vJ/wy+1UbopHQ59iorDzpAOqKy4HwC4a/PASErLaJj3xe05TgGlBXxIEjocXl7bYz/xAqbEiIHIvJzokT3Ha6u6TZqODoNFvOJH2r6E2MqEEB3GYNqrtGep2hHIZYkEDArjPfccFL051mejmDs24SfEw0C2vwIqiBmYRsXHBBa+ix2dRNyL+v8mEfuEBu8J+oWCc7tIQpSzopSNooM3yLcjiof646SiJdobaf7BRyC7dWl0akdDd1wg4Z7iXfZMZsOO7OvjPNPN3637X05L9jUtV29NYYdgRk2F/sobFknaAbsEmY8RddWz+Zw+Jy0GaoZSXevm+TwJMhk/Iay1Zzn+eUfkBz3u3m1JXmQ5IpvlV4wviOb5h/LGpCOA7p+sMcd+UVd0LW2892/ba1VNJUFqf7U3IsykEsqiHCGruYyPQni84SEmlxTU9LK7x7qTv+Bj5pUIRYwwWqvogRBQan5jltF4Iv4WHw0kjnLTRJtuzOVFSnty1G42bxdQfi2RPki2NTNzQ9ZjnF07caSbZDCr/IBPOhiYE8HpQ+UB96ORaiTuZFTojFprh1j9wHoPVSe+4J5glO50wKzhh6/AFzfg0ZStkSI+tUSJMcoSz3gF+hgZba6qpFUCYnx+MjWWNJ6n9BzUujvbDpyRLXh1ho4rhpwIbZn3w1eWSLFFzrmjkAvx/a8V1oix2fXjDHacVVoZ7yuS5BZTCU6azQgoS1i15LjyFAfA=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(966005)(2906002)(76116006)(6486002)(4744005)(508600001)(186003)(26005)(5660300002)(2616005)(38100700002)(66946007)(36756003)(54906003)(6512007)(66446008)(66476007)(66556008)(64756008)(122000001)(91956017)(83380400001)(316002)(110136005)(86362001)(44832011)(71200400001)(8676002)(8936002)(4326008)(38070700005)(6506007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?g2oTeDpKcY3OnfyCgpSWs+rzitOLoj3oaqKMgEVsTx8XZvIxiPE1TnM1x?=
	=?iso-8859-15?Q?QKlc9ga+gS1B3caOjLo/r8iIHgNpyCvPYp6ZLLCcRNwKxANexAKA/7gxs?=
	=?iso-8859-15?Q?wc5Qqonj4FrhNHbWUQKTQUaUzStY5c1Jj5o5tjm/p4ZGsSCqyUrK2oy5h?=
	=?iso-8859-15?Q?XqqFBwPBqF6MqftLVPYdhM17jPMqzylmu+jbWIcsLzWBa69VUbi+S++Co?=
	=?iso-8859-15?Q?qA5dsELS3UhTHj/MjO04K6yNOgSC+rhsXPNU0SXeS92/jEAe7w02dfNRM?=
	=?iso-8859-15?Q?mRLGAHGRMjE7BARJUdAWcvnK2XbdTO8eqz23nBaCKSCLulcWG6RrDuRR5?=
	=?iso-8859-15?Q?rbDcWOVT/eUyHCgG58sPVa5UsiJDpHLTy7EaKIeE6HZrnnD4A5Stg8Lc5?=
	=?iso-8859-15?Q?1OHdKpQ88j/Yn/V677oEuQRrNJMXJILg9jGrk7PebvGhNQHxh0YtqYZWw?=
	=?iso-8859-15?Q?pZZ8BL7uq/4Lmhr51mZMLa8fsPeRJA2kzettzPrP+M014QFQc0uPs8x3L?=
	=?iso-8859-15?Q?lyjomAcK9MBXBOQPkeDXkLqlJNBBlSm23rsmJchjtUZLcin2+PmsamZy8?=
	=?iso-8859-15?Q?xHcA7rKx1aVL+r+3PU4a0YeEGJo5b5870z/L8L9807khMYTUrEUey+2VH?=
	=?iso-8859-15?Q?3Xig43PBB1z99ZX18jvwvuXWxtxi5RI09ONDxgWBVjBj3YD2OZUmETq5M?=
	=?iso-8859-15?Q?WVVfOSdF9cjAC70kops7WMyunsmrIH7Oah89SzLz9RpXHhJZ5Jywu1U9Z?=
	=?iso-8859-15?Q?gPAbZOPr1svk4kN4JFzn51YlkOqge4N4c65ZvH7efgGOfq6Z0r6EiVsP8?=
	=?iso-8859-15?Q?oNx9RPqsSbKnjB8IiKcaAyrvIP32NtObmElMH1h592hDj6mPOL8pEUVmu?=
	=?iso-8859-15?Q?N4rWc3TN0kv/jXw4IDlO+YoFujEtV2/xrB0Odk2rL3VYldkPPC7/1VSSa?=
	=?iso-8859-15?Q?rLq9bbsXW60NxL3BtnMp85JkMqy1whw9aRSlvtcXKKUfbUrhv4kgHAwwB?=
	=?iso-8859-15?Q?doV4Y3LvkzlybSqnOmOX2zKezHZf6Xh9URR1zboBkzUue/IU7eErDOGU5?=
	=?iso-8859-15?Q?R+QK6LI/4ik1HAe9Zh1IjI06O0iBLTBQBC4vOPVsbHBJkAPOmUepNUMBc?=
	=?iso-8859-15?Q?XwcZgfPuIB46h0zz0hCDEcYoysOSmBRfESw+y1n9Vk2SFoWVVyNaKyLBq?=
	=?iso-8859-15?Q?wjChFB7zmNnKWWlOb92qZR+d2c804VJ2YaSLMVRwdjEqOTgi4K8H4wny/?=
	=?iso-8859-15?Q?UA02AQQPRjyMnniuchyq1T3cvHCeUDLk0t9pLnyMsfEIIiWjPCsZLZGOO?=
	=?iso-8859-15?Q?brIQkBiW+bkvEEJYxxgMwSHjZVIsxydvB8B2CgxPFE5z2MLJn3FVFBk8Y?=
	=?iso-8859-15?Q?V2AbNV1ny9Ipbybh1ptS/wLU/wKOXoFtsFQvb5PZC3E1lAIFBgfozmLJL?=
	=?iso-8859-15?Q?hg76BDxcJBrBI+YFAr9g99aDzk/atW8Mq5TkxxE+6cjwCYxwEu+WhTwS6?=
	=?iso-8859-15?Q?FWFEWt8l69kPECaKI9cAvupWMG3TPcVxtFO9A64VGsBN7+SfCtBYdC0y9?=
	=?iso-8859-15?Q?MWeDOCc/7xNToJ3ihZXuVUxBwHLhDFJ9FXBJXTsI+kY5nNBUkZ7DGl2bC?=
	=?iso-8859-15?Q?toN477l/A4Q2SghCV/5k0s/2fmsaVsN8KDRezEHnLNZ5cZleJFbclz4j0?=
	=?iso-8859-15?Q?zQ9z/M8tMVgmdIJ8+OmbOXSvcO8tWXRC14uHhDhx5Hk0fL8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d810b3-28d5-4117-75af-08d9ecbf8dd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 18:02:51.1783 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h3pknid/QDRbd7t8zaWKDUS60NBbk4L6vOu+jIgIpmlKZyw57ZticaYm9gTptAEno3gwvaB1OcQXIYfT0NYv+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5041
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21AI31RA024766
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
Content-ID: <8F7B65508E387F4DBBC9A1F8753E6E3E@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2022-02-10 at 17:55 +0100, Martin Wilck wrote:
> 
> The CI found a minor issue on 32bit, which I'll fixup myself as shown
> below.

There are more errors. I'll have another look. Muneendra, you can check
this yourself by creating a fork of
https://github.com/openSUSE/multipath-tools and a Pull request against
the "queue" branch. While I won't use GH for pulling it, it should run
the CI and show you any errors.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

