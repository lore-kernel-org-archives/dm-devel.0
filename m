Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737EA156C7
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XFgJKyTe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697524377;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=zzmAztgi6ecB7UaqCGob459y4GhttsIKx/RrP9U9cpE=;
	b=XFgJKyTe7IICl05GThgBeAQsoE+9SUWy4x6aSYTuhwZf9YzUcEqzBjyjEGpkqlNMjIIHXe
	VboZPCE+E6aPo8ErjvU2tlBSmj0+Pn/MsjcJJ6cW5UvdGX8FGtoZBoW+3IUE1Njo+cK10o
	PFrtna+CsXlRAISJ7FwCsFgqfy3wLz0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-mOkd4smQM3qaP00XW51JjQ-1; Tue, 17 Oct 2023 02:32:55 -0400
X-MC-Unique: mOkd4smQM3qaP00XW51JjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BABE1C0BB51
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:32:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6366D1C060AE
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:32:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2C86D19466EC
	for <dm-devel@lists.linux.dev>; Tue, 17 Oct 2023 06:32:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D27EC1946587
 for <dm-devel@listman.corp.redhat.com>; Sun, 15 Oct 2023 02:20:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 92985C15BBC; Sun, 15 Oct 2023 02:20:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B94CC15BB8
 for <dm-devel@redhat.com>; Sun, 15 Oct 2023 02:20:16 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60EB385A5BA
 for <dm-devel@redhat.com>; Sun, 15 Oct 2023 02:20:16 +0000 (UTC)
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com
 [209.85.128.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-BT5zG55rMOCfb7Yos8sNiw-1; Sat, 14 Oct 2023 22:20:09 -0400
X-MC-Unique: BT5zG55rMOCfb7Yos8sNiw-1
Received: by mail-yw1-f170.google.com with SMTP id
 00721157ae682-5a822f96aedso21883207b3.2
 for <dm-devel@redhat.com>; Sat, 14 Oct 2023 19:20:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1697336409; x=1697941209;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=zzmAztgi6ecB7UaqCGob459y4GhttsIKx/RrP9U9cpE=;
 b=Yo0Ls0HBYNjsqa5A/eyAHx86ABeM5RkMpCODc5HLV+eYoMnCg/tJyf659+v1NZb7Lv
 o8R3Pd60exhq4yyyeGnwWKixAa7UDt+/x7XhMwwp0Xkxpe7TqYXl2SnE6oeYPaNWZm3z
 WOhirvBqOulrzC6kvRC3VARKtZHgkG6w/2Ctfn9dX2Elx9BfB/Prf+KNuT01pcOAmJH7
 Ik7O31ZTNiXhRCrzUuZi+dZNGojj3tsLYrxhc7lPRgZMir5Kz/LbCQ41OcPM40t3gFd0
 jw0EyWv3+FyJCrASUHmuzSoMf/gbhZ/lS2hTaEKDX0oEbN/hoT4mtB/sX3jTMj8FjWXx
 od9w==
X-Gm-Message-State: AOJu0Ywlrhhkc4ddXwsaztvzs1vM+iLS8KkyJwvWMb+eoYhvLlK+jM33
 huMYyEzJeo0drmuDBPRGUJU1mAAHPmi+lQ==
X-Google-Smtp-Source: AGHT+IGkOEjO+bGWWFCarw0RLmOk68tVCv/6p3H378i9MP3Ve1TWkdNvsdbRXDgjuLQXDGyqdxhtJg==
X-Received: by 2002:a05:690c:257:b0:5a7:b51a:e176 with SMTP id
 ba23-20020a05690c025700b005a7b51ae176mr14718261ywb.12.1697336408657; 
 Sat, 14 Oct 2023 19:20:08 -0700 (PDT)
Received: from localhost ([2607:fb90:3e2c:8023:e145:ae9d:cf98:1574])
 by smtp.gmail.com with ESMTPSA id
 z193-20020a0dd7ca000000b005a8073e2062sm1025954ywd.33.2023.10.14.19.20.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 Oct 2023 19:20:08 -0700 (PDT)
Date: Sat, 14 Oct 2023 19:20:07 -0700
From: Yury Norov <yury.norov@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH 09/14] bitmap: extend bitmap_{get,set}_value8() to
 bitmap_{get,set}_bits()
Message-ID: <ZStMV46v4EkoUHE8@yury-ThinkPad>
References: <20231009151026.66145-1-aleksander.lobakin@intel.com>
 <20231009151026.66145-10-aleksander.lobakin@intel.com>
 <ZSQq02A9mTireK71@yury-ThinkPad>
 <a28542e2-4a5b-4c29-9d4a-12a0d2ab5527@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a28542e2-4a5b-4c29-9d4a-12a0d2ab5527@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mailman-Approved-At: Tue, 17 Oct 2023 06:31:30 +0000
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
Cc: linux-s390@vger.kernel.org, ntfs3@lists.linux.dev,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 David Ahern <dsahern@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 Alexander Potapenko <glider@google.com>,
 Simon Horman <simon.horman@corigine.com>, Jakub Kicinski <kuba@kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 11, 2023 at 11:33:25AM +0200, Alexander Lobakin wrote:
> From: Yury Norov <yury.norov@gmail.com>
> Date: Mon, 9 Oct 2023 09:31:15 -0700
> 
> > + Alexander Potapenko <glider@google.com>
> > 
> > On Mon, Oct 09, 2023 at 05:10:21PM +0200, Alexander Lobakin wrote:
> >> Sometimes there's need to get a 8/16/...-bit piece of a bitmap at a
> >> particular offset. Currently, there are only bitmap_{get,set}_value8()
> >> to do that for 8 bits and that's it.
> > 
> > And also a series from Alexander Potapenko, which I really hope will
> > get into the -next really soon. It introduces bitmap_read/write which
> > can set up to BITS_PER_LONG at once, with no limitations on alignment
> > of position and length:
> > 
> > https://lore.kernel.org/linux-arm-kernel/ZRXbOoKHHafCWQCW@yury-ThinkPad/T/#mc311037494229647088b3a84b9f0d9b50bf227cb
> > 
> > Can you consider building your series on top of it?
> 
> Yeah, I mentioned in the cover letter that I'm aware of it and in fact
> it doesn't conflict much, as the functions I'm adding here get optimized
> as much as the original bitmap_{get,set}_value8(), while Alexander's
> generic helpers are heavier.
> I realize lots of calls will be optimized as well due to the offset and
> the width being compile-time constants, but not all of them. The idea of
> keeping two pairs of helpers initially came from Andy if I understood
> him correctly.
> What do you think? I can provide some bloat-o-meter stats after
> rebasing. And either way, I see no issue in basing this series on top of
> Alex' one.

You're right, let's try both and see what how worse is one comparing
to another wrt bloat-o-meter and overall code generation. If the
difference is not that terrible, I'd stick to universal and simpler
for users version.

If the difference is significant, we'd have to keep both. Maybe it's
worth to try merge the aligned case into generic one, but it's not the
purpose of your series, of course.

Thanks,
Yury

