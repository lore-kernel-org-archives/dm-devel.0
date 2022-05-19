Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 215A5C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 19 May 2022 07:57:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-jRct85HbO9CVP1en5o_OvQ-1; Thu, 19 May 2022 03:57:36 -0400
X-MC-Unique: jRct85HbO9CVP1en5o_OvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A85F7185A7B2;
	Thu, 19 May 2022 07:57:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 509F87ADD;
	Thu, 19 May 2022 07:57:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F20A01947B90;
	Thu, 19 May 2022 07:57:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 25E941947B8F
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 07:57:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 03FF4401E9D; Thu, 19 May 2022 07:57:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F2F29492C14
 for <dm-devel@redhat.com>; Thu, 19 May 2022 07:57:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C42811C05146
 for <dm-devel@redhat.com>; Thu, 19 May 2022 07:57:31 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-2QzWhsUaPouc-OtyokIXHA-1; Thu, 19 May 2022 03:57:29 -0400
X-MC-Unique: 2QzWhsUaPouc-OtyokIXHA-1
X-IronPort-AV: E=Sophos;i="5.91,237,1647273600"; d="scan'208";a="312747372"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO
 NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
 by ob1.hgst.iphmx.com with ESMTP; 19 May 2022 15:57:27 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM5PR04MB1180.namprd04.prod.outlook.com (2603:10b6:3:a8::8) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.13; Thu, 19 May 2022 07:57:26 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81de:9644:6159:cb38%4]) with mapi id 15.20.5273.016; Thu, 19 May 2022
 07:57:26 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "dsterba@suse.cz" <dsterba@suse.cz>
Thread-Topic: [PATCH v4 08/13] btrfs:zoned: make sb for npo2 zone devices
 align with sb log offsets
Thread-Index: AQHYaUWvGG/TZMkJWESbmBi0yiTiyA==
Date: Thu, 19 May 2022 07:57:26 +0000
Message-ID: <PH0PR04MB7416FF84CE207FEC3ED8912F9BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220516165416.171196-1-p.raghav@samsung.com>
 <CGME20220516165429eucas1p272c8b4325a488675f08f2d7016aa6230@eucas1p2.samsung.com>
 <20220516165416.171196-9-p.raghav@samsung.com>
 <20220517124257.GD18596@twin.jikos.cz>
 <717a2c83-0678-9310-4c75-9ad5da0472f6@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0f9f08f-566c-44b4-e64f-08da396d36ff
