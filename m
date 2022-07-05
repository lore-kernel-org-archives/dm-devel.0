Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 785F4C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119404;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kJ92uNQxXhOnXRTYb5v5Edz0dEvm1nv0M2+Siwnf6gA=;
	b=SGR0lykz5P4B0SLyq6hBsu7zi/Ip0nfDie2J8rqIYxSSV4ouKaw6NBvks+Acltq1mGCJaF
	rvc/kch45/96X+29ppHbKsmePKb7wRUAmCqZ9uCIccSYPafiQkAXoD3aYhgxkSRL/TPN0n
	mMEVKcx/nh5zQRtBfrdh10o2q/EVqgA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-YkdlD2rkPGu7LII96MwAUQ-1; Wed, 06 Jul 2022 10:56:35 -0400
X-MC-Unique: YkdlD2rkPGu7LII96MwAUQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F8BD2932493;
	Wed,  6 Jul 2022 14:56:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0B1831415116;
	Wed,  6 Jul 2022 14:56:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5B2441947079;
	Wed,  6 Jul 2022 14:56:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8F1781947054
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:29:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5DEE440E7F29; Tue,  5 Jul 2022 06:29:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5973040E7F28
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:29:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41CBB1C0514F
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:29:54 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-cCxYhbM9PmedseAmrRAyTg-1; Tue, 05 Jul 2022 02:29:52 -0400
X-MC-Unique: cCxYhbM9PmedseAmrRAyTg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1134.namprd12.prod.outlook.com (2603:10b6:300:c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 06:29:50 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:29:50 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 09/17] block: pass a gendisk to
 blk_queue_clear_zone_settings
