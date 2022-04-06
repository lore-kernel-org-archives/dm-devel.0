Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF73C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 06:19:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-lsGHRv4HP9q4A9keYaJ8gw-1; Mon, 11 Apr 2022 02:19:32 -0400
X-MC-Unique: lsGHRv4HP9q4A9keYaJ8gw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E42783397B;
	Mon, 11 Apr 2022 06:19:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 07A104050C47;
	Mon, 11 Apr 2022 06:19:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A9401193F508;
	Mon, 11 Apr 2022 06:19:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 303881949762
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 16:23:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0FA70401DEE; Wed,  6 Apr 2022 16:23:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A5D9401DED
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 16:23:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5041899EC1
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 16:23:45 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-rXQgRrStNuihos2Iq7tTHg-1; Wed, 06 Apr 2022 12:23:42 -0400
X-MC-Unique: rXQgRrStNuihos2Iq7tTHg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 16:23:39 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3dbb:6c2c:eecf:a279%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 16:23:39 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 1/5] btrfs: simplify ->flush_bio handling
Thread-Index: AQHYSZjZVpHjFA1osUGKQf+OEuELhqzjEiaA
Date: Wed, 6 Apr 2022 16:23:39 +0000
Message-ID: <a3645fe5-21dc-d760-78a6-8912790c7828@nvidia.com>
References: <20220406061228.410163-1-hch@lst.de>
 <20220406061228.410163-2-hch@lst.de>
