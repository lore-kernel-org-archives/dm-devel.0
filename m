Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD288C433F5
	for <dm-devel@archiver.kernel.org>; Sun, 16 Jan 2022 10:16:01 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-BHVbA14QOJq1oE9IucAZ3w-1; Sun, 16 Jan 2022 05:15:56 -0500
X-MC-Unique: BHVbA14QOJq1oE9IucAZ3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D706A18397A7;
	Sun, 16 Jan 2022 10:15:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BAFC21059587;
	Sun, 16 Jan 2022 10:15:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B8B5D4BB7C;
	Sun, 16 Jan 2022 10:15:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20GAFhVA007716 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 16 Jan 2022 05:15:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 096D540CFD14; Sun, 16 Jan 2022 10:15:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02E0B40CFD0E
	for <dm-devel@redhat.com>; Sun, 16 Jan 2022 10:15:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9392811E76
	for <dm-devel@redhat.com>; Sun, 16 Jan 2022 10:15:42 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com
	(mail-dm6nam08on2055.outbound.protection.outlook.com [40.107.102.55])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-468-jwSrO9-iMk2YFEo17PhB-Q-1; Sun, 16 Jan 2022 05:15:40 -0500
X-MC-Unique: jwSrO9-iMk2YFEo17PhB-Q-1
Received: from MW3PR12MB4409.namprd12.prod.outlook.com (2603:10b6:303:2d::23)
	by BN9PR12MB5225.namprd12.prod.outlook.com (2603:10b6:408:11e::8)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11;
	Sun, 16 Jan 2022 10:15:38 +0000
Received: from MW3PR12MB4409.namprd12.prod.outlook.com
	([fe80::2cad:c7dd:f5d9:289d]) by
	MW3PR12MB4409.namprd12.prod.outlook.com
	([fe80::2cad:c7dd:f5d9:289d%8]) with mapi id 15.20.4888.013;
	Sun, 16 Jan 2022 10:15:38 +0000
Message-ID: <ad0f7b35-2f68-ed21-fb14-b6952339a6b8@nvidia.com>
Date: Sun, 16 Jan 2022 12:15:22 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
	Thunderbird/91.5.0
To: Eric Biggers <ebiggers@kernel.org>
References: <1642097341-6521-1-git-send-email-israelr@nvidia.com>
	<YeH+Bv9KlceWbm05@sol.localdomain>
