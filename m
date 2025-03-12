Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062EA1F0E38
	for <dm-devel@lists.linux.dev>; Wed, 12 Mar 2025 23:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741822224; cv=none; b=DHwJXIqgBU2x0Nf9sUGQl+ivx0saCW9gCt+AwiIqPRU7BiPyCskqKFolAjXBHWzV0qlIgeB/lUMjHFOG2JmzPgx0fTCrqkYzEdldqqPJ+w5OyeIh1h3ybvwSBvV+YriLUJqHbvfIpgQgNt3gvlE5ulqq3MCagC6MPe1H7BmOH2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741822224; c=relaxed/simple;
	bh=k/m+gVoc2ADaoJjl+P8X/qVfXk1rOWt2XlgQF0qL+v0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HUm3ZFYYCKHZWVqGFkHImPaghl7Km6E+c/n0t13zSTEtHU/ajHL5L0TEmt8XCelrTjK2Dp4nAc0+hK1LFgDGYYISxySdZ8hCRaddRZ4azUPhU8qr96RZgKQV9ymI4cTqlj/5VT6ngqWU9HPE56hMvjxvtn4ARqgMLw+z+m6Y0I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mfe@pengutronix.de>)
	id 1tsVWd-0000xA-5Y; Thu, 13 Mar 2025 00:30:11 +0100
Received: from pty.whiteo.stw.pengutronix.de ([2a0a:edc0:2:b01:1d::c5])
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <mfe@pengutronix.de>)
	id 1tsVWc-005RDy-1f;
	Thu, 13 Mar 2025 00:30:10 +0100
Received: from mfe by pty.whiteo.stw.pengutronix.de with local (Exim 4.96)
	(envelope-from <mfe@pengutronix.de>)
	id 1tsVWc-009eaZ-1F;
	Thu, 13 Mar 2025 00:30:10 +0100
Date: Thu, 13 Mar 2025 00:30:10 +0100
From: Marco Felsch <m.felsch@pengutronix.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: gmazyland@gmail.com, okozina@redhat.com, ebiggers@google.com,
	hare@suse.de, agk@redhat.com, snitzer@kernel.org,
	dm-devel@lists.linux.dev, Lucas Stach <lst@pengutronix.de>
Subject: Re: DM-Integrity journal replay behaviour
Message-ID: <20250312233010.d2byfqtcng3znesx@pengutronix.de>
References: <20250211121138.kokiyvgh6ba3yujl@pengutronix.de>
 <175fa15e-8bb9-d03b-9128-2b9eec61a32d@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175fa15e-8bb9-d03b-9128-2b9eec61a32d@redhat.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: dm-devel@lists.linux.dev

Hi,

sorry for the late reply but we had to run several tests and analyze
multiple test outputs offline via a small self-written tool.

On 25-02-14, Mikulas Patocka wrote:
> Hi
> 
> On Tue, 11 Feb 2025, Marco Felsch wrote:
> 
> > Hi all,
> > 
> > as written in the subject we do see an odd dm-integrity behaviour during
> > the journal replay step.
> > 
> > First things first, a short introduction to our setup:
> >  - Linux v6.8
> >  - We do have a dm-integrity+dm-crypt setup to provide an authenticated
> >    encrypted ext4-based rw data partition.
> >  - The setup is done with a custom script [1] since we are making use of
> >    the kernel trusted-keys infrastructure which isn't supported by LUKS2
> >    at the moment.
> >  - The device has no power failsafe e.g. hard power-cuts can appear.
> >    Therefore we use the dm-integrity J(ournal) mode.
> >  - The storage backend is an eMMC with 512Byte block size.
> 
> Could you retest it with an eMMC or SDCARD from a different vendor, just 
> to test if it is hardware issue?

We saw the issue on different eMMC devices from different manufacturers.

> >  - We use the dm-integrity 4K block size option to reduce the
> >    tag/metadata overhead.
> > 
> > From time to time we do see "AEAD ERROR"s [2] while fsck tries to repair
> > the filesystem which of course abort the fsck run.
> > After a while within the rescue shell
> 
> So, when you run fsck again from the rescue shell (without deactivating 
> and activating the device), the bug goes away? What is the time interval 
> after which the bug goes away?

This happened from time to time, yes but only in rare cases and I'm not
sure if our tester did something wrong.

