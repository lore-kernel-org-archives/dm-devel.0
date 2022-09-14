Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0665FECAAD3
	for <dm-devel@archiver.kernel.org>; Wed, 14 Sep 2022 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663175814;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qzVOIM/27IbUS/zF1yGoggaSh07znbqpAcq0vaKZPWs=;
	b=QKlMWS76QWgDnmi1NwGuCniE7ATnQciSZxeUfH3OfILU82wQh7rO5ASey3/xcVX7vWBGOd
	VZ5golM5PZ5xgaZvJbrs69A+6fOojXhF8dyBCRiUC3n5PpSoU2i86huaW+lLCxY88n9kmv
	oIz/K7yND+IahufkCh8bhfHRioZsXJM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-7WRrPsVoPO-IGB4fCuP6iA-1; Wed, 14 Sep 2022 13:16:51 -0400
X-MC-Unique: 7WRrPsVoPO-IGB4fCuP6iA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5DEC811E81;
	Wed, 14 Sep 2022 17:16:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9011440C6EC4;
	Wed, 14 Sep 2022 17:16:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 627371947040;
	Wed, 14 Sep 2022 17:16:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0C6091946A55
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Sep 2022 17:16:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E5B182166B29; Wed, 14 Sep 2022 17:16:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E14362166B26
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:16:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFFF03C11726
 for <dm-devel@redhat.com>; Wed, 14 Sep 2022 17:16:47 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-RXV5uLuLOC6I6VnDAnc7yQ-1; Wed, 14 Sep 2022 13:16:46 -0400
X-MC-Unique: RXV5uLuLOC6I6VnDAnc7yQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by BY5PR12MB4052.namprd12.prod.outlook.com (2603:10b6:a03:209::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 17:16:43 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266%4]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 17:16:43 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>, "damien.lemoal@opensource.wdc.com"
 <damien.lemoal@opensource.wdc.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "snitzer@kernel.org" <snitzer@kernel.org>
Thread-Topic: [PATCH v13 05/13] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
Thread-Index: AQHYxoDlUEd88ndSUkKvafplxc42Uq3fLoOA
Date: Wed, 14 Sep 2022 17:16:43 +0000
Message-ID: <cdb385ee-25c9-a82b-2b36-92b5b2e5d198@nvidia.com>
References: <20220912082204.51189-1-p.raghav@samsung.com>
 <CGME20220912082211eucas1p2d7cbc34d8ba679e525442128698a1116@eucas1p2.samsung.com>
 <20220912082204.51189-6-p.raghav@samsung.com>
