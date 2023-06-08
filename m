Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BEC6C7EE25
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 07:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686294064;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WgQ1/tXP0NYKwaRQsab2zZ2le0V/vLNeWe5CopihKuk=;
	b=AcHsqQdAy+mzBQRQov0rs2OPJRc7YEmqSfdJl6d7gCiU+HzIpAjToR9oNo2mn9w19XrwqP
	jm7cSEZqayqlk3TKliV2Hp3kroqaPGPKR1s3zXchF523NGo13NHVU5vLHsElQWnDRy84Kj
	oFztfR6yvWGCYA8FZ/HU/O6Wul6svJ4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-QRI27iAaMAGJpBOTX6GJ8g-1; Fri, 09 Jun 2023 03:00:55 -0400
X-MC-Unique: QRI27iAaMAGJpBOTX6GJ8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4C2F3802293;
	Fri,  9 Jun 2023 07:00:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC7552166B25;
	Fri,  9 Jun 2023 07:00:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 96FB619451C0;
	Fri,  9 Jun 2023 07:00:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 39767194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 08:29:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 27A89C16044; Thu,  8 Jun 2023 08:29:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1EEDBC1603B
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 08:29:32 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F356780231B
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 08:29:31 +0000 (UTC)
Received: from esa1.hc3370-68.iphmx.com (esa1.hc3370-68.iphmx.com
 [216.71.145.142]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-wlItPwVaO02urNFYlUcJxQ-1; Thu, 08 Jun 2023 04:29:29 -0400
X-MC-Unique: wlItPwVaO02urNFYlUcJxQ-1
X-IronPort-RemoteIP: 104.47.66.46
X-IronPort-MID: 112448154
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:Z8zlDq5iuQ+exh1tlXUKbAxRtHvHchMFZxGqfqrLsTDasY5as4F+v
 mQWCmuOMvyNYWHyLtEjb9u0pBlUsMDVztNjQVQ5riphHi5G8cbLO4+Ufxz6V8+wwm8vb2o8t
 plDNYOQRCwQZiWBzvt4GuG59RGQ7YnRGvynTraCYnsrLeNdYH9JoQp5nOIkiZJfj9G8Agec0
 fv/uMSaM1K+s9JOGjt8B5mr9lU35JwehBtC5gZlPa4T7AeH/5UoJMl3yZ+ZfiOQrrZ8RoZWd
 86bpJml82XQ+QsaC9/Nut4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5iXBYoUm9Fii3hojxE4
 I4lWapc6+seFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpdFLjoH4EweZOUlFuhL7W5m2
 vVIIw4rfx+6qcGa4/GRQ9IxucUIM5y+VG8fkikIITDxK98DGMqGZpqQoNhS0XE3m9xEGuvYa
 4wBcz1zYR/cYhpJfFAKFJY5m+TujX76G9FagAvN+exrvC6NkkotjtABM/KMEjCObd9SkUuC4
 HrP4kzyAw0ANczZwj2Amp6prraWx3+nCNtPSNVU8NY3q02N+m0uMCQxckOkh+mahVTicelAf
 hl8Fi0G6PJaGFaQZtXwWhyQoXiavwUdUd5dD+077g6WzqPepQ2eAwAsRy5Lb9EOt8IsQzEuk
 FOK9/vgCj9HqrCZSXuBsLyTqFuaIi4UMX0PfwcHQBED7t2lp5s85jrDS5NvHbC4ivXvFD3wy
 izMpy87750WhNQO3r+2/njGhSytvZnDSgMp5gTRUXmh5wk/b4mgD6Ss6F7G/bNKKIGSTXGfs
 3Ue3cuT9uYDCdeKjiPlaOEMGqy5ovWIKjvRhXZxEJQ7sTeg4XiuecZX+j4WDFdkNIMIdCHkZ
 GfXuBhN/9lDMX2yd6h1bomtTcMwwsDd+c/NU/nVap9LfcJ3fQrepiV2PxbMgSbqjVQmlrw5N
 dGDa8GwAH0GCKNhij2rW+Ma1rxtzSc7rY/Oea3GI92c+eL2TBaopX0taTNisshRAHu4nTjo
IronPort-HdrOrdr: A9a23:G7onnapr57uthxW1nBDPqCAaV5rveYIsimQD101hICG9Evb0qy
 nOpoV/6faQslwssR4b9uxoVJPvfZq+z+8W3WByB9eftWDd0QPFEGgL1+DfKlbbak7DH4BmtJ
 uJc8JFeafN5VoRt7eG3OFveexQvOVu88qT9JjjJ28Gd3APV0n5hT0JcjpyFCdNNW57LKt8Lr
 WwzOxdqQGtfHwGB/7LfUXsD4D41rv2fIuNW29+OyIa
X-Talos-CUID: 9a23:y9pm8mHLSebgOpq8qmJI/R4fJOY0fUTz71vzYGWxMjtWSZaKHAo=
X-Talos-MUID: 9a23:AITs3goTuMz8zmb4LsEez2xJJNlU4pmWMWcqiYogq+qLL3BaACjI2Q==
X-IronPort-AV: E=Sophos;i="6.00,226,1681185600"; d="scan'208";a="112448154"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO
 NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
 by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 08 Jun 2023 04:29:25 -0400
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com (2603:10b6:a03:38d::21)
 by SJ0PR03MB7052.namprd03.prod.outlook.com (2603:10b6:a03:4e1::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 08:29:24 +0000
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd]) by SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd%3]) with mapi id 15.20.6455.028; Thu, 8 Jun 2023
 08:29:24 +0000
