Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF638C25B0C
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 01:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660095964;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pIMEkzH2HLj6CJBQ3aogP6vmKNHla5dOx3tbxLyENtQ=;
	b=fgJRBtnwTwuuW5Y/gJsco2vn6YFXA4Wj3FdqJRZkgswbXnt1gcWXroyKJk2pom5TRwyPIN
	XM/Iv4Xf5fMxglf9+JUxYkR+J675DaHx3ckYAu7pqroEBmpFS/zSoi64h73YJ0Xf87Ig6n
	OzwBevYW7/NOOGErpf9zn2aIHevFDrk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-HHZ_Py93P4SwnB4QUdgQtQ-1; Tue, 09 Aug 2022 21:46:00 -0400
X-MC-Unique: HHZ_Py93P4SwnB4QUdgQtQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4FAB1C05195;
	Wed, 10 Aug 2022 01:45:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B7C80492CA4;
	Wed, 10 Aug 2022 01:45:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 750641946A4D;
	Wed, 10 Aug 2022 01:45:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 47EB71946A41
 for <dm-devel@listman.corp.redhat.com>; Wed, 10 Aug 2022 01:45:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1F4D640CF8EB; Wed, 10 Aug 2022 01:45:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B4CE400DFA6
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 01:45:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F292A3C0CD5C
 for <dm-devel@redhat.com>; Wed, 10 Aug 2022 01:45:54 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-OuhYcHFFOM6cs3um1LHylg-1; Tue, 09 Aug 2022 21:45:53 -0400
X-MC-Unique: OuhYcHFFOM6cs3um1LHylg-1
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by PH7PR12MB6610.namprd12.prod.outlook.com (2603:10b6:510:212::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Wed, 10 Aug
 2022 01:45:48 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::e033:3f08:d8d6:1882%7]) with mapi id 15.20.5482.016; Wed, 10 Aug 2022
 01:45:48 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>, Keith Busch
 <kbusch@kernel.org>
Thread-Topic: [PATCH v2 09/20] nvme: Add helper to execute Reservation Report
Thread-Index: AQHYq4PmjV2UOnxHHEaZfkf5ZGRZ762mZnKAgABBcwCAABkjAIAAncQA
Date: Wed, 10 Aug 2022 01:45:48 +0000
Message-ID: <a0184a51-ef30-dc80-412e-6f754c4d9476@nvidia.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
 <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
 <YvJ0Xh61npH+M9HP@kbusch-mbp.dhcp.thefacebook.com>
 <5f55a431-31ce-185a-6ab0-db701b878d82@oracle.com>
