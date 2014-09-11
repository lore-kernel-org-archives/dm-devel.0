From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH] dm crypt: fix access beyond the end of allocated space
Date: Thu, 11 Sep 2014 19:53:44 +0200
Message-ID: <20140911175344.GG23478@1wt.eu>
References: <alpine.LRH.2.02.1409111339220.5256@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1409111339220.5256@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Luis Henriques <luis.henriques@canonical.com>, dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

On Thu, Sep 11, 2014 at 01:43:12PM -0400, Mikulas Patocka wrote:
> Hi
> 
> This is backport of upstream commit 
> d49ec52ff6ddcda178fc2476a109cf1bd1fa19ed. It is suitable for all stable 
> kernels.

Patch queued, thanks very much!

Willy
