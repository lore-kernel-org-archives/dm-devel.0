Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6C3CC7EE43
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 07:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686294055;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FyllDjAjEJKGhCa4CNzU6mAuG9QQZ/d/smKHEFO/G28=;
	b=Yfp6SXOrC+LjdF9P60wzJZ2QEj/S+Qol/gMsdREbLH7rADwRaG7+dYcrVr0zIUpAKKT1dK
	IXc9kfrguR0DONzVWfuLNCwG4FAGWYmWp5JMN2VEjxfWsEII8jOvWoHSCcSJOgQa/RcwQL
	Zpxz8QRYVPj91XI5y+J4pcMOZafX8sA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-z278XlG4ObiPqmtdbMzAsw-1; Fri, 09 Jun 2023 03:00:52 -0400
X-MC-Unique: z278XlG4ObiPqmtdbMzAsw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28A25100AF70;
	Fri,  9 Jun 2023 07:00:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12F0C400E6C6;
	Fri,  9 Jun 2023 07:00:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5FA0319451C0;
	Fri,  9 Jun 2023 07:00:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 69EA1194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 10:09:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 23E8BC16044; Thu,  8 Jun 2023 10:09:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AC90C1603B
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 10:09:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E64F938035B7
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 10:09:08 +0000 (UTC)
Received: from esa5.hc3370-68.iphmx.com (esa5.hc3370-68.iphmx.com
 [216.71.155.168]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-e0rkD2HPMeyuBHjVJCmSbQ-1; Thu, 08 Jun 2023 06:09:06 -0400
X-MC-Unique: e0rkD2HPMeyuBHjVJCmSbQ-1
X-IronPort-RemoteIP: 104.47.55.168
X-IronPort-MID: 110793610
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:PNFkOasfGyImZBJ8qKAPs1rQ8OfnVBReMUV32f8akzHdYApBsoF/q
 tZmKTiDM6uCYGemLogiaYvjoR8FuZDVy9JgQQY6+yg1Fn8R+JbJXdiXEBz9bniYRiHhoOCLz
 O1FM4Wdc5pkJpP4jk3wWlQ0hSAkjclkfpKlVKiffHg3HVQ+IMsYoUoLs/YjhYJ1isSODQqIu
 Nfjy+XSI1bg0DNvWo4uw/vrRChH4rKq4Fv0gnRkPaoQ5AGGxyFMZH4iDfrZw0XQE9E88tGSH
 44v/JnhlkvF8hEkDM+Sk7qTWiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JFAatjsB2bnsgZ9
 Tl4ncfYpTHFnEH7sL91vxFwS0mSNEDdkVPNCSDXXce7lyUqf5ZwqhnH4Y5f0YAwo45K7W9yG
 fMwIRkGSSivxO6K2rucZNFswcIxfdnuM9ZK0p1g5Wmx4fcOZ7nmGv+Pz/kImTA6i4ZJAOrUY
 NcfZXx3dhPcbhZTO1ARTpUjgOOvgXq5eDpdwL6XjfNvvy6Pk0osjf60boq9lt+iHK25mm6Co
 W3L5SLhCwwyP92D0zuVtHmrg4cjmAuiAdpNRebmr6YCbFu731A1EC0ZXEaB/uScgGTuaoJSe
 k8tw397xUQ13AnxJjXnZDW0rXuFlh8aRdtLEuc+5R2Ny6zb+AKQDC4PSTspQNU2vsg7bT8nz
 FmEm5XlBlRHubKWYWiQ+redsXW5Pi19BXQEZDMWQBEt4NT5pow3yBXVQb5LHKvwgtDrFDXY2
 T2GrCEiwb4UiKYj0qyh+FndjjGEp57XTxU07AHaQmKk6AxiYIevIYev7DDz6fdGMZbcRF2Gt
 3sshceT9qYNAIuLmSjLR/8CdJmt5vCYIHjfjERpEp0J6Tug4TigcJpW7TU4I11mWu4UdDmsb
 ELNtAd54J5IIGDsfaJxe5i2Cckh0e7nD9uNaxzPRt9HY5w0fgnX+ihrPBSUxzq0zhhqlrwjM
 5CGd8rqFWwdFals0DuxQaEazKMvwSc9g2jUQPgX0iia7FZXX1bNIZ9tDbdERrlRAH+syOkNz
 +tiCg==
IronPort-HdrOrdr: A9a23:/dJHcqHbEErhENDQpLqEL8eALOsnbusQ8zAXP0AYc20yTiX4ra
 CTdZEgviMc5wxxZJhNo6HkBEDiewKkyXcW2/hoAV7KZmCP1wWVxelZnPDfKlbbaknDH4BmpM
 BdWpk7JefcSX5dpq/BjDVQFexL/PC3tJqFv6P16VBDbS9XUIlczyFfTjy2LyRNNWp7LKt8G5
 qY6tBGtDa7EE57Uu2wGmMZWezOvP3n/aiWAyI7Ow==
X-Talos-CUID: =?us-ascii?q?9a23=3AV3cNDmj2Ji0gM7Pl5084p9xs7DJue1TW60/8YEO?=
 =?us-ascii?q?EE29OZoWVDlmCqbNhnJ87?=
X-Talos-MUID: 9a23:lYx+8wqvJzawk7HAK4AezyheEt9Y7K2zMh8QtJ8s6/jUOH1zAg7I2Q==
X-IronPort-AV: E=Sophos;i="6.00,226,1681185600"; d="scan'208";a="110793610"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO
 NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
 by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 08 Jun 2023 06:09:04 -0400
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com (2603:10b6:a03:38d::21)
 by DM6PR03MB5291.namprd03.prod.outlook.com (2603:10b6:5:229::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 10:09:02 +0000
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd]) by SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd%3]) with mapi id 15.20.6455.028; Thu, 8 Jun 2023
 10:09:02 +0000
