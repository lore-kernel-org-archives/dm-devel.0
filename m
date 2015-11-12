From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH 0/2] Introduce the request handling for
 dm-crypt
Date: Thu, 12 Nov 2015 01:06:36 -0800
Message-ID: <20151112090636.GB18886@infradead.org>
References: <cover.1447233227.git.baolin.wang@linaro.org>
 <20151111181813.GD12236@redhat.com>
 <CAMz4kuLHB=tAgJu1T433FTF-S08HcGCP16-urcZA4fp8dtWLMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMz4kuLHB=tAgJu1T433FTF-S08HcGCP16-urcZA4fp8dtWLMQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, keith.busch@intel.com, jack@suse.cz, Arnd Bergmann <arnd@arndb.de>, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, Mark Brown <broonie@kernel.org>, "Garg, Dinesh" <dineshg@quicinc.com>, tj@kernel.org, bart.vanassche@sandisk.com, jmoyer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Nov 12, 2015 at 10:36:34AM +0800, Baolin Wang wrote:
> That's right. But we'll not introduce the duality things, cause we
> will remove the bio based things in dm-crypt if the request based
> things are accepted.

No, you will NOT remote the bio based path.  That would break all kinds
of perfectly valid setups.
