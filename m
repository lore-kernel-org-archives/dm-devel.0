From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/4] dm verity: add support for error
 correction
Date: Sat, 7 Nov 2015 10:20:38 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511071018250.18330@file01.intranet.prod.int.rdu2.redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com> <563B066C.6050202@redhat.com> <alpine.LRH.2.02.1511061201520.5619@file01.intranet.prod.int.rdu2.redhat.com> <20151106190634.GA2813@google.com> <563CFD6F.4040009@redhat.com>
 <20151106202750.GA11849@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151106202750.GA11849@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: device-mapper development <dm-devel@redhat.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, Mandeep Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids



On Fri, 6 Nov 2015, Sami Tolvanen wrote:

> On Fri, Nov 06, 2015 at 08:20:15PM +0100, Zdenek Kabelac wrote:
> > i.e. you have 1G of space - you want to give 250MB as 'redundancy' -
> > so create 4 partition....
> 
> We cannot afford to set aside 25% of read-only partition space for

You can have 20 raid5 legs (with as big chunksizes as possible - so that 
sequential accesses are really sequential when they hit the flash device), 
and that means setting aside only 5%. Or even more legs.

Mikulas

> redundancy on mobile devices, and would rather not impact performance
> any more than dm-verity already does. With error correction we have
> 0.8% space overhead in our use case and no performance degradation if
> the partition is not corrupted.
> 
> Sami
