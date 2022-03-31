Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C741AC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 31 Mar 2022 10:26:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-7b0hC-x_OO-pc_PuxV4N2A-1; Thu, 31 Mar 2022 06:26:26 -0400
X-MC-Unique: 7b0hC-x_OO-pc_PuxV4N2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BE5082406F;
	Thu, 31 Mar 2022 10:26:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2396D112131E;
	Thu, 31 Mar 2022 10:26:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5062C1947BBB;
	Thu, 31 Mar 2022 10:26:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D2C591947BBC
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Mar 2022 10:26:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 82312C28100; Thu, 31 Mar 2022 10:26:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D31BC28103
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 10:26:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4FDC811E83
 for <dm-devel@redhat.com>; Thu, 31 Mar 2022 10:26:14 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-FEqFljx1Ox6Vp-X0GYL8uw-1; Thu, 31 Mar 2022 06:26:04 -0400
X-MC-Unique: FEqFljx1Ox6Vp-X0GYL8uw-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-3-frYEK3DXO7mJHZ75gUxqAQ-1; Thu, 31 Mar 2022 12:25:58 +0200
X-MC-Unique: frYEK3DXO7mJHZ75gUxqAQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM6PR04MB5478.eurprd04.prod.outlook.com (2603:10a6:20b:97::30)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Thu, 31 Mar
 2022 10:25:57 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::3936:a521:c724:7c77]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::3936:a521:c724:7c77%5]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 10:25:57 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2] multipath: return failure on an invalid remove command
