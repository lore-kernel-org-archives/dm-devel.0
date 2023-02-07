Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E45C6C636CD
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 23:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675813972;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LFzutgbRpMS+elP/I8imw2/uGFDyWd92df+/Wj2ntMY=;
	b=CWpSUH1bntvZYST20O4jGacVzhvurAKkEMWBdxTR3LwbdLMZd0cJHLdwEzyk83J1pAb205
	+z7svpNvBD+kOR+wEKGyu1u5gS1xQ9SwZ7aQXzbMm3lZttV9e6S4Uj+T0+q11HovB41+pw
	+99DW6OfpWHTAabEoq67k0r6o8pal7I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530--m3HcmTqM7aTdAyq0gPEXw-1; Tue, 07 Feb 2023 18:52:49 -0500
X-MC-Unique: -m3HcmTqM7aTdAyq0gPEXw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6E26800B23;
	Tue,  7 Feb 2023 23:52:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 84FAF14171B6;
	Tue,  7 Feb 2023 23:52:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 62EEE194658D;
	Tue,  7 Feb 2023 23:52:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 76CED1946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 23:52:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64FFE40CF8EF; Tue,  7 Feb 2023 23:52:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D30C400D9D0
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 23:52:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DA3C1800077
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 23:52:46 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-640-qV6-2VjpNFC75aqW7vzGmg-1; Tue,
 07 Feb 2023 18:52:44 -0500
X-MC-Unique: qV6-2VjpNFC75aqW7vzGmg-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 176D020C7E3B; Tue,  7 Feb 2023 15:52:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 176D020C7E3B
Date: Tue, 7 Feb 2023 15:52:43 -0800
From: Fan Wu <wufan@linux.microsoft.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Message-ID: <20230207235243.GA5107@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-11-git-send-email-wufan@linux.microsoft.com>
 <4f029a41d80d883d9b4729cbc85211955c9efe8e.camel@huaweicloud.com>
 <20230201232639.GB9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <903062f7b2e2709ae0e4416545ffadd91c132676.camel@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <903062f7b2e2709ae0e4416545ffadd91c132676.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [RFC PATCH v9 10/16] dm-verity: consume root hash
 digest and signature data via LSM hook
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 paul@paul-moore.com, dm-devel@redhat.com, corbet@lwn.net,
 roberto.sassu@huawei.com, Deven Bowers <deven.desai@linux.microsoft.com>,
 linux-doc@vger.kernel.org, snitzer@kernel.org, jmorris@namei.org,
 zohar@linux.ibm.com, linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 02, 2023 at 09:21:24AM +0100, Roberto Sassu wrote:
> On Wed, 2023-02-01 at 15:26 -0800, Fan Wu wrote:
> > On Tue, Jan 31, 2023 at 02:22:01PM +0100, Roberto Sassu wrote:
> > > On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > > > From: Deven Bowers <deven.desai@linux.microsoft.com>
> > > > 
> > > > dm-verity provides a strong guarantee of a block device's integrity. As
> > > > a generic way to check the integrity of a block device, it provides
> > > > those integrity guarantees to its higher layers, including the filesystem
> > > > level.
> > > 
> > > I think you could reuse most of is_trusted_verity_target(), in
> > > particular dm_verity_get_root_digest().
> > > 
> > > And probably, the previous patch is not necessary.
> > > 
> > > Roberto
> > > 
> > Thanks for the info. This function seems could be used to get the roothash
> > but for saving the signature we still need the hook function in the previous
> > patch.
> 
> Uhm, look at the LoadPin case. It does not need to temporarily store
> the root digest in a security blob. It evaluates it directly.
> 
> Well, ok, dm_verity_loadpin_is_bdev_trusted() looks for trusted digests
> in the dm_verity_loadpin_trusted_root_digests list. So, something
> equivalent needs to be made for IPE (or you just get the digest).
> However, I find not introducing new hooks and evaluating the
> information directly more efficient.
> 
> Roberto

Thanks for the input. I did a deeper dive into the source code and did some
experiements, my conclusion is the hook is still the preferred way for us.

For the root digest part, dm_verity_loadpin_is_bdev_trusted is able to query
the root digest is because the root digest is saved in struct dm_verity.
Specifically it will call dm_verity_get_root_digest to kmemdup the digest.
If every binary execution will trigger a kmemdup to copy a digest,
the overhead will be noticeable. 
Using a hook can let us copy the root digest exactly once when
the block device is created and free the copied digest when 
the block device is unmounted. 

For the signature, it is currently an optional parameter and it is not
saved in struct dm_verity. But even if we let struct dm_verity saves
the signature it will still have the kmemdup problem above. 
So using the hook will be the cleanest way.

-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

