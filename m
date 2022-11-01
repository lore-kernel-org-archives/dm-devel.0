Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E26BFA373D
	for <dm-devel@archiver.kernel.org>; Tue,  1 Nov 2022 05:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667281532;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=v1aIsb6fieal8V1hfrj/EuZsLAjAC3TvP0UtERCZHcw=;
	b=YjG7vdwUGniFrC2z7eXmEkql/b4T85l90pnE9LT5l6Seb3p0Cx97K8IcaJ4fbHJS5TUz80
	kIzOGtQEMh0Fr9ltrZUiL7h8so9uowB1C1gOTtnLDIZ7C4yC4FN+zwxD1hlRyO0u6/qok+
	HHXK+EHFwlD7Dd/xDLEW2aBkhUtb3Qw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-299-GEV-rDj7MqmShNpP-YM1Yw-1; Tue, 01 Nov 2022 01:45:28 -0400
X-MC-Unique: GEV-rDj7MqmShNpP-YM1Yw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B9D53C0D195;
	Tue,  1 Nov 2022 05:45:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 07BB049BB60;
	Tue,  1 Nov 2022 05:45:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E306319465B3;
	Tue,  1 Nov 2022 05:45:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0B9B61946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  1 Nov 2022 05:45:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 296162024CBE; Tue,  1 Nov 2022 05:45:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21C2D2024CB7
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 05:45:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 035A786EB60
 for <dm-devel@redhat.com>; Tue,  1 Nov 2022 05:45:18 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-HOaiLVuAPVKSEYAGFcGY2A-1; Tue, 01 Nov 2022 01:45:15 -0400
X-MC-Unique: HOaiLVuAPVKSEYAGFcGY2A-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by PH0PR12MB7080.namprd12.prod.outlook.com (2603:10b6:510:21d::20)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Tue, 1 Nov
 2022 05:45:13 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::eaf1:9be8:d472:ea57%7]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 05:45:12 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mike Christie <michael.christie@oracle.com>, "hch@lst.de" <hch@lst.de>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "axboe@kernel.dk"
 <axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
 <linux-nvme@lists.infradead.org>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Thread-Topic: [PATCH v3 04/19] scsi: Add support for block PR read
 keys/reservation
