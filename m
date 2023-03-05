Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B249C6FA8E
	for <dm-devel@archiver.kernel.org>; Sun,  5 Mar 2023 21:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678051938;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sRzTiId34mQLFHq5u7GK8SC55IXvBLiryZnHr/f7lEM=;
	b=KkODnlhJ5rlkgYu2oSg6xK8v570v3QGj/mBpEgCTwuEsB4DEOlMe9Vp/w4//JYshU/Ikkj
	yOg8exhGxSNdhC2gX4fasnXP3E/2oPMxlkC1fQXsMAMs4Fvq5jxs33WGyW5ZjTb11WZHjR
	M8pV+wVpVLQ7PJVpPucvq4Mgun29ryA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-r8JZi7RCMH-8zBOenHjDAQ-1; Sun, 05 Mar 2023 16:32:15 -0500
X-MC-Unique: r8JZi7RCMH-8zBOenHjDAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D09C8185A7A4;
	Sun,  5 Mar 2023 21:32:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 812082166B26;
	Sun,  5 Mar 2023 21:32:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4EABB1946588;
	Sun,  5 Mar 2023 21:32:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F3B531946586
 for <dm-devel@listman.corp.redhat.com>; Sun,  5 Mar 2023 21:32:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BFFA440B40E4; Sun,  5 Mar 2023 21:32:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B70A44010E7B
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 21:32:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9492B800B23
 for <dm-devel@redhat.com>; Sun,  5 Mar 2023 21:32:10 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-AUYt-8rLPvugNIVpVtE0PA-1; Sun, 05 Mar 2023 16:32:08 -0500
X-MC-Unique: AUYt-8rLPvugNIVpVtE0PA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sun, 5 Mar
 2023 21:32:06 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Sun, 5 Mar 2023
 21:32:06 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>, "bvanassche@acm.org"
 <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>, "linux-block@vger.kernel.org"
 <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Thread-Topic: [PATCH v4 13/18] nvme: Add pr_ops read_reservation support
