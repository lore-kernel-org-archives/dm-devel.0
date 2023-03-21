Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 224C2C74A5B
	for <dm-devel@archiver.kernel.org>; Tue, 21 Mar 2023 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679389892;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xpZU9GTCisMtRrLw+w3ePm0Ffy//aGnXqIKAs6bSo/Q=;
	b=ECl69NK/h9z7ZBSk37sa+pIGq9TDEPHHj75rIH/hkk4FDrXSFQzwWRPF8KHEkvtg5aPqIP
	dXfwTgGvqfB0136oUlE21jfziRIS+ZYUokmeHo6C1J3fbeqQ79vryC6aVT/pwLnuewwb2q
	wB33+d4h4yVTBh3LN8Bcbb4Kk4pv9P4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-YmRnPGZcOGeNpIE48PZZVg-1; Tue, 21 Mar 2023 05:11:28 -0400
X-MC-Unique: YmRnPGZcOGeNpIE48PZZVg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46636381494A;
	Tue, 21 Mar 2023 09:11:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 34C2940B934;
	Tue, 21 Mar 2023 09:11:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ED6A719465A2;
	Tue, 21 Mar 2023 09:11:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 496401946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 21 Mar 2023 09:11:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 27D211121315; Tue, 21 Mar 2023 09:11:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FCC21121314
 for <dm-devel@redhat.com>; Tue, 21 Mar 2023 09:11:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01C15800B23
 for <dm-devel@redhat.com>; Tue, 21 Mar 2023 09:11:25 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on2040.outbound.protection.outlook.com [40.107.13.40]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-wVaFmCF1Nwav2mUtophxMA-1; Tue, 21 Mar 2023 05:11:23 -0400
X-MC-Unique: wVaFmCF1Nwav2mUtophxMA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DBBPR04MB7531.eurprd04.prod.outlook.com (2603:10a6:10:20c::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 09:11:20 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408%3]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 09:11:20 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: limit paths that can get wwid from
 environment
