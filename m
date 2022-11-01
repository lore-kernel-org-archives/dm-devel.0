Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D289C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  1 Nov 2022 05:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667280356;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IFskimjYA3V6lhEm3mU/jL56mCgzMKHhqelRGnupp54=;
	b=B9nVkEEAtYBkKpyuJzcbN2xqtVpWQWSQHkTXmSWVTfb/WbZ42M2te1SXgqZ26f346lcgF9
	UwuI8WvKMnrBs56rSmgah0vbHztLpy3BzDBm/qsatHnzNO/ecy+2EjpJTd2JZVhKZLIMsT
	O0Ebz7tYC3XBBJEiQPU10A31wAbkxG8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-z6L8CAX7Ox-VSyd-G1OV8w-1; Tue, 01 Nov 2022 01:25:53 -0400
X-MC-Unique: z6L8CAX7Ox-VSyd-G1OV8w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E6D9811E67;
	Tue,  1 Nov 2022 05:25:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4EFB92166BAD;
	Tue,  1 Nov 2022 05:25:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 142E619465B3;
	Tue,  1 Nov 2022 05:25:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E305C1946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 05:25:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D577517583; Tue,  1 Nov 2022 05:25:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CC75B1731B
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 05:25:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC4AC1C09B66
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 05:25:46 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com
 (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-rLdXs2myMZGq9SrVa5mQdw-1; Tue, 01 Nov 2022 01:25:39 -0400
X-MC-Unique: rLdXs2myMZGq9SrVa5mQdw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Tue, 1 Nov
 2022 05:25:31 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 05:25:31 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>
Thread-Topic: [PATCH v3 08/19] nvme: Move pr code to it's own file
Thread-Index: AQHY6ZHJfE+OIdc3m0OxwSBGDmQWbK4pkZMA
Date: Tue, 1 Nov 2022 05:25:31 +0000
Message-ID: <f4b3fae4-d2aa-b017-6157-a14ba170fec0@nvidia.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-9-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-9-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4322:EE_
x-ms-office365-filtering-correlation-id: 96e97965-fb9a-4be3-815c-08dabbc97ea6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 5rJ4BjuF4oOMrqc8lqpvhu0kvMqw9x8kKRysGhAWc6So3bFfeoeefJ0/cFXGg8r5DlU4ygG+o597IAFMRUpYKplOUqkxtObYgGhrNBdFGCDNYHzkWXD6BL27ycAxy7t0ZrB2XNYN1LkpKqa/nplZF3so0W0C5IvN1Ix2Tyquo6Wgd2y4bKFD/uDaNLqTPBcIdlL+iik/p9G7/tr07gu7XqR5L4Czb9Vvhr6oiiFXDN2Q8zQpfQDkgOyC6M3DZNp35pKRBgv2c/1AvNhg78JTfrjHgJkQRjsVBDzUz+QEe6ikQnfvTVv1FYxRLbrVwukSconruAUWeBY/e7XK7cHIXTPT5zfcjCx51oYxUGj6Z6tpA1iUhRCpElcK79RY2oB0JFy4Ih1+Tvz/hGfrC9PmpD0QEZ7WF6XA1gE5jPT/GZIgAEDMBLwOZW7Y8iejm0LMAviwzVdB3OwYaBxYRHCJHIh4ALE9sZCp4wNnTZP5rjFvlGG0C7Gl+0NTrV3vj9vl18Ey7io8L66TfGhJxJ1tG6tgFy3f/iOvOB1apQwLGk8q1CdUJ9FHw7DnmE/wpeAV9QCZgBkjLTAa86JAioVnGvw9j8GDNPbbut0eY4dn0yU0icit0SsuC61Wwmpyn3P/vCs9A9SXj2pZ18UjjC+I/QQoNjJyOXUhuDy+rshMQ4EJHXv8TYTz5u+fVZE1PYbndcHc9F8YAWVV6DQXchEM3uPXR0D1S5XNLRTReMdLLC/hisOYoHsvod+d2YDbaJ0C3Rqrt3/7NLhhRQYI6IhAZJEFi/fbtaQwEB6vUmJwt6hYl7bQ9QvqgwuZG1IryP2v
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199015)(66946007)(8936002)(4326008)(7416002)(5660300002)(36756003)(54906003)(478600001)(316002)(2906002)(91956017)(2616005)(76116006)(558084003)(6916009)(38070700005)(41300700001)(71200400001)(6486002)(186003)(53546011)(6506007)(6512007)(66556008)(31686004)(8676002)(66476007)(64756008)(38100700002)(31696002)(122000001)(66446008)(86362001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlBRZ0Vra1dSWFBydi92TjV4QmJad0xvV3pQNEZNM0J6UzNPQVVJOSt5VWxn?=
 =?utf-8?B?TlBKcjNOWWxsKytlNURIa21TVTg4bzgrdzBWNzFuZXJBT0xMYlRtQjM5bERU?=
 =?utf-8?B?Z1gvaE13SCt3ZmRibWdFb20vTnBYbjJwOVBmbGMzMXB6N3A1cFNyNFFMaWo0?=
 =?utf-8?B?MjRTZndoU2xvVDJ4TzB0TStZc3pjd2tJSXl6Vyt2bFBoL0Fhbi9UTDdvbUxx?=
 =?utf-8?B?cDdkcTBiMVVsd3l3Ym45SWRFVGxuOFhyS0wxazMzeUE3a2srN2dSVlQrZ3FR?=
 =?utf-8?B?ckZxNWt2RjFGd3NISVlRbXdTN0pwdFBaQXYrRDJNL3grZEVkUC8wTUlkMGhm?=
 =?utf-8?B?TjlsZ3ppL09FK2wwSnpKRVBMcnRVM0tIcjBHcGhHdzlyRVRnaVlxTUtJdkRp?=
 =?utf-8?B?L2YzdkN3VzF6ZFRzejNoUkpSWTRZVURPVjlNSmx1OXVjQ2ZVQXBqdkN3MzZM?=
 =?utf-8?B?dVNhUHp0TFllMHJXZURLdXpDNVZRK1RZcitOZjFGZlI1L0NQTzVTT3RtbjBE?=
 =?utf-8?B?NkJ6OFZpVTJrdVRDeW1TanRtMngzY2RFUkdpbzVMM1VFRFFOOHc4amZnV2JV?=
 =?utf-8?B?R0I0SmJlaGNWL3Z4WEo4bWliNXJjSm5TR0JCVG9MOGRFbytEOWtyZ3FBWW9M?=
 =?utf-8?B?elRMSExidnVUc09JUGZCellpL1JLdU5LM0RqMnJncXJpN2htOWhDSHA1Q3ov?=
 =?utf-8?B?SnVONWM4bFRwNU9mQWo1U3I2Zmw2SlRCREJGMGFzeDZVVEIyR2t5S1Yxb0F4?=
 =?utf-8?B?UzI4UWpTM2M3UGRmMkZLSW1uR0lCeXk1cjlqSnRXTVF5aHMvOU9ra2IwcFRQ?=
 =?utf-8?B?RTkwUllUbjAzMFNHcWlWdjVXUS9YMm1aaTNndW9BcTlYODBwSUVvcXBqaXZr?=
 =?utf-8?B?TVNzaWJOWSsraitlWmZnS2xEL1lxcGVaRVpqdUQwWCtuNlBrTmF5V2tCMi90?=
 =?utf-8?B?TGxMcmc5R056bUFtUWZnZnZRcHF0MG9zWmMyYnVRd2VIWHVIVFoybzVwdy9a?=
 =?utf-8?B?UHk3YlduVWZtVFY2KzJYL1JoaGNQWVRZT0NSS29SYmlhMjJNKzVEQk5TZ3Az?=
 =?utf-8?B?cWo2MkZBQUhoTkVHTzRxbHNFZ2RENjI4TjBFVVZjZTlhV1JZQ2U1YVRwWkJJ?=
 =?utf-8?B?ckF6dXZSVXhMVGFQRXhxa3Y0dVpNOUJhcldzV0hBNzQ1eUlwNGJzZmFRNDZm?=
 =?utf-8?B?dGhTWCtIMnZuaCsrQkJUcjF6TEU1WmNxVzJFS2hyTnBmWGpoeEpHSGk1Q0E1?=
 =?utf-8?B?WnVSdTgybGIvNVpuUitIc0FwREVxRTgwNGdNZzRBam96cEx5b3A3MEpUYVVG?=
 =?utf-8?B?VEF0cVZReFFUL0h4SmFaUXFMK2JBTVlDK0l5bWRvSWVKQlVyM01DdytmNUkx?=
 =?utf-8?B?c1Y5eFk1ZGRaZEI0L0YzQjFFN2hhME5IUnZQc1RPa09nMTBRRmRlQVBVVXMw?=
 =?utf-8?B?WGFzODQ2c1lvdlhJWlVKUWxLK0xBNmo3em40TUswR0JpcHE0c0VCQWM0Z1lj?=
 =?utf-8?B?Nld3WjlsRW5xQkNvU1locDV2MGNsR0lUbENDd1QyYjA3YS9EY0hxM0tqNVNN?=
 =?utf-8?B?c0lKaXB3Q1VBRDRFTnJVakZiZ3E5VlhLZFBzS0JiNkd2TmlZZFpOSmFTUXRt?=
 =?utf-8?B?OTFwVHl3UVlEUnZReTVFVGRmQXl0Tlk0MVhYQUtxNVRkMEllQU00c0x4QUxX?=
 =?utf-8?B?V0FYMGdKYUpvLzdLK1ZEcW8rdFY3RjJIbU5Wa2tFOTFoMnFkbm8rRjY0OVZ0?=
 =?utf-8?B?TjQ4clZVeDV1dEgrTHM1dHRTeis1QXNvU0liYTFPQU96endFZ0t3NWZGVjlp?=
 =?utf-8?B?SHNicy90Mkp5QUpRMXhYMVVWVGkvSDA1VUdFdlNGWjlHcHhseWZrYnh1Y0gw?=
 =?utf-8?B?WHQvdnF3Q0VlSlp2eFVDOEgrdUJydmw5dGRHakhwd0ZIRVRpM1pSdWsyUzEv?=
 =?utf-8?B?SUsyaCtuVFVMZFJsSXQvNmhuZ0pWSzhickNRa3ZzVGRlQ3gzRFk5SG84bzVp?=
 =?utf-8?B?OWlxd1pabGRuWUlENVFkUVJXdDFsaFVKQ1I3bk11T2lNWG9Ca3dMRWdEOWdC?=
 =?utf-8?B?MzBteHhYbEE0MjZCRlhCQ3MxTTROdUtqKy9MRmpVSDd3UmxLOXFpYXNKU0lw?=
 =?utf-8?B?M0NnZ0NKd21TaEF5VlIyNmdxNW8zamdqT2llUU9xL2wvZUUwUnJBNVJOU2JJ?=
 =?utf-8?B?elE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e97965-fb9a-4be3-815c-08dabbc97ea6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 05:25:31.3539 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7H32oujuHEwu1QXYys/CAaAeJw/hfrZQxHgAL46bD3wbz7uOXZTNuq+aNtcVFX4qWPuouIqHqeBa/JuTBCdMUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v3 08/19] nvme: Move pr code to it's own file
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
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
 "kbusch@kernel.org" <kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F1A3810BC69AAC44AABEFB1F6104E4D0@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 10/26/22 16:19, Mike Christie wrote:
> This patch moves the pr code to it's own file because I'm going to be
> adding more functions and core.c is getting bigger.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>

Thanks a lot for doing this ...

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

