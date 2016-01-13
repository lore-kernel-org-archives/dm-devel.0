From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 0/2] Introduce the bulk IV mode for improving
 the crypto engine efficiency
Date: Tue, 12 Jan 2016 21:18:12 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1601122113240.24452@file01.intranet.prod.int.rdu2.redhat.com>
References: <cover.1450233399.git.baolin.wang@linaro.org> <20160104201343.GQ16023@sirena.org.uk> <alpine.LRH.2.02.1601121744400.18228@file01.intranet.prod.int.rdu2.redhat.com> <5514385.nEhTK7fEcU@wuerfel>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5514385.nEhTK7fEcU@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: device-mapper development <dm-devel@redhat.com>, Mark Brown <broonie@kernel.org>, Milan Broz <gmazyland@gmail.com>, Jens Axboe <axboe@kernel.dk>, keith.busch@intel.com, linux-raid@vger.kernel.org, martin.petersen@oracle.com, Mike Snitzer <snitzer@redhat.com>, Baolin Wang <baolin.wang@linaro.org>, linux-block@vger.kernel.org, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, sagig@mellanox.com, tj@kernel.org, dan.j.williams@intel.com, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Wed, 13 Jan 2016, Arnd Bergmann wrote:

> On Tuesday 12 January 2016 18:31:19 Mikulas Patocka wrote:
> > 
> > Another possibility is to use dm-crypt block size 4k and use a filesystem 
> > with 4k blocksize on it (it will never send requests not aligned on 4k 
> > boundary, so we could reject such requests with an error).
> 
> Is there ever a reason to use something other than 4K block size on
> dm-crypt?
> 
> 	Arnd

You can't use 4k block on CBC (and most other encryption modes). If only a 
part of 4k block is written (and then system crash happens), CBC would 
corrupt the block completely.

For example, suppose that EXT2 directory block is updated, the first 
512-byte sector is written and the rest of the sectors is not written 
because of a crash. CBC would corrupt all sectors except the first one in 
this case.

You could use 4k block on XTS and ECB.

Mikulas
