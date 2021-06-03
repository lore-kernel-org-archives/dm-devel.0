Return-Path: <SRS0=6AeK=K5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2BEC47096
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 23:44:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B31C0613E7
	for <dm-devel@archiver.kernel.org>; Thu,  3 Jun 2021 23:44:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B31C0613E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-5Vuo8vAmNYiOB_fxYi78vg-1; Thu, 03 Jun 2021 19:44:28 -0400
X-MC-Unique: 5Vuo8vAmNYiOB_fxYi78vg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDD4C80ED8E;
	Thu,  3 Jun 2021 23:44:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 358B42C14A;
	Thu,  3 Jun 2021 23:44:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4CA381800FFC;
	Thu,  3 Jun 2021 23:44:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 153NiH00019469 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Jun 2021 19:44:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 861071054EA3; Thu,  3 Jun 2021 23:44:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8118D1054F86
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 23:44:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F68B800B29
	for <dm-devel@redhat.com>; Thu,  3 Jun 2021 23:44:15 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-276-mT8ocbvsNAOgmfCnRe8qQA-1; Thu, 03 Jun 2021 19:44:11 -0400
X-MC-Unique: mT8ocbvsNAOgmfCnRe8qQA-1
IronPort-SDR: B48ETwZcstXe6yd6saTBZwl3dWTg8pTmXvjIMEkWpu5Y5AqbHiJmXqzQt/0lOEoTVaL5m9cDbh
	psKY6ICZvK5FYIGaa1KSIRvG3pvr4qbfeJ/n7S99664D75CFmC2R5+1OVxyFACUYc62GFO13c5
	KbcSRtu8RuazbdSddaUv/sJkLjO5tsaQgHnykAQX21XQMLQ9FcM/1V3BqNyhVVFizpiDsQIw3+
	rzUpmlD4QRAEaRPeikL5gisL1vupsECHEb16uy+ZfM7PQp5/EZLcYPC6UUyqh0WseTknYu9leh
	rzk=
X-IronPort-AV: E=Sophos;i="5.83,246,1616428800"; d="scan'208";a="169944091"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
	by ob1.hgst.iphmx.com with ESMTP; 04 Jun 2021 07:44:09 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB5882.namprd04.prod.outlook.com (2603:10b6:5:16a::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20;
	Thu, 3 Jun 2021 23:44:07 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4173.035;
	Thu, 3 Jun 2021 23:44:07 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH v5 00/11] dm: Improve zoned block device support
Thread-Index: AQHXUaxyAuyK4c4Z+0yqEP2QqnaCJA==
Date: Thu, 3 Jun 2021 23:44:07 +0000
Message-ID: <DM6PR04MB708128C3992978EFFF638851E73C9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
	<DM6PR04MB708146E418BF65FC2F7847E3E73E9@DM6PR04MB7081.namprd04.prod.outlook.com>
	<YLfO168QXfAWJ9dn@redhat.com>
	<a972018e-781b-c0f8-d18a-168c3d1fe963@kernel.dk>
	<YLlUzX18P0V2lAek@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:f9bc:fd30:41b8:96f2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3d4ab50-db1d-46d8-5884-08d926e97a6e
