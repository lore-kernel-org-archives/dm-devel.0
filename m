From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] Reverting "bd_mount_mutex" to "bd_mount_sem"
Date: Wed, 27 Sep 2006 15:57:05 +0200
Message-ID: <20060927135705.GA30311@elte.hu>
References: <451A78DF.1060901@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932251AbWI0OE5@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <451A78DF.1060901@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: dm-devel@redhat.com, linux-lvm@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


* Srinivasa Ds <srinivasa@in.ibm.com> wrote:

>   On debugging I found out that,"dmsetup suspend <device name>" calls 
> "freeze_bdev()",which locks "bd_mount_mutex" to make sure that no new 
> mounts happen on bdev until thaw_bdev() is called.
>   This "thaw_bdev()" is getting called when we resume the device 
> through "dmsetup resume <device-name>".
>   Hence we have 2 processes,one of which locks 
> "bd_mount_mutex"(dmsetup suspend) and Another(dmsetup resume) unlocks 
> it.

hm, to me this seems quite a fragile construct - even if the 
mutex-debugging warning is worked around by reverting to a semaphore.

	Ingo