Thread-Index: AQHYROm1VOAnF1yBA0i+Cqli5r4/KQ==
Date: Thu, 31 Mar 2022 10:25:57 +0000
Message-ID: <4fc430d9e31eb3c948c6ad127c3d364bfb058f9a.camel@suse.com>
References: <1648671296-1107-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1648671296-1107-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7d04f78-f836-4cc7-c4c3-08da1300d821
x-ms-traffictypediagnostic: AM6PR04MB5478:EE_
x-microsoft-antispam-prvs: <AM6PR04MB5478DDF811C6E20AFAAABDA0FCE19@AM6PR04MB5478.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: PEfOyDvBKrZCqH7Va75UwHe0igl33bqZm8B3ai4GwQJJ30JmLWkpaSxnvLbxpxa0yd9mkqra7r8pVDSOCIJvL5cm77idNDM85R+mqs4i5vFa5HhzzCsv+38EnGSbu4c5w8MmtYHY46iKHdypChqugLUdiDwny9qug3Hl9FJtp6NlcAPUMk6thGLxlMBeseKeykaAH5LAuv85/VTvohGkvPjlPou3SgdFHkoH5pQ7bB6L5RvHX80aJBVJz0ZQQH3GKkuqtH7Kt8tPrPRepLAffP3NRcEmeuk5P3uWk/0CyzoHeJMmEn+Min3nVyqdtQTTHG8p+9+UM1tYnomEEblclz8PAsxAzjiXo196kUzaaRYIR5ERtUn8bPu+VEDoJrjEqn31NksbsCUGRfRQH/7EzaukjN8hxLjFl7xOd++D+4Uj34g9V3H3/xaSq6HQyi4ofcDm9wwGrNltyisn6wcGvbN/F955Quor1OeMi+Vp83aIRCAk03uMmKrb7iabXlsrsCIPUrCHfgKRvJnXjvXOiDMjmiP02PvPlBebv7M7S95yI3Kr0gyscrRYZXevRG8HAq9SYCpd18Gz3q0WBUqDUalYHvVRuj+tMGUssqfMPBTILqfKNBR/rgJUUfPEgovWd96LbohWwioKicVQ1ZMgw+JOASg1NGtsKMHG3W0r7YAJYNeoXn7DlWlbwuJw8lLdhgpsPtClZXAUZZIARVAAYw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(26005)(8936002)(91956017)(86362001)(66556008)(66476007)(66446008)(66946007)(64756008)(71200400001)(6512007)(6506007)(4744005)(76116006)(2616005)(316002)(110136005)(186003)(38070700005)(2906002)(83380400001)(44832011)(5660300002)(122000001)(36756003)(38100700002)(4326008)(508600001)(8676002)(6486002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?94ZlohZPXXaqb52B7Brzvc9nGnWp7xO3UB7+2lbHf/jbUc417Q3FiSbJe?=
 =?iso-8859-15?Q?HswKXzGxFIBJTTAX6E2QJV8xYyNgzYXy1DCwi8W9JD4T0tDu7q/ncenzP?=
 =?iso-8859-15?Q?AvtxX05yEDkyBbVMK6ZyHyOXyvErHjUuIwrJmARKNATkCdgkIu9fhtSVZ?=
 =?iso-8859-15?Q?Vn6L+tbtR29EJ1GCm0GMVxREAp0brZfXzrZLYlmJwZpRcu2nYXrkeG9K+?=
 =?iso-8859-15?Q?808D5HYkhE24kFYoYERFCa4qyNnRexxCNeFdElnd3TVqGrjCkvLujWixD?=
 =?iso-8859-15?Q?dhUOD8Zmn5l5ejJT6Ki/vPoBwqxigGDg7RJzGtc6sfpTyGtpcQLijlyNB?=
 =?iso-8859-15?Q?qS/eeL4xSKYegLfuzE5Sg3ZyC4gOhfLKCRl4A0IvyWMmAZKQRfuigPE55?=
 =?iso-8859-15?Q?MDJpe1dZNgeDHZxWNWEjPn5q8GmZOJZRKCfyoF4scD/FEhHWbEOsz1m1p?=
 =?iso-8859-15?Q?pHL6LSbXnnlnOWDr3H60VkYXgeCPIsTpYT4hDsX7FZGvLMWXJZBN0QwDq?=
 =?iso-8859-15?Q?sY+ZJ3m7Kp+2MXl6EaCwN1tDaJw9oePBb5XN6zXYqQ/mUoqCQtMwfR5XI?=
 =?iso-8859-15?Q?5sDWMf1FPVEHpOSUpioUatCvr/EA5WxN9ZDF1f+QaDAr7NS9tKBIFa4B8?=
 =?iso-8859-15?Q?sVKyyz466JQg2p6f3Z8Y+uHrAxvGgOLOadyp2rLb/R8nQ+l/NCOWrzJX7?=
 =?iso-8859-15?Q?x5S5ZYoB0Yn0cseeaJF/18rmMVIiovaIAP7c4h6RZ2RRCEupQhIfMGV6+?=
 =?iso-8859-15?Q?uTA62AQIuuc95rWZR4Nre8WFf0crEaqyI9rOEN4mkaggE2RlIeFsSstVz?=
 =?iso-8859-15?Q?QM0yv51nnypiu1FZqrGep+N/FngDOYWF82dBtwLg0yHzJ8++tSIBQmvSz?=
 =?iso-8859-15?Q?xpeOnFUDO37rtBM/EcijTD10WP0d6dFhFUoAiszPm6ELPyX8FgyVqBfCi?=
 =?iso-8859-15?Q?TznQQiKxFd1z/q2HSrMYPgEOt5+WHUTeldceqxf7imrwsPAgsAgUFV2kG?=
 =?iso-8859-15?Q?rLE978YvZ7mdUKL5UqTkRKu58dWgfnAuAW6Z4tXymsLD4py6rqbdMFZk2?=
 =?iso-8859-15?Q?bIwtMmYWi0hsZNis0KOZRuKdB5SgCr3zzCjSsYeQxhaqfnLyWnksgfUdK?=
 =?iso-8859-15?Q?5vgktcnm8WL6qJG9wQoDhJNWFBHq0+klz+ldZbT9CZgq3YAA54aMLPF18?=
 =?iso-8859-15?Q?fMniztuWxPiEPcVJkjXeHpxHFNosCYHdryAwrVm8I9BeT4Zrj909/wTPZ?=
 =?iso-8859-15?Q?0BPtHCPzo7SKOtii1L+DuEQRs0DCv7gwWotg/w6UhHRA3ab0SGli1lzXl?=
 =?iso-8859-15?Q?SbPVrQ3N78pK8U7QI7hcpys1dDAU7gSQb7Egk6EdXFCcKKCPkuNee75Xx?=
 =?iso-8859-15?Q?RkLImoVBL0KQeIseiI2hSSwQ/OOUoDrFyKvyqgHTK1R95d3PN5SQHr+vj?=
 =?iso-8859-15?Q?+JVaByjkswf4QaAdUCWqM+B8BGGF9l/VjDTueU48dKRafSE3EwyZCWxqT?=
 =?iso-8859-15?Q?ZWeCrv3JRVA+wS1wtd5HmdQJc80QWsFWIoBFayvi9YDd210XWJftnNeio?=
 =?iso-8859-15?Q?aYcl81NGq8ejsM/PJRalh2auVa1nrbN0byqsO3AJ848KLBEvllA2e3w46?=
 =?iso-8859-15?Q?HkB823tJbtCjstobbH4HmdnP7oPSDsCe2ZssZA6xmIiGDXZS7BBSTSxaO?=
 =?iso-8859-15?Q?ONC3Hu+69ubajrq73W6KL1RY4jVRrPLT3rT2ECyyTjqcML4qdnCMYOrqg?=
 =?iso-8859-15?Q?Y+Ve0d6oVla9Zti+C+ypzMAW/z9Hl1kgMG5I5ZZkW8YbEPP/DJzjaLjuG?=
 =?iso-8859-15?Q?gev8JMuwgSMj7Iph8leRM/yakiYxgblkAVNgu1L9pZlHMtaIEFus8E6du?=
 =?iso-8859-15?Q?yiEE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d04f78-f836-4cc7-c4c3-08da1300d821
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 10:25:57.2897 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QDShvcl5Z2CXAXhH942XQQdJfLXAuVwcZUCK66XwJOsy/r6lyRAKKKr9k/BmGRsPMyQ/v/IjaYzBzo2aWjFLYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5478
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2] multipath: return failure on an invalid
 remove command
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <35A18EECEAE05345898E7F7AD7CB53E2@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-03-30 at 15:14 -0500, Benjamin Marzinski wrote:
> When "multipath -f" is run on a device that doesn't exist or isn't a
> multipath device, the command will not remove any device, but it will
> still return success.=A0 Multiple functions rely on _dm_flush_map()
> returning success when called with name that doesn't match any
> multipath device. So before calling _dm_flush_map(), call
> dm_is_mpath(),
> to check if the device exists and is a multipath device, and return
> failure if it's not.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