x-ms-traffictypediagnostic: DM6PR04MB5882:
x-microsoft-antispam-prvs: <DM6PR04MB58826E013CC7ABFA2452E15BE73C9@DM6PR04MB5882.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: uzyqrwzTeyGQFy6FuT2kvWpezCP8gSsZ67xVmCCgDrs1NHpTfilgkCQ/yTBlDDzYQsjxB29V/1Nc0Xh238L0siV739pq8IjYBp1UAlVwZZm0bmW1aGADOzWg15VopzWrab9x+nKW5dcOuDMSX7PubkcalDCjeM29ALLIHVtvtbwN1SQ059bkXDNlFybiid6//1QPrfIyvxL5p/DJJyB5+Wecu9shaTfErbkHRlMrOQv4OUofMRN48BoPtksL/xTiroKXAdp5jL/5vvNhGKd527/HADD80gQ5Ca3eEjfqjoXhICEFb2DuuQC+z2NerGGxERSBlQN6JXfab+1b/jH9cTmEzjvxBlHL0PYznvqjuiCqLfJgHooqaI3RIuKsdATrml9Plg74MreS5CQ/I/HX3auzQsplcsWM5kaExwusLhamwz3aGQqCAY6s5hdds/48nSVvKdAV+hqbPCOvByxh2yea/25kY9/RtSMGzua/r3ft/v6JrcS3kS3zaPF8Ssbf85fZLALwp1z6GsijzImZ29HI7GoeH0u/+BobfQjqWE2oTj8uIyl52UvQGPnrWyC8q1/2JxVQNu8JmHuyh/qjQ2wNogCewb0vWsz4ZVxJ3QoHS/+aYLfreys2qKAGKY435sGfazxyiAlpk/wewp3EyA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(39850400004)(376002)(136003)(346002)(366004)(9686003)(66946007)(66556008)(5660300002)(316002)(8936002)(76116006)(66446008)(86362001)(6506007)(54906003)(122000001)(53546011)(91956017)(7696005)(83380400001)(4326008)(52536014)(186003)(38100700002)(478600001)(2906002)(55016002)(64756008)(8676002)(66476007)(110136005)(71200400001)(33656002)(21314003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Z7QUuBB4oj2MmlonGVymdDobFEfz8Sxi2HJApbsVvUBzniJWDrb0iBOsmezc?=
	=?us-ascii?Q?I6fsNg3tewq7stQx3UP8wOkhMfPswH1JBUMV2wYkLw+dcKtgY9dy+3UboE1i?=
	=?us-ascii?Q?Anv1QvWMP+Mj8KgVJ0r9OGeK4kpHci8oNlSmp9XT3KJp0rIo+KS3LW59jtjV?=
	=?us-ascii?Q?XvvbQjnHXqOEW6QlqDdGaZoP1krJy4YuRzzJS4pjJvkRF1ZrRMumE1zRexk0?=
	=?us-ascii?Q?AfgAnez4fFqy49M8eT8SDfplPSocvzvdQVjOOeU0289O944rqLOurskybUSL?=
	=?us-ascii?Q?/Woz4lzSCEp6zswtVsTCxXchoFJrfwIirWFsf4kU0CadccJM6Rt6KSQnql5Z?=
	=?us-ascii?Q?3PfZbsrbFkS8P5mGyWM6SXKHAcMo43phZbLFgUMr2+N1StRE2oyGl5xZ9tGl?=
	=?us-ascii?Q?sZjANmOWAc+MMqh1T/tVuur8I2W4KuJcHSa8LzlEmspTeS8t1T8TUYVG3JPJ?=
	=?us-ascii?Q?zE1gVWJMZSkkkh6efdQdWdeof9+2eA17RfhYE3SXfQP6AUs4adS20jJtFZ2P?=
	=?us-ascii?Q?YJoShM7Te0ZbJV7pq2bfU5dstRs6V93RSkg/guXFD+MTR5YESwKvfHOAqOna?=
	=?us-ascii?Q?QGPU3I4VRz75MIRhFyrhkzWOBIVfT/x8OljIHwJMekAiK/3rrpfuVZVQ50om?=
	=?us-ascii?Q?0k9Y93vNiBShJXyVBTpOF1XKuzyZtJZWC3fxl3itWs34UpU73EUPkLaUS5hm?=
	=?us-ascii?Q?tSMIlHruUHJIAohGVFpxmelSR3o7GosDoSUOURR31GoQWBjNek7foYYZ+gO5?=
	=?us-ascii?Q?19WA6gmahjSn/ZSEMiROZFOT5/O6vnAl6ZgJUnwSw4ZRdi239E1TUCKYkzw0?=
	=?us-ascii?Q?S3uoI+2NamF7Z1EQgmScAVf9UYDFim2qBv4Ahx+CIlwlMMLMySd21cFpR9lO?=
	=?us-ascii?Q?UT4m2SYGMMDZp4tBRf6/TkREy0YfI4NHGIdYlMdpOGDAS0mgldheSfy0zaQa?=
	=?us-ascii?Q?DVRhhMHkfOgsQsb+uTaM2P1i8iNosEtVvvbgrIMj9XxbzTn7+jGlSPDRz0l2?=
	=?us-ascii?Q?KL6N8/TYX2/N94yXjjwkbEHsEDl06/Z8sP4vUzm8cL1noX7GvQID0nsP2d91?=
	=?us-ascii?Q?4BU2zBFAmS+WQ+3f7LbLZy63/KIBGwAJwpjOZ0m7O49vFKM64MjLUvBJhdjh?=
	=?us-ascii?Q?odyCqBpeZoDa3ybBNX7iBQXdxNeAoYQa96JmwEwz3Q2/gW/+hFVxz/Rmq5Zd?=
	=?us-ascii?Q?oJA0riiKK2n2LlLFSttlqIS5zMlowF4TX0UhuTb/jy4lZ0npjhk3UkmoQzJh?=
	=?us-ascii?Q?p/eIA09O/WsEU73JsuYE8BceVOuyzRL9s80/smt03mM/vIXYARERW9R8sM+o?=
	=?us-ascii?Q?pxUaSq13JwSiSTpUQj7Dz2mSIODK/R/f3OcARCNoYRBcY2DcxLYSIzhNIh/g?=
	=?us-ascii?Q?XuAhbG6iKDDhruhAq8mTXTn5HMbTPuISOvUHc67YkiTfr3zXlA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d4ab50-db1d-46d8-5884-08d926e97a6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 23:44:07.1838 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 60J4YF0Xgks+ASGgRE6j1SYVxz1SV89GylZpVSUtHZwljuJPk/vF/+LWJLLFnN/YrgKkvs4oFINwuQne2Ze9yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5882
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 153NiH00019469
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 00/11] dm: Improve zoned block device
	support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/06/04 7:16, Mike Snitzer wrote:
> On Thu, Jun 03 2021 at  1:46P -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 6/2/21 12:32 PM, Mike Snitzer wrote:
>>> On Tue, Jun 01 2021 at  6:57P -0400,
>>> Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>>>
>>>> On 2021/05/26 6:25, Damien Le Moal wrote:
>>>>> This series improve device mapper support for zoned block devices and
>>>>> of targets exposing a zoned device.
>>>>
>>>> Mike, Jens,
>>>>
>>>> Any feedback regarding this series ?
>>>>
>>>>>
>>>>> The first patch improve support for user requests to reset all zones of
>>>>> the target device. With the fix, such operation behave similarly to
>>>>> physical block devices implementation based on the single zone reset
>>>>> command with the ALL bit set.
>>>>>
>>>>> The following 2 patches are preparatory block layer patches.
>>>>>
>>>>> Patch 4 and 5 are 2 small fixes to DM core zoned block device support.
>>>>>
>>>>> Patch 6 reorganizes DM core code, moving conditionally defined zoned
>>>>> block device code into the new dm-zone.c file. This avoids sprinkly DM
>>>>> with zone related code defined under an #ifdef CONFIG_BLK_DEV_ZONED.
>>>>>
>>>>> Patch 7 improves DM zone report helper functions for target drivers.
>>>>>
>>>>> Patch 8 fixes a potential problem with BIO requeue on zoned target.
>>>>>
>>>>> Finally, patch 9 to 11 implement zone append emulation using regular
>>>>> writes for target drivers that cannot natively support this BIO type.
>>>>> The only target currently needing this emulation is dm-crypt. With this
>>>>> change, a zoned dm-crypt device behaves exactly like a regular zoned
>>>>> block device, correctly executing user zone append BIOs.
>>>>>
>>>>> This series passes the following tests:
>>>>> 1) zonefs tests on top of dm-crypt with a zoned nullblk device
>>>>> 2) zonefs tests on top of dm-crypt+dm-linear with an SMR HDD
>>>>> 3) btrfs fstests on top of dm-crypt with zoned nullblk devices.
>>>>>
>>>>> Comments are as always welcome.
>>>
>>> I've picked up DM patches 4-8 because they didn't depend on the first
>>> 3 block patches.
>>>
>>> But I'm fine with picking up 1-3 if Jens provides his Acked-by.
>>> And then I can pickup the remaining DM patches 9-11.
>>
>> I'm fine with 1-3, you can add my Acked-by to those.
> 
> Thanks, did so.
> 
> Damien: I've staged this patchset in linux-next via the dm-5.14 branch of linux-dm.git

Thanks !

> Might look at optimizing the fast-path of __map_bio further, e.g. this
> leaves something to be desired considering how niche this all is:
> 
>         /*
>          * Check if the IO needs a special mapping due to zone append emulation
>          * on zoned target. In this case, dm_zone_map_bio() calls the target
>          * map operation.
>          */
>         if (dm_emulate_zone_append(io->md))
>                 r = dm_zone_map_bio(tio);
>         else
>                 r = ti->type->map(ti, clone);
> 
> Does it make sense to split out a new CONFIG_ that encapsulates legacy
> zoned devices?

Well, the problem is that there are no "legacy" zoned devices: they all support
zone append commands, either natively (for zns and nullblk) or emulated in their
respective drivers (scsi sd for SMR drives). So I do not think that a new
CONFIG_XXX can be used.

What we could do is have this conditional on either:
(1) the DM targets that need it: dm-crypt only for now (CONFIG_DM_CRYPT)
(2) Zone append command users: btrfs and zonefs only for now (CONFIG_FS_BTRFS
and CONFIG_FS_ZONEFS)

(1) would be the nicest as we can keep this contained in DM and define something
in KConfig. However, given that most distros (if not all) enable dm-crypt, I am
not convinced this will do any good.

Note that for the !CONFIG_BLK_DEV_ZONED case, the "if
(dm_emulate_zone_append(io->md))" is compiled out, resulting in the same code as
without the emulation.

-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

