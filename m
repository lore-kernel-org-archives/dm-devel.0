Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB7A7C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 17 Jan 2022 14:01:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-gHY5DsyHNXyAUN21KoafWg-1; Mon, 17 Jan 2022 09:01:29 -0500
X-MC-Unique: gHY5DsyHNXyAUN21KoafWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5639218358F5;
	Mon, 17 Jan 2022 14:01:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DCE5C753FC;
	Mon, 17 Jan 2022 14:01:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CF57E4BB7C;
	Mon, 17 Jan 2022 14:01:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20HE1CZt026001 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 Jan 2022 09:01:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D18754047279; Mon, 17 Jan 2022 14:01:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCC8A4047272
	for <dm-devel@redhat.com>; Mon, 17 Jan 2022 14:01:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE7911C131A4
	for <dm-devel@redhat.com>; Mon, 17 Jan 2022 14:01:11 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
	(mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-445-zpe6TrQANqmxEFV2iVwVmQ-1; Mon, 17 Jan 2022 09:01:09 -0500
X-MC-Unique: zpe6TrQANqmxEFV2iVwVmQ-1
Received: from MW3PR12MB4409.namprd12.prod.outlook.com (2603:10b6:303:2d::23)
	by DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11;
	Mon, 17 Jan 2022 14:01:07 +0000
Received: from MW3PR12MB4409.namprd12.prod.outlook.com
	([fe80::2cad:c7dd:f5d9:289d]) by
	MW3PR12MB4409.namprd12.prod.outlook.com
	([fe80::2cad:c7dd:f5d9:289d%8]) with mapi id 15.20.4888.014;
	Mon, 17 Jan 2022 14:01:07 +0000
Message-ID: <2d937f09-e18c-6a95-bc6c-45bf5d1b1a11@nvidia.com>
Date: Mon, 17 Jan 2022 16:00:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Milan Broz <gmazyland@gmail.com>, Christoph Hellwig <hch@infradead.org>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<9ef95bbc-4eee-4c00-f199-0daa3cdd03ed@gmail.com>
	<YeUgNpFeg9LmW4Um@infradead.org>
	<0461b15e-8ace-5a84-cf9d-504e555b8cab@gmail.com>
From: Israel Rukshin <israelr@nvidia.com>
In-Reply-To: <0461b15e-8ace-5a84-cf9d-504e555b8cab@gmail.com>
X-ClientProxiedBy: FR3P281CA0074.DEUP281.PROD.OUTLOOK.COM
	(2603:10a6:d10:1f::12) To MW3PR12MB4409.namprd12.prod.outlook.com
	(2603:10b6:303:2d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af8ee15c-04e4-4558-a878-08d9d9c1ced6
X-MS-TrafficTypeDiagnostic: DM4PR12MB5072:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB50721DA1973EA17B340745B8DA579@DM4PR12MB5072.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Pq65MSHpGTr7JImnmnZNdJRgu7Y71ypLIYHvTBghHURjR0f6KydOaSDZQ0bT78pNAlXqm58emKvMUeLCy6Ei+IDgPMCuaBh1ci+OdaxzOPqH4lDBEU8YWZmSqbLp6h880SLOX2K6OqHncrmq7ZBWIG6ei9RVJsz3z8Xa0tExsrPZp+ekCsc2q9MDR8V4tJo/fhvacPMd6StGn549dsBLdag4StojWdiNHuq+NeoRQyMM8XEIZR1ZM1hFEmr3JB6lfnvK68vMgeUhXzUAaKr3BcR+b4ciXdAiX7Fvgu9mOS7sCe7yAZ9l03IXEqXRfyyxVsiVvT3ZX3k76nyv2lVZ+dJzcqFZPW7dz1OmjUk9Wx65cHtjlR0/WsKFrUEnT0kK9hDTOZg6CxXXd7WOd4LltguWLKYm+pPXqZBRY7N7INjmGcJjnVGpesLaaR52sKOhMknqpwgKtRqv9cZN86r8Mm9ny3ne5u7vJ/C4NtqC/fK0FSTKyCBuamH1VvZLyVGW2SEMVs1sL90PUCS4HtTsJg9+wwfRBQ1h+s9kpvwCz3MTtuvxFnM1q4ryXOM+YmPphbKQeGCQF8tYBkk6NrYELFH7cqjfgQE3j6BlO+BFBypJPr5NDHdDlc6pju+9FafE5uT6+w6K4IsQvtH5jPrKBYg998wGu3jEqXsHtzU7k+tKS2c482hWfesx3RE9DnW+QVZqZNtMKBk3yfK9uvFSXoYhXU3fT7PBSC5+K8RjsDbDfOE7tkd3mZkUdypYczF9MBXOfb/DKCRqc1Ce7BlROQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW3PR12MB4409.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(53546011)(186003)(6506007)(86362001)(8676002)(55236004)(6512007)(6666004)(83380400001)(38350700002)(31686004)(38100700002)(508600001)(26005)(66556008)(110136005)(52116002)(5660300002)(54906003)(8936002)(2906002)(31696002)(6486002)(316002)(2616005)(66946007)(36756003)(4326008)(66476007)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aSqk5XmUmPXdzVHrnizbWpBLozbRSYezav+dENEmXk50/MpgchhvhVhc5N7u?=
	=?us-ascii?Q?7oRXlig9lzcr6I2iuqn6hLMdNpQhyUC8gXg52LN+6u4tKA7CD/Q2MRvkFx9D?=
	=?us-ascii?Q?0ruUtc6UvpYUc5XBmkn1ekSD7ILM7gboNwsZ7scUslLlPiWgMfHk5iv1lDjs?=
	=?us-ascii?Q?f7BSc4ttZrXHKIStYCppxUuUL9IIC77uQ3r/dAk2Qx+mV/v82Uq9C90iWqGJ?=
	=?us-ascii?Q?GnFtZQdrvzxY1twd77msUDcMNYZ24A0SfbBrTflznrGycj5OaxvzLE8KpbeJ?=
	=?us-ascii?Q?C/wjD4fleY6P9Acaeo4zXfo8jPf0hn16xyPIvrcBIBbFcYeUXh/+3iG9WWgp?=
	=?us-ascii?Q?0KoRhgiKLuFSno8PCk3EUN0GU8N2w0T6w5mf0R0EplIVdlJ4XYf3sNozRsee?=
	=?us-ascii?Q?rOPHMYC20zA45o8gDnwUWu8AghCWMS6ops8n/IM+n1ftmAMQwzqR2xPIMK/s?=
	=?us-ascii?Q?QrBDaBJrDWVjDfwmEhX+SwMlMKP5r169bsT7NJ1p1sgjMu6kduiA9OsR1H1w?=
	=?us-ascii?Q?1uWpff6b7SLtf/y6YPu1CWCGj2FalBri7GEdLpIdRYwRLcYKyIWYLqOgPybi?=
	=?us-ascii?Q?L9NscIDrNAMYx2ETyAxhbB1HGh+1qSKux3zfRl3v7Yo+Lk7EBv7pAkWOmqwq?=
	=?us-ascii?Q?foZ+E0S8YWGIsghaXNiNAXqb/F+pNo6MR6/5MsXrAWl0k+vepF6jQ9IgjRp8?=
	=?us-ascii?Q?HlZaY3jNKkeQqWGOI2MhnYRtaDHpu9GjzRyToG2BJcZdrQ4qXPJAf7kOGDcw?=
	=?us-ascii?Q?T5TY/z2x88tgI9RFFV6kJW2gn/ayl6kbV9diNs9+w4KDxueC/Sy3UE3Lr5sl?=
	=?us-ascii?Q?YTOi28Fyv0HjgGNcWbXqEwClvuFTYVfsGLez6Ywg+BjzYPGnlt5355oer9FQ?=
	=?us-ascii?Q?iFOvd/Q4GDYcj/uZhXzaPJd4OelWCmbQy8gye+niOCPQ/QoOkGjYWr8ovFuP?=
	=?us-ascii?Q?3yzP6J3V75OUZfv8OOLkfqsSt7TdtQqQFQUgNkKutcO4gviKCb//9QwTCDMs?=
	=?us-ascii?Q?QJMxBMeAJZtWzQyGJX2+tMG9ZJKvutKaZUokb4G3BR6XwO5FPDM+rAV5klrZ?=
	=?us-ascii?Q?XBg4G7fCkcDLFBUj7VOTzZEYDmps7SFdfKagJd4ho/K6PNpSeCcmavqdONMS?=
	=?us-ascii?Q?btCem607vkNlTUjj3fB3OMCSQWD66lwIDySswMehmZ2X+xQEE3kq9tJnLN38?=
	=?us-ascii?Q?uBXAN3VCDKMTJiTuzO0BxojtkSqRlsv3RkTCV3haJSObgT9YjJ7K81zOO03f?=
	=?us-ascii?Q?YOidwrFQdn8LywvN2iN+HTH3NBsWg7eLobtsdnF/P1aTTwqtVxgk9YylYQVp?=
	=?us-ascii?Q?3lWOifHTWs6yfpLW8e+mdBJMTmUQ2NfDalt9+o112g499tuiWemzjpBATC7S?=
	=?us-ascii?Q?F8GVGmvI2omwyVelXErw02xJlQSpLKlnqRKliP26f59f4fbmYt03snT/YU5V?=
	=?us-ascii?Q?nNHGfcCLHTEEKrJmNWr6p3j2GkOGWuxBBUIHeh+Tt76Vo0qwa1Yj73h2L0Lh?=
	=?us-ascii?Q?I58n6DpRCBOaKG2ATTKVhRIm6OifWw1f7hDDAedfeiSSW42aXovvX00mMzfN?=
	=?us-ascii?Q?IxI8AaEF4lLWnh4WlccfCvw1NLB0Ls+pcOAB72mZyuvGKxKxEszNd0k8IRYv?=
	=?us-ascii?Q?eqkawquZVLrV+b6lxBnTXkM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af8ee15c-04e4-4558-a878-08d9d9c1ced6
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4409.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2022 14:01:07.5319 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzOMjHft0A8IoEpQRMbwgqSsEQMu1fJBfzSkEtIjkaudVP+TK0VwNjlW9AFkduRXWrxp52Nk5FqAPyAQ0KIpgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5072
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20HE1CZt026001
X-loop: dm-devel@redhat.com
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, dm-devel <dm-devel@redhat.com>,
	Nitzan Carmi <nitzanc@nvidia.com>, Eric Biggers <ebiggers@google.com>
Subject: Re: [dm-devel] [RFC PATCH 0/1] Add inline encryption support for
 dm-crypt
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMS8xNy8yMDIyIDEyOjUwIFBNLCBNaWxhbiBCcm96IHdyb3RlOgo+IE9uIDE3LzAxLzIwMjIg
MDg6NTIsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+PiBPbiBGcmksIEphbiAxNCwgMjAyMiBh
dCAwOTo1MToyMFBNICswMTAwLCBNaWxhbiBCcm96IHdyb3RlOgo+Pj4gSSB0aGluayBkbS1jcnlw
dCBzaG91bGQgc3RheSBhcyBTVyBjcnlwdG8gb25seSAodXNpbmcga2VybmVsIGNyeXB0byAKPj4+
IEFQSSwKPj4+IHNvIEhXIGFjY2VsZXJhdGlvbiBpcyBkb25lIHRocm91Z2ggY3J5cHRvIGRyaXZl
cnMgdGhlcmUpLgo+Pj4KPj4+IEEgY2xlYW5lciBzb2x1dGlvbiBpcyB0byB3cml0ZSBhIG11Y2gg
c2ltcGxlciBuZXcgZG0tY3J5cHQtaW5saW5lIAo+Pj4gdGFyZ2V0LAo+Pj4gd2hpY2ggd2lsbCBp
bXBsZW1lbnQgb25seSBpbmxpbmUgZW5jcnlwdGlvbi4KPj4+IChBbmQgdXNlcnNwYWNlIGNhbiBk
ZWNpZGUgd2hpY2ggdGFyZ2V0IHRvIHVzZS4pCj4+PiBDb2RlIHNob3VsZCBiZSBqdXN0IGFuIGV4
dGVuc2lvbiB0byB0aGUgZG0tbGluZWFyIHRhcmdldCwgbW9zdAo+Pj4gb2YgZG0tY3J5cHQgY29t
cGxleGl0eSBpcyBub3QgbmVlZGVkIGhlcmUuCj4+Cj4+IFdoeSBkbyB3ZSBldmVuIG5lZWQgYSBk
bSB0YXJnZXQgZm9yIHRoaXMgYXMgd2VsbD/CoCBUaGVyZSBzaG91bGQgYmUgbm8KPj4gbmVlZCB0
byBjbG9uZSBvciByZW1hcCBiaW9zLCBzbyBJIHRoaW5rIGhhbWRsaW5nIGlubGluZSBjcnlwdG8g
c2hvdWxkIGJlCj4+IGp1c3QgYSBzbWFsbCBhZGRpdGlvbiB0byB0aGUgY29yZSBibG9jayBsYXll
ci4KPgo+IFdlbGwsIHllcywgdGhhdCB3YXMgbXkgcXVlc3Rpb24gdG9vIDotKQo+Cj4gTWF5YmUg
dGhlcmUgaXMgbmVlZCB0byBoYXZlIHNvbWUgbmV3IHVzZXJzcGFjZSB1dGlsaXR5IHRvIGNvbmZp
Z3VyZSB0aGF0Cj4gYnV0IG90aGVyd2lzZSBJIHRoaW5rIHRoYXQgZm9yIGlubGluZSBlbmNyeXB0
aW9uIGRldmljZSBtYXBwZXIgbGF5ZXIKPiBvbmx5IGluY3JlYXNlcyBjb21wbGV4aXR5IGFuZCBy
ZWR1Y2VzIElPIHBlcmZvcm1hbmNlLgo+ClJlZ2FyZGluZyBwZXJmb3JtYW5jZSBkZWdyYWRhdGlv
biwgSSBhZGRlZCBvbmx5IG9uZSBpZiBjb25kaXRpb24gYXQgdGhlIApkYXRhIHBhdGggKGluc2lk
ZSAjaWZkZWYpLgo+IENvdWxkIGFueW9uZSBlbGFib3JhdGUgd2hhdCBpdCB0aGUgcmVhc29uIGZv
ciBzdWNoIERNIGV4dGVuc2lvbj8KPiBDb21wYXRpYmlsaXR5IHdpdGggZXhpc3RpbmcgZW5jcnlw
dGlvbi9rZXkgbWFuYWdlbWVudCB0b29scyAobGlrZSBMVUtTKT8KPiBFYXN5IHN1cHBvcnQgaW4g
TFZNPyAuLi4KCkRNIGV4dGVuc2lvbiBnaXZlcyB1cyBzZXZlcmFsIGNhcGFiaWxpdGllczoKCjEu
IFVzZSB0aGUgTGludXgga2V5cmluZyBhbmQgb3RoZXIga2V5IG1hbmFnZW1lbnQgdG9vbHMuCgog
wqDCoMKgIC0gSSB1c2VkICJrZXljdGwgcGFkZCB1c2VyIHRlc3Qta2V5IEB1IDwgL3RtcC93cmFw
cGVkX2RlayIgYXQgbXkgdGVzdHMKCjIuIFNwbGl0IGEgc2luZ2xlIGJsb2NrIGRldmljZSBpbnRv
IHNldmVyYWwgRE1zLiBBbGxvdyB1cyB0byB1c2UgYSAKZGlmZmVyZW50IGVuY3J5cHRpb24ga2V5
IGFuZCBlbmNyeXB0aW9uIG1vZGUgcGVyIERNLgoKMy4gUmVwbGFjZSBhIGtleSBkdXJpbmcgSS9P
IGJ5IHVzaW5nICJkbXNldHVwIHN1c3BlbmQgL2Rldi9kbS0wIiBhbmQgCiJkbXNldHVwwqAgcmVz
dW1lIC9kZXYvZG0tMCIuCgo+Cj4gTWlsYW4KCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVs

