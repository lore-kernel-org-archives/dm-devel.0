From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 0/2] Introduce the bulk IV mode for improving
 the crypto engine efficiency
Date: Tue, 12 Jan 2016 21:13:19 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1601122111040.24452@file01.intranet.prod.int.rdu2.redhat.com>
References: <cover.1450233399.git.baolin.wang@linaro.org> <56711C0F.8030105@gmail.com> <CAMz4kuL2b5Qad5iD3odNVh9VO6ctu_M=QE=8fbdC_+ea+5wJ5w@mail.gmail.com> <56885330.9080801@gmail.com> <20160104201343.GQ16023@sirena.org.uk>
 <alpine.LRH.2.02.1601121744400.18228@file01.intranet.prod.int.rdu2.redhat.com> <20160112234025.GF6588@sirena.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160112234025.GF6588@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Jens Axboe <axboe@kernel.dk>, keith.busch@intel.com, linux-raid@vger.kernel.org, martin.petersen@oracle.com, Mike Snitzer <snitzer@redhat.com>, Baolin Wang <baolin.wang@linaro.org>, linux-block@vger.kernel.org, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, sagig@mellanox.com, Arnd Bergmann <arnd@arndb.de>, tj@kernel.org, dan.j.williams@intel.com, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Tue, 12 Jan 2016, Mark Brown wrote:

> On Tue, Jan 12, 2016 at 06:31:19PM -0500, Mikulas Patocka wrote:
> > On Mon, 4 Jan 2016, Mark Brown wrote:
> 
> > > The main thing the out of tree req-dm-crypt code is doing was using a
> > > larger block size which does seem like a reasonable thing to allow
> > > people to tune for performance tradeofffs but I undertand that's a lot
> > > harder to achieve in a good way than one might hope.
> 
> > But as Milan pointed out, that larger block size doesn't work if you 
> > process requests with different sizes - the data encrypted with one 
> > request size won't match if you decrypt them with a different request 
> > size.
> 
> Sure, you need to fix that block size.
> 
> > Does the hardware encryption you are optimizing for allow setting 
> > arbitrary tweaks in XTS mode? What is the specific driver you are 
> > optimizing for?
> 
> This isn't targeted at a specific driver or system, it's trying to make
> dm-crypt better able to make use of hardware acceleration in general.

If the hardware acceleration doesn't allow to set arbitrary XTS tweak, 
then this "large block" optimization on XTS can't be done at all.

So, we need to know which driver(s) you want to optimize for and how do 
those driver(s) handle tweak generation.

Mikulas
