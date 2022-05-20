Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B1BC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 09:15:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-4wEUckWPOL6Ac2IOPSZy0w-1; Fri, 20 May 2022 05:15:14 -0400
X-MC-Unique: 4wEUckWPOL6Ac2IOPSZy0w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EE951C04B55;
	Fri, 20 May 2022 09:15:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F3E5492C3B;
	Fri, 20 May 2022 09:15:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 023F3194705A;
	Fri, 20 May 2022 09:15:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A5BD81947058
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 09:15:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 958D51410DD9; Fri, 20 May 2022 09:15:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 90DCE1410DD5
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:15:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 751CE801210
 for <dm-devel@redhat.com>; Fri, 20 May 2022 09:15:10 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386--ZIM-Eg6NwGAJWSYquF5JA-1; Fri, 20 May 2022 05:15:08 -0400
X-MC-Unique: -ZIM-Eg6NwGAJWSYquF5JA-1
X-IronPort-AV: E=Sophos;i="5.91,238,1647273600"; d="scan'208";a="312877680"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO
 NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
 by ob1.hgst.iphmx.com with ESMTP; 20 May 2022 17:15:06 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB6668.namprd04.prod.outlook.com (2603:10b6:5:249::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 09:15:05 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38%4]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 09:15:05 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "dsterba@suse.cz" <dsterba@suse.cz>
Thread-Topic: [PATCH v4 08/13] btrfs:zoned: make sb for npo2 zone devices
 align with sb log offsets
Thread-Index: AQHYaUWvGG/TZMkJWESbmBi0yiTiyA==
Date: Fri, 20 May 2022 09:15:05 +0000
Message-ID: <PH0PR04MB7416C7CBF8E4E41D64DF147A9BD39@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230@eucas1p2.samsung.com>
 <20220516165416.171196-9-p.raghav@samsung.com>
 <20220517124257.GD18596@twin.jikos.cz>
 <717a2c83-0678-9310-4c75-9ad5da0472f6@samsung.com>
 <PH0PR04MB7416FF84CE207FEC3ED8912F9BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
 <2252c3b2-0f65-945e-dc39-c0726bce72e8@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5f3f2af-e100-48eb-e8dc-08da3a413a5b
