Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3781CC433F5
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jan 2022 20:06:09 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-iIb-fk8PPG-HX0BXtod4sg-1; Sat, 08 Jan 2022 15:06:04 -0500
X-MC-Unique: iIb-fk8PPG-HX0BXtod4sg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B37D1853020;
	Sat,  8 Jan 2022 20:05:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 50AED101E59D;
	Sat,  8 Jan 2022 20:05:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5E4F64BB7C;
	Sat,  8 Jan 2022 20:05:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 208K5mUb012052 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 8 Jan 2022 15:05:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 08EDD2166B13; Sat,  8 Jan 2022 20:05:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 036F82166B26
	for <dm-devel@redhat.com>; Sat,  8 Jan 2022 20:05:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF996811E7F
	for <dm-devel@redhat.com>; Sat,  8 Jan 2022 20:05:44 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.17.12]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-397-TlScb3RrOkqoWggL5UelrQ-1; Sat, 08 Jan 2022 15:05:43 -0500
X-MC-Unique: TlScb3RrOkqoWggL5UelrQ-1
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko ([46.223.151.24]) by smtp.web.de (mrweb105
	[213.165.67.124]) with ESMTPSA (Nemesis) id 1MvKbj-1mF0Si1UDh-00r490;
	Sat, 08 Jan 2022 20:53:01 +0100
Date: Sat, 8 Jan 2022 19:52:59 +0000
From: Lukas Straub <lukasstraub2@web.de>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <20220108195259.33e9bdf0@gecko>
In-Reply-To: <0535d6c3-dec3-fb49-3707-709e8d26b538@gmx.com>
References: <0535d6c3-dec3-fb49-3707-709e8d26b538@gmx.com>
MIME-Version: 1.0
X-Provags-ID: V03:K1:AGazrWY5rmVs3KLflW/ztv0A9Mbn86f0R+FugVm+ZYTHp7FWmhP
	UvJZ7Mc6s9oUNuBwc+domY47DVsmzp1hcddFyhihrJZm94jzAM/cdMUybsVRXFVs1ix97Gr
	yUM0jx4iKxPulgBfO3FqcjTf+8YUYTlwb+qhzXu6GDGY4VsOiMiFlnsMswKbB4rsGTkCp3i
	U3YHoiSxmX6OtjPgyUEKw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jZMOPEGuQns=:o3yJjUPTAGXGKKJAp21WRk
	DuTLN33rjZSBFyxFsWyy/56bPXPS/Vmp0Gdy6qI+ozxN00NOGSlzWhPM+lxLMXSJYwGqjNfwR
	LJeiRo1muWWUmH1CDWhjIASexXYw4gqtyiNeor8uCQ2OxckkPDZexmczDTbHdgU12kXxi+s2t
	t5qoC9YsUs+Uo0KWscuCefVmRokJuHaElDedy1vGVJ34FJhLuoWBz8OPQ70GtPcy964F3G2M2
	t1EPEGuPA86IhOQ7e45RhLUw7icX1H8/7o6dO5cx30dtOeQuEKilpyfZBYkDFTGojbQaZzHoT
	/Q+VGhEBVVTjgJSdyjeby/8TgI032n8DuK7jCJaDdrFHSHcGurqCZRlsfrMjUbKoCUIgbj/Wg
	2WbNZbNb5AP3Ph2DCrakZugqKTZFdtu5kI6s0nJOeaPgIX6CiqKwF2nxW+tfeevojIkFMRZ7z
	wfWssiEdHvki5ghhK1K0I5QsQrSfQlD5yD8OIc71WmLn/zuIMt/x+hRTD6/7Q1rARIm2n0v32
	vUFacJ4kS/oMerGENpZjYmY72RyvnPTBPxx+qzDlZ2X5pO+FGBUC6h+x1GPqEIXn0a5wVhfBW
	NBNyNtwNZmFmWssIIj3aa1jgWoKlMwefnJER2s1ApSqhGeJ27IB8lL1fliOptIilOscnXDuXa
	P1CLgEv/NQZLhSCYXggKKudTohh5HcevFCSNf3uodv4b6TOZ1ocbeHmiR1cDOLXAxiH/D1gQs
	5Srxtvnh0U+No7GdFvvg25Cv1XbwP8vy9hLHP1P3ruhm7C+fpdF+SAfCCTh8QomRdgjIAkkoc
	xqjqDvcPPj3sAqpqsQS3hwEMpy+LYascgAU6/MnUhWx2ZfJi6uSpy8qddhO5mRV0ACmh74AZX
	OowKOy1QULtr+C3skputUCbVbWaWU9qP323NESI48pCr2FiabHG+fb+NhKxNaenegoqL40Po1
	BgJ09lycKGDpuqM4wN58qCQI0PTlYMuvFygJ65n/O0v/CXPmrifgerLowIEh/MSZZIQ3z5EXu
	UWjtHdBTcZOe/hPb6lXnBwLAKVuPoEUoFkSke1XJXtv3c108nl7PlJqpptO48HhCzAyrwRBpd
	xQhKWJCyJdVnI8=
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 208K5mUb012052
X-loop: dm-devel@redhat.com
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: [dm-devel] Proper way to test RAID456?
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

CC'ing linux-raid mailing list, where md raid development happens.
dm-raid is just a different interface to md raid.

On Fri, 7 Jan 2022 10:30:56 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> Hi,
>
> Recently I'm working on refactor btrfs raid56 (with long term objective
> to add proper journal to solve write-hole), and the coverage of current
> fstests for btrfs RAID56 is not that ideal.
>
> Is there any project testing dm/md RAID456 for things like
> re-silvering/write-hole problems?
>
> And how you dm guys do the tests for stacked RAID456?
>
> I really hope to learn some tricks from the existing, tried-and-true
> RAID456 implementations, and hopefully to solve the known write-hole
> bugs in btrfs.
>
> Thanks,
> Qu
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
>



--


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

