Return-Path: <SRS0=iWw/=NJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7573EC4338F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 07:52:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0865C6109E
	for <dm-devel@archiver.kernel.org>; Wed, 18 Aug 2021 07:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0865C6109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-XUWkt6gmPkyBhWC3JLjPGQ-1; Wed, 18 Aug 2021 03:52:26 -0400
X-MC-Unique: XUWkt6gmPkyBhWC3JLjPGQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02D4B6EAF7;
	Wed, 18 Aug 2021 07:52:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A4AC10013D7;
	Wed, 18 Aug 2021 07:52:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4F0664BB7C;
	Wed, 18 Aug 2021 07:52:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17I7qGm9028304 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Aug 2021 03:52:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 26A7B2126C8B; Wed, 18 Aug 2021 07:52:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20288200BFD7
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 07:52:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60AC2101A529
	for <dm-devel@redhat.com>; Wed, 18 Aug 2021 07:52:13 +0000 (UTC)
Received: from esa20.fujitsucc.c3s2.iphmx.com
	(esa20.fujitsucc.c3s2.iphmx.com [216.71.158.65]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-215-zpqeJymiPCeAA8Gz9paFBw-1;
	Wed, 18 Aug 2021 03:52:09 -0400
X-MC-Unique: zpqeJymiPCeAA8Gz9paFBw-1
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="36840440"
X-IronPort-AV: E=Sophos;i="5.84,330,1620658800"; d="scan'208";a="36840440"
Received: from mail-ty1jpn01lp2053.outbound.protection.outlook.com (HELO
	JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.53])
	by ob1.fujitsucc.c3s2.iphmx.com with
	ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 16:52:05 +0900
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com (2603:1096:604:18::16)
	by OSBPR01MB2440.jpnprd01.prod.outlook.com (2603:1096:604:1c::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16;
	Wed, 18 Aug 2021 07:52:01 +0000
Received: from OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::6db8:ebd7:8ee4:62bb]) by
	OSBPR01MB2920.jpnprd01.prod.outlook.com
	([fe80::6db8:ebd7:8ee4:62bb%6]) with mapi id 15.20.4415.024;
	Wed, 18 Aug 2021 07:52:01 +0000
From: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
To: Jane Chu <jane.chu@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Thread-Topic: [PATCH RESEND v6 1/9] pagemap: Introduce ->memory_failure()
Thread-Index: AQHXhSoSnS/qStIblEyff+FzJU/rBqtlt1aAgBDEPoCAAmInAIAABusAgAAV9MA=
Date: Wed, 18 Aug 2021 07:52:01 +0000
Message-ID: <OSBPR01MB2920AD0C7FD02E238D0C387AF4FF9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
	<1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
	<de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com>
	<beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
	<78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
