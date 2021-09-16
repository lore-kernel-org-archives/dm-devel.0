Return-Path: <SRS0=f/Jd=OH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC37C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 17 Sep 2021 06:35:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 98485610A7
	for <dm-devel@archiver.kernel.org>; Fri, 17 Sep 2021 06:35:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 98485610A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-w6UE3KS4OQWvzdLFUkPwlg-1; Fri, 17 Sep 2021 02:35:23 -0400
X-MC-Unique: w6UE3KS4OQWvzdLFUkPwlg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E10911808307;
	Fri, 17 Sep 2021 06:35:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFD706B559;
	Fri, 17 Sep 2021 06:35:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8FD811806D00;
	Fri, 17 Sep 2021 06:35:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18GN7lYi008839 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 19:07:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1FC6714E76B; Thu, 16 Sep 2021 23:07:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1978014E76A
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 23:07:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1FBB8001EA
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 23:07:43 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-530-NiC94zDlMKmK41IyFmaPeQ-1; Thu, 16 Sep 2021 19:07:42 -0400
X-MC-Unique: NiC94zDlMKmK41IyFmaPeQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
	by MWHPR12MB1584.namprd12.prod.outlook.com (2603:10b6:301:a::22) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16;
	Thu, 16 Sep 2021 23:07:39 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::498a:4620:df52:2e9f]) by
	MW2PR12MB4667.namprd12.prod.outlook.com
	([fe80::498a:4620:df52:2e9f%5]) with mapi id 15.20.4523.016;
	Thu, 16 Sep 2021 23:07:39 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Eric Biggers <ebiggers@kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>
Thread-Topic: [PATCH v2 1/4] blk-crypto-fallback: properly prefix function and
	struct names
Thread-Index: AQHXqyMBfcBXr1WhvEyyvG966VbbBqunSQSA
Date: Thu, 16 Sep 2021 23:07:39 +0000
Message-ID: <550c2308-ed18-93a1-9f35-10ef037b25b1@nvidia.com>
References: <20210916172249.45813-1-ebiggers@kernel.org>
	<20210916172249.45813-2-ebiggers@kernel.org>