In-Reply-To: <5f55a431-31ce-185a-6ab0-db701b878d82@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b18d4017-3e25-41b0-cb79-08da7a720cd1
x-ms-traffictypediagnostic: PH7PR12MB6610:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: kaBKR5UL8TlRqGEjQTxJH7kekJXssZyxXvI19NpRU8+DCjL6XBHMC/5MBV3uRScy54GWqlNaI7xrM7GVZLXgJ2VwOqe5t1qSLZoDSy0hYoXXFMoY22y+7tWj9q4MwoeeVdfojnf7ILJIr21HcS+iNYDXuSnlyx5xcnVI3iiJPRZhPO/OsnTXWurNgYXYTlQqIWdwSxBCr2A3Bs4CtKZNRNV025pDyQErVPiy/Qe5tsiDK52KtGLQhNe+0uY7VcPDbQI+4fUEDLt6uX8KHQmyL3SDFtRJNyb2n/LEoMAIw/1fdRK3kX9MrJgUcUEHOTs51fxBmm/uzbgGhHgPllf+1T/uYjwv4PtYYYnv4u/oN97A/ipUX7l5NXYDoJbNO8ythx63S1i0yMorgy4QFwH1HvlKyn/teRmsxhGmVqqcmi3lRfSpi5aNzYR4NaGknPrNianov/Y0wenneyAZCuZalbUQkKE2bfasa0Ce92g+UjN/1F+P3B+1hw8dwI0KxCttkA8ea+E0GR8DfZiVtJK50hWi2kqQ5GUPpFBJGjDogwOapuzutpd3B7qTl2ySODrh3wYU8GGCPJ9zAprjf9S9DXxGP2FGzRyTRomgxqs7U7b9gjgauTFFWpMzMMAwqmdMPTkQtjCr5qQwUnrL11kM693/cyDaqshiJbLmcGIsJPPWyPAD0zFdGPuzyO9qhaCUaupJ65m1ITldyK+vMrMWefmfWZyPSC0NG2rqsmAU/soIQNMaAyLrbz5oRQonh7lbTMCsutocsIv2QI9JqFvLfUC9K61RZN5jYkf9nUYfSYW0sZs3+zqcm2nHvptLGbQlnBYhzwNx0gsKLEwlcFo/BP9FdUhyqLuhNeH1ajGpKwo=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB4659.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(71200400001)(6506007)(7416002)(110136005)(8936002)(76116006)(478600001)(86362001)(5660300002)(53546011)(122000001)(38100700002)(6486002)(2906002)(31696002)(2616005)(38070700005)(6512007)(41300700001)(83380400001)(186003)(4326008)(31686004)(66556008)(316002)(91956017)(66476007)(64756008)(66946007)(66446008)(8676002)(36756003)(54906003)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWE0cTgxc2RiNEM4OUUxekRZMEdQUUtBaXR5ZjRGWWdIMm1vZlNDeUpoKzNw?=
 =?utf-8?B?SlNWSkxLY0JRQkNvVVRUVEF0a0FwMnl1ZnZtUUpGSWwyRGJ2aFNEZTArWUZs?=
 =?utf-8?B?WXNnUy84SThJV2s3STMrQWE0OXVJZTMvdFYwUGtVaG5YZzluMkVJYmNIRDRw?=
 =?utf-8?B?UWhJZENaZzYzT0hIK2RwaXFlL2RlSk1aaXhzVHl6V2pxaVVIRkFVTnAvTjdl?=
 =?utf-8?B?Ykh4NC9pa0Y4N1B4QjdYd0tMN1doQVJuQTlFZmN6UFZPeFZvVmZHVm00WXdS?=
 =?utf-8?B?ZkVIVUFSNVZUTW5zRU1aTllmcEpCcFVFaU5jRm56TXphL0p5bmtUeUNkd0c1?=
 =?utf-8?B?ME5pd0M5S2RYZ05qeHNOeFlmdkhtMjNIOUtEU0ovWlQ1UUVQMUpvaUd4ODJ6?=
 =?utf-8?B?M0pJUWtYYkVhWm9tSFBvUjh4cGcyZnM4alArN0I0bVNNL3M2RHovTGxXSC9D?=
 =?utf-8?B?UG1DVW5URDNBeFJ4c3ljYU01YUNPbnRYM1AxVlZtT3FLbDNzQXZpbFNuelZk?=
 =?utf-8?B?QS9wYjd0bmVxcStYWDFEdlhsREtudndRRGFPTWhRclBqZ0NuOWNhYm9wMWxN?=
 =?utf-8?B?NnpIUTRneVNET3l1S2hoUTZ2Q3phdTQzRkNUMmRtWUpiYXJrRlF2L3czQndm?=
 =?utf-8?B?ZW95T0tqaUFSVmV6c1NzRkM0c3B1dHpXSWRqT0xoMnZMMzJDUjFrU1l5VVNC?=
 =?utf-8?B?MENEdWxrcUlBNmV3L3hYN05iaU1pblA5Z2RUMmQ5dk5GN1lzM1R0U0dkaXkz?=
 =?utf-8?B?MDlFL1ZzbXJZQW94SzY4WDM4R0dFLzBSQnNUbjZsZHlqWWg0a2NuVElaT2pZ?=
 =?utf-8?B?M3EvSThrbkVxSWs2UEUzeDQyRmFmYnBZbWlsVm8zOUpGSlpiVkYxcnNtTVk1?=
 =?utf-8?B?TnZqTVhMMDJJYm54TjZRQlFHWkFLWXBCbzJmNGczZy82K09oVGZSTkw0QUVO?=
 =?utf-8?B?TkNCVEJmbnA3d2pYU3VQVDYrdDdid2t2VVlieE9UWGE0M0lUUTI1U01BNHlU?=
 =?utf-8?B?ajZycnpYYVZ4TlI2MlFhOEFnZUFnNERld0dseEhldkxFWnhZdzloTkpIRlNm?=
 =?utf-8?B?aDk4OE95ZjEwV0FHUHpJUUxqNkh6RkhDL3ZjS3MvUlpOL2NqQVhjOW54TVkw?=
 =?utf-8?B?dmVVQUptdjRMN3lIUjBEb1BzNjhSZUtKOWVjZFM4dVZ5ZnFmYVBJd2lwU0wr?=
 =?utf-8?B?cVJpTEJKY3g2ekNITWlOcmNwK1pESUMyakoyTzhxamUyVUxTOU1rcXFoM0lW?=
 =?utf-8?B?bUtwOXdseisrTDZNSXA4L2V1YWNxZkVJemxENHh1bGZNWGR1K1hZR2NUUWV3?=
 =?utf-8?B?QmsxYkVsYnhUN1JaVjh0SlU3RW9abFltNUhXMzRFTlFSSld2eVFzb0pEUURN?=
 =?utf-8?B?d1lVcEpVekZMcWtDaTRFVHIraVpLZzJsSmF0T1hxbmk2dk5USmZqYkUrUmVq?=
 =?utf-8?B?TDRLREprZ2wyRkZIc0FzeFZqM2Y4MnY0ZlFWUDQ4d3RuV3VOR090UGtvRG80?=
 =?utf-8?B?REg3aEUwbFZDZDNEWTZGNThweXpQZlczMW52bEQwVjNxc0J0c2V6cTdUTWJF?=
 =?utf-8?B?MDhWTjY5aWJqTXdva0FmQzVRMHFHSC9rbEUwYmo5TFBYQm1jY3oxa1ZMbnNK?=
 =?utf-8?B?RktqZGJxazVBUXl6OFFMMEQxQnNzQ1hlWEVYVEl4UmQ5VWRqMllRMmZzZmlM?=
 =?utf-8?B?TzFNTlNueWw3N2cvQ3ZTYWhWTmkrcG9mN1JJK2h0NDh3dXcxRkJYUzQrYXhT?=
 =?utf-8?B?L3I0WHcrZVFEcUo4TmxUSUZkRjdtbFlyNi80aDBXY1RpaTBrWlpjcUQ0Sk1Z?=
 =?utf-8?B?cHQ3MjVCVGVoZjdEWUd1blBKSG00QnpIMUZpNHoybXRpSjFJYU1SeWFqdllq?=
 =?utf-8?B?RXhXQUs0Vlp2Y3pjYkQ5a29pMVIxVTN1NEcva0dMaEtmemx3K1BsRzh6NXY1?=
 =?utf-8?B?WXU4dnJhOFJrTGZlS2tJaTJpZE9zdnQxdHZTbk1NNzFzaEV0YlNFWEtsamMv?=
 =?utf-8?B?WElGTlVuZmIxcXMxU3YwYXBPemJOcmtzLzlmSE5XelZkb1I0MzFqczE0ajRY?=
 =?utf-8?B?T3FNd0VvMG4vem9kem1PZ1BTdXVQV29QVjZSQjZ0TUMxak90VWsxRHI2Yyts?=
 =?utf-8?B?OFhIZ3V3UHZSRTRzeGk1a3d5OFJ4bjdkSzZIRmRWMmNJL202K0JEWmE4OUc5?=
 =?utf-8?B?R2c9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18d4017-3e25-41b0-cb79-08da7a720cd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2022 01:45:48.5813 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F3L6yz60+JB4g+zWOs/kIlCrBHcIB9YLI4fWPxfkmGzDTKUDTIIyrdkLG56hylVnf6jLP88zYU1Z15pe23Bi/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6610
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2 09/20] nvme: Add helper to execute
 Reservation Report
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
 "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <46C78720EA490943A6AF2FC6B0A2BC79@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 8/9/22 09:21, Mike Christie wrote:
> On 8/9/22 9:51 AM, Keith Busch wrote:
>> On Tue, Aug 09, 2022 at 10:56:55AM +0000, Chaitanya Kulkarni wrote:
>>> On 8/8/22 17:04, Mike Christie wrote:
>>>> +
>>>> +	c.common.opcode = nvme_cmd_resv_report;
>>>> +	c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
>>>> +	c.common.cdw11 = 1;
>>>> +	*eds = true;
>>>> +
>>>> +retry:
>>>> +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
>>>> +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
>>>> +		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
>>>> +	else
>>>> +		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
>>>> +					      data, data_len);
>>>> +	if (ret == NVME_SC_HOST_ID_INCONSIST && c.common.cdw11) {
>>>> +		c.common.cdw11 = 0;
>>>> +		*eds = false;
>>>> +		goto retry;
>>>
>>> Unconditional retries without any limit can create problems,
>>> perhaps consider adding some soft limits.
>>
>> It's already conditioned on cdw11, which is cleared to 0 on the 2nd try. Not
>> that that's particularly clear. I'd suggest naming an enum value for it so the
>> code tells us what the signficance of cdw11 is in this context (it's the
>> Extended Data Structure control flag).
> 

true, my concern is if controller went bad (not a common case but it is
H/W afterall) then we should have some soft limit to avoid infinite
retries.

> Will do that.
> 
> Chaitanya for your comment, with a bad device we could hit an issue where we
> we cleared the Extended Data Structure control flag and it also returned
> NVME_SC_HOST_ID_INCONSIST and we'd be in an infinite loop, so I'll handle that.
> 

that will be great.

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

