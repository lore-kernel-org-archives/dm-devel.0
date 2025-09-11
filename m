Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2DB329F05
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 17:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757610789; cv=pass; b=YrhIezH56ga2jo1H+3NqncXJrbppNYhhAPkJVYWB2vsACgQSpCJy3MAMldxO8PXDH2MxgiHyWBiwQCgBrTsa4pMV4jd5BWHhrcsom13HfpssnE+D+TNX/QX8nYPVpm8yJC2vvLX1uH9fUJK8jmC3uOg5eCreSeEGRlna/SZOs60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757610789; c=relaxed/simple;
	bh=gvYG/ftsEkt1ukbLIv9crYcPv9Gyvwap3kPiHfuwFZM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=uX+lqyB3x0kgtXoR+W5T6wRYjqiZOP171U85Tnuv/w2ytKRt0TeDnrJpPYMBQKHUu5G+gJ1tpNZno/DFEc9kl8bQk+OQaxuqFRs2MZHqNVN3paaB6l1DES5jnEkSkJ6lmco9Ar+OxyjcNO5hunjvgaUVCIGznE/+6mwN7BCx/lQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=bob.beckett@collabora.com header.b=UBqOPiXx; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=bob.beckett@collabora.com header.b="UBqOPiXx"
ARC-Seal: i=1; a=rsa-sha256; t=1757610775; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=Pb5VwZaDoLpNWSOJkfKtVZiif1KZcKdJbyGSxzeYGgmouiedl3He5mMlMCjn2v1UA5G5LqUZeRCgJCkzbllDJFI+DEelAUnewl+v1z9MuNsa7auCGx0nR4x6PcW1/cvKNpRL7xQ509rFX63/8oihG/KlOfGgJbVWmEDGH7HILFI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1757610775; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9wywiY2GlNrnJWWCyhgQ/MZchSDbGB0hTUB1dttlRB4=; 
	b=Xs8lBWw10O7gkE0Qhqgo+1ob60lnG22m2YS5t34/RGVlsLeBOsg3L4psTS9JMJBdWN1P2GN5cVM/tbYm24YscO0ogV+3Y13Z5J11/T+8+1iT/IGlmoQgOmkMWnR3+zy/O5sEUogS1DV31jBhjS9R/6h0q1jSUWb3ueNeB8R6HV4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=bob.beckett@collabora.com;
	dmarc=pass header.from=<bob.beckett@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1757610775;
	s=zohomail; d=collabora.com; i=bob.beckett@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=9wywiY2GlNrnJWWCyhgQ/MZchSDbGB0hTUB1dttlRB4=;
	b=UBqOPiXxhuOUMF9i0WpCXFK3Wf2LggW5VwaDahusajwLUN7k8lyxN+RBoKv8clw9
	3ze8tkG2072AY37mMArzKyEjl4nayr2bzwEuh/COdhAbtaEhdaC8CKh5cXC+FN5w2cg
	nx3hhoqpIr9WKkS5tw2+B3BiJlnRa2bhuii3Pvak=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1757610743040950.0726086101374; Thu, 11 Sep 2025 10:12:23 -0700 (PDT)
Date: Thu, 11 Sep 2025 18:12:22 +0100
From: Robert Beckett <bob.beckett@collabora.com>
To: "Mikulas Patocka" <mpatocka@redhat.com>
Cc: "dm-devel" <dm-devel@lists.linux.dev>,
	"linux-block" <linux-block@vger.kernel.org>,
	"kernel" <kernel@collabora.com>
Message-ID: <19939c394c6.2d36e917643588.7927929178438809583@collabora.com>
In-Reply-To: <60e5d1ec-3c9d-c6d2-e2c0-9e718e9a0ad0@redhat.com>
References: <1992a9545eb.1ec14bf0659281.6434647558731823661@collabora.com> <2d517844-b7bf-3930-e811-e073ec347d4a@redhat.com> <1992f628105.2bf0303b1373545.4844645742991812595@collabora.com> <a7872ca2-be14-0720-190c-c03d4ddf7a5d@redhat.com>
 <199343ab2a7.11b1e13e161813.4990067961195858029@collabora.com> <60e5d1ec-3c9d-c6d2-e2c0-9e718e9a0ad0@redhat.com>