In-Reply-To: <20210916172249.45813-2-ebiggers@kernel.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.13.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7a1114b-b1bf-4364-a678-08d97966c7e1
x-ms-traffictypediagnostic: MWHPR12MB1584:
x-microsoft-antispam-prvs: <MWHPR12MB15841CA1DA64D3E27449150CA3DC9@MWHPR12MB1584.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: T+jqL8+q+aD1OnOGOH5f8nKclo76VxK4tzdk+Z45Um+Tt1uMvh3IRZURnh3R2dkJo5jFfGZT7phH+Ydb/wtWSJMgzS+34r8wyy7Fp6Lv4Egrku+DkT3OzAdr98QUW1LQqyFv5vc6DOo6xRD3ri5a7CRYFPoghGpjgtMsAxOjWICbVwz6sf3sl68IirDsv+yJmqgKckswMq7vvlnM92XHiD4LEObNmRHIT7SVS3lkax27kjO1odwiRv/2YSbD1bkTI3PQifa9ihNIjv9R78v3afLMH3aTfKkbr1dkarQgO+x2ePiniKRRC0FUPDpq9Vn74ivD3PdmnLO3sCnF31otnP9atK1Rl5p+J4kaOc0vozi6Atf9JwtZLQwDc9MbDgRWydNytT52m8zqGL+Z/U985s4Yofr6zHfSxlM1PZQp/y8QwdKJftQ0eopvsXyKW8Jh7KULT7arlmKkBzMKblU80Y8J10ztZZzb3jlVUnQS26k8owqdoSxk4zj+vcV2P2lvUfVlgvXekcDBvJa6ETtBUPiYLkYYKEgMK0QIsw25/1rgHoK6+Z+2nrZ7vgrIdIhwnN6odRopQetvJn397nJDbv10lEKDHOGXx6lDj6EvJ95ey0BxOSoz3MbJRmq1NBND21JjBkOwpCkCYyzMuY7/D2P21FJiCXZJ3+wlkRHjmhmMIRrAOYEwBM8YRkCCn0qCM1Z9envze8vOKAEogwNhmKq5hC2MKtibYr0WnL8ab4g93R1XsAA277zeMpj1uHoTTNhxJnBGm2Anp6oCQPIa/w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(5660300002)(53546011)(2906002)(6512007)(38100700002)(122000001)(54906003)(36756003)(2616005)(110136005)(66556008)(64756008)(66476007)(66446008)(76116006)(71200400001)(66946007)(8676002)(4326008)(31696002)(31686004)(186003)(316002)(38070700005)(4744005)(86362001)(6506007)(8936002)(478600001)(6486002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REpYOGJrbHZISm14aVRlU0dkUW9HYVpyaVZZNFFlc2Z5Z0tYeTllNEQ0QU10?=
	=?utf-8?B?SVV0R2gwR2pRLzd1Snh6RWsyRTlxMjFtNnV5OGRRbGY4eW5idFNUY2VQUjE2?=
	=?utf-8?B?MDYvckpzQ0pNSFZFTzF1VWZzRUc5a09TYUpneE0raEwyUythL0FEZTZmdVoy?=
	=?utf-8?B?SE13QTJkTmR4dGhFTTc5QU1nNHNUdWkzaXY2S3Rxd1RCNVVYa1JCc21pVDlU?=
	=?utf-8?B?ekd5bWFBa3ZkcGo0ZW5SMzhwNHdhUDJqWUFHRjVad2swQko3NlFSUzZFdDQr?=
	=?utf-8?B?M1FadHRIaWs5L1pkZGttcG9TVWVJTEgzV21zdTJEb2JOQVFxTVREd1dXTVk4?=
	=?utf-8?B?RlFvNWtXbHBETkk0c3RQOWN5dGdUbEdqeHN0eHRXVmRkR3I2Z2M3NFc5WkIz?=
	=?utf-8?B?T3B1ZnpCOHp6S05HcjArNVhpV0VhRHFIRnNyMlFqUDNUVTVPWmVqbHNOaC8v?=
	=?utf-8?B?TFl2Qm1sSTB5ZDlpTEZtZnBSS0ZjMW9XYVJ0eVhBZisvSmN3Y3NEOGJlanV6?=
	=?utf-8?B?UDZZK3BtQjNIQzVhT29Jd2Q2RlhmYWQrZVZIdnRoZVBzQ0xCa0h0SjQ1NWZ6?=
	=?utf-8?B?Q21sODRmY3BFY1NRaFFadXoyUnRoNHl1QlR6WC9MTk1DbVZ3bzZ4d0VwOXdV?=
	=?utf-8?B?VjFMZGY1ZGE3MDhUMU9FalUyYXUrQ3BNb3NubVZJUUlnZUcyS1R2TnRMV0Jt?=
	=?utf-8?B?dE1oUm1BSGdlc3lNR1NWZXVnNGlzNnFKNjN4MWhUYkRHMmZnV05ndC9uVVdy?=
	=?utf-8?B?WDRlYnEwWU00SVJkTzNFbHFwd1dIMXZuWFlmZ09jTUJqaEFkS3A2QSs4VVNY?=
	=?utf-8?B?bmFHdzh1WHUyWmVXenJuRW5vSnE0WWdoeXRSSC9wTDFtUXYxVzBlc3dORjFR?=
	=?utf-8?B?WHZKU25iNW5aN2c2Tk1XRS82WlNLVXFLcXBROFo5TWxkY0tZNytpZit4VkYy?=
	=?utf-8?B?VzJON2tHS0w0L013bDIvbWwwdTJTNGl4U0JBYTVxbnpoT1FwdFBOUlJpMThW?=
	=?utf-8?B?dGM3eDdNNTVObk1ycEZtWmJxcGFialVndVhIR2ZnbkIveXlpbWZhMTlSVVFj?=
	=?utf-8?B?Q253NmQ2aVZLdjNDcHlGVEJWajJMUlRLekhDa3FCb2hJSnJYTGQzbVFUbHZx?=
	=?utf-8?B?L1ljQ0E0cGxnb25GWWFVeXVZOWp2UXpZeXFMYUZ4TDliREJhQnczUWFJaHc2?=
	=?utf-8?B?NUVHVHJjRGJkbngyVVNPWHJ6SkxnaFUxOXkxWWN1Q0d4VHhjYnBIVnN5TXd2?=
	=?utf-8?B?Sm03WUowYXJJVzBtS0cySit2RUx5SFBqTGpXWlJtUEJpczlwMFJBOVhQRm02?=
	=?utf-8?B?cTJFTWovSE5RSEdjQ0F0RDRRN2c5UFU0NWVjL2NqelRFS2tiS25RcHpwQ0wy?=
	=?utf-8?B?cFYyVjZyVEFUOWw3blk2eDNIVHRhVjZacmhPWExzVlgwMHdLS29NQ2Q0TGpL?=
	=?utf-8?B?ZERsNW02VlpqRExtM0pyczkyM1dCeEtmWDViME5iVHBibUgxTEt3Qk9kY1Yw?=
	=?utf-8?B?cXVQdlp5cWZkMnVFSkFuaXcvUHYwbk5qclpWb1FhZ1pwbHJxTmFhVHBjN3Vx?=
	=?utf-8?B?YjdDZHNsVjZ4SUVVWnA1QXZMdVZUMktVNHpsRUd5YXE1OUtXVFBCWERZSDk3?=
	=?utf-8?B?L0orN0k3bGJiZjQvZlhIaXE2S241YXJFWVhBaHpzcXFyZjZZempDSUJzRFhN?=
	=?utf-8?B?NFQxcG9ESExtM1hmSmZzN25MbHlvaVRXNVkxMHg4RGJ0amJuWkE3Mk9BbmVI?=
	=?utf-8?B?cW9EL090RXdKYk1ZSkE2c3NidXBmOHgyY0tpNUFBeXJWKzUzVlBOeHcvSFh3?=
	=?utf-8?B?SEZmaHgzVVRJT2haUDdZUkxsU2dXWkR3SlVpYjlxSnJON2pQbktVRGpPOGZm?=
	=?utf-8?Q?VLje14OXP6p93?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7a1114b-b1bf-4364-a678-08d97966c7e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 23:07:39.5305 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F1dx9tu1cK6vMBX2cDrvHq9QkqaPeUYNzBG4aEULlNEl85T//dNR/XyzDVSI6aXJ+pi/riKe/rrHZKDfuKgt+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1584
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18GN7lYi008839
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 17 Sep 2021 02:33:18 -0400
Cc: Satya Tangirala <satyaprateek2357@gmail.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH v2 1/4] blk-crypto-fallback: properly prefix
 function and struct names
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5D55DEBCE0356647B40B714582C6DE63@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/16/21 10:22 AM, Eric Biggers wrote:
> External email: Use caution opening links or attachments
> 
> 
> From: Eric Biggers <ebiggers@google.com>
> 
> For clarity, avoid using just the "blk_crypto_" prefix for functions and
> structs that are specific to blk-crypto-fallback.  Instead, use
> "blk_crypto_fallback_".  Some places already did this, but others
> didn't.
> 
> This is also a prerequisite for using "struct blk_crypto_keyslot" to
> mean a generic blk-crypto keyslot (which is what it sounds like).
> Rename the fallback one to "struct blk_crypto_fallback_keyslot".
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good, it might be useful to mention this patch doesn't change
any functionality, not a hard requirement though.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

