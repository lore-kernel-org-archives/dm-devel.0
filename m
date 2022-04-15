Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C278CC433FE
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-RIZnCZQBP4OU2TztzQoNlA-1; Tue, 19 Apr 2022 02:10:45 -0400
X-MC-Unique: RIZnCZQBP4OU2TztzQoNlA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41AF81014A78;
	Tue, 19 Apr 2022 06:10:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C81348FB08;
	Tue, 19 Apr 2022 06:10:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C7899194EBA5;
	Tue, 19 Apr 2022 06:10:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D094F19451EC
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Apr 2022 05:40:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5E89463EEC; Fri, 15 Apr 2022 05:40:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0F05463EE9
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:40:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 915F586B8AD
 for <dm-devel@redhat.com>; Fri, 15 Apr 2022 05:40:58 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-aMY5mwmYMs2g84SWv6pXGg-1; Fri, 15 Apr 2022 01:40:55 -0400
X-MC-Unique: aMY5mwmYMs2g84SWv6pXGg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1815.namprd12.prod.outlook.com (2603:10b6:903:122::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 05:40:52 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::a90b:9df2:370c:e76b%3]) with mapi id 15.20.5144.030; Fri, 15 Apr 2022
 05:40:52 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 10/27] mm: use bdev_is_zoned in claim_swapfile
