Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744E2C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 16:55:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C752364F30
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 16:55:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C752364F30
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-9CQWSHWeOESwRiWVEdYA7Q-1; Tue, 02 Mar 2021 11:55:40 -0500
X-MC-Unique: 9CQWSHWeOESwRiWVEdYA7Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F02F18B9ECD;
	Tue,  2 Mar 2021 16:55:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B582D6086F;
	Tue,  2 Mar 2021 16:55:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E252F18095CB;
	Tue,  2 Mar 2021 16:55:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 122GtUWT029032 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 11:55:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3C82C10AF9E7; Tue,  2 Mar 2021 16:55:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 33CC210B7C86
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 16:55:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEC78800050
	for <dm-devel@redhat.com>; Tue,  2 Mar 2021 16:55:27 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-418-N_zSUm99OGSsXwR3O9MDhg-1;
	Tue, 02 Mar 2021 11:55:21 -0500
X-MC-Unique: N_zSUm99OGSsXwR3O9MDhg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 37195AE79;
	Tue,  2 Mar 2021 16:55:20 +0000 (UTC)
Message-ID: <50905e363e77c3c4c0d25eb5a742839a1caa1082.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 02 Mar 2021 17:55:19 +0100
In-Reply-To: <41e79d67f568baf8de6b28e4924620240f0a2731.camel@suse.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
	<655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
	<79f18cdb19b41be24d082d5528ab2325e6552395.camel@suse.com>
	<05c23ce9-4859-b0c3-3acb-c74f2c4510d6@huawei.com>
	<41e79d67f568baf8de6b28e4924620240f0a2731.camel@suse.com>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="=-L/9alU89DU+d3l2EPAeB"

--=-L/9alU89DU+d3l2EPAeB
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit

Hi lixiaokeng,

On Tue, 2021-03-02 at 16:29 +0100, Martin Wilck wrote:
> On Tue, 2021-03-02 at 20:44 +0800, lixiaokeng wrote:
> > 
> > 
> 
> The stacks you have shown indicate that the instruction pointers were
> broken. That would suggest something similar as dicussed in the ML
> thread leading to 38ffd89 ("libmultipath: prevent DSO unloading with
> astray checker threads"). Your logs show "tur checker refcount 1", so
> the next call to checker_put would have unloaded the DSO. 
> 
> Please try commenting out the dlclose() call in free_checker_class(),
> and see if it makes a difference.

I have two TENTATIVE patches here that I'd like you to ask to try (with
the dlclose in place again). Also, please make sure you've got 38ffd89.

This is really tentative, I'm still pretty much in the dark. But my
theory is that the crash can happen if the thread is about to start. So
the most important part is the hunk that checks the return value of
checker_class_ref() in start_checker_thread().

Martin



--=-L/9alU89DU+d3l2EPAeB
Content-Disposition: attachment;
	filename="0001-libmultipath-protect-DSO-unloading-with-RCU.patch"
Content-Type: text/x-patch;
	name="0001-libmultipath-protect-DSO-unloading-with-RCU.patch";
	charset="ISO-8859-15"
Content-Transfer-Encoding: base64

