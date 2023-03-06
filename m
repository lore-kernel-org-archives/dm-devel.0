Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7766BC61DA3
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 05:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678079305;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A+kpSiVFnjrBVoYDmEVRGQA4xRuLL5cW6TAAfmlV2xY=;
	b=ekax7dwgzv9XY5q3OGx++nkRvywS33558U8hYfj18Tw369rfdIjcEkSV2E9pRAZ2QOWVQO
	+6iDF0lND1ybEMkkHOwxyFfg07cueDhx4+mYTwZLuYxp17oGoxMSSs09gO+QmCAa7Sv8Y9
	UuEUrwGF9hxw5JC5+jU3zXN6NXB2E4g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84--UZsak1yNcuASHirBA9dGw-1; Mon, 06 Mar 2023 00:08:21 -0500
X-MC-Unique: -UZsak1yNcuASHirBA9dGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0001F1C05EA2;
	Mon,  6 Mar 2023 05:08:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF999C15E7F;
	Mon,  6 Mar 2023 05:08:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F1FB1946588;
	Mon,  6 Mar 2023 05:08:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 566D91946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 05:08:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1F240492C18; Mon,  6 Mar 2023 05:08:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 168A2492C14
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 05:08:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F08658027FD
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 05:08:18 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-EwjctQUlPO-FnZytNsSK6Q-1; Mon, 06 Mar 2023 00:08:17 -0500
X-MC-Unique: EwjctQUlPO-FnZytNsSK6Q-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH7PR12MB7453.namprd12.prod.outlook.com (2603:10b6:510:20a::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Mon, 6 Mar
 2023 05:08:15 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.025; Mon, 6 Mar 2023
 05:08:14 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>, "bvanassche@acm.org"
 <bvanassche@acm.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com"
 <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
 <linux-scsi@vger.kernel.org>, "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>, "linux-block@vger.kernel.org"
 <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Thread-Topic: [PATCH v4 05/18] scsi: Add support for block PR read
 keys/reservation
Thread-Index: AQHZSHgQzNEL10tdBEqbC7x0bFhc867tQmKA
Date: Mon, 6 Mar 2023 05:08:14 +0000
Message-ID: <821298cf-a76e-be6e-c683-7bf34151ddec@nvidia.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-6-michael.christie@oracle.com>
In-Reply-To: <20230224174502.321490-6-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH7PR12MB7453:EE_
x-ms-office365-filtering-correlation-id: b2aac136-b2ca-4bfc-9eba-08db1e00ca80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jY/Nc+T/k7vjt2qIHl31CH+oCOGp8iKaR1g/U8NPLXOHpxD2PtfLmHmGgdyoiL18DXyrssLKpPsfub8vHlUyjxmDD0wtN6NFGd3EgzNVgRocEfte//AOlgej7QOoJPT3Tb63ytfgmjsIL9t2AosUtqpjaPjXcGaqqdMEEyjiWgqKRFVOWgWC5mnt4jQ+B8bDKql1KB1ax1+VMExlGL7niWlIAd/iiMgCYkTMEUoR4gUlx41/le9fhriIQ8jVBWNw3YUdRZYfKlt2jxmp/Fo9MgQqFryJq4MI6ovTor45HtfA1BCHuCTCRpGC2guac+NaSqFVl/gfbmaEMEINmUYQZs2SQCXb+9Yh9ZUGorNtOIUOwOf14/xpMCcPRxlGBbmTVHkAtBTfnCkWhtywoIjg89/bPHTu2K1olP+mwOLmxpDoTQ/2S25TjAJ/ZYlBOa7zyDIRUEVSvv+Id/VfAbJHyLSRewuk0WhhhYd809hzWWodS0TODndB1escd8AGwCarDHxAhzdK5m8wgxRiPf7Jm/ovjCpRDGwhlpEP1vJ4U1GwWT6i/Ep77sitKUMBCWeN2IZGL0tdFq2Nt9EcmlOHno9K3BQTwrpr4eRmSA2vJEG1QHdvf570sSOwVSjN/8REL27zvzuMQdH26wHYsDATcVxoE7U+7zyunQOkKxNPNbsbx7fZcziTDkdHW8IfyI6GNqiuU2c/Kmkx8dxX/ASCiC+XKR4YwPTGQZOYkiWFMJA+kqn48Ni1hqcIpJnMH0X68B3+R5YQB4dYxkMHDz7dkQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(186003)(122000001)(38100700002)(91956017)(38070700005)(921005)(8936002)(64756008)(41300700001)(66556008)(8676002)(66946007)(2906002)(4744005)(5660300002)(76116006)(7416002)(71200400001)(478600001)(53546011)(2616005)(66476007)(6506007)(6512007)(6486002)(316002)(110136005)(36756003)(86362001)(31696002)(83380400001)(66446008)(31686004)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzVtYlcxL0FkTkZqZWYySVBZR3JQNTJGRjlNK1EwcVBySU03VDQ2RUoxU3E5?=
 =?utf-8?B?MWNyLy9DbGtPalNQcVBQR0ZpLzBVdmJxTCtvV0VjanU5MDgydGF4RENqOGRO?=
 =?utf-8?B?QUJBdUMwQVR1UnB6aHpSbUZNYXMza2RTd2tXdWNvMisyNnl4WTYzTzY2bnRQ?=
 =?utf-8?B?cmExaG5GOTlXNnkzYzlQRlViZStlTVZtNm9reS82QlVXQkpLdlpLSm5TSG1M?=
 =?utf-8?B?MC9XK2xUbkZSVHJLdDZnQ0xFQSthNFFqMUZCQzgyUm9SbzM2ODRBbExROFhM?=
 =?utf-8?B?Q0xkWG5VY2NqZWgwTFoyRzA4Qmd4VmhpclFWakpnSXRCOWw5U2pEeFhLRVE2?=
 =?utf-8?B?dVN0eTlJV3kxK0lIN3FUUDZvU1EvVmtFRGNEWU1tck5Hd2JnV2pMT1ZGZkg1?=
 =?utf-8?B?YS9PeXFEZWZ1eWVXMGh6NExPUDZBWHlodjkrYkhzYU9VNkkyUm03MTJJazFZ?=
 =?utf-8?B?U3FLK2ZIR3hCUmtXaXU3bEZNNWJzYTJGZk83RXREVHg5L3ZLczZpYkdPc0Nz?=
 =?utf-8?B?azZ3S1F0S2dTc3gxUER0clVkS2IzUTh1T25jUExLZ1B6WGI3Zm8reVNzWWtq?=
 =?utf-8?B?aDdhc1FZUnRNOWJia1JyVDl4V0syVkFhRjA5WFZKUU4xZzd2RWgvQmVhNlBT?=
 =?utf-8?B?aHN6SSs1QkVGRURjSmhoNUQxbDAzbVFOQ3FUeUl6bEtHd2dKUXRvOHNBWjFk?=
 =?utf-8?B?L0xFcCs4cWxsNGF4dEx1QS9pVitvdzE0eGw3RFdjbjA5cmVIRnlwa255OXBU?=
 =?utf-8?B?dG1NTWJNMDJMM2c0Y1ZTQm50cVNQY3hRendNRE03T0hRY2dNalZtYndGTENn?=
 =?utf-8?B?YzZqaERzQTh0cjg0SFFIZ1lxcTFwOE9iZ0tFWGFpeDZrK3hTSmU3Z3J1cWox?=
 =?utf-8?B?TGVIcWdjS0J5WTArN25heUlyaU5kQnNjL0dmUCtaVFF3VjErcEVyanR1VmJo?=
 =?utf-8?B?ZW1uVms4NkhucjFEKzA5RmZjaEJUdHVhSEY4aEN2bDBjS013S01OdVBUYWdp?=
 =?utf-8?B?dDErNWhrdmc1bUl5TS9UcGhmWnc5Q2tZanp5OGQyMVJwb2VyRDlXSWZLbzBD?=
 =?utf-8?B?cVZ3SWtHMGtqUjQrVktUc1Z2M2VhdTZjOUN5cklSNEZzOTNYZVNZMXhscy9o?=
 =?utf-8?B?T2hrSWl1NkN3S3lUdVpkaDJKSGxxYkdHUUR3ZVFvMFphclZuVXVydVRyWWlk?=
 =?utf-8?B?enVOMElZRkFieUYyR0N3M0tmQlVoNFJTWWVzakxxc05keGxOVjR6bTVYWGJ4?=
 =?utf-8?B?dzlpT2EvN0RKd0dGOEJ0RXhkV1FQRFpxWS9HaGhUWjNvQkt2Q3FrbFViYlZk?=
 =?utf-8?B?d2dySjRVT3VoTTFYVVpaa3hKanJQaFRlOFNPN2dTbjAwdkJTdzVlSlpVSFZ1?=
 =?utf-8?B?WmJZNmdrYk9rNHRyYTRvVmo1d3NSbTBJRnpFK2REOTduL29UR1ppMUdIT2sy?=
 =?utf-8?B?d3kvcTRMczJTTW5HL1BJelNnalFxWFhTbnREOUpaR1B4OVhMUzlpdUk2aDZI?=
 =?utf-8?B?Q3Z1Q1FpTUZONVZFQzFwVmNGTHl4MWtISGh1Z2xBcUF3elJTbDNiSUtuV2ox?=
 =?utf-8?B?bExLZWE0dVZHS2Z3SVVkZTlmb0tHR3h2VFlZTWs0ejBJTmFzUytuVHNjOGF1?=
 =?utf-8?B?ME1PcDdzcGN6YkMrSE9hbUorbmwrRWt0T1p2cWcxOGNORCs1RTVubTI3ZjZt?=
 =?utf-8?B?elYwcWo0TW13Unh6N3B4a3hjT0QrU0orMUwxcXJrYk1WUkFuamdmMCtXb3R5?=
 =?utf-8?B?RHU3b0hyU1REeVF0a1FYcmdmaFNkdjhTNTRFWVZkdmg5dHllZUdFN2taVTJl?=
 =?utf-8?B?OFZlZGtDbnlSK3VmR2JGd0g0UjNXeXBGV01tUHozM0FuYWpBV2ppMlhoR3Ar?=
 =?utf-8?B?Wm5vdDlyb1RSMEhNQjZRcFJFTXdDTlNDTFY2K1UvbWtOTDgvZ3hNbzkyV3Nl?=
 =?utf-8?B?MHRsbnkxRFArWTBEN3ljMjdubHhqaWEzTjJvZkx6aElPNG1mMm5Fait4UnFS?=
 =?utf-8?B?UlZrY1NrK3BlelRReFpUdlRnMHhCMFJndkVyeU83eUUySHRsdC9UOFAzUnZk?=
 =?utf-8?B?aytFQ1BUZk9CNXkrUVg3TWdPbE5aVmJrWEJHUmFCYWNSaFp5Qkkzak9CRk5X?=
 =?utf-8?B?V0ppWUxHYVF1dUl2NktadDR3Y2lGN3hCajZKbzRMZE01NkIyRmIrdzhJRFB0?=
 =?utf-8?Q?tFlicD7jCMhh0Gi7Rcq1IB4movvtz0sr1aKo3gInrzmH?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2aac136-b2ca-4bfc-9eba-08db1e00ca80
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 05:08:14.9161 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q9/tnemrRCfiTMhTujpQDPM88JKWDyqdXgg7M7jwCWxZ0ozrT9jDzA53sUrkfP7bblZ9IfcylUhhS0Qf2pGYFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7453
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v4 05/18] scsi: Add support for block PR read
 keys/reservation
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <03C2209FE2D1514D8822CEACCA28F459@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/24/2023 9:44 AM, Mike Christie wrote:
> This adds support in sd.c for the block PR read keys and read reservation
> callouts, so upper layers like LIO can get the PR info that's been setup
> using the existing pr callouts and return it to initiators.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