In-Reply-To: <20220406061228.410163-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a077090-1ee1-445f-245d-08da17e9cf23
x-ms-traffictypediagnostic: SJ0PR12MB5439:EE_
x-microsoft-antispam-prvs: <SJ0PR12MB5439A2189937CA836D0C0F5EA3E79@SJ0PR12MB5439.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SZako8/mNslluddmggn13XiHPs5LPJC57/JoMOCEAGuXb9TgWeAINll8jXP4sAx5tnUrGuzHDgr9P7PsCFU7iIWA7DsVFod3qefWuMAOqYYui7iP7PLtY41K1UIkDBNNmXQX1Wr2l9D+X850Sv4UE+riPXFnv3MZBBnjwK2+MxtEMVkr/js50fLJx96eAJgE+WPsFr6oaqWYiyMjpUbnJARBl3dE2CYFBZVRJ+Lax4zNRD0jiJ8q/Kp32i039lrxJuXGTvk7rAF1W6JUyeUBaLFcEXS8ohoDDVr4fOi/GPbplEOkoJBqAPKT00VJnJrWC+nnPSM1M9hXYmVw4pzMh9n5tVbb5I3yz3xrewIeq/EBqIcKhtFA805YAjUO2HpSzBEVZmu0hi4TDIV0P8VOyeiwhiMTItbk/GE/d/5bXxEsBgkUPxJnwC7yNVKtBrIIRLpJ4A1SaDmyxUYDwa2eh0/irmrYInUrNOqGvl6yGBUxePvcjVap67wcW7/XKGLqohMaZerlPz6Yob2UG8YtLI7rz4z2hIA3hAAqIrFmrfDBAX0ZZwtRTaPs7nhLy5S/HpVYAOcVgDxmMWMsbA5eg/NtSoQppBICjsgwsDMHB5xhuo45dr1SfT3/OzdhrVrAh1Pzs0auELk3rOkBTqZD2m4ZaeZntsYbjIK/A32SlLZSAb1VrEe8Y42G6jDIcW19N6Em/7iXxuWEQns/RG8gaxD17JwLdCfc6ie2a1L5gpzH4iBPwNrogfLDdG09oKCvM53RPLSdHlt2HTZqidBY/A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(38070700005)(64756008)(66446008)(38100700002)(122000001)(91956017)(110136005)(54906003)(66476007)(2616005)(186003)(66946007)(316002)(508600001)(76116006)(8676002)(66556008)(6486002)(4326008)(53546011)(6512007)(6506007)(5660300002)(8936002)(2906002)(31686004)(71200400001)(36756003)(86362001)(7416002)(31696002)(558084003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUdqZ2hnZFZoQ3h4UjdSWlVYSjREZTUySlNtVnVQUzFjVWxIY2NwaEdDVGR3?=
 =?utf-8?B?RTd6RDNyNUlVcG5wRVlvM2ZxdnBZOU9teDdndi96bDEycWtxU0Z0dVJKUTAw?=
 =?utf-8?B?UUhFekNPSE5kN3B4RzhrdWFVdWNtTHlzRWs5cmNkL3lrV0lualFud2liWkdj?=
 =?utf-8?B?byszWE8yd1NxSy8vZDVUYWc5SUp5eDMyNnA5eFE3YWsyS2JmUElFZzRHbnBZ?=
 =?utf-8?B?elc2NW1UUWVDUlhjemhacXV2bWQ0Nkp5andFY1gzSkh0WlQzU2NIaEp0T2Nm?=
 =?utf-8?B?d2lQdlFVZ2l5QkcrZ29XSi9RSitnMWdHdlVxZkhxR291VDRnbWozWWJObjlX?=
 =?utf-8?B?TlZMVGJrQVlscU84d0FRdE9paDFuejRSdTUxRWRmRGRabkNUUzZ2ZFBCdHhR?=
 =?utf-8?B?ejdwRHZIU3hoRENPWmFSYkEyTitIM1N6WDAvdG5sRlV6RE9TaHYyZzNsZFRL?=
 =?utf-8?B?ZkdyK3Z2TU9nekxNUW1uMW00aG9SNCtwRGI3Q2dGUWNDUkZoYnU2VUFFTFo3?=
 =?utf-8?B?QjRNS3QrRFNOVnh4cFBVblFma0ZEdjdETGRady9ZQmxkVHNmSi92b0F3VzNX?=
 =?utf-8?B?bjlOODllWGZ2NEJkenp2ajU2eGF6ZklnaHk2WktsMGkyWE56VGtsam5pZDc5?=
 =?utf-8?B?Y0QvSEVnZ3J2RFVDcU9tdnhZM3Q0YjRDYzdVRXlTNnR1Zkp6eThqTXlVd3F1?=
 =?utf-8?B?TzdMTlJTZWlkc1djQmI2VE5UVk1NR1pQRW5xKzFteFdRdUErZmJ0YmFSL1Nr?=
 =?utf-8?B?MFREN0F4QWFPVGI4WW9KSGdDNndKa3dPMzdycUFMNjI1UWlNdVJmdEJpaWl0?=
 =?utf-8?B?RUg0clZSbGNJT3BiaXdSOHJzUnRmL2pXSEJvQ2dhSHpZSmxST3FSUnN3YitY?=
 =?utf-8?B?NUFaR0JjZmV3UjBlQi9oMnlubEFWdC9yS3YvcVR5ZEpjR01rS2JMRXdnVEl1?=
 =?utf-8?B?S25KR00xcTJjQlYwT0VHeFo3V2lBTnFFNFJlSFUrU3F2M3dTamVHMW9BRHZW?=
 =?utf-8?B?TlBIWHVsMTRVT2pWN241SmhiVFB1NTFPNmFLLytWOGFyOGtnZTJKWDFMaUxB?=
 =?utf-8?B?U2czdWtVOUVLeU5jeVhueE5WSEswQjdRU0dDWGVCc2o0SloxL2xzRnc3U1lp?=
 =?utf-8?B?Q3VkdHpSZW1QZ3kxMUhMMzd6Yk5rUCtuMGlETnpoczJHWmhtWUhPbHFZUjRK?=
 =?utf-8?B?SVJLNVBXTmVkUitEdHYrVU51S1dLMVB6YUZFMWwwY3U1UktaQXoxallIekxC?=
 =?utf-8?B?eEFXc3grY3c4MTJtWFJCcTNxSU1HOVQ2dDVIK2kvT29KRXRQeU51Z2xhbDRs?=
 =?utf-8?B?VGZCZ3hMZVBnZEhQMnJIYUtBRzFyMUNuNm1IRlRlaUp2RU9FcEJoZVJwQzZS?=
 =?utf-8?B?eWRLMFlXQkxKekxVTEEzZVZEMnEweStialQ5emNsbitXYVROckVaRWIxelBY?=
 =?utf-8?B?aDZ6K1hHOFFGR0YzTXFIOXJwVWRVR0lUeFBmVlN2QUE3SThkcGxxaHpadWdS?=
 =?utf-8?B?L3lPa0NHWWI0NWxSZFFTOSs4RHJiN2VuRERFajQyQWl2aHpMcndaKytaYmlE?=
 =?utf-8?B?SUtuTmVlSEdGRjEzaUM4Q2RqRkZuU3p6TVk5STl2TnZSL0lzSGNsbEczcFFp?=
 =?utf-8?B?WGVuMGZEQ1dKM016emNTT29DWWFSUjcxSERDc2JNMnZ2SDlYbFlIc2VNTi9w?=
 =?utf-8?B?Wk1rRVc0aGJNVk5lYVpaV0YzdGt1cFNPbDJPMTltY2gya3ExSzI5SmZSZzl3?=
 =?utf-8?B?dCt3eFc2Y1JBbmEwOUNEdndzak9Pdkw1dUl4SWJidnRzbTdnejB0VHJiUVdz?=
 =?utf-8?B?QkZoWUF4MzkrbDQ3czlxRS9nUFE0QWN2Q3JhbFBUdTBkUU9ISnArTVNjOWd2?=
 =?utf-8?B?eEJBc2pNRE5RWEduZ0ZJRU9SZmtCUGxMcXlVNlg4Qit4RWMvSzZ1TSt4YjJR?=
 =?utf-8?B?MmpraXZGNmd0VjVlamZyTnNrSGJOeDQwSUg2aGtqUncySnNOWXg2VGs0ODMr?=
 =?utf-8?B?am5WekFHdFlqQW1PRkNWR1huWklmcWJWMzJLcWdOL1VLUXRLem5sSHJHeDE0?=
 =?utf-8?B?Zk9jU0cwdmc0RHBMYXhnS3pId241bkpwRmlKc3lxRm9NVXUvQVIxTGEwck9w?=
 =?utf-8?B?QzZGS2pySnRac3B5VVA3RDRlUzE2WUJ5NlFESTl3RXJMOVpWYWZ2MlBjWEVN?=
 =?utf-8?B?MldtdmkvWWFGVnlLWW5xak5JNm1QYTJtQTh2YXV6bHp1SVVoVmRQNDd0clBS?=
 =?utf-8?B?UE1PSDlxSVVuTjc5NGdveUo2ZHpJUXFKZ1dLY1pHVld0N3FTVlY4eU5tM0JP?=
 =?utf-8?B?Z2V2cWNRa014Qkk2ZW5HSXF3SGJwa3d6R2JPQjdtNmd0cVFmQ05hMlQ2RVY5?=
 =?utf-8?Q?YBBXNd5EoECmn1rE=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a077090-1ee1-445f-245d-08da17e9cf23
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 16:23:39.5727 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MXy1KvXEfF7i6rI3z61vddubR/PXNLrZpVU82Kdjaf7qwVfTyNNRX6cwDhygJebB9kR4F7gregyX2gmHXc8tnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Mon, 11 Apr 2022 06:19:20 +0000
Subject: Re: [dm-devel] [PATCH 1/5] btrfs: simplify ->flush_bio handling
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <22D6CBC02F6B4148A8B02D35A022C69E@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/5/22 23:12, Christoph Hellwig wrote:
> Use and embedded bios that is initialized when used instead of
> bio_kmalloc plus bio_reset.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: David Sterba <dsterba@suse.com>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

