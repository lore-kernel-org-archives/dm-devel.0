Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F7CC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119134;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PdrP13pY+ifVML/j1keBWvYL/dV2t+Y1+gxe5+TgNz4=;
	b=CijgnBes5OyCCnxq+OPmwdordUrFE0di0YjDdP1ihVJEbDU+c5bw2Sx3EuH5qnHh+tlyiF
	m2gOJ6f9Q+cgKEr6OmyiwKiAXLKleUZp7f522FMopp6zox71uV+GAqnhcMyA9tEjNTBnug
	Yta2kAqimGqDz+0azQgWqLP0mL/IQnI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-1v5ZAAdaPl6iA8Htn_jcNA-1; Wed, 06 Jul 2022 10:52:07 -0400
X-MC-Unique: 1v5ZAAdaPl6iA8Htn_jcNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 977A41C18273;
	Wed,  6 Jul 2022 14:52:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 816152166B26;
	Wed,  6 Jul 2022 14:52:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4485E194706B;
	Wed,  6 Jul 2022 14:52:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DC0AD194704A
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:40:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CD44141617E; Tue,  5 Jul 2022 06:40:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C5998416390
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:40:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACFF2296A600
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:40:56 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-y57VJwjROnupZdSf9G-n1Q-1; Tue, 05 Jul 2022 02:40:54 -0400
X-MC-Unique: y57VJwjROnupZdSf9G-n1Q-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BL3PR12MB6476.namprd12.prod.outlook.com (2603:10b6:208:3bc::8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Tue, 5 Jul
 2022 06:40:52 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:40:52 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 10/17] block: pass a gendisk to
 blk_queue_free_zone_bitmaps
