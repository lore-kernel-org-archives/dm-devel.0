Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04DCCCA473
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119382;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j4UVokHGZWFvOMNHOb6qor8ZlT6XIA5wz0aXSkEfEKQ=;
	b=MELJ9JhWiQSIEZs9AxIpGfaoNElx2aPc6oPWY7j8rBfspverPg131Rmoz2iC22XL5aramF
	daldfpJOMG39CCBk7DkIwetsFo6Q2mG2IFCPQpVI56j8X2eiYStc62Zz7LBmOK3wCCvzIy
	wGwc9/EtH7mPMTlf28D8W7EgHlOhAv0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-ffwc2TvfNZOZPv3RidUl4Q-1; Wed, 06 Jul 2022 10:56:18 -0400
X-MC-Unique: ffwc2TvfNZOZPv3RidUl4Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9324B872911;
	Wed,  6 Jul 2022 14:56:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 808BB1415116;
	Wed,  6 Jul 2022 14:56:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 07720194706A;
	Wed,  6 Jul 2022 14:56:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 75D86194704D
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:27:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F88CC15D5C; Tue,  5 Jul 2022 06:27:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 59C75C15D58
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:27:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40CC7101AA4E
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:27:50 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-JhWj1FZSNEGYC3oauPJbxQ-2; Tue, 05 Jul 2022 02:27:45 -0400
X-MC-Unique: JhWj1FZSNEGYC3oauPJbxQ-2
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH0PR12MB5089.namprd12.prod.outlook.com (2603:10b6:610:bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:27:43 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:27:43 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 07/17] block: simplify blk_check_zone_append
Thread-Index: AQHYj6PzpYs7vaKvl0+Bbvh/T/B0O61vUWSA
Date: Tue, 5 Jul 2022 06:27:43 +0000
Message-ID: <aceed252-2623-9e20-e288-9b9c66ab7398@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-8-hch@lst.de>
In-Reply-To: <20220704124500.155247-8-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e213c893-16af-4f44-d416-08da5e4f7814
x-ms-traffictypediagnostic: CH0PR12MB5089:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BUtOV0hAoj5ekb8cQHJl5FVvmVgguGaoTa+dFQ+DYZ9vhQfZUKsVKkMxLpF7zQ8EJvy7RA85UA4Pi5J1IcFXaHyo80ZCr+A6Bbz7xVz5vEn37v9fLmP0o4N281PZODiXABbNYEE/8nPYI5WTQCyka/SN4viAhJIdbKfEYg70UEqkNnt50a/uTZ/UpmcisPGn9QnH+9/UPXuWZOmbOQsWnM3TaKgbN9ZIBzPGJRl59APq7giGWIlIVTnaaJV1egyQ9sQkzfqz+BFghy22o9Z7ymxDdbeEwgaNHTqc67i+RpsCIpj12bC7jKQVz510Xi4k4xiJCECc1P8T7DlJMAnVfVjU1DUhvk0ZuQ65NKi/ecRSFgaejDpigu71qH+0laXG2l53UiFbXMTZZUQHBJ5MdHCQF7uJQQE93v/lLtZiXVPYFl28yHZAtMdTsYku+d2EMocytF4gTGzcB/5vk5vqXYKrhzOui4UxMVtRV/kBe4mstKRLcKsHNXn2uMvDLN4ZtZ0garvsBmYMvcI4tzblIY6xZGYkb0VMkOWtl+qBKfD5N4s+l+nMKinYS9jHExkQ1hKTYJxw8inlJP3XAg5eNUkJCinjn+rwjq6Zz4DKBTlhSvEKEnH9viOX23YxpTvDo58k3VYnWltepn97cU5fVhQWS7xsSIpZdaFmw33I46fyJM0b1XFA87dEHEcC2/Og9TBveT+CKenHf9v7FB5+wuoCYkSF0PBuGCOP+YTKyDZLCjz+BSaYAvZxcgGmdF1zRRwnTbg6JgAKP2lAIyihd6DqdY2g1ol6gS+SECxcTk/j8htuTapp6aXizlUOt/CmY482bF10cXjiPmQ58zPAfc3HNwAbtVUjpivkwGzIDpG+cwCQkopKwdQDB1b+6rwn
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(31686004)(86362001)(38100700002)(41300700001)(6506007)(2906002)(53546011)(4326008)(66446008)(110136005)(36756003)(5660300002)(558084003)(76116006)(316002)(8936002)(71200400001)(186003)(6512007)(54906003)(2616005)(478600001)(31696002)(64756008)(6486002)(38070700005)(91956017)(8676002)(122000001)(66556008)(66946007)(66476007)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZU1yUU9hWko5d0NLcUFHVUZkWnc3cldtUGoyZnBzUE9Rc1VKUjJLMTIwa2FU?=
 =?utf-8?B?dGNtZ1JTMGcwckdsSXNrdExSdG5iOHk2a3ExT1Z1VzJwODVDZnhCM0dDVkJx?=
 =?utf-8?B?M1lSMnBaNFlzUkhaZWpGOWRHR0ZIR2lTeEszSklWaHV4YXF4U0lhdEhxV2pR?=
 =?utf-8?B?ZGtweU1SREROS3RRSW9TemlOSGFodkExU3I5cEVoVlRXaTdtcnJFSzY3dEYw?=
 =?utf-8?B?dDg2WjlaS2pXalJPV0t4Y2tCWVVWMnh5S0FrcnJmLzZCNDRGb0VOZnFJajEy?=
 =?utf-8?B?cEZxWUxPQ2puVG1UVm9uR1hBVld6cUVPWDZvRTRzVko1eHlYTTV3YWkwd3k1?=
 =?utf-8?B?SVJFT3BqRjd5ak5VZjdhU0o4MVpjdW8yellSaXAvSWZtYjFpaHhiZFF3cG50?=
 =?utf-8?B?MkFpenFmSCtuSldnZ2M3aFdyQmE2SmpWU3Ztd1hMS00xRWxFT05DcFQ5VkNx?=
 =?utf-8?B?T0Y3SzU0bk15VU02c0ZKZlNtUzM0NWVkcFlxUTRLWTBMOWg1dTMyTHNiZXVq?=
 =?utf-8?B?QW8zejBiYnNGd20xeE1Id3VZZFhvd0hBck1vazl5QmRIZjNPbUplRWZ6dWww?=
 =?utf-8?B?bFNkbnBzU2JPSXhTaWtaVDdSRW5TSkdJUzIrY0ZGeXhjUEJSc01LYWRDbUxG?=
 =?utf-8?B?M0dNUVlhcXovcTdZdDdjQkZOYVpYTmVvMk81aXNJZVA5ZktFK0p5eEFuRStK?=
 =?utf-8?B?dVRUUGxhMU9zU2JxcWNpSHVkZTZqVXBTZEpWR2gzK21kU0dlOHpzdUd5ek1z?=
 =?utf-8?B?OEVRSTRLWEovb0g5ZEtRbitBNzBJQ1p6ZG1qQWFBMVJCUE9HT05jTDdmd1Z5?=
 =?utf-8?B?dUFmenJ4cUVPSitMMlJoWEpmV0NwLzI4bjBZMkdicE9RcFI4QkYyU0ZvVjFR?=
 =?utf-8?B?THNPbHdvU3lZTzNIdU9MOE83NGRQUnFFekVhSXJvL2VEUEErL0tGMDJWK1RH?=
 =?utf-8?B?TUEzeHBNQUpTekwwdll1eWduNHMwZ09ET0s1WDk2M2Rtb3grclE2YVZUTnZ6?=
 =?utf-8?B?TE1ENGdUOXdIV3A5b2ViaTVjWWMrdmlQcEgwcjBOLzJvMFVJNnloUTNwQ0l4?=
 =?utf-8?B?aTdqU0kzdlBmZS9Ba1cvVmdmbmp3NzBjVzluaHpaUlNMTWRnWDJZYk94UWFn?=
 =?utf-8?B?dERVdTFWZUZNcHhiUkF2QnF1bkorQ0wxWW1tNHp0aHZWK3BQMEFnZ1FiQ0pS?=
 =?utf-8?B?MTVKczl2K0NaSUJWTTB4YWZKejlCOGhLRS9VR0xlYXlIYnk4Z05YSklrSFNY?=
 =?utf-8?B?Vkx5dkNHV0hNZUVCMlVQbmxNT0RReXlLY1JUVDBENkZ1ZlRteTA5MmNmSzZ3?=
 =?utf-8?B?WkhrdkJFRjllQ3dRUWdWckJDT2RGa2FIMWtNQWJNc3Q3aklyRmZEMTBYQWlB?=
 =?utf-8?B?Z0haMjhKei85cmlDTFgwWEI4TndIQ0dvNkRUS002KzRvSE5tYTJaNXN3cm51?=
 =?utf-8?B?WVJya0dFVm40bWNlNGNQWm00U3R0bitMTTJwbnFtMjlPTTQ2cTBGVTVBMEJI?=
 =?utf-8?B?cm1oTDdGYUpsWUVFaDJEeUZWdVNBZHFTbmt6eFQ1TmRSUkwyQWVSQUlBRzJ2?=
 =?utf-8?B?VjNxNTJCK2NNdm8rWnBkcGpxZzNiUFhINFVXUkhYWVNrQTdhZjlCM0xDODVt?=
 =?utf-8?B?bWcrampsc3ZrUE1lNjFRYWtNTWVwNnRLK0xmQW5GbENyNzQ3bjlSKzgyK0hq?=
 =?utf-8?B?TzFSRFR1b0UzV3dNTUxzQzhBS3ZwMmNSMTAzUFR6dEZ4aVpuc0tzb3ltTnlh?=
 =?utf-8?B?NmQ3bVA3K2V3MGowQVMvQllkNXBOcllLN05NYUVxK2prQThXWjJ5Qlg0SkZ2?=
 =?utf-8?B?VmNGakpZZkZZbXYrNy8wNzdnMTc2eFIzN1ZNcUgzMCtYc1p2YVFQWk5XQnho?=
 =?utf-8?B?c1dBODdQUjBSdkZMYm5YajJ5QUpleXNGUC9VUXh6YzZ3TG9zdjREa2NuTVhM?=
 =?utf-8?B?WHRqVmQ2ZW1VMTlnY3FEeDFQQTFSVjV2eWgzaWFxWVZrN2EzMUZkcFEwY2cz?=
 =?utf-8?B?d2JjSEVJLzkrV3c2VHFRQUU3VG1PK1haK0NqVUZxTGRHdXZHekpRT3hqeTNt?=
 =?utf-8?B?eW0zV2huNnFreStLeHlmRnREcUY3Ly9LZmhROU93RXJ6Y2IyRHRRSGI4RTNz?=
 =?utf-8?B?UlBCUWl2UVFpMDduTzBXWnZYM2p1U2k1RTdSVnMyZWxUS2hJUmZaNjdZUlVV?=
 =?utf-8?Q?AG+CDxsq2CECHr84Ru6aLYZDND+DfCrWCfPtHGoRYGG9?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e213c893-16af-4f44-d416-08da5e4f7814
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:27:43.6248 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hDJSAUv9bE7o669hvqqg/0RwKw9D/woaTubeSPOJMMomxbo6C5FHo4baj2Cvr9WW+wJZu/HkguEFR8w842fynw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5089
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 07/17] block: simplify blk_check_zone_append
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6B3BC4058E7F2A409947556E1CFD2716@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:44 AM, Christoph Hellwig wrote:
> Use the bdev based helpers instead of open coding them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

