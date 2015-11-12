From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Thu, 12 Nov 2015 13:50:04 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511121318110.15026@file01.intranet.prod.int.rdu2.redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com> <563B066C.6050202@redhat.com> <20151105173306.GA22302@google.com> <20151109163735.GA28884@redhat.com> <20151109191925.GA29185@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151109191925.GA29185@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids



On Mon, 9 Nov 2015, Sami Tolvanen wrote:

> > Also, the 2 other big questions from Mikulas need answering:
> > 1) why aren't you actually adjustng error codes, returning success, if
> >    dm-verity was able to trap/correct the corruption?
> 
> We don't see actual I/O errors very often. Most corruption we've seen
> is caused by flaky hardware that doesn't return errors. However, I can
> certainly change to code to attempt recovery in this case too.

What flash controller and chips do you use? What is the probability of I/O 
error and what is the probability of silent data corruption? Is the silent 
data corruption permanent or transient? What is causing the silent data 
corruption (decay in flash chips?, errors on the bus?) Why can't you ask 
the hardware engineers to use a controler with proper error correction?

Without these data - it looks like you first wrote the patch and then 
tried to make some excuses why it should be accepted.

I'm also a little bit concerned that the patch will increase prevalence of 
crapware on the market - when accepted, this kind of reasoning will 
follow: "now we have error correction in the kernel, so we cut down flash 
overprovisioning, save a dollar or two per device, and produce a crap that 
randomly corrupts user's data on the read-write partition (because that 
partition not protected by the error correction)".

Mikulas
