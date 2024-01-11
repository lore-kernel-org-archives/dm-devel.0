Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45756524A4
	for <dm-devel@lists.linux.dev>; Thu, 11 Jan 2024 17:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-78338e90470so56216485a.0
        for <dm-devel@lists.linux.dev>; Thu, 11 Jan 2024 09:07:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704992878; x=1705597678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=guvMy5on3EDR89/D3VOhm8VEzO50WLZGZFkTLRN1vR0=;
        b=QbzAR7vrX3De/Lf+YswZYdSNVpIM8FdYptjuWl7jEfl5OcCjs82wx9mPk7ci0Fso2h
         ZTWYWjnbxB5zNBLKo6U0Jb9ZqRGOQScCvus6IvFA8sVUN3cyp59tzBSkUMd0ztCBwDXP
         OV8p+ULtJ8xEd9g/37d9IUy2L4WJsDtX7r65DFq7SX109w9zLENperLWeCrtaF02JoSe
         XmlEOGUH7cWUwP4XtbxUlnfdCrtD1rWXgbmBwBp440NV/AcLM/4DbqR1ZiNszwW5XSD6
         9hKfmINvsgDgummJi6guqmLoC3Ur+FJukTYbBtYyJQf8rLWn3O2oQfLX+r69OHSLX/x+
         xXow==
X-Gm-Message-State: AOJu0YxEzYP5q13XaAtFmAm2jM2ArCvG5jSMofK3Tg7+rwDHdvjQ9NLp
	sZMmCFjyKazDg+SjALjwY0XBvmcT5kGk
X-Google-Smtp-Source: AGHT+IFy7KWn7OYnpKc4xsjFWd5HOeE/9wvJj6iqmHRlz3hOcuXWmmWVKBPUuO8n2brsspLPp9VzuQ==
X-Received: by 2002:ad4:5be5:0:b0:681:36e7:ee94 with SMTP id k5-20020ad45be5000000b0068136e7ee94mr1072238qvc.102.1704992878011;
        Thu, 11 Jan 2024 09:07:58 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id ei19-20020ad45a13000000b006805bd3058asm425295qvb.75.2024.01.11.09.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 09:07:57 -0800 (PST)
Date: Thu, 11 Jan 2024 12:07:56 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Re: [PATCHSET 0/3] Integrity cleanups and optimization
Message-ID: <ZaAgbBCkLX5Ueq4l@redhat.com>
References: <20240111160226.1936351-1-axboe@kernel.dk>
 <ZaASdg+NkFFy8Khx@infradead.org>
 <yq1o7dr6e09.fsf@ca-mkp.ca.oracle.com>
 <ZaAYgJ+xK6c5p1/L@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZaAYgJ+xK6c5p1/L@redhat.com>

On Thu, Jan 11 2024 at 11:34P -0500,
Mike Snitzer <snitzer@kernel.org> wrote:

> On Thu, Jan 11 2024 at 11:24P -0500,
> Martin K. Petersen <martin.petersen@oracle.com> wrote:
> 
> > 
> > > Bw, can someone help with what dm_integrity_profile is for?
> > > It is basically identical to the no-op one, just with a different
> > > name.  With the no-op removal it is the only one outside of the pi
> > > once, and killing it would really help with some de-virtualization
> > > I've looked at a while ago.
> > 
> > No particular objections from me wrt. using a flag.
> > 
> > However, I believe the no-op profile and associated plumbing was a
> > requirement for DM. I forget the details. Mike?
> 
> I'll have to take a closer look.. stacking device always complicates
> things.

The bulk of the following drivers/md/dm-table.c code snippets are from
these 2 commits (first from me, 2nd from Martin):

a63a5cf84dac dm: improve block integrity support
25520d55cdb6 block: Inline blk_integrity in struct gendisk

static bool integrity_profile_exists(struct gendisk *disk)
{
        return !!blk_get_integrity(disk);
}

/*
 * Get a disk whose integrity profile reflects the table's profile.
 * Returns NULL if integrity support was inconsistent or unavailable.
 */
static struct gendisk *dm_table_get_integrity_disk(struct dm_table *t)
{
        struct list_head *devices = dm_table_get_devices(t);
        struct dm_dev_internal *dd = NULL;
        struct gendisk *prev_disk = NULL, *template_disk = NULL;