Date: Thu, 8 Jun 2023 10:29:18 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZIGRXrSGmgLF/07O@Air-de-Roger>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-14-demi@invisiblethingslab.com>
 <ZH7tizoYl8YVFN9B@Air-de-Roger> <ZH9mZGbM32CDmKGF@itl-email>
 <ZIA9uBJxx2gqA4Cq@Air-de-Roger> <ZICs+WYCPYdu2yoI@itl-email>
In-Reply-To: <ZICs+WYCPYdu2yoI@itl-email>
X-ClientProxiedBy: LO4P123CA0071.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::22) To SJ0PR03MB6423.namprd03.prod.outlook.com
 (2603:10b6:a03:38d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6423:EE_|SJ0PR03MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: 4afe84c0-0120-48bd-6361-08db67fa76e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: TB6dm0wrZV9D3MSiBPmVQExFIRPMRGyECAvtMs3kaxuuCvmNWQ8zZtzAW3tkCHL19VqbRpSpKGNj8ShY70oSo8qWVrCmyaT2b9UflgBXvu97JCK+BOrncDejWWWZUZ8HQwf8GjuhMcX/0NG5M1pVQt94mU64wjSsElDw3CO1TLCIKuoazGh/hSySqTMmjH3Xb83N8/922d91+g4aaJoUI6ylkMPXZ/so12R8eWaA8ECZx+ZIQX1FaNNfjc0W0ZLsM0FDRizM8ErhneRU2jMGlQubOJ4yQqgqkJhE/+dbefcgu8RPFnARU77piYAZIXh/cqhEpsAgwMVlnmLdiZ5PydJ3wN8iIplxJUz97Qr+mgBka1Caqhwxd4AuJ9Np0n6yJecpif5FprpN6HV7hyaJFd01Wtgqwlwi4NssXjDFiB4F43Iwbqd23CBozZQZRiOLLZtB0kUuTewtysLFCT0pDh7KckTMnbZtvQM+Hlp3y3B9zZMf9H57hkqx72El/3vIPxHKRLkdqV0KtJ6+uXxBfmmFJ5Df08Ln5ODu5jrqHbocFDpcpPcdiahmlBUv/dWH
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR03MB6423.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199021)(66476007)(478600001)(66946007)(4326008)(6916009)(316002)(2906002)(8936002)(41300700001)(8676002)(5660300002)(54906003)(66556008)(6666004)(6486002)(6512007)(6506007)(26005)(9686003)(82960400001)(38100700002)(33716001)(83380400001)(186003)(85182001)(86362001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkxDUzJyZktLN2owa01HQjZCall5eGcvWjVzM1ZHWHhCVzFhMlZKUlJHRVBS?=
 =?utf-8?B?RUFzT1VwMkp5aWFrSWNBbDFIS3ZyOG85b250Q2t0aG5STENtcmREbUpPZlNL?=
 =?utf-8?B?WWpGMXJOdS9LeG5NMGpFbTNQNDNXUHhCWmkyR09XMUpXSUFCTXdoZzdjYlVo?=
 =?utf-8?B?T0JrUk1TVkE2ZDFJOVdLek1nbjZEYkZpeGZmZklsUVU3bXlzeFhaQzdWYU5w?=
 =?utf-8?B?a3dONzk5Nm51REd6aVhXMEkwSG1lK3NDUDZFNkZwZmIvV2VMYTliY1RTTW1B?=
 =?utf-8?B?UnR2U20yZTRzRi9IcnBMSGYrcGlUR1VXbzd1TSs3MnlpM21pa05XN2pqbUk2?=
 =?utf-8?B?VjllVkQrTTJtc3p3dXB0TFM1RU5zaVM3WEp5N29BTXpUUXp6NXE1N1ZtTmVQ?=
 =?utf-8?B?TEIxL2ZiSDVDS2lUTzAvTHp6MDQ1LzJDWUdHVmpYbkpEWlNMNm5wMnZXWHBC?=
 =?utf-8?B?d3FrQWdZNStjMzhtVnVuR1BTNWZabUI5amM3RGxLYjQveE93cFgwOEtjb01k?=
 =?utf-8?B?aVllZlVycDFzakwxVjhnT1J4UTNwcGl0YlpMT3huSHB3ZVQ2QnYwNkxqL3BY?=
 =?utf-8?B?OTRxbXlpM29KYWY5REQxUzBpQWRpMzRBTS9LdlFKZUxYd0VyWVdXVWpBYjBz?=
 =?utf-8?B?bmE0Sm42ZXBIUkpuYUlQd05FbkRTay9sUThEYjhKb2YrMVltdFZBaytOWWtm?=
 =?utf-8?B?UTcwVWNxUUdrY2s0ZENTeHhJdy9Paml0UFBKRVYzRWhEWkdMbnFRbW5xN0VW?=
 =?utf-8?B?TUQ1RjFOZjArNkpGNnZPTnJiY1NxUFlPdW04RDhJcklJTFNXTU8wWmVYVFNx?=
 =?utf-8?B?d3RqNHY2WXJhQklYa2dSTjBUM0RxVmpZWFZSUXU2dVRHSHpXRWtUeThlTWlU?=
 =?utf-8?B?aHlaYjdRdDBkMGdSbFAvYTRQdkhZemRwNWx2aWVmaElSOG12eGs5T0o5Ylhi?=
 =?utf-8?B?RHdudlFHTHdlVHc4NDRYZ1Fha0VVTXlQZW4zaGRmeVE1ajJQUWV2SnNleXlp?=
 =?utf-8?B?SVI0OUQ2dm5EanRBV2g4TEFBZjFsVnBvb3NCdlZnY3VLY2htcUFkNEhrQWpS?=
 =?utf-8?B?Q21lNXAwQUdaNEtHOEo3RzNKZys4aTBHRC9iQkQvVXJ1aGdrMDh2UWt4Y3BE?=
 =?utf-8?B?Z1VDODhIRG92YnZsWmxZRG9XOEtybDZYbkhic2sya1IweWhHNFhxVDlkK3dS?=
 =?utf-8?B?RnNQaVRsM3g1aGkxZlpmM0JtSFVvWGVycGVOSXA3V1gxeE1IRCtjNUpjUWJ6?=
 =?utf-8?B?bG5rTWQ0NXkxQnlkck1nV0UwQk9HaWhpU2NTMDdUTjFWK0lhbEsxM1I5K1NW?=
 =?utf-8?B?U1dhbnFlSS94VEVHWC9SOVVKM1N3MW4yRnNYbzlzQkdoaFYwQkhUY3IrT1pU?=
 =?utf-8?B?WVNCenBUU2EyUU1GNlpCWGxBblF0VjRjSWxxeXpNajlqbW5uN3ZhSHVPZEp0?=
 =?utf-8?B?ckNxM08ydFRvdzJLS09JaUlJVWJiMG9mVzUrWEYvWURidEJidlJqUHZpeWth?=
 =?utf-8?B?NlNhWEZXNDNrdmtlU2UwUTFRSDZEREpTY095aE90Y0pzSVVLbWxSYTR6SStF?=
 =?utf-8?B?eXg2MC9tSUFmSFBwbGZBVWt5QWR0alBXWm1wTjZnWGZwdGdJWDkvclE1UGZD?=
 =?utf-8?B?TExXWUdUMjdDdWJlK01VTzhURnFxdkFESXFrUXkvVWY4Ukg2WWFNQlNrdEZ6?=
 =?utf-8?B?SFV6SExac0lZWE9EQ1EzbVpxcmJKWnphdjNZTkJzUml2alBvbHA0eWJ1UHBZ?=
 =?utf-8?B?Z1dZekU0Mmg4QU1NQWliRDRlOGFCRUhELy9DTzVGUUh4TjluVjNBekxiK2M2?=
 =?utf-8?B?ZndPUkkvWFo1THZIdnY4dEZKdlk5bldZMDVmTHc0NFgyN1daK1phVjVqL2xh?=
 =?utf-8?B?U2JxZ09PaVJPRmJJS0U5TmFiQnppY3lqalBhTjhMaUJqN25kWFNCWXBsNVpG?=
 =?utf-8?B?bkNqd0QwWnhobGJ5V05na1hvN0RVSWd1OW5tcnEwUmN6RmdmNTdMeUg1TUlj?=
 =?utf-8?B?UHpDMHlYNmVVUGwxZnY3ak9PRnozTzlEYlIyUkpSMC9Db3FvVGpnMWNBME94?=
 =?utf-8?B?Q0RIRmM3b1dQMGJpUE0xNUovcHQ3NS9YNVhIYTRIaHJ0VFpIV0FoWXM4YVBr?=
 =?utf-8?B?UGY0enRGZk1Od3lFa2ZCdnlaUVhnOVJ1ZSs3d0oxZnd2WjZsZU5DSkFaTmRK?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VGdrNXNnS013WVRPVVJ3V1JtL2tnVXRzcUdRdHRqNWd3QkxUNnNlb0UwdGpO?=
 =?utf-8?B?MEh3QXU0SEQ1UkRrSzVISm5oakN2ZlBMZVlNTTU1ZjRtcmN3OGk5NndjQUxF?=
 =?utf-8?B?Nm5ueFZqU3B6L3NMTm92NTArOXBWNnpFdCt1UkhKcW1uRS9pU1NBWkVyODho?=
 =?utf-8?B?UnVIWFlwbzJQb0tteFJVUkJrQ3d0YVZhREJUREk5WjJlSS8zMnduK3hjcVNp?=
 =?utf-8?B?eVRZckxNY0V4UUJNR2llMFUvWUFFTlZ5UXlQZ0FjYUY5TUxGeStheStITmlZ?=
 =?utf-8?B?eWxPUXo4Tk1LZ0hJMFN2dkZWa2JxYlZsZk5jRlp2SVdLc1pQSGd6aFYxR2NR?=
 =?utf-8?B?Qk8rQmdNTzZybktjd2FnSHhFbXhIekxLNnY2bkRDbktRblpXcnJyU2p2R3NU?=
 =?utf-8?B?Rm5nZ2JrMDQwMk9XQ01YUzR2ditTZmduRDc3dzRKUnBxY24xdG9xK1E1MjZL?=
 =?utf-8?B?K3o5SFRlaTVFRVJIamhNNDZ6cGd2dElrT3hId3ZvZnBscG1CY2ZhRXQ4M0pv?=
 =?utf-8?B?VFpuSzRrbWJiU0lBRFVQRWtDUDNLNWt5VlN6RHpPTy9hN1N4ZEZRbWJFbXBr?=
 =?utf-8?B?VFVIUnRvaVpXTUE3aTlzNGQyRWxva3R2bGdHWWpWWjhnVG92N3lDK0p2TFUx?=
 =?utf-8?B?bnkxME1PRnQ1WXdxN2UwYndEZi9PeE83UUlpU21lWk40N3FKT1U0cjhWVkJj?=
 =?utf-8?B?dmk4ZzhRdlNBZ21pbEM4QW95MVZFZWdXTHcxZElOYXJqVXVqK2tvY1JVQzJ1?=
 =?utf-8?B?WW5FTXJBcWNUeG1PalhsQkpMUVRndlRnaE1OTkhmYjVqZW0vdmxKN2dtTDVw?=
 =?utf-8?B?MmxMaEtkaVFnc1B5TlptREFGSjEwR0h5bFR5T3dvb01OSkU1MWZ1Y1IxQmRn?=
 =?utf-8?B?VWNyYzg4cWFESHdTT1NBT2ZWK1pkNTcvd3h3MXIzN2pIcWpLUWZvTjNNVGFH?=
 =?utf-8?B?a3Z0MlFINUhhNm5nU3FBMWdvU3pqSEIzcXNNR2J2eENkSXJzU1czTlpVUC9D?=
 =?utf-8?B?aHRtUExCZ1pCZ0hTL3JCcTh4MHVJUDhUVE1yR0hveEtDVzVXTnY2RXRFYk9V?=
 =?utf-8?B?RjBWcmpvSjhmNThmVDJMWmhsYmhGQ0YxQURqWDRib0VKdTQwcE5lOC9LdHNz?=
 =?utf-8?B?TUhRU29tWitGUmo2NkpGQUtPY2o3NzBBd3JmT214Mit1eHhCa2JCT1ZsT1Z4?=
 =?utf-8?B?TitldmtXMFhndDJtcm5RbFpoQ0NvcTlnU1ZiTWlaeGpLL01oR3RSdHhBYThh?=
 =?utf-8?B?bkJnMGVmTWtOM0w3RXlhc2FwUG5GMkFkaUFGVVZwMnVNc0lFdz09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4afe84c0-0120-48bd-6361-08db67fa76e9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6423.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 08:29:24.1132 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ozwqg25F9uXKQWGwzS7CSPW5c7lRPHZdjCy0M7AxAUbwKBu47gSlG1HKfKkWZG4cqvWm+EVpemsrtaO+E6f1Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB7052
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 09 Jun 2023 07:00:46 +0000
Subject: Re: [dm-devel] [PATCH v2 13/16] xen-blkback: Implement diskseq
 checks
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 xen-devel@lists.xenproject.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: citrix.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdW4gMDcsIDIwMjMgYXQgMTI6MTQ6NDZQTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVu
b3VyIHdyb3RlOgo+IE9uIFdlZCwgSnVuIDA3LCAyMDIzIGF0IDEwOjIwOjA4QU0gKzAyMDAsIFJv
Z2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiBPbiBUdWUsIEp1biAwNiwgMjAyMyBhdCAwMTowMToy
MFBNIC0wNDAwLCBEZW1pIE1hcmllIE9iZW5vdXIgd3JvdGU6Cj4gPiA+IE9uIFR1ZSwgSnVuIDA2
LCAyMDIzIGF0IDEwOjI1OjQ3QU0gKzAyMDAsIFJvZ2VyIFBhdSBNb25uw6kgd3JvdGU6Cj4gPiA+
ID4gT24gVHVlLCBNYXkgMzAsIDIwMjMgYXQgMDQ6MzE6MTNQTSAtMDQwMCwgRGVtaSBNYXJpZSBP
YmVub3VyIHdyb3RlOgo+ID4gPiA+ID4gLQlpZiAoYmUtPm1ham9yIHwgYmUtPm1pbm9yKSB7Cj4g
PiA+ID4gPiAtCQlpZiAoYmUtPm1ham9yICE9IG1ham9yIHx8IGJlLT5taW5vciAhPSBtaW5vcikK
PiA+ID4gPiA+IC0JCQlwcl93YXJuKCJjaGFuZ2luZyBwaHlzaWNhbCBkZXZpY2UgKGZyb20gJXg6
JXggdG8gJXg6JXgpIG5vdCBzdXBwb3J0ZWQuXG4iLAo+ID4gPiA+ID4gLQkJCQliZS0+bWFqb3Is
IGJlLT5taW5vciwgbWFqb3IsIG1pbm9yKTsKPiA+ID4gPiA+ICsJZGlza3NlcV9zdHIgPSB4ZW5i
dXNfcmVhZChYQlRfTklMLCBkZXYtPm5vZGVuYW1lLCAiZGlza3NlcSIsICZkaXNrc2VxX2xlbik7
Cj4gPiA+ID4gPiArCWlmIChJU19FUlIoZGlza3NlcV9zdHIpKSB7Cj4gPiA+ID4gPiArCQlpbnQg
ZXJyID0gUFRSX0VSUihkaXNrc2VxX3N0cik7Cj4gPiA+ID4gPiArCQlkaXNrc2VxX3N0ciA9IE5V
TEw7Cj4gPiA+ID4gPiArCj4gPiA+ID4gPiArCQkvKgo+ID4gPiA+ID4gKwkJICogSWYgdGhpcyBk
b2VzIG5vdCBleGlzdCwgaXQgbWVhbnMgbGVnYWN5IHVzZXJzcGFjZSB0aGF0IGRvZXMgbm90Cj4g
PiA+ID4gPiArCQkgKiBzdXBwb3J0IGRpc2tzZXEuCj4gPiA+ID4gPiArCQkgKi8KPiA+ID4gPiA+
ICsJCWlmICh1bmxpa2VseSghWEVOQlVTX0VYSVNUX0VSUihlcnIpKSkgewo+ID4gPiA+ID4gKwkJ
CXhlbmJ1c19kZXZfZmF0YWwoZGV2LCBlcnIsICJyZWFkaW5nIGRpc2tzZXEiKTsKPiA+ID4gPiA+
ICsJCQlyZXR1cm47Cj4gPiA+ID4gPiArCQl9Cj4gPiA+ID4gPiArCQlkaXNrc2VxID0gMDsKPiA+
ID4gPiA+ICsJfSBlbHNlIGlmIChkaXNrc2VxX2xlbiA8PSAwKSB7Cj4gPiA+ID4gPiArCQl4ZW5i
dXNfZGV2X2ZhdGFsKGRldiwgLUVGQVVMVCwgImRpc2tzZXEgbXVzdCBub3QgYmUgZW1wdHkiKTsK
PiA+ID4gPiA+ICsJCWdvdG8gZmFpbDsKPiA+ID4gPiA+ICsJfSBlbHNlIGlmIChkaXNrc2VxX2xl
biA+IDE2KSB7Cj4gPiA+ID4gPiArCQl4ZW5idXNfZGV2X2ZhdGFsKGRldiwgLUVSQU5HRSwgImRp
c2tzZXEgdG9vIGxvbmc6IGdvdCAlZCBidXQgbGltaXQgaXMgMTYiLAo+ID4gPiA+ID4gKwkJCQkg
ZGlza3NlcV9sZW4pOwo+ID4gPiA+ID4gKwkJZ290byBmYWlsOwo+ID4gPiA+ID4gKwl9IGVsc2Ug
aWYgKGRpc2tzZXFfc3RyWzBdID09ICcwJykgewo+ID4gPiA+ID4gKwkJeGVuYnVzX2Rldl9mYXRh
bChkZXYsIC1FUkFOR0UsICJkaXNrc2VxIG11c3Qgbm90IHN0YXJ0IHdpdGggJzAnIik7Cj4gPiA+
ID4gPiArCQlnb3RvIGZhaWw7Cj4gPiA+ID4gPiArCX0gZWxzZSB7Cj4gPiA+ID4gPiArCQljaGFy
ICpkaXNrc2VxX2VuZDsKPiA+ID4gPiA+ICsJCWRpc2tzZXEgPSBzaW1wbGVfc3RydG91bGwoZGlz
a3NlcV9zdHIsICZkaXNrc2VxX2VuZCwgMTYpOwo+ID4gPiA+ID4gKwkJaWYgKGRpc2tzZXFfZW5k
ICE9IGRpc2tzZXFfc3RyICsgZGlza3NlcV9sZW4pIHsKPiA+ID4gPiA+ICsJCQl4ZW5idXNfZGV2
X2ZhdGFsKGRldiwgLUVJTlZBTCwgImludmFsaWQgZGlza3NlcSIpOwo+ID4gPiA+ID4gKwkJCWdv
dG8gZmFpbDsKPiA+ID4gPiA+ICsJCX0KPiA+ID4gPiA+ICsJCWtmcmVlKGRpc2tzZXFfc3RyKTsK
PiA+ID4gPiA+ICsJCWRpc2tzZXFfc3RyID0gTlVMTDsKPiA+ID4gPiA+ICsJfQo+ID4gPiA+IAo+
ID4gPiA+IFdvbid0IGl0IGJlIHNpbXBsZXIgdG8gdXNlIHhlbmJ1c19zY2FuZigpIHdpdGggJWxs
eCBmb3JtYXR0ZXI/Cj4gPiA+IAo+ID4gPiB4ZW5idXNfc2NhbmYoKSBkb2VzbuKAmXQgY2hlY2sg
Zm9yIG92ZXJmbG93IGFuZCBhY2NlcHRzIGxvdHMgb2YganVuayBpdAo+ID4gPiByZWFsbHkgc2hv
dWxkIG5vdC4gIFNob3VsZCB0aGlzIGJlIGZpeGVkIGluIHhlbmJ1c19zY2FuZigpPwo+ID4gCj4g
PiBUaGF0IHdvdWxkIGJlIG15IHByZWZlcmVuY2UsIHNvIHRoYXQgeW91IGNhbiB1c2UgaXQgaGVy
ZSBpbnN0ZWFkIG9mCj4gPiBraW5kIG9mIG9wZW4tY29kaW5nIGl0Lgo+IAo+IFRoaXMgd2luZHMg
dXAgYmVpbmcgYSBtdWNoIG1vcmUgaW52YXNpdmUgcGF0Y2ggYXMgaXQgcmVxdWlyZXMgY2hhbmdp
bmcKPiBzc2NhbmYoKS4gIEl0IGFsc28gaGFzIGEgcmlzayAocHJvYmFibHkgbW9zdGx5IHRoZW9y
ZXRpY2FsKSBvZiBicmVha2luZwo+IGJ1Z2d5IHVzZXJzcGFjZSB0aGF0IHBhc3NlcyBnYXJiYWdl
IHZhbHVlcyBoZXJlLgoKV2VsbCwgaWYgdGhlIGN1cnJlbnQgZnVuY3Rpb24gaXMgbm90IHN1aXRh
YmxlIGZvciB5b3VyIHB1cnBvc2VzIGl0CndvdWxkIGJlIGJldHRlciB0byBmaXggaXQgcmF0aGVy
IHRoYW4gb3Blbi1jb2RlIHdoYXQgeW91IG5lZWQuICBNb3N0bHkKYmVjYXVzZSBmdXJ0aGVyIHVz
YWdlcyB3b3VsZCB0aGVuIGFsc28gbmVlZCB0byBvcGVuLWNvZGUgd2hhdGV2ZXIKcmVxdWlyZWQu
Cgo+ID4gPiA+IEFsc28sIHlvdSB0aWUgdGhpcyBsb2dpYyB0byB0aGUgInBoeXNpY2FsLWRldmlj
ZSIgd2F0Y2gsIHdoaWNoCj4gPiA+ID4gc3RyaWN0bHkgaW1wbGllcyB0aGF0IHRoZSAiZGlza3Nl
cSIgbm9kZSBtdXN0IGJlIHdyaXR0ZW4gdG8geGVuc3RvcmUKPiA+ID4gPiBiZWZvcmUgdGhlICJw
aHlzaWNhbC1kZXZpY2UiIG5vZGUuICBUaGlzIHNlZW1zIGZyYWdpbGUsIGJ1dCBJIGRvbid0Cj4g
PiA+ID4gc2VlIG11Y2ggYmV0dGVyIG9wdGlvbm8gc2luY2UgdGhlICJkaXNrc2VxIiBpcyBvcHRp
b25hbC4KPiA+ID4gCj4gPiA+IFdoYXQgYWJvdXQgaW5jbHVkaW5nIHRoZSBkaXNrc2VxIGluIHRo
ZSAicGh5c2ljYWwtZGV2aWNlIiBub2RlPyAgUGVyaGFwcwo+ID4gPiB1c2UgZGlza3NlcUBtYWpv
cjptaW5vciBzeW50YXg/Cj4gPiAKPiA+IEhtLCBob3cgd291bGQgeW91IGtub3cgd2hldGhlciB0
aGUgYmxrYmFjayBpbnN0YW5jZSBpbiB0aGUga2VybmVsCj4gPiBzdXBwb3J0cyB0aGUgZGlza3Nl
cSBzeW50YXggaW4gcGh5c2ljYWwtZGV2aWNlPwo+IAo+IFRoYXTigJlzIHdoYXQgdGhlIG5leHQg
cGF0Y2ggaXMgZm9yIPCfmYIuCgpIbSwgSSB0aGluayB3ZSBzaG91bGQgc2VwYXJhdGUgZGlza3Nl
cSBzdXBwb3J0IGZyb20gdGhlIG5vdGlmeSBvcGVuCnN0dWZmOiBpdCdzIHBvc3NpYmxlIGEgZGlm
ZmVyZW50IChub24tTGludXgpIGJhY2tlbmQgd2FudHMgdG8KaW1wbGVtZW50IG9wZW4gbm90aWZ5
IHN1cHBvcnQgYnV0IGRvZXNuJ3QgaGF2ZSBkaXNrc2VxLgoKPiA+IENhbiB5b3UgZmV0Y2ggYSBk
aXNrIHVzaW5nIGEgZGlza3NlcSBpZGVudGlmaWVyPwo+IAo+IE5vdCB5ZXQsIGFsdGhvdWdoIEkg
aGF2ZSBjb25zaWRlcmVkIGFkZGluZyB0aGlzIGFiaWxpdHkuICBJdCB3b3VsZCBiZQo+IG9uZSBz
dGVwIHRvd2FyZHMgYSDigJxkaXNrc2VxZnPigJ0gdGhhdCB1c2Vyc3BhY2UgY291bGQgdXNlIHRv
IG9wZW4gYSBkZXZpY2UKPiBieSBkaXNrc2VxLgo+IAo+ID4gV2h5IEkgdW5kZXJzdGFuZCB0aGF0
IHRoaXMgaXMgYW4gZXh0cmEgc2FmZXR5IGNoZWNrIGluIG9yZGVyIHRvIGFzc2VydAo+ID4gYmxr
YmFjayBpcyBvcGVuaW5nIHRoZSBpbnRlbmRlZCBkZXZpY2UsIGlzIHRoaXMgYXR0ZW1wdGluZyB0
byBmaXggc29tZQo+ID4gZXhpc3RpbmcgaXNzdWU/Cj4gCj4gWWVzLCBpdCBpcy4gIEkgaGF2ZSBh
IGJsb2NrIHNjcmlwdCAod3JpdHRlbiBpbiBDKSB0aGF0IHZhbGlkYXRlcyB0aGUKPiBkZXZpY2Ug
aXQgaGFzIG9wZW5lZCBiZWZvcmUgcGFzc2luZyB0aGUgaW5mb3JtYXRpb24gdG8gYmxrYmFjay4g
IEl0IHVzZXMKPiB0aGUgZGlza3NlcSB0byBkbyB0aGlzLCBidXQgZm9yIHRoYXQgcHJvdGVjdGlv
biB0byBiZSBjb21wbGV0ZSwgYmxrYmFjawo+IG11c3QgYWxzbyBiZSBhd2FyZSBvZiBpdC4KCkJ1
dCBpZiB5b3VyIGJsb2NrIHNjcmlwdCBvcGVucyB0aGUgZGV2aWNlLCBhbmQga2VlcHMgaXQgb3Bl
biB1bnRpbApibGtiYWNrIGhhcyBhbHNvIHRha2VuIGEgcmVmZXJlbmNlIHRvIGl0LCB0aGVyZSdz
IG5vIHdheSBzdWNoIGRldmljZQpjb3VsZCBiZSByZW1vdmVkIGFuZCByZWNyZWF0ZWQgaW4gdGhl
IHdpbmRvdyB5b3UgcG9pbnQgb3V0IGFib3ZlLCBhcwp0aGVyZSdzIGFsd2F5cyBhIHJlZmVyZW5j
ZSBvbiBpdCB0YWtlbj8KCj4gPiBJJ20gbm90IHN1cmUgSSBzZWUgaG93IHRoZSBtYWpvcjptaW5v
ciBudW1iZXJzIHdvdWxkIHBvaW50IHRvIGEKPiA+IGRpZmZlcmVudCBkZXZpY2UgdGhhbiB0aGUg
b25lIHNwZWNpZmllZCBieSB0aGUgdG9vbHN0YWNrIHVubGVzcyB0aGUKPiA+IGFkbWluIGV4cGxp
Y2l0bHkgbWVzc2VzIHdpdGggdGhlIGRldmljZXMgYmVmb3JlIGJsa2JhY2sgaGFzIGdvdCB0aW1l
Cj4gPiB0byBvcGVuIHRoZW0uICBCdXQgdGhlbiB0aGUgYWRtaW4gY2FuIGFscmVhZHkgZG8gcHJl
dHR5IG11Y2gKPiA+IGV2ZXJ5dGhpbmcgaXQgd2FudHMgd2l0aCB0aGUgc3lzdGVtLgo+IAo+IEFk
bWlucyB0eXBpY2FsbHkgcmVmZXIgdG8gZS5nLiBkZXZpY2UtbWFwcGVyIGRldmljZXMgYnkgbmFt
ZSwgbm90IGJ5Cj4gbWFqb3I6bWlub3IgbnVtYmVyLiAgSWYgYSBkZXZpY2UgaXMgZGVzdHJveWVk
IGFuZCByZWNyZWF0ZWQgcmlnaHQgYXMgdGhlCj4gYmxvY2sgc2NyaXB0IGlzIHJ1bm5pbmcsIHRo
aXMgcmFjZSBjb25kaXRpb24gY2FuIG9jY3VyLgoKUmlnaHQsIGJ1dCB3aGF0IGFib3V0IHRoaXMg
ZGV2aWNlIHJlY3JlYXRpb24gaGFwcGVuaW5nIGFmdGVyIHRoZSBhZG1pbgpoYXMgd3JpdHRlbiB0
aGUgZ3Vlc3QgY29uZmlnIGZpbGUgYnV0IGJlZm9yZSB0aGUgY2FsbCB0byAobGliKXhsCmhhcHBl
bnM/ICBibGtiYWNrIHdvdWxkIGFsc28gZW5kIHVwIHVzaW5nIGEgZGlmZmVyZW50IGRldmljZSB0
aGFuCmluZGVudGVkLCBhbmQgeW91ciBwcm9wb3NlZCBhcHByb2FjaCBkb2Vzbid0IGZpeCB0aGlz
LiAgVGhlIG9ubHkgd2F5IHRvCnNvbHZlIHRoaXMgd291bGQgYmUgdG8gcmVmZXJlbmNlIGRldmlj
ZXMgYnkgVVVJRCAoaW93OiBkaXNrc2VxKQpkaXJlY3RseSBpbiB0aGUgZ3Vlc3QgY29uZmlnIGZp
bGUuCgpUaGVuIHRoZSBibG9jayBzY3JpcHQgd2lsbCBvcGVuIHRoZSBkZXZpY2UgYnkgZGlza3Nl
cSBhbmQgcGFzcyB0aGUKbWFqb3I6bWlub3IgbnVtYmVycyB0byBibGtiYWNrLgoKVGhhbmtzLCBS
b2dlci4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBz
Oi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

