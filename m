Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB262C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 07:02:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-q_BDzID1OIaiN384OO6VXw-1; Fri, 20 May 2022 03:02:09 -0400
X-MC-Unique: q_BDzID1OIaiN384OO6VXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90EDB3C01B88;
	Fri, 20 May 2022 07:02:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7AB461121319;
	Fri, 20 May 2022 07:02:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 25C9B194EB86;
	Fri, 20 May 2022 07:02:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 93AFE1947042
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 13:19:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 709E1C27E92; Thu, 19 May 2022 13:19:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AC3DC27E9D
 for <dm-devel@redhat.com>; Thu, 19 May 2022 13:19:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F20C101AA44
 for <dm-devel@redhat.com>; Thu, 19 May 2022 13:19:03 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-JNb-kcyFNx-RIs5jneEjrQ-1; Thu, 19 May 2022 09:18:55 -0400
X-MC-Unique: JNb-kcyFNx-RIs5jneEjrQ-1
Received: from SN6PR06MB4495.namprd06.prod.outlook.com (2603:10b6:805:92::24)
 by MN2PR06MB5456.namprd06.prod.outlook.com (2603:10b6:208:c7::28)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Thu, 19 May
 2022 13:18:53 +0000
Received: from SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::397c:6fd3:92be:8efe]) by SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::397c:6fd3:92be:8efe%3]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 13:18:53 +0000
From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To: Martin Wilck <mwilck@suse.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Thread-Topic: [PATCH 4/9] multipath-tools: add NetApp E-Series NVMe to
 hardware table
Thread-Index: AQHYZ+aiCmhVT7meYkS+M9Uf6jWdcq0lGSiggADdKACAADswwA==
Date: Thu, 19 May 2022 13:18:53 +0000
Message-ID: <SN6PR06MB44955631FFA648B74BB939318CD09@SN6PR06MB4495.namprd06.prod.outlook.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
 <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
 <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
