Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A248C6FA8E
	for <dm-devel@archiver.kernel.org>; Tue, 27 Sep 2022 14:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664289293;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=41clk40hd07JDxI6kMtALGAxnSGTkgnln8xdf3r8oAg=;
	b=AT4JbHZMIyHwdmdOavDD4OjFIBg37ONl2FpvximP4e5t2i1czX517oWqaHiPhEa+8Zb35B
	0D2zH66xiv3vNX40SeegNWDIb2SdCwbS1dg3985D2v26n2lTVjtySWK5DwLGD8OxetDEkS
	9M7cSBhZBOpaSGeBaIWDX/lFG0B5w10=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-7hwNzweSMxG1GuwwoxE9mQ-1; Tue, 27 Sep 2022 10:34:50 -0400
X-MC-Unique: 7hwNzweSMxG1GuwwoxE9mQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 209E1380673E;
	Tue, 27 Sep 2022 14:34:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BF48D492B05;
	Tue, 27 Sep 2022 14:34:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8663D19465B1;
	Tue, 27 Sep 2022 14:34:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 477301946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 27 Sep 2022 14:34:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 330DC400E88E; Tue, 27 Sep 2022 14:34:46 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com
 (segfault.boston.devel.redhat.com [10.19.60.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C92F64048CD4;
 Tue, 27 Sep 2022 14:34:45 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: =?utf-8?Q?Yang=2C_Xiao=2F=E6=9D=A8_=E6=99=93?= <yangx.jy@fujitsu.com>
References: <e0cce6af-fd55-a582-194e-7f8a3aced6b0@fujitsu.com>
 <x49y1u5lxpt.fsf@segfault.boston.devel.redhat.com>
 <a04a8253-44af-11d6-f2ab-6421fe5110a8@fujitsu.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Tue, 27 Sep 2022 10:38:34 -0400
In-Reply-To: <a04a8253-44af-11d6-f2ab-6421fe5110a8@fujitsu.com> (Xiao Yang's
 message of "Tue, 27 Sep 2022 20:42:38 +0800")
Message-ID: <x49tu4sc26t.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] Question about which types of dm need to support DAX
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
Cc: toshi.kani@hpe.com, snitzer@redhat.com,
 Shiyang Ruan <ruansy.fnst@fujitsu.com>,
 "y-goto@fujitsu.com" <y-goto@fujitsu.com>, dm-devel@redhat.com,
 =?utf-8?B?R3UsIEppbnhpYW5nL+mhviDph5Hpppk=?= <gujx@fujitsu.com>,
 zwisler@kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

IllhbmcsIFhpYW8v5p2oIOaZkyIgPHlhbmd4Lmp5QGZ1aml0c3UuY29tPiB3cml0ZXM6Cgo+IEhp
IEplZmYsCj4KPiBUaGFua3MgYSBsb3QgZm9yIHlvdXIgcmVwbHkuCj4KPiBPbiAyMDIyLzkvMjcg
Mzo1MiwgSmVmZiBNb3llciB3cm90ZToKPj4gIllhbmcsIFhpYW8v5p2oIOaZkyIgPHlhbmd4Lmp5
QGZ1aml0c3UuY29tPiB3cml0ZXM6Cj4+Cj4+PiBIaSBSb3NzLCBUb3NoaSwgSmVmZiBhbmQgb3Ro
ZXJzCj4+Pgo+Pj4gQWZ0ZXIgcmVhZGluZyB0aGUga2VybmVsIHBhdGNoZXNbMV1bMl1bM10gYWJv
dXQgZG0sIEkgdGhpbmsgb25seSB0aHJlZQo+Pj4gdHlwZXMobGluZWFyLCBzdHJpcGUgYW5kIGxv
Zy13cml0ZXMpIG9mIGRtIGNhbiBzdXBwb3J0IERBWCBub3csIHJpZ2h0Pwo+Pgo+PiBSaWdodC4K
Pj4KPj4+IEkgd29uZGVyIHdoeSBvbmx5IHRocmVlIHR5cGVzIG9mIGRtIG5lZWQgdG8gc3VwcG9y
dCBEQVg/IElzIHRoZXJlIGFueQo+Pj4gcmVhc29uL2hpc3RvcnkgYW5kIHVzZSBjYXNlPwo+Pgo+
PiBJdCB3YXMgZWFzeSB0byBhZGQgREFYIHN1cHBvcnQgdG8gdGhvc2UgdGFyZ2V0cy4gIE5vdGUg
dGhhdCBpZiBhIHRhcmdldAo+PiBuZWVkcyB0byBpbnRlcmNlcHQgSS9PLCB0aGVuIGl0IGlzIGZ1
bmRhbWVudGFsbHkgaW5jb21wYXRpYmxlIHdpdGggREFYLgo+Cj4gSG93IGNhbiBJIGtub3cgd2hp
Y2ggdGFyZ2V0IG5lZWRzIHRvIGludGVyY2VwdCBJL08/CgpUaGVyZSdzIG5vIGJldHRlciB3YXkg
dGhhbiByZWFkaW5nIGFuZCB1bmRlcnN0YW5kaW5nIHdoYXQgZWFjaCB0YXJnZXQKZG9lcy4KCj4g
Q291bGQgeW91IHRlbGwgbWUgd2h5IGl0IGlzIGZ1bmRhbWVudGFsbHkgaW5jb21wYXRpYmxlIHdp
dGggREFYPwoKREFYIHN0YW5kcyBmb3IgZGlyZWN0IGFjY2VzcywgYW5kIGl0IGlzIGEgbWVjaGFu
aXNtIGJ5IHdoaWNoIGEKdXNlci1zcGFjZSBwcm9jZXNzIGNhbiBwZXJmb3JtIEkvTyB3aXRob3V0
IGdvaW5nIHRocm91Z2ggdGhlIGtlcm5lbC4KCi1KZWZmCi0tCmRtLWRldmVsIG1haWxpbmcgbGlz
dApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4v
bGlzdGluZm8vZG0tZGV2ZWwK

