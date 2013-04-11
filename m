From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
Date: Thu, 11 Apr 2013 13:00:05 -0700
Message-ID: <20130411200005.GB11956@mtj.dyndns.org>
References: <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com>
 <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com>
 <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org>
 <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130411195203.GA11956@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Christian Schmidt <schmidt@digadd.de>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 11, 2013 at 12:52:03PM -0700, Tejun Heo wrote:
> If this becomes an actual bottleneck, the right thing to do is making
> css ref per-cpu.  Please stop messing around with refcounting.

If you think this kind of hackery is acceptable, you really need to
re-evaluate your priorities in making engineering decisions.  In
tightly coupled code, maybe, but you're trying to introduce utterly
broken error-prone thing as a generic block layer API.  I mean, are
you for real?

-- 
tejun
