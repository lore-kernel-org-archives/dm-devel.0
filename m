Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10467C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 06:19:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-1zAXlGe6PoG5g0eUaneX8g-1; Mon, 11 Apr 2022 02:19:33 -0400
X-MC-Unique: 1zAXlGe6PoG5g0eUaneX8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8246F3C00130;
	Mon, 11 Apr 2022 06:19:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6D69C40CFD0F;
	Mon, 11 Apr 2022 06:19:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0ED38194EBA5;
	Mon, 11 Apr 2022 06:19:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6DE4A1949762
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 16:25:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 58104112132D; Wed,  6 Apr 2022 16:25:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 526911121320
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 16:25:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BC9E88FA4F
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 16:25:29 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-yMeZuUzRM0mzS0VpA_56Pw-1; Wed, 06 Apr 2022 12:25:19 -0400
X-MC-Unique: yMeZuUzRM0mzS0VpA_56Pw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM4PR12MB6012.namprd12.prod.outlook.com (2603:10b6:8:6c::5) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Wed, 6 Apr 2022 16:25:17 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 16:25:17 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 3/5] target/pscsi: remove pscsi_get_bio
Thread-Index: AQHYSZjWHWW7ZY8LCk6qHnPXNgEM8KzjEpuA
Date: Wed, 6 Apr 2022 16:25:17 +0000
Message-ID: <cdae813e-2e2d-8900-c48c-e36f3fc3314c@nvidia.com>
References: <20220406061228.410163-1-hch@lst.de>
 <20220406061228.410163-4-hch@lst.de>
