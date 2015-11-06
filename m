From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [dm-devel] [PATCH 0/4] dm verity: add support for error
 correction
Date: Fri, 6 Nov 2015 20:27:50 +0000
Message-ID: <20151106202750.GA11849@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <563B066C.6050202@redhat.com>
 <alpine.LRH.2.02.1511061201520.5619@file01.intranet.prod.int.rdu2.redhat.com>
 <20151106190634.GA2813@google.com>
 <563CFD6F.4040009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <563CFD6F.4040009@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, Mandeep Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Fri, Nov 06, 2015 at 08:20:15PM +0100, Zdenek Kabelac wrote:
> i.e. you have 1G of space - you want to give 250MB as 'redundancy' -
> so create 4 partition....

We cannot afford to set aside 25% of read-only partition space for
redundancy on mobile devices, and would rather not impact performance
any more than dm-verity already does. With error correction we have
0.8% space overhead in our use case and no performance degradation if
the partition is not corrupted.

Sami
