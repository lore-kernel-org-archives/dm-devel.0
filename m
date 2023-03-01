Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFE6C6FA8E
	for <dm-devel@archiver.kernel.org>; Thu,  2 Mar 2023 07:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677743009;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PHBDPgCcO/O7YKoJcfKNrnyrdg13UoHVfoEXmu/HF2g=;
	b=PLcR4WPAnwoDVqxX4Y1gSiCG3Tnavb9RMn4dHPtOQq5zHTo0p12y9EXeYYBkiicVcxLPhO
	UuUnZZONxT0R8pxLg1CEAh6BJM/Ol78slI29UjXRLgJwcx18rUSlbvc4/uCvGudG0zXOhQ
	z6oUuloUT/EkThLAyDxJ5tMAQYoDLCQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-o-t3cgOiO4KS-wpNizPRpw-1; Thu, 02 Mar 2023 02:43:25 -0500
X-MC-Unique: o-t3cgOiO4KS-wpNizPRpw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D04B6811E9C;
	Thu,  2 Mar 2023 07:43:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4312C40C83B6;
	Thu,  2 Mar 2023 07:43:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0626919452CD;
	Thu,  2 Mar 2023 07:43:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 82FAC19465BC
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Mar 2023 11:40:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6867840C6EC4; Wed,  1 Mar 2023 11:40:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 60B514014D10
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 11:40:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41AF13C0E451
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 11:40:43 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-e5l5HF7XOC-5d8oFgeWo_g-1; Wed,
 01 Mar 2023 06:40:11 -0500
