Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7623BC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 13 Dec 2022 23:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670973033;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=t5+yXqKZBCZPtgsjxpJPDGCxSqFIOrXckhhiPQGD6EI=;
	b=Q5TYiXhNRkflyPRYw0+hPBOqa3/QMr447AEvNXBLjEF92tNp74HcsiNztT90f9WZbHa5br
	aE3uVp+6GAivZHulW62nk6dFrxH3zGbrkEJRWHbcVaJgesugUJ1WDufOjmHOXKP6v79R0P
	2a4BhNRjB21jXKkusjuTPWJJ4S81oQE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-kE8x8Z2wPEuObO9WMZre8g-1; Tue, 13 Dec 2022 18:10:30 -0500
X-MC-Unique: kE8x8Z2wPEuObO9WMZre8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86183804186;
	Tue, 13 Dec 2022 23:10:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 227CF40C2064;
	Tue, 13 Dec 2022 23:10:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A5E831946595;
	Tue, 13 Dec 2022 23:10:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A3594194658F
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Dec 2022 23:10:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4E4F153AA; Tue, 13 Dec 2022 23:10:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4563651EF
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 23:10:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C42A29324B7
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 23:10:24 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04on2055.outbound.protection.outlook.com [40.107.8.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-BhCzCnitOeCHrbgkA0VYEg-1; Tue, 13 Dec 2022 18:10:20 -0500
X-MC-Unique: BhCzCnitOeCHrbgkA0VYEg-1
Received: from AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13)
 by PAXPR04MB8765.eurprd04.prod.outlook.com (2603:10a6:102:20c::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Tue, 13 Dec
 2022 23:10:17 +0000
Received: from AM8PR04MB8036.eurprd04.prod.outlook.com
 ([fe80::f330:43d3:b73e:e009]) by AM8PR04MB8036.eurprd04.prod.outlook.com
 ([fe80::f330:43d3:b73e:e009%3]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 23:10:17 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: review for the head of your queue branch
Thread-Index: AQHZD0QJys6AxMr6vkKA6YgY6oxJfa5scZcA
Date: Tue, 13 Dec 2022 23:10:17 +0000
Message-ID: <8b7c4679ba2267bed58223d2bb8e0c4112e729ef.camel@suse.com>
References: <20221213224117.GA6245@octiron.msp.redhat.com>
In-Reply-To: <20221213224117.GA6245@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM8PR04MB8036:EE_|PAXPR04MB8765:EE_
x-ms-office365-filtering-correlation-id: abf4ad39-d7d3-4745-1737-08dadd5f32e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ED9+9zfhvysalcvW8ntMHkY5zl0l+qRVLhtEwFpD5PPSVffSkswI59VEt5siyDGPPHHGbCYYWRuzDKoXw7U3G3AakDcRsQ11Ij3rvamzNjnK2RxlRVHzN5nVyXHBsF6qPP+JxtKars4R3VmQm8mf3P/2C+G+3DqilGix/HUH+OQNcMfQqy7psnL2ew4fiA6AeOaBAWiBnhzdN16hBwKt6MtsvHFCN1haN+X2akzOMtC9e7Cy8JLnDtWxQgKtcuYvL2gAkQcloL7ZhCac8YMj08n1tiUaOS6jSXiMbXakzWBT0fFziEFIWH+XJ6RostQkGu6BrrdFQgPfV8qBJFy5CBlNqFlZl8lIADkNn+5P4RO9G1oSoO9luy3E9iMKUHOa1BphfJUu8pLxOVxr4jHaNYyK+uPbcTZdT48p3lgmddxJQ7xK7zjbHDIJuuLm8XXY6DvKruuiltmv8XpS4tKxZjFVl9COv+mvvuP+8xE1+iSfLwTr4IPRvQxaTeVZAwCkDn4uoISKjB5sPXJZC6OE8PNz0mgOoJRFFVMWPue4vsyg63WHsVbvjnyaAragzgZ6+QXvzOXIuTE1xM14Gy9SlNaJ68si7mnAHJPNNQPePLibUmzF8NZO4mKUy7kAqzW0Wtu+zQj6FrDCYJVoTy8WZuUf8ckNXVNLmNERs7AxsSKi7RGs2AXi66133sc6+AA5Lq0rZiWsMUil8QClZthQJ/gqOyIWQozaSx5uaEIzvsc=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM8PR04MB8036.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199015)(36756003)(44832011)(2906002)(4001150100001)(122000001)(86362001)(5660300002)(38070700005)(8936002)(41300700001)(83380400001)(71200400001)(316002)(6916009)(4326008)(38100700002)(66946007)(8676002)(6486002)(2616005)(26005)(64756008)(91956017)(6512007)(66556008)(66476007)(76116006)(66446008)(450100002)(6506007)(478600001)(186003);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?bqp35mx6va3HH1V62SZiPvWXW5eR7R6huWDmxbutpIoISnKMXnPuWdm3R?=
 =?iso-8859-15?Q?8cJIU65SmZ1JAwSVdcfpQ2sJg73tDcwgNBiIHc1Ahv+useN/fmGj/dsn7?=
 =?iso-8859-15?Q?oUbXjZnDRAVtojUqRCO/OKslY919mgIAaxNMANd26tzPo4OymUoX9wIb5?=
 =?iso-8859-15?Q?jMkU4xiUwUIIOopREuuyzpI26GslT7NjiZ+Xs0qud5Y/xwJyhQUdBNx7c?=
 =?iso-8859-15?Q?sZYSVyHKh7YiuilX1QfRUvn2hvcZgZC9NX/UZ3c8VLNyifWTIGHO6PTBW?=
 =?iso-8859-15?Q?NYGBRAa23L/0KNr38giooz8FSzuFJ+f8Ct1nKLIoL5ybDpli5762EdmTR?=
 =?iso-8859-15?Q?dsY58Z5vJjzhYHtnDyPpMxfgJmM47H6QwYDjbem0PJD8iiTncA9tZipCT?=
 =?iso-8859-15?Q?kGXZy3D57J6fgHQyWX3aRezY7zXtQDVOOYJ23Zml1rnVj2j3+uhEF6Edr?=
 =?iso-8859-15?Q?7YOcJi1J1aoAUKjIwaX3Ifw32OGvSyJoxNbF02sArS8clImuISrownk35?=
 =?iso-8859-15?Q?LLz8PMatjeZ3y89bes6ZaOuVjIquOk1E3Z4kHUTfXwEeUiuqCFBqC+xY3?=
 =?iso-8859-15?Q?XslAZrCsQPTlq7hlgyPbsbhgUm05GovjtN/4OB6c9e3SoMBefXGAvHVwd?=
 =?iso-8859-15?Q?Fk1b8vKEcIo9MWwmY4o/RoCzNC2kwc25KbXARSFJVd/IMQNfAY+poaIfY?=
 =?iso-8859-15?Q?eS5qexH8rz1Hik6A1HW+h2dZ3X/pDzaSO1YfMtCCFrUBJLUj2/IEbolpz?=
 =?iso-8859-15?Q?57N+ffP0CyKasPIai1+qXHMt6W69+gDmkwltlLgYG5LGc7XofukOikyjn?=
 =?iso-8859-15?Q?JOuX/MdfCGIXskjMeM2wCql5YtXPSd1mYCaSu6EHqNSWvNJkY8CRhYII2?=
 =?iso-8859-15?Q?/5UOd2IZ+UXTzPRZOC8qHd/Go9J6vaj5YL1LwxT0uJmR+FcvwPtIotDI7?=
 =?iso-8859-15?Q?HfDwX+N5rQ7qxyo3st6LxFEyORoWHQWv3rD3R5Jm9zR7PhhWIn3QCHyTm?=
 =?iso-8859-15?Q?nRHre79FFPPOoLqViEpH+F3gZcDQlmT7FgA8A+UTKD90vlGMzZq1z3mh6?=
 =?iso-8859-15?Q?Pzem+/z9C5+uEGD8kOZvdYPJKV3QOGtnzy9lPG7Spv29ywOWwbj00Rv57?=
 =?iso-8859-15?Q?rL/Gltsf3EJXEPKciCRBD1WNTk/GUPL1uNgoTwuMNjCh1ONvqwvRek/Jp?=
 =?iso-8859-15?Q?UU9Kt6YzcfFiUvMvttQNh6PMwLK23J6ncWeVPZaNAopYkNmGF0ld/vwVc?=
 =?iso-8859-15?Q?yJcUMXKupbCh46B2uOG4tog2zwcxszM4R8Tmu9nMLB1fCUwcTO5LA4K/3?=
 =?iso-8859-15?Q?fAXmNU25rtFhZfD/lK7PneIkUM65uDrYvl5+arkdFLVHd5KoHV6JO0t6r?=
 =?iso-8859-15?Q?IIONLEGHJ0bvsuMiaS2UGWySoT813nXh4sQOKgvz9Z25SOj0Y5W8eOSeH?=
 =?iso-8859-15?Q?EyMJ/nDVW+dmX9C70OmeLk70u87pCclvZNB/1+QhSk87Uf9UAF3HdQaYX?=
 =?iso-8859-15?Q?DML1llHS1rcUcb5uO4JbMxxpzUZApeqWpiJv1zneOvhFq9FpfM2d5PPCS?=
 =?iso-8859-15?Q?fobAGghQTVZTI7YCAJFk5bNUSWVZ6ywCqpovVsa4jS7ct3NSV3rfUYSCw?=
 =?iso-8859-15?Q?OYkdHQYH4R9iqZwvlSJXOJVBbCCI783FNHdycnMcmQBA/ve5GhXuR4ihy?=
 =?iso-8859-15?Q?ZFHVfi0uhcK80MuZjLFJvXikJw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB8036.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf4ad39-d7d3-4745-1737-08dadd5f32e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 23:10:17.0900 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ywcNeEw6NPNLeytn783XmDaUSlhWGbtWQicfXCWyGvFAZj4LVpl8O4qVUoeRBs4Odgc9XFxSiUzxFCCm7J3mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8765
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] review for the head of your queue branch
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D2F1D8BD74A62E4E95692912CBD481FA@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-12-13 at 16:41 -0600, Benjamin Marzinski wrote:
> FYI, I've looked over all the changes to the head of your queue
> branch,
> and they all look fine. For docs and Makefile changes, I'm not sure
> if
> we need a more formal system than this, or was there a merge request
> that I was supposed to review and I just overlooked it.
>=20
> -Ben
>=20

Thanks a lot, Ben.=A0I am aware the procedure wasn't really clean this
time.=20

You'd acked the most important parts in the original PR on Nov. 11.=A0
(https://github.com/opensvc/multipath-tools/pull/53).
Christophe was slow to merge this time; I even pinged him on Slack last
week but he seems to be extremely busy. Therefore I kept pushing
trivial stuff to "queue" which would make it appear on the PR as well.
I wanted to avoid having to create yet another PR with boring stuff
like this, and have it merged another 3 months from now.=A0

I then added your series, the doc fixes from the ML, and some
additional makefile tweaks that I'd found when I overhauled the GitHub-
based CI.

I'm sure you understand that I am not trying to evade the review here.
Perhaps if you create another note about your review on the GH PR and
possibly ping Christophe once more, we can make some progress.

If you feel we should turn back to a more consequent ML-based workflow,
sending the "trivial" patches to the ML as well, please speak up.

Btw I also have a rework of the log thread cooking, aimed at our past
discussion about cancellation points and cleanup code. I haven't had
time to finalize it yet unfortunately.

Regards,
Martin




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

