Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CACEC54EBD
	for <dm-devel@archiver.kernel.org>; Mon,  9 Jan 2023 07:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673250149;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uqybJ/ETZ5OminnG3NDQP5FVi9vGI2oL4yVjDAYmVT4=;
	b=eAaJyAJP0uWrtKkmKc0qo965ixpTLqfdsFeyRlLqefrchuWq7IK7imQT2gLh+pz77aHxSf
	cmfKyrJazwN27TzF6VazSl+9u6LDTx6oKvPOWglOHYzzj4B4bFzl9M1TDve+cw+/cbJBWY
	IqjQKtkyZPErsbiLmKGVUhSLC14Ihdg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-peb144L-N0-TUkPHez0vDA-1; Mon, 09 Jan 2023 02:42:26 -0500
X-MC-Unique: peb144L-N0-TUkPHez0vDA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14EAD101A52E;
	Mon,  9 Jan 2023 07:42:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4C2E52166B26;
	Mon,  9 Jan 2023 07:42:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2CA1219459E6;
	Mon,  9 Jan 2023 07:42:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 79F761947B84
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Jan 2023 07:42:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1BC5D2026D68; Mon,  9 Jan 2023 07:42:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 13D982026D4B
 for <dm-devel@redhat.com>; Mon,  9 Jan 2023 07:42:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E28CF802D2A
 for <dm-devel@redhat.com>; Mon,  9 Jan 2023 07:42:00 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-5nDZBGUTP-OXo8rxJ6O1bA-1; Mon, 09 Jan 2023 02:41:59 -0500
