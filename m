From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 2/3] dm: add support for passing through inline crypto
 support
Date: Thu, 24 Sep 2020 08:45:50 -0700
Message-ID: <20200924154550.GA1266@sol.localdomain>
References: <20200909234422.76194-1-satyat@google.com>
 <20200909234422.76194-3-satyat@google.com>
 <20200922003255.GC32959@sol.localdomain>
 <20200924011438.GD10500@redhat.com>
 <20200924071721.GA1883346@google.com>
 <20200924134649.GB13849@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200924134649.GB13849@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Satya Tangirala <satyat@google.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 24, 2020 at 09:46:49AM -0400, Mike Snitzer wrote:
> > > Can you help me better understand the expected consumer of this code?
> > > If you have something _real_ please be explicit.  It makes justifying
> > > supporting niche code like this more tolerable.
> >
> > So the motivation for this code was that Android currently uses a device
> > mapper target on top of a phone's disk for user data. On many phones,
> > that disk has inline encryption support, and it'd be great to be able to
> > make use of that. The DM device configuration isn't changed at runtime.
> 
> OK, which device mapper target is used?

There are several device-mapper targets that Android can require for the
"userdata" partition -- potentially in a stack of more than one:

dm-linear: required for Dynamic System Updates
(https://developer.android.com/topic/dsu)

dm-bow: required for User Data Checkpoints on ext4
(https://source.android.com/devices/tech/ota/user-data-checkpoint)
(https://patchwork.kernel.org/patch/10838743/)

dm-default-key: required for metadata encryption
(https://source.android.com/security/encryption/metadata)

We're already carrying this patchset in the Android common kernels since late
last year, as it's required for inline encryption to work when any of the above
is used.  So this is something that is needed and is already being used.

Now, you don't have to "count" dm-bow and dm-default-key since they aren't
upstream; that leaves dm-linear.  But hopefully the others at least show that
architecturally, dm-linear is just the initial use case, and this patchset also
makes it easy to pass through inline crypto on any other target that can support
it (basically, anything that doesn't change the data itself as it goes through).

- Eric