In-Reply-To: <20220406061228.410163-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b69e6288-764e-456a-6631-08da17ea0995
x-ms-traffictypediagnostic: DM4PR12MB6012:EE_
x-microsoft-antispam-prvs: <DM4PR12MB6012E369A1F0FD1F65A7C152A3E79@DM4PR12MB6012.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JWuAhWb02X+5TwbHjumMFa8T1iMu7wHLneNkIQGrhXne8Uvyz62gIGdGy4dv2HDOcp1u8t33fB/8/bNWsYqFJeGseq/wVhhKyuvosJXDLbr1RhP96lDNxgllqi+8dIbENQafvz1IcqA2Jhs55bqIMl5vWPjHOp1RCZsRytFZvR8TptdZjyqjzzaH2QMGLdJD3lu+vnWaeaPO524cdp3+LNSeJkg6ScV9ZkJ7viCGUBbzSyDrnSFXJVkhYcNQO04Nmwdwm3+MvSJwFyJDaGN2FvzmByaWacUGNRCiBLenjas3wla65jSRC9Ry00pY6okHdZv9is6jkFJvmPWcJdE7bpHqcVeCAY29MiCGX04orQViYvRb8Cr6ETJ5eOPOg14zRqBZaHR7OL81Aj3/JjvnXWkyicp6dLzbKhoYsT770uViHX3kGNxUaaz8bvfgp7mDK1+fmj356MZekDQjSxHRWAZQdt3+SEFnlmOVT0KLw8b5M6ddEuOJC2d82XmAyzGvfaFMNyr+Mwj2RIiGlTZAWupBEth/i0dCh2xsJpFC1Qs7lKXCxOWqXSJiy6XAYTAUvdr6+itkkReCXInOdYf0GKxISkfjMeSuEdmxwiJP+RfbsyKpW6fYYe3TaRvpxJ9vLiDpHWn4A88iwL3pzHGAf1EMKEltP7jLfM3LyZyeETDqKpbUdoR1NagWGLkss45htSPOEXNJtkKwR8Wi+fzBgr7aCCCWgXVvsnqYO95gBDIug0F5tgGJkdy/yO5e99ROfB+hqYsXDJJwuGVLaNaTmg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(2906002)(6512007)(71200400001)(558084003)(86362001)(31686004)(38100700002)(54906003)(38070700005)(316002)(110136005)(31696002)(7416002)(4326008)(66556008)(66446008)(66476007)(2616005)(64756008)(36756003)(186003)(91956017)(66946007)(8936002)(6486002)(122000001)(6506007)(53546011)(76116006)(8676002)(508600001)(5660300002)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rk56OUxkeUJER2ZZRU9aQ05QSC9UdVlCUFRGbEI5YUVLQ0N4a21OR0hldThW?=
 =?utf-8?B?UnM4Wi9vN0ptVTJxaEhQOGc5ZWZuRzBrZjhCRkkyWWpHUlg4RFBXTE5iUmRF?=
 =?utf-8?B?Qm9INXNSdDBabzFnRDFUSjc2bTVaeG9WMlJUYVN4dGZiYlg2K2FSd2g4emc4?=
 =?utf-8?B?aWU1ZEFJemFuOTZZUnozV0ZDL3MyRlVZMW1PdTlSeU1VeVB4KzhCTmJ6d0ls?=
 =?utf-8?B?Y1NpMjVHbmh6aVd6ZlZ6TjdzTUNjTDNITTNJVGdJQUR3dHJwRTB1NVhqVEY2?=
 =?utf-8?B?OWozZGpuKy9obzhiajNkeXkxby85U2h2RlY4eTlkUit1YitJWnBockdNT1dV?=
 =?utf-8?B?bUJ2Qjk3L20wN1VtZFFlSS9hc0ZITThvY1JXSysvUExEZFg4WEpHVllsWFN5?=
 =?utf-8?B?YjVHTjYweElRSm55RFZva2ErOGJVd0c0S1E1MG4xV3dTQVcrVlh6d05xcXpp?=
 =?utf-8?B?NUlhNkZoVEkxeEV0enoyM3JPejNGbGNXYkhuTkFXYUsrcFpwMVFGMmMrK0Fn?=
 =?utf-8?B?cXlBdVRMaEhKWFJ3STdZR216Qnc3YmNrTkJyejd2a1NTM2NDL1JpOWZNdzFS?=
 =?utf-8?B?VnZLUDdXQlJyck9SN3ZPWCtvNVg5bGNOUEZxb3JPcE5QUzJRblJ6dFR1OGtC?=
 =?utf-8?B?R1dsYUVOYkhlM2hwdzNtbUsrOEp2a2VEbU1objBsNmJWaG95ZGNoME93WVRI?=
 =?utf-8?B?UDNtZjVXQWpTOHIzdDNpZStFVkpGTklQb0h0TWlYWjVKUk5Kam1CVUt4MGk4?=
 =?utf-8?B?T0VVK0ZEYVl6QkcrUmE5dGNkUUl0ZWtnV1lkVC9YS0ttbnExeVNUMFU3UGo0?=
 =?utf-8?B?b0pWdGZvSTR1Zi9oWUo1SVN0eHNFMFR2d3RYYWhjbUhYR2ZaSDhuOEE3YjlC?=
 =?utf-8?B?YTBHZ2FCMWU5d20rNlJDQXB4bGhuOFR0UkZpZDdhL2FJa1J4V3V6WERBeTZ6?=
 =?utf-8?B?YklZTDdmMjN0bnNPalY1V1dVK2Z6QkhmSmVLeHl4SUNzLzAzQkRVWmdjNHFL?=
 =?utf-8?B?S0tIemNVWk5Eejh4Vk1iSm1SNndJM21Ub2xVVkFneUZ0enc5T0hVeHhod1B4?=
 =?utf-8?B?WkZpRTJGZTU4dHJ1TmVWZ0JRNmM2Z0pPSnh4RW5UT09mNUFQaUFXZ1hBRk5t?=
 =?utf-8?B?Ylc3eGplbVZhOGk4bG5JNjYvQ0VNMU5RbExFQUE0MWF1UHhvTGM5MUVoQzB4?=
 =?utf-8?B?ZnIyR3dnYVUydlY0YXhLbUU5MjJHZmZsQjhFd1VUcE9IMUtEZ0NmL2ZEVVJj?=
 =?utf-8?B?cjl2V09jbkJoWlZVdEhUU2VjUmVWZ1hQeWxZTXdCQ29GalZJVjR3dkFmLzlK?=
 =?utf-8?B?OVE0QjRaV2VISEUzbzV4OEc1NGlEYXNLVjVBVGUvQVMrS2VyYThJUldrR3Ux?=
 =?utf-8?B?R2VxTktPL0JtaTd6c2NZUDdZbmpKbm5XK01qQm9pVDlTN1ljOUNTYTZMNjlH?=
 =?utf-8?B?MmdZbE5UTUtxdWM3S3FwSmF1dEtxdTlISUVDNFZTalBWRklSclBGeHhrbmxL?=
 =?utf-8?B?MmhOV1pqV3g4VS9uVjF5N0QvbVRPUUpZWkpoeHNuaWVmUUx0Wlh4cHpWbGdH?=
 =?utf-8?B?N050ZUxGR0YvSHdzTEttWHdsdnd5ZHdXby9SK2d2bE1aTW5kZUFqbjdCM2wr?=
 =?utf-8?B?Rkpuck5wMVhqVHgyVHdpN3d6NWo2SVQyeXAzenNCOFliRWQ1ZmE2elo1bWkv?=
 =?utf-8?B?VGoycC9JQ21uczdieVJML0d2Y2x4UnBDbDZMb0IxVDZnWmVaS1ZQUFdFRGJn?=
 =?utf-8?B?emRpK3YzOTdRRE1pakYrYksyZzVralNFczd3SmsyZm9Fa0Y2YlRDZ211RXBi?=
 =?utf-8?B?ZmZrUDRNaUJGRmEwUkFXbjVIOW5tT3dldkFPV2pXOGNGT0hiVGlwcXpmSWEw?=
 =?utf-8?B?YlgrcTJHcys3d3N1RmpkY09vN3dLWFowTm4vRDBRTWtOanowZGs0VDcwMEVF?=
 =?utf-8?B?T3JTNklLeVdnK0FJaGF3a1FqVXZYcmJpdytES1hqeVUreUVLOXR5dXB1bmk4?=
 =?utf-8?B?akNMQ3dGamNvZFlGd3lPWG0vVSt6Wk5tc2FPWjg0RXhlYk1NcGd4NmlNY0cw?=
 =?utf-8?B?YzUwRVFwSVVpVFQ4bnUvYXhzZGpHQVI4dGY5YTFuZ01SdG5hV051bWlFQ29u?=
 =?utf-8?B?OUdubUtYNkVvZTdqWXkrRVB4Q2J5cXFiL0ZyRWswWUdDMkJPbTY3N0VlejdL?=
 =?utf-8?B?OFlWLys5RTg2NkJyZUNnbDh5aDJIMWZ2TElQMkRCb1lKQTl2OXpOUEJGdEZq?=
 =?utf-8?B?dGVlMDhuMFlDSXVZdjBGelNlTGNCb1Y2akU1MjlrYmI3akp0cTNDY0Z5bW5y?=
 =?utf-8?B?M01sL1hmekdFOXF4R2krYkVrUU0zL1JHWGRiQlRTNmFRWU12UVB6d3piYzJM?=
 =?utf-8?Q?54vp//spv2N8uNZg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b69e6288-764e-456a-6631-08da17ea0995
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 16:25:17.5981 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4GvzuKuP8ypM0k8f8ythGutz/HEUIpjW6QTgcXilQNpNV90L5nGzEFdUJpWPaS/hvdoJdWres/hZo0pglhlikQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6012
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Mon, 11 Apr 2022 06:19:20 +0000
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9AC08EC06FA28B43A522A1B654D37A98@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/5/22 23:12, Christoph Hellwig wrote:
> Remove pscsi_get_bio and simplify the code flow in the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

