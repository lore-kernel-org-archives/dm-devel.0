Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017361549B
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 06:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KYoNM8AY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698216224;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Rr5gzBivXWqOwgYgSBSgZ9Vw04ZmNk/yARVnWzBY1LE=;
	b=KYoNM8AYCoJKcceWvJad5LFsSB2PA9ZJMNMmxnGoCaCSpZjQkuqNt1ObawNL42qqrdVJ6a
	pfWMmCGBy/9/lCUloPMEdGdTE5b2MAhedBSHgbqNRUZ9MAcnDov22iwam9HEbV+qMXWArg
	DZYG9Nt+cCjZ/G33z0/COChHCTGsGV4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-9IGSV2QQPfKrZPj0jza6bA-1; Wed, 25 Oct 2023 02:43:33 -0400
X-MC-Unique: 9IGSV2QQPfKrZPj0jza6bA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D938185A785
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 06:43:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7383740C6F79
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 06:43:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0537F19465A0
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 06:43:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C698A1946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 25 Oct 2023 05:24:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B3EEE2166B27; Wed, 25 Oct 2023 05:24:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AB7AE2166B26
 for <dm-devel@redhat.com>; Wed, 25 Oct 2023 05:24:10 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8144C88CC46
 for <dm-devel@redhat.com>; Wed, 25 Oct 2023 05:24:10 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-7-QUTFIOQdPqe4h1VfvfRf-w-1; Wed, 25 Oct 2023 01:24:01 -0400