In-Reply-To: <78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com>
Accept-Language: en-US, zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2d6932f-759b-402a-27a1-08d9621d1012
x-ms-traffictypediagnostic: OSBPR01MB2440:
x-microsoft-antispam-prvs: <OSBPR01MB24408F37010CA07023F9080BF4FF9@OSBPR01MB2440.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 7jeu27v+L1+azmocnchPNcGK75Qm52Xx2HtpoIOau6mI3iAhe8ox8S4z/af9Mg1CxMrDj+97xyDKzRSVBWdCZD18DU38Gr5vQ119ATUI4CHDcQWLrJdzN54WFQEP4IfHh75xsakCcppNKoyfrY7/RL1vPVsO0nnJ1m6CNAo5dPtpGcR+vtA2EJBUnG/Q75AGin5SgTje1YxfS4LXAeDAO17Bhavg4wG7rgDrfMZu7FpaE+fj69u/poAum1oKkLpKeEfZ6SPVLUH16UmYr4brO8Ag2xhSWQuQH+hNMapZ/7mcQFLWq7tEGIp32JTweOBIVIHnTISjgXE2zytCwFVpesCt+uALX2XVmR1nyTJBR61DOnadbgQjccD1vGeZlpCHaD6Y0gKb8NcVgccaPR66BHJg3HWYiERw9axFPkHX5CyaTkCEmhobIPa6c6yeregBU0AqAGrWLVmU64gjkRSC3HBBymdRWTmPpRrC7yaoV0bpZLhwvt874yVfAZJkfJw74MkARADPBgfEhl485bJwWS+9e2WzpTLJmoNUm6QTKq3EnQquA7ttPItK3eP9GLIvl0U/HncjQV08ulQioVcFPIEu8eNYQsYiEw2VBKe+PY6dCjs9aQCXpU4b1Bm7dIvapvC/dCyJdJ9Ac+Hj/HhYwXyQEIcdDV71f8A+FI5GwQrRbzHku8Ma/7vaYbj1DVlk00sKDauugRmTCOeek1JOkQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:OSBPR01MB2920.jpnprd01.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(38100700002)(55016002)(83380400001)(85182001)(86362001)(76116006)(66946007)(122000001)(9686003)(66556008)(4326008)(2906002)(186003)(7416002)(52536014)(64756008)(66476007)(66446008)(54906003)(7696005)(508600001)(26005)(8936002)(8676002)(33656002)(6506007)(53546011)(71200400001)(5660300002)(316002)(110136005)(38070700005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3dNbkxvUXpweHJoRXFsclUvazFER1hDdFFoRks3MjlBY2lDSXF3U3JJZjV6?=
	=?utf-8?B?TzI4ejdoaFhMOUxwNlE2eThib2tYcWNwZUlNUXFMTHRIbVlxT05oVnhoTFRY?=
	=?utf-8?B?dFJPaitFU3JsOTdYaW9pRkhDdFdTcW9FMWNhUVo2K0xodXRTWE8zWEt4a1Bw?=
	=?utf-8?B?NXRIWE5CQjRXaGNZRHFvVU1YUzhMcjc4Z25rK0JSTUF2UjJNb0Q2b3JYSmxI?=
	=?utf-8?B?SXVIMjRCTk1MSkpKQllUVS9mUjNtMlQ1bmd2N1FLWlphdmt1U0h4RklabUpE?=
	=?utf-8?B?UVZCMnlyR2czMzI4a2Yya0JyZ1YrYk1IWDFBZTZLY3MyT2xUMXNCWlFvOFJj?=
	=?utf-8?B?eWdLV0k4ZkZIdkl5dDBuR3pnSVg5NDg2cStEd0tmV3c4WVR0eGc0MUoyRjBk?=
	=?utf-8?B?U3FTdkdtbTVJekczYmNLbnU0enNFd3QvZEtqSkVJS1lZQkV1UXF2TlNXdlpG?=
	=?utf-8?B?MFFEQTkycVVHMTMySDQyYS9EWCt0T0VIRXYzNmdSemJKRnhTL3lDZm1HRDBT?=
	=?utf-8?B?ZEF4TjlwL01jajE1QXU5UWJrMW9hZXBuK3RmVmZtOFdXQ0JvK3JmYzlDZisz?=
	=?utf-8?B?WnNWVCs0RnJCZkZDMGhHQUpvVnAzSXVUSkhHL1NOVG51OUV2cHUzR2gzOUxD?=
	=?utf-8?B?dkJtamUrQkJSN0plWEFGTnRxbDRhTU8ybzdEYklFNWxhUGZRS0RjMkFpclQv?=
	=?utf-8?B?MVdrR0F1cVVjWUFTTHRnVm16RlM0eVlOVmZVNzFuVnlEZTdtL1Bqb1UrNmxW?=
	=?utf-8?B?MFlTVGRGcW01ZVFHWWZyR1VKdFhYSEIwaGZrUEFxYkw5Q1lZY2NUZTNXRU51?=
	=?utf-8?B?QVptZUIweU5kaDZXL1ltbzJwNDVUNUI3TUZDbjFSRXRORjZ4N2VDZVZuWnBF?=
	=?utf-8?B?UGFyd1BrUGVrR2hzcXZoMjFZcWlUTDhIWHVyMEJYQUthcENKUU8reEdBRDFj?=
	=?utf-8?B?MGhvSThDMURhWGh4Z0ZXdWxtYkZUYzBKc0RGNlRJR0YwbnJVMDRwcFpYQXpE?=
	=?utf-8?B?SVF2V1owY050d0ZVWGR5eHJzR3FTbVgwU1liZzI4WjdvcFgzSzB5MmxvdTJz?=
	=?utf-8?B?NmZwS0tWVWZySzVvNW0vYjBYSmN1QnpqTE1oZWJXaDhoaHhZc3dSMU1pL1A4?=
	=?utf-8?B?QU41dUNaNytZaDBLYm9HRGtSUHkyazlVNlhPUW4zbE5oM0VUMEhGN0hmd2ZW?=
	=?utf-8?B?ZGJTcVE1ajRNV2VXNCszZTJ3cVFZSVJMNTVuQVpwZmphQkhJd0ZlRmFTS3dk?=
	=?utf-8?B?elJYd1hqMXBvVnJHNVdsN2xUQ0U2OEZFazc0RytCM2htNmFNb2JxdWRXUllP?=
	=?utf-8?B?bzNPRWZPTHdKcVV4TWZmeXBEKzVtRTJoRlJtL0FRdDNGMFhzZ1h1UnhJbW5z?=
	=?utf-8?B?My9oUEVBNUlsS3pjYkE5RnZsbDZ0cVBONjVDZW9ZUkF6WGMrSm1CQ3NKUnY4?=
	=?utf-8?B?QXN0SlVLSFFaM204L1lQYUdLRUxQeGxCYW4zWGMxZ0hlMlJvL1NzNnJpNHlw?=
	=?utf-8?B?aTkxYTA0S3QrTG5USitiSmRydUxnSmZZcUpPckxlZHUxSVpLYXQxTmc0STc4?=
	=?utf-8?B?R2hwWlRqNVVUc0JaYkhyTTNEeGJ5ZlFTRUFiVDZBZUo4NFRQaXpWVG1LbUxK?=
	=?utf-8?B?SFkra2hyQ0VXVWx4MVlmM1NoYjRHNmJHWnlwd0pGZFRwNHJZZ3M2ZS94Y0dO?=
	=?utf-8?B?bk1wdDJmL284RmlQc1h1eU9za1BDazFPZHVhbkE2R2sxd01UQXhQcDhxdk9M?=
	=?utf-8?Q?Gle6mgo2hgKD/8sjdPWVM8rzE3Q1EH3CW7/qFfd?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2920.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2d6932f-759b-402a-27a1-08d9621d1012
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 07:52:01.2105 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: seWqVN6YtlIgfrCNeO5V1QrPyhM6HKt0tiPVVsybjf10CKdLfgG7ba5qWfKV5eyj1/L3PHogW8EY4EzOEWrCGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2440
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from base64 to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17I7qGm9028304
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

Cgo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tCj4gRnJvbTogSmFuZSBDaHUgPGphbmUuY2h1
QG9yYWNsZS5jb20+Cj4gU3ViamVjdDogUmU6IFtQQVRDSCBSRVNFTkQgdjYgMS85XSBwYWdlbWFw
OiBJbnRyb2R1Y2UgLT5tZW1vcnlfZmFpbHVyZSgpCj4gCj4gCj4gT24gOC8xNy8yMDIxIDEwOjQz
IFBNLCBKYW5lIENodSB3cm90ZToKPiA+IE1vcmUgaW5mb3JtYXRpb24gLQo+ID4KPiA+IE9uIDgv
MTYvMjAyMSAxMDoyMCBBTSwgSmFuZSBDaHUgd3JvdGU6Cj4gPj4gSGksIFNoaVlhbmcsCj4gPj4K
PiA+PiBTbyBJIGFwcGxpZWQgdGhlIHY2IHBhdGNoIHNlcmllcyB0byBteSA1LjE0LXJjMyBhcyBp
dCdzIHdoYXQgeW91Cj4gPj4gaW5kaWNhdGVkIGlzIHdoYXQgdjYgd2FzIGJhc2VkIGF0LCBhbmQg
aW5qZWN0ZWQgYSBoYXJkd2FyZSBwb2lzb24uCj4gPj4KPiA+PiBJJ20gc2VlaW5nIHRoZSBzYW1l
IHByb2JsZW0gdGhhdCB3YXMgcmVwb3J0ZWQgYSB3aGlsZSBhZ28gYWZ0ZXIgdGhlCj4gPj4gcG9p
c29uIHdhcyBjb25zdW1lZCAtIGluIHRoZSBTSUdCVVMgcGF5bG9hZCwgdGhlIHNpX2FkZHIgaXMg
bWlzc2luZzoKPiA+Pgo+ID4+ICoqIFNJR0JVUyg3KTogY2Fuam1wPTEsIHdoaWNoc3RlcD0wLCAq
Kgo+ID4+ICoqIHNpX2FkZHIoMHgobmlsKSksIHNpX2xzYigweEMpLCBzaV9jb2RlKDB4NCwgQlVT
X01DRUVSUl9BUikgKioKPiA+Pgo+ID4+IFRoZSBzaV9hZGRyIG91Z2h0IHRvIGJlIDB4N2Y2NTY4
MDAwMDAwIC0gdGhlIHZhZGRyIG9mIHRoZSBmaXJzdCBwYWdlCj4gPj4gaW4gdGhpcyBjYXNlLgo+
ID4KPiA+IFRoZSBmYWlsdXJlIGNhbWUgZnJvbSBoZXJlIDoKPiA+Cj4gPiBbUEFUQ0ggUkVTRU5E
IHY2IDYvOV0geGZzOiBJbXBsZW1lbnQgLT5ub3RpZnlfZmFpbHVyZSgpIGZvciBYRlMKPiA+Cj4g
PiArc3RhdGljIGludAo+ID4gK3hmc19kYXhfbm90aWZ5X2ZhaWx1cmUoCj4gPiAuLi4KPiA+ICvC
oMKgwqAgaWYgKCF4ZnNfc2JfdmVyc2lvbl9oYXNybWFwYnQoJm1wLT5tX3NiKSkgewo+ID4gK8Kg
wqDCoMKgwqDCoMKgIHhmc193YXJuKG1wLCAibm90aWZ5X2ZhaWx1cmUoKSBuZWVkcyBybWFwYnQg
ZW5hYmxlZCEiKTsKPiA+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVPUE5PVFNVUFA7Cj4gPiAr
wqDCoMKgIH0KPiA+Cj4gPiBJIGFtIG5vdCBmYW1pbGlhciB3aXRoIFhGUywgYnV0IEkgaGF2ZSBh
IGZldyBxdWVzdGlvbnMgSSBob3BlIHRvIGdldAo+ID4gYW5zd2VycyAtCj4gPgo+ID4gMSkgV2hh
dCBkb2VzIGl0IHRha2UgYW5kIGNvc3QgdG8gbWFrZQo+ID4gIMKgwqAgeGZzX3NiX3ZlcnNpb25f
aGFzcm1hcGJ0KCZtcC0+bV9zYikgdG8gcmV0dXJuIHRydWU/CgpFbmFibGUgcm1wYWJ0IGZlYXR1
cmUgd2hlbiBtYWtpbmcgeGZzIGZpbGVzeXN0ZW0KICAgYG1rZnMueGZzIC1tIHJtYXBidD0xIC9w
YXRoL3RvL2RldmljZWAKQlRXLCByZWZsaW5rIGlzIGVuYWJsZWQgYnkgZGVmYXVsdC4KCj4gPgo+
ID4gMikgRm9yIGEgcnVubmluZyBlbnZpcm9ubWVudCB0aGF0IGZhaWxzIHRoZSBhYm92ZSBjaGVj
aywgaXMgaXQKPiA+ICDCoMKgIG9rYXkgdG8gbGVhdmUgdGhlIHBvaXNvbiBoYW5kbGUgaW4gbGlt
Ym8gYW5kIHdoeT8KSXQgd2lsbCBmYWxsIGJhY2sgdG8gdGhlIG9sZCBoYW5kbGVyLiAgSSB0aGlu
ayB5b3UgaGF2ZSBhbHJlYWR5IGtub3duIGl0LgoKPiA+Cj4gPiAzKSBJZiB0aGUgYWJvdmUgcmVn
cmVzc2lvbiBpcyBub3QgYWNjZXB0YWJsZSwgYW55IHBvdGVudGlhbCByZW1lZHk/Cj4gCj4gSG93
IGFib3V0IG1vdmluZyB0aGUgY2hlY2sgdG8gcHJpb3IgdG8gdGhlIG5vdGlmaWVyIHJlZ2lzdHJh
dGlvbj8KPiBBbmQgcmVnaXN0ZXIgb25seSBpZiB0aGUgY2hlY2sgaXMgcGFzc2VkPyAgVGhpcyBz
ZWVtcyBiZXR0ZXIgdGhhbiBhbgo+IGFsdGVybmF0aXZlIHdoaWNoIGlzIHRvIGZhbGwgYmFjayB0
byB0aGUgbGVnYWN5IG1lbW9yeV9mYWlsdXJlIGhhbmRsaW5nIGluIGNhc2UKPiB0aGUgZmlsZXN5
c3RlbSByZXR1cm5zIC1FT1BOT1RTVVBQLgoKU291bmRzIGxpa2UgYSBuaWNlIHNvbHV0aW9uLiAg
SSB0aGluayBJIGNhbiBhZGQgYW4gaXNfbm90aWZ5X3N1cHBvcnRlZCgpIGludGVyZmFjZSBpbiBk
YXhfaG9sZGVyX29wcyBhbmQgY2hlY2sgaXQgd2hlbiByZWdpc3RlciBkYXhfaG9sZGVyLgoKLS0K
VGhhbmtzLApSdWFuLgo+IAo+IHRoYW5rcywKPiAtamFuZQo+IAo+ID4KPiA+IHRoYW5rcyEKPiA+
IC1qYW5lCj4gPgo+ID4KPiA+Pgo+ID4+IFNvbWV0aGluZyBpcyBub3QgcmlnaHQuLi4KPiA+Pgo+
ID4+IHRoYW5rcywKPiA+PiAtamFuZQo+ID4+Cj4gPj4KPiA+PiBPbiA4LzUvMjAyMSA2OjE3IFBN
LCBKYW5lIENodSB3cm90ZToKPiA+Pj4gVGhlIGZpbGVzeXN0ZW0gcGFydCBvZiB0aGUgcG1lbSBm
YWlsdXJlIGhhbmRsaW5nIGlzIGF0IG1pbmltdW0gYnVpbHQKPiA+Pj4gb24gUEFHRV9TSVpFIGdy
YW51bGFyaXR5IC0gYW4gaW5oZXJpdGFuY2UgZnJvbSBnZW5lcmFsCj4gPj4+IG1lbW9yeV9mYWls
dXJlIGhhbmRsaW5nLsKgIEhvd2V2ZXIsIHdpdGggSW50ZWwncyBEQ1BNRU0gdGVjaG5vbG9neSwK
PiA+Pj4gdGhlIGVycm9yIGJsYXN0IHJhZGl1cyBpcyBubyBtb3JlIHRoYW4gMjU2Ynl0ZXMsIGFu
ZCBtaWdodCBnZXQKPiA+Pj4gc21hbGxlciB3aXRoIGZ1dHVyZSBoYXJkd2FyZSBnZW5lcmF0aW9u
LCBhbHNvIGFkdmFuY2VkIGF0b21pYyA2NEIgd3JpdGUKPiB0byBjbGVhciB0aGUgcG9pc29uLgo+
ID4+PiBCdXQgSSBkb24ndCBzZWUgYW55IG9mIHRoYXQgY291bGQgYmUgaW5jb3Jwb3JhdGVkIGlu
LCBnaXZlbiB0aGF0IHRoZQo+ID4+PiBmaWxlc3lzdGVtIGlzIG5vdGlmaWVkIGEgY29ycnVwdGlv
biB3aXRoIHBmbiwgcmF0aGVyIHRoYW4gYW4gZXhhY3QKPiA+Pj4gYWRkcmVzcy4KPiA+Pj4KPiA+
Pj4gU28gSSBndWVzcyB0aGlzIHF1ZXN0aW9uIGlzIGFsc28gZm9yIERhbjogaG93IHRvIGF2b2lk
IHVubmVjZXNzYXJpbHkKPiA+Pj4gcmVwYWlyaW5nIGEgUE1EIHJhbmdlIGZvciBhIDI1NkIgY29y
cnVwdCByYW5nZSBnb2luZyBmb3J3YXJkPwo+ID4+Pgo+ID4+PiB0aGFua3MsCj4gPj4+IC1qYW5l
Cj4gPj4+Cj4gPj4+Cj4gPj4+IE9uIDcvMzAvMjAyMSAzOjAxIEFNLCBTaGl5YW5nIFJ1YW4gd3Jv
dGU6Cj4gPj4+PiBXaGVuIG1lbW9yeS1mYWlsdXJlIG9jY3Vycywgd2UgY2FsbCB0aGlzIGZ1bmN0
aW9uIHdoaWNoIGlzCj4gPj4+PiBpbXBsZW1lbnRlZCBieSBlYWNoIGtpbmQgb2YgZGV2aWNlcy7C
oCBGb3IgdGhlIGZzZGF4IGNhc2UsIHBtZW0KPiA+Pj4+IGRldmljZSBkcml2ZXIgaW1wbGVtZW50
cyBpdC7CoCBQbWVtIGRldmljZSBkcml2ZXIgd2lsbCBmaW5kIG91dCB0aGUKPiA+Pj4+IGZpbGVz
eXN0ZW0gaW4gd2hpY2ggdGhlIGNvcnJ1cHRlZCBwYWdlIGxvY2F0ZWQgaW4uwqAgQW5kIGZpbmFs
bHkKPiA+Pj4+IGNhbGwgZmlsZXN5c3RlbSBoYW5kbGVyIHRvIGRlYWwgd2l0aCB0aGlzIGVycm9y
Lgo+ID4+Pj4KPiA+Pj4+IFRoZSBmaWxlc3lzdGVtIHdpbGwgdHJ5IHRvIHJlY292ZXIgdGhlIGNv
cnJ1cHRlZCBkYXRhIGlmIG5lY2Vzc2FyeS4KPiA+Pj4KPiA+Pgo+ID4KCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWw=

