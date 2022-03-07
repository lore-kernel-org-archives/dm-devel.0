Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7EFC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 05:51:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-SSwxZg8gNbO1kHcj0Q0Pgg-1; Mon, 07 Mar 2022 00:51:49 -0500
X-MC-Unique: SSwxZg8gNbO1kHcj0Q0Pgg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C06E1881210;
	Mon,  7 Mar 2022 05:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 317BE40146E;
	Mon,  7 Mar 2022 05:51:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 366711931BEE;
	Mon,  7 Mar 2022 05:51:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 00A1F194E021
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 03:05:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C54B62026D6A; Mon,  7 Mar 2022 03:05:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BFAB32026D4D
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:05:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A28DC802E5B
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:05:10 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-M4_PlfCYNmu2XUlumfivhw-1; Sun, 06 Mar 2022 22:05:08 -0500
X-MC-Unique: M4_PlfCYNmu2XUlumfivhw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:05:05 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:05:05 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH 01/10] block: fix and cleanup bio_check_ro
Thread-Index: AQHYL/Hgn+83FMhmdkmqFwvtuNQY1ayzQGQA
Date: Mon, 7 Mar 2022 03:05:05 +0000
Message-ID: <390e34aa-9338-df44-baa2-54777911c2c4@nvidia.com>
References: <20220304180105.409765-1-hch@lst.de>
 <20220304180105.409765-2-hch@lst.de>
