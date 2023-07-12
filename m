Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DC4EB64DD
	for <dm-devel@archiver.kernel.org>; Thu, 13 Jul 2023 06:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689229502;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NzMvGkt5pQXjQep5H0Y/UUT6MVmHBNvjKKFRcrTqpf8=;
	b=ipFxnNVV34Cu0EyrsOiC26VkXHYKOSfZvIlK2gGeoTbhO1YZez/hiQqbSiVSMH/PqtX0g/
	wwwaAkZC0uPMKiUTug7QagwkxIPxXLSxC/j+tvowfLGojfgHDG32ZNEyWG5iUKsZbW6CaY
	MAjiWy/4uZ6jrSk7eBusWNQ5Z3Fzojw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-0TubS3rEPQijeexoxb0qeA-1; Thu, 13 Jul 2023 02:24:53 -0400
X-MC-Unique: 0TubS3rEPQijeexoxb0qeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FCFC8022EF;
	Thu, 13 Jul 2023 06:24:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 019DF40D285B;
	Thu, 13 Jul 2023 06:24:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B0E93194658F;
	Thu, 13 Jul 2023 06:24:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F26E71946594
 for <dm-devel@listman.corp.redhat.com>; Wed, 12 Jul 2023 16:06:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B05D24CD0CD; Wed, 12 Jul 2023 16:06:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A8AA2492C13
 for <dm-devel@redhat.com>; Wed, 12 Jul 2023 16:06:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88B5D93B762
 for <dm-devel@redhat.com>; Wed, 12 Jul 2023 16:06:49 +0000 (UTC)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com
 [209.85.167.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-8LnhhxU2N_quUkpa23Lrww-1; Wed, 12 Jul 2023 12:06:47 -0400
X-MC-Unique: 8LnhhxU2N_quUkpa23Lrww-1
Received: by mail-lf1-f50.google.com with SMTP id
 2adb3069b0e04-4fb96e2b573so11506602e87.3
 for <dm-devel@redhat.com>; Wed, 12 Jul 2023 09:06:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1689178006; x=1691770006;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=8X6ArMXh62A5UxRR3ZN+q1CvObhoeb8ltfmXU1xj+zw=;
 b=dwxAzPlTtwLHXKqcgFVyt7c0A7Gdyo9J8gTVtavoL0nslT9xZ8GA74OwqFqjA4RJ6Q
 p768ja64MPI6LHgaGhsdb34Q0teiZfE+1wgUPD05ndga5nT14WG3wiN2K9zyJiud8Foq
 6GdQr8wRxtxGY6m2UivT/7HGAnk2YT1SMqwy6jG/KdDeWf9SAkqZd7+nwprntwsTuxOg
 5ZZhlKQvGhrhYgytnUHtx3SUtT1T7pZMBfqtkvarKx8Gviv0vEpcu8fFNUUcBMAIrx4z
 vwskjIpBpyjRnEtEz2oY8fN9QpCuoIAdUAJaDQzAZ4SaNi+YO2v1PIL5oMxDNJcVn0Hq
 quOA==
X-Gm-Message-State: ABy/qLa5vWp+VNRF6FR2NYTpa0liixU7gtQ0yA81VphYTBz3RzOCzefZ
 dTkI32rlOEseIx80vpovY/1zwGOgo6YDEhmBBXVuww==
X-Google-Smtp-Source: APBJJlHjPtNIqZNhhKZT3JSG1orBAozCwd3+TwwvFjulJuToD7D5iIrA7grwKZQU8Z67qc0UJ0oDxWof6WbkdfMRi3A=
X-Received: by 2002:ac2:5b1d:0:b0:4fb:7a90:1abe with SMTP id
 v29-20020ac25b1d000000b004fb7a901abemr15797051lfn.49.1689178006211; Wed, 12
 Jul 2023 09:06:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
 <ZKbgAG5OoHVyUKOG@infradead.org>
In-Reply-To: <ZKbgAG5OoHVyUKOG@infradead.org>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Wed, 12 Jul 2023 18:06:35 +0200
Message-ID: <CAJpMwyiUcw+mH0sZa8f8UJsaSZ7NSE65s2gZDEia+pASyP_gJQ@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 13 Jul 2023 06:24:47 +0000
Subject: Re: [dm-devel] [PATCH 01/32] block: Provide blkdev_get_handle_*
 functions
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@kernel.org>,
 linux-nvme@lists.infradead.org, Joseph Qi <joseph.qi@linux.alibaba.com>,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, Jack Wang <jinpu.wang@ionos.com>,
 Alasdair Kergon <agk@redhat.com>, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, Sergey Senozhatsky <senozhatsky@chromium.org>,
 xen-devel@lists.xenproject.org, Gao Xiang <xiang@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-pm@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>, Chao Yu <chao@kernel.org>,
 Joern Engel <joern@lazybastard.org>, reiserfs-devel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
 linux-mm@kvack.org, Song Liu <song@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 Minchan Kim <minchan@kernel.org>, ocfs2-devel@oss.oracle.com,
 Anna Schumaker <anna@kernel.org>, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: ionos.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBKdWwgNiwgMjAyMyBhdCA1OjM44oCvUE0gQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBp
bmZyYWRlYWQub3JnPiB3cm90ZToKPgo+IE9uIFR1ZSwgSnVsIDA0LCAyMDIzIGF0IDAyOjIxOjI4
UE0gKzAyMDAsIEphbiBLYXJhIHdyb3RlOgo+ID4gQ3JlYXRlIHN0cnVjdCBiZGV2X2hhbmRsZSB0
aGF0IGNvbnRhaW5zIGFsbCBwYXJhbWV0ZXJzIHRoYXQgbmVlZCB0byBiZQo+ID4gcGFzc2VkIHRv
IGJsa2Rldl9wdXQoKSBhbmQgcHJvdmlkZSBibGtkZXZfZ2V0X2hhbmRsZV8qIGZ1bmN0aW9ucyB0
aGF0Cj4gPiByZXR1cm4gdGhpcyBzdHJ1Y3R1cmUgaW5zdGVhZCBvZiBwbGFpbiBiZGV2IHBvaW50
ZXIuIFRoaXMgd2lsbAo+ID4gZXZlbnR1YWxseSBhbGxvdyB1cyB0byBwYXNzIG9uZSBtb3JlIGFy
Z3VtZW50IHRvIGJsa2Rldl9wdXQoKSB3aXRob3V0Cj4gPiB0b28gbXVjaCBoYXNzbGUuCj4KPiBD
YW4gd2UgdXNlIHRoZSBvcHBvcnR1bml0eSB0byBjb21lIHVwIHdpdGggYmV0dGVyIG5hbWVzPyAg
YmxrZGV2X2dldF8qCj4gd2FzIGFsd2F5cyBhIHJhdGhlciBob3JyaWJsZSBuYW1pbmcgY29udmVu
dGlvbiBmb3Igc29tZXRoaW5nIHRoYXQKPiBlbmRzIHVwIGNhbGxpbmcgaW50byAtPm9wZW4uCj4K
PiBXaGF0IGFib3V0Ogo+Cj4gc3RydWN0IGJkZXZfaGFuZGxlICpiZGV2X29wZW5fYnlfZGV2KGRl
dl90IGRldiwgYmxrX21vZGVfdCBtb2RlLCB2b2lkICpob2xkZXIsCj4gICAgICAgICAgICAgICAg
IGNvbnN0IHN0cnVjdCBibGtfaG9sZGVyX29wcyAqaG9wcyk7Cj4gc3RydWN0IGJkZXZfaGFuZGxl
ICpiZGV2X29wZW5fYnlfcGF0aChkZXZfdCBkZXYsIGJsa19tb2RlX3QgbW9kZSwKPiAgICAgICAg
ICAgICAgICAgdm9pZCAqaG9sZGVyLCBjb25zdCBzdHJ1Y3QgYmxrX2hvbGRlcl9vcHMgKmhvcHMp
Owo+IHZvaWQgYmRldl9yZWxlYXNlKHN0cnVjdCBiZGV2X2hhbmRsZSAqaGFuZGxlKTsKCisxIHRv
IHRoaXMuCkFsc28sIGlmIHdlIGFyZSByZW1vdmluZyAiaGFuZGxlIiBmcm9tIHRoZSBmdW5jdGlv
biwgc2hvdWxkIHRoZSBuYW1lCm9mIHRoZSBzdHJ1Y3R1cmUgaXQgcmV0dXJucyBhbHNvIGNoYW5n
ZT8gV291bGQgc29tZXRoaW5nIGxpa2UgYmRldl9jdHgKYmUgYmV0dGVyPwoKKEFwb2xvZ2llcyBm
b3IgdGhlIHByZXZpb3VzIG5vbi1wbGFpbnRleHQgZW1haWwpCgo+Cj4gPwoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

