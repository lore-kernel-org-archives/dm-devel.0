Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43EE7C7619A
	for <dm-devel@archiver.kernel.org>; Sat,  8 Apr 2023 08:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680941262;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OWHjJuiVhIWE3NZoMHN6PBiOZd+KkZse3gYAPMeI+eA=;
	b=KXWIh1rr0FShVVjZtQ4P5u8jTiukc0YvclzJJX32MOgrVKfp7SCCIyyrxNl5lLwQi5btIz
	LoluCXmrXi1kkvDbtXCXWz7vPtG0ILc3l92ihlJ+I2XvbQ+LArWT5g/Vun+115M6qNZtm3
	k5BDUU1hGqnmqy2iP3wZ4fs0bgjrvmg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-208-WweLC0YoNgSz8jBsCXsr2Q-1; Sat, 08 Apr 2023 04:07:38 -0400
X-MC-Unique: WweLC0YoNgSz8jBsCXsr2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C68D685C064;
	Sat,  8 Apr 2023 08:07:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B52F02166B31;
	Sat,  8 Apr 2023 08:07:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 89E9C19465B2;
	Sat,  8 Apr 2023 08:07:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9C1A1946586
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Apr 2023 08:07:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7D39C1602C; Sat,  8 Apr 2023 08:07:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BEE9FC1602B
 for <dm-devel@redhat.com>; Sat,  8 Apr 2023 08:07:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3540811E7C
 for <dm-devel@redhat.com>; Sat,  8 Apr 2023 08:07:34 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-6VoiBaIxPquYBM5hwxFFhQ-1; Sat, 08 Apr 2023 04:07:32 -0400
