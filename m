From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] block: rename trace_block_remap to
 trace_block_bio_remap
Date: Mon, 15 Nov 2010 16:34:44 -0500
Message-ID: <20101115213444.GA25705@redhat.com>
References: <4AB3A393.5000709@ce.jp.nec.com>
 <4AB4F908.60307@ce.jp.nec.com>
 <20101103215047.GC26473@redhat.com>
 <20101115205815.GA25567@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101115205815.GA25567@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jaxboe@fusionio.com
Cc: device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Alasdair G Kergon <agk@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Nov 15 2010 at  3:58pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hi Jens,
> 
> This may have slipped through while you were traveling?
> 
> Patch is also available here:
> https://patchwork.kernel.org/patch/300552/
> 
> Not sure if this change is concerning on a kABI level?

To be clear: that concern/question was prompted from having taken a
quick glance at lwn's kernel summit "KS2010: ABI status for tracepoints"
coverage: http://lwn.net/Articles/412685/

But in that article it clearly states:
"there are to be no stable tracepoints in drivers or filesystems".

Not sure where that leaves tracepoints for the block layer.  Anyway,
seems tracepoint kABI is likely a concern for the future (not the
immediate future).

So this change would be nice to get in before there is a new tracepoint
kABI-aware sheriff in town.

Mike
