Return-Path: <SRS0=6+Yd=NK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7EBC4338F
	for <dm-devel@archiver.kernel.org>; Thu, 19 Aug 2021 09:13:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3D76B61131
	for <dm-devel@archiver.kernel.org>; Thu, 19 Aug 2021 09:13:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3D76B61131
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-fKIiOheBM9e83hL6S9AQVQ-1; Thu, 19 Aug 2021 05:13:26 -0400
X-MC-Unique: fKIiOheBM9e83hL6S9AQVQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71E08189CD04;
	Thu, 19 Aug 2021 09:13:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBAB61017CE8;
	Thu, 19 Aug 2021 09:13:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B7A34BB7C;
	Thu, 19 Aug 2021 09:13:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17J9AwR8023437 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Aug 2021 05:10:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6DCE610CD2C9; Thu, 19 Aug 2021 09:10:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 684EF10CD2C7
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 09:10:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 751DE80378E
	for <dm-devel@redhat.com>; Thu, 19 Aug 2021 09:10:42 +0000 (UTC)
Received: from esa18.fujitsucc.c3s2.iphmx.com
	(esa18.fujitsucc.c3s2.iphmx.com [216.71.158.38]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-470-xI_3qOC-PZCpitCf9-2HpA-1;
	Thu, 19 Aug 2021 05:10:40 -0400
X-MC-Unique: xI_3qOC-PZCpitCf9-2HpA-1
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="37669789"
X-IronPort-AV: E=Sophos;i="5.84,334,1620658800"; d="scan'208";a="37669789"
Received: from mail-os2jpn01lp2053.outbound.protection.outlook.com (HELO
	JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.53])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 18:10:35 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OS3PR01MB6724.jpnprd01.prod.outlook.com (2603:1096:604:f8::6) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.24;
	Thu, 19 Aug 2021 09:10:32 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::6db8:ebd7:8ee4:62bb]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::6db8:ebd7:8ee4:62bb%6]) with mapi id 15.20.4415.024;
	Thu, 19 Aug 2021 09:10:32 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Jane Chu <jane.chu@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH RESEND v6 1/9] pagemap: Introduce ->memory_failure()
Thread-Index: AQHXhSoSnS/qStIblEyff+FzJU/rBqtlt1aAgBDEPoCAAmInAIAABusAgAGlyQCAAA74AIAAC+cA
Date: Thu, 19 Aug 2021 09:10:32 +0000
Message-ID: <OSBPR01MB29203E90FCF9711D8736C8D4F4C09@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
	<de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
	<beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
	<78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
	<d908b630-dbaf-fac5-527b-682ced045643@oracle.com>
	<ab9b42d8-2b81-9977-c60a-3f419e53f7bc@oracle.com>