Thread-Index: AQHYj6P9kVX7BLMFo0SnHYanYyYjjK1vVRCA
Date: Tue, 5 Jul 2022 06:40:52 +0000
Message-ID: <62e52c80-183f-dbe6-dbb8-c303ced4317b@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-11-hch@lst.de>
In-Reply-To: <20220704124500.155247-11-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b4ff2e3-c526-41fb-e3c1-08da5e514e31
x-ms-traffictypediagnostic: BL3PR12MB6476:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: XH7n+6GqdxPWw/cxK3ISn8hNAFu0jNNlAssEWNz34dYRV5RBuiSUYPkCe5q0eItt/lnR9YDUmWUblYpRENfJLq1o32hwyO4OuzxH/8lPqI1XTMHHVwjCqIRNVkMDokC9OGaJ3Iwr+NXuquFm1gBSgE31keRNgqgF8SNvzgFaLGyEpnhyBWzx5/VEiKz32i5dDcL/8JmbqlMO2ce50sldhZRKAQ/OdG0d1H+x/QxDoMu3gfD+Lzh67lc1E8UQvOWRXed221iGkVqR3piI3Slzldfzt9iITR/WnYeDZBDAqNLT1kSMx/qPXPyvWrsbPKFz7zX0TyLFJ8qPRl/qpgaKFm9kB2FdHTsO1SWPQmHmtQ2G7bEiNyBBjldnDLEl4PCdQjn62gjQUVDxJsYq5EvZYZPGI5+V9WTWGyor+goMnrAxk0oVEPbKMcd7M/dO1I6mIopnJVyNFguzZ9qioDmKBNkY5ZZsBF7VpeTQdaQutg628oImavVYbtQ2qBJTrr7GJqKXGN8ZFqEgxzONwoLJ8dB9dt1icgLD3hn+HC+F6NfRFiMIk+KUUAedZ+0uvsHLIgZ8THzGkEbljVRjmtQ1YdOOP6faoD+5NKvhHXvdSEcnxJE2yDEThKrITT8yFYuunzoY96PI99hxxyextAJ24vVyioZMlzPggYHoT4pjBL+qOsKPLot2fxZdQlJ/v5D2Y6dQ+b1h0kEYQk3dBvfbbicFqtzxKOm2mgVW15PWRoWcI62z/WQjTBzU3Q6EajFlnUJF1/zM0bIidDrIHWNZ6N7MMg6lX4Q/o25SZLjztcu3nsr/VtiDYMfSIaDOtkXQ3QxRrvX9ebNEMJ505L5BxoQoXlGQCyZNsrGeR2Xa2+lLInQHT8NQ36ovINAjUeN2
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(6512007)(71200400001)(66446008)(38070700005)(2906002)(6506007)(478600001)(8676002)(4326008)(53546011)(86362001)(64756008)(41300700001)(31696002)(6486002)(31686004)(558084003)(122000001)(83380400001)(36756003)(186003)(5660300002)(2616005)(54906003)(66476007)(316002)(66556008)(8936002)(38100700002)(76116006)(91956017)(66946007)(110136005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGhTZzRKc1Ntd1FZZHJTNEtNcW93ZGkvWkZ0QTN6aVZTaFZrN3h4UXpjTzZD?=
 =?utf-8?B?aDExK2FaQXhCVlBQQ3pkSXF5UVBsSk03RFAyc0lmSW1rZ09LbFZ2anZOb25Y?=
 =?utf-8?B?c0ZVMkpUVU1jdjRrTjdiMXQzVGp5UVIzM09GL1pRYUpSS1Vsdk5pWVlQYU5Y?=
 =?utf-8?B?TUx0b1hmSXQySHpjMTdNVFBlMEl2YVk1OFVxNUkzbUR0Qyt3VFcxNFR1RjNs?=
 =?utf-8?B?MzRydTVubVBzWUFnNXJjamhRcSttVlRjM01RS3ZkY04xdjl5MWFQOW9KOFYr?=
 =?utf-8?B?Z0UvaUVRbnBQRkRKRkw3d2tkd2UvanhHV0hwN01VTWRoT1ZVelpGOFVmb1d5?=
 =?utf-8?B?U2haOTFjSHVlTmVkYmhQMGx0VTJMKzFpSFdxc3JtdzRUSmp6RGVSOEVVcWRx?=
 =?utf-8?B?bHd5cTdQV0ZvSEQ3SU9LSExaMFZ4S1JLNjJHYmM3Wk1Fc2FNcVRhU3AzdEJ4?=
 =?utf-8?B?UERrVFZXOWxvR0pPMWZoV2t6bGNTMGZVWmJrZHB2dWxicml2MUtGTThQUktF?=
 =?utf-8?B?NnVyb0hOS1hncTE1YUIxN3J6YU1FZm9zbHVPenBhQlZacDFsMXU0NytkS0xh?=
 =?utf-8?B?NWE3ZTNMWDdlRzErUjMwQk1PSzI5NUZ0eFZ4cFJXU0tWYkM0YzFTaUx1N2ZX?=
 =?utf-8?B?SnAvSVAwaEFYaTgxcjAwVFU3QXNFcUhJMkJpMlBtT3I4RWM2VkdQcjlIMnJj?=
 =?utf-8?B?Qk1xSGRNZVgwREFtVXgxa2k2alJlbkIxa0FtRDhzbW5BOVVaWWJRNjY2Smg5?=
 =?utf-8?B?YlQzTW01d2QzbkplSmhhSlluaEJKRFV1aVd3dVBCNGpnOUx6QUUxUTRKSUFm?=
 =?utf-8?B?UlUrdVpidHRMYWJyV1lHQkl4UytKb0w5UGVSZ3cvSVlDM3hKQ1gwdHBZNGkx?=
 =?utf-8?B?UklFbnZJS2NKZUNFZmNvQXVjK0NRU09reXlxei9sWHRRR00za1Rvd3l5UmRG?=
 =?utf-8?B?SE5MWnRJM3laOWZTL3dsN3B6L3ZsRzVYN0JaVDJqelV3Q2xVbVB2YmlFbFRt?=
 =?utf-8?B?WnAxOUk3c0VWWXFBVWtCd1VleWd1WHRmaGZobW1oSW9vZzg0eFVON21GcVZy?=
 =?utf-8?B?UndoQWFLVTNKVFZKK01WRzhhZ2M0YVBkRzdWdWdsc2RRU2RPK0VZSU5mNlI0?=
 =?utf-8?B?bnJMeU1VbmpnZkpDeGRieWFVQTRSajdCc0hqaFdkaUxTVmNPY3MrL1UwWVpC?=
 =?utf-8?B?RjY1TEpWV05ZZFo0ZWJhdnJqNThuR01DN0Fjc0ZCUWxtMGNSNy9GY2VpYnJL?=
 =?utf-8?B?T2RyNEMvb1ZpTFNybzVuMmJhY1hlQU9Cc0ovaUN6Vm05TXZ6clRCb1RIdnBB?=
 =?utf-8?B?cnhUYlFtWUc4dFhGQWpiaTV0MW5hK0E4R2R0VGhoUEcyMVdtL3pxRlF5ZFkx?=
 =?utf-8?B?QTVSM2Z2N29KUzBkMUJlWldxL3MvWGdHNzdHQjdzUkZHVWI4ZlhUU05KQnNF?=
 =?utf-8?B?WThESVJqamczUUdKZUNlZnRjMGlUcGtIaTl5MXpLWDVMQjZsQUNIODNtdEpt?=
 =?utf-8?B?V1U0TGhVRDU5UUlnaVZjN3N3cVAvY05DTWYvWFd3T3R4K3R3bm04THBpUUN5?=
 =?utf-8?B?MjNuUXlpTWo4QWJvZXVqM3Z1VzRqWjg4dkhTTHJEaDVUU2pHODdOUHZGbUdB?=
 =?utf-8?B?OHBnOC8vblVhU2l2Y0NSMFFTdHpjU0R1SGhDQVF2S0JNRU5iZVNDSzJkL2xX?=
 =?utf-8?B?ckk2NWM4STJMektpNW1iU1ZNYnEzSTIyMnA1VUZRUndPeHVmS1pCamN4Mm01?=
 =?utf-8?B?YURPb3dmTENOZ1V1eUZ2b2hCOWZQMllYVUF6dnN4UlAyaUtlL2tRbzRzZm41?=
 =?utf-8?B?MFBZTXJUcyt4RytFNjhjb2hCdlFDc1Fkcm9NQWFCU2dvSFA4RnY5Q3liT3BS?=
 =?utf-8?B?SFpISkpLVmpRYzRDQjBuMnYwM25uMEx2T0l0SHkyUXVtdWtGSDV1TWo1WlND?=
 =?utf-8?B?SERXLzArNVE3TTJCQ1ZxNlJjT21ocGJ2UnZlNE04TGUreGROY1VzYXpEeDVp?=
 =?utf-8?B?a0I3K3BBOGd1dE5jeTdvdW5wRVppMmFMTUt5czhLejdrbTJnclF5YWo4Zkl6?=
 =?utf-8?B?M0JBV2R2YU9jZnRFUGxYZWhnK3ZqVW9jNVJBbCs0VnpHTFhYeEpFMmJxRjA5?=
 =?utf-8?B?Q1VpaDdST1JKdmlJTDF1a3VqYVZUMEpVOXhkU3Q3b0Q0ai9GdXdPaHVBQkd3?=
 =?utf-8?Q?9kRgXyRR6AxrDi97BV4KEVVUZHvl6grr5QCcouLpg6t7?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b4ff2e3-c526-41fb-e3c1-08da5e514e31
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:40:52.3288 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VqOI7ZM6zKgA//VCh8lN1i7lN3DO6Fz9LGlXDFicGitosKYTRotqSxS2OJnsXl3pa5TWe26T77fRlVMS8fXUIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6476
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 10/17] block: pass a gendisk to
 blk_queue_free_zone_bitmaps
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9AD1C79E4CFFEA4EA98FE6E085B98DA3@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:44 AM, Christoph Hellwig wrote:
> Switch to a gendisk based API in preparation for moving all zone related
> fields from the request_queue to the gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