x-ms-traffictypediagnostic: DM5PR04MB1180:EE_
x-microsoft-antispam-prvs: <DM5PR04MB1180EEFE018F11138C5A7FF19BD09@DM5PR04MB1180.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: waNJ/8nPr2Kwm7owvHFmTFigUuubmVSdf5TFO51Lx38kyphLIPpgqVUTMHAIjrA66sNy7lS56x2cnugpfmNVwbGsrWpBUT+xdJWBubI9LHUBmAFRpqfvsVJ61bGW+Vi6cXnGbZf9g8izhf20m5L7/NaKWil7hDTNvtUi18WZf+6+5eNXnwlN4P8zNu5jSNyob3LSRqH4AxqCRVXemuGEGK7rBaeDAwvSUGHXPXFNBMvI7d5zam5oGmEUESouFhT4F0X5BY7zN7sQwKWBVdIOF0uWLuRZb3AbRg+lN3nyqqy36FkVaZQC9KX6MY71J2mxMtDlS9GGdAiQ90CsS+xUrFyN4HxIIuz5zBQ4GcZyMgCDl3ksRR9NoJAOYIQbGFfzlvQqmT75ZIHubnKBUHroU2YGhEU9H01/rA4bDGovhyf1PmeZve4Z3vZiilw+fUOmdt0ssP6443j+ZMgJRMcHM3VlyHZEUPuyGk/yPoENugynyktjbPEZlUCRfb6og7G+JEFzAkMXgeujZmC2zDX6WdPRX1lHHwHhKQbgyTX1kKbwemzfSQjBX+/FK/iPdSKDE8UWoFo+gEJC3xWHetoxrqClv8jWpo1oV9XjvD0NzIE/r3aIH+zgEdAXOfQDNSFnxESovTxNm2H0qB+gzSjKrmJfcr0rMmLHx9l/97g7Q68sia0REWp+jxg/DMB9i+e77Rjvzi+vDrt/5IBU/7h8XQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66556008)(66446008)(4326008)(33656002)(6506007)(8676002)(7416002)(316002)(86362001)(110136005)(2906002)(7696005)(5660300002)(9686003)(122000001)(54906003)(64756008)(186003)(66476007)(66946007)(53546011)(38100700002)(82960400001)(71200400001)(55016003)(508600001)(38070700005)(76116006)(8936002)(91956017)(83380400001)(52536014);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?reqlWfoca+h8Q2F/lukhGj4Ck/Yz8Js3BU7SLX2ytFDdzU+/uzUsiNyGgQPF?=
 =?us-ascii?Q?yx/3GT3fr91n8Dx+EoiS6zB81tgXilI+pQcxekXoEmDjMbgEIVDoU1eV8jVw?=
 =?us-ascii?Q?woFPMMJ2C2/O4GTN2Em6UF/2O2MtlMczj0UyVPb9TYUvWIlxCVPbvNP2R7+s?=
 =?us-ascii?Q?RFrHombrwDOOmIkP6acCpmNajmFLvqBzSPVUnWCKvJuJ2Dr272XPP5f9iSZe?=
 =?us-ascii?Q?ekf0AvOkPBleFoEJ9PacujeX4oB3TBzhfrUdfseQXT3AHmhDnFYRbRwulQs1?=
 =?us-ascii?Q?pIJwn1H56gS7VixIIdAuMxYMRox6hoNhlLi4sWC8j2vowwDFkRVigvyAdJkN?=
 =?us-ascii?Q?Rm6bGJ+duzFhpXWXL45/b7mYPb9K3YLw3gDNl/CIINnuEUyKOVq6YE0XkIja?=
 =?us-ascii?Q?y6sNtiJwir1B8tP9Swm9bybIWPVKk+/4/53HpGo6qnwFLTO7JgSt1iek7J6a?=
 =?us-ascii?Q?kWKFRxCGeqEed18ehjd1efrE5bV7J9nP+uGbbVdPetVJZoIs3bSSiH+IbBJC?=
 =?us-ascii?Q?LCSGZrhnsFckvHEST/zBhMeaZ93slrEDZSU5gMSDUnyeL91lH0AaisNpGXRR?=
 =?us-ascii?Q?ffzaH2yRSz6BsnsQO+xxwBHi+vg5sbjKti4SQps8JhVBymuGUVGTydIjiqfI?=
 =?us-ascii?Q?RPAGP8bGy5w/o4JoigKiNxc6dX8+EXoUgrklQ9sQFMA2uawXImpvE6deq7Tw?=
 =?us-ascii?Q?R3EkrQ7YvPK+ZcZ5L/eMgeTjJG1b+ISKG2UQ6J12oUFko9qPX6JwZ+PuM4g7?=
 =?us-ascii?Q?JURDIqgWrE+2tD0cwRXBdSeCtwqUC1prpplHgvODjwmnlCjjhbR0aXAfVRv1?=
 =?us-ascii?Q?tUeB4/IlR7ucYRip5Cb2oa9x1969x9+tYZHNk6jaRlr0vqNf1s0OOaELbDx2?=
 =?us-ascii?Q?3g3klBiIzboW+vu4SAgZWcXEB+15L/D8kRs/Pkoerz4d4NcQ8wI3XY+ovXfZ?=
 =?us-ascii?Q?Sc5t9z5aJzJOKUKdzA6+l0R1FIvpXQYrMG5h7uJLk11Ic4152s/DZv7B14p4?=
 =?us-ascii?Q?CtOPFWkU3NvQlUIG3OVYrWvWi4X7zg1MvZaBkVxGzn+WBZ3WZrLOh54r1XDr?=
 =?us-ascii?Q?8a7yrzrX01GjZk6TRV9rOPXb6wgttm+vauWnCl6rScIiJZ05pxuArHyP37T2?=
 =?us-ascii?Q?HKzm9404suMITCHPgDucHg3lEDOejZN+rZjSdehPAMxvXi2mrxVYG357zooT?=
 =?us-ascii?Q?qlzpqYJSw+fSEUz+Umtxpr8kmF+G/zeLbErtlwo6xkxJzFAz3B6TnOH//pbQ?=
 =?us-ascii?Q?V4v1lRwywKedAuVs33gEAuvN6inmQWqSlP9wA+P4OQvhKPFNVPz1w1FWY/U8?=
 =?us-ascii?Q?PfIbOYwYoszzheLFbVPEs+RdZtAKVLbcOJY1N9OY0Hc4OKiBwCm0Ka/4mb/+?=
 =?us-ascii?Q?YmS9kRwCsRTIAWZaI2a9/9x/LrEEVToEuTaHpt+iKAdWJ/H1aRQSmpzzf2sB?=
 =?us-ascii?Q?RxjX3JxzGoA7PDztKQzjfY5wC/dMA0GT5WvNsW1IYdXAmCKi6O6egEi8d3B9?=
 =?us-ascii?Q?FAI5FXKPL375ulR/NyTvaMoUhr/cmJObpE3SwBhTDNvfhgPB54kts82++bQQ?=
 =?us-ascii?Q?tkgoXf5kS4ceyk1XfyTuvqxxAaNPaBXMJjWj5D6fYNdSgTbxyb5xN4moX8Da?=
 =?us-ascii?Q?MuNGytFNI5xtc4LodDHsNmLrg66RsVQZb9i+K57786C6+8sbsGXfhsPzGvX8?=
 =?us-ascii?Q?1LDlUmYHCcTGAlEGDVByEtgNE+pTIpl7cbJXaDy/An4t5IWqPHZEvilVHjVQ?=
 =?us-ascii?Q?7glNvQ07L9zaL+hoiZ5NclsPa+ef2GqZkqWu7fsZ/ZG9f6lU1geMCCJglJ0I?=
