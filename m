Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17D58C74A5B
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 20:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679603020;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=lgsjrm+0SU9gS9QC4YjUZCOWOlHaZ5XVXm80LOqFbHA=;
	b=f4ukpxI97inwXU+dBUzhFeVojifUCwhItcTBASK6IAYs/XoROFc+zHzDh2W8Shb6UcX85R
	wgl85nNdyDwLTGdB+fhPqoIEW090rphR7jjMuCA12vBfyVOO/QAV76Bz3G+HvWHui9kyqe
	nqyaM8E6RakqD9FflDkZQ/IsWtDIfKo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-_3zy7pLeNK-03U8exRpXDQ-1; Thu, 23 Mar 2023 16:23:36 -0400
X-MC-Unique: _3zy7pLeNK-03U8exRpXDQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF29685A5B1;
	Thu, 23 Mar 2023 20:23:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9944A140E94F;
	Thu, 23 Mar 2023 20:23:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 73B1F19465B7;
	Thu, 23 Mar 2023 20:23:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 492801946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 20:23:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3913940C6E68; Thu, 23 Mar 2023 20:23:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3124640C6E67
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 20:23:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02A571C0518C
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 20:23:33 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on2051.outbound.protection.outlook.com [40.107.13.51]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-A6gQhxj1OtmttNGPWzLkRw-1; Thu, 23 Mar 2023 16:23:28 -0400
X-MC-Unique: A6gQhxj1OtmttNGPWzLkRw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AM8PR04MB7377.eurprd04.prod.outlook.com (2603:10a6:20b:1de::6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 20:23:24 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::264c:9f82:e937:9408%3]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 20:23:24 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "brian@purestorage.com"
 <brian@purestorage.com>
Thread-Topic: [dm-devel] [PATCH] libmultipathd Avoid parsing errors due to
 unsupported designators