In-Reply-To: <ab9b42d8-2b81-9977-c60a-3f419e53f7bc@oracle.com>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d365d7e3-2fb8-4726-90da-08d962f13287
x-ms-traffictypediagnostic: OS3PR01MB6724:
x-microsoft-antispam-prvs: <OS3PR01MB6724C04DCBDD3438DA314BBEF4C09@OS3PR01MB6724.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 9olvzgm7caErg4snYe/imrHXAIemqpcEbIHxZNVOifYjOuAtDkPve3fQMc6TEvt7eg8XXlzah3nKy4MIrMyN/H2hGIV0O/ShS60FkqJLPkWXo4S4if76XISP1XQsBS/8p7Zw8BhI6q9S8TCadP0oREvPH+H8YxjYbn4pk8EtgS6NiDZE+zWIAGUsRq6L6VajkgieOmS/UjLvmJeH0S58C9UkMbKs2LEwh7wOu8DFWxAnHWHUcNAQPinFpKgSnj5/F561b07PDvoq7ZGuIh+v9ors0NAIgfEE7NBJO45lWpU+WC9k3feIvaXvJj5MiNFab1UJmemn72hC42cDqGMUlMOwaObZk9CEaKKqfcjLw/utJ2L7BNZLZ0wN/knorzk2+v9ddAXzw0VviSuFhEeCwG03Y2mdf5J7jwAmkdxr0I1+ciO6SCd6qo9BiIpQQK6VgzdYSMcfXi2Dx6Cty8nVqiThfNA4ySJeJUZTfBJ1to6tsNiLeVa8JaAXGXyLWaC6/3jOTjSxbr+YPzZF2MpWrDQEt5hI7rVooljLwdBlBe+1Nzx4NQ9/9f6gYKg7eZOYK7MlJE2aR5wP3EslK6cTA0tgaVf1QA061BOtNICiL3w0YYwh1lEWLRU3qETeg9odPUXQnJrJvBNIMa+FyCnuNzQZQBoNG+RhR27WPf7ymCq5rq9nqGa4BcCMP/ICn/yTiQYlCHQusGY38+5BT0sh7g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(9686003)(83380400001)(86362001)(316002)(54906003)(66446008)(66476007)(85182001)(110136005)(71200400001)(26005)(2906002)(8676002)(478600001)(4326008)(186003)(7416002)(66946007)(52536014)(64756008)(66556008)(8936002)(33656002)(5660300002)(53546011)(7696005)(38070700005)(38100700002)(55016002)(122000001)(76116006)(6506007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L09ERWRwZTQyd0k3cHNWaEdtT0NWUWlUdGk3NEtTc1Y0bU53d25qdHpGOCtK?=
	=?utf-8?B?Ni9jSko0M0YxbFByZlRuSGZoTWo3bzFkZFUydWlqQkNGb2NiVWdib3Bzcmxu?=
	=?utf-8?B?RDdUY29hS1RQYlhHZmdLeFNXVnVEU0tZOWQ2M2lEVnBLS0xOU3BhVW9ySjdq?=
	=?utf-8?B?cXhZdlptVzM5WFd0VHdaNHpYU0JpdkNKa1VERkJseTBhUEtkU1ppK3NhMGJH?=
	=?utf-8?B?WU1VTWZvOVBtM1ZQRGk2dUF3VE56dEpnM0JBbEFTZndFaHNaVHJQQlY3aTZB?=
	=?utf-8?B?b2VSTnZ1MURqdHJiaDAzNkxsUENyTDlyL2RGZHQyWHBULzI3VG9Ud0JUMm00?=
	=?utf-8?B?ZXRocUtPbWdQU3UxYVJQOFRyYlFzZGo2ZkFFYjlrYVEybm9MMXJLc1NwRng0?=
	=?utf-8?B?dEJNMU90c3Q1d09wTEIwRXhjdGdxR295cHl5Y3ZySXFtVFh4Q28rZ2Rhc1hw?=
	=?utf-8?B?OXRjaXB5alNUcWoxa3dMMXdzdTJCOEp2UjVvaThzNHNxMkVsL0Z2MHNxc2Nx?=
	=?utf-8?B?MDVQU3dtY3BFOU5oZkNsb0wxZzN2UEowQ1k1czJUajIwUUw1UGdaNXpsbXdU?=
	=?utf-8?B?bmpud1NDemlidlZ2VCt6NHZSMGlFNWE0a0tsNzFEK0JVd042MzZnVHRYelVC?=
	=?utf-8?B?YnBUeGdUd2U5ZGpTbEhyUjQ3WDJPNnRjeklGUVpCWGFqMkc5MmVpcHQ3R2U4?=
	=?utf-8?B?c0p5cVRaZ29nMVBNZXdHandrT21zaytzb2Jtai9LNzVBZ3llZXAyNG95bWpo?=
	=?utf-8?B?QzBpbC9jSnhjQ3J0czZNNSttZHVMREVXcUltT1p4TGJJd2JmZWtOTFFobHRR?=
	=?utf-8?B?TkhrOGdaOEp3T1VNbjZuaGR4di9GSXJYdENtVUd1OGlpRlI2WjREYitIUDhY?=
	=?utf-8?B?bU1ZdVFEMUNLU0crVll6V0FobWdPV2pSTFRHWWFROHk5anJFU1A1RWhYOVMy?=
	=?utf-8?B?dS9RZzdHTHRvNkduRytlaUJHVTl0VklYRjlVbi9oaUJiMitjek4xYVlHcUpQ?=
	=?utf-8?B?dlpwcFFxWFZmZEorSzNGcnhRamwxaGdGeFlLWmNKSnJ4VEdTTmgyRkpudzZz?=
	=?utf-8?B?b29NeHMxWEd1ZTU2ZFBLY2VqbGVGWkxrMWcxVjFVc3BFMGZCVElzOStTL1Vx?=
	=?utf-8?B?QTVjbEQ0UFE0SHZEVHBGUkNjaTQ0elVTbFNYbkFYNERQbjY5blFJM1ZmZExP?=
	=?utf-8?B?UllXQ0h4L1hvbkNvK1NlQVRmWUNTREVzYTdhL1JTUkU0blpHejNFR2VJaDQw?=
	=?utf-8?B?ZkFSV0xBbG54MEkxanlnWW83YVFvUnB1Y1Q4eDlWN2l0ZEt5eklsc1VMV21a?=
	=?utf-8?B?elJ3dGRaWldpY2owWGp5UVVVUW5iN0dvbEhoaDQyVDlkb1BneHhnSk9SQmI5?=
	=?utf-8?B?NjFXU1RrdGlEMjJHc1Erdi9pQnJ5dkVPQyttUlY4ZlNLbS90OUNPcXBnbmI0?=
	=?utf-8?B?ZkNQblc3dDYxOEt4QXZsa3dOME9ML3hNZFVGZEhFdWdhVkFvR2RMcTB1NUNR?=
	=?utf-8?B?aFA4bmpZM3dPU3UzMEJibHJGamwrVHhpOEJ4MFBwT3hybmpiTW9mQ2lTVFd5?=
	=?utf-8?B?S01LdGZoK0daMWlRT1c1ZGRZaFZsZXYwZThwZGhYNWpVRUJTS242SGUreGh4?=
	=?utf-8?B?TmZYenlGb2NiOEpWdmUrUmJKYTF3YzZCRXN3WXdObTJXNHpubEtMblV5elJx?=
	=?utf-8?B?aXJzazErSTVsWlVHMWxGZVlqNm1HaHVRaDVSUndTdmtpcVhaQUE5VUhPMWFo?=
	=?utf-8?Q?snt5O0sa2gKUdCq2IdgDcvg4IPQ9N/n8mHvL/xq?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d365d7e3-2fb8-4726-90da-08d962f13287
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 09:10:32.2742 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MVsF+UBl2mfXEkw79vHEJffrLv/3Y5SFOIbonAQAYHBrNjsjvB/5fG8k1R8+k80N+A1dd4X4+n6VTMuE1JtB7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6724
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17J9AwR8023437
X-loop: dm-devel@redhat.com
Cc: "snitzer@redhat.com" <snitzer@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 1/9] pagemap: Introduce
	->memory_failure()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: zh-CN
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBGcm9tOiBKYW5lIENodSA8amFuZS5jaHVAb3JhY2xlLmNvbT4KPiBTdWJqZWN0OiBSZTogW1BB
VENIIFJFU0VORCB2NiAxLzldIHBhZ2VtYXA6IEludHJvZHVjZSAtPm1lbW9yeV9mYWlsdXJlKCkK
PiAKPiBTb3JyeSwgY29ycmVjdGlvbiBpbiBsaW5lLgo+IAo+IE9uIDgvMTkvMjAyMSAxMjoxOCBB
TSwgSmFuZSBDaHUgd3JvdGU6Cj4gPiBIaSwgU2hpeWFuZywKPiA+Cj4gPiAgPsKgID4gPiAxKSBX
aGF0IGRvZXMgaXQgdGFrZSBhbmQgY29zdCB0byBtYWtlICA+wqAgPiA+Cj4gPiB4ZnNfc2JfdmVy
c2lvbl9oYXNybWFwYnQoJm1wLT5tX3NiKSB0byByZXR1cm4gdHJ1ZT8KPiA+ICA+Cj4gPiAgPiBF
bmFibGUgcm1wYWJ0IGZlYXR1cmUgd2hlbiBtYWtpbmcgeGZzIGZpbGVzeXN0ZW0gID7CoMKgwqDC
oCBgbWtmcy54ZnMKPiA+IC1tIHJtYXBidD0xIC9wYXRoL3RvL2RldmljZWAgID4gQlRXLCByZWZs
aW5rIGlzIGVuYWJsZWQgYnkgZGVmYXVsdC4KPiA+Cj4gPiBUaGFua3MhwqAgSSB0cmllZAo+ID4g
bWtmcy54ZnMgLWQgYWdjb3VudD0yLGV4dHN6aW5oZXJpdD01MTIsc3U9Mm0sc3c9MSAtbSByZWZs
aW5rPTAgLW0KPiA+IHJtYXBidD0xIC1mIC9kZXYvcG1lbTAKPiA+Cj4gPiBBZ2FpbiwgaW5qZWN0
ZWQgYSBIVyBwb2lzb24gdG8gdGhlIGZpcnN0IHBhZ2UgaW4gYSBkYXgtZmlsZSwgaGFkIHRoZQo+
ID4gcG9pc29uIGNvbnN1bWVkIGFuZCByZWNlaXZlZCBhIFNJR0JVUy4gVGhlIHJlc3VsdCBpcyBi
ZXR0ZXIgLQo+ID4KPiA+ICoqIFNJR0JVUyg3KTogY2Fuam1wPTEsIHdoaWNoc3RlcD0wLCAqKgo+
ID4gKiogc2lfYWRkcigweDB4N2ZmMmQ4ODAwMDAwKSwgc2lfbHNiKDB4MTUpLCBzaV9jb2RlKDB4
NCwKPiA+IEJVU19NQ0VFUlJfQVIpICoqCj4gPgo+ID4gVGhlIFNJR0JVUyBwYXlsb2FkIGxvb2tz
IGNvcnJlY3QuCj4gPgo+ID4gSG93ZXZlciwgImRtZXNnIiBoYXMgMjA0OCBsaW5lcyBvbiBzZW5k
aW5nIFNJR0JVUywgb25lIHBlciA1MTJieXRlcyAtCj4gCj4gQWN0dWFsbHkgdGhhdCdzIG9uZSBw
ZXIgMk1CLCBldmVuIHRob3VnaCB0aGUgcG9pc29uIGlzIGxvY2F0ZWQgaW4gcGZuIDB4MTg1MDYw
MAo+IG9ubHkuCj4gCj4gPgo+ID4gWyA3MDAzLjQ4MjMyNl0gTWVtb3J5IGZhaWx1cmU6IDB4MTg1
MDYwMDogU2VuZGluZyBTSUdCVVMgdG8KPiA+IGZzZGF4X3BvaXNvbl92MTo0MTA5IGR1ZSB0byBo
YXJkd2FyZSBtZW1vcnkgY29ycnVwdGlvbiBbIDcwMDMuNTA3OTU2XQo+ID4gTWVtb3J5IGZhaWx1
cmU6IDB4MTg1MDgwMDogU2VuZGluZyBTSUdCVVMgdG8KPiA+IGZzZGF4X3BvaXNvbl92MTo0MTA5
IGR1ZSB0byBoYXJkd2FyZSBtZW1vcnkgY29ycnVwdGlvbiBbIDcwMDMuNTMxNjgxXQo+ID4gTWVt
b3J5IGZhaWx1cmU6IDB4MTg1MGEwMDogU2VuZGluZyBTSUdCVVMgdG8KPiA+IGZzZGF4X3BvaXNv
bl92MTo0MTA5IGR1ZSB0byBoYXJkd2FyZSBtZW1vcnkgY29ycnVwdGlvbiBbIDcwMDMuNTU0MTkw
XQo+ID4gTWVtb3J5IGZhaWx1cmU6IDB4MTg1MGMwMDogU2VuZGluZyBTSUdCVVMgdG8KPiA+IGZz
ZGF4X3BvaXNvbl92MTo0MTA5IGR1ZSB0byBoYXJkd2FyZSBtZW1vcnkgY29ycnVwdGlvbiBbIDcw
MDMuNTc1ODMxXQo+ID4gTWVtb3J5IGZhaWx1cmU6IDB4MTg1MGUwMDogU2VuZGluZyBTSUdCVVMg
dG8KPiA+IGZzZGF4X3BvaXNvbl92MTo0MTA5IGR1ZSB0byBoYXJkd2FyZSBtZW1vcnkgY29ycnVw
dGlvbiBbIDcwMDMuNTk2Nzk2XQo+ID4gTWVtb3J5IGZhaWx1cmU6IDB4MTg1MTAwMDogU2VuZGlu
ZyBTSUdCVVMgdG8KPiA+IGZzZGF4X3BvaXNvbl92MTo0MTA5IGR1ZSB0byBoYXJkd2FyZSBtZW1v
cnkgY29ycnVwdGlvbiAuLi4uCj4gPiBbIDcwNDUuNzM4MjcwXSBNZW1vcnkgZmFpbHVyZTogMHgx
OTRmZTAwOiBTZW5kaW5nIFNJR0JVUyB0bwo+ID4gZnNkYXhfcG9pc29uX3YxOjQxMDkgZHVlIHRv
IGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uIFsgNzA0NS43NTg4ODVdCj4gPiBNZW1vcnkgZmFp
bHVyZTogMHgxOTUwMDAwOiBTZW5kaW5nIFNJR0JVUyB0bwo+ID4gZnNkYXhfcG9pc29uX3YxOjQx
MDkgZHVlIHRvIGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uIFsgNzA0NS43Nzk0OTVdCj4gPiBN
ZW1vcnkgZmFpbHVyZTogMHgxOTUwMjAwOiBTZW5kaW5nIFNJR0JVUyB0bwo+ID4gZnNkYXhfcG9p
c29uX3YxOjQxMDkgZHVlIHRvIGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uIFsgNzA0NS44MDAx
MDZdCj4gPiBNZW1vcnkgZmFpbHVyZTogMHgxOTUwNDAwOiBTZW5kaW5nIFNJR0JVUyB0bwo+ID4g
ZnNkYXhfcG9pc29uX3YxOjQxMDkgZHVlIHRvIGhhcmR3YXJlIG1lbW9yeSBjb3JydXB0aW9uCj4g
Pgo+ID4gVGhhdCdzIHRvbyBtdWNoIGZvciBhIHNpbmdsZSBwcm9jZXNzIGRlYWxpbmcgd2l0aCBh
IHNpbmdsZSBwb2lzb24gaW4gYQo+ID4gUE1EIHBhZ2UuIElmIG5vdGhpbmcgZWxzZSwgZ2l2ZW4g
YW4gLnNpX2FkZHJfbHNiIGJlaW5nIDB4MTUsIGl0Cj4gPiBkb2Vzbid0IG1ha2Ugc2Vuc2UgdG8g
c2VuZCBhIFNJR0JVUyBwZXIgNTEyQiBibG9jay4KPiA+Cj4gPiBDb3VsZCB5b3UgZGV0ZXJtaW5l
IHRoZSB1c2VyIHByb2Nlc3MnIG1hcHBpbmcgc2l6ZSBmcm9tIHRoZQo+ID4gZmlsZXN5c3RlbSwg
YW5kIHRha2UgdGhhdCBhcyBhIGhpbnQgdG8gZGV0ZXJtaW5lIGhvdyBtYW55IGl0ZXJhdGlvbnMK
PiA+IHRvIGNhbGwKPiA+IG1mX2RheF9raWxsX3Byb2NzKCkgPwo+IAo+IFNvcnJ5LCBzY3JhdGNo
IHRoZSA1MTJieXRlIHN0dWZmLi4uIHRoZSBmaWxlc3lzdGVtIGhhcyBiZWVuIG5vdGlmaWVkIHRo
ZSBsZW5ndGggb2YKPiB0aGUgcG9pc29uIGJsYXN0IHJhZGl1cywgY291bGQgaXQgdGFrZSBjbHVl
IGZyb20gdGhhdD8KCkkgdGhpbmsgdGhpcyBpcyBjYXVzZWQgYnkgYSBtaXN0YWtlIEkgbWFkZSBp
biB0aGUgNnRoIHBhdGNoOiB4ZnMgaGFuZGxlciBpdGVyYXRlcyB0aGUgZmlsZSByYW5nZSBpbiBi
bG9jayBzaXplKDRrIGhlcmUpIGV2ZW4gdGhvdWdoIGl0IGlzIGEgUE1EIHBhZ2UuIFRoYXQncyB3
aHkgc28gbWFueSBtZXNzYWdlIHNob3dzIHdoZW4gcG9pc29uIG9uIGEgUE1EIHBhZ2UuICBJJ2xs
IGZpeCBpdCBpbiBuZXh0IHZlcnNpb24uCgoKLS0KVGhhbmtzLApSdWFuLgoKPiAKPiB0aGFua3Ms
Cj4gLWphbmUKPiAKPiA+Cj4gPiB0aGFua3MhCj4gPiAtamFuZQo+ID4KPiA+Cj4gPgoKLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

