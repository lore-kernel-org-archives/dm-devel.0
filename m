Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19747C001E0
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jul 2023 10:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690800656;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QHVefMpJ4gB2auLx06XffVnPzF9tBcLvXPAOK4GG/i8=;
	b=M1DPIBBCwN8v6DCRYMqowX7evoWGDW0auNZLIQPFNbYhkpk5BJq5GoAykyfFYaQMAesNDt
	ql3S0kvMWeIoSoTysCVlQSCo/CCEOjXk2/vhF8VjiUOrgHLCi8gl8fqWIzQwr/0+PBBw7f
	fYTLttBcSqzGtvTiizbZHsrFht5f0zc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-MrcIH9qkMFakMqMG06FEfg-1; Mon, 31 Jul 2023 06:50:52 -0400
X-MC-Unique: MrcIH9qkMFakMqMG06FEfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABABA104458E;
	Mon, 31 Jul 2023 10:50:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ABCF61121325;
	Mon, 31 Jul 2023 10:50:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 783E21946A4C;
	Mon, 31 Jul 2023 10:50:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2839C1946A4C
 for <dm-devel@listman.corp.redhat.com>; Mon, 31 Jul 2023 10:50:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2DF1B401DA9; Mon, 31 Jul 2023 10:50:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2601A4A9004
 for <dm-devel@redhat.com>; Mon, 31 Jul 2023 10:50:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05EC92999B2C
 for <dm-devel@redhat.com>; Mon, 31 Jul 2023 10:50:40 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-lsSSCpqbPJWcwjUc1GMTEg-1; Mon,
 31 Jul 2023 06:50:36 -0400
X-MC-Unique: lsSSCpqbPJWcwjUc1GMTEg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id ED50E22197;
 Mon, 31 Jul 2023 10:50:34 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D6932133F7;
 Mon, 31 Jul 2023 10:50:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ovhUNPqRx2R2ZgAAMHmgww
 (envelope-from <jack@suse.cz>); Mon, 31 Jul 2023 10:50:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
 id 457F5A0767; Mon, 31 Jul 2023 12:50:34 +0200 (CEST)
