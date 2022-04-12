Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD831C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 10:32:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-TPEx5ZFsMr2swOVjf-NHLQ-1; Tue, 12 Apr 2022 06:31:59 -0400
X-MC-Unique: TPEx5ZFsMr2swOVjf-NHLQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF3621014A62;
	Tue, 12 Apr 2022 10:31:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 59AB32166B1B;
	Tue, 12 Apr 2022 10:31:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1E64F1949762;
	Tue, 12 Apr 2022 10:31:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F35FF1947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 10:31:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E3BFE407E1C6; Tue, 12 Apr 2022 10:31:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DE82B407F78B
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 10:31:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C14053C174C7
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 10:31:55 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-mai4EqZVM6W4xWeMvTgt_A-1; Tue, 12 Apr 2022 06:31:54 -0400
X-MC-Unique: mai4EqZVM6W4xWeMvTgt_A-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-37-bmgjoJN8MeipURc2S4fVdg-1; Tue, 12 Apr 2022 12:31:52 +0200
X-MC-Unique: bmgjoJN8MeipURc2S4fVdg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DU0PR04MB9465.eurprd04.prod.outlook.com (2603:10a6:10:359::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Tue, 12 Apr
 2022 10:31:51 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 10:31:50 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/9] Add protocol specific config subsection