Date: Thu, 8 Jun 2023 12:08:55 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZIGot1mn+lChK4q8@Air-de-Roger>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-17-demi@invisiblethingslab.com>
In-Reply-To: <20230530203116.2008-17-demi@invisiblethingslab.com>
X-ClientProxiedBy: LO4P123CA0113.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::10) To SJ0PR03MB6423.namprd03.prod.outlook.com
 (2603:10b6:a03:38d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6423:EE_|DM6PR03MB5291:EE_
X-MS-Office365-Filtering-Correlation-Id: 405d24ae-cdaa-4f0a-f8ef-08db6808620f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: 4V237diHWQAFu6s3XWs6gwdUyJG3RdOh0i0aujbf7hjd6Sg+VtaVI2OPleX29zBnDlXDtrbHofno/ddkhB9U81G82Kh0hhuWhjJzKLwIvtXG9wCMKCjy/Ly81VN+nLJpH9PLAhLhkqUxbJjeUlkonssp62HvR+vzvvndtpQzpRydTF1eVhAuZc2eRRezoQYXP1dvsJO0aqS4Hi5stm+BpHbr/7TY8I8ziY6Rkj4pZyY9RPCr5VmIQr4VWMPdcMZpzS8zlzZ1+hLof3fnwtqiEEOW248j9YOHsp8Z7utl+e/ksBmEzCvBdmfovRbDcQiGUWOcH5HrP4TTLitEUeBoGSQLjNjtcQ++YJbSaFZlSxYPZZTHP5cM7cUoxwrCtG+wGeU/BaU/AtXJkl2YPlj5LgC6VryAtl6npLhpaRPBwPARztMrmW7ELlpZqoCA4iQbfR7W9OIwE4zjb/fyZgJ7GpIym2PPXDpqOXbWGnk5LQNfdzuc+r9xRNnRvgMc9fRsgw/gL0Ko26K9QYacxLNnMSHEIDnyNLfaCu8CWbx7BLBInMPZ8WOcU5u4wRGnd2gVo8ZypSJmEvVtTyEYYISvM1pHH03B7a+ba7VfDLW2cuo=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR03MB6423.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(7916004)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(6512007)(9686003)(6506007)(38100700002)(41300700001)(6486002)(6666004)(26005)(186003)(83380400001)(478600001)(54906003)(66476007)(4326008)(82960400001)(316002)(66946007)(8676002)(66556008)(6916009)(8936002)(2906002)(33716001)(5660300002)(86362001)(85182001)(67856001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUZaWnVKTnpLTFcxTzhtK25rS042RDMwMzFxY3N4bDVhYzg5MXZlaTZhVDJv?=
 =?utf-8?B?dHgxM0ZiSVQ0dDY2c2Y1R2ZKV0Y0VEFrUFNRZmtEd0c4bEJhRDRxVWhRRG43?=
 =?utf-8?B?dEgvcWVyRGx0eU5vdUYvUUorMVJ1QlJIa1lSMERSOXQ3NzhheGZlS2hnNHBl?=
 =?utf-8?B?dnFudkwweXdCK2JkU0J1NWJQZWNXakNLREdOOFhCQ3JaeDBzZXZkOVBZVDd4?=
 =?utf-8?B?Nk9pN00wTDRkZXZVZ2ptUVpPWkFlR3V3M2pRU2lZcmlFbkQ0bEkycEJsNW1O?=
 =?utf-8?B?citqNzQ3TzFiNXB4WnpOR25JQmtpZ3FmL2llMlZsd0cyQlFGVmwwY0tXWFRU?=
 =?utf-8?B?NE41Y0h3bGtDYXFsMVYzUTFsdTVwMHZJVTYySHdxbk5sUlMwdEt4emp1N2Jt?=
 =?utf-8?B?bkNMS1gxZzl4SytmQ21xODk4V3czcHd4dmNDOXVxVnRpV2N1bHp1Nmpvai9z?=
 =?utf-8?B?NXlxck4yMGxJRlJ3VUhKUWZrS0dYQjZEemVwaWE2bU1oQ0Y0ZmNkbUIzcGpv?=
 =?utf-8?B?dWFDTVJwZUxFdnBZVUJSaFZqdlJrYTJxN2JuaHh1WVh0YTZEUWFmNTY3NWs0?=
 =?utf-8?B?NGcyU1lDZ1dZd1d2NmcxaVZpbUFJUjVaWVcrQlMyRDh1NFY5L3pFYkFacThh?=
 =?utf-8?B?TVVUV2NqMFhpRkcvMGVLM25VeWRNZG45YXR3SUV2bTZKTndROTJzNy9pR1l3?=
 =?utf-8?B?ZWNlK1lsZGJNaWdhR1M2dlFZL3hMUTZFQXZQcm1vRlY3MnFNR25lRDN4QlRO?=
 =?utf-8?B?UCtEZUR5ZGFWSVF5Tnp6ZFFnQmNXQjRvVkl1UTVud2ZQeUN3QklpZnpwNHgx?=
 =?utf-8?B?ZXo3cFhxNVFEZkFwczhGbm5YamRRSmZIMzNXelZGdmdoOHl0Vkc1VG0zUlhx?=
 =?utf-8?B?QUJ1NHg3WmhlN1hQczd4eFFrU1R2WWdQbjVCQ3N0SXlvZ0F5QmVialJ3cG8x?=
 =?utf-8?B?WENGeEhtUXJYMXpKQ1lzRGZPZmlsYUhRMld5MmJkbHBSc1VyMFNacUxGM3h0?=
 =?utf-8?B?cmk4VWhwdW9hNDJRRmpsV0dRbk1ZSjFaRWNMbVloQ2h0RnU5NkQ2enNwNzAx?=
 =?utf-8?B?M2krWnM3ODdFT1VFTFVpQ2pLTnlmU2tFdXVjZkV4ZVFwZXV6YVNSaEMyWjBq?=
 =?utf-8?B?bW8vZFY4T2Vkcmk2RHIxUTBxbnpPSld3Mk1tOGdyMTJndVRMemhFOVRCZDFB?=
 =?utf-8?B?Z0ZLQlJvRUo1elVlT3NuaWtWMjZkOGRDWDZGR1lSZlZ3L2JqdUhTSGZEUVVG?=
 =?utf-8?B?Tmw3aTlpU0w2dDMydEZ3Zmh4V2dEbUEyOFJlWENDOXdNTjg2aUJ6Zmlhemww?=
 =?utf-8?B?WkFXZG92Q3h4UTFvSVplNmxEN1puNnBmRjc4NzdVS2V1aHhTcHJRV1hPbnhu?=
 =?utf-8?B?ZEw0VmFUQ0d2elRoQ2lhMXREZ0d6S0xyOUNtY2NXZW5iUCtBanFvTW12STRP?=
 =?utf-8?B?Z2xCVUVBVzQwMkdYMHNaVDNKOTJBVzNVdldhbUpNUTcvN0VOaEZTRTlmQUtG?=
 =?utf-8?B?LzZVWEhyaXRwdkxsSm9vWTNUd1g0Tll5NkxwcjM1V3NhUGxhVjFtMlhJeWpM?=
 =?utf-8?B?cU93aThOdVd2NHl5MXpHNGxFclVkazJZVElPTEVZdS8wcWdMYVp5UnFoNnpB?=
 =?utf-8?B?Zm01d3lNK0FFZFRZQVRQTGxteDVYekFUWTlIWVdvZnk4Mnp5emFFUkJENUZz?=
 =?utf-8?B?ekhwYXFJZ09BZ0IxeGVGSXdwbUVaNEh3ZTd4dFkwaDlLa1RMSVhtSzhDQUJM?=
 =?utf-8?B?NDhjYnpqTmVCWVU4WDl4aHVxamN5eDBwMU5DeklvYUtTazlCbXFOUlQyNTBj?=
 =?utf-8?B?N0pZQXIxNW5YOCt2Yy9xdndMR2ExbXduamk1SGd1dUxaNGtnTkhUUmpiUjJx?=
 =?utf-8?B?Z0dVa0YyODIvR0JnWm1DZFpoenR6TWVLc0ZhNVVRb1RqSHh2a1FBZnlTNVNG?=
 =?utf-8?B?azFNTDZpZ0RMRTUzVW9YZGV1aUdNdGtJK0ZCU2dqZzhsTmVKekR1eVUvZVJR?=
 =?utf-8?B?dFZCcFB1MzYwZzcwdXBpKzRlTVZMdmkzUndSbVRaYkc2RThmWGt0NEMvTnZm?=
 =?utf-8?B?MlNQNVJWWi9PUFRadGhGa0RGNE11RURsNjJOUk9HMTJmRVZEbUdJK29MZDg5?=
 =?utf-8?B?ZGlvSDhRdUxxZm8ybFFaQ09vcnhUYW9mM0V3Y3FkMUJFM1FnSHVGeHlFUWtR?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bTdyOFNMVDdtU3RPTDNiTHVsYnNzQURrNjZzU205MWo1V0g0WDBSdzYrc3B1?=
 =?utf-8?B?UFBxZjNmdG91S1REZEJ6QlQrT3Q3aEM0NkRxdEhvcWNIQnkzREVwRTMzSUhD?=
 =?utf-8?B?WGU4dkNubm9SMDRRMldURndpd2Z4ZEUxS2Y3NGw2R3Z5VVVVR0FIbTRNNnJ0?=
 =?utf-8?B?eFhYVHV0U2ViQzBLM3pWWW5KUm9NVzFCekk0RUZsang4OGV6Y3cxMGIyNmVV?=
 =?utf-8?B?dFhnRlVISXptWEZkdWNCQ1pFZVU1YWJudTBEOGh0alZCUHdySzZUUFVaRDcw?=
 =?utf-8?B?a1pjZUxTOUVJdHEyblpMU0RFSThFd1F4cGprWlpoRnRKZFlPT2lsck9ud0V5?=
 =?utf-8?B?NlhybGJxQlpVQ1U0elpTZWh5aG9EUmxucUZ5aGNtdWcvb0E0bFcyVnROemVw?=
 =?utf-8?B?OW5WNzhocGJNSzB3TXlHNHViZmpYakdLSUlkcU4zSDgzMDg1cnNxUzNNUE5O?=
 =?utf-8?B?Qm14eEpOR0tQaWhLd0l0ZVEwaGVNUys0N3F5Wkc4QVhOQjhKZEx1eU14NHR2?=
 =?utf-8?B?OUFDVlBBMXd1dFU3V1NacUhoK1JWanRtMWYyMWxIOTJQa3M2enlacVZSdHpG?=
 =?utf-8?B?YzliUkt3NGttSHlDTUhZTys5R04vOUowSkdXWStBclFldjJOQmxmTWtoZXNs?=
 =?utf-8?B?M0wzVU9HNnpVUjg4NUF2NGJOSmtLRnRYbWE1WHlwTjFwSFQrYy9NRk1YdVpC?=
 =?utf-8?B?Z0xrMG5EbEYwSFlNTDlXNWN2alUxdXdxYXZBaXlwZ0V5Smsxd0t3a0RuVkor?=
 =?utf-8?B?VHFLKzdOUXcwTmptdmRJZUZBV3BTcDIxaVMxNmhPbGxmQWYrazFuM0RCczJD?=
 =?utf-8?B?dENRQXJJeER1K3VOdVIrbjNNOCtReitFcjJ6Z1NPbjh2ZTRtY3VLNjVkY0Uy?=
 =?utf-8?B?emsxcm0vRC9rQ2JXc1ExL3dVZENQa3ZrZzU2TE5adDlwd2tHWlFqZ2FyYVlj?=
 =?utf-8?B?N21GRmI3VWNLNEpTTGN3YVc1ZTlucW1hUk1GWkROYnlGcVF1a2NsNzNaQU04?=
 =?utf-8?B?UlVtcVhZc2MreExPTVBLSllWREIxNnVDR2hxUWlVQWczV2NjMnQ5ak9DVkpz?=
 =?utf-8?B?TE43UTI2cE1SbTlWUE5zM1IxeVcxVGxweDdBTVI1c1FrTXNyd2k5RjE3bUMy?=
 =?utf-8?B?QlhDOGwyZi9VdXVpeC9tUEMwYUlyR1dyZExWOHN2bmJ0SnViQWh6dHdvYm12?=
 =?utf-8?B?eTZoZnI5RHREMWdodk45MWI5U2Vrb0FFTVR5WFpIc3cvejN1bkV5RGhjeHZx?=
 =?utf-8?B?SWhQVjhwNG1PRlNsUElNenZBWlNYTEQyY1RqcE5USXNTSXBYUT09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 405d24ae-cdaa-4f0a-f8ef-08db6808620f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6423.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 10:09:01.9910 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3lCGQazFV4igjyPs3o7iPz4lopdzhhmn5X7rgjYOjddc6kvZr/NjRRMGHxsFaVI9vCMMfXpCAHfgECEjJRuyQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5291
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 09 Jun 2023 07:00:46 +0000
Subject: Re: [dm-devel] [PATCH v2 16/16] xen-blkback: Inform userspace that
 device has been opened
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: citrix.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 30, 2023 at 04:31:16PM -0400, Demi Marie Obenour wrote:
> Set "opened" to "0" before the hotplug script is called.  Once the
> device node has been opened, set "opened" to "1".
> 
> "opened" is used exclusively by userspace.  It serves two purposes:
> 
> 1. It tells userspace that the diskseq Xenstore entry is supported.
> 
> 2. It tells userspace that it can wait for "opened" to be set to 1.
>    Once "opened" is 1, blkback has a reference to the device, so
>    userspace doesn't need to keep one.
> 
> Together, these changes allow userspace to use block devices with
> delete-on-close behavior, such as loop devices with the autoclear flag
> set or device-mapper devices with the deferred-remove flag set.

Now that I think a bit more about this, how are you planning to handle
reboot with such devices?  It's fine for loop (because those get
instantiated by the block script), but likely not with other block
devices, as on reboot the toolstack will find the block device is
gone.

I guess the delete-on-close is only intended to be used for loop
devices? (or in general block devices that are instantiated by the
block script itself)

Thanks, Roger.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

