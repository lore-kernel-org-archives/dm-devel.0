Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2FBC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  7 Jan 2022 02:36:26 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-v90DmNlGMUCfPQHu2KWGKg-1; Thu, 06 Jan 2022 21:36:22 -0500
X-MC-Unique: v90DmNlGMUCfPQHu2KWGKg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0694801B35;
	Fri,  7 Jan 2022 02:36:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD03461096;
	Fri,  7 Jan 2022 02:36:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C5B21809CB8;
	Fri,  7 Jan 2022 02:36:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2072a934013438 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 21:36:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1C0A340FF696; Fri,  7 Jan 2022 02:36:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 16C1B40FF694
	for <dm-devel@redhat.com>; Fri,  7 Jan 2022 02:36:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E82DC3C01D80
	for <dm-devel@redhat.com>; Fri,  7 Jan 2022 02:36:08 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-6-MY1GYRJJOqaxd5aWLAB4Vg-1; Thu, 06 Jan 2022 21:36:07 -0500
X-MC-Unique: MY1GYRJJOqaxd5aWLAB4Vg-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
	[212.227.17.174]) with ESMTPSA (Nemesis) id 1MGQj7-1nAs5h15Th-00Gti1;
	Fri, 07 Jan 2022 03:31:01 +0100
Message-ID: <0535d6c3-dec3-fb49-3707-709e8d26b538@gmx.com>
Date: Fri, 7 Jan 2022 10:30:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.4.1
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
X-Provags-ID: V03:K1:kphmq0FEyg7Wx9XOgZDjRrSzWN242v/TGFEZ+QKFhrInxyqw1jv
	0RBpSjIXo2rzYMDTqIQE5LtmdvKNuC1Q/y6uIGM1e5+/2xd1E5KEn9oWNKrysxwwGW3rOBl
	640Msj/jcUo/VmIrP5VA0THSNyEWF1EbDc7xCrj8sFP1BKR2CdwSXX3nZC0owYPEtwP5c69
	yQIqwNtN8wLoPUIRLOBpQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lN1LYWTc4gE=:8oYw1jDbleQhphbxKSdt49
	7l5SixamrfStF2Kf2Bw36tW0qm6cHSfhq4juOwdd+rKhNOC5xOCYAfIL16emY0vfxZsBTgare
	vifYrfiZDIPlSo8BSA2GtPUJtdNll3OV4T3WT70p9SRKKwn69Dg0RjZqlRqxuaG6upfR47WYh
	2qTE89kkDo2CduFnB5lAWviSK2+VYU0LVf7Uum1EPMyFtYxyonzJKFGxc3c5bS238AeF8Bfm1
	TZXoKOKWidjnxiRbZCc9eImdaDpt4KCkM4QyHaTGS8Vcb7JYU5r+DJCixk1mpw6BDzka7cOJs
	RdICIZ1V3uYoCvi2tR4V3SdYRIf9A5pwcTzUaZ4dbrhBtaqNnlOL/XSQJadiElrB0xG5ygT4X
	WJ/0M8yskoI8+zeJ0n1CGc7t5T4H792KbfRFxH8RknnA7XrwNblPAuVraXMDN5OaMA2/rcMbV
	BBMd6xkdYuSduSB7fFTtTggcQcYDu7eNxd9ccrxlAOCV6hBk5pvnQUC6VyRw401xJeKHZ5XFZ
	bCB32SGxRj16PcyUyhml7BLVqpSCjNAp3GUUFyQX5vZ36v1oUqFfffwAOFhzwtpKUhjgho+4V
	5wyS9/irRe1mMPRk68J6cU9BjDxTnf1iFAggRbOIrHWh77j+/1J3ETOpXPgVGDq7fF0UcxG6F
	eFGDUs1GMSPhK1ilG0N5YE0aTnlm9+M2+HLWuDSB337d/ECyd7Wh1JvYBAlHHCfSphOtWda60
	hkT4ACgYn56ubUcdMWsJ4xhm828A082l8mJKxs79E4KMObosKrSHLOwRljD8wZggYikJTColh
	LBd3mtWWiq60C0nbXT8KP9EkK9n6RdrDXqp+mk9XlB7OHDSgRssJmsFC+kFA8r7hhK+Ila5Ni
	Wk2P3IXHSl+yBzoakyuwwbcJRbxyq3pjJLY76QJM9daxQN1C9CtKloC9N+JNC9TZ7XIC8p6dN
	Jfs/GAIAWqSZ3Pb7d1AkVxavVarFhMdGn4ieY3i2kBA2cYmboC9vYi2V/svUoMGlpTGAm9vhT
	/GQuTu7QeMCiMxhhavt2raLb74M3xpTd2MhVI8kdpwgEV3ppXZg82hiGbSLjlWbcTYYRg8lEN
	6kPRfW4Acdr1RE=
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2072a934013438
X-loop: dm-devel@redhat.com
Subject: [dm-devel] Proper way to test RAID456?
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

Hi,

Recently I'm working on refactor btrfs raid56 (with long term objective
to add proper journal to solve write-hole), and the coverage of current
fstests for btrfs RAID56 is not that ideal.

Is there any project testing dm/md RAID456 for things like
re-silvering/write-hole problems?

And how you dm guys do the tests for stacked RAID456?

I really hope to learn some tricks from the existing, tried-and-true
RAID456 implementations, and hopefully to solve the known write-hole
bugs in btrfs.

Thanks,
Qu


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

