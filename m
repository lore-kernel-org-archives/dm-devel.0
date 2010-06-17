From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: 2.6.35 causes deadlock when snapshotting root lv
Date: Thu, 17 Jun 2010 10:27:32 -0400
Message-ID: <20100617142731.GA10071@redhat.com>
References: <4C1A2839.5010407@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C1A2839.5010407@cfl.rr.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jun 17 2010 at  9:50am -0400,
Phillip Susi <psusi@cfl.rr.com> wrote:

> What:
> 
> lvcreate -s -n snap -L 1g vg/root hangs in an unkillable state while
> trying to flush the fs and suspend the device to switch tables over to
> the snapshot, and no further IO is possible so the system must be hard
> booted with magic-sysrq.
> 
> Where: 2.6.35, all 3 release candidates.  2.6.34 and earlier kernels are
> fine.

Which filesystem are you using?  Which 2.6.35-rc?

There haven't been _any_ changes to DM for 2.6.35 (some DM fixes may get
pushed to Linus once Alasdair gets back from traveling).

So what this means is that the VFS (or ext4) freeze changes introduced
in 2.6.35 are the likely culprit:

http://git.kernel.org/linus/18e9e5104fcd9a9
http://git.kernel.org/linus/6b0310fbf087ad6

Though it could also be an issue with the various 2.6.35 writeback
changes (depending on which -rcX you're using).

Point is: this is not a DM regression.

Mike
