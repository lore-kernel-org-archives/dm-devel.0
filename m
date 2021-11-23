Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A5DC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 06:49:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-oNntd4xLM-aTW_xdU7HgvQ-1; Tue, 23 Nov 2021 01:49:55 -0500
X-MC-Unique: oNntd4xLM-aTW_xdU7HgvQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2155357202;
	Tue, 23 Nov 2021 06:49:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F7CD60C13;
	Tue, 23 Nov 2021 06:49:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 08ABE1832E7F;
	Tue, 23 Nov 2021 06:49:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AN6niMS025106 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 01:49:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 032A540D1B9E; Tue, 23 Nov 2021 06:49:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2CB340D1B98
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 06:49:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8468800882
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 06:49:43 +0000 (UTC)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-571-OCyG4nU5NE2J47ChzbVE8A-1; Tue, 23 Nov 2021 01:49:42 -0500
X-MC-Unique: OCyG4nU5NE2J47ChzbVE8A-1
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
	[212.227.17.184]) with ESMTPSA (Nemesis) id 1MZktZ-1nBFeW2R4Z-00Wj20;
	Tue, 23 Nov 2021 07:44:36 +0100
Message-ID: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
Date: Tue, 23 Nov 2021 14:44:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.1
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
X-Provags-ID: V03:K1:/KzIMRoAX7PxbEm1Bkj26bYMQrmSjX45HekEQlqPdr3cOtGtt5D
	mvzIVxHRSEfXCCQDXRxzoEgDGcraK1fTwOTwApxlv+r2byjfBFoMh3ADlQPcACmrS7xpSKE
	xidaX7Ig7Bed+WJ7ANBriz2TCzju94j2c8YlMOhhZNLmAY9rqryhwOjrdYAinXg0YBUuqTO
	Y35p1hNbFS+2UmMS3wrfw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:pKSm6QENP1Q=:fbi0vR5TcYJ+3XCKoKaZeq
	iYqiFGESKmvXOFre4DjfWzGY3kS00u4woiCcUZudOC/ZskwnE5OddtReKnmwPq4vfxWext0Wz
	ydvggXLsn1g4y3gMqAC8NXrcw0+LdW+INSjA4semuYIybYEMPD+3+EolHgnmTNXQXhek91RO8
	zjCBhMlctF0vSy9HCChBRuvFgT2v8gsEn15YKc4BaLe4q8X8a4Cltmk6Ls5b0Vxy/CJQReJxJ
	QqPbNuZQyUWMRK3noOAJjNnwmkSoXWBed9CKAUQLW6XX3+GordvhblSDFd9qGcFSDognfUcIe
	bWp0SZzNUQPXNvRajJ+pguYMql3XPOuJ7n4la+66DqPmxV3C4jVVn1lnYxHxXhph+SgY1LBwZ
	nvLEmzRKjNDnF21+IIYabXSN2MVuBbsGLGr7fhqmqQ3P4H8nLoTYlLxoH3hb03AcdN9Wwc0gi
	5rJW3RKlYaE+xCl4IeZH0rieOovEG5HH/SQhbp+IQ9GJixnObcMIkZCje4jjpWUH7TdjyCKv2
	zDsQxF8XhDft334Rr4FZXWXTBKmrb2FaGhezT9waUOsaBDt7qq8mOOdAYWWstNeJBIoC+IVVj
	L013rQwATVN32eJ/CSc3NLqZdfQMrdHAnflVpepvnPAU2bNYaDp/5++6CsuR+d0YY9aklR5et
	yuad0jStjbUmJUgnh1WIqZEwA1nvW3YURQ4vk6tF5gHu3xuXHI35QCapI5SodBNDRwam0N3Qq
	iGTutsJsr1h5jhxYZiN4rgMmY9ckfSYu9bb3nelHY+W0Bpq416QHbe8DWlMcML0bxNk3xX4zb
	5MipB9x7f3HLMB2LS6CyiXPOWHt1dDRrBaqcsdyueOr7l3tZMfNmxHk+3x3wiwA+JOB7sovFg
	jLOx/uCwmNOPaNMJQnc9AgSkCxEXFcEHTc3LNFQFsKRHHHgacR+Q6OvZ2rH7U/0TyBxZJpBxC
	c70xw3A7Cg67FghBgcnJODWMb1HxF4DrtGZ4e8znQjGC2TnsAjob6t+aJSU/P+88v+Vyb1voM
	hXd3Ar0DiNsxDqgJgHGO20Grke+gbimBjV7uXvx0sis9a5B7OnwoVaIraPSHrM9SUW3R2bk5F
	nSnATQ0vn97lFw=
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AN6niMS025106
X-loop: dm-devel@redhat.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [dm-devel] Any bio_clone_slow() implementation which doesn't share
	bi_io_vec?
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

Although there are some out-of-date comments mentions other
bio_clone_*() variants, but there isn't really any other bio clone
variants other than __bio_clone_fast(), which shares bi_io_vec with the
source bio.

This limits means we can't free the source bio before the cloned one.

Is there any bio_clone variant which do a deep clone, including bi_io_vec?



The background story is a little long, with btrfs involved.

Unlike dm/md-raid which uses bio_split(), btrfs splits its bio before
even creating a bio.
Every time btrfs wants to create a bio, it will calculate the boundary,
thus will only create a bio which never cross various raid boundary.

But this is not really the common practice, I'd like to at least change
the timing of bio split so that reflects more like dm/md raid.

That's why the bio_clone thing is involved, there is still some corner
cases that we don't want to fail the whole large bio if there is only
one stripe failed (mostly for read bio, that we want to salvage as much
data as possible)

Thus regular bio_split() + bio_chain() solution is not that good here.

Any idea why no such bio_clone_slow() or bio_split_slow() provided in
block layer?

Or really bio_split() + bio_chain() is the only recommended solution?

Thanks,
Qu


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

