Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63E8BC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 22:35:57 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-q_qu7M-0OoGZUzaPOaj85w-1; Mon, 14 Feb 2022 17:35:51 -0500
X-MC-Unique: q_qu7M-0OoGZUzaPOaj85w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DA9C2F44;
	Mon, 14 Feb 2022 22:35:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B55366ABBF;
	Mon, 14 Feb 2022 22:35:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 94A9F4BB7C;
	Mon, 14 Feb 2022 22:35:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21EMZcXd024160 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 17:35:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EC5BB7AD6; Mon, 14 Feb 2022 22:35:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E3DBA7AD5
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 22:35:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B1EB108C1C3
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 22:35:26 +0000 (UTC)
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au
	[211.29.132.246]) by relay.mimecast.com with ESMTP id
	us-mta-99-lEOxJtPeOBy3XcTdMGe6gQ-1; Mon, 14 Feb 2022 17:35:22 -0500
X-MC-Unique: lEOxJtPeOBy3XcTdMGe6gQ-1
Received: from dread.disaster.area (pa49-186-85-251.pa.vic.optusnet.com.au
	[49.186.85.251])
	by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 793C852DCD8;
	Tue, 15 Feb 2022 09:08:12 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
	(envelope-from <david@fromorbit.com>)
	id 1nJjW0-00C4n4-91; Tue, 15 Feb 2022 09:08:12 +1100
Date: Tue, 15 Feb 2022 09:08:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
Message-ID: <20220214220741.GB2872883@dread.disaster.area>
References: <CGME20220214080551epcas5p201d4d85e9d66077f97585bb3c64517c0@epcas5p2.samsung.com>
	<20220214080002.18381-1-nj.shetty@samsung.com>
MIME-Version: 1.0
In-Reply-To: <20220214080002.18381-1-nj.shetty@samsung.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=620ad2d3
	a=2CV4XU02g+4RbH+qqUnf+g==:117 a=2CV4XU02g+4RbH+qqUnf+g==:17
	a=IkcTkHD0fZMA:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
	a=JFXMuzjNVKxm2W9Oq_QA:9 a=QEXdDO2ut3YA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21EMZcXd024160
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
	javier@javigon.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
	James Smart <james.smart@broadcom.com>, hch@lst.de,
	chaitanyak@nvidia.com, Chaitanya Kulkarni <kch@nvidia.com>,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, Sagi Grimberg <sagi@grimberg.me>,
	axboe@kernel.dk, tytso@mit.edu, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 00/10] Add Copy offload support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBGZWIgMTQsIDIwMjIgYXQgMDE6Mjk6NTBQTSArMDUzMCwgTml0ZXNoIFNoZXR0eSB3
