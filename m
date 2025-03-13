Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C45513AA2F
	for <dm-devel@lists.linux.dev>; Thu, 13 Mar 2025 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741881255; cv=none; b=Kxd/Sr5U7qXC9ncNb1LikaqKZE2KEqgM5xL15Gy+FzB+f9l2GNNOhL3LCwCWeB5CcDV7fHiJR2r+ZgXaGgt5rVeXxIgNUWe92PaLqHLLb81YGOeGgZnIWdHB8oyt1hXfjyO35+eoeMV9BcNoIcecyMBcmC6Q5zGCXdlptvhoQOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741881255; c=relaxed/simple;
	bh=f/ByRbfc96AP51AJtnuosFPuzr/qBs3WHz2ib0nPJ3o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ekm6KBTYIipfAta/QcF+gl4iN1xttFwEWTcwzue0N2NJgIkYurOl0GUtVy7yfAr42OFKZrAKhU5hEsrKUQok/TuVCUyJVBPYnSB/SGdeQ6y4LUEdGe7jpLvGisgeTFmdMrqiE3m8/BI7d0Uxwy9hoRlTKcd4SwRCWdI4etCwMYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R2zbBiRL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R2zbBiRL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741881251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9DTyrBkKYMaCClJxsqBGvpgTTGlKxFYXzZ+5vQwFksA=;
	b=R2zbBiRLWI3oJNsnXzkHXeJhkttKg51cnzk9wj4B7r4ZmoZmpYdv9pygJ4SErC9HN4LBbn
	uqSiDVuTGS3MLgnMH8k01bPX0iWTJrHD7GIkzaEts4/7MpRMKSfIROYX4sFQUY1eKX1fGR
	lQEnelQQOWSLx9Z1qpv394RvCSNPPBA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-191-t_zxs-s_NaG0PBd7tleesA-1; Thu,
 13 Mar 2025 11:54:07 -0400
X-MC-Unique: t_zxs-s_NaG0PBd7tleesA-1
X-Mimecast-MFC-AGG-ID: t_zxs-s_NaG0PBd7tleesA_1741881246
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C9E019560BB;
	Thu, 13 Mar 2025 15:54:05 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E865E18001EF;
	Thu, 13 Mar 2025 15:54:02 +0000 (UTC)
Date: Thu, 13 Mar 2025 16:53:58 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Marco Felsch <m.felsch@pengutronix.de>
cc: gmazyland@gmail.com, okozina@redhat.com, ebiggers@google.com, hare@suse.de, 
    agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    Lucas Stach <lst@pengutronix.de>
Subject: Re: DM-Integrity journal replay behaviour
In-Reply-To: <20250312233010.d2byfqtcng3znesx@pengutronix.de>
Message-ID: <72c46128-84d7-ea51-ec60-d37a99fe2901@redhat.com>
References: <20250211121138.kokiyvgh6ba3yujl@pengutronix.de> <175fa15e-8bb9-d03b-9128-2b9eec61a32d@redhat.com> <20250312233010.d2byfqtcng3znesx@pengutronix.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9Fn8M7e-fTNfbR7UbT6HZqI22ohATyooBhbSCBWGc4w_1741881246
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 13 Mar 2025, Marco Felsch wrote:

> Hi,
> 
> sorry for the late reply but we had to run several tests and analyze
> multiple test outputs offline via a small self-written tool.
> 
> On 25-02-14, Mikulas Patocka wrote:
> > Hi
> > 
> > On Tue, 11 Feb 2025, Marco Felsch wrote:
> > 
> > > Hi all,
> > > 
> > > as written in the subject we do see an odd dm-integrity behaviour during
> > > the journal replay step.
> > > 
> > > First things first, a short introduction to our setup:
> > >  - Linux v6.8
> > >  - We do have a dm-integrity+dm-crypt setup to provide an authenticated
> > >    encrypted ext4-based rw data partition.
> > >  - The setup is done with a custom script [1] since we are making use of
> > >    the kernel trusted-keys infrastructure which isn't supported by LUKS2
> > >    at the moment.
> > >  - The device has no power failsafe e.g. hard power-cuts can appear.
> > >    Therefore we use the dm-integrity J(ournal) mode.
> > >  - The storage backend is an eMMC with 512Byte block size.
> > 
> > Could you retest it with an eMMC or SDCARD from a different vendor, just 
> > to test if it is hardware issue?
> 
> We saw the issue on different eMMC devices from different manufacturers.
> 
> > >  - We use the dm-integrity 4K block size option to reduce the
> > >    tag/metadata overhead.
> > > 
> > > From time to time we do see "AEAD ERROR"s [2] while fsck tries to repair
> > > the filesystem which of course abort the fsck run.
> > > After a while within the rescue shell
> > 
> > So, when you run fsck again from the rescue shell (without deactivating 
> > and activating the device), the bug goes away? What is the time interval 
> > after which the bug goes away?
> 
> This happened from time to time, yes but only in rare cases and I'm not
> sure if our tester did something wrong.
> 
> > Could you upload somewhere the image of the eMMC storage when the bug 
> > happens and send me a link to it, so that I can look what kind of 
> > corruption is there?
> 
> Of course I need to align it with our customer but since the data is
> encrypted you could get the dm-integrity dump.
> 
> > > and a following reboot the fsck
> > > run on the same file system doesn't trigger any "AEAD ERROR".
> > > 
> > > The dm-integrity table is added twice [1] since we gather the
> > > provided_data_sectors information from the first call. I know that this
> > > isn't optimal. The provided_data_sectors should be stored and not
> > > gathered again but this shouldn't bother a system with a valid
> > > dm-integrity superblock already written.
> > 
> > That should work fine - there is no problem with activating the device 
> > twice.
> 
> Also with activating it with differnet sizes as we do? I think there is
> no problem with it too. Our script doesn't different between the initial
> setup (no superblock available) and the "normal" setup.
> 
> > > To debug the issue we uncommented the "#define DEBUG_PRINT" and noticed
> > > that the replay is happening twice [2] albeit this should be a
> > > synchronous operation and once the dm resume returned successfully the
> > > replay should be done.
> > 
> > The replay happens twice because you activate it twice - this should be 
> > harmless because each replay replays the same data - there is "replaying 
> > 364 sections, starting at 143, commit seq 2" twice in the log.
> 
> Yes, but after replaying it the first time we thought the code marks the
> entries as unused and don't have to replay these entries a 2nd time. But
> as I said, there should be no issue with it.
> 
> > > We also noticed that once we uncommented "#define DEBUG_PRINT" it was
> > > harder to trigger the issue.
> > > 
> > > We also checked the eMMC bus to see if the CMD23 is sent correctly (with
> > > the reliable write bit set) in case of a FUA request which is the case.
> > > So now with the above knowledge we suspect the replay path to be not
> > > synchronous, the dm resume is returning too early, while not all of the
> > > writes kicked off by copy_from_journal having reached the storage.
> > 
> > There is "struct journal_completion comp" in do_journal_write and 
> > "wait_for_completion_io(&comp.comp);" at the end of do_journal_write - 
> > that should wait until all I/O submitted by copy_from_journal finishes.
> >
> > > Maybe you guys have some pointers we could follow or have an idea of
> > > what may go wrong here.
> > > 
> > > Regards,
> > >   Marco
> > 
> > I read through the dm-integrity source code and I didn't find anything.
> > 
> > There are two dm-crypt bugs that could cause your problems - see the 
> > upstream commits 8b8f8037765757861f899ed3a2bfb34525b5c065 and 
> > 9fdbbdbbc92b1474a87b89f8b964892a63734492. Please, backport these commits 
> > to your kernel and re-run the tests.
> 
> This helped, there are also other dm-crypt fixes which looked closely
> related. Therefore we updated to 6.12.16 and ran the tests. Tests which
> could reproduce the issue quite sufficient are now passing and it really
> looks like dm-crypt was the issue :/
> 
> The issue could be reproduced by the following script which was started
> right after the boot:
> 
> | #!/bin/bash
> | 
> | set -x
> | 
> | suffix=$(hexdump /dev/urandom -n4 -e '"%u"')
> | suffix=$((suffix%220))
> | testdir=/mnt/data/test
> | testfile=$testdir/test.$suffix
> | 
> | # Make testdir
> | mkdir -p $testdir
> | 
> | [ -f $testfile ] && rm $testfile
> | 
> | dd if=/dev/mapper/data of=/dev/null && \
> |  dd if=/dev/urandom of=$testfile bs=1M oflag=sync count=1 && \
> |  dd if=/dev/mapper/data of=/dev/null && \
> |  reboot -f
> | 
> | echo "Something failed, please check!"
> 
> Our data partition was quite small (300MB) which lead the journal-size
> to hold up to ~2MB. Since we use the ext4 on top of it we used a size of
> 1MB. If reading the whole device before or after the script stops and we
> dumped the raw eMMC partition (mmcblkXpY).
> 
> Afterwards we analyzed the dump by our small tool to see if we can found
> the AEAD sector within the journal, which was the case.
> 
> Now we checked if this particular sector (8 sectors since we provide 4K
> IO-size to the upper layers) can be found on the data area. Which was
> the case.
> 
> Lastly we checked if we can find the entry metadata journal content
> within the metadata area. Which was the case too.
> 
> Both the data and metadata belong to the same "area" so we do assume
> that the journal was correctly replayed but got the wrong
> <data><metadata> pair from the dm-crypt layer.
> 
> Please correct me if our conclusion is wrong, but after the kernel
> update the issues are gone for now (we do need more test samples).

It's nice to hear that the issue is fixed. Thanks for testing it.

> Thanks,
> Marco

Mikulas

