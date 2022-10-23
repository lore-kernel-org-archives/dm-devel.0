Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A520ECAAA1
	for <dm-devel@archiver.kernel.org>; Sun, 23 Oct 2022 07:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666508800;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/P2vCS69FEZGxCvaJQmq5Mor5tRLe6Cg95jMDDNO/Ac=;
	b=IKOfQ0BZtr6le55kStXV20zw9QgF3RCfV+TR1O0DuA4xCSD4moEadokwdmVt5qIoSTUiqF
	VL0hwokZ+KnhvY1xEMySMWqo9S5AGQ0gW7HBcPJbKpUxvqcbWAe467wItVRf/kslY0txvj
	0r/lecal6rkIM4JfgkygS0Ryh2qHRvE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-yhh_cYSTOoul_wyF6d8o8w-1; Sun, 23 Oct 2022 03:06:37 -0400
X-MC-Unique: yhh_cYSTOoul_wyF6d8o8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BCEE185A7A8;
	Sun, 23 Oct 2022 07:06:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 29748140EBF3;
	Sun, 23 Oct 2022 07:06:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AC83C1946587;
	Sun, 23 Oct 2022 07:06:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9C8241946586
 for <dm-devel@listman.corp.redhat.com>; Sun, 23 Oct 2022 07:06:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 376F1492B0A; Sun, 23 Oct 2022 07:06:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E7F3492B04
 for <dm-devel@redhat.com>; Sun, 23 Oct 2022 07:06:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DC56804185
 for <dm-devel@redhat.com>; Sun, 23 Oct 2022 07:06:12 +0000 (UTC)
Received: from esa13.fujitsucc.c3s2.iphmx.com
 (esa13.fujitsucc.c3s2.iphmx.com [68.232.156.96]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-dicElejhPKK9A1-a8JnHhA-1; Sun, 23 Oct 2022 03:06:05 -0400
X-MC-Unique: dicElejhPKK9A1-a8JnHhA-1
X-IronPort-AV: E=McAfee;i="6500,9779,10508"; a="67935686"
X-IronPort-AV: E=Sophos;i="5.95,206,1661785200"; d="scan'208";a="67935686"
Received: from mail-tycjpn01lp2172.outbound.protection.outlook.com (HELO
 JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.172])
 by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 23 Oct 2022 16:04:57 +0900
