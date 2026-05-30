Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E8C2C026C
	for <dm-devel@lists.linux.dev>; Sat, 30 May 2026 13:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780149183; cv=none; b=pIyLEUAbmSGR9VDymaRWoGn9FMqNv5xOd9WGlvw/zAb2xIgokgFKc15564VBbqwU/nW1KZFxeKPbb+4r7oKO6EfUAsTWWc8HkkuajIEfhJyNSE2r6UEdvwAeGxDivX+QxvveBvG6VGpPTFLaZ4cY8dJLuUZPXOhFAnQFOfcWLrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780149183; c=relaxed/simple;
	bh=60khod8aLHZGNzzhzNtRmgYa19bB4orxD0gMVp1VrkA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KNlFMCe+elZyQymDOjEmRVBwgClgwktftoz1g0/po/IMebYB+I0M0m5akGmuQQA3lwv4/PfKjz7v4fHtA4nQKudDy0bDSvU/kULC1kAALpBSZJMqwFshFzhWvmfhXhBcyy+/EYO1X3YRYFTEaIi8mPg12Zb/expJmhr+0jTyEps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KoRn0cRh; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KoRn0cRh"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4905529b933so64174605e9.0
        for <dm-devel@lists.linux.dev>; Sat, 30 May 2026 06:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780149181; x=1780753981; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ewp0+8EhRjKPhSzS1/+FL/pipI4hkhHh2pwf/+Fkc5g=;
        b=KoRn0cRhEbnlC9T6SXepEM9BHAhniAtBudB7IpIeT5phn3oWSPVIOPw3cViOS7pGek
         ydLJ30LePANwUcVrrAasRSdu8n3IEEVtnl1F/u9OyOEdXxVikHOyLLWl5+BMunlgf8HN
         B0EHNJoZStBngF/a1q5dNVzZdRrifdpAaz7N+Xofcsu7vVOuPY+XnOxe9pcIQ6Ysv9m6
         cGJpIjP81weZK6d7vxQTSy9x0GlG0TLMmxp/2P/uNQpG0RwwvZAZmXQtl5/v3CPT6WHG
         HkgBQ/P4K5SS1q8z8gV9YpRkFkSJAfcdtumQN8sUFTg2v1l5zUL7JJfJVb/NJdbodHdV
         x1fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780149181; x=1780753981;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ewp0+8EhRjKPhSzS1/+FL/pipI4hkhHh2pwf/+Fkc5g=;
        b=pZdx0WHMM25AV/ZpVxCkMGGtTWYuLtrZFkby7Xu945jJ94gNUIn2MqgBJk4SHTc3X5
         jWw5pD9kvB0vX61xx4DnNDqIr38Lid6OdfOZceTuU6+DiWgksgOfSRromDb4DXvgVyPg
         7WP8N/SgXq7EtVX1VM8w11ywwgfZPyew1Ximdj3B13JMrF9k5Ha0/Id8FaKJL9OHGWqM
         sMBYGU+d+hZJWC//iLRQaROTPaPnoPuHnpGdv+qti1Jn/jnXKnAJkREm1MytgT3Hh27Q
         mJede8thYbE0Q325VBKBT1/7ohob5GUdKrEwVE64pC5Cl3j1qtuY6GWyh1IIFGFp83YP
         GXJA==
X-Gm-Message-State: AOJu0YwfhVSOXuQ1zax5Dh1TDMz7VlXyayw6Us/kPSAeRpS3901sLGEj
	5eaFCDXCC2sZ5SduGrUQwPtT6yCJzU7csh0Seu8ZOiImh8651ci25zMTu5BpTA==
X-Gm-Gg: Acq92OFbQk4u7S/2wYZ8LAvKYWMTKnRlmc6qbbnLB3i/ueJJABHpU2LZjXp2mbUkjN4
	ggmow7PHSUPxlCsL4fkkZsu6FzzV48Q1/N6rewvYa+nCS2D0KszaYlZuWeiiPry/H0m2hu0z6WE
	DWovMUMlFwo2Z48+hbWFrDPqwtk7dnzwMImMbQRfbU3GjfciehN1xATs457tw+ofIgTbexASMAw
	0vEoSZyqMil66rgs0zpSXEeOWG7nMhHG7H+BADPNfWwte8IRVKjUYZddeXZdjlz2i9qJLjxDros
	m8DuRGkA2U/lBuhmCyWrp5SQKwgBJe444hKkSs7NYP3OVvQDWPqyTndDYl0lY5NOaBRH5NOenpk
	1ZEhING/gyhKSFCKpuc/Xu0ZHOExiyIYuc06NAwqlyS8cbAG5L0eWdYvmIkd/HdOU5ZaBIRMTaR
	o07aSijwBI+VTsSCtA/U2cQDwlEBmxZNgWWg==
X-Received: by 2002:a05:6000:2892:b0:441:1e8e:d8fd with SMTP id ffacd0b85a97d-45ef6b60274mr7077651f8f.29.1780149180672;
        Sat, 30 May 2026 06:53:00 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354bb62sm10346013f8f.19.2026.05.30.06.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 06:53:00 -0700 (PDT)
Date: Sat, 30 May 2026 16:52:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@lists.linux.dev
Subject: [bug report] dm zoned: allocate temporary superblock for tertiary
 devices
Message-ID: <ahrruAVoUpDmh6Cf@stanley.mountain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Hannes Reinecke,

Commit 5d2c74f3ddc0 ("dm zoned: allocate temporary superblock for
tertiary devices") from Jun 2, 2020 (linux-next), leads to the
following Smatch static checker warning:

	drivers/md/dm-zoned-metadata.c:1332 dmz_load_sb()
	error: double free of 'sb->mblk' (line 1336)

drivers/md/dm-zoned-metadata.c
    1310         if (zmd->sb_version > 1) {
    1311                 int i;
    1312                 struct dmz_sb *sb;
    1313 
    1314                 sb = kzalloc_obj(struct dmz_sb);
    1315                 if (!sb)
    1316                         return -ENOMEM;
    1317                 for (i = 1; i < zmd->nr_devs; i++) {
    1318                         sb->block = 0;
    1319                         sb->zone = dmz_get(zmd, zmd->dev[i].zone_offset);
    1320                         sb->dev = &zmd->dev[i];
    1321                         if (!dmz_is_meta(sb->zone)) {
    1322                                 dmz_dev_err(sb->dev,
    1323                                             "Tertiary super block zone %u not marked as metadata zone",
    1324                                             sb->zone->id);
    1325                                 ret = -EINVAL;
    1326                                 goto out_kfree;
    1327                         }
    1328                         ret = dmz_get_sb(zmd, sb, i + 1);

This sets sb->mblk on the success path, but if the
dmz_get_sb() allocation fails then sb->mblk is left as-is.

    1329                         if (ret) {
    1330                                 dmz_dev_err(sb->dev,
    1331                                             "Read tertiary super block failed");
--> 1332                                 dmz_free_mblock(zmd, sb->mblk);
                                                              ^^^^^^^^
On the second iteration throug the loop then this is a double free.
I think this dmz_free_mblock() should just be deleted.  If
dmz_get_sb() fails then there shouldn't be anything to free
here.

    1333                                 goto out_kfree;
    1334                         }
    1335                         ret = dmz_check_sb(zmd, sb, true);
    1336                         dmz_free_mblock(zmd, sb->mblk);

On the first iteration then sb->mblk is freed.

    1337                         if (ret == -EINVAL)
    1338                                 goto out_kfree;
    1339                 }
    1340 out_kfree:
    1341                 kfree(sb);
    1342         }
    1343         return ret;
    1344 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
