Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C66C4332F
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 05:51:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-gmZURNg3Mn2aU3pctu52yw-1; Mon, 07 Mar 2022 00:51:49 -0500
X-MC-Unique: gmZURNg3Mn2aU3pctu52yw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04B27101AA45;
	Mon,  7 Mar 2022 05:51:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E692F401E40;
	Mon,  7 Mar 2022 05:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 798F41954D5A;
	Mon,  7 Mar 2022 05:51:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 60C98194E021
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 03:07:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 43E3A401E40; Mon,  7 Mar 2022 03:07:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F776401E3B
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:07:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 269DA299E764
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:07:36 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-EtXb5svbMka80vsamKuHHQ-1; Sun, 06 Mar 2022 22:07:34 -0500
X-MC-Unique: EtXb5svbMka80vsamKuHHQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:07:32 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:07:32 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 05/10] dm-integrity: stop using bio_devname
Thread-Index: AQHYL/Hshqa98ikaMUeGTu4rt8c7H6yzQRSA
Date: Mon, 7 Mar 2022 03:07:32 +0000
Message-ID: <da960eff-68c9-f7d6-20ff-526fc3a421a5@nvidia.com>
References: <20220304180105.409765-1-hch@lst.de>
 <20220304180105.409765-6-hch@lst.de>
