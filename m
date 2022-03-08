Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC748C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  9 Mar 2022 06:57:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-x-u764enPAe_q4VG3NJH_w-1; Wed, 09 Mar 2022 01:57:03 -0500
X-MC-Unique: x-u764enPAe_q4VG3NJH_w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10A9E83395D;
	Wed,  9 Mar 2022 06:57:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 10A5E400E103;
	Wed,  9 Mar 2022 06:57:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA1161932105;
	Wed,  9 Mar 2022 06:56:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E0A7194F4AE
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Mar 2022 22:08:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2BC0B7AD5; Tue,  8 Mar 2022 22:08:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 25B317AC3
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 22:08:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CD373C021AE
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 22:08:46 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-1tiz-QS6NauyWY5ZbjZNdA-1; Tue, 08 Mar 2022 17:08:44 -0500
X-MC-Unique: 1tiz-QS6NauyWY5ZbjZNdA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1446.namprd12.prod.outlook.com (2603:10b6:910:10::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Tue, 8 Mar
 2022 22:08:41 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 22:08:41 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 3/5] target/pscsi: remove pscsi_get_bio
Thread-Index: AQHYMrQLw+FoPzw/ekiea/UAW8GAUqy2DLuA
Date: Tue, 8 Mar 2022 22:08:41 +0000
Message-ID: <562b5704-a403-0fa9-d9d0-2f955796d947@nvidia.com>
References: <20220308061551.737853-1-hch@lst.de>
 <20220308061551.737853-4-hch@lst.de>
