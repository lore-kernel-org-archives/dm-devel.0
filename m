From: Nikolay Borisov <n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
Subject: Re: block: transfer source bio's cgroup tags to clone via bio_associate_blkcg()
Date: Tue, 15 Mar 2016 00:08:27 +0200
Message-ID: <CAJFSNy7i-Kp_bPYajdSzDAt9F6_HQJ=_TFgjWzhk16_W66at7A@mail.gmail.com>
References: <56CDF283.9010802@windriver.com>
	<56CEB1BC.4000005@kyup.com>
	<20160225145314.GA20699@redhat.com>
	<20160302160649.GB29826@mtj.duckdns.org>
	<20160302175656.GA59991@redhat.com>
	<56E6D3D3.4070104@kyup.com>
	<56E6D95B.3030904@siteground.com>
	<20160314194912.GA6975@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160314194912.GA6975-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

>
> Great.
>
> Jens, can you pick up the patch in question ("[PATCH] block: transfer
> source bio's cgroup tags to clone via bio_associate_blkcg()") that I
> posted in this thread?

And what about Vivek's patch of associating the source bio with the io
context of the process issuing the io?
Would that help in the DIO case?
