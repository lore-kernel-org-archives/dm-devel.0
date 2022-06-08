Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85726C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:47:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-UqPccyMLNQWEUCduaoaMPg-1; Wed, 08 Jun 2022 12:47:53 -0400
X-MC-Unique: UqPccyMLNQWEUCduaoaMPg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E97D29AB45F;
	Wed,  8 Jun 2022 16:47:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2EC0F1415102;
	Wed,  8 Jun 2022 16:47:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C720A194704A;
	Wed,  8 Jun 2022 16:47:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AE1F51947040
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 16:47:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8AA7C2026D07; Wed,  8 Jun 2022 16:47:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 850322026D64
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 16:47:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6291D29AA3B3
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 16:47:49 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-a9-BbEokO7K3DtQEgzXsvw-1; Wed, 08 Jun 2022 12:47:45 -0400
X-MC-Unique: a9-BbEokO7K3DtQEgzXsvw-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2050.outbound.protection.outlook.com [104.47.12.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-34-4Z7Wl_7ANFCAhT1tHyE7Ww-1; Wed, 08 Jun 2022 18:47:41 +0200
X-MC-Unique: 4Z7Wl_7ANFCAhT1tHyE7Ww-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by PAXPR04MB8222.eurprd04.prod.outlook.com (2603:10a6:102:1bd::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 16:47:39 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::80f9:38c4:1d69:7886]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::80f9:38c4:1d69:7886%6]) with mapi id 15.20.5332.012; Wed, 8 Jun 2022
 16:47:39 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH] libmultipath: unset detect_checker for clariion / Unity
 arrays
Thread-Index: AQHYesBA6PR50V8MFEqY2TtKCigfDK1FldnYgAAjkYA=
Date: Wed, 8 Jun 2022 16:47:37 +0000
Message-ID: <b5ad7b428d5998e39863a3144d57e40d32f72c1d.camel@suse.com>
References: <1654641901-12324-1-git-send-email-bmarzins@redhat.com>
 <1675cd007bfee3f944c986e7e8a9eec8969487cd.camel@suse.com>
 <20220608144006.GW5254@octiron.msp.redhat.com>
