Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DE9C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  7 Apr 2022 15:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649345837;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FV+RsNXRaGfOSXigzvyIloZD4rS9e36XFDxWMBJvivo=;
	b=OCtPxamW+tho26GNBxLe8+QhanRdYwZmtvSlgXHmwQGVNLv+iEcFKGKNkXeRjr1QM3EtRw
	/qTPIIEJmJBOkAhVe/Bu0dsVAVGm0nYmxRqDA14GmAKKsMy/BpM5Fg1zUaD4pqA63dsX4z
	QpLGbqtLHJOyquUvl1KYzygq0lAcppA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-OY09IKHVPP-ksb48kxkuww-1; Thu, 07 Apr 2022 11:37:15 -0400
X-MC-Unique: OY09IKHVPP-ksb48kxkuww-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E158C2A2AD61;
	Thu,  7 Apr 2022 15:37:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 943CE2166B1F;
	Thu,  7 Apr 2022 15:37:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 54F3F1949761;
	Thu,  7 Apr 2022 15:37:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CEBF41947BBE
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Apr 2022 15:37:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9167B2166B4F; Thu,  7 Apr 2022 15:37:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D5592166B1C
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 15:37:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7092D1C0AF01
 for <dm-devel@redhat.com>; Thu,  7 Apr 2022 15:37:07 +0000 (UTC)
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-6Ox1UseoMWGJhRQGFwJHcw-1; Thu, 07 Apr 2022 11:37:00 -0400
X-MC-Unique: 6Ox1UseoMWGJhRQGFwJHcw-1
Received: by mail-wm1-f72.google.com with SMTP id
 m3-20020a05600c3b0300b0038e74402cb6so3113245wms.8
 for <dm-devel@redhat.com>; Thu, 07 Apr 2022 08:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fykAQX2EGgAkIVjRJ+JEdQF05NZTL0zM7Hy/8zivWsY=;
 b=l8hvFZqrPeA5Vu4G3/K0QerKf1ZJEonu+8emeK8juxIzCrDeOUgRjKvt/aW1p5gLRu
 Z0zF7xwJM1yWbsZqsxZqU611HREGGZoWMFIXnG2c8W0lYo653OTU6KCEruEMGj5HjEEC
 4U0e6tN9XDcLmQYibzL+j/zdn/fNbw7ayvnBNuNxYeFFvOC7g+tOy5qKN1XlSJpMgXUN
 S+hF2kL4Yew9+aKhF2zmYg2skJ4SXizQVYYrfKQLFfE8pur+iolKOseS7eaLc6I9Ksdi
 SIBikAFTyrQpbnPc6a8nHRc9Jq4ULmjqbDHW1YDVDB/+L6p2GbnBNk+QfJnUUcxooxEv
 oFCg==
X-Gm-Message-State: AOAM5323CdktgQP33d/Vnt1X/1+re5LQEaQGI15v6O+WHzykgSmfujWN
 iyFjtvL4lucs+AxZyR5SEYjhyr3GD2ptFkKFp5oCHKaLoGIyReRNfPciEHPwwZGEQKzAcbDesSd
 YWJpbMDOxfl/9LsM=
X-Received: by 2002:adf:db86:0:b0:205:bccf:8cbf with SMTP id
 u6-20020adfdb86000000b00205bccf8cbfmr10988009wri.346.1649345819392; 
 Thu, 07 Apr 2022 08:36:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtZEtTaIqGU6x+/Ch2SaleceIS6pYHeTDvRKyo0ZsS9QnaDBGHqMaV/He3O7SrxNiV5k+G7Q==
X-Received: by 2002:adf:db86:0:b0:205:bccf:8cbf with SMTP id
 u6-20020adfdb86000000b00205bccf8cbfmr10987998wri.346.1649345819147; 
 Thu, 07 Apr 2022 08:36:59 -0700 (PDT)
Received: from redhat.com (128.19.187.81.in-addr.arpa. [81.187.19.128])
 by smtp.gmail.com with ESMTPSA id
 v18-20020adfc5d2000000b0020589b76704sm18069280wrg.70.2022.04.07.08.36.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Apr 2022 08:36:58 -0700 (PDT)
Date: Thu, 7 Apr 2022 16:36:56 +0100
From: "Bryn M. Reeves" <breeves@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <Yk8FGN1HtVTYjoSl@redhat.com>
References: <20220403114532.180945-1-ming.lei@redhat.com>
 <YksiEk+G5QuPG6o8@redhat.com> <Ykz2aF3VgyyVG46m@T590>
 <Yk3FO6r59nTrDuiS@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Yk3FO6r59nTrDuiS@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [RFC PATCH] io_uring: reissue in case -EAGAIN is
 returned after io issue returns
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
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
 Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 06, 2022 at 12:52:11PM -0400, Mike Snitzer wrote:
> On Tue, Apr 05 2022 at 10:09P -0400, Ming Lei <ming.lei@redhat.com> wrote:
> > Because it is null block...
> 
> Ha, yes.. very good point. I was expecting null_blk capability (read
> back written data) that it was never intended to provide. Sorry ;)

You can configure a memory backed nullblk instance using the configfs
interface that will return written data on reads:

  # modprobe null_blk nr_devices=0
  # mkdir -p /sys/kernel/config/nullb/nullb0
  # echo 500 > /sys/kernel/config/nullb/nullb0/size
  # echo 1 > /sys/kernel/config/nullb/nullb0/memory_backed
  # echo 1 > /sys/kernel/config/nullb/nullb0/power 
  # lsblk | grep null
  nullb0               250:0    0  500M  0 disk 

It's good enough to make and mount an ext4 file system; the contents
persist across umount as you'd expect and the image will pass an fsck:

  # mkfs.ext4 /dev/nullb0 
  mke2fs 1.46.3 (27-Jul-2021)
  ...

However there's still something in null_blk that causes fio's verify
mode some indigestion:

  # fio --bs=4096 --ioengine=io_uring --fixedbufs --registerfiles --hipri=1 --iodepth=2 --iodepth_batch_submit=2 --iodepth_batch_complete_min=2 --filename=/dev/nullb0 --direct=1 --runtime=20 --numjobs=2 --rw=randread --name=test --group_reporting --norandommap --do_verify=1 --verify=crc32c --verify_async=1
  test: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=2
  ...
  fio-3.26
  Starting 2 processes
  fio: filehash.c:64: __lookup_file_hash: Assertion `f->fd != -1' failed.
  verify: bad magic header 0, wanted acca at file /dev/nullb0 offset 31621120, length 4096 (requested block: offset=31621120, length=4096)
  verify: bad magic header 0, wanted acca at file /dev/nullb0 offset 388124672, length 4096 (requested block: offset=388124672, length=4096)
  fio: pid=2074, err=84/file:verify.c:1444, func=async_verify, error=Invalid or incomplete multibyte or wide character
  fio: pid=2075, got signal=6
  Jobs: 1 (f=0): [f(1),K(1)][-.-%][eta 00m:00s]
  Jobs: 1 (f=0): [f(1),K(1)][-.-%][eta 00m:00s]
  Jobs: 1 (f=0): [f(1),K(1)][-.-%][eta 00m:00s]
  
  ^Cbs: 1 (f=0): [f(1),K(1)][-.-%][eta 00m:00s]
  fio: terminating on signal 2

I haven't looked into it any further at this point (I was looking at
null_blk to evaluate it for use in stacker, as a backing device for
test stacks).

Regards,
Bryn.
 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

