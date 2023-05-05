Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0457FC7EE26
	for <dm-devel@archiver.kernel.org>; Tue,  9 May 2023 00:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683590612;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ljgYctBEfHpTuZdYhqp3zh3BPdMKeBe80/SC97iRaqs=;
	b=I/XV6m+tZGQ3skV2UlYpLMAXgutUY+v9bEe8W1Jide+wMyD/MKavRIFsEFdByOa8iuXzdn
	EdQk6NiomJQ9nBnWLBw9lqIP7a5JC26i2ERu15Dg3gpfognv2e2DYLt29uhsM9QvNide0u
	DLw6rrP/lCSf7QnC9opaE1QkWQCS31w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-378-Pm9fR3PbOceidbQiNxOiyA-1; Mon, 08 May 2023 20:03:29 -0400
X-MC-Unique: Pm9fR3PbOceidbQiNxOiyA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC7F4857DE7;
	Tue,  9 May 2023 00:03:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A1EFE492B01;
	Tue,  9 May 2023 00:03:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7BBBF19452C5;
	Tue,  9 May 2023 00:03:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CA22B1946A43
 for <dm-devel@listman.corp.redhat.com>; Fri,  5 May 2023 07:22:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ACE432166B33; Fri,  5 May 2023 07:22:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A3A272166B31
 for <dm-devel@redhat.com>; Fri,  5 May 2023 07:22:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 715223C0ED69
 for <dm-devel@redhat.com>; Fri,  5 May 2023 07:22:55 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-9on6u7dwPN-uQPVbG14SBg-1; Fri, 05 May 2023 03:22:53 -0400
X-MC-Unique: 9on6u7dwPN-uQPVbG14SBg-1
X-IronPort-AV: E=Sophos;i="5.99,251,1677513600"; d="scan'208";a="228145569"
Received: from mail-sn1nam02lp2048.outbound.protection.outlook.com (HELO
 NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.48])
 by ob1.hgst.iphmx.com with ESMTP; 05 May 2023 15:22:50 +0800
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6739.namprd04.prod.outlook.com (2603:10b6:a03:229::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.27; Fri, 5 May 2023 07:22:46 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb%9]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 07:22:46 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Thread-Topic: [PATCH blktests v2] tests/dm: add a regression test
Thread-Index: AQHZe+Y9jbQxdYN1K02JKjkDsq86U69JdlwAgAHWnAA=
Date: Fri, 5 May 2023 07:22:45 +0000
Message-ID: <htvmpsfc4s5rvo4billgviohe5tvay3ajo2rstwf6bb2y3troq@rcqla245y76i>
References: <20230427024126.1417646-1-yukuai1@huaweicloud.com>
 <2lsxdy3n7vfwtmyubfc7kh7yd6mxrht6nlnhmvwzrsellij3kc@5hctf5lvmr6e>
 <7cbad327-d0aa-cbd9-0dc9-c30cd19a8df2@huaweicloud.com>