X-MC-Unique: 6VoiBaIxPquYBM5hwxFFhQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SA1PR12MB6920.namprd12.prod.outlook.com (2603:10b6:806:258::5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Sat, 8 Apr
 2023 08:07:31 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6b01:9498:e881:8fb3%4]) with mapi id 15.20.6277.034; Sat, 8 Apr 2023
 08:07:31 +0000
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
Thread-Topic: [PATCH v6 10/18] nvme: Add helper to send pr command
Thread-Index: AQHZaYyA48OVHNgtc0e0ieM0lYEImK8hDzsA
Date: Sat, 8 Apr 2023 08:07:30 +0000
Message-ID: <c05f7943-2aa1-5860-ae94-1630b5d56a07@nvidia.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-11-michael.christie@oracle.com>
In-Reply-To: <20230407200551.12660-11-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SA1PR12MB6920:EE_
x-ms-office365-filtering-correlation-id: 138848e3-5676-4324-8c83-08db38084d3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: EZIbDymR/+YiHp62u8RnbExZfC05AnKCOW86O9897Gf1bBpcXdgJTdL6ejzznymEvaqbCgjETwxQ7toJXMtlMwCezQMtB8/1uI3K8Av1Gs4gSzcWU9GwFm0fVo2g/AS6CPwK3r71OjdT+2fhXY9kNiEhe5O9FXaiwbT42UepAhbEEr/eCwl7rAyAoMk597leu4jKbV3avKDX8EXReZb4U9UJxpm+ZMA21osrmvmtqICJJlLntdRUJ0CuuTJ1XQETXogrSPNR3gzKyxXHG/b6QUU2k72nWOKElnhOJHqM4+zBjRcURdeBMwvG2b2iyguzenW+G6qXHZMUxp+2uwM9d+jZUSNehMx9YGI7SKenMhMwOSoiwmOSQRlsbhmsTr2p1lrDMk1vI/U9OlyP3765PNLkevRdP3WY4ksEmSl34zjPGhJu2Y+jcKvkJaqnBTbr4MpmU8u33lqOvhN4I4ADLx9pKKhIP2ug4BkLo4tZ6YV+7njoYcN3vbSMinCxXVbVuv9eDIholfKFvUeAhFoLMRwIVdeO3nAY1oHJ73ZchGPC+jVOJKQ3U5Z61nNMjtBU4caYtqhpw0vnSp9pkRoZNgdQW0/kEp8bpyutKEy2OdSSPciQ56vxV90hOoZT12n1e5bqjkUzpejWjLu82Q9AtqZyo0DBGeV3IHX3k8UjZg72gydeb2KECqAhJxmtq1QZ
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(921005)(122000001)(38070700005)(36756003)(38100700002)(31696002)(71200400001)(86362001)(6512007)(6506007)(53546011)(2906002)(66946007)(66556008)(41300700001)(66446008)(66476007)(8676002)(64756008)(478600001)(7416002)(5660300002)(31686004)(8936002)(316002)(91956017)(4744005)(6486002)(110136005)(76116006)(186003)(2616005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anZWVlE5VkE1blRqZVhsQ0dKWWh4eGJXbFVoNkFxZXBXNkZWUk4wR1FKcHlB?=
 =?utf-8?B?dnZQUmdieTNnRFljUVJNckV2MStPUGVRYnhwczB1dFFSZ0M5d1ovSi9JcW0z?=
 =?utf-8?B?UVpoR3hvUnlqN01qR3Z0M0xyTlR3cUZKQ2t2UDVxeDN3c0lSK1NYWm9aY0lo?=
 =?utf-8?B?NWpTdmVxNVExRWEvT3c2TG9NL3FxaU05ZWVzUlQ0QTVveVhTSHZuQVhJV2xK?=
 =?utf-8?B?Si8zaEhQenRuY2Z3MWJSeC85eFZ5RHVLanpjT2hYNGNoS3cra1BZSW5TQUxK?=
 =?utf-8?B?dlFwVUIwR3VaTm1xRXNZdDJaSnFKaTdaRzlYcnlqK1U2ZXVUVlVLRTc2VlRh?=
 =?utf-8?B?VEd2eXFJZ3NiM2prVjBwWUo3RzJXcXAzODVZOE5MWndvY2ZyU01XK3pvdFVZ?=
 =?utf-8?B?Wks2TW9kUFF2WnJwT0ZmdVVEV2xkNTVxNlNCTVp2VHpwb1FsMTA1TUtMZ2NI?=
 =?utf-8?B?Z3RVeVJnWDVLV1J6NVRvRFI0ZUNTMzVHQ3Q0Nno0azFYTWNCK2EwTXZzbm5N?=
 =?utf-8?B?eVA5Vzg2cnBhZ2poYnVFN2hlTzV3VDFycTN5OEkwT2N4ckIrZ1Fra3JMVUIw?=
 =?utf-8?B?eHRaY2c5R2t6N1lOVDRVZHIxVEVCdHpyRi9mb0hIWnBDSEdBY0hEemoyOWow?=
 =?utf-8?B?RkNFQ3dSLzNFNkMvcHVzc3oxamw1cndhOE5FYS9ZTktnSThvdGd3VFpidHhy?=
 =?utf-8?B?QUpJZjd2YWRodWRRUXhDL2c5NHRXZytWb3RsMHgrWDNlTXJvOUVxWmxHTnFy?=
 =?utf-8?B?bGdDZU5Vc2xCYTVyM1kwTFN1NWlTRHE5R3NncU1EdDJXRkRkSzZFWUIrdjFv?=
 =?utf-8?B?N3g0ZUVEb0syaFJSSHBaNzRCbTBQTDYrWkNQNWN0Si9SeHhXVElXU0pialpO?=
 =?utf-8?B?V0RuUmFsVUFKTklVb3htOVd6bks1WGFEZkdQaGhrVzZRelI0bUk2aWNLa1Fi?=
 =?utf-8?B?MktuU2Q2QnFkMStlaEdXVXRKSzdwUDBkQ2orR0ZwT0t3Y0VYbERzZ3RWUUVU?=
 =?utf-8?B?OFFlclgyWnJCVTlqS28yTUZzaGp0ZElWTG0vYllMT0N4S1BGMkdwdGFCVnFx?=
 =?utf-8?B?T0Vlek85M2JCejVVQU9Ld044eWplZWZ3YW0rN01WOXpIRU1PWVRsU0JvQmk4?=
 =?utf-8?B?VUtYNEtRNXdiV0NRc3IzVDlzM0ZqUHNrWTI1bEdoS2c1QmdyLzA0dU01V2tm?=
 =?utf-8?B?dXNVd0c2azZUMm5GZEIyOEVoeTV0SjBPemZOODBnWVQyNEhRT3JTL01NbStX?=
 =?utf-8?B?ZlUzVEdTTWRoV3Q0Smc5T2M3a1BMdEdTdzlMYW9taFIxaU5zdWcrQjJOd1BH?=
 =?utf-8?B?NDJnTzJ4L0lCZm5WTlFJSnVLaDZuRkhrYXB1ZnlJd1hDZ2c5anJnb21UQWEx?=
 =?utf-8?B?QnZyUzg0V1ZnR2J4ZHdydlR3KzEwMDMxemUrQmI3MzhscXdEY2lPQ0JmbGJq?=
 =?utf-8?B?YzEzK1JuNU12cTJJeVVJeGRLbDFrZHU0QVZ2SWN3ZWtrQjNPaHB6OHRZcUJm?=
 =?utf-8?B?eVVGZ1J5cDJPYzNPc25idkpab1JNR2FsREQ5Zkw1NVNvQk4vSHpPMEtJYmJE?=
 =?utf-8?B?OFZVNGJFZmNnUTF0YmhuRlBvTkVEcXk3dUh2eTdjMExrRVFHUkFKWEtzdWJp?=
 =?utf-8?B?M3BkdWprMFRvbE0wV2JXeVZjTDk1VENLOTROTDF6V0lwVThSNDE4SnpWazNN?=
 =?utf-8?B?Q01SOE1TelI0d3ZKVUZCam1ncmd5NmRYSW5xcFlCS2pxcUwzam1DUTlWRXhE?=
 =?utf-8?B?T2NiRUtlOHMzOWk1RjNycktXVHpkVEtabmVMWFhJZURtMEVnYVNlbDZHZ1Jn?=
 =?utf-8?B?cEs3bjJEeFBWd013S0VvbEtuejhoV05Zb1ZpSDZrMll3emFHK1ZpV2ZWMmtN?=
 =?utf-8?B?TitzRHp1bHdoeUdNaTUvWjViRnFtamhLTXYxQUoxUDIveFptYXZUSStVelR4?=
 =?utf-8?B?YSt3aG02M1VrRTNoUkdGZTVNSDFVbTlhYkZja0Jyc25lRUlnMXFtd2wvenRQ?=
 =?utf-8?B?WkVvTVZTS2FqUXJpY1JmU0gvUFRTWjluNUQzZTZMNTlmVTM3c1ZSMUFtaVoy?=
 =?utf-8?B?SlJQU01JR0kxZVp5YTkwcVdndW5GOUJoVjI1aVJ1bmhKRnp1cXFqdUFkcENn?=
 =?utf-8?B?SFNvWGwrOXcxaGJySVlYbFZjaHY0dEdhSUFLeWV5NWRaNEF2RS9jaXA2WXBS?=
 =?utf-8?Q?C5ZNy4tia4utIeFUfI4V2gcMIfc4zWn44F+YLuY1X9Np?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 138848e3-5676-4324-8c83-08db38084d3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2023 08:07:30.9491 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tynuRKX6vusWELjh2FCo3YwsKFBjVbdftpOPIbN7SEq8qhAjsvKFv/fv/+r1DmyrQ8XDCXgz7IvF44w98PsWFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6920
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v6 10/18] nvme: Add helper to send pr command
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
X-Mimecast-Originator: nvidia.com
Content-Language: en-US
Content-ID: <1374082C3089744095DAB6D0DACC6C5C@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/7/23 13:05, Mike Christie wrote:
> Move the code that checks for multipath support and sends the pr command
> to a new helper so it can be used by the reservation report support added
> in the next patches.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