X-MC-Unique: e5l5HF7XOC-5d8oFgeWo_g-1
Received: from weisslap.aisec.fraunhofer.de ([31.19.218.61]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MLA6m-1pFFuO0kpm-00IEk1; Wed, 01 Mar 2023 12:34:22 +0100
From: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To: Paul Moore <paul@paul-moore.com>
Date: Wed,  1 Mar 2023 12:34:15 +0100
Message-Id: <20230301113415.47664-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
X-Provags-ID: V03:K1:tGtzLe56BXPRA/UJkQiHxLFGUNAsPjaOFYy/tcw9+uPqPJpJz3Z
 zj5Ye3Z3imqH6MRW+/HoKV3+n0oBXdPXSOf0LxvF2DeTb2JppDQpq7sQyQ37j1FL5FEwSRD
 cv3elYOu1ZkvMmjJsZvSAqFRI9ce18cvY2ehQZsiCCxNdrHNO5WPznAhvTmRUB4YFtQP8kr
 1ubAow1SvYeIt6QIB/L/w==
UI-OutboundReport: notjunk:1;M01:P0:yKp8ysBrTsg=;/UKr2hRr2fQIjkUNzUpURtPtG3h
 M8YZ8Fq0QuPqSxNS7bK72oG0Gtxrs4lels0ygybMwx1dzs40YqxjLELi3K+ncOfrItDJHFz2F
 0nxjNaJG6/sx1ZbDwLVJZ2Y/soUTW6Tpvp8i65psBmyhcYNWqr4hQhUgneSYeg2fJZnFMDQHN
 3rEUV18OMk/SkFAUz7p56tau3EDFZTjjTHs/jbdKFaJPqoT3T26at3QmZ4zDJMkfXEKAKeWvc
 zHEG/U0Sv5/zrOGoaLQCKl+KGdaMrqsxfOl951saeV9zbhIWr4palCTNeAORJ7EGK4ozA+Ewj
 HNjE28GNo4/p9uWCF8iSQJX08OxqOSsE1wsRbITOPXjHnHUgBC/ItiwAc7TrpHeHL/V9mTAmj
 NsKt8xFTrMPNoC0eswIZqUNupVHi9dokQyC0Lgs2ERpyRXjpFp9EQkZmmeUapIt7CEGuC7ory
 3PSXKa/AnLF7uyi11uDVFmjCtRFVggYoMczSlcAxhx+GgWtqotXEXzjcqfMdtu6Z61+iJqqTI
 pnqER3WqWH4SaYo5xv/8AuedhifhsrrU7ZCb+MCXgYtiyuL6wOTtt1ZgZu1b7JZcLAR2c0pDL
 rAv13NANM0831Xg77VzM/yTy74Sibhr4DjLi4oTglAjRq/Wy6MOkkY999+BEc5tCeSEeF3TWz
 oN1odDRD8oa7zbFojvXjlqnIVamOSoszwS3FytrTDA==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Thu, 02 Mar 2023 07:43:19 +0000
Subject: [dm-devel] [PATCH] dm verity: log audit events for dm-verity target
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
Cc: =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
 gyroidos@aisec.fraunhofer.de, Richard Guy Briggs <rgb@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 Eric Paris <eparis@redhat.com>,
 "open list:AUDIT SUBSYSTEM" <audit@vger.kernel.org>,
 "maintainer:DEVICE-MAPPER  LVM" <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

ZG0tdmVyaXR5IHNpZ25hbHMgaW50ZWdyaXR5IHZpb2xhdGlvbnMgYnkgcmV0dXJuaW5nIEkvTyBl
cnJvcnMKdG8gdXNlciBzcGFjZS4gVG8gaWRlbnRpZnkgaW50ZWdyaXR5IHZpb2xhdGlvbnMgYnkg
YSBjb250cm9sbGluZwppbnN0YW5jZSwgdGhlIGtlcm5lbCBhdWRpdCBzdWJzeXN0ZW0gY2FuIGJl
IHVzZWQgdG8gZW1pdCBhdWRpdApldmVudHMgdG8gdXNlciBzcGFjZS4gQW5hbG9nb3VzIHRvIGRt
LWludGVncml0eSwgd2UgYWxzbyB1c2UgdGhlCmRtLWF1ZGl0IHN1Ym1vZHVsZSBhbGxvd2luZyB0
byBlbWl0IGF1ZGl0IGV2ZW50cyBvbiB2ZXJpZmljYXRpb24KZmFpbHVyZXMgb2YgbWV0YWRhdGEg
YW5kIGRhdGEgYmxvY2tzIGFzIHdlbGwgYXMgaWYgbWF4IGNvcnJ1cHRlZAplcnJvcnMgYXJlIHJl
YWNoZWQuCgpUaGUgY29uc3RydWN0aW9uIGFuZCBkZXN0cnVjdGlvbiBvZiB2ZXJpdHkgZGV2aWNl
IG1hcHBpbmdzIGFyZQphbHNvIHJlbGV2YW50IGZvciBhdWRpdGluZyBhIHN5c3RlbS4gVGh1cywg
dGhvc2UgZXZlbnRzIGFyZSBhbHNvCmxvZ2dlZCBhcyBhdWRpdCBldmVudHMuCgpXZSB0ZXN0ZWQg
dGhpcyBieSBzdGFydGluZyBhIGNvbnRhaW5lciB3aXRoIHRoZSBjb250YWluZXIgbWFuYWdlcgoo
Y21sZCkgb2YgR3lyb2lkT1Mgd2hpY2ggdXNlcyBhIGRtLXZlcml0eSBwcm90ZWN0ZWQgcm9vdGZz
IGltYWdlCnJvb3QuaW1nIG1hcHBlZCB0byAvZGV2L21hcHBlci88dXVpZD4tcm9vdC4gV2UgdGhh
biBtYW5pcHVsYXRlZApvbmUgYmxvY2sgaW4gdGhlIHVuZGVybHlpbmcgaW1hZ2UgZmlsZSBhbmQg
cmVhZGluZyBpdCBmcm9tIHRoZQpwcm90ZWN0ZWQgbWFwcGVyIGRldmljZSBhZ2FpbiBhbmQgYWdh
aW4gdW50aWwgd2UgcmVhY2ggdGhlIG1heApjb3JydXB0ZWQgZXJyb3JzIGxpa2UgdGhpczoKCiAg
ZGQgaWY9L2Rldi91cmFuZG9tIG9mPXJvb3QuaW1nIGJzPTUxMiBjb3VudD0xIHNlZWs9MTAwMAog
IGZvciBpIGluIHJhbmdlIHsxLi4xMDF9OyBkbyBcCiAgICBkZCBpZj0vZGV2L21hcHBlci88dXVp
ZD4tcm9vdCBvZj0vZGV2L251bGwgYnM9NDA5NiBcCiAgICAgICBjb3VudD0xIHNraXA9MTAwMCBc
CiAgZG9uZQoKVGhlIHJlc3VsdGluZyBhdWRpdCBsb2cgbG9va3MgYXMgZm9sbG93czoKCiAgdHlw
ZT1ETV9DVFJMIG1zZz1hdWRpdCgxNjc3NjE4NzkxLjg3Njo5NjIpOgogICAgbW9kdWxlPXZlcml0
eSBvcD1jdHIgcHBpZD00ODc2IHBpZD0yOTEwMiBhdWlkPTAgdWlkPTAgZ2lkPTAKICAgIGV1aWQ9
MCBzdWlkPTAgZnN1aWQ9MCBlZ2lkPTAgc2dpZD0wIGZzZ2lkPTAgdHR5PShub25lKSBzZXM9NDQK
ICAgIGNvbW09ImNtbGQiIGV4ZT0iL3Vzci9zYmluL2NtbC9jbWxkIiBzdWJqPXVuY29uZmluZWQK
ICAgIGRldj0yNTQ6MyBlcnJvcl9tc2c9J3N1Y2Nlc3MnIHJlcz0xCgogIHR5cGU9RE1fRVZFTlQg
bXNnPWF1ZGl0KDE2Nzc2MTk0NjMuNzg2OjEwNzQpOiBtb2R1bGU9dmVyaXR5CiAgICBvcD12ZXJp
ZnktZGF0YSBkZXY9NzowIHNlY3Rvcj0xMDAwIHJlcz0wCiAgLi4uCiAgdHlwZT1ETV9FVkVOVCBt
c2c9YXVkaXQoMTY3NzYxOTU5Ni43Mjc6MTE2Mik6IG1vZHVsZT12ZXJpdHkKICAgIG9wPXZlcmlm
eS1kYXRhIGRldj03OjAgc2VjdG9yPTEwMDAgcmVzPTAKCiAgdHlwZT1ETV9FVkVOVCBtc2c9YXVk
aXQoMTY3NzYxOTU5Ni43MzE6MTE2Myk6IG1vZHVsZT12ZXJpdHkKICAgIG9wPW1heC1jb3JydXB0
ZWQtZXJyb3JzIGRldj0yNTQ6MyBzZWN0b3I9PyByZXM9MAoKU2lnbmVkLW9mZi1ieTogTWljaGFl
bCBXZWnDnyA8bWljaGFlbC53ZWlzc0BhaXNlYy5mcmF1bmhvZmVyLmRlPgotLS0KIGRyaXZlcnMv
bWQvZG0tdmVyaXR5LXRhcmdldC5jIHwgMjAgKysrKysrKysrKysrKysrKysrLS0KIDEgZmlsZSBj
aGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbWQvZG0tdmVyaXR5LXRhcmdldC5jIGIvZHJpdmVycy9tZC9kbS12ZXJpdHktdGFyZ2V0
LmMKaW5kZXggYWRlODNlZjNiNDM5Li44YmVlYjRlYTY2ZDEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bWQvZG0tdmVyaXR5LXRhcmdldC5jCisrKyBiL2RyaXZlcnMvbWQvZG0tdmVyaXR5LXRhcmdldC5j
CkBAIC0xNiw2ICsxNiw3IEBACiAjaW5jbHVkZSAiZG0tdmVyaXR5LmgiCiAjaW5jbHVkZSAiZG0t
dmVyaXR5LWZlYy5oIgogI2luY2x1ZGUgImRtLXZlcml0eS12ZXJpZnktc2lnLmgiCisjaW5jbHVk
ZSAiZG0tYXVkaXQuaCIKICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KICNpbmNsdWRlIDxsaW51
eC9yZWJvb3QuaD4KICNpbmNsdWRlIDxsaW51eC9zY2F0dGVybGlzdC5oPgpAQCAtMjQ4LDggKzI0
OSwxMCBAQCBzdGF0aWMgaW50IHZlcml0eV9oYW5kbGVfZXJyKHN0cnVjdCBkbV92ZXJpdHkgKnYs
IGVudW0gdmVyaXR5X2Jsb2NrX3R5cGUgdHlwZSwKIAlETUVSUl9MSU1JVCgiJXM6ICVzIGJsb2Nr
ICVsbHUgaXMgY29ycnVwdGVkIiwgdi0+ZGF0YV9kZXYtPm5hbWUsCiAJCSAgICB0eXBlX3N0ciwg
YmxvY2spOwogCi0JaWYgKHYtPmNvcnJ1cHRlZF9lcnJzID09IERNX1ZFUklUWV9NQVhfQ09SUlVQ
VEVEX0VSUlMpCisJaWYgKHYtPmNvcnJ1cHRlZF9lcnJzID09IERNX1ZFUklUWV9NQVhfQ09SUlVQ
VEVEX0VSUlMpIHsKIAkJRE1FUlIoIiVzOiByZWFjaGVkIG1heGltdW0gZXJyb3JzIiwgdi0+ZGF0
YV9kZXYtPm5hbWUpOworCQlkbV9hdWRpdF9sb2dfdGFyZ2V0KERNX01TR19QUkVGSVgsICJtYXgt
Y29ycnVwdGVkLWVycm9ycyIsIHYtPnRpLCAwKTsKKwl9CiAKIAlzbnByaW50Zih2ZXJpdHlfZW52
LCBETV9WRVJJVFlfRU5WX0xFTkdUSCwgIiVzPSVkLCVsbHUiLAogCQlETV9WRVJJVFlfRU5WX1ZB
Ul9OQU1FLCB0eXBlLCBibG9jayk7CkBAIC0zNDAsNiArMzQzLDExIEBAIHN0YXRpYyBpbnQgdmVy
aXR5X3ZlcmlmeV9sZXZlbChzdHJ1Y3QgZG1fdmVyaXR5ICp2LCBzdHJ1Y3QgZG1fdmVyaXR5X2lv
ICppbywKIAkJZWxzZSBpZiAodmVyaXR5X2hhbmRsZV9lcnIodiwKIAkJCQkJICAgRE1fVkVSSVRZ
X0JMT0NLX1RZUEVfTUVUQURBVEEsCiAJCQkJCSAgIGhhc2hfYmxvY2spKSB7CisJCQlzdHJ1Y3Qg
YmlvICpiaW8gPQorCQkJCWRtX2Jpb19mcm9tX3Blcl9iaW9fZGF0YShpbywKKwkJCQkJCQkgdi0+
dGktPnBlcl9pb19kYXRhX3NpemUpOworCQkJZG1fYXVkaXRfbG9nX2JpbyhETV9NU0dfUFJFRklY
LCAidmVyaWZ5LW1ldGFkYXRhIiwgYmlvLAorCQkJCQkgYmxvY2ssIDApOwogCQkJciA9IC1FSU87
CiAJCQlnb3RvIHJlbGVhc2VfcmV0X3I7CiAJCX0KQEAgLTU5MCw4ICs1OTgsMTEgQEAgc3RhdGlj
IGludCB2ZXJpdHlfdmVyaWZ5X2lvKHN0cnVjdCBkbV92ZXJpdHlfaW8gKmlvKQogCQkJCXJldHVy
biAtRUlPOwogCQkJfQogCQkJaWYgKHZlcml0eV9oYW5kbGVfZXJyKHYsIERNX1ZFUklUWV9CTE9D
S19UWVBFX0RBVEEsCi0JCQkJCSAgICAgIGN1cl9ibG9jaykpCisJCQkJCSAgICAgIGN1cl9ibG9j
aykpIHsKKwkJCQlkbV9hdWRpdF9sb2dfYmlvKERNX01TR19QUkVGSVgsICJ2ZXJpZnktZGF0YSIs
CisJCQkJCQkgYmlvLCBjdXJfYmxvY2ssIDApOwogCQkJCXJldHVybiAtRUlPOworCQkJfQogCQl9
CiAJfQogCkBAIC05NzUsNiArOTg2LDggQEAgc3RhdGljIHZvaWQgdmVyaXR5X2R0cihzdHJ1Y3Qg
ZG1fdGFyZ2V0ICp0aSkKIAkJc3RhdGljX2JyYW5jaF9kZWMoJnVzZV90YXNrbGV0X2VuYWJsZWQp
OwogCiAJa2ZyZWUodik7CisKKwlkbV9hdWRpdF9sb2dfZHRyKERNX01TR19QUkVGSVgsIHRpLCAx
KTsKIH0KIAogc3RhdGljIGludCB2ZXJpdHlfYWxsb2NfbW9zdF9vbmNlKHN0cnVjdCBkbV92ZXJp
dHkgKnYpCkBAIC0xNDI5LDExICsxNDQyLDE0IEBAIHN0YXRpYyBpbnQgdmVyaXR5X2N0cihzdHJ1
Y3QgZG1fdGFyZ2V0ICp0aSwgdW5zaWduZWQgaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCiAJdmVy
aXR5X3ZlcmlmeV9zaWdfb3B0c19jbGVhbnVwKCZ2ZXJpZnlfYXJncyk7CiAKKwlkbV9hdWRpdF9s
b2dfY3RyKERNX01TR19QUkVGSVgsIHRpLCAxKTsKKwogCXJldHVybiAwOwogCiBiYWQ6CiAKIAl2
ZXJpdHlfdmVyaWZ5X3NpZ19vcHRzX2NsZWFudXAoJnZlcmlmeV9hcmdzKTsKKwlkbV9hdWRpdF9s
b2dfY3RyKERNX01TR19QUkVGSVgsIHRpLCAwKTsKIAl2ZXJpdHlfZHRyKHRpKTsKIAogCXJldHVy
biByOwotLSAKMi4zMC4yCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0
LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVs
Cg==