X-MC-Unique: QUTFIOQdPqe4h1VfvfRf-w-1
X-CSE-ConnectionGUID: ZcMXhr28SZ+CqOiv41H4+Q==
X-CSE-MsgGUID: gezDhtTGR8qj1Xw36E166g==
X-IronPort-AV: E=Sophos;i="6.03,249,1694707200"; 
   d="scan'208";a="594797"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO
 NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
 by ob1.hgst.iphmx.com with ESMTP; 25 Oct 2023 13:22:56 +0800
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com (2603:10b6:a03:300::11)
 by SJ0PR04MB7744.namprd04.prod.outlook.com (2603:10b6:a03:32e::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 05:22:54 +0000
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com
 ([fe80::9511:64b5:654e:7a8a]) by SJ0PR04MB7776.namprd04.prod.outlook.com
 ([fe80::9511:64b5:654e:7a8a%4]) with mapi id 15.20.6933.019; Wed, 25 Oct 2023
 05:22:54 +0000
From: Naohiro Aota <Naohiro.Aota@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] dm: error: Add support for zoned block devices
Thread-Topic: [PATCH] dm: error: Add support for zoned block devices
Thread-Index: AQHaBgKcGh2JZw05Xkaaw3gCOyIHMLBZ+paA
Date: Wed, 25 Oct 2023 05:22:53 +0000
Message-ID: <fuyglwmrwyvrx6w3vwi2zlkpxqc5mafnf5cehill5vovnwfhmh@ddzacow35ki5>
References: <20231023224513.344380-1-dlemoal@kernel.org>
In-Reply-To: <20231023224513.344380-1-dlemoal@kernel.org>
Accept-Language: ja-JP, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR04MB7776:EE_|SJ0PR04MB7744:EE_
x-ms-office365-filtering-correlation-id: 92456322-3c50-4f81-3849-08dbd51a70b6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ymTy+PaM48J+aEhdbQwBK+vUH4eSHkYgMJZnW6QX1kMiBAi1vOwDe13sopED8QvxL3pIsMyffIcd8p2M0qwbakfDXibrKYo2eQfFEGwjxzW5NuKsZG5HugG8qYIYuAmj1sUcs3gTchKnqUq2NrwF3LpghI1qt0J71i8JxqNHVaq91xVg1AJubxd4OHUJS1TEySFk5jcRZ8zEt459cz656lVGWk3BlcFEkZbt2WTGG1sHLirarxqszgYMBrq5yVjmrQW8UBvXdS87/1/Wc1WrR09dcwSpJpy0jABnZYUApuykWUxFCjbAHPUl6G8YaitZWb8NNa44qAnq8SGf+NhHr5/SGvq3BPg+qkw87/4WNvfKSjyQ4T8cxPVFWiL2QO7WOtR8hyDHDXJNMvQYS4QHW9XZitKDMXZ4v+WQRBtFyH1cNIrKecv5TovZCwvmlE/QUTpBeI2GCmgNF8BNhH4wHvk4KFCUP49oLMnYF/p3Y7ZULVcps4VPQkfsSNbQ90+IgyfSvWEmFbQERfxDYOrp3QiVTJ8i+boBlJaIUIpew2DsEEVgtXV7T5hp6dFSZGeG0J22jN2Mcgz5THcguuUtrlfI4OibCZ6GlMopVMrOwYFDyaNm3IJ++4bLEvQE57RG
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR04MB7776.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(7916004)(366004)(39860400002)(396003)(376002)(346002)(136003)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(54906003)(2906002)(66556008)(64756008)(66946007)(38100700002)(66476007)(91956017)(122000001)(71200400001)(6916009)(6506007)(478600001)(316002)(6486002)(9686003)(6512007)(82960400001)(66446008)(83380400001)(41300700001)(5660300002)(86362001)(4326008)(8676002)(8936002)(76116006)(38070700009)(26005)(33716001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fz1xpx+UcGak+EYmy3jrJ3fZYA7937ALI0fPLG1UelGeEL18nqRcY6Cah26p?=
 =?us-ascii?Q?5XaesT4OpJJ2DE94wBCIayKyXI+dhYE/26FP+psWx8bwKsV5jOHa0Vkyy/lH?=
 =?us-ascii?Q?zOe2D0kp15aG5u22eySgzEQVjb4rcyhR6d2RqzbDLwQW9vbDU8OcPiik1sDu?=
 =?us-ascii?Q?nwxmOZh0OFN9d4lCihwO3z3F4q4fny7usiz+OMAKq/OorO8+/OZSs2GL58BR?=
 =?us-ascii?Q?ZJeEJbTUFKaNmf/eQdu2bXb4JyBrTQgPu457AAdQcoI5qt7tNT9IzB1P3f0H?=
 =?us-ascii?Q?QxAQvAHrgk/rySfsbbAYbUiyMG+Wu6qf6eYFJwkTrK9v4K0twg+88773fdz/?=
 =?us-ascii?Q?AqP6HXHVkywA5udtffodi4/QE/p8SywgwDZq80sui8UzogZs8Ekt2lrFtUZ2?=
 =?us-ascii?Q?GH6MHLevIcC21j2rPSzlW18+4UVJ27ZoYHmTTAf1m7J0NOB2+2wMZ8ly5QaN?=
 =?us-ascii?Q?azen0BbordAbSqH9L3QEuPAt7cGe+8+jfmJ4BmC41a+C1x7ez/6ghPej+5vi?=
 =?us-ascii?Q?mt8UAbsGQtRvyTJVEitPbyKkxBgsH5L04tp3i149sJvF7bsa4sbsR2bCoKUo?=
 =?us-ascii?Q?A3tl9LxsDYHpSnWZU2CkXYVAKVbg9ST+1bcUGvR8r5bdViXNuwQZbGOlv5ml?=
 =?us-ascii?Q?sQIfpjWlR7wksDPMe24snPRDR26pPceJBp2bgg87Y14n6IST5T5SQwudtAfo?=
 =?us-ascii?Q?ZJVFcFWv9jjZoy7JJYzjLBpURkvMRXIKcfURCehunI3Sf03UC+J+cLAa1/fr?=
 =?us-ascii?Q?xtCl7wCmr4UahNxxljMPOuhzsvvMeo2zay74RSY3lulloTNyLFs86ThO9emS?=
 =?us-ascii?Q?n7UzFUXkvk9DnOGHm642OQAPFunAC0vTKCzIXuPUoREQWs85a9axIPSvVIRO?=
 =?us-ascii?Q?7tFyPYeWIJCWUYKuk1gdnHeW1fWJXJXzaBhUrAG72AGNlabUjQpTttL9aa2E?=
 =?us-ascii?Q?CYCI1xPe2nsMe0J3RkQ3dKBI4NxZwqeyBrIHYgm6SkhJF6iCE6hvurojdocY?=
 =?us-ascii?Q?tRykNDQQ25mB95/FEyR3Ld60r/LCKGe3juUSvu9rxaJpCf+4j89vhfvJcEiB?=
 =?us-ascii?Q?OqFqJOE+sh6UgL/Pb/K1Tav1NEC35RzycAeAcfV46IZQfFkLiqqYQPuIKw0p?=
 =?us-ascii?Q?kxFNtEXtBWZpypGppL5arj6O+j8k5/Gavi6sP/NuA5VLsgP9lM/njdaZYyiJ?=
 =?us-ascii?Q?5lJLrOjbVOlJjDy6vIfF3gVmnwcymVXV8exWAKa3yJuboSL+rKU0UMt+U+Fj?=
 =?us-ascii?Q?TLgoTwXd2XB2IE6Oq84ctCWqvLiqF9rCxuxRcUt9UrIcKEeV4RcN8qpo04Tu?=
 =?us-ascii?Q?Py1sRnNwt5l6T5iT0omKl9ripP52J0WTqXtrPhL7F/+jkaJLkCjKLLXJ1L3p?=
 =?us-ascii?Q?H2tWyAKIKyS51zCPqvUWh8yq7i8RuIMFEdAS5XqEaVWP30SiBHJQV7ZUTR/l?=
 =?us-ascii?Q?l7K4Rek8rzlvEXqOEbkGyq+CvaQ5/EkPXo0G6qqgfQodn7iDIMFdtDYl9PYg?=
 =?us-ascii?Q?CgVQpaJh6CuyDsXihBcanDlmVrcSoaNoC9gX6xa6VAt4o7rmEeUMaaAHoWux?=
 =?us-ascii?Q?tX6LGvfy7nXqLgj4UhRQjpRVC7s6Lo7mZbGGJyx1sG5Gut2f12qjirHezyTi?=
 =?us-ascii?Q?wQ=3D=3D?=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gf13tHNh0PKsEnbsF36/gvt59xCbYlwQokZdtA37Gw+pkteWXc3OGJtQtmifoNPrkjF4C3EDDZfzmQWLi6yARoc+DK8W1yXiK7/CJv5CsPGvIfsr11s9iPRprUo3YeTDar1hqaEBBc768+ddlNcN1wMJ4PPDTBcEz9FMPIfFJTKSmX/fmaoU+CRRzxoBAM7H4MQyCh9S5GDf15JQKDuYXA1bHsRVmt/WzAakQQ96DRfbCYhlkLlfskA+eYl32NAeM8nQ5L+BMOwEgXbmhCMurIVrkiWZaFQETtg32Ep8uceFhoN9Q9vcaAvHiWekYbjZE7rDuB7n2vdaUvz+ki0GEf12OpoiiFKAK9FYuVgKQ47jnZURCk9uKAiXLRygg8v9kEHJk7jmCj7/M4r+Eno1Qw8iGHvoRz7AB4AmvYwQMbx3y3UHgc8dg72Sbk4nB1LW3dMerRfKmXxyTKSgftdwc9QvocXogFXFU2c6yTQ+f+RRjj862I+FIABWeC1xui7KUJtgtVTypwiX3Wa7OXmgiT8Xsu3dF0d8Ta5z7nFXOf+ftvfTZlu9ZIyE+Bqf8/+aqsf16niWS6RcD7Bu8T9S/jZSsHHtRcnBZb5bzouJrnSfJvXyZWF733yMEdelifd3vpdFFTsj/Y2H1NWIuNbgDCYtknA+6puaZRyQRXVmLLqJ7CgELLGKvbjfDKHsnIKOxRF4FyjRGG0re50kZvZ/tH3EYlB9tvbIWeIQt6qD7kuODQJBWYZma1ykjogNyV7qk8N/L1stPa8yjdAka1221LNYLmWSG1T7CMSoJzoRTv78Z/PhpBvorGh1FZEuVMV0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7776.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92456322-3c50-4f81-3849-08dbd51a70b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 05:22:53.9404 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sxjuo/7/Q5ZWxRPWwTNOgG9hwxLRMbE4ssJ2u/CZ1V/50M6VRl1DryVq9z3F6VpUyhDGW5pjbUUwHikMtex4zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7744
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mailman-Approved-At: Wed, 25 Oct 2023 06:43:31 +0000
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
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9ECCC9759010374D946C9B910744EE04@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2023 at 07:45:13AM +0900, Damien Le Moal wrote:
> dm-error is used in several test cases in the xfstests test suite to
> check the handling of IO errors in file syatems. However, with several
                                          ^ systems

> file systems getting native support for zoned block devices (e.g. btrfs
> and f2fs), dm-error lack of zoned block device support creates problems
> as the file system attempt executing zone commands (e.g. a zone append
> operation) against a dm-error non-zoned block device, which causes
> various issues in the block layer (e.g. WARN_ON triggers).
>=20
> This patch adds supports for zoned block devices to dm-error, allowing
> an error table to be exposed as a zoned block device. This is done by
> relying on the first argument passed to dmsetup when creating the device
> table: if that first argument is a path to a backing block device, the
> dm-error device is created by copying the limits of the backing device,
> thus also copying its zone model. This is consistent with how xfstests
> creates dm-error devices (always passing the path to the backing device
> as the first argument).
>=20
> The zone support for dm-error requires the definition of the
> report_zones target type method, which is done by introducing the
> function io_err_report_zones(). Given that this function fails report
> zones operations (similarly to any other command issued to the dm-error
> device), dm_set_zones_restrictions() is tweaked to do nothing for a
> wildcard target to avoid failing zone revalidation. As the dm-error
> target does not implemt the iterate_devices method,
                  ^implement

> dm_table_supports_zoned_model() is also changed to return true.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/md/dm-table.c  |  3 +++
>  drivers/md/dm-target.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>  drivers/md/dm-zone.c   |  9 +++++++++
>  3 files changed, 52 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 37b48f63ae6a..5e4d887063d3 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1600,6 +1600,9 @@ static bool dm_table_supports_zoned_model(struct dm=
_table *t,
>  =09for (unsigned int i =3D 0; i < t->num_targets; i++) {
>  =09=09struct dm_target *ti =3D dm_table_get_target(t, i);
> =20
> +=09=09if (dm_target_is_wildcard(ti->type))
> +=09=09=09continue;
> +

This seems tricky to me. Currently, dm-error is the only dm target having
DM_TARGET_WILDCARD. But, can we expect that will be so forever?

Also, I considered what happens if the backing device is non-zoned
one. dm_table_supports_zoned_model() returns true in that case. But, it is
still reported as non-zoned as we copy non-zoned queue limits. So, it is
OK ... but it is a bit tricky.

Instead, how about implementing the .iterate_devices just like
linear_iterate_devices?

>  =09=09if (dm_target_supports_zoned_hm(ti->type)) {
>  =09=09=09if (!ti->type->iterate_devices ||
>  =09=09=09    ti->type->iterate_devices(ti, device_not_zoned_model,
> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
> index 27e2992ff249..1bf4ecda3012 100644
> --- a/drivers/md/dm-target.c
> +++ b/drivers/md/dm-target.c
> @@ -118,6 +118,21 @@ EXPORT_SYMBOL(dm_unregister_target);
>   */
>  static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **ar=
gs)
>  {
> +=09struct dm_dev *ddev;
> +=09int ret;
> +
> +=09/*
> +=09 * If we have an argument, assume it is the path to the target
> +=09 * block device we are replacing. In this case, get the device
> +=09 * so that we can copy its limits in io_err_io_hints().
> +=09 */
> +=09if (argc) {
> +=09=09ret =3D dm_get_device(tt, args[0], dm_table_get_mode(tt->table),
> +=09=09=09=09    &ddev);
> +=09=09if (ret =3D=3D 0)
> +=09=09=09tt->private =3D ddev;

No need to handle an error case here? Or, I guess it ignores an error for
compatibility when non-device argument is specified. Then, I'd like to add
a note here.

> +=09}
> +
>  =09/*
>  =09 * Return error for discards instead of -EOPNOTSUPP
>  =09 */
> @@ -129,7 +144,10 @@ static int io_err_ctr(struct dm_target *tt, unsigned=
 int argc, char **args)
> =20
>  static void io_err_dtr(struct dm_target *tt)
>  {
> -=09/* empty */
> +=09struct dm_dev *ddev =3D tt->private;
> +
> +=09if (ddev)
> +=09=09dm_put_device(tt, ddev);
>  }
> =20
>  static int io_err_map(struct dm_target *tt, struct bio *bio)
> @@ -149,8 +167,27 @@ static void io_err_release_clone_rq(struct request *=
clone,
>  {
>  }
> =20
> +#ifdef CONFIG_BLK_DEV_ZONED
> +static int io_err_report_zones(struct dm_target *ti,
> +=09=09struct dm_report_zones_args *args, unsigned int nr_zones)
> +{
> +=09return -EIO;
> +}
> +#else
> +#define io_err_report_zones NULL
> +#endif
> +
>  static void io_err_io_hints(struct dm_target *ti, struct queue_limits *l=
imits)
>  {
> +=09struct dm_dev *ddev =3D ti->private;
> +
> +=09/* If we have a target device, copy its limits */
> +=09if (ddev) {
> +=09=09struct request_queue *q =3D bdev_get_queue(ddev->bdev);
> +
> +=09=09memcpy(limits, &q->limits, sizeof(*limits));
> +=09}
> +
>  =09limits->max_discard_sectors =3D UINT_MAX;
>  =09limits->max_hw_discard_sectors =3D UINT_MAX;
>  =09limits->discard_granularity =3D 512;
> @@ -166,7 +203,7 @@ static long io_err_dax_direct_access(struct dm_target=
 *ti, pgoff_t pgoff,
>  static struct target_type error_target =3D {
>  =09.name =3D "error",
>  =09.version =3D {1, 6, 0},
> -=09.features =3D DM_TARGET_WILDCARD,
> +=09.features =3D DM_TARGET_WILDCARD | DM_TARGET_ZONED_HM,
>  =09.ctr  =3D io_err_ctr,
>  =09.dtr  =3D io_err_dtr,
>  =09.map  =3D io_err_map,
> @@ -174,6 +211,7 @@ static struct target_type error_target =3D {
>  =09.release_clone_rq =3D io_err_release_clone_rq,
>  =09.io_hints =3D io_err_io_hints,
>  =09.direct_access =3D io_err_dax_direct_access,
> +=09.report_zones =3D io_err_report_zones,
>  };
> =20
>  int __init dm_target_init(void)
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index eb9832b22b14..9b77ee05e8dd 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -297,6 +297,15 @@ int dm_set_zones_restrictions(struct dm_table *t, st=
ruct request_queue *q)
>  =09WARN_ON_ONCE(queue_is_mq(q));
>  =09md->disk->nr_zones =3D bdev_nr_zones(md->disk->part0);
> =20
> +=09/*
> +=09 * With dm-error (wildcard target), report zones will fail, so do
> +=09 * nothing. dm-error will copy the zones limits itself.
> +=09 */
> +=09if (dm_table_get_wildcard_target(t)) {
> +=09=09md->nr_zones =3D md->disk->nr_zones;
> +=09=09return 0;
> +=09}
> +
>  =09/* Check if zone append is natively supported */
>  =09if (dm_table_supports_zone_append(t)) {
>  =09=09clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
> --=20
> 2.41.0
>=20

