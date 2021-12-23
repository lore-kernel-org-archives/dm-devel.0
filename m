Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26CE6C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 23 Dec 2021 08:46:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-hPXgfl13OlSKYzmZBQd3SA-1; Thu, 23 Dec 2021 03:46:00 -0500
X-MC-Unique: hPXgfl13OlSKYzmZBQd3SA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B61864143;
	Thu, 23 Dec 2021 08:45:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86888519CC;
	Thu, 23 Dec 2021 08:45:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D6B874BB7C;
	Thu, 23 Dec 2021 08:45:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BN8jknE004206 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 23 Dec 2021 03:45:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A99A4515982; Thu, 23 Dec 2021 08:45:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A51F1515981
	for <dm-devel@redhat.com>; Thu, 23 Dec 2021 08:45:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B9F080A0B8
	for <dm-devel@redhat.com>; Thu, 23 Dec 2021 08:45:46 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-626-4mI9uJAtPYK5ZUetbzDl4g-1; Thu, 23 Dec 2021 03:45:45 -0500
X-MC-Unique: 4mI9uJAtPYK5ZUetbzDl4g-1
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur03lp2051.outbound.protection.outlook.com [104.47.10.51]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-28-cpL7JkgNNB-9j25_gK4VZw-1; Thu, 23 Dec 2021 09:45:42 +0100
X-MC-Unique: cpL7JkgNNB-9j25_gK4VZw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB9PR04MB8266.eurprd04.prod.outlook.com (2603:10a6:10:248::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19;
	Thu, 23 Dec 2021 08:45:40 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4801.024;
	Thu, 23 Dec 2021 08:45:40 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/3] Don't enter recovery move over pending paths