Thread-Index: AQHYThEKdbrAhr5xHE2kaVKyN3MnN6zsFOcA
Date: Tue, 12 Apr 2022 10:31:50 +0000
Message-ID: <95a66d760a1ad8ac943de611ebb3e61d5a41afdb.camel@suse.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57fd8d91-892f-4c7d-7ade-08da1c6fa7e2
x-ms-traffictypediagnostic: DU0PR04MB9465:EE_
x-microsoft-antispam-prvs: <DU0PR04MB9465133FB49F40DFDBBD3D78FCED9@DU0PR04MB9465.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cJO559rTy7rZv5RT5iADS00BzFy0ccX5GWYe329o0NQqnWjvDpv4O5FC6qKvWc78PVKwK5wCG5fAJx0vLf0RPTa/141NFKuIbk8S5BVkvfzF2R5tM50AbbK9La+KBm3aGmjyl4gr5CKQy9qtxjX4yPtmts5Lnrl1z/J7qRx8Jo4kuAwoQSaGsfhTQC4HTgszDF+Iz1xqIN49OmxBJIdN6H6CTk4P4cR5d7MsTnbcuG4s6Jy3HGbAQ/B6Bih4w/TiYdcVf1p8jN+A1QtUMgCpfRU2cghbWmHpOArUu/e3wktO/4EBjpSJRVOuY1yz5Xv8ba9DKqldcTYvl7wDG1B9yNSgs6qFfMyy2r3fMwJGsFMlfCT6wx+zKS5o2mQuI90JAdScJGlya4UEgLO41/h6k9DXqaB6PPhjHDyvHyGXE642e4TzD/PqULL+qE7JR0x3BAeOceTl9g3d0u6HuNOF4avuSKtM1APZiVqF4goKP9Ox5AqFPcH+xeLW5L9aQu13b0dGUBa+8U4RbDv4mlmt2xLpy32s6hLfEiZ7YhuL7gLdUk5gLu4xMSCX9c21JQHdvyFfrgMx0zcpFm7AMGFAH6qLdtUwLJoIWoWhmd8RfD1JkvX1xyi/bFs+560+LDjf2XPlx6aKTpdvb1E/P5x0zcX07KvyHZShvvdcWPfmNcLajop09mMCf2ibfcmDjSK81BLdMDYSxHZk3CP0XKhYXQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(508600001)(122000001)(5660300002)(6486002)(44832011)(316002)(110136005)(8936002)(8676002)(38100700002)(38070700005)(36756003)(4326008)(64756008)(26005)(2906002)(2616005)(66446008)(66476007)(66946007)(86362001)(66556008)(71200400001)(91956017)(6506007)(76116006)(6512007)(186003)(83380400001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?9Bc0YHiuHeWkrv24LQnqkG/pMLBCFkl/3L63Oe1luv2k38cEupJz8ngn+?=
 =?iso-8859-15?Q?Zvk/n0WaSINHDKk3gnHP35KNlIffM13c/cTqwnZ5FIGOo3cVQQB/olKTf?=
 =?iso-8859-15?Q?E8uKaD+vYxY7LWbrbnQGjQ239ep29R6bs/sqFUvvRhZMk8TOIiZFe8kWj?=
 =?iso-8859-15?Q?nAtfLWdHMI6U00nnOc10HjM6AOAkbP+t4GtVd08+u9PBqZm5JWv7NGUDn?=
 =?iso-8859-15?Q?SupMiDRS4Ut/tykhiYWjqNTd21n0uUahutKYFyQKP696VJmWwbyacjQvp?=
 =?iso-8859-15?Q?IIG3hB0hL3VooNW3mkL1GeRjp7bdCj30/T5YkCGV6bZbZ/Rcu0OIcQgfo?=
 =?iso-8859-15?Q?lc/USAvtt8ga5kaOADS8Yp2BGjgYaUXmqGGZrSiY23Be3/XSLWUqdpUTs?=
 =?iso-8859-15?Q?G+xiB9CfjpXrLHSCeHTEvtbUr4TvnpDdfyLFNR5Vuc1cjRkL72+4R479d?=
 =?iso-8859-15?Q?FLGqtNKz6tWeTZkZPvN7vKJGNCOoODQZDD7q9RF1gpBoXn/R8yYNqDjDN?=
 =?iso-8859-15?Q?l87wt2rlPDzqsfJiLNU4YEsaAazy2h5Nx1USvTd2+5psC/yK07thXf8F0?=
 =?iso-8859-15?Q?GFE6DVOvCaITm7poXzXqJ0IrcAiwPNe81PZlJJq6T9muVMFh0G9HC2gcZ?=
 =?iso-8859-15?Q?QRFICkNYd4+UzZRaWKQj104bPbPq+2/QN10r94Jc8QR2SeJw3DUhvE9gT?=
 =?iso-8859-15?Q?Io1iY9UrlJk0/VLkeOVLzMGMA/EIez7BM7x96F2PBGAyOavk99w5dCyV7?=
 =?iso-8859-15?Q?5MPWpBeJ7YRWPPeibv/fp+ppDrnBA5e9mkO5Cc9+Gcegg4GmXlhu2Gta+?=
 =?iso-8859-15?Q?Kkyp3980+O7gF/uThPvQpkd9wFriAeU6OFTQ06RdPLY1x6DWi5YtNHZeB?=
 =?iso-8859-15?Q?t8kixv6XET37jWT93NK+aYRMNvGRJTeihTgFAqWTiCv3DJtxPkrWUxYSL?=
 =?iso-8859-15?Q?K6ed/IPBzYNQVDvmpsPyDTDmUKPg5f8G8CNxwJyqll5whVWuRohxc0BSi?=
 =?iso-8859-15?Q?+QC6uOv1FiRzuaQ5Ht5UPJ13v9Vim0AU1mVd4gYDjil0XGG6GPcPEqx8M?=
 =?iso-8859-15?Q?0mUoaOgpUafiXAC5htvSXsQBUHtA4A+okUaeLTNOuiBtbWzgk8TV+W7n4?=
 =?iso-8859-15?Q?b+P4qn9h4edApgex81aPmP2+xriv8fE8oaLCnu7lbaIeO8Rp/IX7EAwyk?=
 =?iso-8859-15?Q?ti+0b//RY3dLnIXunqnoXlX6MoRjXSvTmkFAwqnMw2cLsjNP5/8a4gk1s?=
 =?iso-8859-15?Q?XBqNseq6z2Uayq0qQONKJoLMFP4zoqirHYGQvawEpWZ6897li/qahCMOY?=
 =?iso-8859-15?Q?QZhVdqFvzYljBmNErvHy2C8ySMlc3MJ//lUck2hHOu06pZ2SOYIulut/R?=
 =?iso-8859-15?Q?ga38imbGdkyA2mFOn09qXB1Z3qLh7RQUh/2jBIwBPO34IAWupwmT9fJmC?=
 =?iso-8859-15?Q?vjMJhZD5TMRODkmnjmkLZ/P4DQWDlHq4J1U2iqR1dI62QY9PtiOoywAw8?=
 =?iso-8859-15?Q?v0Sy/ugbdydZJDM/+2pNtJHiYJh78ep1NxOeUnCbp4LgQaCVRltd2bzu2?=
 =?iso-8859-15?Q?EENec1Af4lRIms3naSMdc683ZXi8zF05m11/dM/xT4Fvdji4g9yMUQVY2?=
 =?iso-8859-15?Q?mXyNH/iOw966MzpcoOCn2oGoxXH6aY8hwesef/b1aTbuZxEUbioIKrJw6?=
 =?iso-8859-15?Q?tp/0Jwh8ijRSBzQXHLmID9ITk1fWkoDMuTwfVqIt9gV3vQbEGCdlVnIBh?=
 =?iso-8859-15?Q?LD7k/HVR6m/MeNoNWkYY4Ry4LOUlQfvueBBMvXEzgC1QFFOzxm9R0L2D8?=
 =?iso-8859-15?Q?lB/JNp5Vs8eLzODi8uoGoIMYW9NqE+Zgg1MesRePoZdJL1Ig7YiOlwCg4?=
 =?iso-8859-15?Q?ha1Y=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57fd8d91-892f-4c7d-7ade-08da1c6fa7e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 10:31:50.8994 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FvWaGpj6tA2UowmKcrsN2yHlCOcW5LNezQndLhzFdonfLF3PiBBeS4fkmrmZIbcoVjXdJuj9Wl9UpmEkZYS0mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9465
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <04800917081CD44BB57D8D079B52DEAB@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-04-11 at 20:59 -0500, Benjamin Marzinski wrote:
> Some storage arrays can be accessed using multiple protocols at the
> same
> time.=A0 I've have customers request the ability to set different
> values
> for the path specific timeouts, like fast_io_fail_tmo, based on the
> protocol used to access the path. In order to make this possible,
> this
> patchset adds a new protocol subsection to the device subsection and
> the
> overrides section. This allows users to set a device config's path
> specific timeouts, such as dev_loss_tmo, fast_io_fail_tmo, and
> eh_deadline on a per-protocol basis.

Sigh... I am not happy about this amount of additional complexity in
the multipath configuration. It is already so complicated that hardly
anyone really understands how it works.

I fully agree that some properties, in particular fast_io_fail_tmo [1],
are rather properties of protocol or fabrics than a storage array.
But do we really need to differentiate by both "device" and "protocol"?
IOW, do users need different fast_io_fail_tmo value for the same
protocol, but different arrays? My feeling is that making this property
depend on a 2-D matrix of (protocol x storage) is overcomplicating
matters. And _if_ this is necessary, what do we gain by adding an
"overrides" on top? [2]

What about adding simply adding "protocols" as a new top section in the
conf file, and have the per-protocol settings override built-in hwtable
settings for any array, but not explicit storage-device settings in the
conf file?

Regards,
Martin

[1]: wrt dev_loss_tmo, I tend to think that the best value must be
found based on neither protocol nor array, but data center staff.
[2]: I strongly dislike "overrides", in general. I wonder what we need
it for, except for quick experiments where people are too lazy to add
explicit settings for devices and/or multipaths.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

