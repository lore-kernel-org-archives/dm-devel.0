From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [dm-devel] [PATCH 0/4] dm verity: add support for error
 correction
Date: Fri, 6 Nov 2015 21:23:38 +0000
Message-ID: <20151106212338.GA19557@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <563B066C.6050202@redhat.com>
 <alpine.LRH.2.02.1511061201520.5619@file01.intranet.prod.int.rdu2.redhat.com>
 <20151106190634.GA2813@google.com>
 <563CFD6F.4040009@redhat.com>
 <20151106202750.GA11849@google.com>
 <563D1614.5010501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <563D1614.5010501@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, Mandeep Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Fri, Nov 06, 2015 at 10:05:24PM +0100, Zdenek Kabelac wrote:
> So how do you want to correctly 'restore'  missing full sectors
> with just 0.8% data overhead ??

We use interleaving. Each byte in a 4k block is part of a different
Reed-Solomon block, which means an entire lost 4k data block looks like a
single error. When we also spread the bytes that form a single Reed-Solomon
block across the partition, we end up being able to correct several
megabytes of consecutive corrupted blocks with very small space overhead.

Sami
