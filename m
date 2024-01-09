Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336803DB80
	for <dm-devel@lists.linux.dev>; Tue,  9 Jan 2024 21:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="A09mxoyc"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3608bdb484fso7760255ab.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jan 2024 13:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1704834189; x=1705438989; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Xp+jSWNyDVNPrZ4o9pnDkGaguZvDQ9fIqaku88C5tc=;
        b=A09mxoycRSkydhAlMZfnbxk4cwGKAW+dlYkRn5w+3xb1cR8WBkH8zi3pLCdQ6NunIL
         tlolVz4r/p1FGDIEmefU+RfAFgaskEzYRYZlRMF1tc9NaYzsUbVVaaObEe4xhIA0trij
         nxtjiaqXVXifry93WtBD531F5IUSPte/YuHFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704834189; x=1705438989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Xp+jSWNyDVNPrZ4o9pnDkGaguZvDQ9fIqaku88C5tc=;
        b=JhfI4ugzSue6i5n8aDfz0WqQhIXUWgmJ5jgcoFBGxEXSsBy8Sjl4biq9lQ4W/rb1Dd
         14XTuaBkKHDe6o9mgLd93M8K885DeSC/5kD8KPafZLjB1YxYwFkB030o29GePuxj2t3F
         0i933KerSdo580ORsTjxFVw+xtjhDz+L9RApwgE0LBOGm8wSJE4aXhbRu6r3alVHyBpd
         eBiiOK7N7ChDbMe80V/tLm+/4+OfjbyuGl42/XFTFBGyHLDyPCGEw/odV3Pqyupnf+r3
         n1JtkoIK0Z6xkGr6qHi9QoIest55Xvo2VOcksBV2DX+i/TrazCRtIB1c9AhrjTaEt3vv
         XSlQ==
X-Gm-Message-State: AOJu0Yw3+5zx6sc61PKkGXCaKgTOYOKz97ERi3XeuntLsuALCcLN9IBj
	oHYY88jc59eW9GUBfzo/ouuER1g30rkPpchWlCrPI5NBkQ==
X-Google-Smtp-Source: AGHT+IEQQqPZTxFEKutfL8JwrvhSO22cj85Kple3x5sdC/vEcQKFuMEYftDmACTY1pTf+xrzFl9z9Q==
X-Received: by 2002:a05:6e02:18c7:b0:360:83b5:aea3 with SMTP id s7-20020a056e0218c700b0036083b5aea3mr1291986ilu.15.1704834189204;
        Tue, 09 Jan 2024 13:03:09 -0800 (PST)
Received: from localhost (110.41.72.34.bc.googleusercontent.com. [34.72.41.110])
        by smtp.gmail.com with UTF8SMTPSA id z13-20020a92d6cd000000b0036003f7ce61sm805891ilp.87.2024.01.09.13.03.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jan 2024 13:03:08 -0800 (PST)
Date: Tue, 9 Jan 2024 21:03:08 +0000
From: Matthias Kaehlcke <mka@chromium.org>
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, Brian Geffon <bgeffon@google.com>
Subject: Re: [PATCH v5 01/40] dm: add documentation for dm-vdo target
Message-ID: <ZZ20jAw0E-bOCuSA@google.com>
References: <cover.1700250814.git.msakai@redhat.com>
 <b89e2912cb24b311b4196bb5cc92f10efc396886.1700250814.git.msakai@redhat.com>
 <ZY3JiwgHnbbL1vGF@google.com>
 <8207e4fb-0ef0-50e8-5954-363a3723ffa6@redhat.com>
 <ZZwaPjBECFvs8F4i@google.com>
 <151f92c6-9bc9-d3b5-9123-1ba39beeec73@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <151f92c6-9bc9-d3b5-9123-1ba39beeec73@redhat.com>

On Mon, Jan 08, 2024 at 10:17:49PM -0500, Matthew Sakai wrote:
> 
> 
> On 1/8/24 10:52, Matthias Kaehlcke wrote:
> > Hi Matthew,
> > 
> > Thanks for your reply!
> > 
> > On Thu, Jan 04, 2024 at 09:07:07PM -0500, Matthew Sakai wrote:
> > > 
> > > 
> > > On 12/28/23 14:16, Matthias Kaehlcke wrote:
> > > > Hi,
> > > > 
> > > > On Fri, Nov 17, 2023 at 03:59:18PM -0500, Matthew Sakai wrote:
> > > > > This adds the admin-guide documentation for dm-vdo.
> > > > > 
> > > > > vdo.rst is the guide to using dm-vdo. vdo-design is an overview of the
> > > > > design of dm-vdo.
> > > > > 
> > > > > Co-developed-by: J. corwin Coburn <corwin@hurlbutnet.net>
> > > > > Signed-off-by: J. corwin Coburn <corwin@hurlbutnet.net>
> > > > > Signed-off-by: Matthew Sakai <msakai@redhat.com>
> > > > > ---
> > > > >    .../admin-guide/device-mapper/vdo-design.rst  | 415 ++++++++++++++++++
> > > > >    .../admin-guide/device-mapper/vdo.rst         | 388 ++++++++++++++++
> > > > >    2 files changed, 803 insertions(+)
> > > > >    create mode 100644 Documentation/admin-guide/device-mapper/vdo-design.rst
> > > > >    create mode 100644 Documentation/admin-guide/device-mapper/vdo.rst
> > > > > 
> > > > > diff --git a/Documentation/admin-guide/device-mapper/vdo-design.rst b/Documentation/admin-guide/device-mapper/vdo-design.rst
> > > > > new file mode 100644
> > > > > index 000000000000..c82d51071c7d
> > > > > --- /dev/null
> > > > > +++ b/Documentation/admin-guide/device-mapper/vdo-design.rst
> > > > > @@ -0,0 +1,415 @@
> > > > > +.. SPDX-License-Identifier: GPL-2.0-only
> > > > > +
> > > > > +================
> > > > > +Design of dm-vdo
> > > > > +================
> > > > > +
> > > > > +The dm-vdo (virtual data optimizer) target provides inline deduplication,
> > > > > +compression, zero-block elimination, and thin provisioning. A dm-vdo target
> > > > > +can be backed by up to 256TB of storage, and can present a logical size of
> > > > > +up to 4PB.
> > > 
> > > [snip]
> > > 
> > > > > +	block map cache size:
> > > > > +		The size of the block map cache, as a number of 4096-byte
> > > > > +		blocks. The minimum and recommended value is 32768 blocks.
> > > > > +		If the logical thread count is non-zero, the cache size
> > > > > +		must be at least 4096 blocks per logical thread.
> > > > 
> > > > If I understand correctly the minimum of 32768 blocks results in the 128 MB
> > > > metadata cache mentioned in 'Tuning', which allows to access up to 100 GB
> > > > of logical space.
> > > > 
> > > > Is there a strict reason for this minimum? I'm evaluating to use vdo on
> > > > systems with a relatively small vdo volume (say 4GB) and 'only' 4-8 GB of
> > > > RAM. The 128 MB of metadata cache would be a sizeable chunk of that, which
> > > > could make the use of vdo infeasible.
> > > 
> > > The short answer is that VDO can often use a smaller cache than the default,
> > > but it likely won't help in the way you want it to.
> > > 
> > > > > +Examples:
> > > > > +
> > > > > +Start a previously-formatted vdo volume with 1 GB logical space and 1 GB
> > > > > +physical space, storing to /dev/dm-1 which has more than 1 GB of space.
> > > > > +
> > > > > +::
> > > > > +
> > > > > +	dmsetup create vdo0 --table \
> > > > > +	"0 2097152 vdo V4 /dev/dm-1 262144 4096 32768 16380"
> > > > 
> > > > IIUC the backing device needs to be previously formatted. The formatting
> > > > fails when the size of the backing device is < 5GB:
> > > > 
> > > > vdoformat /dev/loop8
> > > >     Minimum required size for VDO volume: 5063921664 bytes
> > > >     vdoformat: formatVDO failed on '/dev/loop8': VDO Status: Out of space
> > > > 
> > > > That was with 'vdoformat' from https://github.com/dm-vdo/vdo/
> > > > 
> > > > It would be great if somewhat smaller devices could be supported.
> > > 
> > > VDO was designed to handle the challenge of data deduplication in very large
> > > storage pools. It generally is not very useful for very small pools. The
> > > first question to ask is whether VDO can actually provide any value in the
> > > sort of environment you're using. VDO generally takes the strategy of saving
> > > storage space by using extra RAM and CPU cycles. In addition, VDO needs to
> > > track a certain amount of metadata, which reduces the amount storage
> > > available for actual user data.
> > > 
> > > For vdoformat, the biggest consideration is the deduplication index and
> > > other metadata, which are basically a fixed cost of about 3.5GB. In order
> > > for VDO to be useful, VDO would have to find enough deduplication to make up
> > > for the storage lost to VDO's metadata, so the minimum useful size of a VDO
> > > volume is in the 8-12GB range.
> > > 
> > > For the block map cache, decreasing the cache size may increase the
> > > frequency of metadata writes, which generally decreases the write throughput
> > > of the VDO device. So the tradeoff is between RAM and write speed.
> > > 
> > > Nothing about the generic structure of VDO would prevent us from producing a
> > > smaller VDO (and in fact we do for some testing purposes), but in a scenario
> > > where you can only expect to save a few gigabytes through deduplication, VDO
> > > is generally more expensive than it is worth.
> > > 
> > > If you still think this might be worth pursuing, let me know and we can try
> > > to work out a configuration which might suit your goals.
> > 
> > Some more context about my use case:
> > 
> > I'm evaluating the use of VDO for storing a hibernate image, the goal is to
> > reduce hibernate resume time by loading less data from potentially slow
> > storage. That's why the volume is relatively small. The image is only
> > written once per hibernate cycle and generally after the system was idle
> > for a longer time, so the lower write throughput due to a smaller cache
> > size probably wouldn't be a major concern. The systems might not have huge
> > amounts of free disk space, an overhead of ~3.5GB for the deduplication
> > index would probably rule out the use of VDO.
> > 
> > In the context of this use case the compression part of VDO seems more
> > interesting than the deduplication. In the documentation of VDO I noticed
> > a parameter to disable deduplication. With that I wonder if it would be
> > feasible/reasonable to add an option to vdoformat to omit the deduplication
> > index.
> > 
> > Do you think VDO might be (made) suitable for this scenario or is it
> > just not the right tool?
> > 
> > Thanks
> > 
> > Matthias
> 
> The primary reason for VDO is the deduplication capability.  You can disable
> deduplication on a VDO target, but you would still be paying the overhead
> costs of being able to enable it. Certainly I think VDO itself is not the
> right tool here.

Ok, that's good to know, thanks.

> We have considered making a compression-only target, but realistically it
> would be a completely separate dm target and not a version of VDO. A
> compression-only target could remove all the complication of the
> deduplication aspects of VDO, and it could potentially even get better
> compression by removing some of the constraints imposed by supporting
> deduplication. Conceptually it's not too hard, I think, but we haven't
> really done any work developing it so it wouldn't come into being any time
> soon. If you thought it would be helpful then we can consider prioritizing
> that work.

Thanks for the offer to priorize a compression-only target, that migh be
very useful! A decision about whether hibernate is a priority for Chrome OS
in 2024 is still pending, there should be more clarity within a few weeks.
Before that it's probably best not to ask others to do any significant
development work related with that topic :)

> For the specific use case you described, it sounds like you've got a pretty
> good idea of what you need to write already. Have you considered trying to
> compress that image before writing it, just using file-level compression or
> something similar?

Unfortunately that is not a (straightforward) option. We use uswsusp, but
for the sake of security the kernel writes the image directly to a raw
storage device (a dm-crypt target), so any compression would have to happen
in the kernel.

> I wonder if being able to load less data from storage is actually a win
> once you account for the extra computation you would need to decompress
> the image.

That's a good point, might be worth some prototyping.

m.