Date: Mon, 31 Jul 2023 12:50:34 +0200
From: Jan Kara <jack@suse.cz>
To: Haris Iqbal <haris.iqbal@ionos.com>
Message-ID: <20230731105034.43skhi5ubze563c3@quack3>
References: <20230629165206.383-1-jack@suse.cz>
 <20230704122224.16257-1-jack@suse.cz>
 <ZKbgAG5OoHVyUKOG@infradead.org>
 <CAJpMwyiUcw+mH0sZa8f8UJsaSZ7NSE65s2gZDEia+pASyP_gJQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJpMwyiUcw+mH0sZa8f8UJsaSZ7NSE65s2gZDEia+pASyP_gJQ@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
 Christoph Hellwig <hch@infradead.org>, xen-devel@lists.xenproject.org,
 Gao Xiang <xiang@kernel.org>,
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.cz
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkIDEyLTA3LTIzIDE4OjA2OjM1LCBIYXJpcyBJcWJhbCB3cm90ZToKPiBPbiBUaHUsIEp1
bCA2LCAyMDIzIGF0IDU6MzjigK9QTSBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGluZnJhZGVhZC5v
cmc+IHdyb3RlOgo+ID4KPiA+IE9uIFR1ZSwgSnVsIDA0LCAyMDIzIGF0IDAyOjIxOjI4UE0gKzAy
MDAsIEphbiBLYXJhIHdyb3RlOgo+ID4gPiBDcmVhdGUgc3RydWN0IGJkZXZfaGFuZGxlIHRoYXQg
Y29udGFpbnMgYWxsIHBhcmFtZXRlcnMgdGhhdCBuZWVkIHRvIGJlCj4gPiA+IHBhc3NlZCB0byBi
bGtkZXZfcHV0KCkgYW5kIHByb3ZpZGUgYmxrZGV2X2dldF9oYW5kbGVfKiBmdW5jdGlvbnMgdGhh
dAo+ID4gPiByZXR1cm4gdGhpcyBzdHJ1Y3R1cmUgaW5zdGVhZCBvZiBwbGFpbiBiZGV2IHBvaW50
ZXIuIFRoaXMgd2lsbAo+ID4gPiBldmVudHVhbGx5IGFsbG93IHVzIHRvIHBhc3Mgb25lIG1vcmUg
YXJndW1lbnQgdG8gYmxrZGV2X3B1dCgpIHdpdGhvdXQKPiA+ID4gdG9vIG11Y2ggaGFzc2xlLgo+
ID4KPiA+IENhbiB3ZSB1c2UgdGhlIG9wcG9ydHVuaXR5IHRvIGNvbWUgdXAgd2l0aCBiZXR0ZXIg
bmFtZXM/ICBibGtkZXZfZ2V0XyoKPiA+IHdhcyBhbHdheXMgYSByYXRoZXIgaG9ycmlibGUgbmFt
aW5nIGNvbnZlbnRpb24gZm9yIHNvbWV0aGluZyB0aGF0Cj4gPiBlbmRzIHVwIGNhbGxpbmcgaW50
byAtPm9wZW4uCj4gPgo+ID4gV2hhdCBhYm91dDoKPiA+Cj4gPiBzdHJ1Y3QgYmRldl9oYW5kbGUg
KmJkZXZfb3Blbl9ieV9kZXYoZGV2X3QgZGV2LCBibGtfbW9kZV90IG1vZGUsIHZvaWQgKmhvbGRl
ciwKPiA+ICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1Y3QgYmxrX2hvbGRlcl9vcHMgKmhvcHMp
Owo+ID4gc3RydWN0IGJkZXZfaGFuZGxlICpiZGV2X29wZW5fYnlfcGF0aChkZXZfdCBkZXYsIGJs
a19tb2RlX3QgbW9kZSwKPiA+ICAgICAgICAgICAgICAgICB2b2lkICpob2xkZXIsIGNvbnN0IHN0
cnVjdCBibGtfaG9sZGVyX29wcyAqaG9wcyk7Cj4gPiB2b2lkIGJkZXZfcmVsZWFzZShzdHJ1Y3Qg
YmRldl9oYW5kbGUgKmhhbmRsZSk7Cj4gCj4gKzEgdG8gdGhpcy4KPiBBbHNvLCBpZiB3ZSBhcmUg
cmVtb3ZpbmcgImhhbmRsZSIgZnJvbSB0aGUgZnVuY3Rpb24sIHNob3VsZCB0aGUgbmFtZQo+IG9m
IHRoZSBzdHJ1Y3R1cmUgaXQgcmV0dXJucyBhbHNvIGNoYW5nZT8gV291bGQgc29tZXRoaW5nIGxp
a2UgYmRldl9jdHgKPiBiZSBiZXR0ZXI/CgpJIHRoaW5rIHRoZSBiZGV2X2hhbmRsZSBuYW1lIGlz
IGZpbmUgZm9yIHRoZSBzdHJ1Y3QuIEFmdGVyIGFsbCBpdCBpcwplcXVpdmFsZW50IG9mIGFuIG9w
ZW4gaGFuZGxlIGZvciB0aGUgYmxvY2sgZGV2aWNlIHNvIElNSE8gYmRldl9oYW5kbGUKY2FwdHVy
ZXMgdGhhdCBiZXR0ZXIgdGhhbiBiZGV2X2N0eC4KCgkJCQkJCQkJSG9uemEKLS0gCkphbiBLYXJh
IDxqYWNrQHN1c2UuY29tPgpTVVNFIExhYnMsIENSCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QK
ZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xp
c3RpbmZvL2RtLWRldmVsCg==

