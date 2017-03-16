From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 3.10,3.12] dm: flush queued bios when process blocks to
 avoid deadlock
Date: Thu, 16 Mar 2017 08:57:20 +0100
Message-ID: <53af336d-e5c1-d270-b751-d2d55ec62d0a@suse.cz>
References: <alpine.LRH.2.02.1703151627140.1934@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1703151627140.1934@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, stable@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 03/15/2017, 09:28 PM, Mikulas Patocka wrote:
> Hi
> 
> This is backport of upstream commit 
> d67a5f4b5947aba4bfe9a80a2b86079c215ca755. It is suitable for stable 
> branches 3.10 and 3.12.
> 
> Mikulas
> 
> 
> commit d67a5f4b5947aba4bfe9a80a2b86079c215ca755
> Author: Mikulas Patocka <mpatocka@redhat.com>
> Date:   Wed Feb 15 11:26:10 2017 -0500
> 
>     dm: flush queued bios when process blocks to avoid deadlock

Thanks, applied.


-- 
js
suse labs
