From: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 3.10,3.12] dm: flush queued bios when process blocks to
 avoid deadlock
Date: Wed, 15 Mar 2017 23:05:53 +0100
Message-ID: <20170315220553.GA14761@1wt.eu>
References: <alpine.LRH.2.02.1703151627140.1934@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1703151627140.1934@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 15, 2017 at 04:28:51PM -0400, Mikulas Patocka wrote:
> Hi
> 
> This is backport of upstream commit 
> d67a5f4b5947aba4bfe9a80a2b86079c215ca755. It is suitable for stable 
> branches 3.10 and 3.12.

Queued for next 3.10, thanks Mikulas!

Willy