        for (unsigned int i = 0; i < t->num_targets; i++) {
                struct dm_target *ti = dm_table_get_target(t, i);

                if (!dm_target_passes_integrity(ti->type))
                        goto no_integrity;
        }

        list_for_each_entry(dd, devices, list) {
                template_disk = dd->dm_dev->bdev->bd_disk;
                if (!integrity_profile_exists(template_disk))
                        goto no_integrity;
                else if (prev_disk &&
                         blk_integrity_compare(prev_disk, template_disk) < 0)
                        goto no_integrity;
                prev_disk = template_disk;
        }

        return template_disk;

no_integrity:
        if (prev_disk)
                DMWARN("%s: integrity not set: %s and %s profile mismatch",
                       dm_device_name(t->md),
	               prev_disk->disk_name,
                       template_disk->disk_name);
        return NULL;
}

/*
 * Register the mapped device for blk_integrity support if the
 * underlying devices have an integrity profile.  But all devices may
 * not have matching profiles (checking all devices isn't reliable
 * during table load because this table may use other DM device(s) which
 * must be resumed before they will have an initialized integity
 * profile).  Consequently, stacked DM devices force a 2 stage integrity
 * profile validation: First pass during table load, final pass during
 * resume.
 */
static int dm_table_register_integrity(struct dm_table *t)
{
	struct mapped_device *md = t->md;
	struct gendisk *template_disk = NULL;

	/* If target handles integrity itself do not register it here. */
	if (t->integrity_added)
		return 0;

	template_disk = dm_table_get_integrity_disk(t);
	if (!template_disk)
		return 0;

	if (!integrity_profile_exists(dm_disk(md))) {
		t->integrity_supported = true;
		/*
		 * Register integrity profile during table load; we can do
		 * this because the final profile must match during resume.
		 */
		blk_integrity_register(dm_disk(md),
				       blk_get_integrity(template_disk));
		return 0;
	}

	/*
	 * If DM device already has an initialized integrity
	 * profile the new profile should not conflict.
	 */
	if (blk_integrity_compare(dm_disk(md), template_disk) < 0) {
		DMERR("%s: conflict with existing integrity profile: %s profile mismatch",
		      dm_device_name(t->md),
		      template_disk->disk_name);
		return 1;
	}

	/* Preserve existing integrity profile */
	t->integrity_supported = true;
	return 0;
}

/*
 * Verify that all devices have an integrity profile that matches the
 * DM device's registered integrity profile.  If the profiles don't
 * match then unregister the DM device's integrity profile.
 */
static void dm_table_verify_integrity(struct dm_table *t)
{
	struct gendisk *template_disk = NULL;

	if (t->integrity_added)
		return;

	if (t->integrity_supported) {
		/*
		 * Verify that the original integrity profile
		 * matches all the devices in this table.
		 */
		template_disk = dm_table_get_integrity_disk(t);
		if (template_disk &&
		    blk_integrity_compare(dm_disk(t->md), template_disk) >= 0)
			return;
	}

	if (integrity_profile_exists(dm_disk(t->md))) {
		DMWARN("%s: unable to establish an integrity profile",
		       dm_device_name(t->md));
		blk_integrity_unregister(dm_disk(t->md));
	}
}


> But the dummy functions that got wired up with this commit are suspect:
> 54d4e6ab91eb block: centralize PI remapping logic to the block layer
> 
> Effectively the entirety of the dm_integrity_profile is "we don't do
> anything special".. so yes it would be nice to not require indirect
> calls to accomplish what dm-integrity needs from block core.

All said, if blk_get_integrity() can be made to handle the removal of
the nop profile then all should "just work" right?  Here is how it has
been:

static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
{
        struct blk_integrity *bi = &disk->queue->integrity;

        if (!bi->profile)
                return NULL;

        return bi;
}

Not looked closely at Jens' patchset (but will do), however it seems
Jens missed updating blk_get_integrity() to deal with his new
QUEUE_FLAG_INTG_PROFILE flag?

As for complete removal of integrity profiles entirely, DM needs a way
to analyze integrity configurations to try to stack up a sane end
result.

Mike
