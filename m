Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82594C7EE2F
	for <dm-devel@archiver.kernel.org>; Thu,  2 Mar 2023 19:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677783954;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lX3Eo5RhtWyvdiYgBHyGfs9Pm9HChc8W8Je39h9OTlM=;
	b=f/4jY2+D5ctdWjIcnbr35TM0wtze2OJGYxfK8HZ8DEJ4W7WMYgGu+2aNeHKpfLhNt7CU0a
	gvlpYvsOBnBFutFD7wptGYFNFDN1sKDBiPf6oVW3BuhB6zU9fyjr5VVLOdqnSHmEAKbTeO
	2el7p9DjtftJYe4btmyJrDc6Ud7JdiE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-308-KHJ9mpy_M2CXJK147JjMrw-1; Thu, 02 Mar 2023 14:05:50 -0500
X-MC-Unique: KHJ9mpy_M2CXJK147JjMrw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BED46802D2F;
	Thu,  2 Mar 2023 19:05:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB88D492B00;
	Thu,  2 Mar 2023 19:05:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 728EF19452D0;
	Thu,  2 Mar 2023 19:05:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B0C2A19452CD
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Mar 2023 19:05:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9675D2026D76; Thu,  2 Mar 2023 19:05:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E2B12026D4B
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 19:05:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E1DC38221CB
 for <dm-devel@redhat.com>; Thu,  2 Mar 2023 19:05:47 +0000 (UTC)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-363-S45RvF4iO2irITaggg4VAg-1; Thu, 02 Mar 2023 14:05:45 -0500
X-MC-Unique: S45RvF4iO2irITaggg4VAg-1
Received: by mail-pf1-f175.google.com with SMTP id n5so72832pfv.11
 for <dm-devel@redhat.com>; Thu, 02 Mar 2023 11:05:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1677783944;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=kKw96YimrLV8F+VfPY0RJRLjcN/M6IW13R0RuH+pecA=;
 b=66clnYKxBv9THh7NO2h+d8fRpeDlVm795FaPXidau0Crtz926pPs3+CYjpQfrfW+cH
 uKLYqdLENGgxwd3VCivoTBFdwAKfXjl+o4i4s5bdn/VVVX/IDMUBR5O3wyL1BzqK49BA
 S3JnAKohZRsCR9pDShjeSIKzZyuiw6ASUijWrskfSBhhPWJGa01t87QGlR295lvfSIkN
 kyLDVnVFsDVcqsMEKQTYe1FlgKFyc40np9biAfxlYkYOCbJs4hcDh9Div3Y3zsrJDhrC
 sVmkrW7HpcEkvhStkd8h7kONy7rFJn/2uIE5jMhNU0kgt6GOmX00kmSiu7UKSV7HQGp9
 XYHw==
X-Gm-Message-State: AO0yUKXMBp+DybEAQIdkhEd893T1ENoTEJPBi3W5tfUKfgv0eSP3rB+/
 RQvf0YRle1jvykysnBDKcTjTN5Pz2BIRIhzIvFs5
X-Google-Smtp-Source: AK7set9GakAc9W3sffqku5Nxb155E64D4u0/V0fl7OjF3yznVOjHB2ZwEOd+/4xCl7X6UG3aM5pSV/5L2w6ebrSd6Mw=
X-Received: by 2002:a05:6a00:26d0:b0:590:3182:9339 with SMTP id
 p16-20020a056a0026d000b0059031829339mr4326518pfw.0.1677783944283; Thu, 02 Mar
 2023 11:05:44 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-8-git-send-email-wufan@linux.microsoft.com>
 <3723852.kQq0lBPeGt@x2>
