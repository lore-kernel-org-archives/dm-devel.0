From: "James Johnston" <johnstonj.public@codenest.com>
Subject: RE: [dm-devel] bcache gets stuck flushing writeback cache when used in combination with LUKS/dm-crypt and non-default bucket size
Date: Wed, 18 May 2016 17:01:37 -0000
Message-ID: <01df01d1b126$f1fe1810$d5fa4830$@codenest.com>
References: <044401d1a958$ea7ef4e0$bf7cdea0$@codenest.com> <alpine.LRH.2.11.1605101816240.22680@mx.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1605101816240.22680@mx.ewheeler.net>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
To: 'Eric Wheeler' <bcache@lists.ewheeler.net>
Cc: 'Mike Snitzer' <snitzer@redhat.com>, dm-crypt@saout.de, dm-devel@redhat.com, linux-bcache@vger.kernel.org, 'Kent Overstreet' <kent.overstreet@gmail.com>, 'Alasdair Kergon' <agk@redhat.com>
List-Id: dm-devel.ids

> On Sun, 8 May 2016, James Johnston wrote:
> 
> > Hi,
> >
> > [1.] One line summary of the problem:
> >
> > bcache gets stuck flushing writeback cache when used in combination with
> > LUKS/dm-crypt and non-default bucket size
> >
> > [2.] Full description of the problem/report:
> >
> > I've run into a problem where the bcache writeback cache can't be flushed to
> > disk when the backing device is a LUKS / dm-crypt device and the cache set has
> > a non-default bucket size.
> 
> You might try LUKS atop of bcache instead of under it.  This might be
> better for privacy too, otherwise your cached data is unencrypted.

Only in this test case; on my real setup, the cache device is also layered on top
Of LUKS.  (On both backing & cache, it's LUKS --> LVM2 --> bcache.  This gives me
flexibility to adjust volumes without messing with the encryption, or having more
encryption devices than really needed.  At any rate, I expect this setup to at
least work...)

> 
> > # Make cache set on second drive
> > # IMPORTANT:  Problem does not occur if I omit --bucket parameter.
> > make-bcache --bucket 2M -C /dev/sdb
> 
> 2MB is quite large, maybe it exceeds the 256-bvec limit.  I'm not sure if
> Ming Lei's patch got in to 4.6 yet, but try this:
>   https://lkml.org/lkml/2016/4/5/1046
> 
> and maybe Shaohua Li's patch too:
>   http://www.spinics.net/lists/raid/msg51830.html

Trying these is still on my TODO list (thus the belated reply here) but based
on the responses from Tim Small I'm doubtful this will fix anything, as it
sounds like he has the same problem (symptoms sound exactly the same) and he
says the patches didn't help.

Like Tim, I also chose a large bucket size because the manual page told me to.
Based on the high-level description of bcache and my knowledge of how flash
works, it certainly sounds necessary.

Perhaps the union of people who read manpages and people who use LUKS like
this is very small. :)

James
