Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E8FC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 13 Dec 2022 05:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670907603;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BB+nOyIunFcozij6/akE3fzTkAGOSoWlCeIhhCpZfoo=;
	b=GVOggtyegCc0Dts3cjj7gna3G508QQzjxS5qFaY+sO95bFRRJoEQ7gs+ZXRlpaUKyusV4g
	lwk8IRe1BYDESlOpoAvjErQbpMgCUz5Vq7dQp55WpQ/Wb2jd18PEIFjBYnx5pO+VCJrxk2
	UpX+dqfMcMv1tFp1ubtfaY69FzHoaQo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-377-DVOc5GijNKeNOTfE-iaHkA-1; Mon, 12 Dec 2022 23:59:59 -0500
X-MC-Unique: DVOc5GijNKeNOTfE-iaHkA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 032793C0D842;
	Tue, 13 Dec 2022 04:59:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E41361121318;
	Tue, 13 Dec 2022 04:59:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B57571946588;
	Tue, 13 Dec 2022 04:59:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0AF7B1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Dec 2022 04:59:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DEDA5492B02; Tue, 13 Dec 2022 04:59:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D6510492B00
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 04:59:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBE2B185A78F
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 04:59:55 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-_s7D55rBPvOARw1jndno6g-1; Mon, 12 Dec 2022 23:59:53 -0500
X-MC-Unique: _s7D55rBPvOARw1jndno6g-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 04:59:50 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.018; Tue, 13 Dec 2022
 04:59:50 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Alvaro Karsz <alvaro.karsz@solid-run.com>, "Michael S. Tsirkin"
 <mst@redhat.com>
Thread-Topic: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Index: AQHZCMWIE493Nhwph0Wuxc84G3ju4K5iC2yAgAAudgCAAGdJAIAAQiIAgAWW8wCAAtOpgA==
Date: Tue, 13 Dec 2022 04:59:50 +0000
Message-ID: <b560029e-e10c-5fa8-8648-e1b765f903fa@nvidia.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <Y5BCQ/9/uhXdu35W@infradead.org>
 <20221207052001-mutt-send-email-mst@kernel.org>
 <Y5C/4H7Ettg/DcRz@infradead.org>
 <20221207152116-mutt-send-email-mst@kernel.org>
 <CAJs=3_Bu+tZqQk3JDzP0JfNbPZ8FG7mRNnPE9RrWUs8VOF=FzQ@mail.gmail.com>
