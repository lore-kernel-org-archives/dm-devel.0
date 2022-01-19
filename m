Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A149C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 19 Jan 2022 15:46:42 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-IEmixYy3N1u1IqyEPCeX3Q-1; Wed, 19 Jan 2022 10:46:38 -0500
X-MC-Unique: IEmixYy3N1u1IqyEPCeX3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 495E1A0C1F;
	Wed, 19 Jan 2022 15:46:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B28B77F808;
	Wed, 19 Jan 2022 15:46:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C9B624BB7C;
	Wed, 19 Jan 2022 15:46:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20JFjGBB028350 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 Jan 2022 10:45:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3017DC01784; Wed, 19 Jan 2022 15:45:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B692C15E73
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 15:45:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C1CC3813AEE
	for <dm-devel@redhat.com>; Wed, 19 Jan 2022 15:45:16 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam08on2059.outbound.protection.outlook.com [40.107.100.59])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-473-bxgWiKm2ODCJ8tCzLETXBw-1; Wed, 19 Jan 2022 10:45:14 -0500
X-MC-Unique: bxgWiKm2ODCJ8tCzLETXBw-1
Received: from MW3PR12MB4409.namprd12.prod.outlook.com (2603:10b6:303:2d::23)
	by MW3PR12MB4474.namprd12.prod.outlook.com (2603:10b6:303:2e::7) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7;
	Wed, 19 Jan 2022 15:45:11 +0000
Received: from MW3PR12MB4409.namprd12.prod.outlook.com
	([fe80::2cad:c7dd:f5d9:289d]) by
	MW3PR12MB4409.namprd12.prod.outlook.com
	([fe80::2cad:c7dd:f5d9:289d%8]) with mapi id 15.20.4888.014;
	Wed, 19 Jan 2022 15:45:11 +0000
Message-ID: <11f58116-9bff-dd10-5ba4-626de0c148d8@nvidia.com>
Date: Wed, 19 Jan 2022 17:45:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Eric Biggers <ebiggers@kernel.org>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<YeH+Bv9KlceWbm05@sol.localdomain>
	<ad0f7b35-2f68-ed21-fb14-b6952339a6b8@nvidia.com>
	<Yecc1BemVbBSjEo+@sol.localdomain>
