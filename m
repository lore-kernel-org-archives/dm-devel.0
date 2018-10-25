From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [RFC] dm-bow working prototype
Date: Thu, 25 Oct 2018 01:01:23 +0100
Message-ID: <20181025000123.GB22722@agk-dp.fab.redhat.com>
References: <20181023212358.60292-1-paullawrence@google.com> <20181023221819.GB17552@agk-dp.fab.redhat.com> <296148c2-f2d9-5818-ea76-d71a0d6f5cd4@google.com> <alpine.LRH.2.02.1810241514310.4080@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1810241514310.4080@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Lawrence <paullawrence@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-doc@vger.kernel.org, kernel-team@android.com, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids

On Wed, Oct 24, 2018 at 03:24:29PM -0400, Mikulas Patocka wrote:
> What about allocating a big file, using the FIEMAP ioctl to find the 

For reference, dmfilemapd in the lvm2 tree (in daemons/) uses FIEMAP
(in libdm/libdm-stats.c) for monitoring I/O by file.

> If you decide that rollback is no longer needed, you just unload the 
> snapshot target and delete the big file. If you decide that you want to 
> rollback, you can use the snapshot merge functionality (or you can write a 
> userspace utility that does offline merge).
 
There's some old code from Mark McLoughlin for userspace snapshot merging here:
  https://people.gnome.org/~markmc/code/merge-dm-snapshot.c

Alasdair