In-Reply-To: <20220304180105.409765-6-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b9ea44a-fd88-4bd3-707b-08d9ffe79f39
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB18532F3CB83FAEF8F2B0B751A3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 82e7hwojzYbVjGPqBm/WTjVqxYXALhhjGcyKP2i2scYu21CWLv8fPhpCfgraypvza5GfQ5RWrUYJuaer1kMYbMQCPZM4NCEIIG8UnjLHun0V/IM80hu5hI4/FPNpqgQF1z/RhlmYqpOzov4Uc2+vKPia6ulFIr4K6dELgPuNzKfVV4GfeLpGJcnF/UqiWzFDEu3ld7F+SZGIIfa+cy4Aj2QWSdsBbRGqp+Z3Xqh1IzhTJvp7CUhcuu0hwlQ0qADtXz8UsMf7bkx0DYDlgqovpNsR8uQTU4GaZKwIcbgY1REeaNt5shfdvaBSP2MYOBxPkf01Jpwbj4gPvORKzR8FS3gVpqpAZbLKGdWnlp6IgQRHGiIGFRpWTCVX/tbia2iPjDmYiQuzPEWBFQ0ENogiyk4/7hyB80NiJwpt5IwP0K3GTrCAtfR4dN/cU5JZZcYEnjSKiaNTnysEW7Zlhue2CMZsXHL9Rv/eo1bo4NghBl1cRyQ7MVvdNyHKzIx0XdNIkiBbZVxjOGpGSHOCi1SJ0BxYMEFlaU5GKb1cLcT6MxNsheZfRY5aTWb/Jw0ISNV+PeJ82c4mjZ3QrOCqMhb5DwpNVEMvS+hwv/H60u0lkOwPHlTfCTEZcBdN/wkH4eBL6rzd5P++5UA4a8Nmat3p32vW70RJ8sCn8keVQRMfxSeEwjDo4chPzoGRLZJDEROk4Oatl4VSMMfN01Th6q65Fk5bjmjxP7tyjeO2kn5eoaGhK1lB2DbeQCSSv398Dkettv/FwcCerCfmhokDVaz6Zw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(186003)(5660300002)(36756003)(110136005)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(558084003)(76116006)(38070700005)(316002)(91956017)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVVsT1l1NDF0VXBaY3FjWFBWaFVEYWJrZ1MyTnhqL1lKaTZxbGR0LzJveUVz?=
 =?utf-8?B?ZGNvUmVLb3UyaDRTVFNxWGZrZWhHQmFuS1BpYWk3L1h0WUdhVm1aZnpUR1gy?=
 =?utf-8?B?Y0ZOTGtqT3c1VEhrQ2d5ZnE4eTFYMjMxT0ZlbCtIMjRXWWVkakNQVlFpbVd5?=
 =?utf-8?B?a1FmOTF5YUtlbnhySm1uVjlZeHYrTUhtc2I1MStNT1RkUnd4TmhTV1kwakE5?=
 =?utf-8?B?Wjh1UTdFNHduWW9nYXdSYkR2NGU2NS9yVE9IWGFTRDRZdzE3RnJZUjlHSGpo?=
 =?utf-8?B?eFZPVmNHTEg3bU42b2pYY0dsZTQ0YmIyMDBUYVJKSEgwTW05aFFubnVmSUV6?=
 =?utf-8?B?VlFUR2lFSzRCRThtSlVQVmJlcTltSmtlYkNzVHdxZnExdlNjb1ZuU0x6RWZZ?=
 =?utf-8?B?blRhZWR6SG54SjBuc0taeTZtOERBUjM0SDUzSmJacFowdTh3K0VWM0NPemxv?=
 =?utf-8?B?aERrK1lZdGNzNWxpdnYya3B6ZUlUNkJwaEN1L0RqTTZ0ejhZMUhFQjBpUlE3?=
 =?utf-8?B?SEtyTGE1SFkyTW5yVmZZTlRrb1YvYUhTZUdkc0VVaG1MdVRXK2ZSQXdZR1lv?=
 =?utf-8?B?M1F4VjhvKy9JajVSNllMSG0yYUxFOTZrUG5xSHM5c1R3cWkxWEpWd3RZZWNz?=
 =?utf-8?B?SnUyN0VQb1M2ZEM3bDV6T0Uxa2RKM0I1Q0xmVE0yZHAzbHlSN1ZKT3Y1dFRn?=
 =?utf-8?B?cEhqbk9pMVoxV1V1Sklnb0hZMWMwSGlXT0oxeWxJSlFsaEx3ZUZmUzlKODIr?=
 =?utf-8?B?RkE3MCtYSFVtZlRDMXM5eXl4VnFIQjFoeFVRRG9Bd2RQSEs0UmNBbklCcGhN?=
 =?utf-8?B?ZTM3dnltenBkVzVscklta2YvclJIK2wrQThhVVJCZ0VzUXBycG9KTi83L1kr?=
 =?utf-8?B?UHlGRk1xa2FjWnAxazhJaGRjS0pidCtYdjhkRGhWYTZtKzRXUFloNVA1TnlS?=
 =?utf-8?B?di9OYzNZVFVGVUFoeTZGeTZwWHBhYVBjcmNYdG9kWHpqMVBPcW56TDlvSG1Q?=
 =?utf-8?B?SGduYnJVdG5yYkFtelBIZER1RU5Fa3pDbzRzY0cxYnFOdUdEQnU0L3liTmVO?=
 =?utf-8?B?bkJuaE9kaEpIMnBOc1FESDlMNjV3WHdGSmlFejhFcjBnRXp3QUtwbW00Q0xq?=
 =?utf-8?B?TjNhR01SWjJXY2pNMkhYZlNxbDFLY3k4a1pEOUFqQ1R5MDFldWRKc2FYOXhO?=
 =?utf-8?B?Z1ZCbS9OejZqT0dhelFjZnZ2dWtkMmVmMW94Uy9TNlJxTkVVOFlEZzVkZ2FS?=
 =?utf-8?B?Ny9DTTJ0VVpva1pJYWZzMjFISWorNGJtaDFobGs2S3UwdGhkZlNFYWVTK0l1?=
 =?utf-8?B?RjJkTEY3NmJGaDhoK09UMUFUMG93b3lyanc5cmRsWldCREE4M1FGbEF2OEhT?=
 =?utf-8?B?Kys5c1B2U1pFYzhYQlExOGluY0FjNTFBSms4MmVLck1Oc3FsMXgza2lBQnpz?=
 =?utf-8?B?Tk9UejRpRkpGNHkzNHFFUjlCaS8xV0syemFjdHArZzIwMk14ZTdRbUlQa0cz?=
 =?utf-8?B?bDQvNnpoTEQ0dFJmOGt3enFUdEZ4bU5JZ0EwZzVDbU1UVVFjR3NUWHZpeU15?=
 =?utf-8?B?Q3kyNlJNZWJCbkpwbWM5NDVqTFhQZzRzT09LYkNIcjRaRU9KTDJaRXkvMlpT?=
 =?utf-8?B?NlpYdE5VdGQ3dUJZeVRzcmYrSkc1TndWV1V4eGR6WmVHWW1nSk91SXdFT0Vy?=
 =?utf-8?B?Y2IwNjJiOVU0bjlRSytpSU9hNy9pNVVHckFQWklBMFVQS0tScUduMGUwWVpI?=
 =?utf-8?B?c3JJMUdsNS9MNElTZDdGWks2eDhRNGViRTVjdCtyYjBKVU00cW1PbXpqNzV4?=
 =?utf-8?B?b3pNZkE1WDJpdzhmMS9OUEUzWWZXUmg1QW9qN2JwK3dXTi81VjFwR042UVRK?=
 =?utf-8?B?Tm84NEIweEJUdGhGVkZ2NmdhcHRqcW0wQ09pbmpkTEQyeEtIM2lsTmQ3WlBJ?=
 =?utf-8?B?bUtlZ1VqY3U3WXE1Tzc1bGdIZ0pjemZpQW9WOGdqVGN4Q0IzbHQrNEVoME5V?=
 =?utf-8?B?ODFxUkVXZ3ZqRjdZNEQyR3pQU0xHcUJNS3ZVdktQdkcrbkNPUER0bXlxc2Za?=
 =?utf-8?B?YTdGUzRiWU9QYlMrRm13ZjFtYTJrakQrMUdnZk42TkYxcEFSUFRpK25Cemlp?=
 =?utf-8?B?dUtlcEx6bjBXdHNKWDJ1NU1vZmxPa1lHQXlIdzI0V3d5ZUlsZTF5V0xwaGNl?=
 =?utf-8?B?OHQzQTA3TGNQUk5aWFh4MkEyYlZMRkVPUnErcld3OFg2YkRMSnd1WlRBcjNq?=
 =?utf-8?B?dStVL3ZBNzZSVEd5M0RiRjQ4YkJ3PT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9ea44a-fd88-4bd3-707b-08d9ffe79f39
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:07:32.2255 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 22extuXDGIizwaZYvXVVjx3OuMFydNXMWA3qc3vsA4A1eIUMn20coslEECSEtsXfVrNuVDKJPV3/tQg4zKQwww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Mon, 07 Mar 2022 05:51:41 +0000
Subject: Re: [dm-devel] [PATCH 05/10] dm-integrity: stop using bio_devname
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
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 Theodore Ts'o <tytso@mit.edu>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2D975493CF5DCE4D89D88F25E3E676CC@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/4/22 10:01, Christoph Hellwig wrote:
> Use the %pg format specifier to save on stack consuption and code size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

