Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 243C6C77B73
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686077649;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HSTbNxWWEImiuqxKn8H8G0CO5EyMWW4fjL3vWiED4Yg=;
	b=OvxOKEit+1FTOWtjLxj+0zD6AIfDMcr6KjFUapecwjlyPQwjopmma+cFJY20msgq148xIF
	GPXhWsp2Q7EpfJFt0b4VCJRXRdMRAdhkOW3LOHJnsC6tOQihFjR9efqnkX1slWC6LSeDoG
	DacrNaL7ZMU7YMuDn9QubTmYuurkPvo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-yGCZlfhrN3-BhkQQ8M8zhQ-1; Tue, 06 Jun 2023 14:54:05 -0400
X-MC-Unique: yGCZlfhrN3-BhkQQ8M8zhQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29D5B801182;
	Tue,  6 Jun 2023 18:54:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5D221403362;
	Tue,  6 Jun 2023 18:54:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 38C9E19465BC;
	Tue,  6 Jun 2023 18:53:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 07A8119465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 18:53:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7343640218C; Tue,  6 Jun 2023 18:53:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69633492B00
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 18:53:54 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4967A801585
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 18:53:54 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05on2058.outbound.protection.outlook.com [40.107.22.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-L5FvTY0ZPQy2s8Ip-iBLeg-1; Tue, 06 Jun 2023 14:53:52 -0400
X-MC-Unique: L5FvTY0ZPQy2s8Ip-iBLeg-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by VI1PR04MB9858.eurprd04.prod.outlook.com (2603:10a6:800:1d4::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 18:53:50 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 18:53:50 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [dm-devel] [PATCH 4/5] multipathd: reload map if the path groups
 are out of order
Thread-Index: AQHZjpZ2q6vNqLfPoUixhg0FPwfDKa98pQ7/gACgTYCAALvDiYAAHR68gAAVDIA=
Date: Tue, 6 Jun 2023 18:53:49 +0000
Message-ID: <055153b62e524e1d2c433e068b2dff317eb662e4.camel@suse.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
 <76217148d8069829795fb1d8608d5c5da60402e2.camel@suse.com>
 <20230605190807.GT24096@octiron.msp.redhat.com>
 <20230606044215.GV24096@octiron.msp.redhat.com>
 <a9070100acf9c2a6ba479dd3ca840e3d61e522f7.camel@suse.com>
 <20230606155402.GY24096@octiron.msp.redhat.com>
 <ee1290d1c2b5adf734a6df243707b3546d261f0e.camel@suse.com>
 <20230606173807.GB24096@octiron.msp.redhat.com>
In-Reply-To: <20230606173807.GB24096@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|VI1PR04MB9858:EE_
x-ms-office365-filtering-correlation-id: 991fda55-f58a-4413-4f10-08db66bf5dbb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: qTt/jnjmB70/2mrhwfpcbgD4zMAHsqdTjSJ8wZ022EZEznwSInVp6Che+JPynweHTe6Qm5kwKXhl5ckp8O8v0Uxq4gbkyJvlFf/c1bAO6LSyQXv54pgs/UEY5DsqY6/bUx5Ou3qpsSxiYq0Nij9uQdVcv7PBXmEi4SUyOetNogW0xFoVCnetcM3bwJfL4nRBmW1K8Sas2kHVS7y1DI+HLhuhAzlH2mJ+OZrXTiwGnaeaJVUQPNu2NT0eQE5l4RT7gSgcc6ZZKxK9vknjFBDbaA6UmKyQ+4nbljJzpZEVqS/irOSpAZyWiIGFLjmfoVUGAi+qRRbODEBz5bMBuBfcPiaFC1KpZUQNtWWxyQiiS04ctLcOt2zqSdLO6AmO1h/3iHv6NHeH7auzxDYf2QVQWCFv3IflNze1gYAGKW0i2eqn9L1T9olI7qKNXECoUxfR4ZxTpvXzjzpTv6+BEhwlvPulGTnF/9GbQoHgJrT1Vd95gAqN7cjh7w+KMl4ALrgY/vG6utFXGEVmwY/mNPROt8Rx4qD4ySeCzlQpSUDW6iDx253W2VUc9JvnH4uN/84Z5Hu55v05wcnvPt/24WoAsT7TZZQBasEGktRK7B8ZRPiLc+T0ZPHlVSHyWDrWlzgn
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199021)(2906002)(83380400001)(2616005)(86362001)(36756003)(38070700005)(38100700002)(122000001)(6486002)(41300700001)(5660300002)(316002)(8676002)(8936002)(478600001)(66556008)(91956017)(64756008)(66446008)(450100002)(71200400001)(66946007)(76116006)(66476007)(4326008)(6512007)(6506007)(6916009)(26005)(186003)(44832011);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?/b/C2l/A99YcNGWl/JSYkxUUHOhB4Uye/TRXXnt0ZYtIo9ylc9wnOVJII?=
 =?iso-8859-15?Q?YTC2g4R1zX8HY9iL31CIeHS6YHXP4i//+cixgpNx5RdUuO0ZqCbhgeYv6?=
 =?iso-8859-15?Q?TSwdoajdQMMTZBx9aArlX7Olm8d6Suy+SFlGVKBq94lE18ZkwLf6x/odo?=
 =?iso-8859-15?Q?RtuzDUrUtUlQZffrs2cUIkyLzjZX+ge+X/DZZr4sgNK1NtOqABR+a3Lho?=
 =?iso-8859-15?Q?aZWcsLtXqJ8nnO0NX6+uD6MTl6T/tDiqHKGAi0dusYlfKXvLN+HwpSYLb?=
 =?iso-8859-15?Q?qUEQtukDKJ88prkUe7NQK8pr/uPHfGnUWM14q7kVO5L+WOWum3InMghQF?=
 =?iso-8859-15?Q?EIrEbLxfcfUuWemRhmk2k/FLXYj5PZkd2bpsjhA3ACodOD3pcTymiO4gW?=
 =?iso-8859-15?Q?Che+ca3JD+ds4Lf3YRSM2GVDIJMGWQKMpjPJPV8Wqv4lgLuIICRAKOqhH?=
 =?iso-8859-15?Q?7Qjg6jw8RUxYnOHqGu9GCJlVulpMyDKHQ+OIDpddDrl6GXHmYkNSh0kJt?=
 =?iso-8859-15?Q?JvnlGRPKCySHcDStfQh5q0J86brIXTrmekhOPn6H6Qyau+0ZIhxecwEso?=
 =?iso-8859-15?Q?qMFn1nD1+uYe0mufzc3sbFAWFSZGO5OOu9YCmD/tkUl2LDbiGPpwrC6Se?=
 =?iso-8859-15?Q?S9Prn4XKM54pJ1cPM5MDP6YPECFZIXSbdIuJthpKqGwRYgBUC4Q+9dtvp?=
 =?iso-8859-15?Q?p7zV/Ocg2bmwb1UJV7ks3V6xFQlAQmAuXTwTGqkfqXUYKW7KcCyTB3wDU?=
 =?iso-8859-15?Q?dCPXVfAw93gZEP29oPOsEImL0DeNw7HmRj/qTUD6Io4/0ZJFJp6NRPnlp?=
 =?iso-8859-15?Q?S5s02mzqV6C1KR95BeMQV7LWdPAWYekX1b573RCB6TKH98MEVigw4FXjG?=
 =?iso-8859-15?Q?0z2IoDZi9TbyaNeBgoIQFPz4h6JNotTYQDWcizbzvESOvdKvHT4KrOuS2?=
 =?iso-8859-15?Q?J3kbIWoNWP3YK3bT7JcWGpPzqec9yXUAF5nTCqJc5JpymfbCwqezpUXle?=
 =?iso-8859-15?Q?PWFCtsDX4gtFQNDsxFf3uF2yWifqsssDoQN+L9zHe8/Gx0J24f7eTBJ8N?=
 =?iso-8859-15?Q?I0Prm2036DjWdaJ9KlX9ugQ3uTJHMK5ULZzGa90FrM/vI+OXMV/X86rxN?=
 =?iso-8859-15?Q?LxUmn/QiYPiFonO23TZmaMdJMZBWp2p5gdzPmNmRb7znCKqKh+e+NMYyq?=
 =?iso-8859-15?Q?icPjQZc7Gyfvv8Rslaq/6NfRrrOFWVv5PcHG5VbWaJHP/YpTntuILxHEK?=
 =?iso-8859-15?Q?p6gwvFpez+GNIYOLQ4qTCRZM6CJdaQK46Yl5nGFI4/yBafDYaSbq9qfL0?=
 =?iso-8859-15?Q?Q36VGhcMvQXpU3IvFCST/hDoo2qgMQjP8J19nF4dedX0WW4ZnTxvd7Sm3?=
 =?iso-8859-15?Q?dy8B+K/I46fbc0AXfXcou/3eNRaVbJuG7zdZ+HM5Df5KvV03e2f/4GXZy?=
 =?iso-8859-15?Q?7t2+8HMrLMAivNyxP/D3XZir5WNrj6e3jZiYvVMXy5uozx5BINrysgdyU?=
 =?iso-8859-15?Q?NkjVinHrxxzX3SoLYu2Tap3LuVVSllWRWOpRnJ5ZDG1Csqtt5+JlohrqU?=
 =?iso-8859-15?Q?e/0CkHibiu7MxKhtot/MgVvVV8QjNdS6aG4RfNkC+h0Xc0Fl74A8hZ7yG?=
 =?iso-8859-15?Q?MIrOptJU5EaeC/V/WvqGTmjTow3RZ39TJ0JrgRISLDA4PLPLMGjPZcdz4?=
 =?iso-8859-15?Q?q9+M?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991fda55-f58a-4413-4f10-08db66bf5dbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 18:53:49.9911 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nE+DyfdWgOkDUcIB+MC7gU6N1Wl1rHFdsPaZA2Jf0TMtkOPJXzSFpMOkKCn0+om6LHq4aebSNXGsAjqzALkYdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9858
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 4/5] multipathd: reload map if the path
 groups are out of order
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <160DFF3C9D69D142BB10AD250E56BB46@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-06-06 at 12:38 -0500, Benjamin Marzinski wrote:
> On Tue, Jun 06, 2023 at 04:32:13PM +0000, Martin Wilck wrote:
> > On Tue, 2023-06-06 at 10:54 -0500, Benjamin Marzinski wrote:
> > > On Tue, Jun 06, 2023 at 02:55:27PM +0000, Martin Wilck wrote:
> > > > On Mon, 2023-06-05 at 23:42 -0500, Benjamin Marzinski wrote:
> > > > > On Mon, Jun 05, 2023 at 02:08:07PM -0500, Benjamin Marzinski
> >=20
> > > > > =A0
> > > > > Actually, after looking into this more, pushing those two
> > > > > functions
> > > > > together makes the logic more confusing. Plus
> > > > > select_path_group()
> > > > > is
> > > > > used by multiple other functions that don't need to check if
> > > > > the
> > > > > path
> > > > > groups are out of order.
> > > >=20
> > > > Hm. Can it happen at all that select_path_group() returns
> > > > something
> > > > other than=A01 but path_groups_in_order() returns true?=A0
> > >=20
> > > Yes. It might even be the common case. Say a switch goes down and
> > > all
> > > the paths in the high priority pathgroup fail. The kernel will
> > > switch
> > > over to a lower priority pathgroup. As long as those paths work,
> > > it
> > > won't automatically switch back to the high priority pathgroup
> > > when
> > > we
> > > tell it that those failed paths have recovered. It's multipath's
> > > job
> > > to
> > > tell it when to proactively switch pathgroups. Since multipath
> > > doesn't
> > > update the priority of failed paths, the pathgroups should still
> > > look
> > > the same (unless you use group_by_prio and the path fails between
> > > checking the state and running the prioritizer, in which case you
> > > will
> > > likely get a PRIO_UNDEF and reconfigure the pathgroups, but
> > > that's
> > > the
> > > thing group_by_tpg is trying to resolve).=20
> >=20
> > Ok, this is subtle; it's caused by the fact that
> > path_groups_in_order()
> > ignores the ordering of PGs with pgp->prio =3D PRIO_UNDEF (which will
> > be
> > the prio of a PG with only failed paths), whereas
> > select_path_group()
> > will ignore such PGs it in a different way - by never selecting
> > them.
> > I hope I understand correctly now.
> >=20
> > I have to say this is confusing. We have different concepts of how
> > path
> > priority and path state together affect the PG priority, and we
> > apply
> > these different concepts in different parts of the code. I'm not
> > saying
> > it's wrong, but at the moment I'm too confused to tell if it's
> > right.
>=20
> It might make sense to have these be even more different.=A0 Perhaps
> select_path_group should stay the same but sort_pathgroups() and
> path_groups_in_order() should just look at the priorities of the
> paths
> that have a non-PRIO_UNDEF priority and use the total number of paths
> for tie-breakers. This would mean that they would order the
> pathgroups
> how they should be when everything is working correctly.=A0

That makes sense, yes.

> That way if
> something forces the kernel to pick a new pathgroup (which is likely
> the
> failure of all the paths in the current pathgroup), it will switch to
> the pathgroup that, all things being equal, should be the best.
> Obviously, if there is another pathgroup of equal prioity with more
> usable paths, multipath can tell it to switch to that one, but I
> assume
> that even without group_by_prio, multiple pathgroups with the same
> priority will be uncommon.=20

I suppose it can happen with with group_by_tpg. There may be one
optimized and multiple non-optimized PGs, for example.

>=20
> In this situation, it would make sense to call select_path_group()
> after
> calling group_paths(), since the first pathgroup might not currently
> be
> the best pathgroup, if its paths are down. At any rate, it's not
> something to worry about in this patchset.

Right. What I'm worrying about is mostly whether I (or someone else)
will understand the rationale of all this a few years from now. It's ok
to use different logic when we sort the PGs and when we select the best
one, but it should be explained why, and how, we do it. So please add
some comments explaining it.

Thanks
Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

