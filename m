Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C963EB64D7
	for <dm-devel@archiver.kernel.org>; Fri, 23 Jun 2023 06:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687501793;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ph0JZgcXRRHY41nGi3mYbfQ3+BzTgjsE4HEDtT4cNjQ=;
	b=GtDz159UU2gjRCTYkgjTgx07T6OYrRSsUCWf3tI62NZFBd+UkKSEDHQ17rTF0bGo212oh5
	q7Mj7cjA3iv4WWQnxOMmO2jszWeZ1NvFbEbm9jJI43M/9CUofDnNfRX3LVfy/bkQDqsLDk
	T5nrBhKQHclt4I1rg7uUdhn3RPPv/Ww=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-zDJInX6BNoKwari8hjjRSA-1; Fri, 23 Jun 2023 02:29:51 -0400
X-MC-Unique: zDJInX6BNoKwari8hjjRSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC466101A54E;
	Fri, 23 Jun 2023 06:29:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7866E2017DC6;
	Fri, 23 Jun 2023 06:29:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 45DF71946588;
	Fri, 23 Jun 2023 06:29:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D80411946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Jun 2023 06:29:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B724B425356; Fri, 23 Jun 2023 06:29:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF235492C13
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 06:29:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72203185A794
 for <dm-devel@redhat.com>; Fri, 23 Jun 2023 06:29:46 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-fwVEQJEBMTi9jwuzqL3TYQ-1; Fri, 23 Jun 2023 02:29:44 -0400
X-MC-Unique: fwVEQJEBMTi9jwuzqL3TYQ-1
Received: by mail-pl1-f176.google.com with SMTP id
 d9443c01a7336-1b50e309602so2203965ad.0
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 23:29:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687501783; x=1690093783;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=zCEqJX5mm9cbUE56OVCDucRVQniQh/jh7QjO1tCYRyw=;
 b=ekPlQscgrmgOv1Bf7hOWdF5mZg198O3geShl04KaI84P35yz4A4fCJl8cFEqbdaGI4
 V3weMImYL9FfAfearPXsazHWNeMKQ7HiHpeE7oVX5ehg9DZg3itrHqnbbtjQ662EhbIM
 nhncE9+j/d4Px9Ce6mlv+L9t18aP9KfXkmbmCfnYmNggvUBy3lwSuXXIZ2pmSewTOuh8
 U1Gq6BSNqsuh3NKl0WjTsinOReEB29Hj28mfkbYJXclL1zajGTtym0Gcq45fNJYVnlTo
 rp+fRoMjKicTs6lz9lZnkqD/ndRTcoVbGb3dQTjBIUg158K4ohNyzWPzihJqg9iK0pS2
 7NKw==
X-Gm-Message-State: AC+VfDzKpwr7LNFh7l5ELL5P6mZEuij+Lo8MLuRYd04dzHQjj9p2bbdH
 RC9f74G4SGSFkMfY8DCvqy3N/g==
X-Google-Smtp-Source: ACHHUZ6xCu/M/0AOwG5LVLb8OX3DoTsqyFTeplRrHsUG1u2SLkBGduWAm9ZrSI41Zhf0Zeq1UunMJA==
X-Received: by 2002:a17:902:8214:b0:1aa:d971:4623 with SMTP id
 x20-20020a170902821400b001aad9714623mr18870991pln.38.1687501783228; 
 Thu, 22 Jun 2023 23:29:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au.
 [49.180.13.202]) by smtp.gmail.com with ESMTPSA id
 x5-20020a1709027c0500b001b246dcffb7sm6311389pll.300.2023.06.22.23.29.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 22 Jun 2023 23:29:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qCaId-00F8x8-0s;
 Fri, 23 Jun 2023 16:29:39 +1000
Date: Fri, 23 Jun 2023 16:29:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <ZJU708VIyJ/3StAX@dread.disaster.area>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-25-zhengqi.arch@bytedance.com>
 <cf0d9b12-6491-bf23-b464-9d01e5781203@suse.cz>
MIME-Version: 1.0
In-Reply-To: <cf0d9b12-6491-bf23-b464-9d01e5781203@suse.cz>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 24/29] mm: vmscan: make global slab shrink
 lockless
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
Cc: djwong@kernel.org, roman.gushchin@linux.dev,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, linux-ext4@vger.kernel.org, paulmck@kernel.org,
 linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-nfs@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-bcache@vger.kernel.org, dri-devel@lists.freedesktop.org,
 brauner@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 akpm@linux-foundation.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jun 22, 2023 at 05:12:02PM +0200, Vlastimil Babka wrote:
> On 6/22/23 10:53, Qi Zheng wrote:
> > @@ -1067,33 +1068,27 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
> >  	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
> >  		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
> >  
> > -	if (!down_read_trylock(&shrinker_rwsem))
> > -		goto out;
> > -
> > -	list_for_each_entry(shrinker, &shrinker_list, list) {
> > +	rcu_read_lock();
> > +	list_for_each_entry_rcu(shrinker, &shrinker_list, list) {
> >  		struct shrink_control sc = {
> >  			.gfp_mask = gfp_mask,
> >  			.nid = nid,
> >  			.memcg = memcg,
> >  		};
> >  
> > +		if (!shrinker_try_get(shrinker))
> > +			continue;
> > +		rcu_read_unlock();
> 
> I don't think you can do this unlock?
> 
> > +
> >  		ret = do_shrink_slab(&sc, shrinker, priority);
> >  		if (ret == SHRINK_EMPTY)
> >  			ret = 0;
> >  		freed += ret;
> > -		/*
> > -		 * Bail out if someone want to register a new shrinker to
> > -		 * prevent the registration from being stalled for long periods
> > -		 * by parallel ongoing shrinking.
> > -		 */
> > -		if (rwsem_is_contended(&shrinker_rwsem)) {
> > -			freed = freed ? : 1;
> > -			break;
> > -		}
> > -	}
> >  
> > -	up_read(&shrinker_rwsem);
> > -out:
> > +		rcu_read_lock();
> 
> That new rcu_read_lock() won't help AFAIK, the whole
> list_for_each_entry_rcu() needs to be under the single rcu_read_lock() to be
> safe.

Yeah, that's the pattern we've been taught and the one we can look
at and immediately say "this is safe".

This is a different pattern, as has been explained bi Qi, and I
think it *might* be safe.

*However.*

Right now I don't have time to go through a novel RCU list iteration
pattern it one step at to determine the correctness of the
algorithm. I'm mostly worried about list manipulations that can
occur outside rcu_read_lock() section bleeding into the RCU
critical section because rcu_read_lock() by itself is not a memory
barrier.

Maybe Paul has seen this pattern often enough he could simply tell
us what conditions it is safe in. But for me to work that out from
first principles? I just don't have the time to do that right now.

> IIUC this is why Dave in [4] suggests unifying shrink_slab() with
> shrink_slab_memcg(), as the latter doesn't iterate the list but uses IDR.

Yes, I suggested the IDR route because radix tree lookups under RCU
with reference counted objects are a known safe pattern that we can
easily confirm is correct or not.  Hence I suggested the unification
+ IDR route because it makes the life of reviewers so, so much
easier...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

