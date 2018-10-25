From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [dm-devel] [RFC] dm-bow working prototype
Date: Thu, 25 Oct 2018 11:20:40 +0100
Message-ID: <20181025102039.GA9378@localhost.localdomain>
References: <20181023212358.60292-1-paullawrence@google.com>
 <20181023221819.GB17552@agk-dp.fab.redhat.com>
 <296148c2-f2d9-5818-ea76-d71a0d6f5cd4@google.com>
 <alpine.LRH.2.02.1810241514310.4080@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1810241514310.4080@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Paul Lawrence <paullawrence@google.com>, Mike Snitzer <snitzer@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, kernel-team@android.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 24, 2018 at 03:24:29PM -0400, Mikulas Patocka wrote:
> 
> 
> On Wed, 24 Oct 2018, Paul Lawrence wrote:
> 
> > Android has had the concept of A/B updates for since Android N, which means
> > that if an update is unable to boot for any reason three times, we revert to
> > the older system. However, if the failure occurs after the new system has
> > started modifying userdata, we will be attempting to start an older system
> > with a newer userdata, which is an unsupported state. Thus to make A/B able to
> > fully deliver on its promise of safe updates, we need to be able to revert
> > userdata in the event of a failure.
> > 
> > For those cases where the file system on userdata supports
> > snapshots/checkpoints, we should clearly use them. However, there are many
> > Android devices using filesystems that do not support checkpoints, so we need
> > a generic solution. Here we had two options. One was to use overlayfs to
> > manage the changes, then on merge have a script that copies the files to the
> > underlying fs. This was rejected on the grounds of compatibility concerns and
> > managing the merge through reboots, though it is definitely a plausible
> > strategy. The second was to work at the block layer.
> > 
> > At the block layer, dm-snap would have given us a ready-made solution, except
> > that there is no sufficiently large spare partition on Android devices. But in
> > general there is free space on userdata, just scattered over the device, and
> > of course likely to get modified as soon as userdata is written to. We also
> > decided that the merge phase was a high risk component of any design. Since
> > the normal path is that the update succeeds, we anticipate merges happening
> > 99% of the time, and we want to guarantee their success even in the event of
> > unexpected failure during the merge. Thus we decided we preferred a strategy
> > where the device is in the committed state at all times, and rollback requires
> > work, to one where the device remains in the original state but the merge is
> > complex.
> 
> What about allocating a big file, using the FIEMAP ioctl to find the 
> physical locations of the file, creating a dm device with many linear 
> targets to map the big file and using it as a snapshot store? I think it 
> would be way easier than re-implementing the snapshot functionality in a 
> new target.

libdevmapper already has code to handle enumerating physical file
extents via the dm-stats file mapping support. It should be fairly easy
to adapt this to create dm tables rather than dm-stats regions.

See dm_stats_create_regions_from_fd() and _stats_map_file_regions().

Bryn.
