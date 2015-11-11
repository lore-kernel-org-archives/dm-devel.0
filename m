From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Introduce the request handling for dm-crypt
Date: Wed, 11 Nov 2015 01:48:11 -0800
Message-ID: <20151111094811.GA3641@infradead.org>
References: <cover.1447233227.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1447233227.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com, jack@suse.cz, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, broonie@kernel.org, arnd@arndb.de, dineshg@quicinc.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Nov 11, 2015 at 05:31:43PM +0800, Baolin Wang wrote:
> Now the dm-crypt code only implemented the 'based-bio' method to encrypt/
> decrypt block data, which can only hanle one bio at one time. As we know,
> one bio must use the sequential physical address and it also has a limitation
> of length. Thus it may limit the big block encyrtion/decryption when some
> hardware support the big block data encryption.
> 
> This patch series introduc the 'based-request' method to handle the data
> encryption/decryption. One request can contain multiple bios, so it can
> handle big block data to improve the efficiency.

NAK for more request based stacking or DM drivers.  They are a major
pain to deal with, and adding more with different requirements then
dm-multipath is not helping in actually making that one work properly.