Thread-Index: AQHZXcVR9XTrPjia+EmkAIWBK28i/Q==
Date: Thu, 23 Mar 2023 20:23:24 +0000
Message-ID: <e52c66c71e3a3f25412c86763af8de9fadbfd3c8.camel@suse.com>
References: <DB68C384-BA3A-40E8-9223-4868EE30B68A@purestorage.com>
In-Reply-To: <DB68C384-BA3A-40E8-9223-4868EE30B68A@purestorage.com>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AM8PR04MB7377:EE_
x-ms-office365-filtering-correlation-id: f1e425a5-2901-45bf-2289-08db2bdc7428
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: DVEJ/vGl0g9s8o36v8E4TCECXHVeUlhbEurx++UtYyQkm7fEdXfSlPEQ43DufYXM5QyRppE6GiVduzobeiX97lJSByjCb0XWUZJ0ONyn/xVtfu6rWfi3WNFM/z3+74ujPsURliISEDuhmNpkpPDH98BtfujwllnVAaPv8v14BhRTVRKWA09uV1K6eYQCvBkOVoQ+OIpZtp+JmP7e0CwMc+j6E16uynqUiiCDW+iRH+FXgTqLmq2suyzyyNsle/C3p9AF3lVSUlSpvGCGj5HtkQTZZsMtegGixKMGFmwf8zYIMiEfxXMDf7PG4jxvOPf3T5D+Mvsa+/iddumx1Y/XB/gouhFpV5oAzpZq4b7V7XBkKg/LwcAF11B0X/iGvHyoB4ctB98cft5297TN3kGCSN3NkoHYjYbrV2TeyJCbak8Y1xoNEHEIR7/zM+YjyK6HCMMDuxw8cRabhaiS+r0Vt7U7Aawfmb7QSWIS3DPXz0OdSjABChCEqszGjUERymhbcLTmUE2X4t/3XK+bH5/P+SjtFzinotAnAjsR27vKtIu6gcx7YTkG7khA6QtoXzeNxNCfIeWFcNm8uPcXvTJhupUyAfRpFg/Gks4LW+DAXcnmHfbaaifMcytxcLJpX8CgHl4v157DGIzFWhKqSDII+yw+33lFWjC0vUtkIZxyOv5xIuKU8Kga8aodryEfS4xKCK3/txVvj2ImAaEnocHvnQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(396003)(39860400002)(136003)(346002)(376002)(366004)(451199018)(38100700002)(38070700005)(2906002)(86362001)(6486002)(478600001)(71200400001)(186003)(36756003)(2616005)(110136005)(54906003)(91956017)(64756008)(4326008)(66476007)(66446008)(8676002)(66946007)(66556008)(76116006)(99936003)(6512007)(4744005)(316002)(6506007)(5660300002)(8936002)(26005)(122000001)(44832011)(41300700001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?nC4lDxDGPoDHhXo9vtMM70z37Dw+oVhEkR8jR0skv86qdOYWMpVk90s+S?=
 =?iso-8859-15?Q?aIYhrYDF1RvIMEoYsxgeqhRCsYy9cRedrvjqSr2Qf7kIN3pKx1NhbmXAv?=
 =?iso-8859-15?Q?ATSWixYR4s25EhK8kGvE5s8woqD2lAjqVYG032VQMV/ZoD2k3+YfJtkYL?=
 =?iso-8859-15?Q?xglBSUU8FLciERsHIjnKAlzXQ9fyaiW3SuEfYSYv4a7IIjNX24/nHTyes?=
 =?iso-8859-15?Q?VjdIanOZIcK/6eeRqL/VaxoPKthHzcpj3qLEuHcsIXLAWz7ABcRi8Q50+?=
 =?iso-8859-15?Q?ZL0lNyELxZWmaWoVoVxGYgyQDuo04CUI7X6iLijBIUGkv88RoAsLlBWqd?=
 =?iso-8859-15?Q?Pb5JLfjhUYw+UetVtQ5NBjt8UpSDdmFjMyqy2uugc1fu0APUM9/AN9PGS?=
 =?iso-8859-15?Q?7JiZZ5vNqlQnSgOztXqDX5i3PISIQxLULQkDTh9ylwkrUwjPYAxwyXopV?=
 =?iso-8859-15?Q?vDHvtUK2+FsZC9OyCX/y0YPXvqEG8YceVVBNxvSIXreUNofsDKBXYdMa4?=
 =?iso-8859-15?Q?QUZMS1vpEoV8q2J729C5MbhoUWwXfpxE4q4QEYua3uLBTWBpDMfoLsWEf?=
 =?iso-8859-15?Q?L5xfuu4+bAKhD/VWOXZkpQ5+hO8MoyDEGWcJDgqC8kmJKYyXjm8gRg+Kh?=
 =?iso-8859-15?Q?SIGuKP50TBKpnjEIcVCiOba3D/JBZ+9VV/l2Z7fJyGOfxqUuHfV0EDqgv?=
 =?iso-8859-15?Q?/6gQg4lG21C4NaCQKo7N8BdBmoa91mNGD/1ldGE8+8Nq0iiTAMJmNCRiy?=
 =?iso-8859-15?Q?lgwq8RONFPexhOevarr9CF1dtwKTj+ArZPSiTCPZVS7N8PcGh9dxSD3WI?=
 =?iso-8859-15?Q?R5byhdoEoXY/gUG1pwvRzsQxbRAZRK6c8HfHWo9OXeiUebj/h5r30Fq8I?=
 =?iso-8859-15?Q?asHeKR+i1A/Qsrtb1JzerjrZ2Xc3Zj5riGiyRFhOjFWoUwf7IvnyVNz73?=
 =?iso-8859-15?Q?OQjksBKSM/+MhdQ0mGpeQV1Xvsn3QnNMtRqhTQNNP21fe/MBp37W8W0SU?=
 =?iso-8859-15?Q?8KnV73MVVQej/1AR16Dc3XMnzFilu7+byr8l+ROMmb1ecdztoi3LeuXsH?=
 =?iso-8859-15?Q?iVDWuvJIfRE2bESZfsCFeOm+I4UuM+yjEXQR6ypCn30z7M/a/9T00XTMu?=
 =?iso-8859-15?Q?Pm7tT+AGtCKfJsmF5tmONV+Nxo9XLHGkEAy49OcrpUGqsEyEE8gsHFlYw?=
 =?iso-8859-15?Q?BgqHhvIqQKtLZSXaEqUYyBU9LfTm5ULAYBWLBkZUAxok2WrejLoFwhWUo?=
 =?iso-8859-15?Q?HnWDv82vGtzhTdUCRJqZK0kYzw5M/F4phDoXREHMoWqhxhqiRkEKj+8Re?=
 =?iso-8859-15?Q?4Bmy32bHvrfAdI7/yETqLaJypluUptiltGHd4wgzPum2+5NAdKNANcx5J?=
 =?iso-8859-15?Q?eZiiBOzoVzsQbOuwhLT5tNbJjU8QbeaKSKdcDZ0J69viDe8Cu9v1XZ/8x?=
 =?iso-8859-15?Q?204pYE6hI9l8ETVDQxyJEPm2XCVz1pnXlmgjxbva/3RAsNzceBEt5WpDf?=
 =?iso-8859-15?Q?7YwTAMRMWFgFFSnY0PobSFeLCT7iGOeUcC5nvNNd//hFwCrR/+xMI6tLl?=
 =?iso-8859-15?Q?ul+/UKump1W7ReETthUpWJAFerVJRm1lcQRaNZWfgJrNxPJS22zrzpPrC?=
 =?iso-8859-15?Q?P0suItVl2hx1Zp1UOJvnRO78VwMbyvRoGHAyuGtBvhQ3J4rCCUp0x9TAk?=
 =?iso-8859-15?Q?HBdn7gK+qT9F/REafBmGyq/E5Q=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1e425a5-2901-45bf-2289-08db2bdc7428
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2023 20:23:24.4487 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzjYXyII1Q+VZh8U4FoFqTCGjEL8s9gsle7jYr1VGFFhAv3buC4DVu8+rUtWp1Tw+offyHWkaaFjCUWTYIs1yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7377
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH] libmultipathd Avoid parsing errors due to
 unsupported designators
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-Type: multipart/mixed;
 boundary="_002_e52c66c71e3a3f25412c86763af8de9fadbfd3c8camelsusecom_"

