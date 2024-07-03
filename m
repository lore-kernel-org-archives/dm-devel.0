Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4589D14F9ED
	for <dm-devel@lists.linux.dev>; Wed,  3 Jul 2024 19:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720034795; cv=none; b=S40EfXKYBzTxi9mo0xAKPAGZX4/z+4QYfqFxg+U45AFmeDjz3GvTCB7eTik1i6g74oDqtGF7rPmFDUIQ0/aYgxDfuvsBjM+7kjVDQC07duEAXzgSrzSkv5AMRx/iqqGMCTOIeTQm9tEgxVmAO2XUP3AnADEBaPoqaNjmeZaWVSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720034795; c=relaxed/simple;
	bh=WAoUJbGhrX5Vjg8azBqzziIChLVmL0i2wELJBbtfdUo=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ssbnYGPr8aaVpXErgp0ox1oogIbT18Sohw0tsl+LM/+EfprYDzIEZ/CnNN6KAAyEYRVTqCk3CfW17X1bAfrzByFtyzMK40ytFL2FGkv2pAmTTZecI5aZDeOfpczOXiT2LBf0d7NhqE/Tgxgy6qAvRzX894j65WLC+ogWOX/GMqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KPGmX1nk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KPGmX1nk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720034792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i8QsoV70mZg2wDfbA5NnCR1hchqKzleMQDaV7ELVd9c=;
	b=KPGmX1nkupxahfIQgxl3+4jz2sANKLqfFbJP73c3q5Zb24LwOEwbNhnuNLG7lJlKHo+4hJ
	DZscKZG66x3/BWLmB2kbltUceepWYnAQtus5nntuk12nHKKV+Z8SgzvNG0oV4+ktgxzc89
	CcPXndfsXEre8oHsYwUIOrGCzLohn0o=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101--W6xFp0mOmuEC_gUFb3s9w-1; Wed, 03 Jul 2024 15:26:30 -0400
X-MC-Unique: -W6xFp0mOmuEC_gUFb3s9w-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-79d6c6b3079so755530085a.0
        for <dm-devel@lists.linux.dev>; Wed, 03 Jul 2024 12:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720034790; x=1720639590;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i8QsoV70mZg2wDfbA5NnCR1hchqKzleMQDaV7ELVd9c=;
        b=POJkyByNrVbQsPIjWic7wIVhakvYx1PLTSmm6TCZ1h4+pF6Wezc3ngtjYCtlLGwDVt
         NdpbXJbKynBWvkS4q5Ki5QeEbkoXl7GCHa4bw1zzO00B83wLb/A641eh6OyUHZYpbQ4Y
         xVrL86mJwC72IKfo50BA4a8BFZWhhuea4ios1PlDe1ksqNw5LW6dnTRxoAWqdFWT8nBx
         xhiMqWzrwCM9NFvRhO9z89uQyVr9JON5F39smm6hc7UpIhX1yqIRcAEnczaXF83+9Vkw
         0Rb6R+0GWpll3zWA4kYHtWbB/FhF+QK8EzYBrNdgUy6n9IiqreDtxM41qN9UYcblRBa7
         ZuBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWWgp68jL1zXwmEbHAuVaAb7l0shdA9SQgy00Ps2HFBpZ/ZXylIsKqh9o20t5uDB9ptHm9E7pvHKyZjlg2iKLR8xYC5JRHO8FA=
X-Gm-Message-State: AOJu0YwnW2+lfdWAaGky0mkeJaFEZIW3pwlnjxWDqUV4DuoHdzNYFRM+
	YBPxrkLc0koKBpRLCYrH30/9+R7MReitOZGZMABrpev3GZAmcWdzhYvXHk0OacuhzYkMEC5rYWb
	l89QSPMoRstQ96RIzFbUkIN6vpkakTrFnXCdw6oa0ctkYzSuJfpmkqwDp
X-Received: by 2002:a05:620a:3953:b0:796:842c:7808 with SMTP id af79cd13be357-79d7b987e27mr1748756085a.4.1720034790107;
        Wed, 03 Jul 2024 12:26:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIS3bm50dFPnmZZ4qvTBhpAFg0xlUBpgf67WQnQEx/1R+ir+1Q7yBa3DV5EfewIVKDuEEhAQ==
X-Received: by 2002:a05:620a:3953:b0:796:842c:7808 with SMTP id af79cd13be357-79d7b987e27mr1748753685a.4.1720034789734;
        Wed, 03 Jul 2024 12:26:29 -0700 (PDT)
Received: from [192.168.1.152] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79d692f0659sm597350785a.79.2024.07.03.12.26.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 12:26:29 -0700 (PDT)
Message-ID: <a4da5d25-fbfb-4047-c384-99a9063887fb@redhat.com>
Date: Wed, 3 Jul 2024 15:26:28 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@lists.linux.dev
From: Matthew Sakai <msakai@redhat.com>
Subject: VDO fixes for 6.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mikulas,

These are two small cleanups applied to the vdo tree. I think these got 
lost in the shuffle somewhere, can you pull these for dm-6.11?

Thanks!

The following changes since commit 48ef0ba12e6b77a1ce5d09c580c38855b090ae7c:

   dm: restore synchronous close of device mapper block device 
(2024-04-16 11:32:07 -0400)

are available in the Git repository at:

   git@github.com:dm-vdo/dm-linux.git vdo-next

for you to fetch changes up to 5cac38a8dfa2557c15822467ebcd9fac400fdc37:

   dm vdo indexer: use swap() instead of open coding it (2024-06-11 
22:11:45 -0400)

----------------------------------------------------------------
Dr. David Alan Gilbert (1):
       dm vdo: remove unused struct 'uds_attribute'

Jiapeng Chong (1):
       dm vdo indexer: use swap() instead of open coding it

  drivers/md/dm-vdo/dedupe.c        | 5 -----
  drivers/md/dm-vdo/indexer/index.c | 5 +----
  2 files changed, 1 insertion(+), 9 deletions(-)

Matt