In-Reply-To: <e014a5ee6e313404bb4d1d29c1cd4791f9660c5e.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60fe9879-0233-4c50-4bbe-08da399a1f04
x-ms-traffictypediagnostic: MN2PR06MB5456:EE_
x-microsoft-antispam-prvs: <MN2PR06MB5456A58740AEDC2615406B798CD09@MN2PR06MB5456.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: APMnPjXJg0nh62rytInfthPAfYrwV1iLRSNbvBSpnW9PUzJyuR+ZZrx0OniSbZIYIv9j8FowuTM6projGBTBIAJuKAUsg+ZpZMqP4ThRTTViQIE9bU8Yt1SGAuN7RnhxucKOQyD+8vz6oLDhpCL8DWuFbiYSEgkN4bmgruz7hozQs9WdMxjM/MzTlL4gBqkZJtdQNnebpLp2hydZ57Vdxub2M0jSZcyra+MEoIjIVNQVle6pWOoy1a2molAtHk6obGZdIYqwW8nHIf4my2VaXm04SI1ORHq/V8lyM31wytw5frHlIh2M0V+i/TGGhiDM97mqK+c+2nbmuj9SryfxPYEA7jWgMhjhZlAOoSVgw9z150p8aqPcxsw0mRR2+GHd4ABxQp6/na35SCGL1BurHH5HtN+guyws+Lvy8K9xb3AqQzQIgA2GvmARnNRn64ldcNCfd3XHs75z/LoW0N+insGjWCPM+pR674c8FbsgMHlq3TDst4dRIWDvZZ5Q8idB7rsDgjoS7R3PewGENbt/sBwJ6mpE0zDaafMprZhs2XpN+jE/aR0A6UaewqweL7oWseNEDs9qLkMJ7m5M0TMFuFMcNSsYJEXd9IZPz5qL2X5POhCPBROTigxqZ2YMcyQ09KMX1XJp0K+vBa889b7lye6RzpKXoTtCfap32yLMBg9cZUUAGarP/bp93jN5DBuMRx41dthSF6UnFyuUqgLojQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SN6PR06MB4495.namprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(4326008)(6506007)(71200400001)(83380400001)(7696005)(66446008)(38070700005)(64756008)(38100700002)(76116006)(122000001)(66556008)(66476007)(66946007)(8676002)(2906002)(508600001)(86362001)(54906003)(55016003)(8936002)(52536014)(316002)(33656002)(26005)(186003)(110136005)(5660300002)(9686003)(107886003);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sSHU5hpO0Zao8Yi9YeMheQfKydU6zXAA+T6IWeZ10DfqS0lJ1MlgkQVTb6BW?=
 =?us-ascii?Q?2QH3rddd+lcnSIFfe35MllcHpo9dF9/iszyObwHQw4IEWCS9YjZELn0px6eD?=
 =?us-ascii?Q?o0MDXSGgH6rI0MA58hCgAw7k1E6lmKz9CQJTNV74/Aye9GlwurGD6ZyWS5Rn?=
 =?us-ascii?Q?y6gyWqz82H/DAcKFJqeZIs9UItmx1lQYw3K9XsOFckBImvaxzdRpzPYlPvJl?=
 =?us-ascii?Q?mv0jQoPHFp1wv6b0iC6/kdYnrFXSfeYHw7bRzTcqZPvSpnrrBgqJOTSA9B8G?=
 =?us-ascii?Q?pfApJ3wH+3MR5d4xTzwolh10L9TT38mNBcSEDcYRyZzaKL7eyF/0HGqWq7zi?=
 =?us-ascii?Q?5h9bOZHIYgFLlrG9GbgF3OQTnWXYMA4kT8hzHWxmyEV8yrxvRNT61gqDWKny?=
 =?us-ascii?Q?eow32D/dUcNqKA3hOwS1c4Rn19DfhYuky8CsY7B8W4Ffn9QAfTyPaJWRgaPJ?=
 =?us-ascii?Q?G9LM7BNJ1thAcTKXFAVlNPvULXgngeNpFJNJ7zWoRFVpwAsvE2Si+9fmb506?=
 =?us-ascii?Q?6dtzzJa1DlB5VM8VNarkLzD5n3rx2+PwIfyfTHvXC6CuAhVRLJ7U7PZv3UAU?=
 =?us-ascii?Q?hzjNrb6EohdfxDw3j82HUfLRsDKgzypl7MKMzOrAHAUihSnPjyLvNjgLp6I5?=
 =?us-ascii?Q?c2b1NeULM256EVkUwZXBTEv3XhbqvsRrK+vg/eOJWMmlKGEHwAkIIpxAXU+X?=
 =?us-ascii?Q?pMvy0psTbY2IN0AM8c1KMG65RMXEhkAZvBfDbt78j/1BvRfYX7GtE2xMSbSl?=
 =?us-ascii?Q?AZ2KHac1L9CJOV4uj+TyVZeBqy7iZpzin+8MEBXXwbcvu9Nyl7cA/QtddpH0?=
 =?us-ascii?Q?2JLWhPHDo4LNd8pmhy1O33RhYmInjzrAGJsPRfkyDiXknxzHHGvl2S+Vbqp3?=
 =?us-ascii?Q?KmnwCGE9TbOW9I1Otw2aANQzrBJgH/q5c3lu3nb+64NKb4JGdj7V2zYB50TD?=
 =?us-ascii?Q?mJrOs7SRhqmNDAu1F+BLN1HLC+Gl0EmftGbC6ainCu6Un7TbimuBNfnEoW3s?=
 =?us-ascii?Q?479SjO+h4Rf5oGhJ8VrD/iXs7O96weObkpmNW4B4ZbA417ne0hAOEOE+gGqV?=
 =?us-ascii?Q?oTYoF9qCaS7fYEkrLp0QB9Mib4blqdEKoqfrEUuCA8ALRZgIVNSNazDZVEq0?=
 =?us-ascii?Q?xPWF5EAgNhuvCyd0Ydk6UZPaznE+SIC7q4TOev2cpLqTuRmEFO9+ATCnuiHT?=
 =?us-ascii?Q?wsmHzcdSW/5aNeTi+FP8uEZv4YR1Kziem0ZF/f9AzpO1E4g2S9NA/np6gDa5?=
 =?us-ascii?Q?SrqIjgMuG2FswR9MOL+NpwhJ+3JL4jLeuMgLZxursZ+tR05V73PHHRw+6mAL?=
 =?us-ascii?Q?FE0GbEkvxj3lHpR8Vj6ms7KBAbDQTsyNC60kr9difcdoTg/IcgWTlKdD5hPv?=
 =?us-ascii?Q?3qwMn4QjSajrfMHPFbZDbJGMMpmcyWeAIQbS6WGJkfvC0ROS0yd5xhUFmZc9?=
 =?us-ascii?Q?0xR7xCJ24fzW0rv0sndbffwdjsi7+Nedpqq2PoKxdpQJ6cE9H4w5ZGfqFpCK?=
 =?us-ascii?Q?jsJqhb1VfEmx4VCNDtyJUhk3QbHNJwXY1Uo8vF2KlFrBSzi5S6DRWr3dnoHg?=
 =?us-ascii?Q?WNUFDzNr8ss3aipTx/OfNkD/fQMjZUKgyUFgersaiAw94aogN0kX/BnMUyg8?=
 =?us-ascii?Q?8jX+oXIBdH13VUvF86J7ezEqAH1eeF9S69mDaCIC2R7rFHLYjCTNkV+L+oke?=
 =?us-ascii?Q?P2CRabMw09GodIfg/KFGbEMTtrhxPxeklzda89Afa1FZWIuuUg24J6Oomi0u?=
 =?us-ascii?Q?6yIK302kGw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR06MB4495.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fe9879-0233-4c50-4bbe-08da399a1f04
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 13:18:53.4312 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bI4Hkk4qzggC8LVndCMti++7x9YqTsnvkBeSvTmDTEaKCt9nbkOChw9qf+OXgio9x6AfoeS7o9NB0yDimEcN9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR06MB5456
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Fri, 20 May 2022 07:01:49 +0000
Subject: Re: [dm-devel] [PATCH 4/9] multipath-tools: add NetApp E-Series
 NVMe to hardware table
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
Cc: "George,
 Martin" <Martin.George@netapp.com>, Hannes Reinecke <hare@suse.com>,
 ng-eseries-upstream-maintainers <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Martin W,

