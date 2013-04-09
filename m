From: Tejun Heo <tj@kernel.org>
Subject: Re: dm-crypt parallelization patches
Date: Tue, 9 Apr 2013 14:03:56 -0700
Message-ID: <20130409210356.GN6186@mtj.dyndns.org>
References: <20130328203808.GC15969@redhat.com>
 <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210201.GM6186@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130409210201.GM6186@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Christian Schmidt <schmidt@digadd.de>
List-Id: dm-devel.ids

On Tue, Apr 09, 2013 at 02:02:01PM -0700, Tejun Heo wrote:
> For testing, copying bi_ioc and bi_css directly is fine but please add
> another interface to copy those for the actual code.  Say,
> bio_copy_association(@to_bio, @from_bio) or whatever.

Another and probably better possibility is just remembering the
issuing task (you would of course need to hold an extra ref as long as
you wanna use it) and use bio_associate_task() on it when creating new
bios.

Thanks.

-- 
tejun
