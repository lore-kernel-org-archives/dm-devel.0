Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB1EDC77B73
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 16:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685551465;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ybQWJaw9FAwr6/y8+uApGWGr4beYTW4HgLHqMyVYZPw=;
	b=XC0kWhDwAfF/vhbuPl43JQwzjKiJNk8+lQXPYvpy6FdZZikQWfZ1AWekQTeZcK9U8qKuXD
	JNcgbPrRviPY/UfLVwWD4hIs5yV+vKsOjsabP0+Jx1x1m98CTb3xphe8ybY6SACtJlyeBZ
	SqFtQPLO3WRkpevbolQViMQWrs0u9L0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439--WGfw1LvOyqg3Kv3HFPd2g-1; Wed, 31 May 2023 12:44:23 -0400
X-MC-Unique: -WGfw1LvOyqg3Kv3HFPd2g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9FE81C09053;
	Wed, 31 May 2023 16:44:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1CCA940C6EC4;
	Wed, 31 May 2023 16:44:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ECAD219465B6;
	Wed, 31 May 2023 16:44:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 49F3C1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 16:28:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2C854492B0B; Wed, 31 May 2023 16:28:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 245C2492B0A
 for <dm-devel@redhat.com>; Wed, 31 May 2023 16:28:47 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 054588007D9
 for <dm-devel@redhat.com>; Wed, 31 May 2023 16:28:47 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04on2040.outbound.protection.outlook.com [40.107.7.40]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-wDBG49BnPkq8Bnx-gdBGoQ-1; Wed, 31 May 2023 12:28:45 -0400
X-MC-Unique: wDBG49BnPkq8Bnx-gdBGoQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DBAPR04MB7383.eurprd04.prod.outlook.com (2603:10a6:10:1b3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 16:28:42 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:28:42 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 5/5] multipathd: don't assume mpp->paths will exist in
 need_switch_pathgroup
