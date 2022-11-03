Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86CCFC433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 14:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667486827;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VWkPetbc3W8BbtjL4gqXxukEO/KcWieKr0O7X0QjKXE=;
	b=b2Kh3qVuMs1nCbJQjTfpj0UTqPRg87QYf1emHJJtMQcdM/Bk+nOupe3pAIv4jb6rtaj9LK
	HypXaP3eZV4T07L0RlQ3NOLbM5yXP/uurnbGprTnFH62DI0fAqg8ooKgQiQnzQi5vKo/vo
	7LBQu8xEz9YfeAujZ36k7KqCC5i8idc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-taO1qi_8O8mFDCTBPeIXXQ-1; Thu, 03 Nov 2022 10:47:03 -0400
X-MC-Unique: taO1qi_8O8mFDCTBPeIXXQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BA642A2AD7D;
	Thu,  3 Nov 2022 14:47:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BFDB39D7C;
	Thu,  3 Nov 2022 14:46:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3748A19465A4;
	Thu,  3 Nov 2022 14:46:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 149811946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 14:46:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BDEDEC1908A; Thu,  3 Nov 2022 14:46:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B5B17C15BAB
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 14:46:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 945F53811F33
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 14:46:53 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr150082.outbound.protection.outlook.com [40.107.15.82]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-myecegLAPPyG-OXkwSXpjA-1; Thu, 03 Nov 2022 10:46:47 -0400
X-MC-Unique: myecegLAPPyG-OXkwSXpjA-1
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 VI1PR04MB6893.eurprd04.prod.outlook.com (2603:10a6:803:133::7) with
 Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Thu, 3 Nov 2022 14:46:44 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2554:cfdf:10b:487c]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2554:cfdf:10b:487c%7]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 14:46:44 +0000
To: Guoqing Jiang <guoqing.jiang@linux.dev>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
From: Heming Zhao <heming.zhao@suse.com>
Message-ID: <11a466f0-ecfe-c1e2-d967-2d648ce65bcb@suse.com>
Date: Thu, 3 Nov 2022 22:46:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
X-ClientProxiedBy: SG2PR06CA0210.apcprd06.prod.outlook.com
 (2603:1096:4:68::18) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR04MB4666:EE_|VI1PR04MB6893:EE_
