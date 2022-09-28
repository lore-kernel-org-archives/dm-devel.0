Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D22C6FA92
	for <dm-devel@archiver.kernel.org>; Thu, 29 Sep 2022 07:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664435224;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mzjjzLCZQ/H2HOxyjRSoeqRrJQJEsgqJCFfGNiiIZZ4=;
	b=D6561LPxgb5y4Afk7qWKMXDQdrSwCNMF4lbTBT3b6p2KaYUVrZh5T8peGrkmOUa13DUM4E
	VlbzovePTBHDZomYEBjMqy3ffw9iJOwIJ3wIHHxHPRq73Rq0C8F4xICQPYR4d7YL1QX6eu
	DzkR+S0WZBmOt+qv+j763I+12Ckm5dQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-1RC8kLA-PAezK_vhmMoDNA-1; Thu, 29 Sep 2022 03:07:00 -0400
X-MC-Unique: 1RC8kLA-PAezK_vhmMoDNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B85F4858282;
	Thu, 29 Sep 2022 07:06:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A624DC15BA4;
	Thu, 29 Sep 2022 07:06:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D1AE1946A6B;
	Thu, 29 Sep 2022 07:06:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 87A0A19465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Sep 2022 10:19:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 66259492CA4; Wed, 28 Sep 2022 10:19:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EA7B492CA2
 for <dm-devel@redhat.com>; Wed, 28 Sep 2022 10:19:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44840185A79C
 for <dm-devel@redhat.com>; Wed, 28 Sep 2022 10:19:00 +0000 (UTC)
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-580-AZMFvVYwMFmc3M6T2gRpxQ-1; Wed,
 28 Sep 2022 06:18:58 -0400
X-MC-Unique: AZMFvVYwMFmc3M6T2gRpxQ-1
Received: from theinternet.molgen.mpg.de (theinternet.molgen.mpg.de
 [141.14.31.7])
 (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested) (Authenticated sender: buczek)
 by mx.molgen.mpg.de (Postfix) with ESMTPSA id 6297461EA1929;
 Wed, 28 Sep 2022 12:10:43 +0200 (CEST)
To: Theodore Ts'o <tytso@mit.edu>
References: <4e83fb26-4d4a-d482-640c-8104973b7ebf@molgen.mpg.de>
 <20220531103834.vhscyk3yzsocorco@quack3.lan>
 <3bfd0ad9-d378-9631-310f-0a1a80d8e482@molgen.mpg.de>
 <YpY2o/GG8HWJHTdo@mit.edu>
From: Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <302f2af1-eee8-95aa-91f5-55fe5cf8727f@molgen.mpg.de>
Date: Wed, 28 Sep 2022 12:10:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YpY2o/GG8HWJHTdo@mit.edu>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 29 Sep 2022 07:06:56 +0000
Subject: Re: [dm-devel] ext4_writepages: jbd2_start: 5120 pages, ino 11;
 err -5
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
Cc: Jan Kara <jack@suse.cz>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
 it+linux@molgen.mpg.de, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/31/22 5:39 PM, Theodore Ts'o wrote:
> Hmmm..... I think this patch should fix your issues.

Thanks a lot. Unfortunately, it didn't, I still occasionally get

    [368259.560885] EXT4-fs (dm-0): ext4_writepages: jbd2_start: 344 pages, ino 279244; err -5


D.


> 
> If the journal has been aborted (which happens as part of the
> shutdown, we will never write out the commit block --- so it should be
> fine to skip the writeback of any dirty inodes in data=ordered mode.
> 
> BTW, if you know that the file system is going to get nuked in this
> way all the time, so you never care about file system after it is shut
> down, you could mount the file system with the mount option
> data=writeback.
> 
>        	      	      	    		- Ted
> 
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 8ff4c6545a49..2e18211121f6 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -542,7 +542,10 @@ static int ext4_journalled_submit_inode_data_buffers(struct jbd2_inode *jinode)
>  static int ext4_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
>  {
>  	int ret;
> +	journal_t *journal = EXT4_SB(jinode->i_vfs_inode->i_sb)->s_journal;
>  
> +	if (!journal || is_journal_aborted(journal))
> +		return 0;
>  	if (ext4_should_journal_data(jinode->i_vfs_inode))
>  		ret = ext4_journalled_submit_inode_data_buffers(jinode);
>  	else
> @@ -554,7 +557,10 @@ static int ext4_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
>  static int ext4_journal_finish_inode_data_buffers(struct jbd2_inode *jinode)
>  {
>  	int ret = 0;
> +	journal_t *journal = EXT4_SB(jinode->i_vfs_inode->i_sb)->s_journal;
>  
> +	if (!journal || is_journal_aborted(journal))
> +		return 0;
>  	if (!ext4_should_journal_data(jinode->i_vfs_inode))
>  		ret = jbd2_journal_finish_inode_data_buffers(jinode);
> 


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