RnJvbSBhNGRkNjQ4MDhkNDlmNWEwZDJhOTQzMzZlNTY0MDEyNjJlZjk5ZTU1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KRGF0ZTog
VHVlLCAyIE1hciAyMDIxIDE3OjAzOjE1ICswMTAwClN1YmplY3Q6IFtQQVRDSCAxLzJdIGxpYm11
bHRpcGF0aDogcHJvdGVjdCBEU08gdW5sb2FkaW5nIHdpdGggUkNVCgpTb21lIGNyYXNoZXMgcG9z
c2libHkgcmVsYXRlZCB0byBEU08gdW5sb2FkaW5nIGFyZSBzdGlsbCBvYnNlcnZlZC4KVHJ5IHBy
b3RlY3RpbmcgdGhlIHVubG9hZGluZyB3aXRoIFJDVS4KClNpZ25lZC1vZmYtYnk6IE1hcnRpbiBX
aWxjayA8bXdpbGNrQHN1c2UuY29tPgotLS0KIGxpYm11bHRpcGF0aC9jaGVja2Vycy5jIHwgNzkg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0KIGxpYm11bHRpcGF0aC9w
cm9wc2VsLmMgIHwgIDQgKysrCiAyIGZpbGVzIGNoYW5nZWQsIDYzIGluc2VydGlvbnMoKyksIDIw
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jaGVja2Vycy5jIGIvbGli
bXVsdGlwYXRoL2NoZWNrZXJzLmMKaW5kZXggMmRkOTkxNS4uMjVmMDdjZSAxMDA2NDQKLS0tIGEv
bGlibXVsdGlwYXRoL2NoZWNrZXJzLmMKKysrIGIvbGlibXVsdGlwYXRoL2NoZWNrZXJzLmMKQEAg
LTMsNiArMyw3IEBACiAjaW5jbHVkZSA8c3RkZGVmLmg+CiAjaW5jbHVkZSA8ZGxmY24uaD4KICNp
bmNsdWRlIDxzeXMvc3RhdC5oPgorI2luY2x1ZGUgPGVycm5vLmg+CiAjaW5jbHVkZSA8dXJjdS5o
PgogI2luY2x1ZGUgPHVyY3UvdWF0b21pYy5oPgogCkBAIC0yNSw2ICsyNiw3IEBAIHN0cnVjdCBj
aGVja2VyX2NsYXNzIHsKIAl2b2lkICooKnRocmVhZCkodm9pZCAqKTsJICAgICAvKiBhc3luYyB0
aHJlYWQgZW50cnkgcG9pbnQgKi8KIAljb25zdCBjaGFyICoqbXNndGFibGU7CiAJc2hvcnQgbXNn
dGFibGVfc2l6ZTsKKwlzdHJ1Y3QgcmN1X2hlYWQgcmN1OwogfTsKIAogc3RhdGljIGNvbnN0IGNo
YXIgKmNoZWNrZXJfc3RhdGVfbmFtZXNbUEFUSF9NQVhfU1RBVEVdID0gewpAQCAtNzQsMjAgKzc2
LDE2IEBAIHN0YXRpYyBpbnQgY2hlY2tlcl9jbGFzc191bnJlZihzdHJ1Y3QgY2hlY2tlcl9jbGFz
cyAqY2xzKQogCXJldHVybiB1YXRvbWljX3N1Yl9yZXR1cm4oJmNscy0+cmVmY291bnQsIDEpOwog
fQogCi12b2lkIGZyZWVfY2hlY2tlcl9jbGFzcyhzdHJ1Y3QgY2hlY2tlcl9jbGFzcyAqYykKK3N0
YXRpYyB2b2lkIGZyZWVfY2hlY2tlcl9jbGFzc19yY3Uoc3RydWN0IHJjdV9oZWFkICpoZWFkKQog
ewotCWludCBjbnQ7CisJc3RydWN0IGNoZWNrZXJfY2xhc3MgKmMgPSBjb250YWluZXJfb2YoaGVh
ZCwgc3RydWN0IGNoZWNrZXJfY2xhc3MsIHJjdSk7CiAKLQlpZiAoIWMpCi0JCXJldHVybjsKLQlj
bnQgPSBjaGVja2VyX2NsYXNzX3VucmVmKGMpOwotCWlmIChjbnQgIT0gMCkgewotCQljb25kbG9n
KGNudCA8IDAgPyAxIDogNCwgIiVzIGNoZWNrZXIgcmVmY291bnQgJWQiLAotCQkJYy0+bmFtZSwg
Y250KTsKKwlpZiAodWF0b21pY19yZWFkKCZjLXJlZmNvdW50KSA+IDApIHsKKwkJY29uZGxvZygx
LCAiJXM6IFJBQ0U6IHJlZmNvdW50ID0gJWQsIG5vdCBmcmVlaW5nIGNoZWNrZXIiLAorCQkJX19m
dW5jX18sIHJlZmNvdW50KTsKIAkJcmV0dXJuOwogCX0KIAljb25kbG9nKDMsICJ1bmxvYWRpbmcg
JXMgY2hlY2tlciIsIGMtPm5hbWUpOwotCWxpc3RfZGVsKCZjLT5ub2RlKTsKIAlpZiAoYy0+cmVz
ZXQpCiAJCWMtPnJlc2V0KCk7CiAJaWYgKGMtPmhhbmRsZSkgewpAQCAtOTksNiArOTcsMjIgQEAg
dm9pZCBmcmVlX2NoZWNrZXJfY2xhc3Moc3RydWN0IGNoZWNrZXJfY2xhc3MgKmMpCiAJRlJFRShj
KTsKIH0KIAorc3RhdGljIHZvaWQgZnJlZV9jaGVja2VyX2NsYXNzKHN0cnVjdCBjaGVja2VyX2Ns
YXNzICpjKQoreworCWludCBjbnQ7CisKKwlpZiAoIWMpCisJCXJldHVybjsKKwljbnQgPSBjaGVj
a2VyX2NsYXNzX3VucmVmKGMpOworCWlmIChjbnQgIT0gMCkgeworCQljb25kbG9nKGNudCA8IDAg
PyAxIDogNCwgIiVzIGNoZWNrZXIgcmVmY291bnQgJWQiLAorCQkJYy0+bmFtZSwgY250KTsKKwkJ
cmV0dXJuOworCX0KKwlsaXN0X2RlbCgmYy0+bm9kZSk7CisJY2FsbF9yY3UoJmMtPnJjdSwgZnJl
ZV9jaGVja2VyX2NsYXNzX3JjdSk7Cit9CisKIHZvaWQgY2xlYW51cF9jaGVja2VycyAodm9pZCkK
IHsKIAlzdHJ1Y3QgY2hlY2tlcl9jbGFzcyAqY2hlY2tlcl9sb29wOwpAQCAtMTExLDE1ICsxMjUs
MzIgQEAgdm9pZCBjbGVhbnVwX2NoZWNrZXJzICh2b2lkKQogCiBzdGF0aWMgc3RydWN0IGNoZWNr
ZXJfY2xhc3MgKmNoZWNrZXJfY2xhc3NfbG9va3VwKGNvbnN0IGNoYXIgKm5hbWUpCiB7Ci0Jc3Ry
dWN0IGNoZWNrZXJfY2xhc3MgKmM7CisJc3RydWN0IGNoZWNrZXJfY2xhc3MgKmMsICpmb3VuZCA9
IE5VTEw7CisJaW50IHJlZmNvdW50ID0gMDsKIAogCWlmICghbmFtZSB8fCAhc3RybGVuKG5hbWUp
KQogCQlyZXR1cm4gTlVMTDsKKworCXJjdV9yZWFkX2xvY2soKTsKIAlsaXN0X2Zvcl9lYWNoX2Vu
dHJ5KGMsICZjaGVja2Vycywgbm9kZSkgewotCQlpZiAoIXN0cm5jbXAobmFtZSwgYy0+bmFtZSwg
Q0hFQ0tFUl9OQU1FX0xFTikpCi0JCQlyZXR1cm4gYzsKKwkJaWYgKCFzdHJuY21wKG5hbWUsIGMt
Pm5hbWUsIENIRUNLRVJfTkFNRV9MRU4pKSB7CisJCQlmb3VuZCA9IGM7CisJCQlicmVhazsKKwkJ
fQogCX0KLQlyZXR1cm4gTlVMTDsKKwlpZiAoZm91bmQpIHsKKwkJcmVmY291bnQgPSBjaGVja2Vy
X2NsYXNzX3JlZihmb3VuZCk7CisJCWlmIChyZWZjb3VudCA9PSAxKQorCQkJY2hlY2tlcl9jbGFz
c191bnJlZihmb3VuZCk7CisJfQorCXJjdV9yZWFkX3VubG9jaygpOworCisJaWYgKHJlZmNvdW50
IDw9IDEpIHsKKwkJY29uZGxvZygxLCAiJXM6IFJBQ0U6IGdvdCByZWZjb3VudCA9PSAlZCIsIF9f
ZnVuY19fLCByZWZjb3VudCk7CisJCWZvdW5kID0gTlVMTDsKKwl9CisKKwlyZXR1cm4gZm91bmQ7
CiB9CiAKIHZvaWQgcmVzZXRfY2hlY2tlcl9jbGFzc2VzKHZvaWQpCkBAIC0zODcsMTEgKzQxOCwy
MCBAQCBzdGF0aWMgdm9pZCAqY2hlY2tlcl90aHJlYWRfZW50cnkodm9pZCAqYXJnKQogaW50IHN0
YXJ0X2NoZWNrZXJfdGhyZWFkKHB0aHJlYWRfdCAqdGhyZWFkLCBjb25zdCBwdGhyZWFkX2F0dHJf
dCAqYXR0ciwKIAkJCSBzdHJ1Y3QgY2hlY2tlcl9jb250ZXh0ICpjdHgpCiB7Ci0JaW50IHJ2Owor
CWludCBydiwgcmVmY291bnQ7CiAKIAlhc3NlcnQoY3R4ICYmIGN0eC0+Y2xzICYmIGN0eC0+Y2xz
LT50aHJlYWQpOworCiAJLyogVGFrZSBhIHJlZiBoZXJlLCBsZXN0IHRoZSBjbGFzcyBiZSBmcmVl
ZCBiZWZvcmUgdGhlIHRocmVhZCBzdGFydHMgKi8KLQkodm9pZCljaGVja2VyX2NsYXNzX3JlZihj
dHgtPmNscyk7CisJcmN1X3JlYWRfbG9jaygpOworCXJlZmNvdW50ID0gY2hlY2tlcl9jbGFzc19y
ZWYoY3R4LT5jbHMpOworCWlmIChyZWZjb3VudCA8PSAxKQorCQljaGVja2VyX2NsYXNzX3VucmVm
KGN0eC0+Y2xzKTsKKwlyY3VfcmVhZF91bmxvY2soKTsKKwlpZiAocmVmY291bnQgPD0gMSkKKwkJ
Y29uZGxvZygxLCAiJXM6IFJBQ0U6IGdvdCByZWZjb3VudCA9PSAlZCIsIF9fZnVuY18sIHJlZmNv
dW50KTsKKwkJcmV0dXJuIEVJTzsKKwl9CiAJcnYgPSBwdGhyZWFkX2NyZWF0ZSh0aHJlYWQsIGF0
dHIsIGNoZWNrZXJfdGhyZWFkX2VudHJ5LCBjdHgpOwogCWlmIChydiAhPSAwKSB7CiAJCWNvbmRs
b2coMSwgImZhaWxlZCB0byBzdGFydCBjaGVja2VyIHRocmVhZCBmb3IgJXM6ICVtIiwKQEAgLTQx
OCwxNCArNDU4LDEzIEBAIHZvaWQgY2hlY2tlcl9nZXQoY29uc3QgY2hhciAqbXVsdGlwYXRoX2Rp
ciwgc3RydWN0IGNoZWNrZXIgKmRzdCwKIAogCWlmIChuYW1lICYmIHN0cmxlbihuYW1lKSkgewog
CQlzcmMgPSBjaGVja2VyX2NsYXNzX2xvb2t1cChuYW1lKTsKLQkJaWYgKCFzcmMpCisJCWlmICgh
c3JjKSB7CiAJCQlzcmMgPSBhZGRfY2hlY2tlcl9jbGFzcyhtdWx0aXBhdGhfZGlyLCBuYW1lKTsK
KwkJCWlmIChzcmMgJiYgY2hlY2tlcl9jbGFzc19yZWYoc3JjKSA9PSAxKQorCQkJCXNyYyA9IE5V
TEw7CisJCX0KIAl9CiAJZHN0LT5jbHMgPSBzcmM7Ci0JaWYgKCFzcmMpCi0JCXJldHVybjsKLQot
CSh2b2lkKWNoZWNrZXJfY2xhc3NfcmVmKGRzdC0+Y2xzKTsKIH0KIAogaW50IGluaXRfY2hlY2tl
cnMoY29uc3QgY2hhciAqbXVsdGlwYXRoX2RpcikKZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9w
cm9wc2VsLmMgYi9saWJtdWx0aXBhdGgvcHJvcHNlbC5jCmluZGV4IGY3NzFhODMuLjRhZGQ5NWEg
MTAwNjQ0Ci0tLSBhL2xpYm11bHRpcGF0aC9wcm9wc2VsLmMKKysrIGIvbGlibXVsdGlwYXRoL3By
b3BzZWwuYwpAQCAtNTM2LDYgKzUzNiwxMCBAQCBpbnQgc2VsZWN0X2NoZWNrZXIoc3RydWN0IGNv
bmZpZyAqY29uZiwgc3RydWN0IHBhdGggKnBwKQogCWRvX2RlZmF1bHQoY2tyX25hbWUsIERFRkFV
TFRfQ0hFQ0tFUik7CiBvdXQ6CiAJY2hlY2tlcl9nZXQoY29uZi0+bXVsdGlwYXRoX2RpciwgYywg
Y2tyX25hbWUpOworCWlmICghY2hlY2tlcl9zZWxlY3RlZChjKSkgeworCQljb25kbG9nKDEsICIl
czogZmFpbGVkIHRvIGdyYWIgY2hlY2tlciIsIF9fZnVuY19fKTsKKwkJcmV0dXJuIDE7CisJfQog
CWNvbmRsb2coMywgIiVzOiBwYXRoX2NoZWNrZXIgPSAlcyAlcyIsIHBwLT5kZXYsCiAJCWNoZWNr
ZXJfbmFtZShjKSwgb3JpZ2luKTsKIAlpZiAoY29uZi0+Y2hlY2tlcl90aW1lb3V0KSB7Ci0tIAoy
LjI5LjIKCg==
--=-L/9alU89DU+d3l2EPAeB
Content-Disposition: attachment;
	filename="0002-libmultipath-tur_thread-use-pthread_exit.patch"