In-Reply-To: <20220304180105.409765-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 394fdd8f-b4a3-47e7-6b66-08d9ffe74790
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB1853D00290C3F81D550E6F4CA3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Vph5/CA+7Y2/tDcK8UttjxfJpK/Eid+BuJWWwROlaosAB58tvU3qAXi3MR+gfb+fEslMpOianIVwwlBjsCoxeuVWkUgZXJgY59VpWXPSAqK3tjK95siSwVqSXZK+Vv6fsU8i1lrBvbBJmZSOi8beOSKuhcFOm78D8TDGaesCvFnyoh1hgiucdwGyZjqIlZ5Fz5QWW2eWb9BzRKarc4GZRgEd1rPswwNTEvcrZTKf/rzfySg9lh9FJhFqSpxuWSB13l7MIMgsWAXjfrDMmjYEYri7s2xsLz1t3iXXOh+Soc2Ti12fKGn7j3u44WVHc0bl0G2Bu3/ucdf67RhqRQ3dUTX+xvPGQ5AGWifLyTPMFTOgvA2uSHodBl/BEZbPf8cL82+1RirhRuvZRNRtmc3L7zD+Li/Q1OHrqzLC39aiOejvpeUTvCQy0YaV0XfvPV1o7SaAz4kZK0zrTCvOGaQO4c+MEejLw2WIpTaqVOHAN31fz2KZ5EyP/A0rlOUBOYjSQZkzgc6o7Qw65OEMawLK4Di3S2h+5y+6WCfz6nYXcNH7mfY3VA2Coc2RoiP1cMmO6uhia/nn+Xb0hHrJuEvrInGkfvQoAF+Dc8rF5OYFYI1rOTq74+Daxkz6eNel636HVf7+3esxCcaXKDoLQ1Dkbu6AuwP0ASJjzJr1N1Sdtw61tS0N6C1u4FovxCZ1+z9sNUqm2xLsy9MbNKYW3+Js99fqaBwNCGCToXT+7TTHI8DqqxxgMgcBaSy6P844hYmiFdrZ0VFbRkXItqQjfDzFug==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(4744005)(6916009)(186003)(5660300002)(83380400001)(36756003)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(76116006)(38070700005)(316002)(91956017)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFdhWi9jNElManI4aUJ3VHpPVERkSHJnc0RScG5SRUJDeVRPd0dXYjNGT2Fv?=
 =?utf-8?B?R2lQTXdHOEZsNFVDc3ZzaTZWc1hOYS9LVzFITUd4K3lzRFZhcHFtbjBtNzV0?=
 =?utf-8?B?LzlyeXYwanpoNXI4NHYwWC9QZU15WkpnclhJT0ZzQ2FBWTMxOEJjYjUxTVRK?=
 =?utf-8?B?M1FTa0ZBUVFpRXN4MEZMd2NqWHJNckY2WmJscUl3Qk1UaWoycGxrZ1dna0Rj?=
 =?utf-8?B?NG5MUndMVFJnSWlVTldPV0EwSVhWTDhTU2wwRnZKdkxNdW1jTlRBc3M1clpL?=
 =?utf-8?B?VTd5ZHgrY3dvdGhLZGwyMmFlQmJMVFJRdzRFdzdOWHpDVi9xSFhUeDhsbXIv?=
 =?utf-8?B?REZ2NHJjenBlOW1xQUZ0MTB4WjA0aTc2dnJDQmhUay81d2crUUUxYks2OFNq?=
 =?utf-8?B?ajdWcVpPc2oxcThuRlAxS2locGloMVN1dnZHN0RyYnRvWEhkNVl0SlBCVGhp?=
 =?utf-8?B?dGcydFptS0J0RlFpVHVjVVFJQlFENy9wSmZtOTFaMzNBRlJLY0t2S1JBbHRt?=
 =?utf-8?B?RSttWFdDNVVNN3lraU1LWGVRd3pMcG9ZQVAzd3ZodnVTRklnclRyNFRIdzU0?=
 =?utf-8?B?WUFYQjlqWWdOMlRXdGV5UzVBcjNETittZHc2OXpJemZmSU92Nzd6ck1lYmJX?=
 =?utf-8?B?RlBUeW1nQ1ozRUttaGFxQmcrYVJWMkJBVERBNDdoZTh4blp6N0FFaWRaZDF1?=
 =?utf-8?B?Y2gzTzR1dnJHZlg0MkRLakZGd2RqRnVWbUNIL1grZUJZcjkrSEpIbUF3MnpV?=
 =?utf-8?B?S3lmcHFvZTF3UkRUZkJrQnpLMmxjRXhwa1pqTEdjNmVMUXFxeXR6RzBDdnpD?=
 =?utf-8?B?RW9SaWN1WkFNZlE2bVNIZVJ6VXdoZjJaNjZ2bnIrQ0FQTzk3YWNwbitaanQr?=
 =?utf-8?B?cTE4Zm0wNjJZbDc0a04vSkM5Qy9XWWwrVW1vV0lkYnZOTFc1U2NHc0FPOFQ1?=
 =?utf-8?B?c2lsQ3FEMHJVMzlyNEI1ZVBraGdBbmExdkxpeUtpVVc0a1pRRkNrcmxORS9H?=
 =?utf-8?B?M1hOUXlmUmk1bkw3OHpuL2hGVWh2b3hodHhiS0FPL3lwZVJuVENvOXlUbm1G?=
 =?utf-8?B?UU56Zlp5VVNLTm43Y04wMWd3UzBhRjdwRDZOTmpaeWo2YWNEK1ZLNGcrYUIv?=
 =?utf-8?B?am13QUhRZ25pcTlsOFNuaWptRFJKaW9MNzlBUG4vRXduazlYTWJQMWZURkpU?=
 =?utf-8?B?akhsTm5vM3hKRTBVbEFLWXVqQ2ZEVFgwSHN5WUE3T2FlYWErUmVaTnFzRWZM?=
 =?utf-8?B?Vno2ZWg5WHZad0ZFRnIvaDNEeG5YeXNub1p0ZWRaZDlIRVQwTEVML0hYSlEy?=
 =?utf-8?B?RjFBWTNQejBDYXZIUy9Xb09Ybzdqamkyc3FOZEFiblhPeDBGVlFWUmw3U1hl?=
 =?utf-8?B?Zm94WXlwMVlRbFk3U3RDaHZRWWh1TStwOUxGZU1CeTVFenRLK2s2TzhJdDZl?=
 =?utf-8?B?dFNaWUNWUVZrcGtLWkJhUG42TVlWem15SFpvdDd0L1pxdk1SQ2xuZ2g2eEc1?=
 =?utf-8?B?TjVxYklsUk5tZ2RpUHFucS9LWmFEcDdDRXFTd3dYZ2ZpeE1QS2ZJaVRPQXdu?=
 =?utf-8?B?dTY1RTB2ZDV3ZUxuYUxmMFpFWnZhYzMwdGJSUlBDRklXRHNGOHFhOS9VK29P?=
 =?utf-8?B?TVZhaDI0MmY4RmRMRnRZaWFvcTF0N1I1M1ljWnZSZm9qL0hzNGZQZ2pyd2dV?=
 =?utf-8?B?R09BcXQzWEVqTXphZXJWdjE4eUROeUhuYUYvTjF1RU1ON0E4bE9QdHB5MDhE?=
 =?utf-8?B?cFZNMW0zemJTRlNoM0k4dVVYb1dzUEs4N1d0S05FRE9pbjNZRU5xVUVNa0E2?=
 =?utf-8?B?cC92R01VNFdxZzZrODIrVHYzcHBlTkx4VU1XTkRGTTk2czh0eStMdEpkYkVW?=
 =?utf-8?B?cFU0b3lvWDJwV0NJWURhckwxR1hwN3ZlODE0TkxVT3poRzk5dUhscm00TU94?=
 =?utf-8?B?c0p2TWhjYURqN25zREJ4eEVKdUtubWl5MHRmdlhpcDQ3Z1lhTk83Vy9XWHdz?=
 =?utf-8?B?VnloM2hjQVRKbEgwU3NzMXhORTVoMUJQbnQrWS8zVzhsRVFpbWVFaHVXSUN0?=
 =?utf-8?B?SndBeTBpRWhIc3F4OFZsWFdmOXhSNk1IRnNYYmhDNVptL21EdG1OY1A3ZVM1?=
 =?utf-8?B?ZnFnbVcwbzQ1KzlwWDI5M1BFWHVnV243VmNqOTlySDNMWXE1emJ6TXRpNTZV?=
 =?utf-8?B?aWFIOFQ0S0cxQnl1Uk8yY2RzSUpNN2dkamtyZm94bzVWMEpmM1krK09OTmpQ?=
 =?utf-8?B?cUtjRUlQMkdSUFdacktNTU56djVBPT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394fdd8f-b4a3-47e7-6b66-08d9ffe74790
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:05:05.1717 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BgRY2GIjHSN+MEW1EX+EbxRQvTf9Gv8Wvivct0n7ZIZsKlorUs+ASqeTfePmHSevU6CCjab4l7jzG/4Bel04ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mailman-Approved-At: Mon, 07 Mar 2022 05:51:41 +0000
Subject: Re: [dm-devel] [PATCH 01/10] block: fix and cleanup bio_check_ro
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
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
Content-ID: <04B6A932C26F33498E7925D880426469@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/4/22 10:00, Christoph Hellwig wrote:
> Don't use a WARN_ON when printing a potentially user triggered
> condition.  Also don't print the partno when the block device name
> already includes it, and use the %pg specifier to simplify printing
> the block device name.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

