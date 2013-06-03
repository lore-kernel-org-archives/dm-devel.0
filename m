From: Lars Marowsky-Bree <lmb@suse.com>
Subject: Re: Clustered RAID1 performance
Date: Mon, 3 Jun 2013 22:45:27 +0200
Message-ID: <20130603204527.GZ10694@suse.de>
References: <20130530095955.GE11926@suse.de>
	<6948BCF9-4B9B-420F-B95E-150F38A6D567@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <6948BCF9-4B9B-420F-B95E-150F38A6D567@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 2013-05-31T10:58:35, Brassow Jonathan <jbrassow@redhat.com> wrote:

Hi Jon, thanks for the response.

> What is your test set-up in which you are seeing the performance hit?

We saw it essentially as soon as we used "lvcreate -m1" on an LV; the
performance drop would be about 70% compared to -m0. Exclusive
activation would bring it back to ~95%.

(I wonder if that could be related to still using an older lvm2
user-space. Hm. Need to benchmark again with the latest.)

Actually concurrency via OCFS2 would of course have a worse impact.

I'm not quite sure where the split is; many use cases are "One active
process, but they want the LV to be visible everywhere and the election
to be automatic", but a fair share is "concurrent processes/OCFS2/GFS2,
replacing traditional expensive SAN mirroring (while not being ready
for ceph/gluster)" too.

The first part is reasonably trivial - enforce the one open process via
an exclusive lock automatically, and get to avoid the entire rest of the
cluster overhead.

Optimizing the latter case is harder.

> I have given some thought to making MD RAID1 cluster-aware.  (RAID10
> would come for free, but RAID4/5/6 would be excluded.) =


Yes, I guess that cover 99% of the interesting pieces anyway.

> would then make use of this code via the dm-raid.c wrapper.  My idea
> for the new implementation would have been to keep a separate bitmap
> area for each machine.  This way, there would be no locking and no
> need to keep the log state collectively in-sync during nominal
> operation.

Yes, I can see this could work. (Similarly to how OCFS2/GFS2 keep a
per-node journal too.)

Could be a bit tricky to get to the point where you could do full
read-balancing.

And, of course, this whole complexity is only needed for the truly
concurrent IO.

> When machines come, go or fail, their bitmaps would have
> to be merged and responsibility for recovery/initialization/scrubbing
> would have to be decided.

Right, but that's easy enough.

> Additionally, handling device failures is
> more tricky in MD RAID.  This is because MD RAID (and by extension,
> the device-mapper targets that leverage it) simply marks a device as
> failed in the superblock and keeps working while DM "mirror" blocks
> I/O until the failed device is cleared.

I guess though that could be enhanced.

> This makes a difference in the cluster because one machine may suffer
> a device failure due to connectivity and another machine may not.

Yes, understood. And we then want to degrade as gracefully as we can,
too.

(I sometimes keep wondering if, depending on the interconnect in the
cluster, the "ship all writes to a central process, read locally,
fail-over that process" isn't cheaper. I'm pretty sure that for
read-intensive workloads, it probably is.)

> If the machine suffering the failure simply marks the failure in the
> superblock (which will also need to be coordinated) and proceeds, the
> other machine may then attempt a read from the device and grab a copy
> of data that is stale.

Right. Cheapest way is to mark the drive failed on all nodes at the same
time; anything else actually does require write-shipping.


Regards,
    Lars

-- =

Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffe=
r, HRB 21284 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