From: Israel Rukshin <israelr@nvidia.com>
In-Reply-To: <Yecc1BemVbBSjEo+@sol.localdomain>
X-ClientProxiedBy: FR3P281CA0058.DEUP281.PROD.OUTLOOK.COM
	(2603:10a6:d10:4b::19) To MW3PR12MB4409.namprd12.prod.outlook.com
	(2603:10b6:303:2d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ae39995-ea01-4972-b0c1-08d9db62ad31
X-MS-TrafficTypeDiagnostic: MW3PR12MB4474:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB4474D82C5D03DC5BF02F79CFDA599@MW3PR12MB4474.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: s3iYRxBuNQgxg6ChozNSX2VVVy8GHG99PlVevar0IwA/jtcgRHNz4Tc5V9JI1bZZat6PWn7By7enqiMYoMWMEKF7eBk+XvuBV6g+xE0Y0koRjOYUFagnK4txUMVXneHVKK3wAYwy2PKAUEX5jrlQSu57C+wW1lIYG23r95+A/c5YBEVqGTgoLWlU8j3N5tSZZEo8Ikm9OeYrmxLXA3npXQ+JXC30i9P9AoUG2aAj0+zt6bzKN3IsSSxDA01sd79lQUf1TRl40jN7790yaZevk+AqpJAGwuPtScMYUDjf4kKnIDVDG/plCtiC74omIhFoJFwOMnoPRc8h31yv93ImzvApZ1slMhErLfwz0T+nqSA5a5DLw0ocr0yxXmO3d9G12YQJnWvsIs5WBy5818Z7ONGv0ESl+mymLM4t2NBETlWDxu17Gnc2o8RJ+hAdIFd3v7u88Qw9Hej7vsyFm/DTMYe989Bm4R50UfQVm9OM75WmxNNyjD0Hgq1l1H6jx/kXUEnMMYOlRf3ibrcfzKPNxQT9QGtvWH+jZ/pLuSM0QZnqjmge+2WnPc7SgoG7NvWUd4sAjFMdEWYpzWtfjSp6UmYkgFzeG7SX/n9UdfgXgdklWQojI3ocIDb4pj84qaWSEXivi2zU0t93Y9anT3O/WsUuQ+jYleTzZiPO/+6/oB8i22i3ILGi/6NV8PV2Lrd4oSM0bOGVVncmibwqgawIf0FiMtk/lRX7Il7rwJz1dNVm3DbEQmScaBYzt3QMWG1bpu6ehsZ3NHE9AVIMHgcXpxiGk02hTymWUjq1wkWgevDhu4JJyuqOEHHMLk5yRQugXDDH52oXkn8yKauGMeQ6ulI9WudrKu7Pc7b4GtSy+AY=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW3PR12MB4409.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(186003)(6916009)(52116002)(2906002)(6506007)(53546011)(5660300002)(966005)(508600001)(4326008)(55236004)(8676002)(26005)(66476007)(8936002)(31686004)(86362001)(83380400001)(6486002)(107886003)(6666004)(2616005)(6512007)(36756003)(54906003)(66556008)(31696002)(316002)(66946007)(38100700002)(38350700002)(45980500001)(43740500002);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xl52ANyh+XHA0UIpKaKIiC3MNXItr5VaEQLpVLvJI0kOn5P9kgy8p+r7ckjG?=
	=?us-ascii?Q?XTW5gtZmwetQZHQAmCcNQ00NgTkRTOOEDI8bC1sAr+7vDYK95m1olwVj/DF3?=
	=?us-ascii?Q?0pRAedPEC+EXO5LRZU+w+XreclYUIXHXTfKIQ7c4eZ+vV1CaPbeG639E4beO?=
	=?us-ascii?Q?/kVralulcxcz24THigJn0USyHTUFOTBHW/SBlh3v3z/qjqh29t1Z5pHw4k8v?=
	=?us-ascii?Q?aKE44S5o0aSi1BxCbkDWMZOp3FMXx4Uqeb1TMJCtm3Sz+du65TP5el5d5ZtR?=
	=?us-ascii?Q?f+H9gL05hEw0v1UndOhvdA0Jl4XO6sO3PN3x8sHHTUXDraAi6Bpc75BGV0Yt?=
	=?us-ascii?Q?A8GydpEo2M6rRou3keok2BQLHEyxvgx0GY7l8+rvhQhG8SQCGxtobVPN6U1Z?=
	=?us-ascii?Q?eYcQUi3YYLmcaS+YM/DSUqwXFJnw/4x9hgN4XuK5NPQP3cYrcOt95pLd5ecm?=
	=?us-ascii?Q?1TImeUELQhu7uGJxpqrfLclVxjR7fZkZoUVqmmYMP9Smkqs9vx0Ko0h4ssVb?=
	=?us-ascii?Q?oGH7Hoxui3spk2x3cD5bgG8Vl8Qqzb7LjvhMhXbqeONzPyAM2lBlT48P6eB7?=
	=?us-ascii?Q?UAb7pFADeHUyXDJQ1q9n3zPaMm5bs819ppsIF4N+FXycuEfYTIzruh9sP7qk?=
	=?us-ascii?Q?oPfZ5waDZ0C9jB36LzwjY1tqtGcZdADjnG8/8RxLnDMv4z5i49t6T43T8Prz?=
	=?us-ascii?Q?10UxhpPfekYgMyrDeBWEs+D1+/Gkah7l8m35j+Qb3APMFFkxGJcpxz5pyoMp?=
	=?us-ascii?Q?RnYDW1XkztHQ4TxPDuu7kwcBRjNBRmvIY7XxbbNot8JySHJe84pzYUliVxjJ?=
	=?us-ascii?Q?Jn2xN9qU1tVHhiw5hKCiGhE0iKKD7eL6vaUyWIgqBk/rEYuBZN1kxD5hODWA?=
	=?us-ascii?Q?rF1KSkEkLYeLRbZn8rSaRi4rUl4bUSN+0EMam8WwQYkM5oHFLY9gqIc92Mj6?=
	=?us-ascii?Q?PfusrgRN5HCBXO72GvftZtRFUUWNnY7OIDDrwWkDIf/+b3WTsSUy3cnFo0La?=
	=?us-ascii?Q?/lX4Nqtn7NKk1Gmf7TXT1B4VgOl1FKz8AEbveuBIhfsYjJudpCK2srFtEXbV?=
	=?us-ascii?Q?ffGS8VCqtCP88mpnbAXP+1GiVKTxUphfLvgRi1I18lzwv4J4xBISwIfNN9tr?=
	=?us-ascii?Q?n7fEWC6Yxnhv4hE3cCmnwYZqeml2vooq9B6Kp833ol+vSP7YUSzQRcn+yK2E?=
	=?us-ascii?Q?Zod+iUv78yKGxozWBzjhVcw6+Ot23l3PCUeSSug/UPBJumB5bVX0E/NRxd7D?=
	=?us-ascii?Q?S9G+A+E9FjVJNQEr0BKoy0wy1th5l21R7DFeNsaWtxZQanfqWGYLp8KjZ7vt?=
	=?us-ascii?Q?B1tTb2H14HvNxomc+As4nUrVK/nYmsYQfnhmghTO/rNAu/8SQV2+TnEVkLaL?=
	=?us-ascii?Q?kPqpcPZKOChKKsNU6Hx0geWlD7ywUKj/n0d5BB33HUumcAm0ujYBWZMdGhfs?=
	=?us-ascii?Q?904vCMrSMFmQEIO8i1HVkFRIDMDMAbCKlHzA8pT2aebGwwmWmJJhGIj8fYcI?=
	=?us-ascii?Q?+7WIKyeQMTrbr3Hm0gvfGicNhS/w3CHova3HwIu8WSRxheJIQjZyq1QPd8ql?=
	=?us-ascii?Q?+VEMvAm0O+HJJKR8ViPBdmf1TVs5e+g6ABJs8A1+9lNnIPBr3DD6NDQy3w/T?=
	=?us-ascii?Q?iynx8i7e/yOCfZnbS3ov0fQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae39995-ea01-4972-b0c1-08d9db62ad31
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4409.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 15:45:11.2858 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dk36QPmxlbLjhZAcGyQul1iYA/4ce4MkcwwuP7a0xS54fsejXFTYAKs7UtdbG+EY23DdqT1eLheRQHdjNk1caA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4474
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20JFjGBB028350
X-loop: dm-devel@redhat.com
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, dm-devel <dm-devel@redhat.com>,
	Nitzan Carmi <nitzanc@nvidia.com>, oren@nvidia.com
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMS8xOC8yMDIyIDEwOjAyIFBNLCBFcmljIEJpZ2dlcnMgd3JvdGU6Cj4gT24gU3VuLCBKYW4g
MTYsIDIwMjIgYXQgMTI6MTU6MjJQTSArMDIwMCwgSXNyYWVsIFJ1a3NoaW4gd3JvdGU6Cj4+IFll
cywgSSBpbXBsZW1lbnRlZCB5b3VyIGlubGluZSBjYWxsYmFja3MgYXQgbnZtZS1yZG1hIGRyaXZl
ci4gVGhlIGRyaXZlcgo+PiBjb21tdW5pY2F0ZXMgd2l0aAo+Pgo+PiB0aGUgSFcgdmlhIGEgZ2Vu
ZXJhbCBpYl92ZXJicyBsYXllciwgc28gSSBoYWQgdG8gZXh0ZW5kIGliX3ZlcmJzIGFuZCBtbHg1
X2liCj4+IGRyaXZlcnMuIFRob3NlCj4+Cj4+IHBhdGNoZXMgYXJlIGF0IGludGVybmFsIHJldmll
dyBhbmQgSSB3aWxsIHNlbmQgdGhlIG52bWUtcmRtYSBwYXRjaGVzCj4+IGFmdGVyd2FyZHMuCj4+
Cj4+PiBDYW4geW91IGFsc28gZWxhYm9yYXRlIG9uIGhvdyB3cmFwcGVkIGtleXMgd29yayBpbiB5
b3VyIGNhc2U/ICBJbiBwYXJ0aWN1bGFyLAo+Pj4gYXJlIHRoZXkgY29tcGF0aWJsZSB3aXRoIHRo
ZSB3aG9sZSBkZXNpZ24gd2hpY2ggSSd2ZSBkb2N1bWVudGVkIGluIGRldGFpbCBpbiBteQo+Pj4g
cGF0Y2hzZXQ/ICBUaGF0IHdvdWxkIGluY2x1ZGUgaW1wbGVtZW50aW5nIHRoZSAtPmltcG9ydF9r
ZXksIC0+Z2VuZXJhdGVfa2V5LAo+Pj4gLT5wcmVwYXJlX2tleSwgYW5kIC0+ZGVyaXZlX3N3X3Nl
Y3JldCBvcGVyYXRpb25zLiAgQWxsIHRoZSBkaWZmZXJlbnQgcGFydHMgYXJlCj4+PiBpbXBvcnRh
bnQuICBJZiBzb21ldGhpbmcgbmVlZHMgdG8gYmUgb3B0aW9uYWwsIHRoYXQncyBzb21ldGhpbmcg
SSBjYW4gY29uc2lkZXIKPj4+IGluY29ycG9yYXRpbmcgaW50byB0aGUgZGVzaWduLCBidXQgaXQg
d291bGQgcmVzdHJpY3QgdGhlIHVzZSBjYXNlcy4KPj4gSW4gbXkgY2FzZSwgdGhlIHVzZXIgc2hv
dWxkIGNyZWF0ZSB3cmFwcGVkIGtleXMgYnkgaGltc2VsZiB2aWEgYSB1c2VyIHNwYWNlCj4+IHRv
b2wgYmFzZWQKPj4KPj4gb24gb3BlbnNzbCBsaWJyYXJ5LiBUaGVyZWZvcmUsIHRoZSAtPmltcG9y
dF9rZXksIC0+Z2VuZXJhdGVfa2V5IGFuZAo+PiAtPnByZXBhcmVfa2V5IGFyZQo+Pgo+PiBub3Qg
bmVjZXNzYXJ5IGF0IG15IGNhc2UuIFJlZ2FyZGluZyAtPmRlcml2ZV9zd19zZWNyZXQsIGl0IGlz
IG5vdCBzdXBwb3J0ZWQKPj4gcmlnaHQgbm93IGJ5Cj4+Cj4+IENvbm5lY3RYNiBEWCBmaXJtd2Fy
ZSAod2UgcGxhbiB0byBhZGQgc3VwcG9ydCBmb3IgdGhpcykuwqAgVG8gdGVzdCBmc2NyeXB0Cj4+
IHdpdGggd3JhcHBlZCBrZXlzLAo+Pgo+PiBhIHRlbXBvcmFyeSBXQSB3YXMgYWRkZWQgdG8gdGhl
IC0+ZGVyaXZlX3N3X3NlY3JldCBhdCBudm1lLXJkbWEgZHJpdmVyLiBUaGUKPj4gb3RoZXIgY2Fs
bGJhY2tzCj4+Cj4+IHlvdSBtZW50aW9uZWQgd2VyZSBsZWZ0IGVtcHR5Lgo+IFNvLCB3aGF0IHdl
IG5lZWQgdG8gdGhpbmsgYWJvdXQgaXMgaG93IHVzZXJzcGFjZSBpcyBleHBlY3RlZCB0byBhY3R1
YWxseSB1c2UgYW5kCj4gdGVzdCB0aGUgaGFyZHdhcmUtd3JhcHBlZCBrZXlzIGZlYXR1cmUuCj4K
PiBNeSBwYXRjaHNldCBwcm9wb3NlZCBhIGRlc2lnbiB3aGVyZSBpZiBhIGJsb2NrIGRldmljZSBk
ZWNsYXJlcyBzdXBwb3J0IGZvcgo+IGhhcmR3YXJlLXdyYXBwZWQga2V5cywgdGhlbiB0aGUgQkxL
Q1JZUFRPQ1JFQVRFS0VZIGFuZCBCTEtDUllQVE9QUkVQQVJFS0VZCj4gaW9jdGxzIGFyZSBhdmFp
bGFibGUuCj4KPiBBZGRpdGlvbmFsbHksIGEgc3BlY2lmaWMgaGFyZHdhcmUtaW50ZXJuYWwga2V5
IGhpZXJhcmNoeSBhbmQgS0RGIGlzIGFzc3VtZWQgKGR1ZQo+IHRvIHRoZSBuZWVkIHRvIHN1cHBv
cnQgLT5kZXJpdmVfc3dfc2VjcmV0KS4gIFdoaWxlIHVzZXJzcGFjZSBkb2Vzbid0IG5lZWQgdG8K
PiBrbm93IHRoZXNlIGRldGFpbHMgdG8gdXNlIHRoZSBmZWF0dXJlIG5vcm1hbGx5LCB0aGV5ICpt
dXN0KiBiZSBrbm93biBpbiBvcmRlciB0bwo+IHRlc3QgdGhhdCBpdCdzIGFjdHVhbGx5IHdvcmtp
bmcgY29ycmVjdGx5Lgo+Cj4gSWYgd2Ugd2VyZSB0byBzdXBwb3J0IHZhcmlhbnRzIG9mIHRoZSBm
ZWF0dXJlLCBzdWNoIGFzOgo+Cj4gKiBIYXJkd2FyZS13cmFwcGVkIGtleXMgbXVzdCBiZSBjcmVh
dGVkL3ByZXBhcmVkIGluIHNvbWUgd2F5IG90aGVyIHRoYW4KPiAgICBCTEtDUllQVE9DUkVBVEVL
RVkgYW5kIEJMS0NSWVBUT1BSRVBBUkVLRVkuICAoQ291bGQgeW91IGVsYWJvcmF0ZSBvbgo+ICAg
IHdoYXQgdGhpcyB3YXkgYWN0dWFsbHkgaXMsIGluIHlvdXIgY2FzZT8pCgpXZSBjdXJyZW50bHkg
YXNzdW1lIHRoYXQgdGhlIHNhbWUgZW50aXR5IHRoYXQgY29uZmlndXJlZCB0aGUgZGV2aWNlIHRo
ZSBmaXJzdCB0aW1lCmFuZCBwdXNoZWQgdGhlIGZpcnN0IHdyYXBwaW5nIGtleSB0byBpdCBpcyBh
YmxlIHRvIHByb2R1Y2UgREVLcyAoRGF0YSBFbmNyeXB0aW9uIGtleXMpCndoaWNoIGFyZSBwYXNz
ZWQgdG8gdGhlIHNvZnR3YXJlIGluIGEgd3JhcHBlZCBmb3JtLCB0byBiZSBsb2FkZWQgdG8gdGhh
dCBwYXJ0aWN1bGFyCmRldmljZSBhcy1pcy4KQXQgb3VyIGNhc2UsIHdlIHByb2R1Y2UgdGhlIHdy
YXBwZWQgREVLcyBhdCBhIGRpZmZlcmVudCBtYWNoaW5lIHdoaWNoIG1heSBiZSBwbGFjZWQKYXQg
YSBtb3JlIHNlY3VyZWQgZW52aXJvbm1lbnQuCgo+Cj4gKiBIYXJkd2FyZSdzIGtleSBoaWVyYXJj
aHkgb3IgS0RGIGlzIGRpZmZlcmVudCwgc28gdXNlcnNwYWNlIG11c3QgZG8gc29tZXRoaW5nCj4g
ICAgZWxzZSB3aGVuIHZlcmlmeWluZyB0aGUgb24tZGlzayBjaXBoZXJ0ZXh0Lgo+Cj4gLi4uIHRo
ZW4gd2Ugd291bGQgbmVlZCB0byBwcmVjaXNlbHkgc3BlY2lmeSB0aGVzZSBvdGhlciB2YXJpYW50
cywgYW5kIGRlZmluZSBhCj4gd2F5IGZvciB1c2Vyc3BhY2UgdG8gZGlzY292ZXIgd2hhdCBpdCBz
aG91bGQgZG8uCj4KPiBJbiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjExMjA4MDEzNTM0
LjEzNjU5MC0xLWViaWdnZXJzQGtlcm5lbC5vcmcsIEknbQo+IHByb3Bvc2luZyBleHBvc2luZyB0
aGUgY3J5cHRvIGNhcGFiaWxpdGllcyBvZiBibG9jayBkZXZpY2VzIHZpYSBzeXNmcy4gIFRoYXQK
PiBjb3VsZCBsZWFkIHRvIGEgcGFydGlhbCBzb2x1dGlvbiwgZS5nLiB0aGUga2VybmVsIGNvdWxk
IHByb3ZpZGUgYSBmaWxlCj4KPiAJL3N5cy9ibG9jay8kZGlzay9xdWV1ZS9jcnlwdG8vd3JhcHBl
ZF9rZXlzX3ZhcmlhbnQKPgo+IC4uLiB3aGljaCB3b3VsZCBhbGxvdyB1c2Vyc3BhY2UgdG8gZGlz
Y292ZXIgdGhlIHN1cHBvcnRlZCB2YXJpYW50IG9mCj4gaGFyZHdhcmUtd3JhcHBlZCBrZXlzLiAg
SSB3YXMgcmVhbGx5IGhvcGluZyB0aGF0IG9uZSB2YXJpYW50IGNvdWxkIGJlCj4gc3RhbmRhcmRp
emVkLCBidXQgdGhhdCBpcyBvbmUgcG9zc2liaWxpdHkuCj4KPj4+IEFsc28sIHdpbGwgeW91ciBk
cml2ZXIgb25seSBzdXBwb3J0IHdyYXBwZWQga2V5cywgb3Igd2lsbCBpdCBzdXBwb3J0IHN0YW5k
YXJkCj4+PiBrZXlzIHRvbz8KPj4gT3VyIGRyaXZlciB3aWxsIHN1cHBvcnQgYm90aCBtb2Rlcy4g
VGhlIGZpcnN0IHN0ZXAgaXMgdG8gc3VwcG9ydCB0aGUKPj4gc3RhbmRhcmQga2V5cywgYmVjYXVz
ZSBvZgo+IE9rYXksIGdyZWF0LiAgSWYgeW91J3JlIGFkZGluZyBpbmxpbmUgZW5jcnlwdGlvbiBz
dXBwb3J0IHRvIGRtLWNyeXB0IChvciB0bwo+IGRtLWlubGluZS1jcnlwdCBvciB0byB0aGUgYmxv
Y2sgbGF5ZXIsIGRlcGVuZGluZyBvbiB3aGF0IHBlb3BsZSBkZWNpZGUgaXMgdGhlCj4gYmVzdCBh
cHByb2FjaCksIHBlcmhhcHMgeW91IHNob3VsZCBzdGFydCB3aXRoIHN0YW5kYXJkIGtleXMgb25s
eSwgdG8gYXZvaWQgYQo+IGRlcGVuZGVuY3kgb24gdGhlIGhhcmR3YXJlLXdyYXBwZWQga2V5cyBm
ZWF0dXJlIHdoaWNoIGlzIHN0aWxsIGJlaW5nIHdvcmtlZCBvbj8KWWVzLCBJIHdpbGwgZG8gaXQu
Cj4KPj4gdGhlIGdhcCBJIG1lbnRpb25lZCBhYm92ZS4gQXMgSSB1bmRlcnN0YW5kLCAtPmRlcml2
ZV9zd19zZWNyZXQgaXMgbm90IG5lZWRlZAo+PiBmb3IgZG0tY3J5cHQuCj4+Cj4+IElzIHRoYXQg
cmlnaHQ/Cj4gVGhhdCdzIGNvcnJlY3QuICBUaGUgbGFyZ2VyIGlzc3VlIGlzIHRoYXQgaWYgeW91
IGRvbid0IHN1cHBvcnQKPiAtPmRlcml2ZV9zd19zZWNyZXQsIHRoZW4gaXQncyBsaWtlbHkgdGhh
dCB5b3VyIGtleSBoaWVyYXJjaHkgaXMgZGlmZmVyZW50Cj4gKHByb2JhYmx5IHlvdSBkb24ndCBo
YXZlIGEgImhpZXJhcmNoeSIsIGJ1dCByYXRoZXIganVzdCBvbmUga2V5KSwgd2hpY2ggd291bGQK
PiBpbXBseSB0aGF0IHRoZSBmZWF0dXJlIG5lZWRzIHRvIGJlIHRlc3RlZCBkaWZmZXJlbnRseS4K
V2UgcGxhbiB0byBzdXBwb3J0IGFsc28gLT5kZXJpdmVfc3dfc2VjcmV0Lgo+Cj4gQXMgcGVyIHRo
ZSBhYm92ZSwgdGhpcyBjb3VsZCBiZSBhY2NvdW50ZWQgZm9yIGluIHRoZSBkZXNpZ24gYnkgYWxs
b3dpbmcgbXVsdGlwbGUKPiB2YXJpYW50cyBvZiB3cmFwcGVkIGtleXMuICBPZiBjb3Vyc2UsIHRo
YXQgd291bGQgYWRkIGNvbXBsZXhpdHkuCj4KPiAtIEVyaWMKCgotLQpkbS1kZXZlbCBtYWlsaW5n
IGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWls
bWFuL2xpc3RpbmZvL2RtLWRldmVs

