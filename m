Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD824C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 12 Feb 2022 16:50:17 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-BOI8Hls3N8CMNaWwTmHx_A-1; Sat, 12 Feb 2022 11:50:13 -0500
X-MC-Unique: BOI8Hls3N8CMNaWwTmHx_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D7E61006AA0;
	Sat, 12 Feb 2022 16:50:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 630A77E2F4;
	Sat, 12 Feb 2022 16:50:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3A97C4BB7C;
	Sat, 12 Feb 2022 16:50:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21CGntsx004791 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 12 Feb 2022 11:49:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 070552026D46; Sat, 12 Feb 2022 16:49:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 024EC2026D65
	for <dm-devel@redhat.com>; Sat, 12 Feb 2022 16:49:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A173C811E81
	for <dm-devel@redhat.com>; Sat, 12 Feb 2022 16:49:51 +0000 (UTC)
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-135-EHEFCmUKNgKLntwJbtBNvw-1; Sat, 12 Feb 2022 11:49:50 -0500
X-MC-Unique: EHEFCmUKNgKLntwJbtBNvw-1
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net
	[108.7.220.252]) (authenticated bits=0)
	(User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 21CGkxsP010096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Sat, 12 Feb 2022 11:47:00 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id 1847215C0040; Sat, 12 Feb 2022 11:46:59 -0500 (EST)
Date: Sat, 12 Feb 2022 11:46:59 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Qing Wang <wangqing@vivo.com>
Message-ID: <Ygfkg0n6RvvJYMJa@mit.edu>
References: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
In-Reply-To: <1644546640-23283-1-git-send-email-wangqing@vivo.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>,
	Michael Turquette <mturquette@baylibre.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	dri-devel@lists.freedesktop.org,
	Hans Verkuil <hverkuil@xs4all.nl>, dm-devel@redhat.com,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	linux-clk@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
	amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-media@vger.kernel.org,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	intel-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>, linux-block@vger.kernel.org,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, linux-kernel@vger.kernel.org,
	Daniel Vetter <daniel@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH V2 00/13] use time_is_xxx() instead of
	jiffies judgment
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 10, 2022 at 06:30:23PM -0800, Qing Wang wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> It is better to use time_is_xxx() directly instead of jiffies judgment
> for understanding.

Hi Wang,

"judgement" doesn't really make sense as a description to an English
speaker.  The following a commit desription (for all of these series)
is probably going to be a bit more understable:

Use the helper function time_is_{before,after}_jiffies() to improve
code readability.

Cheers,

						- Ted

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

