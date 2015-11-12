From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH 0/2] Introduce the request handling for
 dm-crypt
Date: Thu, 12 Nov 2015 01:05:40 -0800
Message-ID: <20151112090540.GA18886@infradead.org>
References: <cover.1447233227.git.baolin.wang@linaro.org>
 <20151111181813.GD12236@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151111181813.GD12236@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Baolin Wang <baolin.wang@linaro.org>, axboe@kernel.dk, keith.busch@intel.com, jack@suse.cz, arnd@arndb.de, neilb@suse.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, broonie@kernel.org, dineshg@quicinc.com, tj@kernel.org, bart.vanassche@sandisk.com, jmoyer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 11, 2015 at 01:18:13PM -0500, Mike Snitzer wrote:
> But I'm trying to keep an open mind... show me data that real hardware
> _really_ benefits and we'll go from there.  Again, it needs to be "OMG,
> this is amazing!" level performance to warrant any further serious
> consideration.

Also the numbers should be on 4.3+ with our arbitrarily sizeds bios,
and a file system that isn't stupid and actually submits bios (xfs,
btrfs for example).