In-Reply-To: <20220608144006.GW5254@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a4745f5-345a-4466-2bf7-08da496e9966
x-ms-traffictypediagnostic: PAXPR04MB8222:EE_
x-microsoft-antispam-prvs: <PAXPR04MB82226D6DFE6CD3CDB86FA621FCA49@PAXPR04MB8222.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: UiI7VqwqiFikLo3wAWbVhvlRN6tifYQfWTsWP1pv2b+fMhzqz/G/9mivZg87wf82P2JcUgWLON8g9JUrnpeZl+X4USZ93MUWegBKgOQrrjyCUGl+mnTIWnHoGuDdLIpw0f63N/GAVo22iA1vfmdG5NLTYIXQNWSP+F1Ev8c3lmLpntWzXIMyUADj0QQrimgY3EPFtq6wHMnAQUeAvBedgnG6GQFHff7V4G0ne9OnwLVOwogJXq8nAj3/nxmg3+bPLTeUSs2gJBJUYgr3rpoer2hd9iQPoSIuiQSqh56NZw3z5o+aH19reI40jg6uDGhJ90OIdeiJImLRiHIoz7wnxL+8mbv2YNpl4dtWK6FL+ebRS2G0wfhDRvRPFTelYsoVwMRyXIcSrZKigGZXWTCh8j2OkFSuIcXYZ7hORYIdQq1HfXs222j26o0DQz2hItV49Z3FvMMpOJSaNjMKw5+X6s+sbpaWTCzegyD2uZ2/N3cih6gRqHABtu3XMyoyYg2+FO+Ss5S9m67NXeR/aO2eGePvNG9/EDkaoYQ05H7N+0WFOy4A+fvNKBnbHD3enV01/d+OKq8hqhbrlGWjEuIyswW2yFPG4XkHbS43UBI0AWso4Hjh14f/rCZjcESd0YFb0vdqeinRdtkp/EoqHnHfPW8Ro+rw8fj3yIYHohXOJx3voN2DgoVyzpuUeiFEw7k6iv5vqDxb3Yoo3TbfFdePBw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6512007)(26005)(71200400001)(83380400001)(38070700005)(2616005)(5660300002)(8936002)(66476007)(44832011)(508600001)(6486002)(6506007)(86362001)(66946007)(66556008)(76116006)(66446008)(4326008)(64756008)(186003)(8676002)(2906002)(36756003)(91956017)(6916009)(54906003)(38100700002)(316002)(122000001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGJQUzhTdmJUTWhJN3NseWw2eFJFdkNUaTZDUVQyekE5VUFMbUdaYjhSWHVO?=
 =?utf-8?B?RTFPYVI3UWxpRytsZGxPdFNpRmNUTVdkNzRRRUVNVnZ4Ky9QaUhBemptN3hS?=
 =?utf-8?B?MGtGQWNXc3RXeFBGNi83SmtQM1I5MGZjMlh1QTVpVUQrUngycTVmWXQwc21K?=
 =?utf-8?B?TzlxYmcxVE82eEF1NkxBMU0yZFVFWk1nTUVxWHNaR2JULytFSHk5bjFTeHds?=
 =?utf-8?B?MHh2dXVqN3EwbGgwUFJxZUNtR1VLci9XdUpIR21HZGhHbnA5b3pVdmhva0Vq?=
 =?utf-8?B?LytwblJzYjN0eTZTWk9CTC9qSDhCTE5hUktqOUcvUnBnR0o1dmxNN2drZi9r?=
 =?utf-8?B?N2dkQVBXWWh0Z090Zk11MkwvTjdyRDk1VE90a2g3bWwrc3BnZkRjQU5FY09W?=
 =?utf-8?B?RkZuOGtZM1kwZmV3bkx0TDA3KzNvc3RQM2RyMkhEcGI3QjZPRHpqREw5WVhM?=
 =?utf-8?B?ajdYOERwUjBNRmZKWHMrVm9mZlZ6dDFJS3ZqMjRaV0Q5SFl2eXVLYVE2TlRz?=
 =?utf-8?B?ajVOZGwzRGpSK3JzRC9haC9YOGlSUWV5L3NoaURYUjZSSFdNd3V5RWVrUzAw?=
 =?utf-8?B?NnZWQkFYWXpzaFlmSDV5dEtFWHdYeDgwWUVJaFdxRmtQeHprMGk5SXRnblFO?=
 =?utf-8?B?VTZ6N3RyNEVtYzdXYW15K0craERoVXNnUks2akxyWGNKejlmQzFWaGtIRlVj?=
 =?utf-8?B?Mlk5WE50OUE3VW5Ya0VMamZXS1NYMTQrUi9YeVN2NUtoNkJVY3dtZDI1SVFp?=
 =?utf-8?B?TmUvcVlYQ0dEaDZ4b01JQjdRVjdsVEROZ0s5KzFTMWVRcFRYZTV1aW14ZFVv?=
 =?utf-8?B?NzNBb3l4OXRCemV6VjllZTI1NGFrZmNkR0twdHFweEFuZjFoTzc0NDJnTUdR?=
 =?utf-8?B?bmFJeFFTY1I0Z2Y4REJocWJjV3RDaklEYzNkOVdUN00vOTZIRGEvVE42NjBo?=
 =?utf-8?B?bnFYQytvTFZnS05Pd0ZDMFdmMWFqS3NOK3psUklCTXVNWDZKS2hBMGpvQXJj?=
 =?utf-8?B?OUhZazUxU0dOUDR6Z3lQWHFBaEhNRmIvWi96TUJwdHkyZzhjTWQyT09LZ3lr?=
 =?utf-8?B?K1p4WWJ4YWtmMnRYQ1JVNkxiUVZqb0laWm5DSWUvcE1TNUJPYnVyNWdHVFF2?=
 =?utf-8?B?RTA3M0ptR2kyQmgxRWNOanhidFA5blBGMUFOMWlRUTJwZVdzUEJhQTZJZlZ4?=
 =?utf-8?B?dC9kQ0I0OVRaNE8zWThMRDlsckVaNkY5bU1KMHM1Uytmc0lUSU5uUEI5RzdY?=
 =?utf-8?B?SzFxenMrbERIY3orSVJpNTcrR00rRjhuV1VEL0FwUmc3R1FkSWFkUWlQZjcw?=
 =?utf-8?B?ZHhOV0h1dGdNakJvV3FXeFl2bUhUSW9uVEdISEtuRUZCcWNmT0ZSUUFLTnBv?=
 =?utf-8?B?cWVzY0laVFowWHB6Z2ZNQ3A1YjhHamdLT3dsU2ZtSEw2S1dTb3ZHLzgwN2hk?=
 =?utf-8?B?elliYmN0ZDQwRzNkTUNDYXZMVU56VktsMktYL0RNNVV5ekVGaXZsYnJwem9I?=
 =?utf-8?B?SU1EOWF1S21IdFVlOVJoNkRkbzJCLzZyNEVtdEN4cGNFZjNhYUQ2L1oza2h6?=
 =?utf-8?B?NUtySzNXem1oMnF0OEMvQjZXb3dPMEg5dHl1cXk3U2t4NHJOOW9qN0p1UmNx?=
 =?utf-8?B?Q3pESG5sWW9sRUpPWHpHMXJMMzFseGVIRlF1UFg1eWRvRVFoYzNSd24wL1JJ?=
 =?utf-8?B?OWFBMURZUjlEMmprRGpKcm1DN09oRWpXYTRoSkIwVlc4dmE2UnNKQUVaa1FD?=
 =?utf-8?B?WjMyVUdCK2QxQVh1Q01id2JRR2lNS0JhOStBbkcvdHRkMVNBTW5xNE9OSFlx?=
 =?utf-8?B?bHQ1dmRVdnQzTE5WQlBnQzVMYkptcW0yeW92NUluWjlBMlU2L05pQjVjNlI1?=
 =?utf-8?B?K3JRSFhVMGlHN1FKV1B2SE9yUUczdDFZNHBKS25zS3ZCK2l6VFRsaFBQdG1R?=
 =?utf-8?B?dXFrQm9rOXp1eUJpdVlWSFJPb3dvOW1iVStuUEdVaWp1ZkdseU1TeHZvSDFK?=
 =?utf-8?B?UzViM2dBS2xwanZuQmRyeFcrb3hOK056eVd1alRCWjkxWjRmM2NNMURvMDBB?=
 =?utf-8?B?V0h4ZTdsWUllbFlXUWlWYTRwcEJqZlBZRTUvMHVjVHMxWWZJNnhORTJGMy9t?=
 =?utf-8?B?YjEvdlF2cGpJWktiMmx4VTdPaHgyeDZCTy9FZWxjOER1TFhHbkRYU0pxOThz?=
 =?utf-8?B?eGJXRjZ1bUV3alFFN0REeVY1VGM0NXNJNmZUTDFPRHMya001UDNwUFN5cGN5?=
 =?utf-8?B?a2pFK1lpMUJKc3AySGVQekFmb1VIRHJTaTQ0b1NjV09EZytCbnozT2w4djNP?=
 =?utf-8?B?a0wyNVVDMUtIbkN0eHFuVVF1akFROXZVY3dnOHhrcTlqN0xYTzY5cFpKTWMz?=
 =?utf-8?Q?ojOvK0sYum+7w/ZA=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4745f5-345a-4466-2bf7-08da496e9966
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 16:47:39.4874 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JnUKcZiJ2bFCsklCg4EoRWT0wr8wTG6gLlgEBcAKQxlmdcO3+saYL1xBJeZmKv13dC1olGQV26YPbvhrZga7Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8222
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] libmultipath: unset detect_checker for
 clariion / Unity arrays
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
Cc: "vincent.chen1@dell.com" <vincent.chen1@dell.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <AC5358870FE787479C3CE23CD4531719@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCAyMDIyLTA2LTA4IGF0IDA5OjQwIC0wNTAwLCBCZW5qYW1pbiBNYXJ6aW5za2kgd3Jv
dGU6DQo+IE9uIFdlZCwgSnVuIDA4LCAyMDIyIGF0IDA3OjU2OjI3QU0gKzAwMDAsIE1hcnRpbiBX
aWxjayB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMjItMDYtMDcgYXQgMTc6NDUgLTA1MDAsIEJlbmph
bWluIE1hcnppbnNraSB3cm90ZToNCj4gPiA+IERlbGwgRU1DIHdvdWxkIGxpa2UgdG8gYWx3YXlz
IHVzZSB0aGUgZW1jX2NsYXJpaW9uIGNoZWNrZXIuDQo+ID4gPiBDdXJyZW50bHkNCj4gPiA+IGRl
dGVjdF9jaGVja2VyIHdpbGwgc3dpdGNoIHRoZSBjaGVja2VyIHRvIFRVUiBmb3IgVW5pdHkgYXJy
YXlzLg0KPiA+ID4gVGhpcyBjYW4gY2F1c2UgcHJvYmxlbXMgb24gc29tZSBzZXR1cHMgd2l0aCBy
ZXBsaWNhdGVkIFVuaXR5DQo+ID4gPiBMVU5zLA0KPiA+ID4gd2hpY2ggYXJlIGhhbmRsZWQgY29y
cmVjdGx5IHRoZSB0aGUgZW1jX2NoZWNrZXIsIGJ1dCBub3QgdGhlIFRVUg0KPiA+ID4gY2hlY2tl
ci4NCj4gPiA+IA0KPiA+ID4gQ2M6IHZpbmNlbnQuY2hlbjFAZGVsbC5jb20NCj4gPiA+IFNpZ25l
ZC1vZmYtYnk6IEJlbmphbWluIE1hcnppbnNraSA8Ym1hcnppbnNAcmVkaGF0LmNvbT4NCj4gPiAN
Cj4gPiBUaGlzIHBvaW50cyB1cyB0byBhIGZsYXcgaW4gb3VyIGxvZ2ljLg0KPiA+IA0KPiA+IEl0
IHdhcyB3cm9uZyBpbiB0aGUgZmlyc3QgcGxhY2UgdG8gaGF2ZSBhdXRvZGV0ZWN0aW9uIHRha2UN
Cj4gPiBwcmVjZWRlbmNlLA0KPiA+IGV2ZW4gb3ZlciAib3ZlcnJpZGVzIi4gVGhlIGVmZmVjdCBm
b3IgdXNlcnMgaXMgdGhhdCB3aGVuZXZlcg0KPiA+ICJwYXRoX2NoZWNrZXIiIGlzIHNldCwgImRl
dGVjdF9jaGVja2VyIG5vIiBtdXN0IGFsc28gYmUgc2V0LCB3aGljaA0KPiA+IGlzIGhpZ2hseSBz
dXJwcmlzaW5nIGFuZCBhZGRzIG5vIGJlbmVmaXQuDQo+ID4gDQo+ID4gV2Ugc2hvdWxkIGFzc3Vt
ZSB0aGF0IGlmIGEgZGV2aWNlIGhhcyBhbiBleHBsaWNpdCBjaGVja2VyDQo+ID4gY29uZmlndXJl
ZA0KPiA+IGVpdGhlciBpbiB0aGUgZGV2aWNlIGNvbmZpZ3VyYXRpb24sIG92ZXJyaWRlcywgb3Ig
dGhlIGh3dGFibGUsIHRoaXMNCj4gPiBjaGVja2VyIG11c3QgYmUgdXNlZCwgYW5kIGZhbGwgYmFj
ayB0byBhdXRvZGV0ZWN0aW9uIG9ubHkgaWYgdGhpcw0KPiA+IGlzDQo+ID4gbm90IHRoZSBjYXNl
Lg0KPiA+IA0KPiA+IFNvIHdoaWxlIHRoaXMgcGF0Y2ggaXMgYWxyaWdodCwgSSdkIHByZWZlciBh
IHBhdGNoIHRoYXQgZml4ZXMgdGhlDQo+ID4gbG9naWMuDQo+IA0KPiBJJ20gbm90IHN1cmUgdGhh
dCB0aGlzIGlzIGEgZ29vZCBpZGVhLiBJSVJDLCB0aGUgY3VycmVudCBtZXRob2Qgd2FzDQo+IGFu
DQo+IGludGVudGlvbmFsIGNob2ljZS7CoCBUaGUgaWRlYSB3YXMgdGhhdCBpZiBhIGNoZWNrZXIg
d2FzIGF1dG9kZXRlY3RlZCwNCj4gd2UNCj4gd291bGQgdXNlIHRoYXQuIElmIG5vdCwgd2Ugd291
bGQgZmFsbCBiYWNrIHRvIHRoZSB1c2VyIGRlZmluZWQNCj4gY2hlY2tlci4NCj4gRm9yIHRoZSBt
b3N0IHBhcnQgdGhpcyBpcyB1c2VmdWwgZm9yIGFycmF5cyB0aGF0IGNvdWxkIGJlIHJ1biBpbiBB
TFVBDQo+IG9yDQo+IG5vbi1hbHVhIG1vZGUuwqAgQ2hhbmdpbmcgdGhlIHByaW9yaXR5IG9mIGRl
dGVjdF9jaGVja2VyIHdpbGwgc3VkZGVubHkNCj4gY2hhbmdlIGhvdyB0aGVzZSBhcnJheXMgYXJl
IGNvbmZpZ3VyZWQuwqAgVXNlcnMgdGhhdCBjb25maWd1cmVkIGENCj4gZmFpbGJhY2sgY2hlY2tl
ciBmb3IgY2FzZXMgd2hlcmUgdGhlaXIgYXJyYXlzIHdlcmVuJ3QgaW4gQUxVQSBtb2RlDQo+IHdv
dWxkDQo+IHN1ZGRlbmx5IGZpbmQgdGhhdCB0aGVpciBhcnJheXMgd2VyZSBhbHdheXMgdXNpbmcg
dGhlIGZhbGxiYWNrDQo+IG1ldGhvZC4gDQoNCj4gTm93IEknbSBub3Qgc2F5aW5nIHRoYXQgdGhl
IG9yaWdpbmFsIGxvZ2ljIHdhcyB0aGUgYmVzdCBvcHRpb24uIEJ1dCBJDQo+IGFtDQo+IHNheWlu
ZyB0aGF0IGl0IGhhc24ndCBjYXVzZWQgbWFueSBpc3N1ZXMgb3ZlciB0aGUgeWVhcnMgdGhhdCBp
dCdzDQo+IGJlZW4NCj4gaW4gZXhpc3RhbmNlLiBUaGVyZSBhcmUgYSBudW1iZXIgb2YgYXJyYXlz
IGluIHRoZSBidWlsdGluIGhhcmR3YXJlDQo+IHRhYmxlDQo+IHRoYXQgZGVmaW5lIGNoZWNrZXJz
LiBJIGFzc3VtZSB0aGF0IHRoZXkgZWl0aGVyIGRvbid0IHN1cHBvcnQgQUxVQSwNCj4gb3INCj4g
dGhleSBhcmUgaGFwcHkgd2l0aCBvbmx5IHVzaW5nIHRoZWlyIGNvbmZpZ3VyZWQgY2hlY2tlciB3
aGVuDQo+IHRoZWlyPFRoaW5raW5nIGFib3V0IGl0LCANCj4gYXJyYXlzIGFyZW4ndCBpbiBBTFVB
IG1vZGUuDQoNCk1vc3Qgb2YgdGhlIGJ1aWx0LWluIGh3dGFibGUgZW50cmllcyBzZXQgdGhlIFJE
QUMgY2hlY2tlci4gRm9yIHRoZXNlLA0KdGhlIHJlc3VsdCB3aWxsIGJlIHVuY2hhbmdlZCBpZiB3
ZSBsb3dlciB0aGUgcHJlY2VkZW5jZSBvZg0KZGV0ZWN0X2NoZWNrZXIuIFRoZXJlIGFyZSB0d28g
ZW50cmllcyBzZXR0aW5nIERJUkVDVElPIGZvciBub24tU0NTSQ0KZGV2aWNlcyAoREFTRCBhbmQg
SHVhd2VpIE5WTWUpOiBubyByZWdyZXNzaW9uIHJpc2sgdGhlcmUuIFRoZW4gdGhlcmUncw0KQ2xh
cmlpb24gQ1gvQVgvVk5YLCBmb3Igd2hpY2ggdGhlIGNoYW5nZSBpbiBiZWhhdmlvciBpcyBpbnRl
bmRlZC4NCkZpbmFsbHksIHRoZXJlIGFyZSB0d28gZW50cmllcyBmb3IgYW5jaWVudCBIUEUgZGV2
aWNlcyB1c2luZyBIUF9TVy4gSWYNCndlIGNoYW5nZSB0aGUgcHJlY2VkZW5jZSwgdGhlc2UgZGV2
aWNlcyBtaWdodCBzd2l0Y2ggZnJvbSBUVVIgdG8gSFBfU1cNCihpZiB0aGV5IHN1cHBvcnQgQUxV
QSwgZHVubm8pLg0KDQo+ICBJIHdvdWxkIHJhdGhlciBmaXggdGhlIHJlbWFpbmluZyBjYXNlcyB3
aGVyZQ0KPiB0aGUgZXhpc3RpbmcgcHJpb3JpdHkgZ2l2ZXMgdGhlIHdyb25nIGFuc3dlciB0aGFu
IHN1ZGRlbmx5IGNoYW5nZSBob3cNCj4gdGhpbmdzIHdvcmssIGluIGEgd2F5IHRoYXQgY291bGQg
c3VkZGVubHkgYnJlYWsgdGhpbmdzIGZvciBhbiB1bmtub3duDQo+IChidXQgcXVpdGUgcG9zc2li
bHkgbGFyZ2UpIG51bWJlciBvZiBleGlzdGluZyB1c2Vycy4NCg0KQWNjb3JkaW5nIHRvIHRoZSBh
Ym92ZSwgb25seSBwZW9wbGUgd2hvJ2QgdXNlIHZlcnkgb2xkIEhQRSBzdG9yYWdlDQphcnJheXMg
d2l0aCBsYXRlc3QgdXBzdHJlYW0gbXVsdGlwYXRoLXRvb2xzIHdvdWxkIGJlIGFmZmVjdGVkLg0K
DQpSZW1haW4gdGhvc2UgdXNlcnMgdGhhdCB5b3UgbWVudGlvbmVkIOKAlCBwZW9wbGUgd2hvIG9w
ZXJhdGUgaW4gQUxVQSBtb2RlDQpidXQga2VlcCBzb21lIGV4cGxpY2l0IG11bHRpcGF0aC5jb25m
IHNldHRpbmdzIGFyb3VuZCBhcyBmYWxsYmFjayAid2hlbg0KdGhlaXIgYXJyYXlzIGFyZW4ndCBp
biBBTFVBIG1vZGUiIChmb3Igd2hhdGV2ZXIgcmVhc29uKS4gVGhlc2UgdXNlcnMNCndvdWxkIG5v
dyBvYnNlcnZlIHRoYXQgdGhlaXIgYXJyYXlzIG9wZXJhdGUgaW4gZmFsbGJhY2sgbW9kZSwgZXZl
biBpZg0KQUxVQSB3YXMgZW5hYmxlZC4NCg0KSSdtIG5vdCBzdXJlIGlmIHRoaXMgbWF0dGVycyBt
dWNoLiBPVE9ILCBpdCdzIHJhdGhlciBjb21tb24gZm9yIHBlb3BsZQ0KdG8gZm9yZ2V0IHRvIHNl
dCAiZGV0ZWN0X2NoZWNrZXIgbm8iIGFuZCB3b25kZXIgd2h5IHRoZWlyDQptdWx0aXBhdGguY29u
ZiBzZXR0aW5ncyBkb24ndCB0YWtlIGVmZmVjdC4NCg0KPiANCj4gPiAoVGhlIHNhbWUgY291bGQg
YmUgc2FpZCBmb3IgZGV0ZWN0X3ByaW8sIGJ1dCBJIGRvbid0IHdhbnQgdG8gbWFrZQ0KPiA+IG91
dHJhZ2VvdXMgZGVtYW5kcykuDQo+IA0KPiBUaGUgYWJvdmUgYXJndW1lbnRzIGFwcGx5IGhlcmUs
IG9ubHkgbW9yZXNvLg0KDQpCZXNpZGVzIHRoZSBkZXZpY2VzIGFscmVhZHkgbWVudGlvbmVkIGZv
ciBkZXRlY3RfY2hlY2tlciwgdGhlcmUncyB0aGUNCkhpdGFjaGkgVmFudGFyYSBBTVMgc2V0dGlu
ZyBQUklPX0hEUywgYW5kIE9OVEFQIHVzaW5nIFBSSU9fT05UQVAuIFRoZQ0KYmlnIGRpZmZlcmVu
Y2UgaXMgdGhhdCBpbiBkZXRlY3RfcHJpbygpLCBSREFDIGFycmF5cyBhcmUgY29uZmlndXJlZCB0
bw0KdXNlIEFMVUEgcmF0aGVyIHRoYW4gUkRBQy4gU28gaWYgd2Ugc3dpdGNoIHRoZSBwcmVjZWRl
bmNlLCBhbGwgdGhvc2UNCmFycmF5cyB3b3VsZCBzd2l0Y2ggZnJvbSBBTFVBIHRvIFJEQUMuIEkg
YWdyZWUgdGhpcyB3b3VsZCBiZSBzdXJwcmlzaW5nDQphbmQgdW5kZXNpcmFibGUuIEFyZSB0aGVz
ZSBhcnJheXMgc3RpbGwgY29uZmlndXJhYmxlIHRvIG5vdCBzdXBwb3J0DQpBTFVBPyBJZiBubywg
d2UgY291bGQganVzdCByZW1vdmUgdGhlIFJEQUMgZW50cmllcy4gU2FtZSBmb3IgT05UQVAuDQoN
CkFueXdheSwgX2lmXyB3ZSBjaGFuZ2UgdGhlIHByZWNlZGVuY2UgcnVsZXMsIHdlIHNob3VsZCBk
byBpdCBmb3IgYm90aA0KZGV0ZWN0X3ByaW8gYW5kIGRldGVjdF9jaGVja2VyLCBvdGhlcndpc2Ug
b3VyIGJlaGF2aW9yIG1pZ2h0IGFwcGVhcg0KbW9yZSBpbmNvbnNpc3RlbnQgdGhhbiBpdCdzIG5v
dy4NCg0KRm9yIG5vdywgSSdsbCBhY2sgeW91ciBwYXRjaCBhbmQgbGV0IHRoaXMgZGlzY3Vzc2lv
biBzaW5rIGluIGEgYml0Lg0KQ29tbWVudHMgZnJvbSB1c2VycyB3ZWxjb21lIQ0KDQpSZWdhcmRz
DQpNYXJ0aW4NCg0KLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

