From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Tue, 4 Sep 2012 12:01:19 -0700
Message-ID: <20120904190119.GD3638@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
 <20120904034100.GA21602@moria.home.lan>
 <20120904185540.GC3638@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120904185540.GC3638@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

On Tue, Sep 04, 2012 at 11:55:40AM -0700, Tejun Heo wrote:
> Actually, if the timer approach can reduce the frequency of rescuer
> involvement, I think it could actually be better.

Ooh, it wouldn't.  It's kicking in only after alloc failure.  I don't
know.  I think conditioning it on alloc failure is cleaner and
converting all per-bio allocations to front-pad makes sense.  Using a
timer wouldn't make the mechanism any simpler, right?

Thanks.

-- 
tejun