> Steve,
> 
> On Wed, 2022-05-18 at 20:24 +0000, Schremmer, Steven wrote:
> >
> > Nak. NetApp E-Series only supports these settings in certain
> > configurations, and we prefer to handle it via our installation
> > documentation.
> >
> 
> I don't follow. What harm is done to Netapp if these settings are
> included? People can still follow your documentation, the end result
> will be the same... no?
> 
> AFAICS, the only setting above that would only be supported in certain
> configurations is PRIO_ANA, without which GROUP_BY_PRIO doesn't make
> much sense. If the array is configured not to support ANA, this
> configuration would lead to error messages and PRIO_UNDEF for all
> paths, and thus "imply" multibus topology. Not beautiful, but also no
> big harm done, IMO.
> 
> If it's that you're concerned about, please provide the set of defaults
> you prefer for E-Series, or explictly state that you prefer to run with
> the generic NVMe defaults (const prio, failover policy).
> 
> In general, if vendor-recommended settings are strongly dependent on
> storage configuration, host-side software defaults must try to match
> the storage array's defaults. We shoud do this for E-Series, too. If
> ANA needs to be explicitly enabled on the array by the admin, we
> shouldn't enable it by default; but otherwise, we should.
> 
> Martin

NVMe-attached E-Series is moving towards only using the native NVMe
multipathing in the kernel rather than DM-MP with NVMe. At some point
we will stop interoperability testing with NVMe DM-MP and not certify new
solutions with it.

The set of defaults listed for NVMe E-Series are the correct ones, but I'm not sure
they should be included if we aren't going to continue to test the interoperability
of NVMe-attached E-Series and DM-MP.

Thanks,
Steve

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