Thread-Index: AQHYUITaaZIEEJsgKUC+wO3WwWQ60azwdbIA
Date: Fri, 15 Apr 2022 05:40:52 +0000
Message-ID: <0da96aad-412b-9afa-c42d-92ca2a650d1e@nvidia.com>
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-11-hch@lst.de>
In-Reply-To: <20220415045258.199825-11-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aea663ee-d1f2-4514-a72a-08da1ea28110
x-ms-traffictypediagnostic: CY4PR12MB1815:EE_
x-microsoft-antispam-prvs: <CY4PR12MB18159DA5D8FC0199C25F222EA3EE9@CY4PR12MB1815.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: M34dFIzT0LV588aq6aIAGcgbjFXRluuYfXVQM6iNXvjdMwoeKeFBKBg1bghEe7k9t8y6Z5AyNBw/oD320Tio0S1m8PgrMXdIhntJtODQdLBnIhKAP28tJkRREQtszuGfbWFxqsBpClX5b2CNwWfFcyZOV9iU1D/FDauDeXl45/gWrS6a4h16M6rbfnLLgI4wBd7UwkvXcP1DTEPisunfwUMy4+wCC3eFpvjkbARACjDrUJTgMZFs5TZokIc6JnZnMKzIupFEqnhD0hcHJBAwuu4ucObPeA7ecyuz4+4sEG74G+2F036CTLI3jKSw7bGTOTJCwzzuZO9U2uwikGT7hbW77Dta8N6jnvi6E5eZVARMdmJO5CD8pvslNQvIcAte5bqUZzg+j6SHYsvaxhM/Zzv8pK8jbup781PwaxLUuGeVChY22kcWzr3RBW2x0g5ZRh7Nh0ipfISoWUnD/hRIU8LP9ftilHK4Oyib3ov5IjNleB9l17sxDKoEZ1iNpdf+UK5spUg5UA67pmlowjfw2IaOWzLbcrsQpuSy2gM5fQ2jPiG2CcXZi6RgmNoMsvXeWwmbP2uGJTlDhNWSflSWcOBe/1gX5IZU/hZGYfCwiJETf2A7vLRzSUCxSzIiTsWu3J3zSqXmTlN7p/QdH0bmT4GNBdyJOtdsp0a7Z07Og+b+Wy0yNNubVjqJAv6islzQqCPzpMffELFiAH3SFUjlpVM3o3SYWA4Zptgo86P/qGFflXN2rtVGKcZevr3CvF9Us9LApcqQqt8taqJvFLfk8Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(7416002)(8936002)(2906002)(91956017)(5660300002)(4326008)(66556008)(86362001)(31686004)(508600001)(38070700005)(6512007)(2616005)(186003)(53546011)(6506007)(558084003)(36756003)(66946007)(66476007)(54906003)(110136005)(71200400001)(76116006)(6486002)(38100700002)(64756008)(66446008)(122000001)(8676002)(31696002)(316002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REtnQjB2b2dibWFRdnVXaDF4OXJNTDVZaGFnQzd1ZHp3azVzbUZKL1JDdG5N?=
 =?utf-8?B?TGg3V05zc0dYUGJTSWNnZVNaSVFwK2JhSC9GNlMzQkVvenZZaWdFK2I5ay8w?=
 =?utf-8?B?dDl4V3U2dm5qQ1BTRlpQeVBRWVhFRjcyeFBheWVITk5nRklPNDhDcDhZRll5?=
 =?utf-8?B?cVRzQVVSeWZiY3dvdFBUaWtVOUU0UmhUY3dOZkpCTHB2S2M2NmkzVnc3U0V2?=
 =?utf-8?B?d1lUMmRRdnVKS3p4UUVDaDJtSFYrNlBkT1RFZVJZU0h2K09SM2paQUdJSGpl?=
 =?utf-8?B?aGxDZGF1ekJ5Z1pZVjBoM0tGdmJtcko2NWlBd1JDZXNSYlJCY3hWMlBVZ0lu?=
 =?utf-8?B?eldoK2xmK1NhZkR3THpQUHNOd3MwdmJROTVSSXlqNWFJRnNFdGNDRENCRFBN?=
 =?utf-8?B?aDRTazUxbUVEM3EvUmU1RG0wUGhadU1pdWFpWFppZXBBZ3RFYjNWZTl3bFRY?=
 =?utf-8?B?eDZDMjEyYVh1WlZRQUpkSllRMmttKzVxTyszYWR2bFcwTlppbXJBd25weUtH?=
 =?utf-8?B?UHVKdTBmbUlVRE1QZk1XSlpURUQ0UWtVY1RsSzh3N0k2S2czZkgwYlJ5cERa?=
 =?utf-8?B?RldrellCR2hCV2cyL1dMeDJkRE9tdUpSdUV0ZnY4enlBSVdTZTVIb3NkUHlU?=
 =?utf-8?B?L0dNU2dIOFlBTEc2K1RyRkxaQnVOTUpFQVNxNkQ2bXFBbGhkMVB5bnQyc2ln?=
 =?utf-8?B?UnI0Vkx1MFFNOWp5eEdlWnk1V0EzK1FGZHlVV3RJeXNpMDI1aWl4Ulc5US82?=
 =?utf-8?B?WFZXbWxaSXdPdk1keFBWMEcxUHpWb2s0MGx4TWtTdUoxOTRLMWI3RUEyUGFP?=
 =?utf-8?B?dmEySHh0bjdqNjNIVjlNMXFnL0d2ZWhZaDBMNzZCV2NNdDJtSURCbXIrZVVl?=
 =?utf-8?B?Y01RNndva3phZ3dRSU1LR1pkRlhVNW11Vk9tYnM2cGZOcHN4L0RXdC94VDBw?=
 =?utf-8?B?K09zNlhVRUY4TW12dUZlNU9QQTZwOTZ3YVhieWdkbkFjUHJ3dHJMK0ZsWjV4?=
 =?utf-8?B?MDJDY2ZUUmV5ZUVwRTlrZittdWdDMXU0Mks5SnZiSFFNellQZTFFVDNGejBZ?=
 =?utf-8?B?RTMybExHSXMwUXkrRmhIdXdmYXN6YmlhQmJxNThweWJhRFZSTUgxOVpCd0ln?=
 =?utf-8?B?R2RMZVFEK3QwQlg3MjRGTjk2Z3VMSC9Mem5Sbkg0SHVucklQWWE1aFQxc2I3?=
 =?utf-8?B?emJyakE3dHRmQ0FaUjJaTU9TUzIwVllKUlRKN3RKNFlzSXBUd1l0ak9RZUp1?=
 =?utf-8?B?Vm1CZFdoTmVGN1orYnRzZ04zMXhZMHFOdTdkWXJkbmh5YndZakZHc0VURWoy?=
 =?utf-8?B?RXhxclpvZ2N1Nk1tTFM0c0RsclJBTjVSdXBoYW1WdmdtdlNjbEpDK3BqWk5F?=
 =?utf-8?B?NFpYWWo5cUM3ZDVzZDh5L3B1WDhoTi9sbm9SK29Ma3FOUEpWd1crelMrQngx?=
 =?utf-8?B?YWtGblNiem9uVll1N2NtaXlaMVpLTHdWd3piUUpKZTEzbTlqTFordlJhSWdM?=
 =?utf-8?B?RThIQ3RzZW1FOUs0SGVaRkVPaDRkTU8vUnB6cktqY3Qra09MYUVoWHJlTzNI?=
 =?utf-8?B?ZVR0Q0tXRFFYemVGcXI3bGoyZThnSzdBSDM0K3dHcFNNUXZqbGZyYWpkcDhy?=
 =?utf-8?B?QllKQXRCZ05FbjV3MTNqV1BXZzg0VmkyeS9UZ2tYdlRSODRrL1BrRXBzV3hW?=
 =?utf-8?B?V2dQTkJKM2hzRlNLZkNHUUgwOFhZZ01HVW5nOUxnYTh3UWErMFNwZmFIWnds?=
 =?utf-8?B?b0xGM0NOUEEybmRNWGlXdWJLRS9PMEhmL3lPV0Rsd3laZE91clVlRm5MNkJp?=
 =?utf-8?B?ZmRDV2ExeGw2bkhFc1A0Y25CMUZ4ejhOOFhqeFV1TzJBUDlSWGZIamtsV2JW?=
 =?utf-8?B?a0NLU1RlSEQ1NW43TzVkM1piOHdvdjMxVm90V0RhLzEwK0pKcndYNTU3cFk3?=
 =?utf-8?B?TzBEYXhKbEpXVlNkcXVtcThOSFdwbTYvTTJWdGVPaUpzV1NYRjVVSkx4aWZu?=
 =?utf-8?B?QXBRbVA0SitHQ2s0c1AzdEZQK29BUURISmIzZWtSNjlFOW53THo3TkwyRGNR?=
 =?utf-8?B?MGRPYytuM3JPTUUwbWZSamxxZFpEVE02aGxLM3JSK1diTGRzN0QrclBoeWIr?=
 =?utf-8?B?S2VtWWtXMnRnRCtaTFM0blV1bDlHWG5GU0hYODFmeFU1ZG9YRmNaeW9vVUdF?=
 =?utf-8?B?QnQ3eDJlZk5WelYvcGU2VUlROGoxMGE5RDk2OVZvWHVGVVRnbnB2bWJmQ0Fz?=
 =?utf-8?B?R215U0tORSs1ZXVSS0Vjd09ySzRSNXM2Y0M2OW9OVEZFcXJRYU80cXhWcEVL?=
 =?utf-8?B?YVlSS0JRcWRhNi9lREtiT0Z3TEw4Q1lTUkk4RjRvOU94NlZYUFJqNDBud09j?=
 =?utf-8?Q?fNzSH1XXej3O0JvI=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aea663ee-d1f2-4514-a72a-08da1ea28110
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 05:40:52.3984 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aRHw2otjvuGwsDds8CNzFbeFzIULc5OPanDRop/gKBwt/QQI0D4jISCjUFC3clY67udtv5Wb1eK47vFOJyX3/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1815
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: Re: [dm-devel] [PATCH 10/27] mm: use bdev_is_zoned in claim_swapfile
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
Cc: "jfs-discussion@lists.sourceforge.net"
 <jfs-discussion@lists.sourceforge.net>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
 "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
 "nbd@other.debian.org" <nbd@other.debian.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "ntfs3@lists.linux.dev" <ntfs3@lists.linux.dev>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <807FABDDF8F92345AAFE5DF5D2053FEC@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/14/22 21:52, Christoph Hellwig wrote:
> Use the bdev based helper instead of poking into the queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

