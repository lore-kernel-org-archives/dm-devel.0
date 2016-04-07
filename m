From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: dm-cache performance behaviour
Date: Thu, 7 Apr 2016 18:10:16 +0300
Message-ID: <CACaajQu6H96ZGpXSWtBOzaDaE3zDPOacJjcQw7GFrfMw96-Tiw@mail.gmail.com>
References: <20160405071253.GB27444@suselix.suse.de> <20160405133109.GF27444@suselix.suse.de>
 <alpine.LRH.2.11.1604070115070.12121@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1604070115070.12121@mail.ewheeler.net>
Sender: linux-bcache-owner@vger.kernel.org
To: Eric Wheeler <bcache@lists.ewheeler.net>
Cc: Andreas Herrmann <aherrmann@suse.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

2016-04-07 4:24 GMT+03:00 Eric Wheeler <bcache@lists.ewheeler.net>:
> You might consider tweaking {read,write}_promote_adjustment with
>         dmsetup message /dev/mapper/foo 0 read_promote_adjustment X
> or at initial table creation time to shorten cache heat time.
>
> You could use this with LVM tools:
>   lvchange --cachesettings 'read_promote_adjustment = 1' vg/cachedvol
>
> See descriptions here:
>
> https://www.kernel.org/doc/Documentation/device-mapper/cache-policies.txt
>
> When we used dm-cache I would set the promote values to 1 (or 0?) to heat
> up the cache and then increment them after the cache filled.
>
>> bcache:
>> - writeback cache mode
>> - LRU cache policy
>
> bcache defaults to 512k bucket size iirc, you'll want to specify -b 256k
> on your make-bcache call for an apples-to-apples comparison.  FWIW, I like
> the 64k size best for our workload.
>
> --
> Eric Wheeler


Does somebody can test bcache vs dm-writeboost vs dm-cache on latest
stable kernels ?


-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
