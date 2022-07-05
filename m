Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6399ECCA47F
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119811;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bxW+fhJpI70UGzbMc7Ed4TwXTUL6Ha953NMwPFmk0nI=;
	b=LwWM203xtWmh1t8Wha82b7NR6lElUf17xxVBU3b0IpKRCP25pkOsPXsKVyPOZ9Haoq/8fF
	a9Yh3ToTojgRQ7h3BHwhANWZmx3mStoM+wYycBLLKwFLhteXx1Y2xD1QzAaoPe+o4dMdX0
	xqVUkWKUGeELVYgrAC1jmWIXCU5l0c8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-GP3Pw2GrP9KpzeyMvZCf9w-1; Wed, 06 Jul 2022 11:03:28 -0400
X-MC-Unique: GP3Pw2GrP9KpzeyMvZCf9w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FA911C0896A;
	Wed,  6 Jul 2022 15:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8BE6640CFD0B;
	Wed,  6 Jul 2022 15:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1AB421947076;
	Wed,  6 Jul 2022 15:03:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9502E194704A
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:44:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7010B141530A; Tue,  5 Jul 2022 06:44:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AF561415309
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:44:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53597380114C
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:44:11 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-FkryGmWPNE2VB8xM6T7oLw-1; Tue, 05 Jul 2022 02:44:09 -0400
X-MC-Unique: FkryGmWPNE2VB8xM6T7oLw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN6PR12MB2846.namprd12.prod.outlook.com (2603:10b6:805:70::33)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 06:44:05 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:44:04 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 16/17] block: remove blk_queue_zone_sectors
Thread-Index: AQHYj6QOTS7ygGc31U2GItgion9Bjq1vVfSA
Date: Tue, 5 Jul 2022 06:44:04 +0000
Message-ID: <a9449447-a078-a37f-0db9-ecafee70e2e7@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-17-hch@lst.de>
In-Reply-To: <20220704124500.155247-17-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a95bf6a1-162f-448e-6e02-08da5e51c0a3
x-ms-traffictypediagnostic: SN6PR12MB2846:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 82yceVZ1HkW4DZJDrO+tsnw7VE7D0jc6dFcHQVEZnb5lYn/UmcGTKhuMbmNcJG+94xpVijAZ63KL/QrqFtSKEOPuiJjLYxOASVLyj0kpoj96y39gBpfHT4yuSCW+y7NHsaiN1siGwryEE99JSzCKGTXyQIwSwKgVUOy2c6Iw81SL59VfS3fH405v6S7mgpYw74inBGJvhuS+uxdJEkGW328QU4kZpM60cmGxxfEPkmOI9CLBdzz9iUnkvbFnD+s8tbqF5govktY0mTI7TStFVV3b20nyPEWsmbc9XmYQX1G9sNSI3xZ2m8UvbWxKd75fzsiqYMkeh9gKEqYGzBkI3ZQeiJyNKgD4Zzm954BKD8dS7nXczweb8hTlJY7xODdu0LcJlaSvsa/LAAxjMBuq8yPDuuusEztblGMRF8TldXsnbpjPWXv01FfZ8X7Qv1tg9QxzZACAfuWzrXVLCCLdMOVZHwCtR481mqqk7opEtreW9QjBkcbKyZAkeWNq+Eja8IsUQ6PSZ85xmACtJrJ6JkjReKhNP9ZEwKCssAmYQMHA5lEfzFM6epeeOHgW/3nhC1kQdZKpn7CWHv19fHKIaAKgrmEIgmMBuVPDvjr3msmcLoRPD9K+SJGjFoB9DH7a1S0BveiJOLroCJiSY8ZnlFTeyaYPxTNczRHSb+YsCiFlhVYaNYjlhnLIF7hMq19ecRhuOgUspmSfILfY7NpIiRcfqka3/qp0hqd2yRBAu4SKb1tkw8yEcNw3EJQll3kDPk1A501dOGaqeFRlB1C9UaBbYyCWeyso+TxHXo1lt1h6LwVThXm4kw1arwpcwjeaf/0RhQhAjVLmiu25bo1NUT4AvdZTSC8YsYU9lovjn/gILjlQ+kePno7kQD96z55g
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(6512007)(53546011)(71200400001)(478600001)(2906002)(6506007)(41300700001)(31686004)(4326008)(86362001)(31696002)(558084003)(36756003)(122000001)(38070700005)(38100700002)(6486002)(8676002)(110136005)(186003)(2616005)(5660300002)(316002)(54906003)(8936002)(66946007)(66476007)(64756008)(91956017)(76116006)(66446008)(66556008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3BRZ1I1b3VjQWZBaXFYY0pBSndpcDM2Q0NSSjJZbkZ0eThxWXFGZTZMMXN0?=
 =?utf-8?B?V0NPV2dtS0VSNjBmbEk0MDJJejVCTW00STl3N0ZtS0VnQUhCWElVL2I0cEtu?=
 =?utf-8?B?dTlGb0JRZ2Z3Tm5hMmZVWGxzOTM3ejZIWGdUN1VwOTRNdHB1Y3pEc2JWMngx?=
 =?utf-8?B?Vmt4bGY4THc4UWJJbU8wanQ4Zy9UVkc3dEZJUkNQRXV2VC9URXkrOExlK0xr?=
 =?utf-8?B?ekxJOUpVTkFxbTg1RnluQ2Myd3NCQUk3bCtJekRjeWtDeDNVU2UrRHE4WE9U?=
 =?utf-8?B?dFlUUWplbHRsNE1ZK01nQXF5NmpLRFhwSitiMEZwMEgzbHpJaTlHQ3VlNkM3?=
 =?utf-8?B?Uk83REZkM2xqY3ZtQnNUdFpnbDAxWEg1aVNPbGNGNGRvdXRzWlV1bGYrWHFQ?=
 =?utf-8?B?dHNGRGg5NUxmWWFGbSs0RzBHZ3RhaXAvVUMzalA4ZXpwdWtDVVpnN2h1TXdJ?=
 =?utf-8?B?OTI3aFFTY0VONkVHWVViUjRqYlN1NkdaVTkyRFdnejRFcFZ6aXZlT0ZSZ0FF?=
 =?utf-8?B?aitsVW1hcDJjK0MxWHNmVnlGYXBXaklCaDJhalJUWDNDU0diVWRjSDZ2QWo2?=
 =?utf-8?B?UDZWSC9YSkgxTExHbVZEV00rcm0ySmh3dHcrWnhBUVYrdURRakNtZENWTi9a?=
 =?utf-8?B?akpnUnY2ZmY3c1YxMWxLbEx6TXhJSWFyZlNWV3BDTTZtY2xuTm1uUWRlblN0?=
 =?utf-8?B?QWxPS2RzUyt0SnBLemFoR1pycGRiVmNHOUUvekE3MEo3Mk1KUC9jd2ZsSHhm?=
 =?utf-8?B?dExKTDdKTE9oRWU4ZHlVUWFwdnFON0RqdmJ6RXU4R2J1T0dscjBwL3dVWDdX?=
 =?utf-8?B?UkI5Z0hYbjlWSXJBdjdzLzFTT1hVQTBPTFB0ZThvZGsyK0dQU1NwUmpSa2NW?=
 =?utf-8?B?NUdXd2MwNGtTN0VwZFNGMlR4WVBYV2RONXM5U2RlaEIrVlBDbjNXakoyZmxB?=
 =?utf-8?B?MGFRV28xSmVYSUw3OTR0c3dtS05INjk2WEFGaWMxK3FuYTF3UjJxSjlCK1dx?=
 =?utf-8?B?ZW00WllvTmxQa2tDeVlWY3Y4MzZQTG5BcWJQQjhMb0VxZnU5NmNBbk9lVGNO?=
 =?utf-8?B?QStWTHpKMzhSYUpiM0ZYWWZxZGNJR2Q1L0diSGUzMEpkNkJOOEkvbGhuQ2xp?=
 =?utf-8?B?dktHLzZHTms0SlczQzRXc3hyZnpkZEltL2h3ajJUNGc5TFNXVXBmYjFETW1X?=
 =?utf-8?B?SjBHK1JCY3o5QWNXY2lOTlNxVS9GSVFONzJCdFVBdUQ3OUJYb0dDTGIyVHpY?=
 =?utf-8?B?bXY5VSttWjBhSk13by9UK05wMFFyMG54TzJUSEw5WEJhZm1KamZNeUF0Nno2?=
 =?utf-8?B?SUZKdXFqSTlGdHNVTnFNNXA4bHJnL2s2QnBNKzZvdjllOEp6MGNDYW1DRjJS?=
 =?utf-8?B?YXJwWnd6YXVCeVBxQSsvcW45b2tneGtjbm5KM05WVGtBVTZNNzJJdkl5U1NC?=
 =?utf-8?B?ODVjcHlXOHpJZkl1bUgxck9WM0JweUdhbWwzRGpYTGhnMnl6NEVYNmlkNHQz?=
 =?utf-8?B?MzBFdlQ4cE5BcnAwVGw2MENKWE5OaFprV2ZtUmpPK1kveXAyVEFOTjNXaUtn?=
 =?utf-8?B?K2NaaythYjNGdXEyL3djYkJsSHBNeWRQR05scDc2SDliWkY5RExtYW1tZFRr?=
 =?utf-8?B?UkpzSTV0V3hNQlVmSHg1NGR4UjlrWXdhdjQvOEwyVm43cFhuemZ3L3p4Lzdu?=
 =?utf-8?B?OGsvNnRtdVRZOHg3NFJSSGMxcVlSNGJpbVVMdi9SRjlVWU1yS01xK3F2UjlM?=
 =?utf-8?B?NThabFdXT1hlNk9BMlFpMWlHS2RObm5xMXFpa2svWGRpNGRyZ2M3MEY1Ym5U?=
 =?utf-8?B?L2hucTVMK2J2N0VvSWtaNUNUS0dNWFVzQWM1ck5lMTdBVENiTzNteW9tcUdG?=
 =?utf-8?B?T1VLajVKZ09jcUl1L21rYk5zeVZGbXV1UHlUbWt4bkZseDUwcitzcTV4T01M?=
 =?utf-8?B?VWJpSEpjb2JuTnNxenVQOFFtUlhNd3FvM2pJU3E3Mkh3R3Zjd0ZSVlFhTFNU?=
 =?utf-8?B?SnBFalFIK3UvbmQrbkw4Wjh6eXpSanR4WkdpS2pvZlNJOEVUbWgwUEJCN3Zo?=
 =?utf-8?B?dkZhSXI0MTV5bmhYNFJhdUp0QWppaG54OGszZHpWajJYR0ZranBoU0p3cDBq?=
 =?utf-8?B?Sy9ybFJyY1NRclh5bkpRTUhCaFVheUpXVSt2cUZaM0swdDNVSEhabVlWZ3Ry?=
 =?utf-8?Q?dp1shvAm6YW8B+XosiBKbRPq4gizSC6KFuAlONimf+Ki?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a95bf6a1-162f-448e-6e02-08da5e51c0a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:44:04.3488 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vLNT3RXAzdiddVCOnSHDCqYstoj75KUQ60+ABxubCUChnUjab5MzrqCRCliN4dfRS8XdOxLgK5wIujBSYPNobQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2846
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 16/17] block: remove blk_queue_zone_sectors
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <7FF7C5A004A78F4F8B238A5020DB9713@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:44 AM, Christoph Hellwig wrote:
> Always use bdev_zone_sectors instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

