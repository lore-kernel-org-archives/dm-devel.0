From: Shaohua Li <shli@kernel.org>
Subject: Re: [dm-devel] [PATCG]DM: dm-compression: a compressed DM target for
 SSD
Date: Tue, 31 Dec 2013 17:58:27 +0800
Message-ID: <20131231095827.GA27868@kernel.org>
References: <20131227062421.GA21053@kernel.org>
 <20131228125725.GA16613@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131228125725.GA16613@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Sat, Dec 28, 2013 at 12:57:25PM +0000, Alasdair G Kergon wrote:
> I've not looked at this in any depth, but here are some first
> impressions:
> 
> On Fri, Dec 27, 2013 at 02:24:21PM +0800, Shaohua Li wrote:
> > This is a simple DM target supporting compression for SSD only.
> 
> Presumably there'll be other disk layouts and other types of compression
> in future, so if you want to grab the generic name "compression" then
> please make sure the interface to the code supports such extensions.
> Use of the term "SSD" may also be too narrow as there could be other
> technologies that are not labelled "SSD" that could benefit from the
> target.  At best, we say "for example, ssd" leaving things open for
> other uses.
> 
> IOW EITHER you should make it modular and supply a name to the ctr that
> tells it to use this specific combination OR if you don't think there'll
> need to be shared code with other compression types/disk layouts, rename
> this particular one to something more specific.
> 
> For this naming, focus on the key feature of the code, which seems to me
> to be the "in-place" or "in situ" nature of the so-called compression.
> - If you don't have some form of thin provisioning underneath, why would
> you use this?  
>   => dm-compress-inplace / insitu
>   => dm-compinsitu
>   => dm-compress-thin  (sub-module loaded from dm-compress)
>   => dm-compressthin   (standalone target)
>      -lzo ?

Thanks for your time! I'll rename it.
 
> To use this compression target above dm-thin (likely to prefer larger
> block sizes), for example, could the block sizes be adapatable /
> configurable?

block size (larger block size) is configurable, but currently I didn't
implement yet.

> Please use dm_ / DM_ prefixes - with underscore - and choose one prefix
> to use consistently.  I see "cp" (makes me think "copy") as well as
> "comp".
> 
> We don't label the fields in the STATUSTYPE_INFO output.
> 
> Do write Documentation/device-mapper/<target_name_without_leading_dm>.txt.
> E.g. what you wrote in the patch header should be moved into that file
> instead.  (Use a recent documentation file as a model for the format of
> the file, such as verity or thin-provisioning.)

ok

> And don't be afraid to include more comments in the code for the benefit
> of people who are unfamiliar with the nuances of device-mapper
> targets:)

Sure, I'll add more in next post.

Thanks,
Shaohua