In-Reply-To: <20220912082204.51189-6-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|BY5PR12MB4052:EE_
x-ms-office365-filtering-correlation-id: cd2f4efb-14ca-4afc-b5fb-08da9674e58c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: LPUiZjvfK6SiH9qbo71qYIaIQdOEXD6TxvUiQ+uvNmHeZxMn9oh3iD+vq+kbnrl9LSButrwpsR59ILUEL0WtHU5GteB7TLcLtEBROktLQW979vkHBBnHohHYhUr7dnKSq2Ycemf6P6+q3tZJ+C+xt88sh9s2Za/tdBe2G6jhcFWt+joAaBAdYpmn5ChdyZk1nPQyR3BOGR0lsB4lM5lyJZj2fu9nX0A9CQWNE4T93k7H1EzDpVtKZktSJsoDzg6lRKvH4vX4XheuLCUSTlQ8DoFflwMsn4XtEqDrFDEbEzmvtvo1IqXcatQwDg0nHba6OsoTE5rqC8C8muwKBnZjN+YZVUSiZS2rmodO/yN0Tw8OctJf6g5ErBPnswFAMFeQOD0nky+X7j6b4Ej+Ix3y82z06r5R2Sf8R/I80ZHf2zqaXIk1dbQ4kFHCimBV5vlylLg+wvt9ridvk71Vb82veVKmNDJ+ZGgxxS+/JfaVUY8UZ9JmLS++2U5WJQrO4etdWtZUOWV6Yveu+HLmsggiNPIpx1PmwkNykNKLvovN3h5tCNWjtBE2PNyRV06XVGBBQLEdS1rfOiP5vwEwCMyk/GTDpvA9VFdM7ReHqQTFUsbmLdCdwO6NdoVwHkkQ/GPuKksMExBqtPdvDRdMS617J2t+r+dayKBAcrXGv/60zresNkkknEpdYqBE+bmWq1Ub2eIQdBXNoZz0u7kVVwIwKBRgGrH1N78rdJkEuynjCHNOgGqhVdbOD0z75xDm+DyISrf4U7sI+N+1FRuAQwii5Bwe2BUtBNJoHAVNvzu+wX/yTlArrZLmImv29bxBwmvg
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199015)(8936002)(71200400001)(110136005)(6512007)(83380400001)(38100700002)(8676002)(26005)(31696002)(38070700005)(478600001)(66946007)(6506007)(4326008)(86362001)(7416002)(66476007)(66446008)(64756008)(186003)(76116006)(66556008)(6486002)(53546011)(5660300002)(91956017)(2616005)(4744005)(54906003)(36756003)(122000001)(31686004)(2906002)(316002)(41300700001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmlkK3RxZmYrNDBDaGNvQmV4MTRVTDFCNnd6S3Q5aFlnN3ZHaC9UTmtLSEVw?=
 =?utf-8?B?eXBaaVR2eXdUeENSaCtlb1N0bkkwNm5zMFIwVVNsN3VRdVVmSStMMHpHbi9Y?=
 =?utf-8?B?bzg1L1ZOeW1vNjBadzQveU5Uek93ZmxSUWg0V2FKT3QyMGxYT01yWUt0TTAy?=
 =?utf-8?B?TXVwakE2WG1sdDF4MGsvMHVMTWhNY2FnVFphNklub21PNE1QakJNWmNFOWMz?=
 =?utf-8?B?aTlOdHJIM0hRSkd2ZWhjejI4THlkMVNnc2NlUlg0aTg1ZGZVRWRrS2tIeGVU?=
 =?utf-8?B?dUJWRTllSXB0eit6dloxZ3dIWlUrNjFoZXNqVE82UmxPcElvWVJMVkhzN0tC?=
 =?utf-8?B?NndXYkE5Mm5URVFPbDkvTG9JbEpZREc0RHcrZGpXZ2tHL1Q0RFpwUndmUnV4?=
 =?utf-8?B?U0x3Q1RxbC9WS0hteG4rS1V3a0c3VXRFNlpiREVVbm0yZ0tiNjdLZTJVUTRW?=
 =?utf-8?B?OWNVcHJvMm5HVTRuNCt5Tm9zSVdKRGdaTkthUHphWmpPRncvZnlkRmJlOExZ?=
 =?utf-8?B?cVMwTTB0M3U2d3JuZDEycGFwZDVLQkZ1VmtFN2ZxM3JDZENiQUpOeDVJRS9m?=
 =?utf-8?B?aUJZTFpVTG5GSkowYWNlbTFQcHdpbDU4MmdEZ25vc3psZldYaDJQRk1Eb0ZD?=
 =?utf-8?B?eFZnYXNsb1BsUjRoYUpIN0ZUYlhMNDl4MUJuL3VGOWZ1WUR6VzdocDA3eUJu?=
 =?utf-8?B?cDFwS21UbDdFVGt3cDR4NWp2ZW9HcW9rVWZORi8zL3NmOFJMbFB6Y1ZKZHRL?=
 =?utf-8?B?Q2o0c1hVdGduNlViQjVWTjhMSzE0MzZFL0wvazQ2WVZmV0pyWDdSSUkycTRv?=
 =?utf-8?B?QkZXT285WWN3RlR0MFdwT0dtNGR2bXAwRFcrbndzNnpyQWFDTzRGSS9EK3dw?=
 =?utf-8?B?UWI5NUY3RnJTUDR1dVAvZUpZUzFhc2ZDZE5XOWhMTHFQcTJwUXhteG42M2E2?=
 =?utf-8?B?RVFCbUdJMDJLME5qei9XTTJaVWp3emR1SGR3a3ZTcWJnVmw1SmVhcnlkSmRB?=
 =?utf-8?B?dFhCanhta0hLVmxZNExXcnQvNm5Ia1hlMlJMaUJGbGZLUlpjTTFRd1lncW5y?=
 =?utf-8?B?dFV2UGYvUzI3UzNoY1JVK1BJcVk3ZmxpU0hSUmphb1Q1cytQQXFHYUFXWEhi?=
 =?utf-8?B?SWJaMDl3OGVlVjVmbGJSRjhkNUFDNC9UZzBtdlRwSW5XTmppTkllQ0NyOTRi?=
 =?utf-8?B?WXM0RW5lYnVtTklSV3J0K2w0UlFWNWpHMHRHZjdmTDJBNU16czVaMjVoV29U?=
 =?utf-8?B?dHRON0FZeDBISURmSkZKWFNxVnZkY2F0YXBhdXNKSUxwYVlEVWE1WENCMFMy?=
 =?utf-8?B?Y25qREZ3Y01LNTYyek1hYXpwMHRJY0NVUkdkakNOTkVzV2pMM1UyNWFrZ1BT?=
 =?utf-8?B?bDdsbExWZ0FLWFFBK3AwTUIyRUVMbXQzYmh5aFJrVWRsMkxIdFZKV0Q1M3dN?=
 =?utf-8?B?NlNWMU0xLzhObFhvaGxTWUVkUmI0OTB1Z2ZFQmxVYkZoMndmVExudXpXY2h5?=
 =?utf-8?B?U3NQcDE3cmNEaG5mMVRoVFUydDRQNEVRU3RjZVhsUmN5cHVOZ2xLRVNWU1cw?=
 =?utf-8?B?T1ZWSnlCUkJQS2tTV2hlVHdpaVJONDFIMkJmU2JkaHU3WEVLUm54MEQyekU1?=
 =?utf-8?B?U0hlUFpxc3htNXV5QzR1Z0s4dGJUYzdjZWZkTUlaVkROVTFkRW1tNkRrQUxp?=
 =?utf-8?B?cGhBdEJWTyszVUJWYXdqbXBPaVdRZVlRU1VGV2k3dnhXZDhWbTZYMkFrNzBI?=
 =?utf-8?B?dWUyWEdrR0VKTk1Wbnl0QlFxandiUUJTR3FwYW83RXJVeWdmWEtLM1hJZkc3?=
 =?utf-8?B?SDAwYWFBU2JNZGlhODFkUkJCaXZTelB5dVcydnBLWVBmcmRCWGRYZFI3TG1O?=
 =?utf-8?B?M05neDJKeitLSGFZelhWODZTODliS1RIZjl1OThmOFh3M2ZCaE5xa0hBTWVH?=
 =?utf-8?B?VmlTVCtuSW9FSmFJWEFiOTl3OFp5bjdTc3ZFcGEzbGdCRFBpU2t6ZzFZQkJj?=
 =?utf-8?B?Zm5mUGZBaVlzelBMK0VNbk1lS05VMXRUTlBiZTRVK3hjakJONTVVbkE3bHV4?=
 =?utf-8?B?c0NQM0hwVXRKc1ZRVTYxb2N0eU5rSHhJTlcyRWQrVmVXODRUTEFyM2xKZXIr?=
 =?utf-8?Q?5TlPxym6SXsKvqGY8JF1Xeon+?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd2f4efb-14ca-4afc-b5fb-08da9674e58c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2022 17:16:43.7767 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oyZsaP3EyPpv8iS4eUIjjGFtZ8OMul4UnNnCMuCuQLoVKDri1UfXjpWgApxa5XJwkwbaj+hczc1Un/poJeEwmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4052
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v13 05/13] nvme: zns: Allow ZNS drives that
 have non-power_of_2 zone size
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
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "Johannes.Thumshirn@wdc.com" <Johannes.Thumshirn@wdc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
 "matias.bjorling@wdc.com" <matias.bjorling@wdc.com>,
 Luis Chamberlain <mcgrof@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <EE9B28D7A0890A48AEA40060561D3170@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 9/12/2022 1:21 AM, Pankaj Raghav wrote:
> Remove the condition which disallows non-power_of_2 zone size ZNS drive
> to be updated and use generic method to calculate number of zones
> instead of relying on log and shift based calculation on zone size.
> 
> The power_of_2 calculation has been replaced directly with generic
> calculation without special handling. Both modified functions are not
> used in hot paths, they are only used during initialization &
> revalidation of the ZNS device.
> 
> As rounddown macro from math.h does not work for 32 bit architectures,
> round down operation is open coded.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed by: Adam Manzanares <a.manzanares@samsung.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>


Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