Thread-Index: AQHZk9z2KbbT8YdkxESp1uv342TLxg==
Date: Wed, 31 May 2023 16:28:42 +0000
Message-ID: <bf7e213a0a838e04e56ce2d4930dbcaa5c34072d.camel@suse.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684970472-28669-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DBAPR04MB7383:EE_
x-ms-office365-filtering-correlation-id: de926afb-6793-49c2-5bc5-08db61f41900
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ubyRaPXHFW2SkXbi4dx0AsWPA0xc+NIjWITM3jdBDsmrWsQMTM4+Ery3V/tbjEBYX3tpb4RIfc54SGsujZ+4jRGKqjt3RYXJRyWCwyHGvgqpm/VHSGI07SpML3g8Y8YXLvH9XgwepdIiGfTED6bao8OFyTu+M5eCOV1I9xqFE1FN9TTy8RuTkwVJc/RTo1qujCjy1w8p6URsJem7v7/xQkMetBKvv6qlvIP7ijGg5PCwHHX1muq9cOleqEjtqZfwk/eyDbu81GhXjsa4WX4ZpM/RWvsdLjvBh8GDVSAdgJwTf31Ekmwebo3rtyEzmV9WSOpYm8kZv4NurUF2Xd0RFjmYf7UM9BS+PtGkM14Vqk5DiZ4lDM4YHHfqeH9ws5azJ+YVCa1Eb5i5mVpvUh1JNonPYVTTnz/aNpHcE7rRb53WaUYfqgovEDTx0oCz/rJXLvelQF1DJEidUElq8cfmovl6+yedBmPKikZK+otrInD+YwUGyaDIRr596WFwKCHKxm/4XNKw/58M1pzbkzpPUJ2L29tc1e7PLXhQ5g+oHRZHR25d+v7Uq0ZQ72A1u4oUBETzxPLyYyZhx66jHHR2bnUsZhSXDb4z28+mim6Nz726wR3MrkVKMyoYuzmYr53nvbWW67nD03lfkFGTGMoveQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39860400002)(366004)(136003)(346002)(396003)(376002)(451199021)(26005)(38100700002)(41300700001)(6486002)(186003)(83380400001)(6512007)(6506007)(2616005)(478600001)(110136005)(71200400001)(8936002)(122000001)(66446008)(64756008)(66476007)(66556008)(66946007)(91956017)(4326008)(316002)(5660300002)(76116006)(8676002)(44832011)(4744005)(86362001)(2906002)(38070700005)(36756003)(178253001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?WuSfeATN1MwNSh06K/y6hIwPQhMCCqDAHnhgcCgmX4YjxRb9izBdrpwVv?=
 =?iso-8859-15?Q?2L9DbjH+QE821QdtaOapjMBkewAqZ7Sq8hwweU1ebeuQitmwOGHYgWpOq?=
 =?iso-8859-15?Q?Cm4mI13dwuFvLnUo0s6DY7uZDLhtqn5jXO8yCEJy+QU48YglEyE0/OQSK?=
 =?iso-8859-15?Q?ta86gq/DGw6trU6rfOVPAn/NMfejvvY+HU5ZFUgfc92z4u3GbgOG/xZ72?=
 =?iso-8859-15?Q?fOf7qoQZsdE0S953IbRpdDNQ62FlAe/3NpZ/Ptu31UOK4tvwMHTqgeKEy?=
 =?iso-8859-15?Q?zw4yEsQNl8VZm31BpoSLjNv7/OmK5aPN5F/tJhQKJErR7h/PrZgzEnT4z?=
 =?iso-8859-15?Q?KAV5zA298yMbV7Gbh+9Ft99FtiEPohWQesw8uHnEFlr3IswBoO5/Tb9MD?=
 =?iso-8859-15?Q?Qj8m8kd9lvKQbgQkFGmfPVSCtmPVk0DYv9V8SsMr3zXddHJyzXpW189I3?=
 =?iso-8859-15?Q?zok54mbzGlTQnuaO5ofLMUxqniB9RIcT5pBot0DtcsN4TkCoaYVBOe66l?=
 =?iso-8859-15?Q?QegFPGcfDqDH8eVAyNfezZFlGPZ4lk2Cx3zQe3mLT2ACPzGmjrOm2Ua9c?=
 =?iso-8859-15?Q?P4HqS8YdMh4TNgtYSiiS2AdxooBHca9yl5RGTSyOSu3c8ASetkvNZ23rT?=
 =?iso-8859-15?Q?3sSjQfUnGr3NO4rDPIy6URkg5Tgcgkd0NtpLVzlswkXPgFRKDu/gxBiij?=
 =?iso-8859-15?Q?ulyKU19nsVit0zeVFABfWrss0BwN7tr7wgmoi/hcv6+ZzYzUFsJ7k74HA?=
 =?iso-8859-15?Q?0kLKRxsNHIYgliE/piy8JFQnDxIORnU5Hu2k0laYsZgrmn2GyaKhul9rg?=
 =?iso-8859-15?Q?5GwEeSCkaUR/YVckQbNbggfiEVBkT1eFmF0J30c1bI7T32gB8HLEYKj8N?=
 =?iso-8859-15?Q?5g2KbNRJ8wacIdboHrEM7kK8AKv4XFAVepKbnn812eyd52iywUa3CPbGa?=
 =?iso-8859-15?Q?XPRNPahDHYVxBKDHrva8jgEZ7unP97OQ1BQ5DdV1xzlSWmhZMioyOwNfj?=
 =?iso-8859-15?Q?9IOXqOKxtPuW1P8RrntOD+haxWq3EZnbxQ5TqaXw9YHoeIGF/1s/NsCsH?=
 =?iso-8859-15?Q?RN4K2Qc0dalmhxghmFT5H9RxErBZCuxtLGwat22kOAX7P3hjNIcEy8YnH?=
 =?iso-8859-15?Q?xy8i3fOoWyknP0GdNsS8go6DuTo5BLTEBg2kuOAMnq7SUuWoyWdJMotKE?=
 =?iso-8859-15?Q?Lr+aFv7j8wWlZloNDA1GCCVg2/fRGln8bzrs7WHAcV+inYOY+E80iGj4L?=
 =?iso-8859-15?Q?Oe1/+x/5ZHxFWDfrRxZ53ircmjej71vwuN0Xx9c51tP4KRXAReZz0znQU?=
 =?iso-8859-15?Q?YEqSUKUFPHMxZQPPl1sVQc4K8QsnLVHVJykFwSMWjy1G28wfvW9l/1X60?=
 =?iso-8859-15?Q?w1TGqmxZa/PvSW8ZWAvQgMTZrITxbRcm5Rj+fz0bz5kAAXl/E/FvJbXA6?=
 =?iso-8859-15?Q?w3EB8ge/28m2jp74PxVwEE2D0pgEYPuusieGh+tD9E5Xvxb3UDb8S7Oew?=
 =?iso-8859-15?Q?oEEd+rQfwO90LIgrDrPVAKSBCCbSFek0Vh0noq1wXp4diAEJIh6rL0ApT?=
 =?iso-8859-15?Q?E43Qm/8vqe1aiD2DO7JeA9RzVSHIdS4t+ldbSzNAJLl2wxuLurQ5kjh0Z?=
 =?iso-8859-15?Q?vHTjOR0NII2q6/6COnR//UcaBD8EMsP6aRhHQCya0mzIgX8vNCWaOCe/Q?=
 =?iso-8859-15?Q?22IRGqwaR0sLgJokf2GryKE8Ww=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de926afb-6793-49c2-5bc5-08db61f41900
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 16:28:42.2004 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vqstaL/vj2+jmi3F1AqryBzIMkUG+d0zazplZ+MQzmEhF3eBIOUeo2yxWX2TaqlEyzrxUdwyn1mKdEJ/KOp3+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7383
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 5/5] multipathd: don't assume mpp->paths will
 exist in need_switch_pathgroup
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <2E4E89DB7CF706438DB2867372D33257@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> When need_switch_pathgroup() is called by deferred_failback_tick(),
> there is a chance that mpp->paths will be NULL, even if there are
> paths
> in the multipath device's pathgroups. Instead check if there are
> multiple pathgroups, since multipath can't be using the wrong
> pathgroup
> if there is one or none.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

