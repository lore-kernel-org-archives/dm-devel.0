Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC99EB64D9
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 06:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688971635;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IR0EW7V9rF6LPp4pGB0tlhvtX8JnDV26fDmxi8nz5Ac=;
	b=YnH9edqt6++Vj/PS2+9paolD/FIgPVYDLV7tDUv4AvF8lGnWE940AX/J24t2FiwoWAFmnA
	GsekDTehHGBc7Iz6QGzziaJBK7QRYhg1isWS+QPnB6ppx7BPXKeavKZuIutcGanK8uomb2
	wH3yWz/Snid4rUOksRU2RjIMK7ZlmB8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-Z_ZBWQlwODuH1ukrbmbfyQ-1; Mon, 10 Jul 2023 02:47:14 -0400
X-MC-Unique: Z_ZBWQlwODuH1ukrbmbfyQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA745887114;
	Mon, 10 Jul 2023 06:47:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D6D2CC09A09;
	Mon, 10 Jul 2023 06:47:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CDC5519465A3;
	Mon, 10 Jul 2023 06:47:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 856EE1946587
 for <dm-devel@listman.corp.redhat.com>; Sun, 25 Jun 2023 11:29:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5B0E9200B680; Sun, 25 Jun 2023 11:29:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 53700200B677
 for <dm-devel@redhat.com>; Sun, 25 Jun 2023 11:29:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38BA910113D4
 for <dm-devel@redhat.com>; Sun, 25 Jun 2023 11:29:04 +0000 (UTC)
Received: from mout.web.de (mout.web.de [212.227.15.4]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-552-rc3ChlOcOPa56tUGgLTr7w-1; Sun,
 25 Jun 2023 07:29:01 -0400
X-MC-Unique: rc3ChlOcOPa56tUGgLTr7w-1
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.83]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N7QUL-1pzYlk2D7d-017iKQ; Sun, 25
 Jun 2023 13:23:41 +0200
Message-ID: <3241078c-2318-fe1b-33cc-7c33db71b1a6@web.de>
Date: Sun, 25 Jun 2023 13:23:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Demi Marie Obenour <demi@invisiblethingslab.com>, dm-devel@redhat.com,
 kernel-janitors@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
References: <20230624230950.2272-3-demi@invisiblethingslab.com>
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20230624230950.2272-3-demi@invisiblethingslab.com>
X-Provags-ID: V03:K1:7wHokFvCC0uPe5YoT4komQPeZRl8dcMdb5Vp4qtURetXTPvAB6w
 iRJFDsVqvwfnWFz0DCFGAm6yESq3Xk+iP89GaAekmCCuQAKl9nbiNl6/Jn4fMD+FYoX1Wo/
 7yOG5dU/lLdr5jhUH+ZsEE/Jwnr1UafmcWAWLAxwlk080ZMXUK6UPVRGa7ZnPgrLwkHujqJ
 IJ/uyQJn3YplrBVBPr4uA==
UI-OutboundReport: notjunk:1;M01:P0:5NV/79Olx5I=;fcAMKpVe6j7ft8LXBzsk8IL4P8e
 qRPQXOmmx/HRp3LBDjdpvNRXXn1NyzsqSJIVun9pb3XwaOJumFu33e+9/JNh6AOnjGTiixJHr
 vZUTT/Mo+IgMw5zTjugfiz7J3qX+v8FpaX+y7NNJOvqp39+eLJPqm4XWbD1iQzG1MuLGVz9Qr
 PsV6+1KG6cvjXH+x1rMMQiayk+AYWFqqdlANwjEOjWIj6hKDXKaH7g87Mc+joH8/TYVoYNqnO
 B8WiwmMJhQwuyKRCi3iN8R0irnktV8PHvul3zZVGVtlUVcckzUXTLBla4qIy/mImnS74zyoVR
 wL986iPZ/AZ0IDTCsIR9UtPKD05yqKPQ3aOoX9A20PHtVqNiClDdUaNR1CQ68R6ymkLvHJLWg
 JC+Pf//MDQkx9GzxJyPlMCttRz2rTBISz57v3SxYWCU0C1fkK+rhJl5bvfn1m7NlfL7O2TY7W
 5UXzjPG40pPR8/BKKE0u6vPcJV9Y1jzbwJAVGsw7dOWdXs3V+FYpFquRQbGpuyaGEwcJvqt4X
 vo9o0LCAPmc0LFhZk9ssAipeIvoRSC2+tvOSJaujn9BQFPRpVqD6IEEU58M1f1tt4VwsSVzFc
 Fj5Ehu0SlkHMpGHUo2uVvSks6oClrfsDMOjMO+ntkfGY7y2yNoXkeisgWD7AA9BKbJZ8Srt9N
 FTvdp1jqN62Aj6McnDyIc1+GMW+8n1qok+2R8FvCQS35g170gJITTWQ62hRl8IB7GSdq7WJ8c
 jpw4AAery+sFBDe4QzSx+tYOBJR3S9+5n1B8UCgxcMZie0h/itVe8loGhQOvQwEWKER+vAsEE
 tEqqfG6rPUi3xb2FsHfe/EeTb10ZffspBscxekAr6hh+ajNI7RQD8cTvZ03jVoBLo34PYUV71
 hmSdYiBxDC0tbi0IxpyymfF1H6mYymPK7hIuii71WOyLKI/3rj/HtFOgQpVpKzQuLHPNsA9kC
 wTz7Ag==
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 10 Jul 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH v2 2/4] dm ioctl: Allow userspace to provide
 expected diskseq
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
Cc: LKML <linux-kernel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: web.de
Content-Language: en-GB
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiBUaGlzIGNhbiBiZSB1c2VkIHRvIGF2b2lkIHJhY2UgY29uZGl0aW9ucyBpbiB3aGljaCBhIGRl
dmljZSBpcyBkZXN0cm95ZWQKPiBhbmQgcmVjcmVhdGVkIHdpdGggdGhlIHNhbWUgbWFqb3IvbWlu
b3IsIG5hbWUsIG9yIFVVSUQuIOKApgoKUGxlYXNlIGFkZCBhbiBpbXBlcmF0aXZlIGNoYW5nZSBz
dWdnZXN0aW9uLgoKU2VlIGFsc286Cmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC90cmVlL0RvY3VtZW50YXRpb24vcHJvY2Vz
cy9zdWJtaXR0aW5nLXBhdGNoZXMucnN0P2g9djYuNC1yYzcjbjk0CgpSZWdhcmRzLApNYXJrdXMK
Ci0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlz
dG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

