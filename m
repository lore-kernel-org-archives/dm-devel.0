Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B95C28D13
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 16:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661184917;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=o6raqNtNqs9jZ7bNjhggUodfmLRJIVfhkIcC+iDeBeY=;
	b=hcO9k2+NV2rG6zpbQqrbydLgg6B6IitFdNfViUFbuIs0zKNlIMpwn/6V/Euz9KBpfILwoa
	ntwNuJ2vGQVvb8HvxC1CV3aGSDNS4wwoVsuVPAH9+L4mf4Ml2j4Ots0AbsAUnPGLH+nojF
	zvQWm9jCKiXVbq//puwqcTnffnkuXfE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-rXeYgArPM_erLEYKuABZDg-1; Mon, 22 Aug 2022 12:15:14 -0400
X-MC-Unique: rXeYgArPM_erLEYKuABZDg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19BEC3804527;
	Mon, 22 Aug 2022 16:15:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C6BA5492CA5;
	Mon, 22 Aug 2022 16:15:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8090F1946A52;
	Mon, 22 Aug 2022 16:15:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 021A61946A47
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 16:15:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DF1431415125; Mon, 22 Aug 2022 16:15:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA4D41410DD9
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 16:15:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD41E3804523
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 16:15:07 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-mBwXabysPPC40VL0lDk5Gg-1; Mon, 22 Aug 2022 12:15:03 -0400
X-MC-Unique: mBwXabysPPC40VL0lDk5Gg-1
Received: from AM8PR04MB8036.eurprd04.prod.outlook.com (2603:10a6:20b:242::13)
 by PAXPR04MB8142.eurprd04.prod.outlook.com (2603:10a6:102:1ce::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 16:15:01 +0000
Received: from AM8PR04MB8036.eurprd04.prod.outlook.com
 ([fe80::650e:243b:14d5:4593]) by AM8PR04MB8036.eurprd04.prod.outlook.com
 ([fe80::650e:243b:14d5:4593%9]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 16:15:01 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 3/6] multipathd: Occasionally allow waiters to
 interrupt checking paths
Thread-Index: AQHYsnrAH+iw4oeHCUC/1VJhQ3qQRq27H7IA
Date: Mon, 22 Aug 2022 16:15:01 +0000
Message-ID: <e0f0516a08bf8fe5dddf058e5b9c9fad494340ba.camel@suse.com>
References: <1660769316-5302-1-git-send-email-bmarzins@redhat.com>
 <1660769316-5302-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1660769316-5302-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e16d3540-2b64-4590-3179-08da8459772b
x-ms-traffictypediagnostic: PAXPR04MB8142:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 1zlUKmLroauWf9PBWHWeJZ9AwDQc3EdIlJ8xu9hHMu1w34+FLf39Kk1TCr5ubM+82KVL5N6a/uhRu6qy9/xxSGemXXbwh5ujXKsInbXx9ZBKFj5uoGjsyjO+E5thtOkzHeTg2N0Z2GW28eyvkVgj2T36jEjWogmiLFjw0s2tIkY7Dl00elwsTrf8EjYvY/anMjLHtzVVUBlVt7LM9/hxeJoy3MdSBXeYn+5NFuJ5HWmYdKAsd9DYZ0AkPu9SsZtVV3LYkLOhuPJ1ajL9NzjLJ7GKQ+Mm4Z1EURMnxrPHeVN4B+cZiMt7+HuPkByfS4BDdA3FqaBhAZWIoK4FAZgD3fSPuMN4Zgykk6xVoZkNicqyWCsZ42R0V07Lldsh7u1NDee3rFX2O2W+EWKfdZcYO8Uyty0IroXpaIcgx72fmhUN3uLG/zswHWPuK77IpYPHNLaulwxIoRaxdfoOSBe2JAjvJOTswfQY8TIEIUVAw04jy0F1ZyY/xuBYIjz4/S7nWo6pYw0AbpZ+UTokbs8eA4eH+RVGBPgc/rH/TM3DogxuCZArK8qOg2/EDY7VatBtBiG7o3/gcQN/0Zg4ZocUv2l7a6e066zHksqeClKv6kW6NhsWC8wFgjtAecJl5FRghKhuN5z+DNSuMH5ymB2xg5OQJt8ox3KKzK45iF3VgYAmflJAXNfuiRLyyb7LRnyHV2Ajji7Y7bq/6/otjPcLaOQGbTSpLJ0Jg1ejCMZej7ynCzjHPVroSDb0UvZ6HxrXAxcSdeAlXWVL0NAh6CETRA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AM8PR04MB8036.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(366004)(376002)(346002)(136003)(396003)(39860400002)(4326008)(66476007)(8676002)(41300700001)(316002)(110136005)(66556008)(66446008)(54906003)(91956017)(76116006)(66946007)(8936002)(2906002)(44832011)(5660300002)(38100700002)(64756008)(86362001)(36756003)(38070700005)(122000001)(6506007)(71200400001)(6486002)(186003)(478600001)(26005)(6512007)(83380400001)(2616005);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?hYjkZ4ubBFHxeoqP0gTyE010Wm/aXq6F2j1bW1ktRo6blJXdLeLTH1S9h?=
 =?iso-8859-15?Q?5IxEmms0wTdWCbXOzw0o75eU1HWMA5Z+dmDo6jMaDkiMEHscZerxm6Y1O?=
 =?iso-8859-15?Q?KEELlUa+U4u34WMngBOYBPEHFjebCY71x5Fx/5QEpQJ6iJFZEuYKUEWTv?=
 =?iso-8859-15?Q?m7Te0lvxQf6/oTm4Or4pUmkFkYImU/8yLPClY4JFZ2F9tPJADjQb1L4x5?=
 =?iso-8859-15?Q?R9vMg+wM2GJ97FiaIPj4D5gwUQ0OhY3IpcvfRns4IwlAlG6EbjKOSDKoo?=
 =?iso-8859-15?Q?yvCvyGarvd5kvBGYE1yc69ULpqb/fpcDY1mq/XbxcmRwvq4985eOwMH4X?=
 =?iso-8859-15?Q?x46bdor1KdteWwSbYVPce6GaOKT/4f6YuS0igzJKqdnGvavwiLUG3QYha?=
 =?iso-8859-15?Q?gAINOmcL7zc6xgWX2rd/NPSzOuxDGZCbB5lALYfseAdBCIJ3VngNR9Bed?=
 =?iso-8859-15?Q?3OxrYiBjQXiRenMWMXT9OpA/uKnnsYnMDhstNPcV2MB17sa5Es/S3C8nY?=
 =?iso-8859-15?Q?z1w4MYDJlKRAgdwY4zEzMLZQWcYizGaxfbtdrOy5GhrqAOTQIBChlz+I2?=
 =?iso-8859-15?Q?qFx9NxWSqSzakQx4Qy9QDD9tdFkNIR2RXubGKwx4ekfZGiLcIBnAlmMT5?=
 =?iso-8859-15?Q?3QmPIxt7fp/KDnnEpN582VhX5vJZLevKCUINBrb1A3tkbJEqAKBwcX9+a?=
 =?iso-8859-15?Q?5kqkzDE+4fMQXs42c3qqEBcPXxdjqiK0S3NZiqpl3sRfHQHwIUu5//raW?=
 =?iso-8859-15?Q?JNnQfHT+RVmWuNmBr4jrl06Zhko5sjmJbplmnclTm48FwQW9K2gf+76wR?=
 =?iso-8859-15?Q?RA38DhyiENKLUdhZijSAsRF9yMw+66ref1guNPlg3Yu2LOK3XMa9T18Pc?=
 =?iso-8859-15?Q?TRHMls6YQ9Id6ovLiieIbE775ZRxkc3LBjmm61R7TesTnQ1yEkRsuB2uk?=
 =?iso-8859-15?Q?RFJjBs/VNLJsSFGwOMhaQC13k3UNYYYF6mzUN7uau5owepplLj7FnRz05?=
 =?iso-8859-15?Q?z+8CtPdCRwmjus9CHH43tNR0UNyBVOgPPIpzfX5eNCJGZds3mYAUJMKj8?=
 =?iso-8859-15?Q?3OkZskZRIMi9l4eyRyH11SfOW1+9BE6q5QDAjKZDMUEEAqV5yaccoDRl/?=
 =?iso-8859-15?Q?zoh5oUYhZaq6v65GTiJm1KzHWBqQBesgOJ1ocOzU+DwKcy9q9aqu9tit4?=
 =?iso-8859-15?Q?M761ZOkBTXxvc5P/HD+XoA4BCOL67fMLtY1UjTmUdKKfX+bR7vHGCy7uE?=
 =?iso-8859-15?Q?nSQ00KZp60f1IraKuefzNPep2agwHuVPggw43BPHHjq/5+Ezal7RXQL5R?=
 =?iso-8859-15?Q?Cg6uMyQEZfV2AH++U7c4yvBNnPuHx1WdEHaNKv87b1raV0psvcSuxWuQB?=
 =?iso-8859-15?Q?syfgapQEvsjYo0K8my7zvE9zHOIKiMcFTa3rQZGACRG7SbKf6386JEBR1?=
 =?iso-8859-15?Q?DofM/xC9ewJaD0Nvyb4NNhrMzv+lgHCmMYyelmeYeIfX3NMf4EmO0jfud?=
 =?iso-8859-15?Q?saC8JpA29Qv5NJ1aQ1+e9cPWeMB6Gou0wF5iv8ysVCoMZ+lNbLfDFYj51?=
 =?iso-8859-15?Q?awwHCe7U47/jdaB/RUOH5ztNNiV6180qL1up9ukrf33TNGMI1/Q+3Varb?=
 =?iso-8859-15?Q?KGxeEi8Wi5JYPc/a4O1KKzz8h0NIR/ljFeL7kJf5P28t+h4e1Bavj8Wxz?=
 =?iso-8859-15?Q?Dk2BMITqaDqM+NGc6PBB1tWzMw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB8036.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16d3540-2b64-4590-3179-08da8459772b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 16:15:01.2465 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JGiJhh2NyDLLjtNYZupHhQv2C2877HGgwSPKfH4MQZc2CoKbxyI14a2SRQzM6nfftd7vMFXNNlQsnNb5ll/sog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8142
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH V2 3/6] multipathd: Occasionally allow
 waiters to interrupt checking paths
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
Cc: "wuguanghao3@huawei.com" <wuguanghao3@huawei.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D0BEE67AF0E55B4EAADC9AE07F765774@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-08-17 at 15:48 -0500, Benjamin Marzinski wrote:
> If there are a very large number of paths that all get checked at the
> same time, it is possible for the path checkers to starve out other
> vecs->lock users, like uevent processing. To avoid this, if the path
> checkers are taking a long time, checkerloop now occasionally unlocks
> and allows other vecs->lock waiters to run.
>=20
> In order to make sure that path checking is always making real
> progress,
> checkerloop() only checks if it should unlock every 128 path checks.
> To
> check, it sees if there are waiters and more than a second has passed
> since it acquired the vecs->lock. If both of these are true, it drops
> the lock and calls nanosleep() to schedule.
>=20
> When checkerloop() reacquires the lock, it may no longer be at the
> correct place in the vector. While paths can be deleted from any
> point
> of the pathvec, they can only be added at the end. This means that
> the
> next path to check must be between its previous location and the
> start
> of the vector. To help determine the correct starting place,
> checkerloop() marks each path as not checked at the start of each
> checker loop. New paths start in the unchecked state. As paths are
> checked, they are marked as such. If the checker loop is interrupted,
> when it reacquires the lock, it will iterate backwards from the last
> location in checked to the start of the vector. The first path it
> finds
> that is marked as checked must be the last path it checked.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/structs.h |=A0 1 +
> =A0multipathd/main.c=A0=A0=A0=A0=A0 | 82 ++++++++++++++++++++++++++++++++=
+-------
> --
> =A02 files changed, 67 insertions(+), 16 deletions(-)
>=20
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index a6a09441..9d4fb9c8 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -351,6 +351,7 @@ struct path {
> =A0=A0=A0=A0=A0=A0=A0=A0int fast_io_fail;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int dev_loss;
> =A0=A0=A0=A0=A0=A0=A0=A0int eh_deadline;
> +=A0=A0=A0=A0=A0=A0=A0bool is_checked;
> =A0=A0=A0=A0=A0=A0=A0=A0/* configlet pointers */
> =A0=A0=A0=A0=A0=A0=A0=A0vector hwe;
> =A0=A0=A0=A0=A0=A0=A0=A0struct gen_path generic_path;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 71079113..37c04018 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2548,6 +2548,11 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0}
> +enum checker_state {
> +=A0=A0=A0=A0=A0=A0=A0CHECKER_STARTING,
> +=A0=A0=A0=A0=A0=A0=A0CHECKER_RUNNING,
> +=A0=A0=A0=A0=A0=A0=A0CHECKER_FINISHED,
> +};
> =A0
> =A0static void *
> =A0checkerloop (void *ap)
> @@ -2555,7 +2560,6 @@ checkerloop (void *ap)
> =A0=A0=A0=A0=A0=A0=A0=A0struct vectors *vecs;
> =A0=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> =A0=A0=A0=A0=A0=A0=A0=A0int count =3D 0;
> -=A0=A0=A0=A0=A0=A0=A0unsigned int i;
> =A0=A0=A0=A0=A0=A0=A0=A0struct timespec last_time;
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> =A0=A0=A0=A0=A0=A0=A0=A0int foreign_tick =3D 0;
> @@ -2581,8 +2585,9 @@ checkerloop (void *ap)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0while (1) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct timespec diff_time=
, start_time, end_time;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int num_paths =3D 0, strict=
_timing, rc =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int num_paths =3D 0, strict=
_timing, rc =3D 0, i =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unsigned int ticks =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0enum checker_state checker_=
state =3D CHECKER_STARTING;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (set_config_state(DAEM=
ON_RUNNING) !=3D
> DAEMON_RUNNING)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
* daemon shutdown */
> @@ -2603,22 +2608,67 @@ checkerloop (void *ap)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (use_watchdog)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
d_notify(0, "WATCHDOG=3D1");
> =A0#endif
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while (checker_state !=3D C=
HECKER_FINISHED) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uns=
igned int paths_checked =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0str=
uct timespec chk_start_time;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanu=
p_lock, &vecs->lock);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (vecs->=
pathvec, pp, i) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rc =
=3D check_path(vecs, pp, ticks);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(rc < 0) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s: check_path() failed,
> removing",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dev);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0vector_del_slot(vecs->pathvec, i);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0free_path(pp);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0i--;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} e=
lse
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0num_paths +=3D rc;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pth=
read_cleanup_push(cleanup_lock, &vecs-
> >lock);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0loc=
k(&vecs->lock);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pth=
read_testcancel();
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0get=
_monotonic_time(&chk_start_time);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(checker_state =3D=3D CHECKER_STARTING) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(vecs->pathvec,
> pp, i)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->is_checked =3D false;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0i =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0checker_state =3D CHECKER_RUNNING;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} e=
lse {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * Paths could have been removed
> since we
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * dropped the lock. Find the path to
> continue
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * checking at. Since paths can be
> removed from
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * anywhere in the vector, but can
> only be added
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * at the end, the last checked path
> must be
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * between its old location, and the
> start or
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * the vector.
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (i >=3D VECTOR_SIZE(vecs->pathvec))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i =3D VECTOR_SIZE(vecs-
> >pathvec) - 1;

What if VECTOR_SIZE(vecs->pathvec) =3D=3D 0? Maybe you should catch that in
the while () condition above?

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

