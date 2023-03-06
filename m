Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF10C61DA3
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 05:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678079194;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Uvto5rUgzXgwU0fPRTvNzS5QYCZChNnkqbgKJPGu3as=;
	b=Q7u6PPu6MmSTgMWGxTTToEjU2DnYnewgQ4EgZCs2DdhIxYvAR06gvMacDOhNPreapBYvZ1
	bHqtHNQtc6Pt1jlgRaWummS9oi4bHZQbrnv60wIfeP1Fh/vBt2HRfLVw5AXoFEU8j3c9qu
	WK1B/nYN91wxPGkTOOJlXW2jFaXXqPg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-9P6_3dJjPVG6cc8Aa933dw-1; Mon, 06 Mar 2023 00:06:31 -0500
X-MC-Unique: 9P6_3dJjPVG6cc8Aa933dw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61EAE80D181;
	Mon,  6 Mar 2023 05:06:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4CF94440DE;
	Mon,  6 Mar 2023 05:06:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1A7501946588;
	Mon,  6 Mar 2023 05:06:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 662F31946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 05:06:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48F9F440DC; Mon,  6 Mar 2023 05:06:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 40EFF175AD
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 05:06:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2126C85A5A3
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 05:06:28 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam04on2089.outbound.protection.outlook.com [40.107.102.89]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-uKHGS8TCNV65zYXckAI_wg-1; Mon, 06 Mar 2023 00:06:25 -0500
X-MC-Unique: uKHGS8TCNV65zYXckAI_wg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH7PR12MB7453.namprd12.prod.outlook.com (2603:10b6:510:20a::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Mon, 6 Mar
 2023 05:06:11 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Mon, 6 Mar 2023
 05:06:11 +0000
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
Thread-Topic: [PATCH v4 04/18] scsi: Move sd_pr_type to header to share
Thread-Index: AQHZSHgJeQNvgF2p5U2ur2VJ4lBvZ67tQc8A
Date: Mon, 6 Mar 2023 05:06:11 +0000
Message-ID: <8c378381-4c96-f9f5-26d7-791660dbe1b7@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-5-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-5-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH7PR12MB7453:EE_
x-ms-office365-filtering-correlation-id: 53da8c9a-92f7-455e-f822-08db1e00811b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: AkZJAicorxHXMEM7GO3z30zuu+42/gHBpOC7fX6/W5edDGw6i891Q7BqPM0KHUYpZfylXYODaS2746vWkE4WVmGhv/MoB0fhWFz/GJUrQLZ21hVEcIb32y8B+XmnWqbKKXRX3imaNKsJVsvNUd0A3jZoFOe0B9d7repXoB6RzYr9QucdYrKHQNs0nDI5f5g9hTWDuyw8/RfFRWXCfQrM/N9I+yiK5RwZqsQyhEvECsQq7EFdEFvIO3EGrIPNsDbUhbV+EE2hNp/vVBGyHeF/KclbxqRkBq5twpWok5GG1YIf5jEq5Tl8L3xkBIIcCWoBLIwjyATGz5ykhQAyN8IhicUSSV7YNJFDH4LwQHLraX1IdBkRx8CcVuKplORDos7dqpqglxIuGJd4ALuVvE+fdsfpp57adCmYPork0HZsHqd3CrAbDjLQXALKu61Y+w87iW/6wr+qNnwdW2amRJJGx+Ar24DAqVATzhug87R2AcmOnD52M4EenJu+FzCfencCsmT+RiSPdXfnKbp/Dp/Ukb2JYdUqEcIN+Am0URKPMzIirvQ4A2YNq7WFLj1sBKXnsLxr9TcpRRJ/L1Ik3KWyuE7cK8DCKzy8NYSwKSLu87KWiV2NHWdlNm13VsAsyYWvvnwP3lGyZLYjMhfFCPeWv33EhrBdAjhW6zJJMgQiLUytd227zrsBbfUbaaCMjfnkPgtQUQtQ7X8CDIue8VREpraycp3zsAjCPbIZEZ5rDUNhyKx/xHEyhB7xLGWmBTB/5fj8wD12xdV2ei0OL7anyw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(186003)(122000001)(38100700002)(91956017)(38070700005)(921005)(8936002)(64756008)(41300700001)(66556008)(8676002)(66946007)(2906002)(4744005)(5660300002)(76116006)(7416002)(71200400001)(478600001)(53546011)(2616005)(66476007)(6506007)(6512007)(6486002)(316002)(110136005)(36756003)(86362001)(31696002)(83380400001)(66446008)(31686004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDF5UFlTVndPcFE1bktVSVdzdzJLQjNyRkwzWERLek43bHRDS21VbHAzR0Nw?=
 =?utf-8?B?RHhEOGN2NHd4bEJwVWlDdCtIRElMcVVXWlRPZWV3VExGSDBjOHZNZVVuYVEw?=
 =?utf-8?B?NXhBYmpFQ2pTY1JrSlV3OVFzUTY0ay8xM0g0N01ENkxoRUs0Z3hTNzNlSXM4?=
 =?utf-8?B?clhHNTJ0NEVOZ1owaUkyN0VWQTNiVlhvcDZKTnhGWGhJS01QM1orUGU3cTlS?=
 =?utf-8?B?SGIwaC96TWEvdnJ0amkvYzk4ZFRIUWgxUkgvRmpOSXFDZEJsM1VGQ1JpQ2Rv?=
 =?utf-8?B?T2pWeWpCV0ZjZm5EOU1WUXE5b2I2QU5nVWxwOWlReTJBQXYwTjRxak9sdlA1?=
 =?utf-8?B?RDlwRHR3VzIxK05xZlEwZHc5MDVFNm9qRTU2Njl1cUl4QmIzNzRJNXBQRzJS?=
 =?utf-8?B?UWwvakRJcXNZV0NhZW9qZENGNkxJRnJaSzBiUzNkaEs3SWk3TmdRTkwyYmxo?=
 =?utf-8?B?QS84N05mcHAvbHFaOU1BUER3WWhoQ1p3ZzBsVlRZU3BxNU9sUWMxWFE3bUxV?=
 =?utf-8?B?L2NlenpuRXNCUXRGN0VGbDZXUlRkbHJqUkt0OU1ZaThXV2Z1L3lXMThoUnBP?=
 =?utf-8?B?UGwxTmNnRXh1UmJQaHVtNThOYmZ5Q2NGcnM4TDdiK1paRk10cklXSW5NSXY0?=
 =?utf-8?B?M3hSSWQrUXFHNkV6a3lPVllzMEpCYkpGdTMxSUFDdno5RTliTEU5d1JZeURM?=
 =?utf-8?B?WEVRUDVWNU44Qko0aG8yUXZ5Lzdsa3g0Si9VenBPWW0zVmQza1dyLzEvUXlT?=
 =?utf-8?B?TmQ0UVNPQkI4MExOVVdKd0RNYWFMQ3pjbDdvNFNia1dvSmVSYXFRUjRRdElG?=
 =?utf-8?B?NE1scU5VL0oxY1VkbWM2Q0piL3BqNDdnYkpuWDM1MlRoTVZ2Ty9XS2RPU3NC?=
 =?utf-8?B?S05GbDgzV29tLzBMemxxN3F1MmMzZDlpL1VCa2dTZ051T0dVcWdhalVlNlJq?=
 =?utf-8?B?M3R2bGhVdk0zLy95NC9TZFpmR1pFYlB4aHEzZHBzd2p1V3VxdzRIWXBlM3Zm?=
 =?utf-8?B?T1B5SkNtcy8vR1VaMTlCNVVWZGcxNHYxQlVoRjlQbnJxYkJ3aFFhS0JMWDE1?=
 =?utf-8?B?alBZays0OXZWWDk1Ty9TcWZMOTFydDQ1RGNEQlFxelJiTEJTaEtEenEzSVFL?=
 =?utf-8?B?bm9wc3grelRvWCtUdDgyc0Iyd1BCT245VWJjQnoyRTRqa0hUSUFGUGZkdHZz?=
 =?utf-8?B?WkVHMmdldHZYOFJkZk8zSFova2hDV200cExUNktHOXl6cGR0Z0dOdExqUWti?=
 =?utf-8?B?cnJOZjdkRFlJT25GZEw1ME45a0laWUJYZ1l1M21wSTl6OXh1VWwzUm9jSFNk?=
 =?utf-8?B?OFhwRjUyaVkzU3JDdmMyelFhSUNOMm9EZW9IcDE5ejJwc2IxRDdWbnNFb3BO?=
 =?utf-8?B?Ym1HY2NsZlBDMWEyZnVFWFRkb3V5alA2V05DSUpCcGZPN1FtVUdPandoemk5?=
 =?utf-8?B?aTRrblJ3cldmek1xNHVISlVrUjI5WXlodVZYcnJ6cE9kc2dDM3g0UXI4ZUZa?=
 =?utf-8?B?YWRGcGY5V1ZacllnQzdNM1JZZ1ZzSzFaSlN3UHJxV2hUL09MTFprbWVOd21m?=
 =?utf-8?B?RlZZU2JtYlJ5VG1nMFE1em5FbFozRHR6ZC8wNTNXQUFRYVpzVnNMNjgwTjJI?=
 =?utf-8?B?NGl6cUp0MVV5dUh2LzRxTHVOOXI3UVB3ZktWczV1eE9OSEpLN3ZGSmJGSDJ1?=
 =?utf-8?B?d0JVVU85azBLd3M3b3lYZ2ZqYzhwWTFkUFl5WjFmRDl5TzZBSFd2bC9XZFU5?=
 =?utf-8?B?TEhKTHZMQzFCREY3aVl0ZmRTTUtpb1hOU2M0dUVmMUxnckhOSXFRZlRacGJt?=
 =?utf-8?B?TEVtV2pDYXo0cllFZnp6UXpkOWNMc2FKUWNkd1hQRzVBdjJqN09hNHY2UC9v?=
 =?utf-8?B?UnMyeGhXUU5jQWlidlFaOW12QWdvSkNBeWx3SGU5ejFjV05XNjBTVDNtcTkr?=
 =?utf-8?B?UEE4clZxMHdLb1gxNmh0ZitCUFRyNlRUUmVLZWVaV2pFOURkNElEcnVpa2RZ?=
 =?utf-8?B?b3ZSb0dyMlBVRlVmL1pDL054Qk04c2VVU2FHMTF2a1FOMFk4SHNTU2lad2Fm?=
 =?utf-8?B?elRmUTVqTFNNTUVkQVJvU1BDK1FnYTNNdEN3VHZjSHpFbVp6V1A3QmFMcU15?=
 =?utf-8?B?UmlXSmhocTd1Z2oxaUkwejc0Y3ZxbER3M0tHcUZSSnVIRVcycnJURHJieUds?=
 =?utf-8?Q?kob3qCr756Q8+MR5ZJC/4k4NhVMsYGr+/vJYzdVDkc+Z?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53da8c9a-92f7-455e-f822-08db1e00811b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 05:06:11.7671 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GG1ae4v80dOsP1suV6KveZGfKk11+n9krvQ996N2Gq7XirFE/0T7BdAHAm0CiRMRU9m9yT6ZwmDoWxJQ5M3+mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7453
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v4 04/18] scsi: Move sd_pr_type to header to
 share
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <3E07F04F06406A4C9D9BAB3468B94055@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/24/2023 9:44 AM, Mike Christie wrote:
> LIO is going to want to do the same block to/from SCSI pr types as sd.c
> so this moves the sd_pr_type helper to a new file. The next patch will
> then also add a helper to go from the SCSI value to the block one for use
> with PERSISTENT_RESERVE_IN commands.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

