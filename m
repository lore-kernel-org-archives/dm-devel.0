From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Crash when IO is being submitted and block size is changed
Date: Thu, 28 Jun 2012 11:44:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1206281138150.23635@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
 <20120628111541.GB17515@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120628111541.GB17515@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Thu, 28 Jun 2012, Jan Kara wrote:

> > Do you have any other ideas what to do with it?
>   Yeah, it's nasty and neither solution looks particularly appealing. One
> idea that came to my mind is: I'm trying to solve some races between direct
> IO, buffered IO, hole punching etc. by a new mapping interval lock. I'm not
> sure if it will go anywhere yet but if it does, we can fix the above race
> by taking the mapping lock for the whole block device around setting block
> size thus effectivelly disallowing any IO to it.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

What races are you trying to solve? There used to be i_alloc_mem that 
prevented direct i/o while the file is being truncated, but it disappeared 
in recent kernels...

Mikulas