Thread-Index: AQHZPKvyANbsh8kW3UyR3Hllsj4wYq8FMNqA
Date: Tue, 21 Mar 2023 09:11:20 +0000
Message-ID: <8c2ff75a12aeefb7ea1502ddccbb89094b380458.camel@suse.com>
References: <1675963711-22722-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675963711-22722-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DBBPR04MB7531:EE_
x-ms-office365-filtering-correlation-id: d258acc9-d610-4350-790d-08db29ec3c75
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: +LuHSNlJQ3kxWvKGOoxQ9kn5l3nko6KSxFYe8OEoPFjmLAvddijVbOMZxa/tGi7kPz5ZnK9KigZiguMstVo26j8mbcT0QXP+wACOfnkksdMRC4YDxnXo0AXVBIVM2Birj+eUh1WR2ZNSo+6LRJNc/dhOHICK+FgC0Vn3G4ZGU1l+sEnwCG420tdaZKVb3hg7MiTpnhrbs0iPjAOdGJCZBRfwgkz+4VidQ5TZfNX9K9xjchqrC5JyOONkQjHAiLKedjeSCikiU+ma3oxEZkvzTws3beUuicIXICv1pyWdjeFIz43wjLosceBOfFJvcpoYgorOmtFGhFhvYDWlHJ4FSKMP9ythKRMOIS57wPyqPdtJgae/gsxtku1MU4NtE2ss1nE0xuyHD6Zl5taZPy2fiNCmlhKqK61fJ0ACY1XR1xAyjayHAESuRba4TZxZArYu9Ru3Fj1O7n+f6VxC+UIgzPRt+SbxzqYltPlA3C2xCDpO8rQqHiKOapxZRqHbE44y5jJSX+z/9GPOyVyQvP9kFg10a7aIojQy/lITL42DZ5D/f4pdVMrs1o9yuGeUPQk+Xp4+/3tomKW9tZ4UMUIi4D/8wQzq/hT4h6MaUIhtwhWbBHDHX8/XPEaSw/8bteobjLwHRBLRvQkF9QbDU4Wv+/HQfBVRam/5AVmWmnFVnu0h8CvtufNkIr/KeC2NYXt39joa26tTlb9WO7qW45/PmQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(83380400001)(2616005)(6512007)(71200400001)(6506007)(110136005)(478600001)(6486002)(26005)(5660300002)(316002)(186003)(44832011)(76116006)(38100700002)(38070700005)(86362001)(2906002)(8936002)(66946007)(91956017)(122000001)(4326008)(66446008)(36756003)(66476007)(66556008)(64756008)(41300700001)(8676002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?pqjmqB1Dmf74Mc2zHZsp1N09FFTHjqs+BBhQZ0FRf7e2HmF9B56UpHB2r?=
 =?iso-8859-15?Q?q8jA9yFTeQ+m/vX83W+5r7SQTD7yLswIJ+hdX0TKeQXZPc1THO0tYX6vZ?=
 =?iso-8859-15?Q?FarMgXKMVJBj3AzN1Pu1rKL3Y/lh2nVVekbPIJY0+qov4OB3PvrEukcDJ?=
 =?iso-8859-15?Q?leTk3LlcICJ1/w2RKSTxTUI004pp+VjTBvl6yaCUS7xdgyDuqzNdJY9A0?=
 =?iso-8859-15?Q?ZfGFg49id17J+CkHMIPwlKlsYwsVSbvJ869jXsFLMAOree8YtxavX6Fp0?=
 =?iso-8859-15?Q?GZ2ops/jTb5ExWgerGQa8qfCP9BnCV1eBO9LrCUArTkWVwPiIHh43HoAC?=
 =?iso-8859-15?Q?uywZWSrho+Lt4Ga31uNz7eJ4ZUBTx4JrhLC0mWArr18n66E98X6+BApv/?=
 =?iso-8859-15?Q?3G29uQHodeA+ZhO/sYrqOTKlaAaOGYelUxqz9HtCLktIovRgUDf/e97yH?=
 =?iso-8859-15?Q?Aet1bxHj0a9//jNwjAtd253Ma4ZG3j+y9d+TeaZCDl6jt5Mhvvy/+nDVs?=
 =?iso-8859-15?Q?yqj31fqH1pyNJEQj62uLChl6ycDRdXsSVTXwfVyAZPPOqhQXSWE3XpLA0?=
 =?iso-8859-15?Q?mGI+fLL2q//97ytzyA9aYvhCgHidgJ89mEz204vXRMybaqTu/VcRQaDOl?=
 =?iso-8859-15?Q?hcFj751ASVSPUYbjJi5EmIrrAp1kCE2tYUExyvfMZpqwW+9Ks0kcVpqNi?=
 =?iso-8859-15?Q?gvgEZ6J9bJvh6B1jvNElXkBoaSFbC0sb/NIhJa0Dq8GCMrtyMuJ+CXTEB?=
 =?iso-8859-15?Q?XjZCRTdpswJ8nQ4faZMjkODYjOStKFK2MmLbW4Pls6/h7ZAjn6Goen5I5?=
 =?iso-8859-15?Q?SxWg+wHh0bKEoS+dcZ6/I8TOKL1HY8Lcutz8Um1hHVV6n1GioMtTw306H?=
 =?iso-8859-15?Q?GlPxy4CjyNZdJPWNV2Orv0vpCz+aoPyS6GSjsFOY2kYzfXgMFtoMH58Mz?=
 =?iso-8859-15?Q?t1Mv2cwI3Gp5K+/kbV0BmH5Fpn/5dWJucUG/UwiuxU9tg5dBIw8Eri9oe?=
 =?iso-8859-15?Q?oRH550EFu+RbsAinwdFBKGZ2QJ4nLlGJJGLdtY14mzPjHCvSV5Fqlp7OF?=
 =?iso-8859-15?Q?77tbRLjvnwWqCeoMkhGS9YfgcfIjtlqN9wZH80QiHN82N7K7FmJ5q48c7?=
 =?iso-8859-15?Q?fxU0Z6RAmr4inJ55hxbJobtoieS37vOy0LfN4oASV/xS3bnHZkp715/Sv?=
 =?iso-8859-15?Q?j9beH0SUApVYS7ru8ihrNFXEfTUHAB57IYVru38XlMprMx/fkDaeQqbUm?=
 =?iso-8859-15?Q?Z8ThNGZGmcckFcV7lGNZ4RGg9ueGi9EGLEOaKx6QRenlPv+3WmRwqJJ8c?=
 =?iso-8859-15?Q?Dklz5qZmq/dc7t0W8B6yg61jhRXn+NVt+5vGv2WW14GQpWVKsFefQceZq?=
 =?iso-8859-15?Q?+JO7Yv/KZmv+0lDg6T+bG5XTRYJLbXZHlvHNlEiBDq91IyzKZwUr/VoqE?=
 =?iso-8859-15?Q?I+EGLpbzBiTlFWaMfg8IFkAX7pzd1r6cnKJeqwDAtuXyDipNQTgXa6E4J?=
 =?iso-8859-15?Q?BLbvt8H7WjHOJa6WiBBPSN83bo8n6zw1Uuq/XTQ2jvzwEgNaYyOTAHMqw?=
 =?iso-8859-15?Q?+lkYg4WXWW6ExxcS7up/QLTZfQqtSJ08c3xNoKq3hEDRLoF9UcnwkbQyx?=
 =?iso-8859-15?Q?YSIGembfizT5VwjmwOp2AlZVjj+6/M6GyiIsxhJjcPfXwErMmgWiZZFkv?=
 =?iso-8859-15?Q?5GAXoR0ByYsTiED2RdUdecD8Cw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d258acc9-d610-4350-790d-08db29ec3c75
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 09:11:20.6097 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CgWLZ4Tw2146YXHyBbRWgtvjvJ2w9NHC/aFyazEemwCwqWuSAlfoHlVyUCpQShsmWXl/N6cvUUq13VZy4hSksw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7531
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] libmultipath: limit paths that can get wwid
 from environment
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <C5BA11F97B710841B924E0E0E3E52F57@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-02-09 at 11:28 -0600, Benjamin Marzinski wrote:
> Currently, whenever getting the uid_attribute from the udev database
> fails, multipath will try to get it from the environment variables.
> This
> normally isn't a problem, since either multipath -u is getting called
> from a uevent and the environment will have the correct value in that
> variable, or something else is being run and that variable won't be
> set.
> However, when find_multipaths is configured to "smart", this causes
> problems. For maybe devices, multipath needs to get the WWIDs of all
> the
> other block devices, to see if they match the maybe device wwid.=A0 If
> one
> of those devices doesn't have uid_attribute set in its udev database,
> multipath will fall back to checking the environment for it, and it
> will
> find that variable set to the WWID of the maybe device that this
> uevent
> is for.=A0 This means that all devices with no WWID will end up
> appearing
> to have the same WWID as the maybe device, causing multipath to
> incorrectly claim it.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