x-ms-traffictypediagnostic: DM6PR04MB6668:EE_
x-microsoft-antispam-prvs: <DM6PR04MB6668DA2A73C4CB34C4F6108F9BD39@DM6PR04MB6668.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: QXEpMyuy4WxqATlFhkTReMuS/vGlQEWrVlxB+wEiLlydTPBIovLOP6yQBkDltFzt13S4mSsxlfZ6b7s2wQEqDucK7M8/WdLMMGxPZ6gj93e10VL/St2cA4uUHUTUOSyryF5/ft6ndgjhyCzgHFXDQSMv/Hi2T3D1qV4wI/oF40hwwQtG+UpozqaBlHGaoW/hg9nBzwXsP0R2VJU3xre167i42Tt+e7rq1m0byoO423EHsnNgeEkT9tR9rkgBO44IWZCV/6Q0ngxub3XWBfQir9Wj1dtPpxRG4P55OIY72ve08Un6ahGQPnq6nB6pge4VLFk+erpZor38565RYN1hs880ZIiXEsL7nsljf15hAfHumkj/iwG0+dp9NyckN9xWsgWQ5XBfjNCQ+mVrIv/DG4pJg3+9Y1uNJuVoYmPdT9FTH5mHckkmXmlCr9apJSRGml72tslwj3/IL7VsJhWjKsfSU5PgMKUmfCpAkmS1ZZ/ppkf6LD21jf+R/pTU/O+0E0+251SkyUtMzWzMy1q+py9ExtapY6qIbEImFha6vJzyw0VBtFV/Io2PC5/n1qspfsMpn4LGcjsBM2cqm47m2ZqZyDvFCLkKudz59MlUueRq2YwyBVU+5Lh6MtSMSKCnAQbcMK8nC+MJEG8rp60fKIGx+cdQkBEoyfXhn/EGkkOb/xsn1Qasawz8Ju9no9xXy+/anBNjVlr4IrOc1Ii6IQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(5660300002)(7416002)(38070700005)(86362001)(55016003)(54906003)(316002)(33656002)(186003)(83380400001)(9686003)(82960400001)(2906002)(508600001)(110136005)(4326008)(8676002)(38100700002)(122000001)(26005)(66476007)(53546011)(71200400001)(66446008)(91956017)(8936002)(66556008)(76116006)(7696005)(52536014)(6506007)(64756008)(66946007);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WSXsknwM54ib8CNLzcjmNtUCQDu4s3yssQ5mdrLEkmAUXfVLvvfmU9ixkaa2?=
 =?us-ascii?Q?kboHLYw+sMxzaHW4QlY0YC6Bw/Y8DSK1/cLPVOvD/JoG4fnv91AkrXSbARDC?=
 =?us-ascii?Q?Pr+ihTZX6BMuk2bMu3kr7R+Fw6x79fqkAUCoItFxVuKLI1AxjzCi1YDROeXZ?=
 =?us-ascii?Q?mSGVxC7IkzDOuhCI292nJznoHZEGsi4yA/pU8m2dGoyhgmgK4wc3UBHRedZW?=
 =?us-ascii?Q?JcYU7zjj13whhwIgP6cUk+C2joANfVkJ7xE0JSczP7v93nhIVFmxo/j8/Ml5?=
 =?us-ascii?Q?G+WYbBE8WOuPFt+4IaGMgghoksITC1F7T3yhSxu4xoTi0jN2EfBPFbLAj685?=
 =?us-ascii?Q?qG1IhVF461PuxX7ODKBeoQSu8jIQ62e1xb1oM5HfENCFq43dXizIOwrViKr7?=
 =?us-ascii?Q?D1vCkcOYtw0H0N3jY4SjYVr4z1HNpmwmtuUg9/fIck8DPW0Jb245c+tcTCjx?=
 =?us-ascii?Q?TwpVoVQaAM90Gt14YeATMFGMSxmco+FL6hcfkv2oPkah6ncLvsvBgX1L2ZuV?=
 =?us-ascii?Q?7uVnykUOFeH9m0JNih5Ihj7ndjnpu3Qp2TWrR8BGy3+bZJzfQ5isopsr49lM?=
 =?us-ascii?Q?kVAP6B1aLulELjA1nbh0SmfQ6+yqZrzTZMO6p864EfpBTgcgb2GRIWU1UCG0?=
 =?us-ascii?Q?XUXAJ/evCFLT9hs3eVNRJ6JyX0DENb/YJg6vHTj0GqunPtAyzmhHdDKPUFJr?=
 =?us-ascii?Q?ZrD5Ocrv+3lexV3KVmHJzdq+sXg1qhmuQ5YBMKiqv251x+EfQDaftAR6OktQ?=
 =?us-ascii?Q?EmSd85xz1zyW8j8IGBM6uOh6Yj0QuhSFQiLwj0tLmV949XzxdMrHP/7iDkbU?=
 =?us-ascii?Q?24y2mlA8xoBGk6KUQzCnopNEmbwnxZ74e3g1nqCVkbCyzlV665gW4lWv65Ey?=
 =?us-ascii?Q?dKoyq7ocy8wsMa0fjT4wLsleC71hv3zXg++g9GQeRsvukJcZviJ9Cu0E1vo9?=
 =?us-ascii?Q?gogjhZeKrfSn4CSJ4SWdU/BkBRa9qFYGLcvsEHGsrkpMl3PeARnug25mktBk?=
 =?us-ascii?Q?yZhCZd1KZrMlSoqeOZ7CwZeWjE8290+m89d1o5zOxAu/OHBDnSbOkFHyzWEo?=
 =?us-ascii?Q?7zwqPhzK59FQfc9kHQF5tjJ7aiBt9L0afifk3CWh8LTUCXesr/1z0FPZ2UVz?=
 =?us-ascii?Q?QOI1/iFbBPYfqfHcDmprbAZrRZ9JQ0ycd1XNah33raa0WmQ5USHSc+nMlKOo?=
 =?us-ascii?Q?BqE1cc2fKmKTyNANqZeg9BJ2/MmFvxNuFGYDmfwVbFxCpsEEOtK3mnMvLPwR?=
 =?us-ascii?Q?ScC+7RU/4fJnNdbZeB9khE4thu/C6z7bL+z9dsj8eqoWtc1lVP0jVK7eYN9r?=
 =?us-ascii?Q?fHK0RRtUT7Gk5Yw82Ts5taxac8NFq9k1z/zGpJjOl6iJ3IL7+Ykn+jJoq05H?=
 =?us-ascii?Q?hZd8lUDmgc3ic2ECIHlfACz23y8/AOSedHGbztCwLGr0T3yNofFBewjhQKDA?=
 =?us-ascii?Q?CgQZRmwUMiYd1J3COq8VoyoXt9V08Ve/UMEB6sKycCCCiX7uuczy0M4knjaP?=
 =?us-ascii?Q?hwyFRlru9rP+B/t8aVMtQAdEofPV7p4Y+cxamvdsxcNMIGbqcO6moUyfTdbS?=
 =?us-ascii?Q?yeX8KPXXXvSjwmns9xtMyFsfjroDSoymQaiNfEeG82duC5Lp/9TPgQudCuf3?=
 =?us-ascii?Q?RwF5B7ZjYM0d7vuLxBgnYKOolBtHwoisUsRM/NnBLgf1gTEDh5GwdSsWY5lo?=
 =?us-ascii?Q?MDi7lpuunmTLkvuwtiBIHhvuiRbQlnAV5PoXI2yttHHqRXCAMQtS2BQT6cdQ?=
 =?us-ascii?Q?NgLAINBuBJ40ePOJYquhOuZIbNZqsMHHjisv+6UfIHrUrbOssyX2?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f3f2af-e100-48eb-e8dc-08da3a413a5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 09:15:05.2265 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DLwgx1Q+Dnwk3RsZDZxwA+SULokeFGc6+o8MCY3eY0pEYNPCBkiTMnoRUDGzCTcrYhhe8ZvQzaB8TzXx4yqZzgiYdgwwBz2ri4HAZbwk1R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6668
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v4 08/13] btrfs:zoned: make sb for npo2 zone
 devices align with sb log offsets
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "dsterba@suse.com" <dsterba@suse.com>, "hch@lst.de" <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 20/05/2022 11:07, Pankaj Raghav wrote:
> On 5/19/22 09:57, Johannes Thumshirn wrote:
>>> Unfortunately it is not possible to just move the WP in zoned devices.
>>> The only alternative that I could use is to do write zeroes which are
>>> natively supported by some devices such as ZNS. It would be nice to know
>>> if someone had a better solution to this instead of doing write zeroes
>>> in zoned devices.
>>>
>>
>> I have another question. In case we need to pad the sb zone with a write
>> zeros and have a power fail between the write-zeros and the regular 
>> super-block write, what happens? I know this padding is only done for the
>> backup super blocks, never the less it can happen and it can happen when
>> the primary super block is also corrupted.
>>
>> AFAIU we're then trying to reach out for a backup super block, look at the
>> write pointer and it only contains zeros but no super block, as only the 
>> write-zeros has reached the device and not the super block write.
>>
>> How is this situation handled?
>>
> That is a very good point. I did think about this situation while adding
> padding to the mirror superblock with write zeroes. If the drive is
> **less than 4TB** and with the **primary superblock corrupted**, then it
> will be an issue with the situation you have described for npo2 drives.
> That situation is not handled here. Ofc this is not an issue when we
> have the second mirror at 4TB for bigger drives. Do you have some ideas
> in mind for this failure mode?

The only idea I have for this is creating a bounce buffer, write the padding
and the super-block into the buffer and then submit it. But that's too ugly
to live.

And it would involve changing non-zoned super-block writing code, which I think
is way to risky.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