Thread-Index: AQHY6ZG2rXrywtNwpkassqh1XNVmtK4plxQA
Date: Tue, 1 Nov 2022 05:45:12 +0000
Message-ID: <5edeecd7-09a0-65a4-46b7-014d1a1c1acf@nvidia.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-5-michael.christie@oracle.com>
In-Reply-To: <20221026231945.6609-5-michael.christie@oracle.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|PH0PR12MB7080:EE_
x-ms-office365-filtering-correlation-id: 9337af98-a7d8-4b2f-79c6-08dabbcc3edd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: QcPPWvd8ErwvFW9cA6+HwCrYr1V015yGgbMxz6vDuX4BimCWDAn7au9BvrscLyyQ3xfBe2up4QVnD20PobIok3bWJP0JgRW1I6VllCQHeWhzkoLMBnhZvGH/jccm9fYk8phFNUMohsRkjP0KDKRax2OpX3L9EyxznQGcmDQqsrN/PHNMUbm1n9HMkQlIqAaztq2z2kVed8ETJWtevspbyrz7TVRvmgPl58ZqjKzY/fxwc5m2T6j1gBd4nk/bnXq3lNyczxlXWhoroqM/7IwyzA+BafH83L84Lv6iYchtuBjMMmYeUMFIW+CHPeDrmhBZXdDLeID0xRGoiqIm9He/kkY3JvR9nBMDEMGUmviydhLoEUPQzw1z5I9bk47m/mKyKKZybWDLpezVIgrhJIWVRBOdxh4T8ocrI8dz9nT6ijbjVZP4gY7WRjwRWgKraEfpd9feh55/bkVNfFkILw/yiWaq8wSnmbvlTl9MSj8hOFcLTM4fU3Qw6ti4PoCI8eG//RbvEd4qPfHzmQehoOmMsV3Cq8kZx98FpZtzX538F/31EiP85tuOvD4uNzTjHUydpsmUsL5mV5NeoRXRu7laWrEUPcbb8FOBICv1GeW1blU08ijChQfmdgcjv1FDRHjYhbPt2Pj5pK8FKGYzdg9WhiC14XLTPcVBR52cXJvF1T3Z9Z7GGifA5XmdMkk5rylxSC06C8+azneqIZF1pSnxbsyCiTUh/DPcv6hZfQca4UerMXCaSXiUdyjiT8AFHvLZlk247xNlXRXS0NricE0zXbIq8el2uM5jcaH3ENlkO2kOSfmDx74FXV7nVFMWiQigFxcolVIs3eiLvhbxDffywFE2DwVDorz95/Q5aPaxyr4=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(451199015)(5660300002)(2616005)(38100700002)(91956017)(122000001)(4744005)(86362001)(31696002)(7416002)(83380400001)(8676002)(8936002)(186003)(36756003)(66946007)(6506007)(64756008)(66446008)(66556008)(41300700001)(66476007)(6512007)(2906002)(38070700005)(6486002)(921005)(31686004)(76116006)(478600001)(316002)(71200400001)(110136005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFNuZ2xCb0hsM2NHWjhlWmRBWW1rckhueTA5NUhvTlh6YVBvQ1VVS2k5WG0r?=
 =?utf-8?B?c2tSNE9PTFd6eGZHbTNoYmxSeVdmN3RhRENZa1VWdWJ6UXBiOE02Uk9IK3Na?=
 =?utf-8?B?dkhiN1BRUGNGRlZSdm9VaVFyeWM5UzhjVUpjRDQ4ZVdzemdld3JqQnRSc1dJ?=
 =?utf-8?B?T0owdnVhdUlqdlVCdUhvUCtJdXlTckh5ckZXWmpZQlJWclpEeWJQdnVoVnlp?=
 =?utf-8?B?QkNYVUhCTVlRN2VrTmxWVjVJUVcyOURJdFpEcDJleExQclhPUlZWM2Z1OEQr?=
 =?utf-8?B?SXFMK1NMbDlvZFAzUHd1NDIrQXAwZlkvV1h0K2ZnVUdqMkYxNFRob1B1VTR4?=
 =?utf-8?B?eEt3WkxOY0tldm5LZzEvQlUxTEhKNG1ObTdmZDJ4M056SXVURnVrWjRQWWNs?=
 =?utf-8?B?UTFqMEJMVTNaY1JWWGxHdWtBNVU5eFNmc2gxNzB5bEgxZWhjMnE1VHZtNDFO?=
 =?utf-8?B?N0wvekM0TlNrY0NRaGhxeWdNcVV6NHpnWUNUd1crTTFPcnZKV3BPNkJvdlli?=
 =?utf-8?B?UUk3b2xGRVFsTFRuTzJkcUtoNUdTVStpbFQ4azFSWTlpNGRFVCtheHY0RDBa?=
 =?utf-8?B?Nm1rMytxRFpVUHg5QmpHUkxJK3UzODEyRVkrclRIenI3VHQrYWNlYzZ6b29O?=
 =?utf-8?B?emNHMi9INGw1WFJ0RnRrM0YrOHUrbzBoMnVkS0hZOHE3N1pjbmZ3bnhGNnBW?=
 =?utf-8?B?Njl1eUU1L0xZaHdQQWtiZHlLWmZXelNlV3RVUC9tM1pqSXJhd25jSExHdGV0?=
 =?utf-8?B?VDFpdGFPTXRWNUt5bzJzT2FiN251VndMUHdnUWExeEZvcnpPQTliUlJNN3NR?=
 =?utf-8?B?N21rQlN2ZzEveG52Z0hZZUhtY2QrMXZ4bHc0alk3Wk80Wnorei9yeCswRWxn?=
 =?utf-8?B?RXhtNzVHcm5Cc0NWaEdzZEtPOWNOSE9RdkhTTUJQc1d3b29lOW5vRzNoZmhN?=
 =?utf-8?B?SHNmL0RCQTJxUjlBMmNUdlloelQvY1lRZXdNbm1SNDdWNmtEUzhFSmVmRVRR?=
 =?utf-8?B?eTFVS1ZWWkUwbU5xblVaZG1KbTRhWkU3ZnRPY3l2ZnZCR3dPY1E3WnhXSG5F?=
 =?utf-8?B?Y0U0aXZJZDlEWmRDaGYzZVVIbmhuemkwN2JtTjAwTnl1TktSL0VsS2tCaWMz?=
 =?utf-8?B?OWJvbzVPdkdINlhNN2hNN0h4TDZVeUFQTnlIVmFHUllEVm94Mi9KbDJac0dN?=
 =?utf-8?B?TWVaUXE0ZHV4WFFVM2d2MUlLYnBnc1VqYkRza2cxZFo5VFQ0cUQ5aVREam11?=
 =?utf-8?B?WW5ia2VvRFVEWE1ueXd4dlBOdFhHOWFiM1RmdU1FUHdoWVBXV0tpbXB2dUI2?=
 =?utf-8?B?aVFJZzdOWmMyWlB4NmFWY0RvYzZKdFVuSlNoMmo3Z1J0RHhiaytneHlrODVF?=
 =?utf-8?B?VmZCTUZ0akYzeFMzQWJTRkRSSlVTMnZSaHNRQnRqSmpuTXgrK0lMLzIzUmtL?=
 =?utf-8?B?TlFCSTQzTGxiWDY3TGh1ZzkzOEJrMlF3d0NlNkFJYnFuSFN1eWtEd3VjMXF0?=
 =?utf-8?B?aE5zeXVIN0laTk15eitPcS81RVVJQjVYcTVsUjhzdEJWZHRKR0lqd0M5M2dF?=
 =?utf-8?B?OW9pNlo5N1Y3YnFQM09KS2RUckZpbUZGVTk4NlRDbmUwZTVna0ZKaklWNTJS?=
 =?utf-8?B?dWJFTTBsU1ZaK1VpZ2U2MFV3K3FZWVUrNVNPUEs2YzRUekhmY0tWcnhaY3pP?=
 =?utf-8?B?dnpuVTdJeDVMU1dTcEJFTHh6QTZ6eVUzQUFPMVNyeGZaMDFkL3BlMGN2azd0?=
 =?utf-8?B?UzZNS0RRckZpMUJLNW8rN21VM3JGaDhVYVBFdWtibTkzUEVyUkF2RFNkVjRR?=
 =?utf-8?B?dnk4aDhXUDMvcjdzQTk2dHFZTm5wUm1CZ0Y1L1hJMVdiL1FnOURFeXgwSUlV?=
 =?utf-8?B?S3crQ29WYWVXYWxIRUpidzAydG5HclZWeVd4NWU3WTFiYjhhbitnMlV4b3c3?=
 =?utf-8?B?ekZ6OFB1SE1KaGdSK3B6cHk5ZEhsNzVoMUtPNnRmbDhxZ2JOYWRxcW85Z0pV?=
 =?utf-8?B?NElJWVNpNUtMVWpkUGV5b3Z6cDkya21xZjZlMjRJSFlscStPSEZ4UUF4Nko5?=
 =?utf-8?B?NW1jZzVIYmlJSGJhM3pUODhLOUsxaW9pUHZMckxicmZ5WXNrdW1yeFR5c3ZW?=
 =?utf-8?B?dEhoNWU3Qjh6QkVCS2UzUFFxa25lRDdZcnE3eVg4blRrUTV3aDdGVkozeVZT?=
 =?utf-8?B?S0E9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9337af98-a7d8-4b2f-79c6-08dabbcc3edd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 05:45:12.8458 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aj3G3Ywe7mFukW47htTqmh3Tb0jbNr7y4JxnYRPcRzvxGBWT/mjbkivRm5f3g/RS4deJIEc9eUd3NOEni8764g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7080
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v3 04/19] scsi: Add support for block PR read
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <E81F4D3D242E1745AB4C278037589D56@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


> +static inline enum pr_type scsi_pr_type_to_block(enum scsi_pr_type type)
> +{
> +	switch (type) {
> +	case SCSI_PR_WRITE_EXCLUSIVE:
> +		return PR_WRITE_EXCLUSIVE;
> +	case SCSI_PR_EXCLUSIVE_ACCESS:
> +		return PR_EXCLUSIVE_ACCESS;
> +	case SCSI_PR_WRITE_EXCLUSIVE_REG_ONLY:
> +		return PR_WRITE_EXCLUSIVE_REG_ONLY;
> +	case SCSI_PR_EXCLUSIVE_ACCESS_REG_ONLY:
> +		return PR_EXCLUSIVE_ACCESS_REG_ONLY;
> +	case SCSI_PR_WRITE_EXCLUSIVE_ALL_REGS:
> +		return PR_WRITE_EXCLUSIVE_ALL_REGS;
> +	case SCSI_PR_EXCLUSIVE_ACCESS_ALL_REGS:
> +		return PR_EXCLUSIVE_ACCESS_ALL_REGS;
> +	default:
> +		return 0;
> +	}
> +}
> +

same here as previous comment, unless there is strong reason not to do
that ...

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

