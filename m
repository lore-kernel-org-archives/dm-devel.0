Return-Path: <SRS0=hK9d=GJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D522C433E0
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jan 2021 05:00:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8367222CAF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jan 2021 05:00:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8367222CAF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-mR56rcEjP9uu67Lv_tUs3A-1; Wed, 06 Jan 2021 00:00:30 -0500
X-MC-Unique: mR56rcEjP9uu67Lv_tUs3A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B050A107ACE4;
	Wed,  6 Jan 2021 05:00:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 506571002388;
	Wed,  6 Jan 2021 05:00:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4D05D180954D;
	Wed,  6 Jan 2021 05:00:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10650Iet004742 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Jan 2021 00:00:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A620C2166B29; Wed,  6 Jan 2021 05:00:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A09D12166B2C
	for <dm-devel@redhat.com>; Wed,  6 Jan 2021 05:00:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33D87858285
	for <dm-devel@redhat.com>; Wed,  6 Jan 2021 05:00:16 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-228-S_Vn9MkmM1GQNoTduzlwCQ-1;
	Wed, 06 Jan 2021 00:00:10 -0500
X-MC-Unique: S_Vn9MkmM1GQNoTduzlwCQ-1
Received: from [192.168.86.31] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5D80F20B7192;
	Tue,  5 Jan 2021 21:00:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5D80F20B7192
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
References: <20201212180251.9943-1-tusharsu@linux.microsoft.com>
	<20201212180251.9943-3-tusharsu@linux.microsoft.com>
	<4e83480731b937cea479f688029560444b9cb66a.camel@linux.ibm.com>
	<3fdb72ae-f291-386b-e7b9-688dfe092dc5@linux.microsoft.com>
Message-ID: <e401bb98-6b39-b148-fdba-76e48c7c3932@linux.microsoft.com>
Date: Tue, 5 Jan 2021 21:00:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3fdb72ae-f291-386b-e7b9-688dfe092dc5@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10650Iet004742
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v9 2/8] IMA: add support to measure buffer
	data hash
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"

<snip>

>>> =A0 void process_buffer_measurement(struct inode *inode, const void=20
>>> *buf, int size,
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *eventna=
me, enum ima_hooks func,
>>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int pcr, const char *fun=
c_data);
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int pcr, const char *fun=
c_data,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool measure_buf_hash);
>>
>> Please abbreviate the boolean name to "hash".=A0=A0 The test would then =
be
>> "if (hash =3D=3D true)" or "if (hash)".
>>
> Will do.

<snip>

>>> - * process_buffer_measurement - Measure the buffer to ima log.
>>> + * process_buffer_measurement - Measure the buffer or the buffer=20
>>> data hash
>>> =A0=A0 * @inode: inode associated with the object being measured (NULL=
=20
>>> for KEY_CHECK)
>>> =A0=A0 * @buf: pointer to the buffer that needs to be added to the log.
>>> =A0=A0 * @size: size of buffer(in bytes).
>>> @@ -787,12 +787,23 @@ int ima_post_load_data(char *buf, loff_t size,
>>> =A0=A0 * @func: IMA hook
>>> =A0=A0 * @pcr: pcr to extend the measurement
>>> =A0=A0 * @func_data: private data specific to @func, can be NULL.
>>> + * @measure_buf_hash: measure buffer hash
>>
>> ^@hash: measure buffer data hash
>>
> Agreed. Will fix.
<snip>
>>> =A0 void process_buffer_measurement(struct inode *inode, const void=20
>>> *buf, int size,
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *eventna=
me, enum ima_hooks func,
>>> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int pcr, const char *fun=
c_data)
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int pcr, const char *fun=
c_data,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool measure_buf_hash)
>>> =A0 {
>>> =A0=A0=A0=A0=A0 int ret =3D 0;
>>> =A0=A0=A0=A0=A0 const char *audit_cause =3D "ENOMEM";
>>> @@ -807,6 +818,8 @@ void process_buffer_measurement(struct inode=20
>>> *inode, const void *buf, int size,
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 struct ima_digest_data hdr;
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 char digest[IMA_MAX_DIGEST_SIZE];
>>> =A0=A0=A0=A0=A0 } hash =3D {};
>>> +=A0=A0=A0 char buf_hash[IMA_MAX_DIGEST_SIZE];
>>> +=A0=A0=A0 int buf_hash_len =3D hash_digest_size[ima_hash_algo];
>>> =A0=A0=A0=A0=A0 int violation =3D 0;
>>> =A0=A0=A0=A0=A0 int action =3D 0;
>>> =A0=A0=A0=A0=A0 u32 secid;
>>> @@ -849,13 +862,27 @@ void process_buffer_measurement(struct inode=20
>>> *inode, const void *buf, int size,
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out;
>>> =A0=A0=A0=A0=A0 }
>>> +=A0=A0=A0 if (measure_buf_hash) {
>>
>> ^ if (hash) {
> Yes.
>>> +=A0=A0=A0=A0=A0=A0=A0 memcpy(buf_hash, hash.hdr.digest, buf_hash_len);
>>> +
>>> +=A0=A0=A0=A0=A0=A0=A0 ret =3D ima_calc_buffer_hash(buf_hash, buf_hash_=
len,
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 iin=
t.ima_hash);
>>> +=A0=A0=A0=A0=A0=A0=A0 if (ret < 0) {
>>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 audit_cause =3D "measure_buf_hash_er=
ror";


Hi Mimi,
There already exist a local struct variable named "hash" in p_b_m().
I was thinking of using "buf_hash", but that one is taken too.
Maybe I should use "buf_hash" for the input bool, and rename the
existing "buf_hash" local variable to "digest_hash"?
Does it sound ok?

Thanks,
Tushar


<snip>


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