In-Reply-To: <7cbad327-d0aa-cbd9-0dc9-c30cd19a8df2@huaweicloud.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6739:EE_
x-ms-office365-filtering-correlation-id: 765f97fb-09c7-4d1e-7a5c-08db4d3985d8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eU4Js0OWUXoTwApthsPxO4Ij/J/c9otiuecoRQNn9Lby+OISNsdiAO13SOg1xCqyZdnxFq1GljYk5ME7ryufvPqLzwNmZ0H5CeyVQ3rIkQNWasWz+gu/w+Jr2PSEF1BMYWsbl5S9ZEue+CUmnOurF4jBscbObpgef4UfOJLEoQH3JjXucnbVBadR/raOns0saYpDShUinafpaA2ulQisPlrXagQN+HGfhVoaGxRd2glNPRi7xQJxHRabmjYxO5geKlLxvU9wbU/BQ0EiQq1PrGyP4A+oSPeq6+UWvjCNKv+DfEoHAddg8ZE4nAUP5BBHxA4aUqLJbLmvBjVqG/48pmnTQSE+delHysrvy3ovkOHIcFjSpJPziccXPH2kyKGm12tWGY4XdDldP/V8rGmawZilQhbZEUBKHReDbq/dpScZvstZDg5B/9WU/XyS3mN2HtogJcf9p/Wdq79Tq50TYPoj6X5vX+GDyRpxehntlA4HOzZqVChUs4rIGGAgrdYg7exWiFDd0XPTjzt68T2wR9Z9ACjNGdWUUWBwV1OZDaVjDDSK2HjmxdG4hvyuPkxwAafcX4VbE3KxZ7KeR0d85A7/OpXaflGSakOCPrKvXqzMSxzchQzfXO4em8E5kTxE
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DM8PR04MB8037.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(7916004)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199021)(66556008)(66476007)(66446008)(64756008)(6916009)(4326008)(76116006)(66946007)(71200400001)(478600001)(6486002)(91956017)(316002)(54906003)(86362001)(6506007)(26005)(9686003)(6512007)(8936002)(5660300002)(8676002)(44832011)(4744005)(2906002)(41300700001)(33716001)(82960400001)(38070700005)(186003)(122000001)(38100700002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cy81QVRjRmJPNS9xYW4zYnJBbzJHV0lOZWNYY2FtSnp0eUVKRjVBamV4NW5v?=
 =?utf-8?B?bGVLcFFCbC9hQnd3OFFtVllSMUo4UC9mY0ZqZDNrTUVjbE5GOXFoQ0sxeVVC?=
 =?utf-8?B?Mm12RURvUTRLTnJJU2FWU2VZYmM3YzFNMXBkT1RLTXErM0JFcEZhemVnNU1L?=
 =?utf-8?B?b1Z4UDlxOVQ1ZEQ2L05BaXVWNlV0NmdlUUEwK2tSZHluakFNYVZvNjQwL1hB?=
 =?utf-8?B?enAwaDhFK3dGVzl6NFpXdklNN0drVjI1ZVg2cVg4bStaMVpmWGFsRkJrNERv?=
 =?utf-8?B?bW1ETHlzc2NtK3A1MnVDVHpkanJyWWY4bTBrbUZXdjhmVzJoZEpQWjhUSG1t?=
 =?utf-8?B?aFQyYzFrcGNzazljdnI3RVYzUWtYRzlIQU53UG9xeWR4R3JVYmVodWc3dWlD?=
 =?utf-8?B?YzZlVU1NUUt1ei9zbWVCSWl2dzYza0VKS3VqMEFEWDFxMmw3YVFYdXhCQjBj?=
 =?utf-8?B?THRVVmVCbjE0QWFMK0J0dWdDREk0dVJGTXpBTUtGQUhhR2dsUTlxSDlmbkR0?=
 =?utf-8?B?cmk5aWpzT203RHZQcStKOU9LOGZRWUc4MDZTWkJMWlIvd3dOWTlZY083cGxX?=
 =?utf-8?B?b1JDZmpUSFExZ1E5ODBmZS9RejRycFl0UGRyeU9wNjN6My9Sd2l2MDJ6Tkk4?=
 =?utf-8?B?TFNmUUZJbDFFYzVKLzNRNy90L01XbytOYWp1RVphNzkvV0tTNjdZVEliTUVT?=
 =?utf-8?B?MFRPcVJPMEtCTDl4c0hzdUpxbW1EZU5SMlNtd3dTdFhRQWJmSFMyTE5zNU0v?=
 =?utf-8?B?TDM4aFZYU2VGbnFrZ3hROGhJck82Uy85NkZQbXdBU0tUcEdydXBjaHV3bVpo?=
 =?utf-8?B?Q2pkZ1g4MUxlZ1ViUFZYaVhJdVc3a1pISG1BV0FBeU41Wm1kVzFLN0xkY0Jh?=
 =?utf-8?B?WjBZWVNndTEwUXZQZXB5NkNEODZEbm9nVmEyN083ZG4yajZ4ZmpBRmR3SlBH?=
 =?utf-8?B?eWFPU0ZGd2JiNlY3R1NsMFBCaGNWa3dTUGFzUEsrVThYMmZoQTNFeW8wcHUy?=
 =?utf-8?B?dzFNQUpqS0tIaXdHQ2hvTkZIU1Q3NmRuR2tqZ09pazZjQXoyNnN4VmdPTkZw?=
 =?utf-8?B?K1grSlhzVDhLd3pHTzJnMjViQmVLWC8yWDNadW1rcTRmRDlzeVVBRTEycEts?=
 =?utf-8?B?VFA3L3RmVTUvUTNFc3Jpd0pTdnVnYWdzeG44U1FPcUI3blJDanBRZG5ydXhq?=
 =?utf-8?B?anpwQnI0MGZXVU9hQ3Q0VjNSQjR1RERoTG1NRHR2OUdzMmtxTVcwdW1ORGZw?=
 =?utf-8?B?Z1VUK2RBNlpWdDhUN2NRbmJUTk5na3c0TU5GSjNtYU5jdkdubjFNeHpjanVC?=
 =?utf-8?B?SFpGb0xzZGlqL0owb290b0NyVVFDWUtVeGI3bVU2b0ZmK2tqdU4yM0dNaEhN?=
 =?utf-8?B?OUVWUFdBcTJlZXZDUVI3REJoQkwwWWRFc3JQdXJGaTduVThKUllNYjNRbFhJ?=
 =?utf-8?B?YTNhWjZweGQyU0JIclNGUHNhL2h6SmkwVGdhWlJGY2lrUnV4aTBidUlvblJs?=
 =?utf-8?B?bS81N09va1pGdHRjaDhHcmZJT2VuZUNnRy9CZ2pybExaUXlRZFEwK0VkY0J5?=
 =?utf-8?B?UExJN0x2MGVCNXpkaW8yaVRkOHJOR1pkaitiNGg2Mk5Rb05pL0VqYWZvV0NQ?=
 =?utf-8?B?akV3NGl2VGQyTmpZWUFkWnR4Snh1bFlvVjlBZDZaTTdCMDcxc2c0ZVlHY3o0?=
 =?utf-8?B?TzhOSTBIaDkxUUE2RllOYkFWTWwvRjV1R1Vwc0tpbnk4dlJ5MU1KMXFHckhV?=
 =?utf-8?B?ekFIZEdZVEsydm1OcDhtb1RuK05ZQjN4ZXcvQy94cDRtcTliMXpYMTIxM0FJ?=
 =?utf-8?B?SmtWQ3ZDbHFGemlIS3c3S2p4Yi9nb3piV042OC9mZ1F3c3VCRjdSS0VERFZE?=
 =?utf-8?B?NmkrTG05eEl4Uzl3VHVkWWhYSjhuTkZjMnJKMWZTQk5rY3lEb1BOV1lWdk1M?=
 =?utf-8?B?eFlXOHJnYTBaQ0t1akx0RkdyRGVyUmxseDVKQmhObFpiQWVTaWk3UXFuYjNW?=
 =?utf-8?B?dlJKNXczRHR5L2FpYmJQa1d4KzZJelByTWgvZjFPekI3b2dyR2tlWW1mZ1VG?=
 =?utf-8?B?MFl6UDdKOFpkRFFuenFwWVlQQkVUR1h6WUxkeVFCWC9sVyt1TUR2MjJuLzFw?=
 =?utf-8?B?U0NtSG5jRVpobW50ck03RVhnUEdzK1RTUUZhUmdrSG8rS0xpZzFORjAwd2JN?=
 =?utf-8?B?TVE9PQ==?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dXFrT2hOYk0ySmZ5a0ZhVVZRZkw2U2VqeXEzRFg1WE9tZjRZZE91elgzcmdJ?=
 =?utf-8?B?VFNQZjZzVCs3dTFNVHkraitZZzlVVEhrdkVqWlV0c1Bycnk0dHZjWkJKcGI4?=
 =?utf-8?B?YnVBZ05JZ2lwQU1FUkNtWUd6ejhzRVQwZTlKdmVrem42TDRVSnk5bVRTak1T?=
 =?utf-8?B?cUhHa1dCT0s3R0xZWFpHeDR2OUxROTFjWFl1Mk5nMkNQMUZCZUE1T1RsUmN3?=
 =?utf-8?B?SDJnSDhZOXM5Sm9hKzY0Z2FiY1g3TmtrQmNwemtMaXhtUFlmcVdMeGovc0Vt?=
 =?utf-8?B?ZnJwMDJQZi82M3FEcG9adlEwZWpMb1hSM1R2SzNPb0VaUzJWMkFUVVRJODlm?=
 =?utf-8?B?ZTBUMXJjbUh4NDFrMTVKODFXWUhFUUFKK2ljUndVYm5SUHM5OFdVaTZrUUY5?=
 =?utf-8?B?YThVZjNLbGVDWlFocnJobUVHQ0VkN05pQUMzMWVRQmdPWDFucGJUdVVidjFo?=
 =?utf-8?B?N1RxQit0RVpEeVVyWXkwL2dHd2dmaUgreWJOVXI1SUp1YUl4RW1SbUgwS3hU?=
 =?utf-8?B?V0lrZkUvKzNxYVBIODdZaVpjNDBSVkhCbjVFVzBESHZPTXpEUzRsYUtqMmsr?=
 =?utf-8?B?dW1JMTV0T2dzOEV0cXZ2MHNpb0hIendvR3BlM0JjZmVwS1NnN0VCeExBWVMv?=
 =?utf-8?B?aUJxeHBRTVpuMTVYamxUalo4ZTBLdW1DRzdFZ0xkR0FLdzFFandEeVkyR3Bs?=
 =?utf-8?B?U1VCZjVqeVZYVEZub2h0bWtjem5PUWtoaCtVWjJhRUNGUDVIUWRPRDEvNVc2?=
 =?utf-8?B?bUF5RG9kZGd2dGV5TGthNjFZMTViRnN6OTMraEIxUExvSEdmRVVnZnBtclJx?=
 =?utf-8?B?TWNBay9TdmxiYkx5S0dhY0VLcHoyU3FPcTQ4RUZXeDZsdzhNa1JhNXJZL1g1?=
 =?utf-8?B?TXBRQzdLOXJIRzJDbTRzZVVLQVM1QktlcnBkdmdwMm5lcWEyQ2tENG5Kay9m?=
 =?utf-8?B?eFl1ZFMwbHVwcFhRRXdKdy81bGZDaFNJK1Qrb08wT0hJTksrZmR5c29zZlc1?=
 =?utf-8?B?Uk9qYi9tV0ZTSlU5U3FDazM5Q1pzYitTVFRDMDA4SHJyZ0w2SERkVXZRYVdV?=
 =?utf-8?B?R2djcnhSOTdzVTBzKy9OdmNaZ1ZqZmNTODJqWWlMN29IUG0yWThWK09ubXhh?=
 =?utf-8?B?elVDYzhIVGlSZVgvTG80cWY5bXVwSGxTREdhQ3JEWlJYWklqSENJcHZKSFNp?=
 =?utf-8?B?N0gxT2tXaWZPamovY3hCTWFkWk5zZ3JRSjNPZzNneG9vdU9jWU9aQnZlZG90?=
 =?utf-8?Q?WIL3jwuz4feoGOu?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 765f97fb-09c7-4d1e-7a5c-08db4d3985d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2023 07:22:45.6944 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KWhUH/aBgWQn/VZP+DTxUThHTmgza+O+yu5triBAyVVBlDxGnuR5kF0eesbNG4Iex+BqAEDPQoAebzdrlmunoLsB5qH2IK2EX5gMw7Br+R8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6739
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Tue, 09 May 2023 00:03:21 +0000
Subject: Re: [dm-devel] [PATCH blktests v2] tests/dm: add a regression test
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
 "yukuai \(C\)" <yukuai3@huawei.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "shinichiro@fastmail.com" <shinichiro@fastmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-ID: <307F8B68A294E34B9A9B948946449C5E@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTWF5IDA0LCAyMDIzIC8gMTE6MTgsIFl1IEt1YWkgd3JvdGU6DQo+IEhpLA0KPiANCj4g5Zyo
IDIwMjMvMDUvMDEgMTI6MzQsIFNoaW5pY2hpcm8gS2F3YXNha2kg5YaZ6YGTOg0KPiA+IFl1LCB0
aGFua3MgZm9yIHRoZSBwYXRjaC4gSSBoYXZlIHRocmVlIG1pbm9yIGNvbW1lbnRzIGJlbG93LiBP
dGhlciB0aGFuIHRoYXQsDQo+ID4gdGhlIHBhdGNoIGxvb2tzIGdvb2QgdG8gbWUuIElmIHlvdSBk
byBub3QgbWluZCwgSSBjYW4gZG8gdGhlc2UgZWRpdHMuIFBsZWFzZSBsZXQNCj4gPiBtZSBrbm93
IHlvdXIgdGhvdWdodHMuDQo+IA0KPiBJJ20gZ29vZCB3aXRoIHlvdXIgY29tbWVudHMuDQoNCkFs
bCByaWdodCwgSSd2ZSBhcHBsaWVkIHRoZSBwYXRjaGVzIHdpdGggdGhlIGVkaXRzLiBUaGFua3Mh
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

