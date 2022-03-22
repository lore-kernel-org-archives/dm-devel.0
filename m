Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B42C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Mar 2022 11:30:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-woIhPbXOPheHZALuMkVF7w-1; Tue, 22 Mar 2022 07:30:31 -0400
X-MC-Unique: woIhPbXOPheHZALuMkVF7w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4604D28078DD;
	Tue, 22 Mar 2022 11:30:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2500F46517B;
	Tue, 22 Mar 2022 11:30:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AF0CB1940340;
	Tue, 22 Mar 2022 11:30:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AC54A1947BBC
 for <dm-devel@listman.corp.redhat.com>; Tue, 22 Mar 2022 11:30:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 86F4146517B; Tue, 22 Mar 2022 11:30:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8233F465170
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:30:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A9123C153AA
 for <dm-devel@redhat.com>; Tue, 22 Mar 2022 11:30:27 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-0axSnY9CNLSyrNZYa3VEDw-1; Tue, 22 Mar 2022 07:30:25 -0400
X-MC-Unique: 0axSnY9CNLSyrNZYa3VEDw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id E0F35210F2;
 Tue, 22 Mar 2022 11:30:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BAC4A133B6;
 Tue, 22 Mar 2022 11:30:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id fv4zLU+zOWJGSQAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 22 Mar 2022 11:30:23 +0000
Message-ID: <1537235d-ac22-6914-4b31-4482e9536098@suse.de>
Date: Tue, 22 Mar 2022 12:30:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
To: John Garry <john.garry@huawei.com>, axboe@kernel.dk,
 damien.lemoal@opensource.wdc.com, bvanassche@acm.org, jejb@linux.ibm.com,
 martin.petersen@oracle.com, hch@lst.de, ming.lei@redhat.com