Subject: Re: deadlock when swapping to encrypted swapfile
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail






 ---- On Thu, 11 Sep 2025 17:56:01 +0100  Mikulas Patocka <mpatocka@redhat.com> wrote --- 
 > 
 > 
 > On Wed, 10 Sep 2025, Robert Beckett wrote:
 > 
 > >  > > Yeah, unfortunately we are currently restricted to using a swapfile due to many units already shipped with that.
 > >  > > We have longer term plans to dynamically allocate the swapfiles as neded based on a new query for estimated size
 > >  > > required for hibernation etc. Moving to swap partition is just not viable currently.
 > >  > 
 > >  > You can try the dm-loop target that I created some times ago. It won't be 
 > >  > in the official kernel because the Linux developers don't like the idea of 
 > >  > creating fixed mapping for a file, but it may work better for you. Unlike 
 > >  > the in-kernel loop driver, the dm-loop driver doesn't allocate memory when 
 > >  > processing reads and write.
 > > 
 > > oh interesting. I hadn't seen that.
 > > I was discussing a quick idea of potentially adding a new fallocate mode bit to request contiguous non-moveable
 > > block assignment as it pre-allocates, which filesystems could then implement support for.
 > 
 > You can ask the VFS maintainers about this, but I think they'll reject it.
 > 
 > > Then use the known
 > > file range with dm-crypt directly instead of going via the block device.
 > > I guess this is roughly analaguous to that idea.
 > > 
 > > I see that dm-loop is very old at this point. Do you know the rationale for rejection?
 > 
 > The reason was that the filesystem developers think that the filesystems 
 > should have freedom to move the allocated blocks around.
 > 
 > The dm-loop patch sets the flag S_SWAPFILE to prevent that from happening, 
 > but they don't want more code to use this flag.
 > 
 > > was there any hope to get it included with more work?
 > 
 > No - because they don't like the idea of creating a map of file blocks in 
 > advance.
 > 
 > One could rework the dm-loop patch to use standard filesystem methods read 
 > and write, but then it would allocate memory when processing requests and 
 > it would be unsuitable for swapping.
 > 
 > > If the main objection was regarding file spans that they can't gurantee persist, maybe a new fallocate based
 > > contrace with the filesystems could aleviate the worries? 
 > > 
 > > 
 > >  > 
 > >  > Create a swap file on the filesystem, load the dm-loop target on the top 
 > >  > of that file and then create dm-crypt on the top of the dm-loop target. 
 > >  > Then, run mkswap and swapon on the dm-crypt device.
 > >  > 
 > >  > > I tried halving /sys/module/dm_mod/parameters/swap_bios but it didn't help, which based on your more recent
 > >  > > reply is not unexpected.
 > >  > > 
 > >  > > I have a work around for now, which is to run a userland earlyoom daemon. That seems to get in and oomkill in time.
 > >  > > I guess another option would be to have the swapfile in a luks encrypted partition, but that equally is not viable for
 > >  > > steamdeck currently.
 > >  > > 
 > >  > > However, I'm still interested in the longer term solution of fixing the kernel so that it can handle scenarios
 > >  > > like this no matter how ill advised they may be. Telling users not to do something seems like a bad solution :)
 > >  > 
 > >  > You would have to rewrite the filesystems not to allocate memory when 
 > >  > processing reads and writes. I think that this is not feasible.
 > >  > 
 > >  > > Do you have any ideas about the unreliable kernel oomkiller stepping in? I definitely fill ram and swap, seems like
 > >  > > it should be firing.
 > >  > 
 > >  > I think that the main problem with the OOM killer is that it sometimes 
 > >  > doesn't fire for big applications.
 > > 
 > > perhaps oom_kill_allocating_task helps in that scenario?
 > > in this lockup scenario I don't see oomkiller starting at all. It looks like it soft
 > > locks and never feels the need to step in.
 > > Perhaps because it sees some (tiny) amount of forward progress with
 > > some swapout requests completing?
 > 
 > If you are swapping to an encrypted file, it may deadlock even before you 
 > exhaust the memory and swap.
 > 
 > >  > I think that using userspace OOM killer is appropriate to prevent this 
 > >  > problem with the kernel OOM killer. 
 > > 
 > > Turns out I spoke too soon on the userland earloom daemon being a solution.
 > > It worked for some patterns, but not others.
 > > It mostly worked well when swap was either pre-filled with data greater than it's
 > > threshold so as soon as ram is exhausted it stepped in, or when the allocations are
 > > sufficiently spaced for it to fill greater than it's threshold without many more
 > > outstanding swapouts before it gets to evaluate again.
 > > 
 > > For now the only really reliable way to work around is to disable memory
 > > overcommit, but we really don't want to go looking down that route as it 
 > > will have all sorts of other impacts.
 > 
 > You can allocate a file, use e4defrag to reduce the number of fragments, 
 > then use the FS_IOC_FIEMAP ioctl to find out the location of the file and 
 > then use the dm-linear target to map the file - and place encryption and 
 > swapping on the top of that.
 > 
 > If you have control over the whole device and make sure that no one moves 
 > the file, it should work.
 > 
 > Note that you can't use device mapper on a block device that has 
 > filesystem mounted, so you'll have to add one dm-linear device underneath 
 > the filesystem.

Yeah, I already looked in to that and discounted it.
We want to support dynamic swapfile sizing, which means files, not statically reserved regions of disk.
Besides, if static regions were suitable for our design, we could just use partitions instead.

At this point, we accept that any sort of mapping over the top of dependable extents is just not
going to happen. And Based on the discussions from your previous attempt
 https://lore.kernel.org/dm-devel/7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com/
I can definitely agree with the fs folks why it makes sense to avoid that approach.

I think instead we'll go looking at ancyrpting swap data during swap out.
zswap exists as a permutation of data during swap in/out. I suspect we could do
something with encryption in a similar manner (to be investigated).

Thanks for the discussion, was interesting diving in to it.

 > 
 > Mikulas
 > 
 > 