X-MS-Office365-Filtering-Correlation-Id: a0fe2f28-7d2f-4004-15bf-08dabdaa39fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: +fMzCBfPXw185RSWWWLR8MaoEY4dOXUJEpLXwdE9M9XWFRkZlw/KuV0SMdHp7aV+BeUkg8aEhjlrP/PGnptHyiPw1NhMJZvKOFYSmVadcps1MyFC/aTmtSVSGVHDPFmZg9y95IwGvq8YzjwB+ebjCbj16MB+joVT1++W87PXG1a7uAZ/EZs0/e97DSuFM5xj9mlHjIICRT9jykuphQ4vd/bJc+y+H3SVTU3dEF9mzGHwKrzLid9s4bS54AdgIuFg676H8UeD8Vu2N5yPfsv0TnhPtEg4bLwgus/Gd2Dw47X3GupOP+INqfR8oDeuV/0/5t5ZmmhwYZU5fAfivniAo26LIEr8KOVA6gue03WIy3DUSmTkKnZdcg8Ob1iVGk6E+1ItB0BKU+CCU/pBGmPlOsavI4u9aw02+Onoy+XjYEQxRo9bIHkwMlioQqeJikCqXw2KpofowbwOhBvqsHdifPNYVAR3O9AYBL+0bqWDxjeHCxAbceTkVEFXRP9Gq8bW+01c1tAeQxyHoeUcaRW7tMpvnVjQvS0SsxJGMGH0B6ZnJBaLH1iGFNIGhpsGV75igyVN+uQOii5YamUuaibfkP1utZZWSliD7A4mfjhYUoKoAG+J6AyVoIjZbKzZVjojTBQ5fhHCL//byXYtzbKQBSnnB/UIY1858QV8AtWg6R9rrWWzO+gWyVFXxUm+jiH7pq5EQe2y7Ft5C8kCPJK74etdnH2a8PyJVLyEwDdIaFFiUX32PK8dFPl342Oqamr6hwCFacNXICYAL6sOA0q9YLSlHP61XDL+7B+kTa+fJbkfa31VLgpsNp7R44VCeqPjMkBPu84wNiwNyaY/FMFE8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB7PR04MB4666.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(31686004)(36756003)(6666004)(5660300002)(2906002)(38100700002)(83380400001)(31696002)(86362001)(8936002)(26005)(186003)(2616005)(44832011)(41300700001)(19627235002)(316002)(110136005)(66946007)(478600001)(6486002)(966005)(45080400002)(53546011)(4326008)(8676002)(66476007)(6512007)(6506007)(66556008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?08gsz0wHlingWfzUIlXxm6U4EoKEUW8zd7s9BXxvDPwqCxkD+PpKpxBqQNIj?=
 =?us-ascii?Q?v+BIiQ1T/GUhmHb8mtlohM1CqTAJv8BcAMwVYFoUinabBRUFYEPhbCm7RXLv?=
 =?us-ascii?Q?3ew/F62MExmIcWCs9+cWUlvQ1Hs+YJ8ZwU8+hGtr31FDQsfKhuatvtXHCAph?=
 =?us-ascii?Q?Pf5/VY5LSF+vFpDAJqqfT+FCiCsrfUUitef9xxy2HlAwznLBMDNyiQmBe2qS?=
 =?us-ascii?Q?0WzARJOcysrFQiRxQ92BrfS/AoiFCofh+FEKEbW5DiHp+xTzSB+XPT990I50?=
 =?us-ascii?Q?yDprhYL1zeYKkwBknL8p51lGms3Ru3Qmtd5MruIswzhm8yX1vVto3AzpaCeF?=
 =?us-ascii?Q?LWi4KCIkuzH/TWIQNBG9LWSFrWitCHnUVddGW2BQIXWz7Ni4BsP79ydlsH7u?=
 =?us-ascii?Q?40kgGT4l9UoWTCLqOBFLZqXE1R//CDiz8bzMXJF7my9CJd7Bt1rXygXosWdw?=
 =?us-ascii?Q?OYc0QzPcjci6QTUgXDCfp97COVjrYoKRNHx7RONvjNVGwJ2/QjCj2O9b6prF?=
 =?us-ascii?Q?HrwT3wL79M4M8gazUQcZkud7wEntOEQV0gHB+Ku8P0ZaC8u6yPX0SRo/CD8y?=
 =?us-ascii?Q?gj6m+i4uI7Ncib+ndZeMrkuX2rzhuZbp95lkyki+Um6X4VLiOrZbwgaUr2AV?=
 =?us-ascii?Q?l3HLQbz5u+Hwd/AOG0ONXr+D+VhCPHTaPcWUBXV7cUm7WFOHrIObL1g0z478?=
 =?us-ascii?Q?V29G+E9pHxVQu+QhlMR22akyzOEWs8Mtj7QnqCQFgUnYArmLiyl8kBGqS6dM?=
 =?us-ascii?Q?nIDG3tE0Coe4dPbHGuqdDMN8hBYIh/hqCJOTxSIIgG9od87A8N41JovpXgKy?=
 =?us-ascii?Q?IeNxp3rQO5AjkjH9E5fEny7/4Pg0/sB/Yac7tLuwKIL72pTG9BvBAHjk0VFK?=
 =?us-ascii?Q?N/RCsKM4dkEUylqmJw3pbNyZBEt2nn4Y8o4wTsCgbvTQgswtK7WrV3FabRCd?=
 =?us-ascii?Q?yjaLJO+ZcrHv9m1uQhbEsHJPtsmnrf2sYKI9n7M16xDiis6BJR1tWIqPuO80?=
 =?us-ascii?Q?bycsXyDI6j15arg0Rk3Phdh9XKWIf8oqb0rV9kq7YIYlYmEmu3Js3Kx57Gp7?=
 =?us-ascii?Q?pm/4zqphuhc0xMG24R/8l910ssYuFwIGIeWYYdBzGTzVR9q1KbRnrsKWn3/o?=
 =?us-ascii?Q?9SZLolPZmWVmfZKc+gu+pCFzYRdmzuVeepFxSB7vt7HdT+2W2wTf4+xePU3z?=
 =?us-ascii?Q?SxZbxwX7JjxeahfUAy7Qv9i02G21HjOZLQhxB7IvEKPI2i9pXGsVPqXVGAyv?=
 =?us-ascii?Q?VDJ1kfQAuIvdBoP/1ygvebyCr3nL5O7LDIU/aUR0jBXrza/vC2oYoRoUUnLk?=
 =?us-ascii?Q?/iSXN281EdMawfjgY45SOyVZMhfVsJggP+Fa3i8nJZ+4PCNnjElOtnpDDaws?=
 =?us-ascii?Q?AVHx67pZklk6lsso4EKUThn0o5yvK+0YHIxY0ARdpL5eQBhOvU/ttMVnQvNX?=
 =?us-ascii?Q?NnnzezsutghOhj88PaGE2i8oZ6MuugKYsHJzpS7WLbrlPDQtxrTrZA2NG+pN?=
 =?us-ascii?Q?DbObwYBZuw66rXnxhfsBjIuZp8HSDv1qdliW/s+W6mP3VntnrUkclI1193UT?=
 =?us-ascii?Q?HlIgHYUL8aa30imBTu27jK7lh+rlbZVlvOv6/leO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0fe2f28-7d2f-4004-15bf-08dabdaa39fd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 14:46:44.2105 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqhRVWU5tsIBIEmg0aDzRnumWhPh8oDp7uXKUMHOXAz4sDAtSYNREzz+zGM6DuA2veMuRGG2cxfwB3avHixhUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6893
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
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
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTEvMy8yMiAxMTo0NyBBTSwgR3VvcWluZyBKaWFuZyB3cm90ZToKPiBIaSwKPiAKPiBPbiAx
MS8zLzIyIDEyOjI3IEFNLCBNaWt1bGFzIFBhdG9ja2Egd3JvdGU6Cj4+IEhpCj4+Cj4+IFRoZXJl
J3MgYSBjcmFzaCBpbiB0aGUgdGVzdCBzaGVsbC9sdmNoYW5nZS1yZWJ1aWxkLXJhaWQuc2ggd2hl
biBydW5uaW5nCj4+IHRoZSBsdm0gdGVzdHN1aXRlLiBJdCBjYW4gYmUgcmVwcm9kdWNlZCBieSBy
dW5uaW5nICJtYWtlIGNoZWNrX2xvY2FsCj4+IFQ9c2hlbGwvbHZjaGFuZ2UtcmVidWlsZC1yYWlk
LnNoIiBpbiBhIGxvb3AuCj4gCj4gSSBoYXZlIHByb2JsZW0gdG8gcnVuIHRoZSBjbWQgKG5vdCBz
dXJlIHdoYXQgSSBtaXNzZWQpLCBpdCB3b3VsZCBiZSBiZXR0ZXIgaWYKPiB0aGUgcmVsZXZhbnQg
Y21kcyBhcmUgZXh0cmFjdGVkIGZyb20gdGhlIHNjcmlwdCB0aGVuIEkgY2FuIHJlcHJvZHVjZSBp
dCB3aXRoCj4gdGhvc2UgY21kcyBkaXJlY3RseS4KPiAKPiBbcm9vdEBsb2NhbGhvc3QgbHZtMl0j
IGdpdCBsb2cgfCBoZWFkIC0xCj4gY29tbWl0IDM2YTkyMzkyNmMyYzI3YzFhOGE1YWMyNjIzODdk
MmE0ZDNlNjIwZjgKPiBbcm9vdEBsb2NhbGhvc3QgbHZtMl0jIG1ha2UgY2hlY2tfbG9jYWwgVD1z
aGVsbC9sdmNoYW5nZS1yZWJ1aWxkLXJhaWQuc2gKPiBtYWtlIC1DIGxpYmRtIGRldmljZS1tYXBw
ZXIKPiBbLi4uXQo+IG1ha2UgLUMgZGFlbW9ucwo+IG1ha2VbMV06IE5vdGhpbmcgdG8gYmUgZG9u
ZSBmb3IgJ2FsbCcuCj4gbWFrZSAtQyB0ZXN0IGNoZWNrX2xvY2FsCj4gVkVSQk9TRT0wIC4vbGli
L3J1bm5lciBcCj4gIMKgwqDCoMKgwqDCoMKgIC0tdGVzdGRpciAuIC0tb3V0ZGlyIHJlc3VsdHMg
XAo+ICDCoMKgwqDCoMKgwqDCoCAtLWZsYXZvdXJzIG5kZXYtdmFuaWxsYSAtLW9ubHkgc2hlbGwv
bHZjaGFuZ2UtcmVidWlsZC1yYWlkLnNoIC0tc2tpcCBACj4gcnVubmluZyAxIHRlc3RzCj4gIyMj
wqDCoMKgwqDCoCBydW5uaW5nOiBbbmRldi12YW5pbGxhXSBzaGVsbC9sdmNoYW5nZS1yZWJ1aWxk
LXJhaWQuc2ggMAo+IHwgWyAwOjAwXSBsaWIvaW5pdHRlc3Q6IGxpbmUgMTMzOiAvdG1wL0xWTVRF
U1QzMTc5NDguaUNvTHdtRGhaVy9kZXYvdGVzdG51bGw6IFBlcm1pc3Npb24gZGVuaWVkCj4gfCBb
IDA6MDBdIEZpbGVzeXN0ZW0gZG9lcyBzdXBwb3J0IGRldmljZXMgaW4gL3RtcC9MVk1URVNUMzE3
OTQ4LmlDb0x3bURoWlcvZGV2IChtb3VudGVkIHdpdGggbm9kZXY/KQoKSSBkaWRuJ3QgcmVhZCBv
dGhlciBtYWlscyBpbiB0aGlzIHRocmVhZCwgb25seSBmb3IgYWJvdmUgaXNzdWUuCklmIHlvdSB1
c2Ugb3BlbnN1c2UsIHN5c3RlbWQgc2VydmljZSB0bXAubW91bnQgdXNlcyBub2RldiBvcHRpb24g
dG8gbW91bnQgdG1wZnMgb24gL3RtcC4KIEZyb20gbXkgZXhwZXJpZW5jZSwgdGhlcmUgYXJlIHR3
byBtZXRob2RzIHRvIGZpeCh3b3JrIGFyb3VuZCk6CjEuIHN5c3RlbWN0bCBkaXNhYmxlIHRtcC5t
b3VudCAmJiBzeXN0ZW1jdGwgbWFzayB0bXAubW91bnQgJiYgcmVib290CjIuIG12IC91c3IvbGli
L3N5c3RlbWQvc3lzdGVtL3RtcC5tb3VudCAvcm9vdC8gJiYgcmVib290CgpUaGFua3MsCkhlbWlu
ZwoKPiB8IFsgMDowMF0gIyMgLSAvcm9vdC9sdm0yL3Rlc3Qvc2hlbGwvbHZjaGFuZ2UtcmVidWls
ZC1yYWlkLnNoOjE2Cj4gfCBbIDA6MDBdICMjIDEgU1RBQ0tUUkFDRSgpIGNhbGxlZCBmcm9tIGxp
Yi9pbml0dGVzdDoxMzQKPiB8IFsgMDowMF0gIyMgMiBzb3VyY2UoKSBjYWxsZWQgZnJvbSAvcm9v
dC9sdm0yL3Rlc3Qvc2hlbGwvbHZjaGFuZ2UtcmVidWlsZC1yYWlkLnNoOjE2Cj4gfCBbIDA6MDBd
ICMjIHRlYXJkb3duLi4uLm9rCj4gIyMjwqDCoMKgwqDCoMKgIGZhaWxlZDogW25kZXYtdmFuaWxs
YV0gc2hlbGwvbHZjaGFuZ2UtcmVidWlsZC1yYWlkLnNoCj4gCj4gIyMjIDEgdGVzdHM6IDAgcGFz
c2VkLCAwIHNraXBwZWQsIDAgdGltZWQgb3V0LCAwIHdhcm5lZCwgMSBmYWlsZWQKPiBtYWtlWzFd
OiAqKiogW01ha2VmaWxlOjEzNzogY2hlY2tfbG9jYWxdIEVycm9yIDEKPiBtYWtlOiAqKiogW01h
a2VmaWxlOjg5OiBjaGVja19sb2NhbF0gRXJyb3IgMgo+IAo+IEFuZCBsaW5lIDE2IGlzIHRoaXMs
Cj4gCj4gW3Jvb3RAbG9jYWxob3N0IGx2bTJdIyBoZWFkIC0xNiAvcm9vdC9sdm0yL3Rlc3Qvc2hl
bGwvbHZjaGFuZ2UtcmVidWlsZC1yYWlkLnNoIHwgdGFpbCAtMQo+IC4gbGliL2luaXR0ZXN0Cj4g
Cj4gRm9yICJsdmNoYW5nZSAtLXJlYnVpbGQiIGFjdGlvbiwgSSBndWVzcyBpdCByZWxhdGVzIHRv
IENUUl9GTEFHX1JFQlVJTEQgZmxhZwo+IHdoaWNoIGlzIGNoZWNrIGZyb20gdHdvIHBhdGhzLgo+
IAo+IDEuIHJhaWRfY3RyIC0+IHBhcnNlX3JhaWRfcGFyYW1zCj4gIMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAtPiBhbmFseXNlX3N1cGVyYmxvY2tzIC0+IHN1cGVyX3ZhbGlk
YXRlIC0+IHN1cGVyX2luaXRfdmFsaWRhdGlvbgo+IAo+IDIuIHJhaWRfc3RhdHVzIHdoaWNoIG1p
Z2h0IGludm9rZWQgYnkgaW9jdGxzIChETV9ERVZfV0FJVF9DTUQgYW5kCj4gIMKgIMKgIERNX1RB
QkxFX1NUQVRVU19DTUQpIGZyb20gbHZtCj4gCj4gU2luY2UgdGhlIGNvbW1pdCB5b3UgbWVudGlv
bmVkIHRoZSBiZWhhdmlvciBvZiByYWlkX2R0ciwgdGhlbiBJIHRoaW5rIHRoZSBjcmFzaAo+IGlz
IGNhdXNlZCBieSBwYXRoIDIsIHBsZWFzZSBjb3JyZWN0IG1lIGlmIG15IHVuZGVyc3RhbmRpbmcg
aXMgd3JvbmcuCj4gCj4+IFRoZSBjcmFzaCBoYXBwZW5zIGluIHRoZSBrZXJuZWwgNi4wIGFuZCA2
LjEtcmMzLCBidXQgbm90IGluIDUuMTkuCj4+Cj4+IEkgYmlzZWN0ZWQgdGhlIGNyYXNoIGFuZCBp
dCBpcyBjYXVzZWQgYnkgdGhlIGNvbW1pdAo+PiAwZGQ4NGIzMTkzNTJiYjhiYTY0NzUyZDRlNDUz
OTZkOGIxM2U2MDE4Lgo+Pgo+PiBJIHVwbG9hZGVkIG15IC5jb25maWcgaGVyZSAoaXQncyAxMi1j
b3JlIHZpcnR1YWwgbWFjaGluZSk6Cj4+IGh0dHBzOi8vcGVvcGxlLnJlZGhhdC5jb20vfm1wYXRv
Y2thL3Rlc3RjYXNlcy9tZC1jcmFzaC1jb25maWcvY29uZmlnLnR4dAo+Pgo+PiBNaWt1bGFzCj4+
Cj4+IFvCoMKgIDc4LjQ3ODQxN10gQlVHOiBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNl
LCBhZGRyZXNzOiAwMDAwMDAwMDAwMDAwMDAwCj4+IFvCoMKgIDc4LjQ3OTE2Nl0gI1BGOiBzdXBl
cnZpc29yIHdyaXRlIGFjY2VzcyBpbiBrZXJuZWwgbW9kZQo+PiBbwqDCoCA3OC40Nzk2NzFdICNQ
RjogZXJyb3JfY29kZSgweDAwMDIpIC0gbm90LXByZXNlbnQgcGFnZQo+PiBbwqDCoCA3OC40ODAx
NzFdIFBHRCAxMTU1N2YwMDY3IFA0RCAxMTU1N2YwMDY3IFBVRCAwCj4+IFvCoMKgIDc4LjQ4MDYy
Nl0gT29wczogMDAwMiBbIzFdIFBSRUVNUFQgU01QCj4+IFvCoMKgIDc4LjQ4MTAwMV0gQ1BVOiAw
IFBJRDogNzMgQ29tbToga3dvcmtlci8wOjEgTm90IHRhaW50ZWQgNi4xLjAtcmMzICM1Cj4+IFvC
oMKgIDc4LjQ4MTY2MV0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsg
UElJWCwgMTk5NiksIEJJT1MgMS4xNC4wLTIgMDQvMDEvMjAxNAo+PiBbwqDCoCA3OC40ODI0NzFd
IFdvcmtxdWV1ZToga2RlbGF5ZCBmbHVzaF9leHBpcmVkX2Jpb3MgW2RtX2RlbGF5XQo+PiBbwqDC
oCA3OC40ODMwMjFdIFJJUDogMDAxMDptZW1wb29sX2ZyZWUrMHg0Ny8weDgwCj4+IFvCoMKgIDc4
LjQ4MzQ1NV0gQ29kZTogNDggODkgZWYgNWIgNWQgZmYgZTAgZjMgYzMgNDggODkgZjcgZTggMzIg
NDUgM2YgMDAgNDggNjMgNTMgMDggNDggODkgYzYgM2IgNTMgMDQgN2QgMmQgNDggOGIgNDMgMTAg
OGQgNGEgMDEgNDggODkgZGYgODkgNGIgMDggPDQ4PiA4OSAyYyBkMCBlOCBiMCA0NSAzZiAwMCA0
OCA4ZCA3YiAzMCA1YiA1ZCAzMSBjOSBiYSAwMSAwMCAwMCAwMAo+PiBbwqDCoCA3OC40ODUyMjBd
IFJTUDogMDAxODpmZmZmODg5MTAwMzZiZGE4IEVGTEFHUzogMDAwMTAwOTMKPj4gW8KgwqAgNzgu
NDg1NzE5XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZmODg5MTAzN2I2NWQ4IFJDWDog
MDAwMDAwMDAwMDAwMDAwMQo+PiBbwqDCoCA3OC40ODY0MDRdIFJEWDogMDAwMDAwMDAwMDAwMDAw
MCBSU0k6IDAwMDAwMDAwMDAwMDAyMDIgUkRJOiBmZmZmODg5MTAzN2I2NWQ4Cj4+IFvCoMKgIDc4
LjQ4NzA4MF0gUkJQOiBmZmZmODg5MTQ0N2JhMjQwIFIwODogMDAwMDAwMDAwMDAxMjkwOCBSMDk6
IDAwMDAwMDAwMDAzZDA5MDAKPj4gW8KgwqAgNzguNDg3NzY0XSBSMTA6IDAwMDAwMDAwMDAwMDAw
MDAgUjExOiAwMDAwMDAwMDAwMTczNTQ0IFIxMjogZmZmZjg4OTEwMWExNDAwMAo+PiBbwqDCoCA3
OC40ODg0NTFdIFIxMzogZmZmZjg4OTE1NjJhYzMwMCBSMTQ6IGZmZmY4ODkxMDJiNDE0NDAgUjE1
OiBmZmZmZThmZmZmYTAwZDA1Cj4+IFvCoMKgIDc4LjQ4OTE0Nl0gRlM6wqAgMDAwMDAwMDAwMDAw
MDAwMCgwMDAwKSBHUzpmZmZmODg5NDJmYTAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAw
MDAKPj4gW8KgwqAgNzguNDg5OTEzXSBDUzrCoCAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDog
MDAwMDAwMDA4MDA1MDAzMwo+PiBbwqDCoCA3OC40OTA0NzRdIENSMjogMDAwMDAwMDAwMDAwMDAw
MCBDUjM6IDAwMDAwMDExMDJlOTkwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmIwCj4+IFvCoMKgIDc4
LjQ5MTE2NV0gQ2FsbCBUcmFjZToKPj4gW8KgwqAgNzguNDkxNDI5XcKgIDxUQVNLPgo+PiBbwqDC
oCA3OC40OTE2NDBdwqAgY2xvbmVfZW5kaW8rMHhmNC8weDFjMCBbZG1fbW9kXQo+PiBbwqDCoCA3
OC40OTIwNzJdwqAgY2xvbmVfZW5kaW8rMHhmNC8weDFjMCBbZG1fbW9kXQo+IAo+IFRoZSBjbG9u
ZV9lbmRpbyBiZWxvbmdzIHRvICJjbG9uZSIgdGFyZ2V0X3R5cGUuCj4gCj4+IFvCoMKgIDc4LjQ5
MjUwNV3CoCBfX3N1Ym1pdF9iaW8rMHg3Ni8weDEyMAo+PiBbwqDCoCA3OC40OTI4NTldwqAgc3Vi
bWl0X2Jpb19ub2FjY3Rfbm9jaGVjaysweGI2LzB4MmEwCj4+IFvCoMKgIDc4LjQ5MzMyNV3CoCBm
bHVzaF9leHBpcmVkX2Jpb3MrMHgyOC8weDJmIFtkbV9kZWxheV0KPiAKPiBUaGlzIGlzICJkZWxh
eSIgdGFyZ2V0X3R5cGUuIENvdWxkIHlvdSBzaGVkIGxpZ2h0IG9uIGhvdyB0aGUgdHdvIHRhcmdl
dHMKPiBjb25uZWN0IHdpdGggZG0tcmFpZD8gQW5kIEkgaGF2ZSBzaGFsbG93IGtub3dsZWRnZSBh
Ym91dCBkbSAuLi4KPiAKPj4gW8KgwqAgNzguNDkzODA4XcKgIHByb2Nlc3Nfb25lX3dvcmsrMHgx
YjQvMHgzMDAKPj4gW8KgwqAgNzguNDk0MjExXcKgIHdvcmtlcl90aHJlYWQrMHg0NS8weDNlMAo+
PiBbwqDCoCA3OC40OTQ1NzBdwqAgPyByZXNjdWVyX3RocmVhZCsweDM4MC8weDM4MAo+PiBbwqDC
oCA3OC40OTQ5NTddwqAga3RocmVhZCsweGMyLzB4MTAwCj4+IFvCoMKgIDc4LjQ5NTI3OV3CoCA/
IGt0aHJlYWRfY29tcGxldGVfYW5kX2V4aXQrMHgyMC8weDIwCj4+IFvCoMKgIDc4LjQ5NTc0M13C
oCByZXRfZnJvbV9mb3JrKzB4MWYvMHgzMAo+PiBbwqDCoCA3OC40OTYwOTZdwqAgPC9UQVNLPgo+
PiBbwqDCoCA3OC40OTYzMjZdIE1vZHVsZXMgbGlua2VkIGluOiBicmQgZG1fZGVsYXkgZG1fcmFp
ZCBkbV9tb2QgYWZfcGFja2V0IHV2ZXNhZmIgY2ZiZmlsbHJlY3QgY2ZiaW1nYmx0IGNuIGNmYmNv
cHlhcmVhIGZiIGZvbnQgZmJkZXYgdHVuIGF1dG9mczQgYmluZm10X21pc2MgY29uZmlnZnMgaXB2
NiB2aXJ0aW9fcm5nIHZpcnRpb19iYWxsb29uIHJuZ19jb3JlIHZpcnRpb19uZXQgcGNzcGtyIG5l
dF9mYWlsb3ZlciBmYWlsb3ZlciBxZW11X2Z3X2NmZyBidXR0b24gbW91c2VkZXYgcmFpZDEwIHJh
aWQ0NTYgbGliY3JjMzJjIGFzeW5jX3JhaWQ2X3JlY292IGFzeW5jX21lbWNweSBhc3luY19wcSBy
YWlkNl9wcSBhc3luY194b3IgeG9yIGFzeW5jX3R4IHJhaWQxIHJhaWQwIG1kX21vZCBzZF9tb2Qg
dDEwX3BpIGNyYzY0X3JvY2tzb2Z0IGNyYzY0IHZpcnRpb19zY3NpIHNjc2lfbW9kIGV2ZGV2IHBz
bW91c2UgYnNnIHNjc2lfY29tbW9uIFtsYXN0IHVubG9hZGVkOiBicmRdCj4+IFvCoMKgIDc4LjUw
MDQyNV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAwCj4+IFvCoMKgIDc4LjUwMDc1Ml0gLS0tWyBlbmQg
dHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tCj4+IFvCoMKgIDc4LjUwMTIxNF0gUklQOiAwMDEw
Om1lbXBvb2xfZnJlZSsweDQ3LzB4ODAKPiAKPiBCVFcsIGlzIHRoZSBtZW1wb29sX2ZyZWUgZnJv
bSBlbmRpbyAtPiBkZWNfY291bnQgLT4gY29tcGxldGVfaW8/Cj4gQW5kIGlvIHdoaWNoIGNhdXNl
ZCB0aGUgY3Jhc2ggaXMgZnJvbSBkbV9pbyAtPiBhc3luY19pbyAvIHN5bmNfaW8KPiAgwqAtPiBk
aXNwYXRjaF9pbywgc2VlbXMgZG0tcmFpZDEgY2FuIGNhbGwgaXQgaW5zdGVhZCBvZiBkbS1yYWlk
LCBzbyBJCj4gc3VwcG9zZSB0aGUgaW8gaXMgZm9yIG1pcnJvciBpbWFnZS4KPiAKPiBUaGFua3Ms
Cj4gR3VvcWluZwoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