Content-Type: text/x-patch;
	name="0002-libmultipath-tur_thread-use-pthread_exit.patch"; 
	charset="ISO-8859-15"
Content-Transfer-Encoding: base64

RnJvbSBjNDQzNzViYjVlMjE4YjFlNTRjYTRkOTA2OWIyYjE2MzJkZjg3Zjc1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4KRGF0ZTog
VHVlLCAyIE1hciAyMDIxIDE3OjA1OjI2ICswMTAwClN1YmplY3Q6IFtQQVRDSCAyLzJdIGxpYm11
bHRpcGF0aDogdHVyX3RocmVhZDogdXNlIHB0aHJlYWRfZXhpdCgpCgpVc2luZyAicmV0dXJuIiB3
b3VsZCBqdW1wIGludG8gYSBkaWZmZXJlbnQgRFNPIChsaWJtdWx0aXBhdGgpLAphdm9pZCB0aGF0
LgoKU2lnbmVkLW9mZi1ieTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+Ci0tLQogbGli
bXVsdGlwYXRoL2NoZWNrZXJzLmMgICAgIHwgMTEgKysrKysrLS0tLS0KIGxpYm11bHRpcGF0aC9j
aGVja2Vycy90dXIuYyB8ICAyICsrCiAyIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwg
NSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvY2hlY2tlcnMuYyBiL2xp
Ym11bHRpcGF0aC9jaGVja2Vycy5jCmluZGV4IDI1ZjA3Y2UuLjk5ZTQ4YmMgMTAwNjQ0Ci0tLSBh
L2xpYm11bHRpcGF0aC9jaGVja2Vycy5jCisrKyBiL2xpYm11bHRpcGF0aC9jaGVja2Vycy5jCkBA
IC03OSw4ICs3OSw5IEBAIHN0YXRpYyBpbnQgY2hlY2tlcl9jbGFzc191bnJlZihzdHJ1Y3QgY2hl
Y2tlcl9jbGFzcyAqY2xzKQogc3RhdGljIHZvaWQgZnJlZV9jaGVja2VyX2NsYXNzX3JjdShzdHJ1
Y3QgcmN1X2hlYWQgKmhlYWQpCiB7CiAJc3RydWN0IGNoZWNrZXJfY2xhc3MgKmMgPSBjb250YWlu
ZXJfb2YoaGVhZCwgc3RydWN0IGNoZWNrZXJfY2xhc3MsIHJjdSk7CisJaW50IHJlZmNvdW50Owog
Ci0JaWYgKHVhdG9taWNfcmVhZCgmYy1yZWZjb3VudCkgPiAwKSB7CisJaWYgKChyZWZjb3VudCA9
IHVhdG9taWNfcmVhZCgmYy0+cmVmY291bnQpKSA+IDApIHsKIAkJY29uZGxvZygxLCAiJXM6IFJB
Q0U6IHJlZmNvdW50ID0gJWQsIG5vdCBmcmVlaW5nIGNoZWNrZXIiLAogCQkJX19mdW5jX18sIHJl
ZmNvdW50KTsKIAkJcmV0dXJuOwpAQCAtMTQ1LDcgKzE0Niw3IEBAIHN0YXRpYyBzdHJ1Y3QgY2hl
Y2tlcl9jbGFzcyAqY2hlY2tlcl9jbGFzc19sb29rdXAoY29uc3QgY2hhciAqbmFtZSkKIAl9CiAJ
cmN1X3JlYWRfdW5sb2NrKCk7CiAKLQlpZiAocmVmY291bnQgPD0gMSkgeworCWlmIChyZWZjb3Vu
dCA9PSAxKSB7CiAJCWNvbmRsb2coMSwgIiVzOiBSQUNFOiBnb3QgcmVmY291bnQgPT0gJWQiLCBf
X2Z1bmNfXywgcmVmY291bnQpOwogCQlmb3VuZCA9IE5VTEw7CiAJfQpAQCAtNDI1LDExICs0MjYs
MTEgQEAgaW50IHN0YXJ0X2NoZWNrZXJfdGhyZWFkKHB0aHJlYWRfdCAqdGhyZWFkLCBjb25zdCBw
dGhyZWFkX2F0dHJfdCAqYXR0ciwKIAkvKiBUYWtlIGEgcmVmIGhlcmUsIGxlc3QgdGhlIGNsYXNz
IGJlIGZyZWVkIGJlZm9yZSB0aGUgdGhyZWFkIHN0YXJ0cyAqLwogCXJjdV9yZWFkX2xvY2soKTsK
IAlyZWZjb3VudCA9IGNoZWNrZXJfY2xhc3NfcmVmKGN0eC0+Y2xzKTsKLQlpZiAocmVmY291bnQg
PD0gMSkKKwlpZiAocmVmY291bnQgPT0gMSkKIAkJY2hlY2tlcl9jbGFzc191bnJlZihjdHgtPmNs
cyk7CiAJcmN1X3JlYWRfdW5sb2NrKCk7Ci0JaWYgKHJlZmNvdW50IDw9IDEpCi0JCWNvbmRsb2co
MSwgIiVzOiBSQUNFOiBnb3QgcmVmY291bnQgPT0gJWQiLCBfX2Z1bmNfLCByZWZjb3VudCk7CisJ
aWYgKHJlZmNvdW50IDw9IDEpIHsKKwkJY29uZGxvZygxLCAiJXM6IFJBQ0U6IGdvdCByZWZjb3Vu
dCA9PSAlZCIsIF9fZnVuY19fLCByZWZjb3VudCk7CiAJCXJldHVybiBFSU87CiAJfQogCXJ2ID0g
cHRocmVhZF9jcmVhdGUodGhyZWFkLCBhdHRyLCBjaGVja2VyX3RocmVhZF9lbnRyeSwgY3R4KTsK
ZGlmZiAtLWdpdCBhL2xpYm11bHRpcGF0aC9jaGVja2Vycy90dXIuYyBiL2xpYm11bHRpcGF0aC9j
aGVja2Vycy90dXIuYwppbmRleCBhNGI0YTIxLi4wZGI1MGJhIDEwMDY0NAotLS0gYS9saWJtdWx0
aXBhdGgvY2hlY2tlcnMvdHVyLmMKKysrIGIvbGlibXVsdGlwYXRoL2NoZWNrZXJzL3R1ci5jCkBA
IC0yODQsNiArMjg0LDggQEAgdm9pZCAqbGliY2hlY2tfdGhyZWFkKHN0cnVjdCBjaGVja2VyX2Nv
bnRleHQgKmN0eCkKIAogCXR1cl90aHJlYWRfY2xlYW51cF9wb3AoY3QpOwogCisJcHRocmVhZF9l
eGl0KE5VTEwpOworCS8qIG5vdCByZWFjaGVkICovCiAJcmV0dXJuICgodm9pZCAqKTApOwogfQog
Ci0tIAoyLjI5LjIKCg==
--=-L/9alU89DU+d3l2EPAeB
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--=-L/9alU89DU+d3l2EPAeB--