In-Reply-To: <20220308061551.737853-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ecd96c8-972d-4c79-a1d4-08da01503494
x-ms-traffictypediagnostic: CY4PR12MB1446:EE_
x-microsoft-antispam-prvs: <CY4PR12MB14465517FE96EEBBADC0F3A1A3099@CY4PR12MB1446.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: r2OCb7V8n74BBia8thkIInazXML0rDFMklvHZOWje48Vzv6VcJF/ejIaZgNqy2SVaUn2XIIYDOEvg672VzMafretBWvPZKKcj9Z63sybez6I1+d72C0CvHtcQxf4/4NylVLfHLpIYC3ulY4ocq5ltB2g7mBt+JRtDi1HcfXrBIOifjWyqxcnyhWihE4VEJEyUcqU9aj5mEs7BvJm9KhV3ht9KeLcxN8u2hy+vwJm2BTjl9LnreMo/KuNsD7kSpMspBK3nH+VTfiJqNBXlYGNdvUnVi6+0fqt8hzezDNVy7GdG4pVlPX6PWHFz66txh449zV+RgoXQzXQE+EJCvE2KFiWJfdCf0l6Iyr9jDlybOmbDk3USgsk3HaqEtc/f8r8gmqBRx9ocEOWxLbJJjTtERbUI9mZTHaKLGN7XkjhMOTczjL7N6336oEaQ+NJ9Rv/6tejM6RiuzFeOpLIwOK0Rs1I5ZzFiiwxLsBi1GTO/YnpUI28NCyV+xEZWYcXa4isDobtsjuaCrlKKjnQK/pAekL88GqQfWMapCyvNbTlGAqt5pGu3tQ3Y5J+afQaZMqmO7pg3GOAoKvR7ecIYKsgeFu3V+sLKdO8Bif74xXoCBJ2C5l/xDkwz0QkNfYEt6dOIrzr6wc6pPDPaFdnhejoD5QnTSOuFgRKPP5S58H3rD0BaIyXJtpVs44LGAYVAI8i79ll1mLygjbAgA/eqbW4SUCSjzSYwMeEkeGh5LrtL7kxo0h5kunGvzwHJeOQs77PovR7hPru4v2UFjt/kLOCTA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(186003)(5660300002)(91956017)(8676002)(66446008)(66476007)(66556008)(66946007)(64756008)(76116006)(26005)(4326008)(558084003)(316002)(36756003)(2906002)(8936002)(7416002)(110136005)(54906003)(38100700002)(31686004)(122000001)(508600001)(38070700005)(6486002)(86362001)(31696002)(71200400001)(6512007)(53546011)(6506007)(2616005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzhGTzg4KzRMVUhkNHhEa0RyZjNkS1YxRjRqUTEyVS8venFrN2o5cFVzOGNw?=
 =?utf-8?B?L3ZsdnN1WS8vMm9ULzBJTzFFbVorTEVNcnl0RDFNWDY5ZS8yMkhsRUtEUXRN?=
 =?utf-8?B?TFA0VTArbUM1enpiS1VsTENEdDQ2M3o3S1M5NGtKcU54YWxtZzlqSEdST1Nm?=
 =?utf-8?B?eFRQTG1zZExYRlFJNkZsZHA5ZnVrM0FBczRHL00wTlNwZzQ5QUdRMjZpT3hU?=
 =?utf-8?B?QmFWUUs0VGFQbUphK2tNUk9Jc05lYW9tamlYVkFEVnlOMUNUU0lKc1pKZWZ3?=
 =?utf-8?B?eldSdEZLNjlPR0V6bDZzYUxVb0F1VElpN1pHeGtZQnBlTUZvMkI5Rkw1d05u?=
 =?utf-8?B?MEpid2xudGltdjVmZkFGY1NTTnNKMGdmVnVVeGlMdGtPNEdMWEM4Yzh1M25l?=
 =?utf-8?B?RXZDSzNYSm95Nksyd2ZuUUc0ODA2dU1IQ1FySnFyM1ZZSjFzc091aStjL05P?=
 =?utf-8?B?am9WZFQwc3g5NXZYRk9ZZmMzWUFJb0ozdFB0UlR3cHo5R2pnajVTdzJsdWFD?=
 =?utf-8?B?dVNScUJzSjRYc2xNRXA1dnhDOXkyUEY4ek9uQ1lka3V2T2orNEROR1FMbW9J?=
 =?utf-8?B?c1JjUFp0ZU5wbU9Ub29jWDlFbUdnRzZjSm1oaWZYNWVESC9ORHhLNGdlb2dp?=
 =?utf-8?B?V3NrdUFmTk1kSWQ0Nlk4NnU2dWJSeWlrT1FiU2JUZTg2MDU4a1MzMSthK2F5?=
 =?utf-8?B?Y0syOWVJYjdnRWZsV01Bei82UzRGa3NmUlpiQS9ESWhuYU1jTXMxWjdJbTdy?=
 =?utf-8?B?RmZwMGJudUVIazZDQjFHUHZPSnh5d0Y3NE8vS2d2UTlSSHNsUm9DVkp0MkI4?=
 =?utf-8?B?L0FDUFRwNDExL2pvcGMyVWI0RS9EaXVuanhsL2hGRjNiWU1RL3htNmxETndm?=
 =?utf-8?B?Y09XcHI4dnQyS3J0cXBTZFBOUkM0Y2FnRGNOeU03dmw5b2xtZ2xPZGNIM0Rx?=
 =?utf-8?B?QU5ROUE3QjlqaWdoY1BvUmljTWFrV2dtejhRTlVOTGsxcUxRbFppdGY5cnY1?=
 =?utf-8?B?UGp1VmR3a01JYXp2bDRrK04yUUFDVVJvU3BqcUtSeEkyMng3UjM1OFpqcUlt?=
 =?utf-8?B?UHZ5dFVmY3B6RU9MdXl0YkF6UTN1dFZwTlVjbnFWaWdmOUZOQmFTeGJ6V0dr?=
 =?utf-8?B?aWh6Q2I3MUs4UDdtQ05uOEI3aDRTSGNENFVGWVlmTmFiZWdQeHViV2RjWjRz?=
 =?utf-8?B?bGJ2YUhzZmNPcDdhWnQxYmc5SzdUa3dWSEUyL1NXS21JbWZEM1FDWkJiSUNj?=
 =?utf-8?B?SE1LTlVsMG5lYnJPUDhyeEs4b01PQVdiS3FvRmlJbkFISCszaGxPV1pheGlr?=
 =?utf-8?B?ZWMyeCtnNE5XMUpzNlhvbXprNDFwcVhrUmVtR0JHQlpGTS9VOU1IWlBVOFpm?=
 =?utf-8?B?WGpsWWZZLzhEYzN5SktzVVVCU3BQc2JyZlpYSThqalUxRDZQZTRVQWpJNHZu?=
 =?utf-8?B?aG51S0hBaWVSeE1rdkhlV0RubENUY0RMUGlFYlJrdzMrc2pUMXMrd1dTaFpa?=
 =?utf-8?B?ODdFRkxMMURGUFowN0FObTJwR3k0WUY4SDA1Z204dWI0aHhEWVhtV2JLQ3d4?=
 =?utf-8?B?NmhjeCtLRWZkaFJWMXVOdklJN0FWaFJrRnZnZ0pCTnRvQzVYMEhvR3dmbmlB?=
 =?utf-8?B?NTY1OWl4OEVTaURhSWpPLy9SN05sK05XeS9GaEZ2bW1ORjdLeVU0c1hoQmdm?=
 =?utf-8?B?YW1Bc054eDRQbDY5QmZSWmdTTHN4dGRYS01NWUEyMTBRczc3MGdwenh4anZ5?=
 =?utf-8?B?R2hmZTNXZFNXdlNCa3Vhb3J6UGl5UWVwaVpKWE5xVEozMHFuSkVUenJnTVFu?=
 =?utf-8?B?a1FXZTJ3cGRXYTBteFBzQTlPQUlYZnNrOVhNQ1NZSnJVbEl5RXc1YVlSbnBZ?=
 =?utf-8?B?akdmY1oxTHJsc2hxY0tPWXQyWlBBVXZBbVM3ZlQ0Rkp1WUdDM1ZBOGZicDB0?=
 =?utf-8?B?a1REMmRwNzZUWlFtOUduOTU4RkEwc3RmaHQ5b1VsZEdwZzFJRTBSdnQvVVVX?=
 =?utf-8?B?NEwyc2gydDVTQ0VaWFN0V0dYa2FCMTI1TDNQOU0rdjZOSlRUR3Iwb1FKTEV4?=
 =?utf-8?B?d0V0TG9FbDAwc1p6Y3IwOHRNOHdVRDIvelAwNjBQdGE3bUQ3a0I1bEJvNDg2?=
 =?utf-8?B?NDJUZjVTWVRpeXErYTAzU3ZBQnhHQ29VVlUrdFFoVGVlRTFseUZxUWVwTHJT?=
 =?utf-8?B?a1E9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ecd96c8-972d-4c79-a1d4-08da01503494
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 22:08:41.6576 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CNW8lCB2SYZ7PFrdJIssIegKOcE4Hmm9c0KSh5ShyJ6LbwJQnilcS21F9th3L03diifrgM+LosIXN8ayUrzGAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1446
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Wed, 09 Mar 2022 06:56:59 +0000
Subject: Re: [dm-devel] [PATCH 3/5] target/pscsi: remove pscsi_get_bio
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
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A62A05069BE16C4CAC0AC348EF086F8B@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/7/22 22:15, Christoph Hellwig wrote:
> Remove pscsi_get_bio and simplify the code flow in the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---



Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