In-Reply-To: <CAJs=3_Bu+tZqQk3JDzP0JfNbPZ8FG7mRNnPE9RrWUs8VOF=FzQ@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4084:EE_
x-ms-office365-filtering-correlation-id: af6f455e-24d4-4a63-f20b-08dadcc6dd69
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jydfVwWHeV+TIbPe09z27wjprzEyFD3B4k+coMBasobTiyqQvopvDlLw8O0jaZ9P115QylVIKzNQHfaNMH9uwJrew9LuwjIBidLjsRiyN0k94Dy7THe0FY/WuiISjpI+syLDkopw+qe/Sf9fgbpS49RaoPQG9ToGuvZf2ngg51lsYHLBwGQrzZFc+fx+lrcBXhvHG5xM+3ySfhq6POV3gpS/Hunk/R7YpJo6vYgmmRmmhA1jFjB5zWPGY+w2klMnRvYf8Qnn4GeRL0sXCPcTCn0K/RzMhnisUAQIY4vC3sFPI67Ty1hURz2ZaH/MzUTmHPI24jQI5h3/G2reWVHKsY5vacfAKM24VJ9qRqDJuUqjR082HyfGLFgyzGRCXe29uIVRR7EvhvwMe4nOrpl+eMRnMk8vVnL2QjClQrUW6sSel88Ph6Tga7l7ANdtiO5CcE0hWSGtlYlyD82kPaEwk/iRASc3aTcu8bxSCvYNUSCGYyPMVI1ty1r2na7fwj/MLB54hMHW0lFo7oIZ7wiCR+wTbvvpJ2Ycw6jV92oWqykKGh3h1ERnTeQDjRlnAGhBYoG0yHwD4TpCTqXM8QidxvxTNu8+kOsKhy9w/nTVr5CmnW3yJYFwCRIIQxtaQKfBD1MBn2fZ0lbcJ1TWVZVlzincWXHgxkXpW4E/Q/u8lcE+in7URgU8/EoPh3oz3rb4PtRft1P+7I8LNNG+7gFZcOatwXjRFBJccNtYmjCKEmbLxwWQ2tpKpibYPc9OAnjYrxnKGokAzVJvdm1III8eLQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(451199015)(478600001)(2616005)(186003)(6506007)(38100700002)(6486002)(53546011)(6512007)(122000001)(71200400001)(91956017)(66446008)(4326008)(64756008)(66556008)(316002)(76116006)(54906003)(110136005)(41300700001)(66946007)(8676002)(2906002)(5660300002)(66476007)(83380400001)(8936002)(7416002)(4744005)(31686004)(31696002)(38070700005)(86362001)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1NjbFVuNlFQaWdvNEtHSjJRNm1xT1NwVlNGa1ZGY0E3WDNVUFNpNDBOL29j?=
 =?utf-8?B?bXdKV1ZpVjFBMmFpUUdUWXc4QjVtME5RckU5bGlRa21oTnpLNDRqaHhvdFhs?=
 =?utf-8?B?LzUzd3NVeUZRSmtyZFI0NTUzUkhnMU9kWGN2Qlk4QWY0VmZ5SWErVWNhdDJ0?=
 =?utf-8?B?dlY3bnc4QVpqcUp1YjloU0JGeTF3dlBxNkhKNFdUNWFrcG55S1ZKdUI4NmZt?=
 =?utf-8?B?QlJHNkRNWEZvK1hLU2NHUXJZamNlNEZLQ2NNMW14SGtQejBTZUFValBsaVM3?=
 =?utf-8?B?YURtT2E4QUs0RWx0Y2IzaVJUUG00UWxMbWZVOWN1cWZCMks5R3FWbGFyaDhY?=
 =?utf-8?B?Y2RrUnM0U2JPczVvZ0szRWUwWUVIR0E3QUppTUVYeWlWbjJDV0RBZHZEblB1?=
 =?utf-8?B?RXRZaHN6VDlWNWs5VXMzTVQ5OXVZU1laQ3gyUHRqSlgwU3lWVFZUUFZuc1JK?=
 =?utf-8?B?RWNrR1JNSkxJcEZGUXh4MkhJNG9sMkRGNGNWenVHZkpvSEtuZGpua3liVU1U?=
 =?utf-8?B?Z1pZaHI4dDlJYnVaa09ic3ZES000ZXBmUlRiQWozbFJJdHY4VnI5d2NSR0Nw?=
 =?utf-8?B?OWNtbkNJdlpITEpkTEs1VVVpVDByTkpYU25WeCtRZ1pNbTdsL3Q1UEQyQVZa?=
 =?utf-8?B?ekU1V3ZFTDZJb3VKeXM3VmhST21iWlRiYThFWU1pWXJZMDNTak4vam5HekFD?=
 =?utf-8?B?aWg3RVlWRERkR3oydXdhMnMvdk5iMklEQjVvL0I2V2l0WUx1NURvZExWbHlM?=
 =?utf-8?B?VTl4SHM3dWh4dFBqOTBrOUJLd01xVVlQQVZBdTh4TjUrRVJUSlNaUHVqd1NE?=
 =?utf-8?B?TzJ2RkZ0RldWWUZsN2ZGQXB0UE1oVUZBcmhyV3N3WldlYWc2SUZFdHNwTVdk?=
 =?utf-8?B?TktTaVVnSitLMnc4WmcyWklvdm1XaW1ob2RqaG54dkFJdjRScmdJOGFLZWMw?=
 =?utf-8?B?WDFNVHB2Z1FEYmpXVjFvbGFXR2o4UjBoUWk2Z0s2QnAwLzdCUEhGbW9OZmFP?=
 =?utf-8?B?U3RIdWJMUWhObzU2TVE2U1dqWmdYazU2OHNTQzhNcmJVaVpKSW0xTEtWZEha?=
 =?utf-8?B?VmtjNk9jaVBFaGxFTU45bU1qemZNei8yTmFGN1oxT1oxbjgxS1pqTWxUclQv?=
 =?utf-8?B?L1hhZ1ErRmlDb1BpL2Jjekl1OUY0cUh0dmFOa0RFMExNbnE3MitaMWI1UWZq?=
 =?utf-8?B?cnVMZE16blErNDU4SjA2NTM5Y3hreHNxbW5HYnFpZzl5dVNwZTN1UFRQRXI4?=
 =?utf-8?B?cVhyVlUyRWVhcEVJUjJoaW05ZGRhKzg2LzZQcGRYdTZ1SjUwMk9qc1U0cVF0?=
 =?utf-8?B?K3JNdDNSTmJCbFBPdlVvdUlNK3dYQUlZQTJldndvTm10ZnArNHF1ZW5pbnFQ?=
 =?utf-8?B?UWYvUHEraUFnUU1mTUZNckkyM1hGY1lqbDMwamhPZldaTmxvR3hEM2VxaSts?=
 =?utf-8?B?MEpkWWhsOWhEcHdybE5ieVBoVzZtaFo0Mjhvakh6ZEhON01VRjhETk0wUjVH?=
 =?utf-8?B?MzcwV3E5K0xEM0lRNXFBVGt2QWFIdThJY20vVFJiMXQ0d1d3bCtVVFNtdENw?=
 =?utf-8?B?dGd4c1QycGNnOGRTNjBZcjA5WnZHZnJxNjIxQ294NytNMHc3V1U1TDdqU2Mx?=
 =?utf-8?B?VW9YTFBwVytyOXhtc2loZ2k2aGs5ZlhlWElRcW5VNHJQUGpId0V4WUFoNWdE?=
 =?utf-8?B?T3BycU1FZWN6cGlwSzdnc2tPOTB3YzlBZkUwdzlHSS92UUdxcWhLbDlsOXVW?=
 =?utf-8?B?T3I2TGk0NU9pNGJ4c2EweUtjWkVEWlQ2VWZta3owQ29NSS8rZXM3SG5uMnFK?=
 =?utf-8?B?eFVYYnhMd1prc0NURzExandoa0lDbEZQeVBKdmhoQkJIU2d5QmtNeWNkL05B?=
 =?utf-8?B?YVVuZ2d4WVB0NGZGSEFyY3dYeWN4UGlFbTNuNHM2UjFubnRRUE1nbkRvS3gw?=
 =?utf-8?B?Z2p3ZlJwWlNSNG43dHlEak40M1ZROTdsc1dTelFPYXh5NzI4QjVDeWsvczJt?=
 =?utf-8?B?andiclkwRC9kMHIxWVllQysxTFc3dTNaN0l6OFNmRDdzek8xLzNodWdtZ2VH?=
 =?utf-8?B?K3JDdUJUalNFY2ZIQVJHVUlBSVFpSkxSYnBDM3VtZ3hxNmRnOEF3QnpDd04w?=
 =?utf-8?B?Y2s0WGE1VUROM1l4QXdzZnRPVnVUeXJPWk9lSG9OTk9pVW9oclFIbE1xS0tM?=
 =?utf-8?B?emc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af6f455e-24d4-4a63-f20b-08dadcc6dd69
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 04:59:50.2221 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wkccF09sEtFNHoUy5BZ7c+CZ0V7gmDsVCCYp+XnIRdBBD806IZeN13ROAT0QLS/5kxSanbOqw+PtDEBOvnLTPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Jason Wang <jasowang@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <FBA671671B41B84A991D83A8451696E0@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/11/22 01:49, Alvaro Karsz wrote:
>> Alvaro could you pls explain the use-case? Christoph has doubts that
>> it's useful. Do you have a device implementing this?
> 
> Our HW exposes virtio devices, virtio block included.
> The block device backend can be a eMMC/uSD card.
> 
> The HW can report health values (power, temp, current, voltage) and I
> thought that it would be nice to be able to report lifetime values as
> well.

Why not use block layer passthru interface to fetch this instead of
adding non-generic IOCTL ?

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