Thread-Index: AQHZSHgc3xJ2ofNqXkeIdkRZxLK3/q7swu8A
Date: Sun, 5 Mar 2023 21:32:05 +0000
Message-ID: <ce7d9459-d672-6389-99ad-dd6b2c141902@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-14-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-14-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7864:EE_
x-ms-office365-filtering-correlation-id: 91992d17-ea3a-4ff8-9b24-08db1dc11150
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BKz9AUDBdB7B1gmlMhhpXQBKtV4PeB0uLT+fqoCdkil7uz3rFkz0/qe4d0CuT2ObRIgoT/cio7IL/NBcMvMbtG9BV24pwJ8GWEzvchQuTXXw5G6e1WBwiKDeJA17VQF0c8T3wJE6llQS3NmleYlnUdT9H+5CdEiWzeJ5uFj1x/+EcoZJmL03G5uQEnzr37Vl1eA1ATa2CjguYvGhNrJcXAZD6ZVG6nj1pAnMnGZ6C30a1is9Sve/ELBbddT3j1yNilAVplkbf5QvjYYd7SiSXiY9iETRr+UIxFU4Fv8PSJ1lnJFY4gscITlkCorIFKp6f4VGPdkrfe4B/KQCcPuTaAieX3sr6gCQ0lFDj3eWBjYlUaaUH69IQXvt6l7pFiMx3B3OrT4+NYp+0F8U4RMOXqVjvRsMoaqr5PoqaA/Y8Hh5vGtjdC0ICB/ZSVI3qRvBzXHLLSoIHc5VJt6Z0lzqtqInN8vstipt/2BorNdOhn//pJm3mG4IQiRR9ZtBuj8S3E2RLMUIo5F1vzcrgAo4GzuX9+ijNuSZ8QF/n9i0E7RVF6DCXrCuC4Q1lOYmapjDNkpINBaoJZ9TJUYwACG2PL77FAk4FuTAX5YT+BCUrxHHY3ubwQWb/i4kUWAgw/tp62nx2KxtQaZIiZDLR9b40qxEJoxS/wvY8/UOeswBmH0BO/8V9SVZaZz/iflC/VEQgsqwF+FEkunew9BvM40JGyGiGGv8RHKVB3TgsxbRB8m8KpbTkYH+bKKk3lmA3RdR8jhzRumosq6+eVIhjT1g/G0T8aI06TFXfRHWl5XwJ7Y=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(186003)(71200400001)(6486002)(38100700002)(478600001)(91956017)(66946007)(110136005)(83380400001)(64756008)(76116006)(66476007)(66556008)(66446008)(8676002)(53546011)(2616005)(31686004)(316002)(6512007)(6506007)(41300700001)(8936002)(7416002)(5660300002)(4744005)(122000001)(2906002)(921005)(31696002)(86362001)(38070700005)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEVZSExsc2xrK2NncytwUEEvR0g2UHh3cStNU0FCVFJ6WGhDTng4TEpDUFpx?=
 =?utf-8?B?WU1nYi9UUVAyQ3R0K2F4MHJVOWViaHB4dXRmRjVYS0JPbmpHOUtCSDBUQ0tI?=
 =?utf-8?B?aWtLU3B4d0J6b3lEMmttV3pRQTBXYUZPSGJqNmtWMDZ6YzlBNjVPR3RoOE51?=
 =?utf-8?B?NzBHOXdRRzJqemwzK29CN1YzdDJjYU1Cb3V6ME04OVhqM3c1UlBzMU9QaDNl?=
 =?utf-8?B?eGZXNERxSFVBZElJamtLS093a1RJRlBTSmFyRmduTnYwTTZiZzJ6VFY1UVZp?=
 =?utf-8?B?UC9yMmJTZFBFaXVpVDFpRjJEZ2VpSTB3WUVsMUMxRWVTMmdNZFRaV0tmTWti?=
 =?utf-8?B?N1pjSHM3dnY3Y2F6a3dEWXp4Mlc5VlJOdVR6MFJZRW1XWGs2SHJvMUdkRTk5?=
 =?utf-8?B?MWdidkllS3UwY1puVUVjS08yNmQyTjZ6WUVxUVhtTGF2MmhoYWIybzVJd1Ey?=
 =?utf-8?B?d3ZNc0E3Z29NVklxamFFRjlmdVhoek5nYUV0eWhUSGo4OStuUFlNR0tkK3dI?=
 =?utf-8?B?bXJtT0RoeWNoQkxsZ000WjBEaTRTU25UZ2NMKzFHMDRLMVc0ZnFQdjJvNFc1?=
 =?utf-8?B?RkRubktJZXJuR1Y2SjYxUWxrNkNxTHg5N0xFWGN2ZzVobERiRHk0a2VqY1hN?=
 =?utf-8?B?R29LcEV4VWY0SUZLRlVSV01nQWNGSjNiSVBBZ3VOMWNqbHozczJYTGZMU21i?=
 =?utf-8?B?Wm9pL29vakN4RVZsTWY1ZWdZdk5XV2RBSytUY29LSG1lQUMxbEhKWTJSY2tz?=
 =?utf-8?B?THpKRkhOU1d1Sk42ckluSUMzUVJ3NkpJdUVJQjdpdW1QV2IwemxiOFdROEZF?=
 =?utf-8?B?NzJSc0RJTzd2RXBiNmEybnVBVE1HbnhoTVN3RVIxWkVneExpK1QvZUF5ZXNG?=
 =?utf-8?B?aVh2Sk0xd1hVMVIwWnp0TSt0aEFCaExpdFdpc21YMzRVT1F2ZG1HaVl1Uk5i?=
 =?utf-8?B?ZzRZMlluSUR1WjN0TGxLVVZnV1oyLzM2YW15aEZqczdaZHNDaEJhMThpdFFZ?=
 =?utf-8?B?R1ZzMno4Z0R5a0VCU3BGd0dUc2FLM0QxTzEvczBxb09sdnJLZU1UNkZGODZm?=
 =?utf-8?B?ZVBpOHZrM2V2RWJTMGU1OS80S2tPTjBaTjBka2NJb0hqYUg5QkZ0TVFFaUpr?=
 =?utf-8?B?K1hJQjRob0VCTEtCNS9sK3VpOGRUaVZOUDBrMENHRTg4Ty9IZlRQTGlicVI5?=
 =?utf-8?B?di9mOEFKaFp2UnB3WG1hbDhNM1hRUnFOVHpaUGE0SnRUV0xDand3VlhONVlm?=
 =?utf-8?B?QkMvSnRqOG1yU0pxRHp4MmRIYzZlcjErd2pFYmRZc1dRZm0zMG1UR1dZR0Zq?=
 =?utf-8?B?akM1bGQyRDM5Z3FIMk1MMlFQU00ycFBZS0xUZ1ZkSWl2ZnRRNFZhWVZkR01N?=
 =?utf-8?B?US9LNWJsMThZUEp3R2pldlFmbEYxZGJYc0NieU5yUTR4OVo5d1dJSnltNEx5?=
 =?utf-8?B?UE9ybXEyMDZXQ1hxY1JFdnVRVzhMYUF0Q3dZeE1LNnJ5eTA4dEpIYTZyTHMw?=
 =?utf-8?B?djc2UzZqOUZ3R2IyVlowS2hsajluNFZqSXlWMmlaam5MU0twazVWbnNHb1Bu?=
 =?utf-8?B?b09zZDdLL2RaV2toWUF2aEZyNndLWXJEN3ZuYjN0K0xlSXJTZU84QW5qUERp?=
 =?utf-8?B?WExBbEtrSDlPelMwcjF3alhPME9sQ3RLcVhmLzhsUk01azZRWDcybTN0UGFs?=
 =?utf-8?B?YjlhMFVxOWZXeEpMd2gyTW52WlRKbHkyK29TUWI4RlZCMjd1R2Z4SDZGdnFX?=
 =?utf-8?B?RFpQK1hUU3U4b3BNVXFidmtsWnZXeDRMVEZqb2NoS2NkV3ZQWlRKMEFFelhu?=
 =?utf-8?B?T0RycUFpOXF1TFYvQk1BZ254YzkwS1QrbGsyc0djTkxHa1Z4WFNoVHFvNEUr?=
 =?utf-8?B?R0I0a2ZjSU5KcUZVV0FVS2QyNU9RU0I5MjZuYk04RnoveGlrbm1ab0tnbEJm?=
 =?utf-8?B?MTVlek9FWXFRRVRyMFhhZXJiekJBOFJCaWZFVzllMTZnSUYrQ0ZDeGkzVXJI?=
 =?utf-8?B?ZCt4WUl0U2t5eTJRQVFyWUhJNmZtbWtldXVGckZTdkFkd1VaOEQ4MG41WmdG?=
 =?utf-8?B?K2pkWWdxM0lCNUpNS0V6dGR3SS9zQ1NGYzNnbkZ6NDZQTU5WYzQxT0NDdmJt?=
 =?utf-8?B?RGVHSjlwc204SnI3amVrdkJ6VDBDSWJxTGhuZ3RMWFM0K0tMUlBDS2laUzFO?=
 =?utf-8?Q?0rIWKxxnUvZuW2lPmCUUv7oQSFeQX755h5KMlr3J8vXL?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91992d17-ea3a-4ff8-9b24-08db1dc11150
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2023 21:32:05.8821 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dSeHjKjoJvf2CxX4HujPi0Vb7XU7ZxrUHW8zU28M9zUWth1uiWdeAmK+XqEjXRho6sdL8UXfI990w92GfaxfRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v4 13/18] nvme: Add pr_ops read_reservation
 support
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6AE43FA79600114A84A33EA6962144F1@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/24/2023 9:44 AM, Mike Christie wrote:
> This patch adds support for the pr_ops read_reservation callout by
> calling the NVMe Reservation Report helper. It then parses that info to
> detect if there is a reservation and if there is then convert the
> returned info to a pr_ops pr_held_reservation struct.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