X-MC-Unique: 5nDZBGUTP-OXo8rxJ6O1bA-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN7PR12MB7250.namprd12.prod.outlook.com (2603:10b6:806:2aa::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 07:41:56 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 07:41:56 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Thread-Topic: [PATCH 1/7] block: remove superfluous check for request queue in
 bdev_is_zoned
Thread-Index: AQHZIammwKDv9lFNrUaYH7I9XXAa1q6VuF2A
Date: Mon, 9 Jan 2023 07:41:56 +0000
Message-ID: <71b2163b-8d25-ad50-4852-3a0669df11bb@nvidia.com>
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083319eucas1p1e58f4ab0d3ff59a328a2da2922d76038@eucas1p1.samsung.com>
 <20230106083317.93938-2-p.raghav@samsung.com>
In-Reply-To: <20230106083317.93938-2-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SN7PR12MB7250:EE_
x-ms-office365-filtering-correlation-id: aebb343f-28ee-4e5a-a253-08daf214fbc0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: UOzwKS1g39qMxb+qVS9lNjwKwufRRZiSXZ4uw/0RzIbM9PFW+2uDLzoftDe5ns8rmr+flbZ5E+0P1lMBkr6d3FqGMUnozI0tPedbxVYL8tkZlaIaccAjLbVwE1Tndkqg7LKchYq0lNqtcULmlskh4loWBga58cfsXYR5rGWQYUTlxtFO5gBYOrk78vRKh3b0XKHys/02CnIHaT4TGU/0mp0H5AM0e1Ey3gW4GI20sFu8DTNPnL8PHUQrPIDjAGY/W53gf6iegLBCBLOiD5meyUDppQCvudrdDMhie0jNtS5EoRCJBQ5TikL2xAanR7xHc72g91WqRITq3N+DNRH23asy+udqNYwUTd6mX6Qwq9f8QM4JZOURnV5z3Jn1GdnTT18ytpobNZMQwrKAkZ0RDGz3eSAUiNaelI1b3DyGt9R6GpRsVhnuj2HD6/WjzUeT8Dum76Xk0juHR9rDn/sVWFzYOGOXCfXcP6yhdZOJnQyMa7R01VemhnMBM4UyDwm5f7sa10LZDyzYDkvKUp7t51uzbNZNiHDmR1pxUL1H1zWJyxxFK2/S9Ag1a1slYBkQwF8L4Pn5CxJjdX0HJFs789c37qp0YjRWsClBVR0S0khQN7hB1JznA/M1VHXvwR6gFHI3+IUnTsiX0la62rRnWtDOOQqOX8qJg5AUqZOb9o95teu9cK4mnXMNxe9lsWp81fJfDoT96sICOsH9Qco897bKfgtMlaJvkxJeU3nqlkF9cOykwnYmP+sT2J0e6GIk1hKYekCk4jTBR4CJyENCIQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199015)(6506007)(38100700002)(122000001)(53546011)(31686004)(2906002)(6486002)(478600001)(2616005)(558084003)(186003)(6512007)(5660300002)(316002)(71200400001)(7416002)(83380400001)(8936002)(36756003)(38070700005)(86362001)(31696002)(41300700001)(110136005)(76116006)(66476007)(8676002)(91956017)(66946007)(64756008)(4326008)(66556008)(54906003)(66446008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTIxQURFd2hza2dyRzR0emwvYVVsK1FCckdXWjB6M2Zlb0t4ZlFHcmtibWxT?=
 =?utf-8?B?TlRNM3JnY2FDT1FuMkJ6WTVpOXdVQytnVFZQSXRQamM3d3FIdm00MklpbDZr?=
 =?utf-8?B?RVo5Q1ptM1pydFVsRXZac2RwelZoNEV5SUQrZzJhRHRzNExoU1hzSUs2RGY1?=
 =?utf-8?B?bXZvWW5EOUIrWFQrOXhaaXBPQTNsUG5mY3YzN2xSbE9rcm9ycEF6dWFISW1o?=
 =?utf-8?B?UHFtVE5xMEhHT3AwSnIvZFRHYTRRV283RUhuVDVqcmZyVWFJNUNOKzJvZUxr?=
 =?utf-8?B?S244a1RpUmhxemkwYjMvaGRWc1Q5RE1DNWxxellzb1VhcUp1UjcrSzAxNjda?=
 =?utf-8?B?cjY0WnFWc2svaDFqOFFCZk4vRFhDeWhIYzFjajFpYXkvc0FCWDJTcXFCaDVE?=
 =?utf-8?B?UVo2OUN3am5RUjlNOGUrNEhkQnZCQlBIWHF5OTNwR1BTUGpRV0pjZzc4R3lM?=
 =?utf-8?B?N2pybHNNdE51b1JhcTcrWjhHQ2ZpeWtleURwOVo0RExwY0N2ZjZCNkFpM3Iy?=
 =?utf-8?B?RXhEeGpJdWZ5ZHRZQ1VwSWlGdVdsQ3JxQms3KzMwWlkyQS8rZHAxT3orOUo5?=
 =?utf-8?B?WWZzd0tVTGdHQlpaSFV3N1VSTjJFTTQ5Y3BJNmVBSUtLT2xVSCtwRG5jMzE2?=
 =?utf-8?B?NVhyZVRwZC9ZM0I0VjNKNGxjUmsxOGhyWHdrRjhiWmdkcUVqRTFmZUVhVkF2?=
 =?utf-8?B?UlhnUzNleENIS3lFcVZFOTIzc0F5cXlhYkY4MTdxVFdwRHYyLzlDTXlZQXlU?=
 =?utf-8?B?NmU0Y3MwbFhRQVBXUzMySHlMTWFNVTFkUHRqeXJDT1dxNHMyVnJ0MTBQV1Yz?=
 =?utf-8?B?YXcwRjFNeW15WjhsSmZaajFacTNFd1NTS1E4SWJ6QWVac2pNa2FYR1JiSFhZ?=
 =?utf-8?B?TzZOUUxGVlcyWjRuWmZYbHdaUEJzVlJ0Q29MZEpTT3lyK2tFaVBKcjQ0dkxR?=
 =?utf-8?B?b3dnQThWSWdMaHVNQk9ZMkZhVTRNMzBONWM5S29rTG1MOWhQaGMzOHlIOU1s?=
 =?utf-8?B?ZS9qMHE4NEdvRzlCUDhKYWhReExzeEdYT1l3WnNFSEJLOEl6MUJZSlV3Tnp2?=
 =?utf-8?B?QUV3MFpjYmt5d3VMUElaWVJ2b256TTFRZEtDL1cydXlNcVlXWnhJc2VZRWlB?=
 =?utf-8?B?L2RWUVBsQ2hVYU9WMEl3RkZCeC84UlNaTXNkb0FpUkhMdVBJc0xpUDJBRkdq?=
 =?utf-8?B?N3ZUWWVpZ1ZXQWU5bDgxUHQrNkoyZmlRdkluQy9MbnlMQVUxN1BKTm5uelhk?=
 =?utf-8?B?K1V3blcxdldBOU5aRXErSVIrYnFlZ3RUUXpSWVVuNjZrZGFxLzdVM29zMzM1?=
 =?utf-8?B?Tmt0dmU4ZVE2MTdCMTRqQU92QlVBLzFHRy8zV2pUYVRzYVFBV20xS0pYZTNI?=
 =?utf-8?B?TC82L05BUHNSNUVCYzJiWHIyWE0xVi92SmZjTm0wcWl6bE5uUW01SVRtdkpz?=
 =?utf-8?B?RmdQUjdDZmFoVzJsakZUcFlhdnRiRUdVYTlxb0JXM3J4YU9PV1RaVER5OFJj?=
 =?utf-8?B?YlBydEdYdHh0MTZwVWQ3SkJvbWNsbldlZmJUbzZNWUx6WGZ4YmRPb0hsNWZk?=
 =?utf-8?B?WlVVSWdBNk5OZUZ6cjVQTXB2ZmZZSmQzYUJoZ3VDY3JWWVVJNDVPVi9pZDZu?=
 =?utf-8?B?NkpLSnVuN2RseEhhRlFINUxnTWFXaGVUUys5QWthRzBkbVY3TVJIUVZQK1NZ?=
 =?utf-8?B?VFo4YjZ6dnlOVDNHcjdLK3NmcGhxV1RMY3ZqQm5KelVtR2lUeHdrcmNVYTZD?=
 =?utf-8?B?STAzT1daeTMzZk1tbkcrYzluVEJFZDBMc3BkRk05OVhZTnRKdFR0ZnVjNXQ5?=
 =?utf-8?B?TVRaQzRJYmFXdktEWFcvYmJwWWR3NjNtU1RraFplUWRweE1PRHNSZEFkRzlY?=
 =?utf-8?B?NkRxcHV6dXNLM3ZuSUFKaFBYSnpPa1lNdzhUbmhtVW5ua3AyR0w4SjJZcVZM?=
 =?utf-8?B?ZVNBVmpUdGdmaXVyamZKRmVxOWNYOXI5UHRCQWxvQjFnZU1GS2F2UFpiUThx?=
 =?utf-8?B?Rm5rUzZvTklkYTFxcWgrVWZuSXFPUGIvRzQwODNsRy9lSllhYThqM09TM3BB?=
 =?utf-8?B?UG5FTXUzZi9oSThEeUxZVTZ3MlhIa2xlaXdHZE5mVVVkQ2kxRUE1KzhjazI0?=
 =?utf-8?B?OE5SS0JscEkxRFJWdWF6UGJ4TFNYSVpWWGlnSlZsa0hVNmFyUW9DVXZObXAr?=
 =?utf-8?B?bWc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aebb343f-28ee-4e5a-a253-08daf214fbc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 07:41:56.2851 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 68+b8vmEB/VEL22BZ+WXCC6hDJWcpk0fCpNbpkGjBiy+PcWF5jEw01JUTHlbfq3WRnz7Y2S6xD8ggh1zY7bd2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7250
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 1/7] block: remove superfluous check for
 request queue in bdev_is_zoned
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
Cc: "bvanassche@acm.org" <bvanassche@acm.org>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "kernel@pankajraghav.com" <kernel@pankajraghav.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <79B9F0E9CDA52C47903779A79E81EF3B@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/6/23 00:33, Pankaj Raghav wrote:
> Remove the superfluous request queue check in bdev_is_zoned() as the
> bdev_get_queue can never return NULL.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