In-Reply-To: <3723852.kQq0lBPeGt@x2>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 2 Mar 2023 14:05:33 -0500
Message-ID: <CAHC9VhRqMrTuvVtwzJoK2U=6O1QuaQ8ceA6+qm=6ib0TOUEeSw@mail.gmail.com>
To: Steve Grubb <sgrubb@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [RFC PATCH v9 07/16] uapi|audit|ipe: add ipe
 auditing support
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
Cc: axboe@kernel.dk, Fan Wu <wufan@linux.microsoft.com>, tytso@mit.edu,
 corbet@lwn.net, roberto.sassu@huawei.com,
 Deven Bowers <deven.desai@linux.microsoft.com>, linux-doc@vger.kernel.org,
 snitzer@kernel.org, jmorris@namei.org, zohar@linux.ibm.com,
 linux-kernel@vger.kernel.org, ebiggers@kernel.org, dm-devel@redhat.com,
 linux-audit@redhat.com, linux-block@vger.kernel.org, eparis@redhat.com,
 linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKYW4gMzEsIDIwMjMgYXQgMTI6MTHigK9QTSBTdGV2ZSBHcnViYiA8c2dydWJiQHJl
ZGhhdC5jb20+IHdyb3RlOgo+Cj4gSGVsbG8sCj4KPiBPbiBNb25kYXksIEphbnVhcnkgMzAsIDIw
MjMgNTo1NzoyMiBQTSBFU1QgRmFuIFd1IHdyb3RlOgo+ID4gRnJvbTogRGV2ZW4gQm93ZXJzIDxk
ZXZlbi5kZXNhaUBsaW51eC5taWNyb3NvZnQuY29tPgo+ID4KPiA+IFVzZXJzIG9mIElQRSByZXF1
aXJlIGEgd2F5IHRvIGlkZW50aWZ5IHdoZW4gYW5kIHdoeSBhbiBvcGVyYXRpb24gZmFpbHMsCj4g
PiBhbGxvd2luZyB0aGVtIHRvIGJvdGggcmVzcG9uZCB0byB2aW9sYXRpb25zIG9mIHBvbGljeSBh
bmQgYmUgbm90aWZpZWQKPiA+IG9mIHBvdGVudGlhbGx5IG1hbGljaW91cyBhY3Rpb25zIG9uIHRo
ZWlyIHN5c3RlbnMgd2l0aCByZXNwZWN0IHRvIElQRQo+ID4gaXRzZWxmLgo+ID4KPiA+IFRoZSBu
ZXcgMTQyMCBhdWRpdCwgQVVESVRfSVBFX0FDQ0VTUyBpbmRpY2F0ZXMgdGhlIHJlc3VsdCBvZiBh
IHBvbGljeQo+ID4gZXZhdWxhdGlvbiBvZiBhIHJlc291cmNlLiBUaGUgb3RoZXIgdHdvIGV2ZW50
cywgQVVESVRfTUFDX1BPTElDWV9MT0FELAo+ID4gYW5kIEFVRElUX01BQ19DT05GSUdfQ0hBTkdF
IHJlcHJlc2VudCBhIG5ldyBwb2xpY3kgd2FzIGxvYWRlZCBpbnRvIHRoZQo+ID4ga2VybmVsIGFu
ZCB0aGUgY3VycmVudGx5IGFjdGl2ZSBwb2xpY3kgY2hhbmdlZCwgcmVzcGVjdGl2ZWx5Lgo+Cj4g
VHlwaWNhbGx5IHdoZW4geW91IHJldXNlIGFuIGV4aXN0aW5nIHJlY29yZCB0eXBlLCBpdCBpcyBl
eHBlY3RlZCB0byBtYWludGFpbgo+IHRoZSBzYW1lIGZpZWxkcyBpbiB0aGUgc2FtZSBvcmRlci4g
QWxzbywgaXQgaXMgZXhwZWN0IHRoYXQgZmllbGRzIHRoYXQgYXJlCj4gY29tbW9uIGFjcm9zcyBk
aWZlcmVudCByZWNvcmRzIGhhdmUgdGhlIHNhbWUgbWVhbmluZy4gVG8gYWlkIGluIHRoaXMsIHdl
IGhhdmUKPiBhIGZpZWxkIGRpY3Rpb25hcnkgaGVyZToKPgo+IGh0dHBzOi8vZ2l0aHViLmNvbS9s
aW51eC1hdWRpdC9hdWRpdC1kb2N1bWVudGF0aW9uL2Jsb2IvbWFpbi9zcGVjcy9maWVsZHMvCj4g
ZmllbGQtZGljdGlvbmFyeS5jc3YKPgo+IEZvciBleGFtcGxlLCBkZXYgaXMgZXhwZWN0ZWQgdG8g
YmUgMiBoZXggbnVtYmVycyBzZXBhcmF0ZWQgYnkgYSBjb2xvbiB3aGljaAo+IGFyZSB0aGUgZGV2
aWNlIG1ham9yIGFuZCBtaW5vciBudW1iZXJzLiBCdXQgZG93biBhIGNvdXBsZSBsaW5lcyBmcm9t
IGhlcmUsIHdlCj4gZmluZCBkZXY9InRtcGZzIi4gQnV0IGlzbid0IHRoYXQgYSBmaWxlc3lzdGVt
IHR5cGU/CgpXaGF0IFN0ZXZlIHNhaWQuCgpJJ2xsIGFsc28gYWRkIGFuIGFkbWluaXN0cmF0aXZl
IG5vdGUsIHdlIGp1c3QgbW92ZWQgdXBzdHJlYW0gTGludXgKYXVkaXQgZGV2ZWxvcG1lbnQgdG8g
YSBuZXcgbWFpbGluZyBsaXN0LCBhdWRpdEB2Z2VyLmtlcm5lbC5vcmcsIHBsZWFzZQp1c2UgdGhh
dCBpbiBmdXR1cmUgcGF0Y2ggc3VibWlzc2lvbnMuICBBcyBhIHBvc2l0aXZlLCBpdCdzIGEgZnVs
bHkKb3BlbiBsaXN0IHNvIHlvdSB3b24ndCBydW4gaW50byBtb2RlcmF0aW9uIGRlbGF5cy9ub3Rp
ZmljYXRpb25zL2V0Yy4KCj4gPiBUaGlzIHBhdGNoIGFsc28gYWRkcyBzdXBwb3J0IGZvciBzdWNj
ZXNzIGF1ZGl0aW5nLCBhbGxvd2luZyB1c2VycyB0bwo+ID4gaWRlbnRpZnkgaG93IGEgcmVzb3Vy
Y2UgcGFzc2VkIHBvbGljeS4gSXQgaXMgcmVjb21tZW5kZWQgdG8gdXNlIHRoaXMKPiA+IG9wdGlv
biB3aXRoIGNhdXRpb24sIGFzIGl0IGlzIHF1aXRlIG5vaXN5Lgo+ID4KPiA+IFRoaXMgcGF0Y2gg
YWRkcyB0aGUgZm9sbG93aW5nIGF1ZGl0IHJlY29yZHM6Cj4gPgo+ID4gICBhdWRpdDogQVVESVQx
NDIwIHBhdGg9Ii90bXAvdG1wd3htYW0zNjYvZGVueS9iaW4vaGVsbG8iIGRldj0idG1wZnMiCj4g
PiAgICAgaW5vPTcyIHJ1bGU9IkRFRkFVTFQgb3A9RVhFQ1VURSBhY3Rpb249REVOWSIKPgo+IERv
IHdlIHJlYWxseSBuZWVkIHRvIGxvZyB0aGUgd2hvbGUgcnVsZT8KCkZhbiwgd291bGQgaXQgYmUg
cmVhc29uYWJsZSB0byBsaXN0IHRoZSBwcm9wZXJ0aWVzIHdoaWNoIGNhdXNlZCB0aGUKYWNjZXNz
IGRlbmlhbD8gIFRoYXQgc2VlbXMgbGlrZSBpdCBtaWdodCBiZSBtb3JlIGhlbHBmdWwgdGhhbiB0
aGUKc3BlY2lmaWMgcnVsZSwgb3IgYW0gSSBtaXNzaW5nIHNvbWV0aGluZz8KCj4gPiAgIFRoZSBh
Ym92ZSBhdWRpdCByZWNvcmQgc2hvd3MgSVBFIGJsb2NrZWQgYSBmaWxlCj4gPiAgICAgL3RtcC90
bXB3eG1hbTM2Ni9kZW55L2Jpbi9oZWxsbyBpbiB0aGUgdGVtcCBmaWxlIHN5c3RlbS4KPiA+Cj4g
PiAgIGF1ZGl0OiBBVURJVDE0MjAgcGF0aD0iL3RtcC90bXB4a3ZiM2Q5eC9kZW55L2Jpbi9oZWxs
byIgZGV2PSJ0bXBmcyIKPiA+ICAgICBpbm89MTU3IHJ1bGU9IkRFRkFVTFQgYWN0aW9uPURFTlki
Cj4gPgo+ID4gICBUaGUgYWJvdmUgYXVkaXQgcmVjb3JkIHNob3dzIElQRSBibG9ja2VkIGEgZmls
ZQo+ID4gICAgIC90bXAvdG1weGt2YjNkOXgvZGVueS9iaW4vaGVsbG8gaW4gdGhlIHRlbXAgZmls
ZSBzeXN0ZW0gdmlhIGFub3RoZXIKPiA+ICAgICBydWxlLgo+ID4KPiA+ICAgYXVkaXQ6IE1BQ19Q
T0xJQ1lfTE9BRCBwb2xpY3lfbmFtZT0iZG12ZXJpdHlfcm9vdGhhc2giCj4gPiAgICAgcG9saWN5
X3ZlcnNpb249MC4wLjAgc2hhMjU2PURDNjdBQzE5RTA1ODk0RUZCMzE3MEE4RTU1REU1Mjk3OTRF
MjQ4QzIKPiA+ICAgICBhdWlkPTQyOTQ5NjcyOTUgc2VzPTQyOTQ5NjcyOTUgbHNtPWlwZSByZXM9
MQo+Cj4gVGhlIE1BQ19QT0xJQ1lfTE9BRCByZWNvcmQgdHlwZSBzaW1wbHkgc3RhdGVzIHRoZSBs
c20gdGhhdCBoYWQgaXQncyBwb2xpY3kKPiBsb2FkZWQuIFRoZXJlIGlzbid0IG5hbWUsIHZlcnNp
b24sIGFuZCBoYXNoIGluZm9ybWF0aW9uLiBJJ2QgcHJlZmVyIHRvIHNlZQo+IGFsbCB1c2VycyBv
ZiB0aGlzIHJlY29yZCB0eXBlIGRlY2lkZSBpZiBpdCBzaG91bGQgYmUgZXh0ZW5kZWQgYmVjYXVz
ZSB0aGV5Cj4gYWxzbyBoYXZlIHRoYXQgaW5mb3JtYXRpb24gYXZhaWxhYmxlIHRvIHJlY29yZC4K
Ck5vdCBhbGwgTFNNcyB3aGljaCBsb2FkIHBvbGljeSBoYXZlIHRoYXQgaW5mb3JtYXRpb247IGFz
IGFuIGV4YW1wbGUsClNFTGludXggZG9lc24ndCBoYXZlIHRoZSBjb25jZXB0IG9mIGEgcG9saWN5
IG5hbWUgb3IgdmVyc2lvbi4gIFRoZQpTRUxpbnV4IHBvbGljeSB2ZXJzaW9uIHlvdSBtaWdodCBz
ZWUgaW4gdGhlIGtlcm5lbCBzb3VyY2VzIHJlZmVycyB0bwp0aGUgcG9saWN5IGZvcm1hdCB2ZXJz
aW9uIGFuZCBoYXMgbm8gYmVhcmluZyBvbiB0aGUgYWN0dWFsIHBvbGljeQpjb250ZW50IGJleW9u
ZCB0aGF0IGRpY3RhdGVkIGJ5IHRoZSBmb3JtYXQuCgpJZiBhZGRpdGlvbmFsIGluZm9ybWF0aW9u
IGlzIHJlcXVpcmVkIGJ5IElQRSwgcGVyaGFwcyBhbiBhdXhpbGlhcnkgSVBFCnBvbGljeSBsb2Fk
IHJlY29yZCBjb3VsZCBiZSBjcmVhdGVkIHdpdGggdGhvc2UgYWRkaXRpb25hbCBmaWVsZHMuCgo+
ID4gICBUaGUgYWJvdmUgYXVkaXQgcmVjb3JkIHNob3dzIElQRSBsb2FkZWQgYSBuZXcgcG9saWN5
IG5hbWVkCj4gPiAgICAgImRtdmVyaXR5X3Jvb3RoYXNoIiB3aXRoIHRoZSBzaGEyNTYgaGFzaCBv
ZiB0aGUgcG9saWN5Lgo+ID4KPiA+ICAgYXVkaXQ6IE1BQ19DT05GSUdfQ0hBTkdFIG9sZF9hY3Rp
dmVfcG9sX25hbWU9IkFsbG93X0FsbCIKPiA+ICAgICBvbGRfYWN0aXZlX3BvbF92ZXJzaW9uPTAu
MC4wCj4gPiAgICAgb2xkX3NoYTI1Nj1EQTM5QTNFRTVFNkI0QjBEMzI1NUJGRUY5NTYwMTg5MEFG
RDgwNzA5Cj4gPiAgICAgbmV3X2FjdGl2ZV9wb2xfbmFtZT0iZG12ZXJpdHlfcm9vdGhhc2giIG5l
d19hY3RpdmVfcG9sX3ZlcnNpb249MC4wLjAKPiA+ICAgICBuZXdfc2hhMjU2PURDNjdBQzE5RTA1
ODk0RUZCMzE3MEE4RTU1REU1Mjk3OTRFMjQ4QzIKPiA+ICAgICBhdWlkPTQyOTQ5NjcyOTUgc2Vz
PTQyOTQ5NjcyOTUgbHNtPWlwZSByZXM9MQo+ID4KPiA+ICAgVGhlIGFib3ZlIGF1ZGl0IHJlY29y
ZCBzaG93cyBJUEUncyBhY3RpdmUgcG9saWN5IHN3aXRjaGVkIGZyb20KPiA+ICAgICAiQWxsb3df
QWxsIiB0byAiZG12ZXJpdHlfcm9vdGhhc2giLgo+Cj4gU2hvdWxkbid0IHRoaXMganVzdCBiZSBh
bm90aGVyIE1BQ19QT0xJQ1lfTE9BRD8gVGhhdCB3b3VsZCBtYXRjaCBvdGhlciBMU00ncy4KPiBU
aGUgTUFDX0NPTkZJR19DSEFOR0UgaXMgdG8gZGVub3RlIHRoYXQgYSBjaGFuZ2VhYmxlIG9wdGlv
biB3YXMgbW9kaWZpZWQgZnJvbQo+IG9uZSB2YWx1ZSB0byBhbm90aGVyLiBCdXQgaXQgaXMgc3Rp
bGwgb3BlcmF0aW5nIHVuZGVyIHRoZSBzYW1lIHBvbGljeS4KCklmIGl0IGlzIGp1c3Qgc3dpdGNo
aW5nIGZyb20gb25lIHByZXZpb3VzbHkgbG9hZGVkIHBvbGljeSB0byBhbm90aGVyLAppdCBzZWVt
cyBsaWtlIE1BQ19DT05GSUdfQ0hBTkdFIG1pZ2h0IGJlIHRoZSBiZXN0IGNob2ljZS4KCi0tCnBh
dWwtbW9vcmUuY29tCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