cm90ZToKPiBUaGUgcGF0Y2ggc2VyaWVzIGNvdmVycyB0aGUgcG9pbnRzIGRpc2N1c3NlZCBpbiBO
b3ZlbWJlciAyMDIxIHZpcnR1YWwgY2FsbAo+IFtMU0YvTU0vQkZQIFRPUElDXSBTdG9yYWdlOiBD
b3B5IE9mZmxvYWRbMF0uCj4gV2UgaGF2ZSBjb3ZlcmVkIHRoZSBJbml0aWFsIGFncmVlZCByZXF1
aXJlbWVudHMgaW4gdGhpcyBwYXRjaHNldC4KPiBQYXRjaHNldCBib3Jyb3dzIE1pa3VsYXMncyB0
b2tlbiBiYXNlZCBhcHByb2FjaCBmb3IgMiBiZGV2Cj4gaW1wbGVtZW50YXRpb24uCj4gCj4gT3Zl
cmFsbCBzZXJpZXMgc3VwcG9ydHMg4oCTCj4gCj4gMS4gRHJpdmVyCj4gLSBOVk1lIENvcHkgY29t
bWFuZCAoc2luZ2xlIE5TKSwgaW5jbHVkaW5nIHN1cHBvcnQgaW4gbnZtZS10YXJnZXQgKGZvcgo+
IAlibG9jayBhbmQgZmlsZSBiYWNrZW5kKQo+IAo+IDIuIEJsb2NrIGxheWVyCj4gLSBCbG9jay1n
ZW5lcmljIGNvcHkgKFJFUV9DT1BZIGZsYWcpLCB3aXRoIGludGVyZmFjZSBhY2NvbW1vZGF0aW5n
Cj4gCXR3byBibG9jay1kZXZzLCBhbmQgbXVsdGktc291cmNlL2Rlc3RpbmF0aW9uIGludGVyZmFj
ZQo+IC0gRW11bGF0aW9uLCB3aGVuIG9mZmxvYWQgaXMgbmF0aXZlbHkgYWJzZW50Cj4gLSBkbS1s
aW5lYXIgc3VwcG9ydCAoZm9yIGNhc2VzIG5vdCByZXF1aXJpbmcgc3BsaXQpCj4gCj4gMy4gVXNl
ci1pbnRlcmZhY2UKPiAtIG5ldyBpb2N0bAo+IAo+IDQuIEluLWtlcm5lbCB1c2VyCj4gLSBkbS1r
Y29weWQKClRoZSBiaWdnZXN0IG1pc3NpbmcgcGllY2UgLSBhbmQgYXJndWFibHkgdGhlIHNpbmds
ZSBtb3N0IHVzZWZ1bApwaWVjZSBvZiB0aGlzIGZ1bmN0aW9uYWxpdHkgZm9yIHVzZXJzIC0gaXMg
aG9va2luZyB0aGlzIHVwIHRvIHRoZQpjb3B5X2ZpbGVfcmFuZ2UoKSBzeXNjYWxsIHNvIHRoYXQg
dXNlciBmaWxlIGNvcGllcyBjYW4gYmUgb2ZmbG9hZGVkCnRvIHRoZSBoYXJkd2FyZSBlZmZpY2ll
bnRseS4KClRoaXMgc2VlbXMgbGlrZSBpdCB3b3VsZCByZWxhdGl2ZWx5IGVhc3kgdG8gZG8gd2l0
aCBhbiBmcy9pb21hcCBpdGVyCmxvb3AgdGhhdCBtYXBzIHNyYyArIGRzdCBmaWxlIHJhbmdlcyBh
bmQgaXNzdWVzIGJsb2NrIGNvcHkgb2ZmbG9hZApjb21tYW5kcyBvbiB0aGUgZXh0ZW50cy4gV2Ug
YWxyZWFkeSBkbyBzaW1pbGFyICJyZWFkIGZyb20gc291cmNlLAp3cml0ZSB0byBkZXN0aW5hdGlv
biIgb3BlcmF0aW9ucyBpbiBpb21hcCwgc28gaXQncyBub3QgYSBodWdlCnN0cmV0Y2ggdG8gZXh0
ZW50IHRoZSBpb21hcCBpbnRlcmZhY2VzIHRvIHByb3ZpZGUgYW4gY29weSBvZmZsb2FkCm1lY2hh
bmlzbSB1c2luZyB0aGlzIGluZnJhc3RydWN0dXJlLgoKQWxzbywgaG9va2luZyB0aGlzIHVwIHRv
IGNvcHktZmlsZS1yYW5nZSgpIHdpbGwgYWxzbyBnZXQgeW91CmltbWVkaWF0ZSBkYXRhIGludGVn
cml0eSB0ZXN0aW5nIHJpZ2h0IGRvd24gdG8gdGhlIGhhcmR3YXJlIHZpYSBmc3gKaW4gZnN0ZXN0
cyAtIGl0IHVzZXMgY29weV9maWxlX3JhbmdlKCkgYXMgb25lIG9mIGl0J3Mgb3BlcmF0aW9ucyBh
bmQKaXQgd2lsbCBmaW5kIGFsbCB0aGUgb2ZmLWJ5LW9uZSBmYWlsdXJlcyBpbiBib3RoIHRoZSBs
aW51eCBJTyBzdGFjawppbXBsZW1lbnRhdGlvbiBhbmQgdGhlIGhhcmR3YXJlIGl0c2VsZi4KCkFu
ZCwgaW4gcmVhbGl0eSwgSSB3b3VsZG4ndCB0cnVzdCBhIGJsb2NrIGNvcHkgb2ZmbG9hZCBtZWNo
YW5pc20KdW50aWwgaXQgaXMgaW50ZWdyYXRlZCB3aXRoIGZpbGVzeXN0ZW1zLCB0aGUgcGFnZSBj
YWNoZSBhbmQgaGFzCnNvbGlkIGVuZC10by1lbmQgZGF0YSBpbnRlZ3JpdHkgdGVzdGluZyBhdmFp
bGFibGUgdG8gc2hha2Ugb3V0IGFsbAp0aGUgYnVncyB0aGF0IHdpbGwgaW5ldml0YWJseSBleGlz
dCBpbiB0aGlzIHN0YWNrLi4uLgoKQ2hlZXJzLAoKRGF2ZS4KLS0gCkRhdmUgQ2hpbm5lcgpkYXZp
ZEBmcm9tb3JiaXQuY29tCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bA==

