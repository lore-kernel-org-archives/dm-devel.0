Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65B85665
	for <dm-devel@lists.linux.dev>; Sun, 29 Oct 2023 06:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LzefDqn2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698560628;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6APcAHJnPRDgsos+ljCYaEzULw//MCqDLfIgMUvZ7DE=;
	b=LzefDqn252dQ81mtgPkCeUK+kNmmu4XcKkEz2qj3hxNwLdz7O7EFqWktEdinCWxLjWo6zf
	iw2TAsxdeE3vOMjqIoAYvzEy7lIlMlevWJ1RSGJrnCrK8Ochwvsbk6TFLw+176eVf1bok+
	OK4lJs4aGZXsr/OqE0nBuaJ3JOIBs4Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-v3Y7jkNvPzCAKxw_518IVw-1; Sun, 29 Oct 2023 02:23:46 -0400
X-MC-Unique: v3Y7jkNvPzCAKxw_518IVw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60DFA811E7D
	for <dm-devel@lists.linux.dev>; Sun, 29 Oct 2023 06:23:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 57CDEC1596D
	for <dm-devel@lists.linux.dev>; Sun, 29 Oct 2023 06:23:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 16C6F1946595
	for <dm-devel@lists.linux.dev>; Sun, 29 Oct 2023 06:23:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 341FB1946587
 for <dm-devel@listman.corp.redhat.com>; Sun, 29 Oct 2023 06:23:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D8981502C; Sun, 29 Oct 2023 06:23:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D101A502B
 for <dm-devel@redhat.com>; Sun, 29 Oct 2023 06:23:44 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A39083806706
 for <dm-devel@redhat.com>; Sun, 29 Oct 2023 06:23:44 +0000 (UTC)
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de
 [80.237.130.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-O6cWrydWMAeRR_IO_tABag-1; Sun, 29 Oct 2023 02:23:42 -0400
X-MC-Unique: O6cWrydWMAeRR_IO_tABag-1
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
 by wp530.webpack.hosteurope.de running ExIM with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
 id 1qwzCv-0001je-OJ; Sun, 29 Oct 2023 07:23:33 +0100
Message-ID: <cb0ec234-5a91-4469-9261-2a266f0ce9ab@leemhuis.info>
Date: Sun, 29 Oct 2023 07:23:32 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, Linux Stable <stable@vger.kernel.org>
References: <ZTNH0qtmint/zLJZ@mail-itl> <ZTOCUJdgDDBX-ecp@debian.me>
From: "Linux regression tracking #update (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
In-Reply-To: <ZTOCUJdgDDBX-ecp@debian.me>
X-bounce-key: webpack.hosteurope.de; regressions@leemhuis.info; 1698560622;
 3cc3668b
X-HE-SMSGID: 1qwzCv-0001je-OJ
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
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
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc: Linux Regressions <regressions@lists.linux.dev>,
 Mike Snitzer <snitzer@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Linux Devicemapper <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: leemhuis.info
Content-Language: en-US, de-DE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[TLDR: This mail in primarily relevant for Linux regression tracking. A
change or fix related to the regression discussed in this thread was
posted or applied, but it did not use a Closes: tag to point to the
report, as Linus and the documentation call for. Things happen, no
worries -- but now the regression tracking bot needs to be told manually
about the fix. See link in footer if these mails annoy you.]

On 21.10.23 09:48, Bagas Sanjaya wrote:
> On Sat, Oct 21, 2023 at 05:38:58AM +0200, Marek Marczykowski-Górecki wrote:
>>
>> Since updating from 6.4.13 to 6.5.5 occasionally I hit a storage
>> subsystem freeze - any I/O ends up frozen. I'm not sure what exactly
>> triggers the issue, but often it happens when doing some LVM operations
>> (lvremove, lvrename etc) on a dm-thin volume together with bulk data
>> copy to/from another LVM thin volume with ext4 fs.
> [...] 
> #regzbot ^introduced: 5054e778fcd9cd

#regzbot fix: dm crypt: don't allocate large compound pages
#regzbot ignore-activity

(fix currently found in
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.7&id=b3d87b87017d50cab1ea49fc6810c74584e00027
)

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

