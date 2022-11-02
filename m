Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D648AC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 05:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667366323;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LLMGaIR3VWyWRfGgD37wGjK5vBN5S9SzPmUxAeuKI6I=;
	b=AthpcIw0r/PB9Q3ZxMPAak6RgV1qYHUANvBb3rwR/KewyDPVV/bdapDxgq6Y5OazETDs4T
	qcCvhseW/3B8WMkd3vDrHsK9PY4umaNau0xUUIAW3yUVP4HBfvTvy5C5057K3KoYkvNPfq
	X3unSWjMjai9AGB6FrAWs+We8XO4BkY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-KqPUv4aQMimdlTBw9rsdiA-1; Wed, 02 Nov 2022 01:18:39 -0400
X-MC-Unique: KqPUv4aQMimdlTBw9rsdiA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBE5C800159;
	Wed,  2 Nov 2022 05:18:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 48E82207B344;
	Wed,  2 Nov 2022 05:18:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 25F121946597;
	Wed,  2 Nov 2022 05:18:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B5511946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 05:18:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5FFCEC2DF63; Wed,  2 Nov 2022 05:18:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57D9DC2C8D9
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 05:18:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38C65800159
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 05:18:34 +0000 (UTC)
Received: from esa7.fujitsucc.c3s2.iphmx.com (esa7.fujitsucc.c3s2.iphmx.com
 [68.232.159.87]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-Dmzc8jrJMHOgg4AH3hRU1Q-1; Wed, 02 Nov 2022 01:18:32 -0400
X-MC-Unique: Dmzc8jrJMHOgg4AH3hRU1Q-1
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="69067830"
X-IronPort-AV: E=Sophos;i="5.95,232,1661785200"; d="scan'208";a="69067830"
Received: from mail-tycjpn01lp2169.outbound.protection.outlook.com (HELO
 JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.169])
 by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 02 Nov 2022 14:17:21 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
 by TYCPR01MB9569.jpnprd01.prod.outlook.com (2603:1096:400:192::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Wed, 2 Nov
 2022 05:17:18 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
 ([fe80::5fa2:ac9e:d081:37f1]) by OSBPR01MB2920.jpnprd01.prod.outlook.com
 ([fe80::5fa2:ac9e:d081:37f1%5]) with mapi id 15.20.5769.021; Wed, 2 Nov 2022
 05:17:18 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>
Thread-Topic: [PATCH] xfs: fail dax mount if reflink is enabled on a partition
Thread-Index: AQHYfA4g5aj+ViA5o0mdS5cU960Zpq1oy6eAgCBSEICAACSLAIALwXoAgAASpQCAB7mIAIABcJ4AgDfaCgCAAYXbgIAHcj8AgAAwlgCAADFJAIAAQWgAgAEpzwCAAQljgIAGUv0AgA+aw4CABj0IgIAAQxUAgADul4CAGN++gIACWZ4AgALenACAAFidVoAAJVqAgAHUVwCAAI4xgIADWnYAgABLEYCAA6klgIAEI92AgABL3QA=
Date: Wed, 2 Nov 2022 05:17:18 +0000
Message-ID: <384341d2-876d-2e61-d791-bad784d3add4@fujitsu.com>
References: <6a83a56e-addc-f3c4-2357-9589a49bf582@fujitsu.com>
 <Y1NRNtToQTjs0Dbd@magnolia> <20221023220018.GX3600936@dread.disaster.area>
 <OSBPR01MB2920CA997DDE891C06776279F42E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
 <20221024053109.GY3600936@dread.disaster.area>
 <dd00529c-d3ef-40e3-9dea-834c5203e3df@fujitsu.com>
 <Y1gjQ4wNZr3ve2+K@magnolia> <Y1rzZN0wgLcie47z@magnolia>
 <635b325d25889_6be129446@dwillia2-xfh.jf.intel.com.notmuch>
 <7a3aac47-1492-a3cc-c53a-53c908f4f857@fujitsu.com>
 <Y2G9k9/XJVQ7yiWN@magnolia>
In-Reply-To: <Y2G9k9/XJVQ7yiWN@magnolia>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2022-11-02T05:17:17.976Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSBPR01MB2920:EE_|TYCPR01MB9569:EE_
x-ms-office365-filtering-correlation-id: 8b2668cf-1e62-400b-63eb-08dabc918355
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FkTDq9DnegGsTpvN6sdIceynVazX8EpC5dwktVPB6fVqBg8mOEoi18LcnQjY4gpwlrvN/3m+7D+E9bN9hXAg/jizoY5Do0rP9Gz3g94qbK5Pxzz5i995anEfMYL+9x2pN0S/I9N4NQiRB0kaYK3c0ia9EYlqxw1o4i9+a9MFWvZmceUjlBeedlt1V0m5R0g4M1fyc4KFbM3Q4s9y0PLjqjqqV19tz8EIEzy8BA6dLCJZzAf23IKW1C3HEFLTBYkM2RSn7Q4R8upTFwew+OGJEowOQo8faVGB3b01QqM6iMXhnCPqVRZ0d9CQSkC9fclpe7LDSq2dpMduMU8e4lX4AhlFjR7oAQak5BUP4YjmNM6Xk5O16Iz32xpRg6+Aj1xEGl8LID5oCVFIfJKhCusADMnMe5DN+KSbVlTMPbpvrTq+qetUlsVCmun0b+oIc40xy+zFeMJK14sYjAs/KZoA4CnT3TCnfHCaTvV9E6F3vs+WhUH+LIr1ZEOX5sgvTuE3Ac9X4H/ooYldM7Abe0wxQh4PzEBbbIIsqnHwL38EG5vT8eXFDrkfSX42vwcp9fxiXV3pQg/MFL2BfeOBN3GHuED16OEYCsgBy4U57J2UzRTMZQro5SGwDcjeSdiwFWqu11Fz54T9+MrBfgN6ekeapPuErmVfYIivyYTXH7H2JTDtfugEDhhiCbT+uYF5R7+arymMQpgJ+0aC934EXj8s5lsO0FYkn6zGV4sBf39shmhMjg1HnOOhIV32lFavjBmjAvxw+bVbnx58egbnNrP5ur5bBYHHVWd4AGr0eLtY147WS9lM4dUxeaXGrdab/dmpckC/aeR0TBxdDSfPj0NxaOZdYGBzMLmfZesxQOyK9CU=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(84040400005)(451199015)(1590799012)(31686004)(71200400001)(966005)(38070700005)(7416002)(1580799009)(5660300002)(31696002)(66899015)(6486002)(478600001)(8936002)(66946007)(54906003)(316002)(36756003)(66476007)(2906002)(110136005)(85182001)(76116006)(91956017)(66556008)(38100700002)(26005)(2616005)(6512007)(4326008)(8676002)(64756008)(86362001)(66446008)(6506007)(41300700001)(82960400001)(186003)(122000001)(83380400001)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?WFFSdXg3Q01nM2VudlFYT2pOVkt5cGpyTnZ5RzFyZWN0STQvRWdkcDZpakVO?=
 =?gb2312?B?b1NyUTRMUG1tNy9abi9kM1hmcitHTmg2VXZlL1RqRnk3M21xeXVqcUJSMkZr?=
 =?gb2312?B?WlJWcEdFY3dZQzJSTndmVEgwVVBNM04vb1pocXkvQWJjVXZuUHNPUmgralVQ?=
 =?gb2312?B?UGFUdDB4SGdmQkFWcDYrV1cvMWdab2tHeWV6OGplZ0E2bTM0RnZMUmgyNzZn?=
 =?gb2312?B?TllFMkpYcU5OcGZvamx1ZjMrNVB5SkVLeVp1M2VSUG9oUm5DTHpsaUtVU0RN?=
 =?gb2312?B?ZVNQZTBNU0hjY3h6TXhldHpHdC80Z0Y5bTIydWZYb2IyeUc5b1pVTytCQkR3?=
 =?gb2312?B?V0tBV2dOUk0rMUlWMUt2Y0kzVytZc0JQd2VXaU42RVM2bXA1M0lHTm5ockgy?=
 =?gb2312?B?bTFXNVdELzV0cDlYaVNMaDVaRVNDTnRyR3psQTRJaHNTdmZvUzY2bGJZMGRa?=
 =?gb2312?B?c0lCNjQ3RUJlUlE3OHlWVFM1RVF4QndPb0ZyQkFWdmxueFhuME9NQytubnhC?=
 =?gb2312?B?YVpzcTl3L3JCRFYxUjV3aDhDSGI3bW44UzRzOEZWVG5rcERFcTdDVURlQWJ4?=
 =?gb2312?B?WTk3SmxkbU96c284cm44a3hKc3lVbzBuNEI0WE9qbjhkbzBnZmRhMnpxZSs1?=
 =?gb2312?B?ZTAvZW8yWk15VlZwMjV2OU1BQkU4K3d0TDlxd0JkMWZVT0NIMFBxYTU1Wkc4?=
 =?gb2312?B?Rkl4Nm1WY0RlekNiaHZ1OXl6eDUrYkdobTY4Y2RVN0hQa0tUVTh0bEVTYTRD?=
 =?gb2312?B?OGNWMld4S0xBOFdMNHVUT2tvV1dqMzIvQi9nSUpwVDBlS1lrZXZOQm80NGxY?=
 =?gb2312?B?Q096QTZIT1lWVUtDamp6cDU1MSt2S0hOV0pBc0lrVTJRanlFY2gyRUFIWldj?=
 =?gb2312?B?TVFidlcwMGpqdTlHY1cwYmZZbFVoK1lhV2hRbTRHcmlHREx6WDJ2ZHFtRlFV?=
 =?gb2312?B?QUJJdzhQTXhxcUNpTXlwVGdHZDA5WVozbEhNeTU4S2ExdWl1TU40MWEzS2Ru?=
 =?gb2312?B?RG8wTHlUTzdqc2N2QXVEc05IOVRwMUxIcEJFNU9XN3FMaDF6WmQxU09XdXEw?=
 =?gb2312?B?UnZSd25XVld2TEN2VFk2cFEvSDVTY1BoTkRxUFdhUUlYUUMyN1hjdU1tTWty?=
 =?gb2312?B?VjhKLzRqenIwQkt1d2dpcGFXalE5MWU2QVlleGFKQUJqZUdzcVdrQm5sUUNN?=
 =?gb2312?B?Ly9TOS9wQkNpSDl4d1FadUJydVl4TENBaGZsUFhENXY4aTBHVlFGa1JhM3N6?=
 =?gb2312?B?K0xnM0dyT01TYlE5cVNwZ2JPb1duTk5hN2VMcy9rbWFIcktmcFV2amU3bk9l?=
 =?gb2312?B?bWNoeUpiL3hhMW5vcUh6L3UxVVEvdVVNUTZwcFZBVTVuZi83Rk92MGNYeE1E?=
 =?gb2312?B?TkFuSlBpd0QrN1psbUxpN1A1SVhZSXIvN2drd1c0UGdJZU9lejBWeTh5T0s3?=
 =?gb2312?B?VHB1UHRMdmlnbTZIYy9qQnc5UXd3L05na08zNnlJdkp6UGMxckR4eVV2TjZy?=
 =?gb2312?B?VE9YaGJHZGVua3JsUy9HMTY2YnJXdXduOHdSK2RHUmhMMGZaNUFSSWh3c2lQ?=
 =?gb2312?B?eUl0NFNVTEZvbDlRU0xaWjU5QUtxLzhNTUU1M25MTk9vQXY3Z3VVdHNWK1Zh?=
 =?gb2312?B?ZXE5VlRvbStSVmVxOFdyZEl3eWlVZFRuZFFPMkRua21zOWt5dlpNWFdZbGN2?=
 =?gb2312?B?N2MyQnJRWGlsazdEQUdBUFhuQkdhK3dWem5YSjU0ME4xZ1hsUFdkY2ZSUXV5?=
 =?gb2312?B?eUtXMzh0S083T3Y3R0xlQnZ5Y3FzbmtrN1N5bzZDaE5EcFB6TGxkMlBxSnht?=
 =?gb2312?B?TUdpeUp4M2Mza24zeFV5MFR4N1J2dFRaQkZiSnJ0UFFVT1MxQVdVTDI5ZHNH?=
 =?gb2312?B?K3A1TVhUR0RpYXBOSDBqQTFjblhrcGQ4U2dsVFZjc2l2QXhIcWJBYTFLWUsy?=
 =?gb2312?B?SVdKdlJYZWNEQW9JN3o1bUxUbTZQZ1lJaEtZZWd5VGpwdHVNL0RwN0I1Q2hM?=
 =?gb2312?B?OVdaOVUzSG9BV0xVeXo5OTR0NFFwQmlsaVptWjZHelpkcERwLzhYSkY1d1dJ?=
 =?gb2312?B?L0RHS0ExN2ludUdZbzZPVTZqelg5Sy9IbklnZ0ovRnlBVURhZUxqbnlvRFpB?=
 =?gb2312?Q?uQKwZAxMiapzvCcf2iW/J9qo8?=
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2668cf-1e62-400b-63eb-08dabc918355
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 05:17:18.5881 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mz3kuoU9QNxxqwk0RQGutsIlAi3Ey36yOtt5JoYG1qYZSlQM2Hu3Ka4JheMhElZsvKC0gmksAIJKgleuQ2im7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB9569
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
Cc: "hch@infradead.org" <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>,
 "toshi.kani@hpe.com" <toshi.kani@hpe.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 Brian Foster <bfoster@redhat.com>,
 "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yasunori Gotou \(Fujitsu\)" <y-goto@fujitsu.com>,
 Jeff Moyer <jmoyer@redhat.com>, "zwisler@kernel.org" <zwisler@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6CDAC3A7CD7AEA488670AE6282A65F28@jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

CtTaIDIwMjIvMTEvMiA4OjQ1LCBEYXJyaWNrIEouIFdvbmcg0LS1wDoKPiBPbiBTdW4sIE9jdCAz
MCwgMjAyMiBhdCAwNTozMTo0M1BNICswODAwLCBTaGl5YW5nIFJ1YW4gd3JvdGU6Cj4+Cj4+Cj4+
INTaIDIwMjIvMTAvMjggOTozNywgRGFuIFdpbGxpYW1zINC0tcA6Cj4+PiBEYXJyaWNrIEouIFdv
bmcgd3JvdGU6Cj4+Pj4gW2FkZCB0eXRzbyB0byBjYyBzaW5jZSBoZSBhc2tlZCBhYm91dCAiSG93
IGRvIHlvdSBhY3R1YWxseSAvZ2V0LyBmc2RheAo+Pj4+IG1vZGUgdGhlc2UgZGF5cz8iIHRoaXMg
bW9ybmluZ10KPj4+Pgo+Pj4+IE9uIFR1ZSwgT2N0IDI1LCAyMDIyIGF0IDEwOjU2OjE5QU0gLTA3
MDAsIERhcnJpY2sgSi4gV29uZyB3cm90ZToKPj4+Pj4gT24gVHVlLCBPY3QgMjUsIDIwMjIgYXQg
MDI6MjY6NTBQTSArMDAwMCwgcnVhbnN5LmZuc3RAZnVqaXRzdS5jb20gd3JvdGU6Cj4+Cj4+IC4u
LnNraXAuLi4KPj4KPj4+Pj4KPj4+Pj4gTm9wZS4gIFNpbmNlIHRoZSBhbm5vdW5jZW1lbnQgb2Yg
cG1lbSBhcyBhIHByb2R1Y3QsIEkgaGF2ZSBoYWQgMTUKPj4+Pj4gbWludXRlcyBvZiBhY2NlcyB0
byBvbmUgcHJlcHJvZHVjdGlvbiBwcm90b3R5cGUgc2VydmVyIHdpdGggYWN0dWFsCj4+Pj4+IG9w
dGFuZSBESU1NcyBpbiB0aGVtLgo+Pj4+Pgo+Pj4+PiBJIGhhdmUgL25ldmVyLyBoYWQgYWNjZXNz
IHRvIHJlYWwgaGFyZHdhcmUgdG8gdGVzdCBhbnkgb2YgdGhpcywgc28gaXQncwo+Pj4+PiBhbGwg
Y29uZmlndXJlZCB2aWEgbGlidmlydCB0byBzaW11bGF0ZSBwbWVtIGluIHFlbXU6Cj4+Pj4+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXhmcy9ZelhzYXZPV01TdXdUQkVDQG1hZ25vbGlh
Lwo+Pj4+Pgo+Pj4+PiAvcnVuL210cmRpc2svW2doXS5tZW0gYXJlIGJvdGggcmVndWxhciBmaWxl
cyBvbiBhIHRtcGZzIGZpbGVzeXN0ZW06Cj4+Pj4+Cj4+Pj4+ICQgZ3JlcCBtdHJkaXNrIC9wcm9j
L21vdW50cwo+Pj4+PiBub25lIC9ydW4vbXRyZGlzayB0bXBmcyBydyxyZWxhdGltZSxzaXplPTgy
ODk0ODQ4ayxpbm9kZTY0IDAgMAo+Pj4+Pgo+Pj4+PiAkIGxzIC1sYSAvcnVuL210cmRpc2svW2do
XS5tZW0KPj4+Pj4gLXJ3LXItLXItLSAxIGxpYnZpcnQtcWVtdSBrdm0gMTA3Mzk1MTUzOTIgT2N0
IDI0IDE4OjA5IC9ydW4vbXRyZGlzay9nLm1lbQo+Pj4+PiAtcnctci0tci0tIDEgbGlidmlydC1x
ZW11IGt2bSAxMDczOTUxNTM5MiBPY3QgMjQgMTk6MjggL3J1bi9tdHJkaXNrL2gubWVtCj4+Pj4K
Pj4+PiBBbHNvIGZvcmdvdCB0byBtZW50aW9uIHRoYXQgdGhlIFZNIHdpdGggdGhlIGZha2UgcG1l
bSBhdHRhY2hlZCBoYXMgYQo+Pj4+IHNjcmlwdCB0byBkbzoKPj4+Pgo+Pj4+IG5kY3RsIGNyZWF0
ZS1uYW1lc3BhY2UgLS1tb2RlIGZzZGF4IC0tbWFwIGRldiAtZSBuYW1lc3BhY2UwLjAgLWYKPj4+
PiBuZGN0bCBjcmVhdGUtbmFtZXNwYWNlIC0tbW9kZSBmc2RheCAtLW1hcCBkZXYgLWUgbmFtZXNw
YWNlMS4wIC1mCj4+Pj4KPj4+PiBFdmVyeSB0aW1lIHRoZSBwbWVtIGRldmljZSBnZXRzIHJlY3Jl
YXRlZCwgYmVjYXVzZSBhcHBhcmVudGx5IHRoYXQncyB0aGUKPj4+PiBvbmx5IHdheSB0byBnZXQg
U19EQVggbW9kZSBub3dhZGF5cz8KPj4+Cj4+PiBJZiB5b3UgaGF2ZSBub3RpY2VkIGEgY2hhbmdl
IGhlcmUgaXQgaXMgZHVlIHRvIFZNIGNvbmZpZ3VyYXRpb24gbm90Cj4+PiBhbnl0aGluZyBpbiB0
aGUgZHJpdmVyLgo+Pj4KPj4+IElmIHlvdSBhcmUgaW50ZXJlc3RlZCB0aGVyZSBhcmUgdHdvIHdh
eXMgdG8gZ2V0IHBtZW0gZGVjbGFyZWQgdGhlIGxlZ2FjeQo+Pj4gd2F5IHRoYXQgcHJlZGF0ZXMg
YW55IG9mIHRoZSBEQVggd29yaywgdGhlIGtlcm5lbCBjYWxscyBpdCBFODIwX1BSQU0sCj4+PiBh
bmQgdGhlIG1vZGVybiB3YXkgYnkgcGxhdGZvcm0gZmlybXdhcmUgdGFibGVzIGxpa2UgQUNQSSBO
RklULiBUaGUKPj4+IGFzc3VtcHRpb24gd2l0aCBFODIwX1BSQU0gaXMgdGhhdCBpdCBpcyBkZWFs
aW5nIHdpdGggYmF0dGVyeSBiYWNrZWQKPj4+IE5WRElNTXMgb2Ygc21hbGwgY2FwYWNpdHkuIElu
IHRoYXQgY2FzZSB0aGUgL2Rldi9wbWVtIGRldmljZSBjYW4gc3VwcG9ydAo+Pj4gREFYIG9wZXJh
dGlvbiBieSBkZWZhdWx0IGJlY2F1c2UgdGhlIG5lY2Vzc2FyeSBtZW1vcnkgZm9yIHRoZSAnc3Ry
dWN0Cj4+PiBwYWdlJyBhcnJheSBmb3IgdGhhdCBtZW1vcnkgaXMgbGlrZWx5IHNtYWxsLgo+Pj4K
Pj4+IFBsYXRmb3JtIGZpcm13YXJlIGRlZmluZWQgUE1FTSBjYW4gYmUgdGVyYWJ5dGVzLiBTbyB0
aGUgZHJpdmVyIGRvZXMgbm90Cj4+PiBlbmFibGUgREFYIGJ5IGRlZmF1bHQgYmVjYXVzZSB0aGUg
dXNlciBuZWVkcyB0byBtYWtlIHBvbGljeSBjaG9pY2UgYWJvdXQKPj4+IGJ1cm5pbmcgZ2lnYWJ5
dGVzIG9mIERSQU0gZm9yIHRoYXQgbWV0YWRhdGEsIG9yIHBsYWNpbmcgaXQgaW4gUE1FTSB3aGlj
aAo+Pj4gaXMgYWJ1bmRhbnQsIGJ1dCBzbG93ZXIuIFNvIHdoYXQgSSBzdXNwZWN0IG1pZ2h0IGJl
IGhhcHBlbmluZyBpcyB5b3VyCj4+PiBjb25maWd1cmF0aW9uIGNoYW5nZWQgZnJvbSBzb21ldGhp
bmcgdGhhdCBhdXRvLWFsbG9jYXRlZCB0aGUgJ3N0cnVjdAo+Pj4gcGFnZScgYXJyYXksIHRvIHNv
bWV0aGluZyB0aGF0IG5lZWRlZCB0aG9zZSBjb21tYW5kcyB5b3UgbGlzdCBhYm92ZSB0bwo+Pj4g
ZXhwbGljaXRseSBvcHQtaW4gdG8gcmVzZXJ2aW5nIHNvbWUgUE1FTSBjYXBhY2l0eSBmb3IgdGhl
IHBhZ2UgbWV0YWRhdGEuCj4+Cj4+IEkgYW0gdXNpbmcgdGhlIHNhbWUgc2ltdWxhdGlvbiBlbnZp
cm9ubWVudCBhcyBEYXJyaWNrJ3MgYW5kIERhdmUncyBhbmQgaGF2ZQo+PiB0ZXN0ZWQgbWFueSB0
aW1lcywgYnV0IHN0aWxsIGNhbm5vdCByZXByb2R1Y2UgdGhlIGZhaWxlZCBjYXNlcyB0aGV5Cj4+
IG1lbnRpb25lZCAoZGF4K25vbl9yZWZsaW5rIG1vZGUsIGN1cnJlbnRseSBmb2N1aW5nKSB1bnRp
bCBub3cuIE9ubHkgYSBmZXcKPj4gY2FzZXMgcmFuZG9tbHkgZmFpbGVkIGJlY2F1c2Ugb2YgInRh
cmdldCBpcyBidXN5Ii4gQnV0IElJUkMsIHRob3NlIGZhaWxlZAo+PiBjYXNlcyB5b3UgbWVudGlv
bmVkIHdlcmUgZmFpbGVkIHdpdGggZG1lc2cgd2FybmluZyBhcm91bmQgdGhlIGZ1bmN0aW9uCj4+
ICJkYXhfYXNzb2NpYXRlX2VudHJ5KCkiIG9yICJkYXhfZGlzYXNzb2NpYXRlX2VudHJ5KCkiLiBT
aW5jZSBJIGNhbm5vdAo+PiByZXByb2R1Y2UgdGhlIGZhaWx1cmUsIGl0IGhhcmQgZm9yIG1lIHRv
IGNvbnRpbnVlIHNvdmxpbmcgdGhlIHByb2JsZW0uCj4gCj4gRldJVyB0aGluZ3MgaGF2ZSBjYWxt
ZWQgZG93biBhcyBvZiA2LjEtcmMzIC0tIGlmIEkgZGlzYWJsZSByZWZsaW5rLAo+IGZzdGVzdHMg
cnVucyB3aXRob3V0IGNvbXBsYWludC4gIE5vdyBpdCBvbmx5IHNlZW1zIHRvIGJlIGFmZmVjdGlu
Zwo+IHJlZmxpbms9MSBmaWxlc3lzdGVtcy4gPgo+PiBBbmQgaG93IGlzIHlvdXIgcmVjZW50IHRl
c3Q/ICBTdGlsbCBmYWlsZWQgd2l0aCB0aG9zZSBkbWVzZyB3YXJuaW5ncz8gSWYgc28sCj4+IGNv
dWxkIHlvdSB6aXAgdGhlIHRlc3QgcmVzdWx0IGFuZCBzZW5kIGl0IHRvIG1lPwo+IAo+IGh0dHBz
Oi8vZGp3b25nLm9yZy9kb2NzL2tlcm5lbC9kYXhiYWQuemlwCgpUaGFua3MgZm9yIHlvdXIgaW5m
byEKCgooVG8gRGF2ZSkgSSBuZWVkIHlvdXIgcmVjZW50IHRlc3QgcmVzdWx0IHRvby4gIElmIGNh
c2VzIHdvbid0IGZhaWwgd2hlbiAKcmVmbGluayBkaXNhYmxlZCwgSSdsbCBmb2N1c2luZyBvbiBz
b2x2aW5nIHRoZSB3YXJuaW5nIHdoZW4gcmVmbGluayBlbmFibGVkLgoKCi0tClRoYW5rcywKUnVh
bi4KCj4gCj4gLS1ECj4gCj4+Cj4+Cj4+IC0tCj4+IFRoYW5rcywKPj4gUnVhbgotLQpkbS1kZXZl
bCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