Received: from OS3PR01MB9499.jpnprd01.prod.outlook.com (2603:1096:604:1c8::5)
 by OSZPR01MB6309.jpnprd01.prod.outlook.com (2603:1096:604:ef::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Sun, 23 Oct
 2022 07:04:54 +0000
Received: from OS3PR01MB9499.jpnprd01.prod.outlook.com
 ([fe80::339e:88a3:a24c:5f68]) by OS3PR01MB9499.jpnprd01.prod.outlook.com
 ([fe80::339e:88a3:a24c:5f68%9]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 07:04:54 +0000
From: "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Thread-Topic: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
Thread-Index: AQHYfA4forHNHCyS0U+LGZ2U8ockZa1oy6eAgG1PENKAAYW1gIAHcj8AgAAwlgCAADFJAIAAQWgAgAEpzwCAAQljgIAGUv0AgA+aw4CABj0IgIAAQxUAgADul4CAGN++gIACWZ4AgAB3MICAAWvlEA==
Date: Sun, 23 Oct 2022 07:04:53 +0000
Message-ID: <OS3PR01MB9499BE1E2B3E1823B6F8F1C4832F9@OS3PR01MB9499.jpnprd01.prod.outlook.com>
References: <YyHKUhOgHdTKPQXL@bfoster> <YyIBMJzmbZsUBHpy@magnolia>
 <a6e7f4eb-0664-bbe8-98d2-f8386b226113@fujitsu.com>
 <e3d51a6b-12e9-2a19-1280-5fd9dd64117c@fujitsu.com>
 <deb54a77-90d3-df44-1880-61cce6e3f670@fujitsu.com>
 <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
 <Yzt6eWLuX/RTjmjj@magnolia>
 <f196bcab-6aa2-6313-8a7c-f8ab409621b7@fujitsu.com>
 <Yzx64zGt2kTiDYaP@magnolia>
 <6a83a56e-addc-f3c4-2357-9589a49bf582@fujitsu.com>
 <Y1NRNtToQTjs0Dbd@magnolia>
 <09f522cd-e846-12ee-d662-14f34a2977c4@fujitsu.com>
In-Reply-To: <09f522cd-e846-12ee-d662-14f34a2977c4@fujitsu.com>
Accept-Language: zh-CN, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: =?utf-8?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2Uw?=
 =?utf-8?B?NTBfQWN0aW9uSWQ9ZTdkN2I3ZWMtZDU5Mi00ODExLTg3MmItNmVlZTAyOGNk?=
 =?utf-8?B?ZTZiO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRm?=
 =?utf-8?B?ZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5?=
 =?utf-8?B?LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX01ldGhv?=
 =?utf-8?B?ZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1hYjRk?=
 =?utf-8?B?LTNiMGY0ZmVjZTA1MF9OYW1lPUZVSklUU1UtUkVTVFJJQ1RFRO+/ou++gA==?=
 =?utf-8?B?776LO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRm?=
 =?utf-8?B?ZWNlMDUwX1NldERhdGU9MjAyMi0xMC0yM1QwNzowMDowMlo7TVNJUF9MYWJl?=
 =?utf-8?B?bF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfU2l0ZUlk?=
 =?utf-8?Q?=3Da19f121d-81e1-4858-a9d8-736e267fd4c7;?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3PR01MB9499:EE_|OSZPR01MB6309:EE_
x-ms-office365-filtering-correlation-id: 5822ad2d-ce5e-4506-5ef3-08dab4c4e2bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: shAC7Sb0qDnf7msp/29n39n7X6dFdGv1eWRiv/Ca8jlDQn6fcO869pScEau/qvz8/RoTd8Nw73kyPvFM20eC14exljvdgStW70+rZaT9WRCNtxZIpjv65L0XGQm+TEEhx0CGk2zXDwaz+WzhsqcV2plWNddL5P//FDXcyt9F/PohQ1SAkAivxUAMZfKr4CtCAuSy4TR51z/ltfx/9/SWuYFQdVEmqFjnE2uR1Osb4Kn4D7qNBraVSgL9WfKc1SNNZPvTREXQ8V6wQ3Yoha5RN/OvU7/6mqzJp8Kt6sZlIg/RT7Sfplffji7lFvpoOx/2XSS/IMcgHlZ91J7CJa+/yYgEuTC4j92EFXLvJE6du7V6/Sn0oUuAHVRnSUPbonCBuBiwLCMZ1NIiE1MmlvQmW3A+JVA7x60H+n143tlYO+wOev0VfRAqQWnxQP3DF/zV8tBMBkumkX+eszq3PdcagW9y2I7/X3s0iz2x7OeLRH0bePcgq7WGLj4E+L00a/NeLj6MQ1EH/7Kit38sU4DyMKEpK5YltzWrLrPDVmTVQQpEnDBYjdxNQRarVGSK6WYEeaKO/xsvJIV86TqE+s1dOGb/NOcgRQ4cJ9gefYbY9IqS9djH3qaobb5RfqaWg4l1y4ovSJjc6qYWc0winyAUpqPgv21clmwKiaQXlhcb4VQ0pvxmoZ0C8vMbzJEDBGW97z/nyuf123r4cWhHitcxaUJGJoVPFsjkvz/qnNx/dXPTr/sEJ8ZOYNwx0AZL2Y/zBGqsQ/3bwX76KoQYhAC0pm97yfyQfQVJUU2ieUTk3LATrprpGynm4uM66i7FlFVd50L1QhWCXq6WfMUhcPGzQw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:OS3PR01MB9499.jpnprd01.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199015)(1590799012)(1580799009)(2906002)(5660300002)(7416002)(85182001)(52536014)(55016003)(33656002)(41300700001)(83380400001)(122000001)(38100700002)(38070700005)(82960400001)(71200400001)(6916009)(54906003)(966005)(478600001)(8936002)(86362001)(316002)(66946007)(66476007)(66556008)(64756008)(66446008)(8676002)(4326008)(76116006)(186003)(26005)(9686003)(7696005)(53546011)(6506007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFRSQno3eHUxVVpneEZwZ3lVQVI1SGRmK1k4cnVlaTlLNjNVRnJwdlNNMCs5?=
 =?utf-8?B?YWkvb201OG9oQkhNekdROENUUkJLY3hTSlBsQ3lpeFB1amQySHRWRlQxUTNL?=
 =?utf-8?B?aGRJVk9jT1UrVGlkRnJSeTdhWGJ5WnlNVDF4ZlYxd1V6aUxnY0ZLRCtidVVT?=
 =?utf-8?B?ajF0WldUWDZWc0g4VllhQ0JSQVlGcEE1K3MzenkzN1hiYllnVm1XRjRtVXhC?=
 =?utf-8?B?NjMxd0prS1BJZW5DNldtN0ZXZk1SeHptNWF4OUtYNTdlaVVNNDlic3F0OEZD?=
 =?utf-8?B?VVQ4Qm9nSlh3WTFUWGtqSFBSQlh1RXFUbGVhU1NEMU1xKzlPT3ZVSk5EUUpM?=
 =?utf-8?B?SWczakV6NHlxemp0VTFqRGxIT29SNVJKRHJtOFhYenhFNW9iNkVVem9XQldR?=
 =?utf-8?B?NWE1VU9pMXU1dG9ONzlvODlUNGE2dEFveWFVNzBtUTkrbjNUVHV4QzVqUHdT?=
 =?utf-8?B?QXcvTDNUQjRrVGJHWG4vS2svelFIMy9OT0lYMS84VStSOE1xMG1FNE1OaTRx?=
 =?utf-8?B?VDFyb0ZKWldzRk00VW9abVVlYXQ1blJXZ0IxZEZCc3lUaGlscGpJVVZ6RFBR?=
 =?utf-8?B?MzVaek04TVdneVRBb2NaRFZhMHUrRlNBYVNCWVhUOTlIY0hiYVdSdE9nd1RR?=
 =?utf-8?B?QldybHdtR0lNeUdLZkc0Y29Hd05xN2J1dk4ySTlaZFAxWnJHUUhTdFdZSERV?=
 =?utf-8?B?eDN5aTZQUkxEQU5OelAwTFdTbDhRRWU2WE4vQlVhRzJUMjFraURJZEVTOStE?=
 =?utf-8?B?VUdpUUR3L0E3YkZHa0VjV3pXcnJtZmxuVWlLb3d5T2FiMEVTYVVPVVVPMmhi?=
 =?utf-8?B?TE1XdEpnVG1tdmFSL3QvbUtqWVVvallIbnRwNFZaSTVXU2NsdkJ0R2l3d2k0?=
 =?utf-8?B?MDk4ME53RUJuWnJQYnVsWFJWTHcvd2RHMTZSSkhTM3hVN3VTTFh2S0I3SDFN?=
 =?utf-8?B?MHMvU0RDb2JOQldmbEtlTWYzbHBidUt1NDhrYkcxVjE0TWFhUHdsZmgrYXZJ?=
 =?utf-8?B?N1oyZ2tvbndOLzZIakhNK1JYbDhmL0Z2bGREekRBSWtzMmQxL3Y2cEhaQjcw?=
 =?utf-8?B?b2xjNzFaaE56NFBWcGowSW96aFlNdG95azk5aTlPSkxSMWJKRzJvVHNXYmkw?=
 =?utf-8?B?WGo1SGJmaDR5bmVtZDJEK1RYb05LUFZUTXVZWjgyamFSMXdMQUZmZ2tXVGhE?=
 =?utf-8?B?bTZBMWVRcmVxeXJMN282MUIxUmNKSHh6Y0hKY2JlTHc2Z3YrNlp3VnloZ21I?=
 =?utf-8?B?QnJYTlJrNVJpRVlQQWxjV2RnTkVneTd4TSswWk9PeW5MeG9pZ3Q4SVJoNWFa?=
 =?utf-8?B?Y0ExQjYydDZDR1FKeXhUUVdWNDZPTXc2Y0hEdVd2K2Zid3ZXSi92dTg1L1Ey?=
 =?utf-8?B?R2lNY3Jzb09WVzNzeDF1NHk4TEFRMzArUWU2dkZCNVRQUkkrN3IrT0gyNUZm?=
 =?utf-8?B?amZzR05EaldZdzVBc0k1Um05OVhWUFdScTh1SHBDRzNJVEVkNEdubWxIM2FG?=
 =?utf-8?B?b2RZR0ozd3lTck9VQlZqSS90SlNtVTRtWWx5Njl6RHRoQ1V5enJNS2hVelRB?=
 =?utf-8?B?dDlFcHY5akdEY29MUURZRnVRaWg2UXRFRFhsSGFpUGd2WUgvQkF3UmlTenZh?=
 =?utf-8?B?T1FxNWR5bXdJUEJuYzVSYWVabTRpNEY5R2ZiWDlTbnFYU2NlblRKWGJNcmtw?=
 =?utf-8?B?UDJ2T3FGS3VMQ2JIV0toRWV3alJQM2w3QVdiT3VVNWxURXRZdzYrUmJCOGhN?=
 =?utf-8?B?RkNxRnhiT0YyS3orNkVIUDBhUEorNjFndG05Ni9kN29UTXNUUHgyVE5XMUVs?=
 =?utf-8?B?clJzSmJNbDM4d0JOMzRCVUpVUXo2a01MQ3RnSXgrbnVYMmF6UW9GaE1kYzFZ?=
 =?utf-8?B?ZFpCL3NacGpnc290dHVDK3A0M3NLT3FxMWw1MXgxYnFXa0lqSUhkL1VpeW1F?=
 =?utf-8?B?WkFMS3QzNkI5NjVBT211Mm5zSkZDZnJHR0xBclBmSnpkV1lyNnRyZnZlWXN6?=
 =?utf-8?B?S1NwZUI5VEYyV3lXRFQxUnZEU2ppaDdqVlkrdTc3MG1YbGhYaW8vVTIwVFow?=
 =?utf-8?B?Q0laNkpRSkVKRU9iMUhWSWlLTHF5VGdBTDYrNkhhMmdCTlhIRTV0aHZ0Q0Zh?=
 =?utf-8?Q?m/zsZx5ya4Ystw8cc+kOyfuDc?=
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB9499.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5822ad2d-ce5e-4506-5ef3-08dab4c4e2bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2022 07:04:53.6775 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k9Gsx5rO1/hDr1ZL1tHYrm7W7JirKzZyLnK8FlXJ1EodrNalNl3UDCR4dJ9czFIjAi8gcYEW7Be2SBID86KgFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB6309
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] xfs: fail dax mount if reflink is enabled on
 a partition
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
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "toshi.kani@hpe.com" <toshi.kani@hpe.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 Brian Foster <bfoster@redhat.com>, "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "hch@infradead.org" <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
 "zwisler@kernel.org" <zwisler@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022/10/22 10:11, Darrick J. Wong wrote:
>> We need to fix the issue by discarding XFS log on the block device.
>> mkfs.xfs will try to discard the blocks including XFS log by calling
>> ioctl(BLKDISCARD)  but it will ignore error silently when the block 
>> device doesn't support ioctl(BLKDISCARD).
> ...but I think here's where I think your understanding isn't correct.
> It might help to show how the nested logging creates its own problems.
> 
> First, let's say there's a block B that contains some stale garbage 
> AAAA.
> 
> XFS writes a block into the XFS log (call the block L) with the 
> instructions "allocate block B and write CCCC to block B".  
> dm-logwrites doesn't know or care about the contents of the blocks 
> that it is told to write; it only knows that XFS told it to write some 
> data (the
> instructions) to block L.  So it remembers the fact that some data got 
> written to L, but it doesn't know about B at all.
> 
> At the point where we create the dm-logwrites preunmap mark, it's only
> tracking L.  It is not tracking B.   After the mark is taken, the XFS
> AIL writes CCCC to B, and only then does dm-logwrites begin tracking B.
> Hence B is not included in the preunmap mark.  The pre-unmount process 
> in XFS writes to the XFS log "write DDDD to block B" and the unmount 
> process checkpoints the log contents, so now block B contains contains 
> DDDD.
> 
> Now the test wants to roll to the preunmap mark.  Unfortunately, 
> dm-logwrites doesn't record former block contents, which means that 
> the log replay tools cannot roll backwards from "umount" to "preunmap" 
> -- they can only roll forward from the beginning.  So there's no way 
> to undo writing DDDD or CCCC to B.  IOWs, there's no way to revert B's 
> state back to AAAA when doing dm-logwrites recovery.
> 
> Now XFS log recovery starts.  It sees "allocate block B and write CCCC 
> to block B".  However, it reads block B, sees that it contains DDDD, 
> and it skips writing CCCC.  Incorrectly.  The only way to avoid this 
> is to zero B before replaying the dm-logwrites.
> 
> So you could solve the problem via BLKDISCARD, or writing zeroes to 
> the entire block device, or scanning the metadata and writing zeroes 
> to just those blocks, or by adding undo buffer records to dm-logwrites 
> and teaching it to do a proper rollback.

Hi Darrick,

Thanks for your patient explanation.

Do you know if XFS log records still use buffer write? In other words, they cannot be written into the block device in DAX mode, right?

In fact, I can reproduce the inconsistent filesystem issue on
generic/482 but cannot reproduce the issue on generic/470.

> 
>> Discarding XFS log is what you said "reinitialize the entire block 
>> device", right?
> No, I really meant the/entire/  block device.
> 
>>> I think the only way to fix this test is (a) revert all of 
>>> Christoph's changes so far and scuttle the divorce; or (b) change this test like so:
>> Sorry, I didn't know which Christoph's patches need to be reverted?
>> Could you tell me the URL about Christoph's patches?
> Eh, it's a whole long series of patches scuttling various parts where 
> pmem could talk to the block layer.  I doubt he'll accept you 
> reverting his removal code.

Where can I find the Christoph's patch set you mentioned.
I just want to know the content of Christoph's patch set.

> 
>>>    1. Create a large sparse file on $TEST_DIR and losetup that sparse
>>>       file.  The resulting loop device will not have dax capability.
>>>
>>>    2. Set up the dmthin/dmlogwrites stack on top of this loop device.
>>>
>>>    3. Call mkfs.xfs with the SCRATCH_DEV (which hopefully is a pmem
>>>       device) as the realtime device, and set the daxinherit and rtinherit
>>>       flags on the root directory.  The result is a filesystem with a data
>>>       section that the kernel will treat as a regular block device, a
>>>       realtime section backed by pmem, and the necessary flags to make
>>>       sure that the test file will actually get fsdax mode.
>>>
>>>    4. Acknowledge that we no longer have any way to test MAP_SYNC
>>>       functionality on ext4, which means that generic/470 has to move to
>>>       tests/xfs/.
>> Sorry, I didn't understand why the above test change can fix the issue.
> XFS supports two-device filesystems -- the "realtime" section, and the 
> "data" section.  FS metadata and log all live in the "data" section.
> 
> So we change the test to set up some regular files, loop-mount the 
> files, set up the requisite dm-logwrites stuff atop the loop devices, 
> and format the XFS with the data section backed by the dm-logwrites 
> device, and make the realtime section backed by the pmem.
> 
> This way the log replay program can actually discard the data device 
> (because it's a regular file) and replay the log forward to the 
> preunmap mark.  The pmem device is not involved in the replay at all, 
> since changes to file data are never logged.  It now becomes 
> irrelevant that pmem no longer supports device mapper.
> 
>> Could you tell me which step can discard XFS log?
> (None of the steps do that.)
> 
>> In addition, I don't like your idea about the test change because it 
>> will make generic/470 become the special test for XFS. Do you know if 
>> we can fix the issue by changing the test in another way? blkdiscard 
>> -z can fix the issue because it does zero-fill rather than discard on the block device.
>> However, blkdiscard -z will take a lot of time when the block device 
>> is large.
> Well we/could/  just do that too, but that will suck if you have 2TB 
> of
> pmem.;)
> 
> Maybe as an alternative path we could just create a very small 
> filesystem on the pmem and then blkdiscard -z it?

Good idea, I have sent a patch set to do it.
https://lore.kernel.org/fstests/20221023064810.847110-1-yangx.jy@fujitsu.com/T/#t

> 
> That said -- does persistent memory actually have a future?  Intel 
> scuttled the entire Optane product, cxl.mem sounds like expansion 
> chassis full of DRAM, and fsdax is horribly broken in 6.0 (weird 
> kernel asserts everywhere) and 6.1 (every time I run fstests now I see 
> massive data corruption).

As far as I know, cxl.mem will take use of nvdimm driver and can be used by many existing applications.

Best Regards,
Xiao Yang
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