References: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <1647945585-197349-1-git-send-email-john.garry@huawei.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH RFC 00/11] blk-mq/libata/scsi: SCSI driver
 tagging improvements
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
Cc: linux-scsi@vger.kernel.org, chenxiang66@hisilicon.com,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-ide@vger.kernel.org, dm-devel@redhat.com, beanhuo@micron.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8yMi8yMiAxMTozOSwgSm9obiBHYXJyeSB3cm90ZToKPiBDdXJyZW50bHkgU0NTSSBsb3ct
bGV2ZWwgZHJpdmVycyBhcmUgcmVxdWlyZWQgdG8gbWFuYWdlIHRhZ3MgZm9yIGNvbW1hbmRzCj4g
d2hpY2ggZG8gbm90IGNvbWUgdmlhIHRoZSBibG9jayBsYXllciAtIGxpYmF0YSBpbnRlcm5hbCBj
b21tYW5kcyB3b3VsZCBiZQo+IGFuIGV4YW1wbGUgb2Ygb25lIG9mIHRoZXNlLgo+IAo+IFRoZXJl
IHdhcyBzb21lIHdvcmsgdG8gcHJvdmlkZSAicmVzZXJ2ZWQgY29tbWFuZHMiIHN1cHBvcnQgaW4g
c3VjaCBzZXJpZXMKPiBhcyBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1zY3NpLzIwMjEx
MTI1MTUxMDQ4LjEwMzkxMC0xLWhhcmVAc3VzZS5kZS8KPiAKPiBUaGlzIHdhcyBiYXNlZCBvbiBh
bGxvY2F0aW5nIGEgcmVxdWVzdCBmb3IgdGhlIGxpZmV0aW1lIG9mIHRoZSAiaW50ZXJuYWwiCj4g
Y29tbWFuZC4KPiAKPiBUaGlzIHNlcmllcyB0cmllcyB0byBzb2x2ZSB0aGF0IHByb2JsZW0gYnkg
bm90IGp1c3QgYWxsb2NhdGluZyB0aGUgcmVxdWVzdAo+IGJ1dCBhbHNvIHNlbmRpbmcgaXQgdGhy
b3VnaCB0aGUgYmxvY2sgbGF5ZXIsIHRoYXQgYmVpbmcgdGhlIG5vcm1hbCBmbG93Cj4gZm9yIGEg
cmVxdWVzdC4gV2UgbmVlZCB0byBkbyB0aGlzIGFzIHdlIG1heSBvbmx5IHBvbGwgY29tcGxldGlv
biBvZgo+IHJlcXVlc3RzIHRocm91Z2ggdGhlIGJsb2NrIGxheWVyLCBzbyB3b3VsZCBuZWVkIHRv
IGRvIHRoaXMgZm9yIHBvbGwgcXVldWUKPiBzdXBwb3J0Lgo+IAo+IFRoZXJlIGlzIHN0aWxsIHNj
b3BlIHRvIGFsbG9jYXRlIGNvbW1hbmRzIGp1c3QgdG8gZ2V0IGEgdGFnIGFzIHRva2VuIGFzCj4g
dGhhdCBtYXkgc3VpdCBzb21lIG90aGVyIHNjZW5hcmlvcywgYnV0IGl0J3Mgbm90IHdoYXQgd2Ug
ZG8gaGVyZS4KPiAKPiBUaGlzIHNlcmllcyBleHRlbmRzIGJsay1tcSB0byBzdXBwb3J0IGEgcmVx
dWVzdCBxdWV1ZSBoYXZpbmcgYSBjdXN0b20gc2V0Cj4gb2Ygb3BzLiBJbiBhZGRpdGlvbiBTQ1NJ
IGNvcmUgY29kZSBhZGRzIHN1cHBvcnQgZm9yIHRoZXNlIHR5cGUgb2YgcmVxdWVzdHMuCj4gCj4g
VGhpcyBzZXJpZXMgZG9lcyBub3QgaW5jbHVkZSBTQ1NJIGNvcmUgaGFuZGxpbmcgZm9yIGVuYWJs
aW5nIHJlc2VydmVkCj4gdGFncyBwZXIgdGFnc2V0LCBidXQgdGhhdCB3b3VsZCBiZSBlYXN5IHRv
IGFkZC4KPiAKPiBCYXNlZCBvbiBta3Atc2NzaSA1LjE4L3Njc2ktc3RhZ2luZyBAIDY2ZGFmM2U2
Yjk5Mwo+IAo+IFBsZWFzZSBjb25zaWRlciBhcyBhbiBSRkMgZm9yIG5vdy4gSSB0aGluayB0aGF0
IHRoZSBsaWJhdGEgY2hhbmdlIGhhcyB0aGUKPiBsYXJnZXN0IHNjb3BlIGZvciBpbXByb3ZlbWVu
dC4uLgo+IAoKR3JhbmQgc2VlaW5nIHRoYXQgc29tZW9uZSBpcyB0YWtpbmcgaXQgdXAuIFRoYW5r
cyBmb3IgZG9pbmcgdGhpcyEKCkJ1dDoKQWxsb2NhdGluZyBhIHF1ZXVlIGZvciBldmVyeSByZXF1
ZXN0IChlZyBpbiBwYXRjaCAzKSBpcyBvdmVya2lsbC4gSWYgd2UgCndhbnQgdG8gZ28gdGhhdCBy
b3V0ZSB3ZSBzaG91bGQgYmUgYWxsb2NhdGluZyB0aGUgcXVldWUgdXBmcm9udCAoZWcgd2hlbiAK
Y3JlYXRpbmcgdGhlIGRldmljZSBpdHNlbGYpLCBhbmQgdGhlbiBqdXN0IHJlZmVyZW5jaW5nIGl0
LgoKSG93ZXZlciwgY2FuJ3Qgc2F5IEkgbGlrZSB0aGlzIGFwcHJvYWNoLiBJJ3ZlIGJlZW4gcGxh
eWluZyBhcm91bmQgd2l0aCAKc3VwcG9ydGluZyBpbnRlcm5hbCBjb21tYW5kcywgYW5kIHJlYWxs
eSBmb3VuZCB0d28gY29uc3RyYWludHMgcmVhbGx5IAphbm5veWluZzoKCi0gVGhlIHRhZ3NldCBz
dXBwb3J0cyBvbmx5IF9vbmVfIHNldCBvZiBwYXlsb2FkIHZpYQogICBibGtfbXFfcnFfKHRvLGZy
b20pX3BkdSgpLgpUaGlzIHJlcXVpcmVzIGVhY2ggcmVxdWVzdCB0byBiZSBvZiB0aGUgc2FtZSB0
eXBlLCBhbmQgd2l0aCB0aGF0IG1ha2luZwppdCByZWFsbHkgaGFyZCBmb3IgcmUtcHVycG9zaW5n
IHRoZSByZXF1ZXN0IGZvciBpbnRlcm5hbCB1c2FnZS4gSW4gdGhlCmVuZCBJIHNldHRsZWQgYnkg
anVzdCBrZWVwaW5nIGl0IGFuZCBza2lwcGluZyB0aGUgU0NTSSBjb21tYW5kIGZpZWxkLgpJZiB3
ZSBjb3VsZCBoYXZlIGEgZGlzdGluY3QgUERVIHR5cGUgZm9yIGludGVybmFsIGNvbW1hbmRzIEkg
Z3Vlc3MgCnRoaW5ncyB3b3VsZCBiZSBlYXNpZXIuCgotIFRoZSBudW1iZXIgb2YgcmVzZXJ2ZWQg
Y29tbWFuZHMgaXMgc3RhdGljLgpXaXRoIHRoYXQgaXQncyBnZXR0aW5nIHJlYWxseSBoYXJkIHVz
aW5nIHJlc2VydmVkIGNvbW1hbmRzIHdpdGggCmxvdy1xdWV1ZSBkZXB0aCBkZXZpY2VzIGxpa2Ug
QVRBOyB3ZSBvbmx5IGhhdmUgMzEgY29tbWFuZHMgdG8gd29yayB3aXRoLCAKYW5kIHNldHRpbmcg
b25lIG9yIHR3byBhc2lkZSBmb3IgVE1GIGlzIHJlYWxseSBtYWtpbmcgYSBkaWZmZXJlbmNlIApw
ZXJmb3JtYW5jZSB3aXNlLiBJdCB3b3VsZCBiZSBfYXdlc29tZV8gaWYgd2UgY291bGQgYWxsb2Nh
dGUgcmVzZXJ2ZWQgCmNvbW1hbmRzIGR5bmFtaWNhbGx5IChpZSBqdXN0IG1hcmtpbmcgYSBjb21t
YW5kIGFzICdyZXNlcnZlZCcgb25jZSAKYWxsb2NhdGVkKS4KU3VyZSwgaXQgd29uJ3QgaGF2ZSB0
aGUgc2FtZSBndWFyYW50ZWVzIGFzICdyZWFsJyByZXNlcnZlZCBjb21tYW5kcywgYnV0IAppbiBt
b3N0IGNhc2VzIHdlIGRvbid0IGFjdHVhbGx5IG5lZWQgdGhhdC4KCk1heWJlIHRoZXNlIGFyZSBz
b21lIGxpbmVzIHdlIGNvdWxkIGludmVzdGlnYXRlPwpIbW0/CgpDaGVlcnMsCgpIYW5uZXMKLS0g
CkRyLiBIYW5uZXMgUmVpbmVja2UJCSAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0
CmhhcmVAc3VzZS5kZQkJCSAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0Ug
U29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8
cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR0Y6IEZlbGl4IEltZW5kw7ZyZmZlcgoK
LS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0
bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