From: Israel Rukshin <israelr@nvidia.com>
In-Reply-To: <YeH+Bv9KlceWbm05@sol.localdomain>
X-ClientProxiedBy: FR3P281CA0005.DEUP281.PROD.OUTLOOK.COM
	(2603:10a6:d10:1d::19) To MW3PR12MB4409.namprd12.prod.outlook.com
	(2603:10b6:303:2d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e1dd2e8-eb54-4ae3-1e6b-08d9d8d92430
X-MS-TrafficTypeDiagnostic: BN9PR12MB5225:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5225BD5A55DA9D60F5F743ACDA569@BN9PR12MB5225.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: qsx0NOnTP7krbcsBaT12mlYKaxWQMhmj5LMFASWC9tkWR4mOnUirWf6/gJMtJR6ZXk4EycBrUfWwMfGWeiIc20ndIx+RP/WKmE+Qx+qnt1Xp+GT4hjU08xe0jQ3+FFKDuPK0iv2lO1uo8gDm3oX1gvJ7UDLBNT842NKvIm4V2vtrZgPSmlc6RR73zQpknZy4Srji0v8f3FiewwQbVpfMvhgeOzOxNCz94WPzcz5sB/U1+J9vzNP6Bg5CXl/MBeZAt4zqqcMOGaGHuUeqMQLt7N4Vy36yrMOQUdI2MsxNfDka7HdNJU4v3FV90MmR33h8fgf012+mTEjowGgDKvHkbW36+j0vKTUl0/xQfv7NgJgfHbK0nSDSb/Uhr0iJxLpOFnSYdQs8bXSHzcpfpuye4Nd8urZ6SsL/Se6w3FxyB6WAjdhh/glB6fdtA5XmNfkzae3qKFh7QiTSe1yIYXLDVy7AFy37+Y50o93PNmtJKyXl13fr6atwlr8J6yNSm3yR6TBYSAJ2l74y1SHU06FJi5nYZpbhNd5pn+WNtUycppgpvSJn2IAedmCcc19sWsohPegscoQKFW7TxqnMURIx9YAvDzyV4sftI9M/jyfwhu4N59w2TX4NaXi9WgrtdZUiQPtTQqQQconAKZHuW3yxwIMFFgHKnYJOj+FTOCjw7vyiV2r8zhbZGwTcDy59JmcSq9DhKUoEKeevBvfXuMG2DKyHvAPxdX4lqH7626jyzQSXYmRVexhGLEUip2YXIgtnptOmi3Nm23NO6T4AWhvVxeVq7HAoUKqF/q6bq6fTf0TfEVs6pB7OsfGYseLO/SK1I17NnHN4gMqVeQagObHh9vhoKs3VUuRNkO/ixV6luc/Bl9VzHx9mYgIcyVvD9cURUIYtsp0v2jn0frBidZrJng==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:MW3PR12MB4409.namprd12.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(6506007)(52116002)(53546011)(66946007)(38350700002)(66556008)(66476007)(2906002)(107886003)(6512007)(6916009)(508600001)(6666004)(2616005)(86362001)(38100700002)(4326008)(186003)(55236004)(8936002)(5660300002)(54906003)(26005)(316002)(31686004)(36756003)(6486002)(966005)(83380400001)(31696002)(8676002)(43740500002)(45980500001);
	DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FVq6nPyZBioiuYnjuoy8Qfh4yb2CpzOqeYCli3to/qRDhH4Nl3zBWy76ttsk?=
	=?us-ascii?Q?dwpXY2hDi0z/sNgThjb/xT1WXppZgqp8n8iczstKqqUog3rKguQeSlzjPvZn?=
	=?us-ascii?Q?r4DWDupoJa9CdLbAV693ObA1WtwkNOhAcMcOvsP9Ho3gbx5AOQsNJfLaRLY6?=
	=?us-ascii?Q?mJeDzAc352K3LCKh4G7Aa7hLp3LtIwlientHZ5MQX4Jm7jdgaVmAQZdHempI?=
	=?us-ascii?Q?TlhFYMf+u5yO2Bxikx7au+UcSqu3PQwvFa/jPgnk1S+H2XsC0wJzJL5BaAHV?=
	=?us-ascii?Q?+nkG8A3p4g9oGgulh0MdGMp3ma9t2WN0wosGXwkubcIHD06sOjZ/LdpNEz/p?=
	=?us-ascii?Q?2aa68usuNdySW96DRTt2k2zLPhCFmP3hCiDCW15wQeWY1TLKKp4IBI4JW0vU?=
	=?us-ascii?Q?PNDSV12Q8kdL1pyvn7wq7cBkZnRzOo+eJxd6wgt+y2cLWgSGIVjYsGrE14lu?=
	=?us-ascii?Q?LtHP+TOhZ+zUmREkrOy2TUmUniyKZ5fvikYKeBU+Af8YNpchhFi9HpqCzaoG?=
	=?us-ascii?Q?QoQjPSA3jPuyijwHM4zpI6JPoDeWPdws52JpSC8NksrD+kjBADdgQ7Oim8Vh?=
	=?us-ascii?Q?xLJZnKZZTJoy48c7XBzlfz4sXYb9a9ZaZG8/56gavpGMCtgk666NRcK+z4av?=
	=?us-ascii?Q?R9l2ZP/ycLy6MtRFJvWJXJSNRpmy9S/Jdo9nM46MdrREGiomhKEicXEc6e6R?=
	=?us-ascii?Q?atenuaFgvr3zyazI1jaumLGN2ZT0FOv+j1uwXkJihQomZj1dHm1NoM7VUhVX?=
	=?us-ascii?Q?Ig6QjgtdS/WlxEVa8rSS+/dkyqOq0NWmXSnN8lO9CVUhKd6JEi2yKJ55qkz8?=
	=?us-ascii?Q?ptptCCbOaDji38vi8O7u8as01pvSwOaFoOBNSbWMcE+7JQuaLQGDxLeWpePc?=
	=?us-ascii?Q?pz+6o4xrTgxxbUHV/7bNDXfec5INLVh+munuYiBXCbu1s/SbaRerJezNxAVP?=
	=?us-ascii?Q?THKd7QVUpHwUb5JsCp2NiLT1J7kHT/JME/eZZVtPvKIl2fip8HofuaZwBRtj?=
	=?us-ascii?Q?hD07JPB8S7OWQ1B3Djf/fO0n4Kp1QnGrAE1Q+DSduCTQ/DLqDbwop0yldx8F?=
	=?us-ascii?Q?n6HFdnjlUDkGX1avR1gY2wKPeZ4II/rbM4pcYVg7pgQDOIg9SMZVLWFrikhf?=
	=?us-ascii?Q?LjGQvqxYQI9KnIINl7F/3S4AXLXQvxA02qTVJsiziro+KN0+riDCjSg/APSJ?=
	=?us-ascii?Q?S7vlwj/vo+aO8jCJsxj9Fxyh0Gn+YZXsSmXiJegbil6s8qGsuVtpbAUNd8td?=
	=?us-ascii?Q?uDbe61p0S6eHmUnDPm/aK3gO56jqbbBi/BACECHoC/DFcJBV7nljZnNMHID9?=
	=?us-ascii?Q?ui0G90zhXDTuwxg9ttW39SWnH8nuunMhKEIkkOwaLd01AKwWFH8YX04kecW/?=
	=?us-ascii?Q?cmROdfCdBwlb5K9RhNcS88xTDGRXyxUZTa1KLnvtaEXlM0YCYW2AybmNh7Go?=
	=?us-ascii?Q?qXrl6CSEk7r3aHl+e9qAU65QgfGFgLvKdZawrnBtL0fbmyqW5klAy7KNHCOy?=
	=?us-ascii?Q?iFctS17zupZjQ2irP24G7mNMfmmaRR1ALOTv5G5+TGqVXgYynauEBx6Ha8px?=
	=?us-ascii?Q?szktZ/zcHbIB4fJanLdCRmHWydYx9t0M5VtkqMOs3VrzISB7VNxXr9fXM2Ga?=
	=?us-ascii?Q?S6SwxaOGOJNQ09zE6ILqHTk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e1dd2e8-eb54-4ae3-1e6b-08d9d8d92430
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4409.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2022 10:15:37.8938 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OA6AeAGRN3eQ8kuynYrO4LEcW3TGAUhvsT2HM9ytYftrAMmoCvUAdS3YKYu/Q9iSe4n+SVHSTiibyM6yDBHwyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5225
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20GAFhVA007716
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGkgRXJpYywKCk9uIDEvMTUvMjAyMiAxMjo0OSBBTSwgRXJpYyBCaWdnZXJzIHdyb3RlOgo+IEhp
IElzcmFlbCwKPgo+IE9uIFRodSwgSmFuIDEzLCAyMDIyIGF0IDA4OjA5OjAwUE0gKzAyMDAsIElz
cmFlbCBSdWtzaGluIHdyb3RlOgo+PiBIaSwKPj4KPj4gSSBhbSB3b3JraW5nIHRvIGFkZCBzdXBw
b3J0IGZvciBpbmxpbmUgZW5jcnlwdGlvbi9kZWNyeXB0aW9uCj4+IGF0IHN0b3JhZ2UgcHJvdG9j
b2xzIGxpa2UgbnZtZiBvdmVyIFJETUEuIFRoZSBIVyB0aGF0IEkgYW0KPj4gd29ya2luZyB3aXRo
IGlzIENvbm5lY1gtNiBEeCwgd2hpY2ggc3VwcG9ydHMgaW5saW5lIGNyeXB0bwo+PiBhbmQgY2Fu
IHNlbmQgdGhlIGRhdGEgb24gdGhlIGZhYnJpYyBhdCB0aGUgc2FtZSB0aW1lLgo+Pgo+PiBUaGlz
IHBhdGNoc2V0IGlzIGJhc2VkIG9uIHY1LjE2LXJjNCB3aXRoIEVyaWMgQmlnZ2VycyBwYXRjaGVz
Cj4+IG9mIHRoZSBIVyB3cmFwcGVkIGtleXMuCj4+IEl0IGNhbiBiZSByZXRyaWV2ZWQgZnJvbSBi
cmFuY2ggIndpcC13cmFwcGVkLWtleXMiIGF0Cj4+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9mcy9mc2NyeXB0L2ZzY3J5cHQuZ2l0Cj4+Cj4+IEkgdGVzdGVkIHRoaXMgcGF0Y2ggd2l0
aCBtb2RpZmllZCBudm1lLXJkbWEgYXMgdGhlIGJsb2NrIGRldmljZQo+PiBhbmQgY3JlYXRlZCBh
IERNIGNyeXB0IG9uIHRvcCBvZiBpdC4gSSBnb3QgcGVyZm9ybWFuY2UgZW5oYW5jZW1lbnQKPj4g
Y29tcGFyZWQgdG8gU1cgY3J5cHRvLiBJIHRlc3RlZCB0aGUgSFcgd3JhcHBlZCBpbmxpbmUgbW9k
ZSB3aXRoCj4+IHRoZSBIVyBhbmQgdGhlIHN0YW5kYXJkIG1vZGUgd2l0aCBhIGZhbGxiYWNrIGFs
Z29yaXRobS4KPj4KPj4gSXNyYWVsIFJ1a3NoaW4gKDEpOgo+PiAgICBkbSBjcnlwdDogQWRkIGlu
bGluZSBlbmNyeXB0aW9uIHN1cHBvcnQKPj4KPj4gICBibG9jay9ibGstY3J5cHRvLmMgICAgfCAg
IDMgKwo+PiAgIGRyaXZlcnMvbWQvZG0tY3J5cHQuYyB8IDIwMiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKystLS0tLS0KPj4gICAyIGZpbGVzIGNoYW5nZWQsIDE4MCBpbnNlcnRp
b25zKCspLCAyNSBkZWxldGlvbnMoLSkKPiBJIGFwcHJlY2lhdGUgdGhlIGludGVyZXN0IGluIG15
IHBhdGNoc2V0IHRoYXQgYWRkcyBzdXBwb3J0IGZvciBoYXJkd2FyZS13cmFwcGVkCj4gaW5saW5l
IGVuY3J5cHRpb24ga2V5cwo+IChodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1ibG9jay8y
MDIxMTExNjAzMzI0MC4zOTAwMS0xLWViaWdnZXJzQGtlcm5lbC5vcmcpLgo+IFNvIGZhciBJJ3Zl
IHJlY2VpdmVkIHZlcnkgbGl0dGxlIGZlZWRiYWNrIG9uIGl0Lgo+Cj4gT25lIG9mIHRoZSBjaGFs
bGVuZ2VzIEkndmUgYmVlbiBoYXZpbmcgaXMgdGhhdCBJIHN0aWxsIGhhdmUgbm8gcGxhdGZvcm0g
b24gd2hpY2gKPiBJIGNhbiBhY3R1YWxseSB0ZXN0IGhhcmR3YXJlLXdyYXBwZWQga2V5cyB3aXRo
IHRoZSB1cHN0cmVhbSBrZXJuZWwuICBUaGUgZmVhdHVyZQo+IGNhbm5vdCBiZSBhY2NlcHRlZCB1
cHN0cmVhbSB1bnRpbCB0aGVyZSBpcyBhIHdheSB0byB0ZXN0IGl0LiAgSXQncyBhbG1vc3QKPiB3
b3JraW5nIG9uIHRoZSBTTTgzNTAgU29DLCBidXQgSSBhbSB3YWl0aW5nIGZvciBRdWFsY29tbSB0
byBmaXggc29tZSB0aGluZ3MuCj4KPiBJdCBzb3VuZHMgbGlrZSB5b3UndmUgaW1wbGVtZW50ZWQg
YSBibG9jayBkZXZpY2UgZHJpdmVyIHRoYXQgZXhwb3NlcyBzdXBwb3J0IGZvcgo+IGhhcmR3YXJl
LXdyYXBwZWQga2V5cy4gIENhbiB5b3UgcGxlYXNlIHBvc3QgdGhhdCBkcml2ZXI/CgpZZXMsIEkg
aW1wbGVtZW50ZWQgeW91ciBpbmxpbmUgY2FsbGJhY2tzIGF0IG52bWUtcmRtYSBkcml2ZXIuIFRo
ZSBkcml2ZXIgCmNvbW11bmljYXRlcyB3aXRoCgp0aGUgSFcgdmlhIGEgZ2VuZXJhbCBpYl92ZXJi
cyBsYXllciwgc28gSSBoYWQgdG8gZXh0ZW5kIGliX3ZlcmJzIGFuZCAKbWx4NV9pYiBkcml2ZXJz
LiBUaG9zZQoKcGF0Y2hlcyBhcmUgYXQgaW50ZXJuYWwgcmV2aWV3IGFuZCBJIHdpbGwgc2VuZCB0
aGUgbnZtZS1yZG1hIHBhdGNoZXMgCmFmdGVyd2FyZHMuCgo+Cj4gQ2FuIHlvdSBhbHNvIGVsYWJv
cmF0ZSBvbiBob3cgd3JhcHBlZCBrZXlzIHdvcmsgaW4geW91ciBjYXNlPyAgSW4gcGFydGljdWxh
ciwKPiBhcmUgdGhleSBjb21wYXRpYmxlIHdpdGggdGhlIHdob2xlIGRlc2lnbiB3aGljaCBJJ3Zl
IGRvY3VtZW50ZWQgaW4gZGV0YWlsIGluIG15Cj4gcGF0Y2hzZXQ/ICBUaGF0IHdvdWxkIGluY2x1
ZGUgaW1wbGVtZW50aW5nIHRoZSAtPmltcG9ydF9rZXksIC0+Z2VuZXJhdGVfa2V5LAo+IC0+cHJl
cGFyZV9rZXksIGFuZCAtPmRlcml2ZV9zd19zZWNyZXQgb3BlcmF0aW9ucy4gIEFsbCB0aGUgZGlm
ZmVyZW50IHBhcnRzIGFyZQo+IGltcG9ydGFudC4gIElmIHNvbWV0aGluZyBuZWVkcyB0byBiZSBv
cHRpb25hbCwgdGhhdCdzIHNvbWV0aGluZyBJIGNhbiBjb25zaWRlcgo+IGluY29ycG9yYXRpbmcg
aW50byB0aGUgZGVzaWduLCBidXQgaXQgd291bGQgcmVzdHJpY3QgdGhlIHVzZSBjYXNlcy4KCklu
IG15IGNhc2UsIHRoZSB1c2VyIHNob3VsZCBjcmVhdGUgd3JhcHBlZCBrZXlzIGJ5IGhpbXNlbGYg
dmlhIGEgdXNlciAKc3BhY2XCoCB0b29sIGJhc2VkCgpvbiBvcGVuc3NsIGxpYnJhcnkuIFRoZXJl
Zm9yZSwgdGhlIC0+aW1wb3J0X2tleSwgLT5nZW5lcmF0ZV9rZXkgYW5kIAotPnByZXBhcmVfa2V5
IGFyZQoKbm90IG5lY2Vzc2FyeSBhdCBteSBjYXNlLiBSZWdhcmRpbmcgLT5kZXJpdmVfc3dfc2Vj
cmV0LCBpdCBpcyBub3QgCnN1cHBvcnRlZCByaWdodCBub3cgYnkKCkNvbm5lY3RYNiBEWCBmaXJt
d2FyZSAod2UgcGxhbiB0byBhZGQgc3VwcG9ydCBmb3IgdGhpcykuwqAgVG8gdGVzdCAKZnNjcnlw
dCB3aXRoIHdyYXBwZWQga2V5cywKCmEgdGVtcG9yYXJ5IFdBIHdhcyBhZGRlZCB0byB0aGUgLT5k
ZXJpdmVfc3dfc2VjcmV0IGF0IG52bWUtcmRtYSBkcml2ZXIuIApUaGUgb3RoZXIgY2FsbGJhY2tz
Cgp5b3UgbWVudGlvbmVkIHdlcmUgbGVmdCBlbXB0eS4KCj4KPiBBbHNvLCB3aWxsIHlvdXIgZHJp
dmVyIG9ubHkgc3VwcG9ydCB3cmFwcGVkIGtleXMsIG9yIHdpbGwgaXQgc3VwcG9ydCBzdGFuZGFy
ZAo+IGtleXMgdG9vPwoKT3VyIGRyaXZlciB3aWxsIHN1cHBvcnQgYm90aCBtb2Rlcy4gVGhlIGZp
cnN0IHN0ZXAgaXMgdG8gc3VwcG9ydCB0aGUgCnN0YW5kYXJkIGtleXMsIGJlY2F1c2Ugb2YKCnRo
ZSBnYXAgSSBtZW50aW9uZWQgYWJvdmUuIEFzIEkgdW5kZXJzdGFuZCwgLT5kZXJpdmVfc3dfc2Vj
cmV0IGlzIG5vdCAKbmVlZGVkIGZvciBkbS1jcnlwdC4KCklzIHRoYXQgcmlnaHQ/Cgo+Cj4gLSBF
cmljCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6
Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

