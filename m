From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Wed, 11 Nov 2015 13:18:13 -0500
Message-ID: <20151111181813.GD12236@redhat.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1447233227.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Cc: axboe@kernel.dk, agk@redhat.com, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, jack@suse.cz, arnd@arndb.de, linux-kernel@vger.kernel.org, keith.busch@intel.com, jmoyer@redhat.com, broonie@kernel.org, tj@kernel.org, bart.vanassche@sandisk.com, dineshg@quicinc.com
List-Id: dm-devel.ids

On Wed, Nov 11 2015 at  4:31am -0500,
Baolin Wang <baolin.wang@linaro.org> wrote:

> Now the dm-crypt code only implemented the 'based-bio' method to encrypt/
> decrypt block data, which can only hanle one bio at one time. As we know,
> one bio must use the sequential physical address and it also has a limitation
> of length. Thus it may limit the big block encyrtion/decryption when some
> hardware support the big block data encryption.
> 
> This patch series introduc the 'based-request' method to handle the data
> encryption/decryption. One request can contain multiple bios, so it can
> handle big block data to improve the efficiency.

The duality of bio-based vs request-based code paths in DM core frankly
sucks.  So the prospect of polluting dm-crypt with a similar duality is
really _not_ interesting.

Request-based DM requires more memory reserves per device than bio-based
DM.  Also, you cannot stack request-based DM ontop of bio-based devices
(be them DM, MD, etc) so request-based DM's underlying storage stack
gets a lot less interesting with this change.

That said, it could be that the benefits of supporting both bio-based
and request-based DM in dm-crypt outweigh any overhead/limitations.  But
you haven't given any performance data to justify this patchset.

There needs to be a _really_ compelling benefit to do this.

Also, FYI, having a big CONFIG knob to switch all of dm-crypt from
bio-based to request-based is _not_ acceptable.  Both modes would need
to be supported in parallel.  Could easily be that not all devices in a
system will benefit from being request-based.

Regardless, the risk of this change causing request-based DM to become
more brittle than it already is concerns me.

But I'm trying to keep an open mind... show me data that real hardware
_really_ benefits and we'll go from there.  Again, it needs to be "OMG,
this is amazing!" level performance to warrant any further serious
consideration.