x-ms-exchange-antispam-messagedata-1: 3wsxfGTRpd/w+lvCmDa3nDbyOTPqNmmciagjxHpKh/Em1Yr+pJQW/DTm
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f9f08f-566c-44b4-e64f-08da396d36ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 07:57:26.2992 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eWi1xnPp4MWOwR1HYrUoogbJUyQeffPr2QXBLcBSQyB2KDZKvq9YJCxalE84HKbdS49onoWEZujnoAyzM0QM3ZTsHlRJIRy/1txiHFChlGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1180
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 18/05/2022 11:17, Pankaj Raghav wrote:
> On 2022-05-17 14:42, David Sterba wrote:
>> On Mon, May 16, 2022 at 06:54:11PM +0200, Pankaj Raghav wrote:
>>> Superblocks for zoned devices are fixed as 2 zones at 0, 512GB and 4TB.
>>> These are fixed at these locations so that recovery tools can reliably
>>> retrieve the superblocks even if one of the mirror gets corrupted.
>>>
>>> power of 2 zone sizes align at these offsets irrespective of their
>>> value but non power of 2 zone sizes will not align.
>>>
>>> To make sure the first zone at mirror 1 and mirror 2 align, write zero
>>> operation is performed to move the write pointer of the first zone to
>>> the expected offset. This operation is performed only after a zone reset
>>> of the first zone, i.e., when the second zone that contains the sb is FULL.
>> Is it a good idea to do the "write zeros", instead of a plain "set write
>> pointer"? I assume setting write pointer is instant, while writing
>> potentially hundreds of megabytes may take significiant time. As the
>> functions may be called from random contexts, the increased time may
>> become a problem.
>>
> Unfortunately it is not possible to just move the WP in zoned devices.
> The only alternative that I could use is to do write zeroes which are
> natively supported by some devices such as ZNS. It would be nice to know
> if someone had a better solution to this instead of doing write zeroes
> in zoned devices.
> 

I have another question. In case we need to pad the sb zone with a write
zeros and have a power fail between the write-zeros and the regular 
super-block write, what happens? I know this padding is only done for the
backup super blocks, never the less it can happen and it can happen when
the primary super block is also corrupted.

AFAIU we're then trying to reach out for a backup super block, look at the
write pointer and it only contains zeros but no super block, as only the 
write-zeros has reached the device and not the super block write.

How is this situation handled?

Thanks,
	Johannes


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

