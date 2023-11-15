Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17C333063
	for <dm-devel@lists.linux.dev>; Wed, 15 Nov 2023 17:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1f03db0a410so4087595fac.1
        for <dm-devel@lists.linux.dev>; Wed, 15 Nov 2023 09:29:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700069392; x=1700674192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q1VHa97dJyKrKV4G7OM0snBy+DfEMqxi/XhRE/MeRgE=;
        b=SdUJ4Y0FjCXIC4axt/fbMMMj4+bMXpwUQfFJ8Z08qEugaqAlWOEJp5EqAW4U1qZSOK
         IKOPgZ7ZiaU3T/IRIbo31/KCbdHO4MEt4v0uwPmCPPkJSE07aVJCpzw8dhX0cJVvzU+d
         biipytf/1yQaF9UnI4uDga8zAY/9xHiq9/MVpFYfahDvztq8j6193fqZ6ljAVJfUH13l
         X2hHuPoDVVfFJSx1d1tqF9Ioo4cSGcaQG/1RFrLGkb2oJzG19V2Q3zQqDueSlz6YHElw
         o4hbajiA2TgYifxLi60SEniVbdz3Avy5M8Wv6NcbBh/iLM4MWobTXpNwB4XQzNI8dyFv
         O0FQ==
X-Gm-Message-State: AOJu0YxAcf7YsmXSnM0ml378DZ/O3g/S3m3VG1a1bz0T8AAEothiOTrC
	yJqmCEmekqqTrb/OBLdN3yaMAwgkySdXHfpSrw==
X-Google-Smtp-Source: AGHT+IHWQ2E+ORCSqwkptCHnUiz8A/LIC6IVV4oZ1oOOmocfJeLq7pKTMoqgLLjCuEOtmIKlfUwD/g==
X-Received: by 2002:a05:6870:82ab:b0:1f0:84cb:9a35 with SMTP id q43-20020a05687082ab00b001f084cb9a35mr16559510oae.4.1700069391759;
        Wed, 15 Nov 2023 09:29:51 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id l19-20020ac84a93000000b0041b016faf7esm3682508qtq.58.2023.11.15.09.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 09:29:51 -0800 (PST)
Date: Wed, 15 Nov 2023 12:29:50 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Aaditya Raj Barnwal <abarnwal@qti.qualcomm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	"Aaditya Raj Barnwal (QUIC)" <quic_abarnwal@quicinc.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
	"Ravi Kumar Siddojigari (QUIC)" <quic_rsiddoji@quicinc.com>
Subject: Re: Patch : drivers/md/dm-verity-target.c
Message-ID: <ZVUADgxZPOtcSYTE@redhat.com>
References: <PH0PR02MB859952FC76063896916AA05DF6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
 <e371659-f86f-e711-ceb6-db9f0fd2e70@redhat.com>
 <PH0PR02MB859987618E8647439950A053F6AAA@PH0PR02MB8599.namprd02.prod.outlook.com>
 <559787b2-9b87-4ce-d5d9-6e16f22bc44@redhat.com>
 <1e9615ee3bf84ab7a3023152e3b94284@quicinc.com>
 <f66b2e7c-294b-60f8-7bd0-a4dff496fb4@redhat.com>
 <b5956421-f371-3535-6538-b189b16ec73e@redhat.com>
 <SJ0PR02MB8593C7351FBA28D4B213E105F6B1A@SJ0PR02MB8593.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR02MB8593C7351FBA28D4B213E105F6B1A@SJ0PR02MB8593.namprd02.prod.outlook.com>

On Wed, Nov 15 2023 at  2:01P -0500,
Aaditya Raj Barnwal <abarnwal@qti.qualcomm.com> wrote:

> Sorry if that statement confused you ,  It was debugging print 
> that was added to check if the  tight while loop has ended or not
>  
> Code : dm-init.c 
> dm_init_init()
>  
> 	wait_for_device_probe();
> 	for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
> 		if (waitfor[i]) {
> 			dev_t dev;
>  
> 			DMERR("waiting for device %s ...", waitfor[i]);
> 			while ((dev=  name_to_dev_t(waitfor[i]) !=0))
> 				fsleep(5000);
> 		}
>  
> 	DMERR("exiting after %s ",waitfor[i]);  <<<<<<<<<<<here it was added 
> 	}
>  
> 	if (waitfor[0])
> 		DMINFO("all devices available");
>  
> 	list_for_each_entry(dev, &devices, list) {
> 		if (dm_early_create(&dev->dmi, dev->table,
> 				    dev->target_args_array))
> 			break;
> 	}
> 


Mikulas wasn't confused.  He was pointing out that you have made
changes to your kernel without sharing what they are.

But your issue is that you configured the dm-mod.waitfor device
incorrectly. You must wait for the underlying physical device(s) that
the virtual DM device depends on.

Mike