--_002_e52c66c71e3a3f25412c86763af8de9fadbfd3c8camelsusecom_
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <D288AFF61A52BC40B8853A0A89CAE6F3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-03-20 at 12:22 -0700, Brian Bunker wrote:
> Unsupported designators, even if they are correct, will result
> in parsing errors. Add support for these two:
>=20
> Logical Unit Group (0x6)
> Vendor Specific (0x0)
>=20
> Mar 20 13:37:35 init107-18 multipath[45016]: parse_vpd_pg83:
> invalid device designator at offset 87: 01060004
> Mar 20 13:37:35 init107-18 multipath[45016]: parse_vpd_pg83:
> invalid device designator at offset 131: 02000005
>=20
> Thanks,
> Brian

Thanks. I've modified your patch as attached.

Martin


--_002_e52c66c71e3a3f25412c86763af8de9fadbfd3c8camelsusecom_
Content-Type: text/x-patch;
	name="0001-libmultipathd-Avoid-parsing-errors-due-to-unsupporte.patch"
Content-Description: 0001-libmultipathd-Avoid-parsing-errors-due-to-unsupporte.patch
Content-Disposition: attachment;
	filename="0001-libmultipathd-Avoid-parsing-errors-due-to-unsupporte.patch";
	size=1477; creation-date="Thu, 23 Mar 2023 20:23:24 GMT";
	modification-date="Thu, 23 Mar 2023 20:23:24 GMT"
Content-ID: <8B299A92C341FD488D853692A69E31BC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64