Thread-Index: AQHYj6P63JXdZnrMME6+VVMZ51uta61vUfuA
Date: Tue, 5 Jul 2022 06:29:50 +0000
Message-ID: <ec663d63-14f3-550e-cc2e-4c6db8dc1784@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-10-hch@lst.de>
In-Reply-To: <20220704124500.155247-10-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0637bdb5-6d53-4e14-3576-08da5e4fc381
x-ms-traffictypediagnostic: MWHPR12MB1134:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: +5PPtcY9ZqoBo5xt8xAKixD8WjqxWx2BHLFqZErqD4H7DUPf5T3OofZZfLDWFoRAD/3X3iS5ij0eCPJgoNAX8OMwxcfX+8rt4Y7sd0Mg1UC+F1GqYAtX0X2yCZUasSnctV5dHxqQD94knwoyE3TP/dYVzoxkjoxdjIzVaxJZkN+TzADfiSS5zoUtmKuox4Vd9ppJR+eQLOGoCXArd+5dI8l8cFuPAGHJOBJxVjLe1/S/kgo9U4SYKInuSlBs/MqunPYPbRR/N4nbyKJIayJqbHhU59aP+oC33vZaJ7w5EqKJur79dMkZC1n9ng5UbLl6m/3sT2Iw1XEBfqqkQgAgWlZf+CRMh+yY1/oPbb3z+9olec4XxlpyJd8EVHsZ6iBxqi3lPjGcbTHKE4uOApEC9ofDcOsbTVFJX6BAPevCS+rCHuIRV+OHbpijD5YH/dbzzogs/IncQqFCgPPxjMBZNwv3+K6WsmdjVrB53ErMnvux/sJvc8Sx/C6Ywp5BgFl/e88jb4dRqgRKUiTzZYyi3wxIqp/sPCGvQ5P+Ori7qBgZEx7iR3CQdl0Scg3OHgjVjRtGflfqC6sP9gk4NZeHK1K0u71QQwZQixJYYzYIGoSqyPK9NHlgt4UpOs+O2/4QMtgy6pubMCXdh2YWdvz2aidmk3aOxiknV3snmvhqqkBqUpaBBXva8lsYObshP1FnfBugJsbZaFjj2n+/KbVaWraBOu8E1gKlk6xHVxnI1SKGSzb/Odg/0XJydmp2dsUsMEQpaEi4RC3/7rwiwcSSbPzTV32aMX4ekYy2BlmQnEVexZyBF7Uc0QdbKWqMlSXvDrPZMj8mhgFdRC8OJrrcSwdclGZkQFYgG+3CTOzD2XUdl9gCZzqLbyi4+uqA2Db4
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(8936002)(31696002)(38100700002)(6486002)(86362001)(478600001)(76116006)(122000001)(66946007)(6512007)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(4744005)(5660300002)(2616005)(71200400001)(91956017)(186003)(53546011)(316002)(36756003)(31686004)(54906003)(2906002)(41300700001)(6506007)(83380400001)(38070700005)(110136005)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXFMRS9vWXhEZStWU2czR25tWlBUb3ZiRi9rYVNSTlp6Ujd2Vzl0Y2g2WWJM?=
 =?utf-8?B?RE5jY2JvSlJvVVpydm95LzV4a2ZWK1ZuRWN0azBhUHdXZ2VEVkZJcXRzNGdO?=
 =?utf-8?B?c0hjSU1VcmRVWDBlL0QveW1Eblp1NTdDYVNMbC9LNFZsekhQTnE2dTJlT1BN?=
 =?utf-8?B?YkwzVytTQlF2d2dpVnV6YWJwTmlCS2ExRlBwa2ZxU21vWUhVNE45S2VpMUlS?=
 =?utf-8?B?WE9HU0pJL05na3FFK1N3MG1rRDdFZjhTMW9DdkhQdUpOcmNyODlQRDJIYzBU?=
 =?utf-8?B?dmtrUHlhVm16ZFM5bGltY1NqaXVZOGt6dTEyN3poeWNRdVFCV1Z1MkdVTHJL?=
 =?utf-8?B?UytmUERpeHhUY3BhbGt2M0hSdDV6N1p2ZDF1Rncrb0VmeFBqcTdwN3NkYXFi?=
 =?utf-8?B?enZ4cnhQK2F6em53U0NVM2JKZ2huNTVqa0NZdUdTYU1WRVgxeU5pblBrV2M4?=
 =?utf-8?B?aHVsYXJuOHdzSTk3U00wZWcxK04rdHRUZnJpTWthYmVWNmw1QUFYZVNEdEc2?=
 =?utf-8?B?MWJOa1E4MTljV3FWMVIvWVRQcHZkN0R6MXF0T3BpRjlxU3M2N2RkTENhbW9k?=
 =?utf-8?B?a3hGazg1b1hnZC9QaW0yd3dpcXBVV1BuZm5NTnNsSnNVNDJ6U0k2Mm1uWSt5?=
 =?utf-8?B?S0NDRFh2MXhNdmYvK1U4WEVUVkpWRjNIZ3EwWU9JMGo2Z2xmcmFuMHQ3b3JP?=
 =?utf-8?B?dHBvdFJtSUVEa0xnNHNBYTR1RVZZbmQrK3Z3VG13YTgxS1ZHTXlhM0RBd1dw?=
 =?utf-8?B?aitsZEJ0NE5UZldIeEdpRE5YRTdxak54YlFNSlhNN0poRjBDK1NpZmJMSUp5?=
 =?utf-8?B?Wk1PcnhNNTdhM2VVRDBETXppcVlIYWtXMVY3UlQ5Vnd0eGdCVmFrajNOc1FM?=
 =?utf-8?B?YnBYc29GT0NSa0E0eE9kN1MrSlpOWC9SVnF6cVkwU205bk5teEdmekl5ak9Y?=
 =?utf-8?B?dHp3cmxZUmZDSDdMN0VmNkE5cHVFS3prOGRNWlB6cDAvN1NQYTBRQ2hidVRP?=
 =?utf-8?B?dlhIcUhwaGFsd3JheFVUZHM5VDdCMjVLSzlrNW5CSVQvaU0vQWtITys3a3FL?=
 =?utf-8?B?VmJUdkNLMVNyMWtxQ1VUeGtNY0xLekpJNS9HSm5EaEpyVy80UDJyVVZlcElx?=
 =?utf-8?B?VllMN3RpeEIyaWdHOEllZ0UvZFc3QkpjR3hWbVpoeXhaUkhvanpxaC9VSTJS?=
 =?utf-8?B?K0lVNVJLUW1yaGk2YVRqWjcxSUtnU0RBUE5OeUFsQWRwYWQ0cWZmY0xPZC9B?=
 =?utf-8?B?UytKOEtjdjEzVUN5TzBhd1dFbTh6R0dkRWZINlZXdkczMUhwbXVhNElSNisv?=
 =?utf-8?B?TEpNTTNvTXpUcG1EaCtoaSsyaFc4TytlWjVwTkhkS2pTakY3MG9XSzJQN1pP?=
 =?utf-8?B?SXBnT0w1d2k1UlNnMHh2Q2M0eG9tZVdxRjVJckhLcXp0T2dhaGNreTRiMFZn?=
 =?utf-8?B?Skg2WGpVbDg0eFQyYXRGWXNTK3FVNEdXUnJiM2t4ZnJ6cytPRHBhcXVwY2Zy?=
 =?utf-8?B?MzhPemxlTlg4WElJWDR0b0hSSHVtN3YxWWNHYTU4V3BtUk5BSEhaUFNEOHdh?=
 =?utf-8?B?eDM1YU5hRVF2TE9na09XODFVQWpnNXRwVXNwc2daSEJLUUlwTDA1Unlaclla?=
 =?utf-8?B?WXNqQmJ1ZGt6YTFyMnQzYTZOR2c1T3ROMzV0WkhwdHdVcHVjalZ5Tm9FejA5?=
 =?utf-8?B?c3N2andwemNmbjRrdWVGVXBVUnM4d1NtMlMrQTc5SHQyRkYvZEtxMWhaRmQ2?=
 =?utf-8?B?blpvOUVHNENoQmd1SXYzQklyOUM4aEdtSzRnUlFuUU5VVXF2MTlVQzl4Y2Q2?=
 =?utf-8?B?S2VzV3drRUt2U3JSVjlDNnZEMlB5c1REKzlnYjdqTHZjV1BQZW1neFBCekVP?=
 =?utf-8?B?cHRVV3RSSUpTRVZQa0IySEc3MDZadDRPSGJVZnBqSFRQc2hqZ0Z2VTVaZ2ph?=
 =?utf-8?B?SzZzR0Z6bGVtcDZkRjY2ZzZ2VVRVRjZJT2V0SEhEYUprVmp4bUlUT1NTcTFD?=
 =?utf-8?B?dGFZMzg5dG9BRFBlU1FQRVFsTHR4VU1JcUdqbldqU1pldEd6aW1uSzJCNWx6?=
 =?utf-8?B?UVpoNGE5WXN2T2l6Nm9DR2RiTFl5dHNPOEtZRFA2RzU1RnI4WWFCTW41RU9B?=
 =?utf-8?B?Q2M1T0U4SkltenhXMHJZYzIxZTZ4MnV1YUdVdDhGd1h2K1c0K1ZoU0w5RU1x?=
 =?utf-8?Q?qBxl2DlfTgQfHo5wSqL0+wHaC4UYBbevVxAZpkErRrij?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0637bdb5-6d53-4e14-3576-08da5e4fc381
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:29:50.1486 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LFOZ0pZzYkIfY3TEwDTXktfcIAwr7UKzAaTKVJmwRAuJLycpBYOu1LfPUjYeBebA8eyiXC4HfRAnimC6E1XHwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1134
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 09/17] block: pass a gendisk to
 blk_queue_clear_zone_settings
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
Content-ID: <F8E80994445F5942A6C37B8B680A4513@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:44 AM, Christoph Hellwig wrote:
> Switch to a gendisk based API in preparation for moving all zone related
> fields from the request_queue to the gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-settings.c | 2 +-
>   block/blk-zoned.c    | 4 +++-
>   block/blk.h          | 4 ++--
>   3 files changed, 6 insertions(+), 4 deletions(-)
> 

Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