> Could you upload somewhere the image of the eMMC storage when the bug 
> happens and send me a link to it, so that I can look what kind of 
> corruption is there?

Of course I need to align it with our customer but since the data is
encrypted you could get the dm-integrity dump.

> > and a following reboot the fsck
> > run on the same file system doesn't trigger any "AEAD ERROR".
> > 
> > The dm-integrity table is added twice [1] since we gather the
> > provided_data_sectors information from the first call. I know that this
> > isn't optimal. The provided_data_sectors should be stored and not
> > gathered again but this shouldn't bother a system with a valid
> > dm-integrity superblock already written.
> 
> That should work fine - there is no problem with activating the device 
> twice.

Also with activating it with differnet sizes as we do? I think there is
no problem with it too. Our script doesn't different between the initial
setup (no superblock available) and the "normal" setup.

> > To debug the issue we uncommented the "#define DEBUG_PRINT" and noticed
> > that the replay is happening twice [2] albeit this should be a
> > synchronous operation and once the dm resume returned successfully the
> > replay should be done.
> 
> The replay happens twice because you activate it twice - this should be 
> harmless because each replay replays the same data - there is "replaying 
> 364 sections, starting at 143, commit seq 2" twice in the log.

Yes, but after replaying it the first time we thought the code marks the
entries as unused and don't have to replay these entries a 2nd time. But
as I said, there should be no issue with it.

> > We also noticed that once we uncommented "#define DEBUG_PRINT" it was
> > harder to trigger the issue.
> > 
> > We also checked the eMMC bus to see if the CMD23 is sent correctly (with
> > the reliable write bit set) in case of a FUA request which is the case.
> > So now with the above knowledge we suspect the replay path to be not
> > synchronous, the dm resume is returning too early, while not all of the
> > writes kicked off by copy_from_journal having reached the storage.
> 
> There is "struct journal_completion comp" in do_journal_write and 
> "wait_for_completion_io(&comp.comp);" at the end of do_journal_write - 
> that should wait until all I/O submitted by copy_from_journal finishes.
>
> > Maybe you guys have some pointers we could follow or have an idea of
> > what may go wrong here.
> > 
> > Regards,
> >   Marco
> 
> I read through the dm-integrity source code and I didn't find anything.
> 
> There are two dm-crypt bugs that could cause your problems - see the 
> upstream commits 8b8f8037765757861f899ed3a2bfb34525b5c065 and 
> 9fdbbdbbc92b1474a87b89f8b964892a63734492. Please, backport these commits 
> to your kernel and re-run the tests.

This helped, there are also other dm-crypt fixes which looked closely
related. Therefore we updated to 6.12.16 and ran the tests. Tests which
could reproduce the issue quite sufficient are now passing and it really
looks like dm-crypt was the issue :/

The issue could be reproduced by the following script which was started
right after the boot:

| #!/bin/bash
| 
| set -x
| 
| suffix=$(hexdump /dev/urandom -n4 -e '"%u"')
| suffix=$((suffix%220))
| testdir=/mnt/data/test
| testfile=$testdir/test.$suffix
| 
| # Make testdir
| mkdir -p $testdir
| 
| [ -f $testfile ] && rm $testfile
| 
| dd if=/dev/mapper/data of=/dev/null && \
|  dd if=/dev/urandom of=$testfile bs=1M oflag=sync count=1 && \
|  dd if=/dev/mapper/data of=/dev/null && \
|  reboot -f
| 
| echo "Something failed, please check!"

Our data partition was quite small (300MB) which lead the journal-size
to hold up to ~2MB. Since we use the ext4 on top of it we used a size of
1MB. If reading the whole device before or after the script stops and we
dumped the raw eMMC partition (mmcblkXpY).

Afterwards we analyzed the dump by our small tool to see if we can found
the AEAD sector within the journal, which was the case.

Now we checked if this particular sector (8 sectors since we provide 4K
IO-size to the upper layers) can be found on the data area. Which was
the case.

Lastly we checked if we can find the entry metadata journal content
within the metadata area. Which was the case too.

Both the data and metadata belong to the same "area" so we do assume
that the journal was correctly replayed but got the wrong
<data><metadata> pair from the dm-crypt layer.

Please correct me if our conclusion is wrong, but after the kernel
update the issues are gone for now (we do need more test samples).

Thanks,
Marco
