Return-Path: <SRS0=jAWR=FP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C82DC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:04:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8E1AE23D3C
	for <dm-devel@archiver.kernel.org>; Fri, 11 Dec 2020 18:04:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E1AE23D3C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-leIgWrmSOs6lvFcJw4MnUA-1; Fri, 11 Dec 2020 13:03:56 -0500
X-MC-Unique: leIgWrmSOs6lvFcJw4MnUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEBFE190A7AD;
	Fri, 11 Dec 2020 18:03:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 34A125D9D2;
	Fri, 11 Dec 2020 18:03:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DA337180954D;
	Fri, 11 Dec 2020 18:03:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BBI3ke2027362 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Dec 2020 13:03:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 71A032026D3F; Fri, 11 Dec 2020 18:03:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C5DB2026D3B
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 18:03:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2169858287
	for <dm-devel@redhat.com>; Fri, 11 Dec 2020 18:03:41 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-383-9h44x2TTO0Kf40PmJEQl2A-1;
	Fri, 11 Dec 2020 13:03:39 -0500
X-MC-Unique: 9h44x2TTO0Kf40PmJEQl2A-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C087DAE4A;
	Fri, 11 Dec 2020 18:03:37 +0000 (UTC)
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Sergei Shtepa <sergei.shtepa@veeam.com>, hch@lst.de
References: <1607518911-30692-1-git-send-email-sergei.shtepa@veeam.com>
	<20201209135148.GA32720@redhat.com> <20201210145814.GA31521@veeam.com>
	<20201210163222.GB10239@redhat.com> <20201211163049.GC16168@redhat.com>
	<1ee7652e-b77f-6fa4-634c-ff6639037321@kernel.dk>
	<208edf35-ecdc-2d73-4c48-0424943a78c0@suse.de>
	<06b4a10d-5ea5-27e1-af0d-83d5c714996f@kernel.dk>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <b4f3ee74-58fd-52c8-ae60-f352758fb42a@suse.de>
Date: Fri, 11 Dec 2020 19:03:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <06b4a10d-5ea5-27e1-af0d-83d5c714996f@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BBI3ke2027362
X-loop: dm-devel@redhat.com
Cc: "steve@sk2.org" <steve@sk2.org>,
	"johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
	Pavel Tide <Pavel.TIde@veeam.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@redhat.com, "koct9i@gmail.com" <koct9i@gmail.com>
Subject: Re: [dm-devel] [PATCH 0/3] block: blk_interposer - Block Layer
	Interposer
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTIvMTEvMjAgNjowNCBQTSwgSmVucyBBeGJvZSB3cm90ZToKPiBPbiAxMi8xMS8yMCA5OjU2
IEFNLCBIYW5uZXMgUmVpbmVja2Ugd3JvdGU6Cj4+IE9uIDEyLzExLzIwIDU6MzMgUE0sIEplbnMg
QXhib2Ugd3JvdGU6Cj4+PiBPbiAxMi8xMS8yMCA5OjMwIEFNLCBNaWtlIFNuaXR6ZXIgd3JvdGU6
Cj4+Pj4gV2hpbGUgSSBzdGlsbCB0aGluayB0aGVyZSBuZWVkcyB0byBiZSBhIHByb3BlciBfdXBz
dHJlYW1fIGNvbnN1bWVyIG9mCj4+Pj4gYmxrX2ludGVycG9zZXIgYXMgYSBjb25kaXRpb24gb2Yg
aXQgZ29pbmcgaW4uLiBJJ2xsIGxldCBvdGhlcnMgbWFrZSB0aGUKPj4+PiBjYWxsLgo+Pj4KPj4+
IFRoYXQncyBhbiB1bmVxdWl2b2NhbCBydWxlLgo+Pj4KPj4+PiBBcyBzdWNoLCBJJ2xsIGRlZmVy
IHRvIEplbnMsIENocmlzdG9waCBhbmQgb3RoZXJzIG9uIHdoZXRoZXIgeW91cgo+Pj4+IG1pbmlt
YWxpc3QgYmxrX2ludGVycG9zZXIgaG9vayBpcyBhY2NlcHRhYmxlIGluIHRoZSBuZWFyLXRlcm0u
Cj4+Pgo+Pj4gSSBkb24ndCB0aGluayBzbywgd2UgZG9uJ3QgZG8gc2hvcnQgdGVybSBiYW5kYWlk
cyBqdXN0IHRvIHBsYW4gb24KPj4+IHJpcHBpbmcgdGhhdCBvdXQgd2hlbiB0aGUgcmVhbCBmdW5j
dGlvbmFsaXR5IGlzIHRoZXJlLiBJTUhPLCB0aGUgZG0KPj4+IGFwcHJvYWNoIGlzIHRoZSB3YXkg
dG8gZ28gLSBpdCBwcm92aWRlcyBleGFjdGx5IHRoZSBmdW5jdGlvbmFsaXR5IHRoYXQKPj4+IGlz
IG5lZWRlZCBpbiBhbiBhcHByb3ByaWF0ZSB3YXksIGluc3RlYWQgb2YgaGFja2luZyBzb21lICJp
bnRlcnBvc2VyIgo+Pj4gaW50byB0aGUgY29yZSBibG9jayBsYXllci4KPj4+Cj4+IFdoaWNoIGlz
IG15IHBsYW4sIHRvby4KPj4KPj4gSSdsbCBiZSB3b3JraW5nIHdpdGggdGhlIFZlZWFtIGZvbGtz
IHRvIHByZXNlbnQgYSBqb2ludCBwYXRjaHNldAo+PiAoaW5jbHVkaW5nIHRoZSBETSBiaXRzKSBm
b3IgdGhlIG5leHQgcm91bmQuCj4gCj4gSnVzdCB0byBiZSBjbGVhciwgY29yZSBibG9jayBhZGRp
dGlvbnMgZm9yIHNvbWV0aGluZyB0aGF0IGRtIHdpbGwKPiBjb25zdW1lIGlzIG9idmlvdXNseSBm
aW5lLiBBZGRpbmcgdGhpcyBhcyBibG9jayBsYXllciBmdW5jdGlvbmFsaXR5IHRoYW4KPiB0aGVu
IGV4cG9zZXMgYW4gYXBwbGljYXRpb24gQVBJIGZvciBzZXR0aW5nIGl0IHVwLCB0ZWFyaW5nIGRv
d24sIGV0YyAtCj4gdGhhdCBpcyBkZWZpbml0ZWx5IE5PVAo+IApUaGF0IHdhcyBuZXZlciBteSBp
bnRlbnRpb24uCkFueSBjb25zdW1lcnMgb2YgdGhpcyB0aGluZyB3b3VsZCBuZWVkIHRvIGJlIGlu
LWtlcm5lbC4KSWYgdGhhdCB3YXMgeW91ciBjb25jZXJuLgoKQ2hlZXJzLAoKSGFubmVzCi0tIApE
ci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVj
dApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTExIDc0MDUz
IDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBO
w7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJlcjogRmVs
aXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly93d3cucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs

