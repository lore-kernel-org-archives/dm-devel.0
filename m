Return-Path: <SRS0=5DIA=HG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03848C433E0
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 04:21:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 228FB64E06
	for <dm-devel@archiver.kernel.org>; Thu,  4 Feb 2021 04:21:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 228FB64E06
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-6PCqCOJ4MO2IhYPpjdRDBQ-1; Wed, 03 Feb 2021 23:21:10 -0500
X-MC-Unique: 6PCqCOJ4MO2IhYPpjdRDBQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8424AFA82;
	Thu,  4 Feb 2021 04:21:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA044100763D;
	Thu,  4 Feb 2021 04:21:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE57658074;
	Thu,  4 Feb 2021 04:21:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1144KxhX007542 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Feb 2021 23:20:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 61BB61055320; Thu,  4 Feb 2021 04:20:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CDB5105507F
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 04:20:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01D6285A59D
	for <dm-devel@redhat.com>; Thu,  4 Feb 2021 04:20:54 +0000 (UTC)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-538-l9meFMjyMkKlk_gD5ddznw-1; Wed, 03 Feb 2021 23:20:50 -0500
X-MC-Unique: l9meFMjyMkKlk_gD5ddznw-1
Received: from [2601:1c0:6280:3f0::aec2]
	by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1l7W2w-0002Ru-Mv; Thu, 04 Feb 2021 04:15:11 +0000
To: Sergei Shtepa <sergei.shtepa@veeam.com>, Damien.LeMoal@wdc.com,
	snitzer@redhat.com, hare@suse.de, ming.lei@redhat.com, agk@redhat.com, 
	corbet@lwn.net, axboe@kernel.dk, jack@suse.cz,
	johannes.thumshirn@wdc.com, gregkh@linuxfoundation.org,
	koct9i@gmail.com, steve@sk2.org, dm-devel@redhat.com,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1612367638-3794-1-git-send-email-sergei.shtepa@veeam.com>
	<1612367638-3794-2-git-send-email-sergei.shtepa@veeam.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ef604ad7-1348-1ffa-e3c4-67d153620e08@infradead.org>
Date: Wed, 3 Feb 2021 20:15:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1612367638-3794-2-git-send-email-sergei.shtepa@veeam.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: pavgel.tide@veeam.com
Subject: Re: [dm-devel] [PATCH v4 1/6] docs: device-mapper: add
	remap_and_filter
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/3/21 7:53 AM, Sergei Shtepa wrote:
> remap_and_filter - describes the new features that
> blk_interposer provides for device mapper.
> 
> Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>

Hi--
Please see comments below.


> ---
>  .../admin-guide/device-mapper/index.rst       |   1 +
>  .../device-mapper/remap_and_filter.rst        | 132 ++++++++++++++++++
>  2 files changed, 133 insertions(+)
>  create mode 100644 Documentation/admin-guide/device-mapper/remap_and_filter.rst

> diff --git a/Documentation/admin-guide/device-mapper/remap_and_filter.rst b/Documentation/admin-guide/device-mapper/remap_and_filter.rst
> new file mode 100644
> index 000000000000..616b67998305
> --- /dev/null
> +++ b/Documentation/admin-guide/device-mapper/remap_and_filter.rst
> @@ -0,0 +1,132 @@
> +=================
> +DM remap & filter
> +=================
> +
> +Introduction
> +============
> +
> +Usually LVM should be used for new devices.
> +The administrator have to create logical volumes for the system partition

                     has

> +when installing the operating system. For a running system with
> +partitioned disk space and mounted file systems, it is quite difficult to
> +reconfigure to logical volumes. As a result, all the features that Device
> +Mapper provides are not available for non-LVM systems.
> +This problem is partially solved by the dm remap functionality, which
> +uses the kernel's blk_interposer.
> +
> +blk_interposer
> +==============
> +
> +Blk_interposer extends the capabilities of the DM, as it allows to
> +intercept and redirect bio requests for block devices that are not
> +dm device. At the same time, blk_interposer allows to attach and detach

      devices.

> +from devices "on the fly", without stopping the execution of user
> +programs.
> +
> +Blk_interposer allows to do two tasks: remap and filter.
> +Remap allows to redirect all requests from one block device to another.
> +Filter allows to do additional processing of the request, but without
> +redirection. An intercepted request can get to the block device to which
> +it was addressed, without changes.
> +
> +Remap
> +=====
> +
> +Consider the functionality of the remap. This will allow to connect
> +any block device with a dm device "on the fly".
> +Suppose we have a file system mounted on the block device /dev/sda1::
> +
> +  +-------------+
> +  | file system |
> +  +-------------+
> +        ||
> +        \/
> +  +-------------+
> +  | /dev/sda1   |
> +  +-------------+
> +
> +Creating a new DM device that will be mapped on the same /dev/sda1::

Sometimes it's "DM", other times it's "dm" device. Please be consistent.

> +
> +  +-------------+  +-----------+
> +  | file system |  | dm-linear |
> +  +-------------+  +-----------+
> +           ||         ||
> +           \/         \/
> +         +---------------+
> +         |   /dev/sda1   |
> +         +---------------+
> +
> +Redirecting all bio requests for the /dev/sda1 device to the new dm
> +device::
> +
> +  +-------------+
> +  | file system |
> +  +-------------+
> +        ||
> +        \/
> +   +----------+    +-----------+
> +   |  remap   | => | dm-linear |
> +   +----------+    +-----------+
> +                         ||
> +                         \/
> +                   +-----------+
> +                   | /dev/sda1 |
> +                   +-----------+
> +
> +To achieve this, you need to:
> +
> +Create new dm device with option 'noexcl'. It's allow to open

                                                   allowed to open the

> +underlying block-device without the FMODE_EXCL flag::
> +
> +  echo "0 `blockdev --getsz $1` linear $DEV 0 noexcl" | dmsetup create dm-noexcl
> +
> +Call remap command::
> +
> +  dmsetup remap start dm-noexcl $1
> +
> +Remap can be used to extend the functionality of dm-snap. This will allow
> +to take snapshots from any block devices, not just logical volumes.
> +
> +Filter
> +======
> +
> +Filter does not redirect the bio to another device. It does not create
> +a clone of the bio request. After receiving the request, the filter can
> +only add some processing, complete the bio request, or return the bio
> +for further processing.
> +
> +Suppose we have a file system mounted on the block device /dev/sda1::
> +
> +  +-------------+
> +  | file system |
> +  +-------------+
> +        ||
> +        \/
> +  +-------------+
> +  | /dev/sda1   |
> +  +-------------+
> +
> +Creating a new dm device that will implement filter::
> +
> +  +-------------+
> +  | file system |
> +  +-------------+
> +        ||
> +        \/
> +    +--------+    +----------+
> +    | filter | => | dm-delay |
> +    +--------+    +----------+
> +        ||
> +        \/
> +  +-------------+
> +  | /dev/sda1   |
> +  +-------------+
> +
> +Using filter we can change the behavior of debugging tools:
> + * dm-dust,
> + * dm-delay,
> + * dm-flakey,
> + * dm-verity.
> +
> +In the new version, they are will be able to change the behavior of any

          Either       they are able to change the behavior of any
            or         they will be able to change the behavior of any

I prefer the first choice.

> +existing block device, without creating a new one.


According to Documentation/doc-guide/sphinx.rst, here is how
chapters, sections, etc., should be indicated:


* Please stick to this order of heading adornments:

  1. ``=`` with overline for document title::

       ==============
       Document title
       ==============

  2. ``=`` for chapters::

       Chapters
       ========

  3. ``-`` for sections::

       Section
       -------

  4. ``~`` for subsections::

       Subsection
       ~~~~~~~~~~

  Although RST doesn't mandate a specific order ("Rather than imposing a fixed
  number and order of section title adornment styles, the order enforced will be
  the order as encountered."), having the higher levels the same overall makes
  it easier to follow the documents.



thanks.
-- 
~Randy

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