Thread-Index: AQHX95z/xgJVT9m80kyxZpHHiEXxnqw/w7MA
Date: Thu, 23 Dec 2021 08:45:40 +0000
Message-ID: <4fb1f5e51599d63e98828346e7a7725225cb9897.camel@suse.com>
References: <1640223155-1678-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1640223155-1678-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f36bec45-837e-440b-7a86-08d9c5f09993
x-ms-traffictypediagnostic: DB9PR04MB8266:EE_
x-microsoft-antispam-prvs: <DB9PR04MB8266F07CDD7E55BF9BABCF81FC7E9@DB9PR04MB8266.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:800
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: EDglUSDjuvP/1GZW8TWX5Dve/prQRbqEt+/55JkSZydcPBsB5Cy1Z8eomcYPWm1PVR7mak+CAGbMBSj5Lz0cM6T/m9LZNd78VeS27PP3K3YXGIPtVGEbp6tIVue7lN3+DvHWF04vT0eS7CkJC8jbqeByOEgMN2aG1qJ3P5weOXkFGDec9FZu+FH0xIl4PILdX2kJgA8WBP5umcCxRU7MjpDMRO6GmTG2NFcyOWtdEU0R1dOOsUB5bGJ9cVP8arUxeU55Z6pSjS8/TdTzLfnJgsOcfkTQ143OfXGLfV9GH6ZVmtK7vj0RB+n3qZvbiBg9I67rFLMyiuaLv8K8Ep/5y85Mx4Qt960Ho2ENDtGMp+FAX2ArGw83ySGK8VeRkDWI0y9UfKgABT3fPkDWl7yX7UQTpgQCVT5n7poR49j4InfyHc3cbKaJGSbV/+HfmzldZGoSaGBAHPgzGpNW94RJeHYj64AlrYU5YicWhno+0xh408XnaSJ8d9Bkk6dSzX3xZjHqo7a8KwtWq3Ib3cs+5M9W3V711ATjA5Pj275pjY3XufXvkCgFng3jnW42yIFPvJM2vOuXMMe/vV4h+Y2GrCCxvSnxMbMG/4i6a97Spz+rLi+nM9dywr9zbwCEyGnBovVNcsCdLJT+bhY8SlruR1lh/lP+G6vTYM5DQVlznU9alCubDSNKvulX9VvXQYMhDhzFUeOUYjqp0qFbwg0zWw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(186003)(38100700002)(36756003)(83380400001)(508600001)(38070700005)(2616005)(2906002)(5660300002)(6506007)(110136005)(4326008)(122000001)(44832011)(66946007)(86362001)(4001150100001)(6486002)(66556008)(66446008)(64756008)(66476007)(76116006)(91956017)(8936002)(71200400001)(4744005)(8676002)(6512007)(26005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?DhJzVRkASNx9Ml0uuvczILAwccKwTb4Xn4U3HNCjg4hl8L4LgQ/9/39jP?=
	=?iso-8859-15?Q?Emy9nnlXbKhqcHAyYHOe4137o9MLBoJbDXcxK6yfC2YJHOUs4LMU9/WgE?=
	=?iso-8859-15?Q?75CbjlVKJbIfpBv1TpQdIJdZMuogNemzRq3sCNUGcLIyz3qDBNUxWR0kQ?=
	=?iso-8859-15?Q?4V1NrHWR4mcKVc4UQaBagVsOveSbtEy9XhgfqJkaT9YRfpP9gdEeDOUx3?=
	=?iso-8859-15?Q?oYhtQkbT1wSP6k+QvhMHCWSBE5GcSKlllJ8bUJQE33N92CSzOiYA6MWxD?=
	=?iso-8859-15?Q?9X5qQmaT04Uq+NZRDcYY5ZXvSC37CgNhMDlJ5eEHo30nOM3PsK+1vyXZL?=
	=?iso-8859-15?Q?scPB9zQSuJ5iLQourVrqtGN7SxKGZa+yPLIGRdLyO8SAN98cTvsacpO/2?=
	=?iso-8859-15?Q?cyRZpnuqU5PsRsJpkJ/+ApU0EeaVP9+XWClz6ib+5KEQi2sfB+6XDyriw?=
	=?iso-8859-15?Q?lh1s6AFN/XtRRpgX4+t8byGdSEreZFi5Of7SofzVO0UWvuSwLFtn8hnZU?=
	=?iso-8859-15?Q?M+GPgQdzfq9exuwHK/ew/5hIWzZC/w9lAjK8T0qRYDY72RbEw47iEBfjM?=
	=?iso-8859-15?Q?TXtDrg3gNx1lpziC+btAqTslyvqRn7KpGw1HFKoM2n/ddQbzHQQ6UM8dy?=
	=?iso-8859-15?Q?WdgVbInCqCdMi8jqCJdZ8QTtbxLsqri5YyRCumvs5gqHV/8K/VI6uc6bT?=
	=?iso-8859-15?Q?pt1YslptMR4QGyp8Jjx79s6xAfEh+w5sRp1+VLrY17zHXTWddzk1mEr0E?=
	=?iso-8859-15?Q?aXXRJPNmEqOZgGysmn7gabYNaw/oqC9Qtz8viDNv+xgRVYPIZeyf0Gx3B?=
	=?iso-8859-15?Q?DzJfjDCMc3z6onNV19ck6mTmgfMzxFWuXDLUC2671EV8pM5htk19dXOFh?=
	=?iso-8859-15?Q?6wUymFKzDpOr2KgwuDapKnnakhmsA8Qe4pD6vsqOjHiz7Kgp1f7LjFI7n?=
	=?iso-8859-15?Q?Jw1xr/z6IskcH3gtDqxIL0xd8akEI1FLmpnknO0483YUTXQ8wSwQCAxhK?=
	=?iso-8859-15?Q?pkt7X6S9d8ekgMAKfTuyV4EnTYhLhpQ0dNN519/zcjmSTaZ8VzeM8v6Xd?=
	=?iso-8859-15?Q?5NUCrcpUp1toy+NNBFlt02f8FFGNEKZIYHax5ApmYr9F/sxtaqyYdUYC3?=
	=?iso-8859-15?Q?UXAp7VkM3sd4PsScXDq14OVnySHsGgM+eLjKHLruUOS68xEeCO6dbXp06?=
	=?iso-8859-15?Q?6DEVeMq4bGVREAL1/b+Jh9RiEBXIh6zGDrUCggVTxctClaCGZdZhiZQM6?=
	=?iso-8859-15?Q?VcFjLBPA/1bNp3hCIwhSh2K4pNZQuPmND0nFMR3MNWGRobi9tblRL/LVK?=
	=?iso-8859-15?Q?/Dq9QMcpHAbj4nd2qJ2f+LwDwSTNhIrRAT2W72RU8qSvAOmRP44EIsfH/?=
	=?iso-8859-15?Q?OCH9yHVdLqQZn8uS6sxhI01pW3UgpRHZZrTEuP3A5iWrzVWp6J0TKS3tw?=
	=?iso-8859-15?Q?P3h7nGnLDDbOgztd1hr+PWGZlcs8GeOu69lFXnUx9yBCFIWAkEn0Rqf6I?=
	=?iso-8859-15?Q?C0p8ggKzBhYj0PKtgp4dNb651CeXLvsrknS1trRB1tRMUTHv2weG6e+/y?=
	=?iso-8859-15?Q?v82n4Er+AqDRClALBd6jFyXbmfmUZ/zr4XXAf4RoHmloAzeoVzRGl8HlR?=
	=?iso-8859-15?Q?aX3ixmyBz8HZWddLinXkNmJod52sk4VkVQqLbNH5insjzDmu37snvzrej?=
	=?iso-8859-15?Q?b7GUPRaMKoCKo6Xl5DL0+j4bZHtF0PJzD6u85IwSb4a+1Y8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36bec45-837e-440b-7a86-08d9c5f09993
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2021 08:45:40.8558 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cvEXKevBo1BQJNwtAWjgPuuSNxPRPEwh2v/LsTTx4zvBMZJ7rmUJvo9fj4XDLOKKt7d2qehwxvUTWG0G+Y2pvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8266
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BN8jknE004206
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3] Don't enter recovery move over pending
	paths
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
Content-ID: <5D4AD042CA694A44A0D6652B22842090@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-12-22 at 19:32 -0600, Benjamin Marzinski wrote:
> After commit 2e61b8fb, I started seeing multipath devices switching
> into
> recovery mode briefly on startup.=A0 They come back out shortly, so
> unless
> no_path_retry is set very low, this won't be an issue, but multipathd
> shouldn't enter recovery mode at all over pending paths.
>=20
> Benjamin Marzinski (3):
> =A0 libmultipath: fix DI_NOIO pathinfo PATH_PENDING handling
> =A0 libmultipath: simplify out __set_no_path_retry()
> =A0 libmultipath: don't enter recovery mode with pending paths
>=20
> =A0libmultipath/discovery.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 5 ++++-
> =A0libmultipath/libmultipath.version |=A0 2 +-
> =A0libmultipath/structs_vec.c=A0=A0=A0=A0=A0=A0=A0 | 13 ++++++-------
> =A0libmultipath/structs_vec.h=A0=A0=A0=A0=A0=A0=A0 |=A0 3 +--
> =A04 files changed, 12 insertions(+), 11 deletions(-)
>=20

For the set:

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