RnJvbSA5ZWRiYzJiNjE1NDc4NmE5ZTdiYjM4ODkwZDAyMzMwMWM2NWM4YTZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCcmlhbiBCdW5rZXIgPGJyaWFuQHB1cmVzdG9yYWdlLmNvbT4K
RGF0ZTogTW9uLCAyMCBNYXIgMjAyMyAxMjoyMjowMiAtMDcwMApTdWJqZWN0OiBbUEFUQ0hdIGxp
Ym11bHRpcGF0aGQgQXZvaWQgcGFyc2luZyBlcnJvcnMgZHVlIHRvIHVuc3VwcG9ydGVkCiBkZXNp
Z25hdG9ycwoKVW5zdXBwb3J0ZWQgZGVzaWduYXRvcnMsIGV2ZW4gaWYgdGhleSBhcmUgY29ycmVj
dCwgd2lsbCByZXN1bHQKaW4gcGFyc2luZyBlcnJvcnMuIEFkZCBzdXBwb3J0IGZvciB0aGVzZSB0
d286CgpMb2dpY2FsIFVuaXQgR3JvdXAgKDB4NikKVmVuZG9yIFNwZWNpZmljICgweDApCgpNYXIg
MjAgMTM6Mzc6MzUgaW5pdDEwNy0xOCBtdWx0aXBhdGhbNDUwMTZdOiBwYXJzZV92cGRfcGc4MzoK
aW52YWxpZCBkZXZpY2UgZGVzaWduYXRvciBhdCBvZmZzZXQgODc6IDAxMDYwMDA0Ck1hciAyMCAx
MzozNzozNSBpbml0MTA3LTE4IG11bHRpcGF0aFs0NTAxNl06IHBhcnNlX3ZwZF9wZzgzOgppbnZh
bGlkIGRldmljZSBkZXNpZ25hdG9yIGF0IG9mZnNldCAxMzE6IDAyMDAwMDA1CgpUaGFua3MsCkJy
aWFuCgptd2lsY2s6IGFkZGVkIGRlc2NyaXB0b3IgdHlwZSA3IChNRDUpIGZvciBjb21wbGV0ZW5l
c3MuCgpTaWduZWQtb2ZmLWJ5OiBCcmlhbiBCdW5rZXIgPGJyaWFuQHB1cmVzdG9yYWdlLmNvbT4K
U2lnbmVkLW9mZi1ieTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Ci0tLQogbGlibXVs
dGlwYXRoL2Rpc2NvdmVyeS5jIHwgMTEgKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAxMSBp
bnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL2Rpc2NvdmVyeS5jIGIvbGli
bXVsdGlwYXRoL2Rpc2NvdmVyeS5jCmluZGV4IDNhNWJhMTcuLjY4NjVjZDkgMTAwNjQ0Ci0tLSBh
L2xpYm11bHRpcGF0aC9kaXNjb3ZlcnkuYworKysgYi9saWJtdWx0aXBhdGgvZGlzY292ZXJ5LmMK
QEAgLTEyMTEsNiArMTIxMSwxNyBAQCBwYXJzZV92cGRfcGc4Myhjb25zdCB1bnNpZ25lZCBjaGFy
ICppbiwgc2l6ZV90IGluX2xlbiwKIAkJCWludmFsaWQgPSAoZFszXSA8IDgpOwogCQkJbmV3X3By
aW8gPSAyOwogCQkJYnJlYWs7CisJCWNhc2UgMHg2OgorCQkJLyogTG9naWNhbCBVbml0IEdyb3Vw
ICovCisJCQlpbnZhbGlkID0gKGRbM10gIT0gNCk7CisJCQlicmVhazsKKwkJY2FzZSAweDc6CisJ
CQkvKiBNRDUgbG9naWNhbCB1bml0IGRlc2lnbmF0b3IgKi8KKwkJCWludmFsaWQgPSAoZFszXSAh
PSAxNik7CisJCQlicmVhazsKKwkJY2FzZSAweDA6CisJCQkvKiBWZW5kb3IgU3BlY2lmaWMgKi8K
KwkJCWJyZWFrOwogCQljYXNlIDB4YToKIAkJCWNvbmRsb2coMiwgIiVzOiBVVUlEIGlkZW50aWZp
ZXJzIG5vdCB5ZXQgc3VwcG9ydGVkIiwKIAkJCQlfX2Z1bmNfXyk7Ci0tIAoyLjM5LjIKCg==
--_002_e52c66c71e3a3f25412c86763af8de9fadbfd3c8camelsusecom_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--_002_e52c66c71e3a3f25412c86763af8de9fadbfd3c8camelsusecom_--

