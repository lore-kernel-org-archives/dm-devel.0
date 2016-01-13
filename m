From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-devel] [PATCH v2 0/2] Introduce the bulk IV mode for
 improving the crypto engine efficiency
Date: Wed, 13 Jan 2016 08:01:01 +0100
Message-ID: <5695F62D.3050705@gmail.com>
References: <cover.1450233399.git.baolin.wang@linaro.org>
 <20160104201343.GQ16023@sirena.org.uk>
 <alpine.LRH.2.02.1601121744400.18228@file01.intranet.prod.int.rdu2.redhat.com>
 <5514385.nEhTK7fEcU@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5514385.nEhTK7fEcU@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mark Brown <broonie@kernel.org>, Milan Broz <gmazyland@gmail.com>, Jens Axboe <axboe@kernel.dk>, keith.busch@intel.com, linux-raid@vger.kernel.org, martin.petersen@oracle.com, Mike Snitzer <snitzer@redhat.com>, Baolin Wang <baolin.wang@linaro.org>, linux-block@vger.kernel.org, neilb@suse.com, LKML <linux-kernel@vger.kernel.org>, sagig@mellanox.com, tj@kernel.org, dan.j.williams@intel.com, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 01/13/2016 12:38 AM, Arnd Bergmann wrote:
> On Tuesday 12 January 2016 18:31:19 Mikulas Patocka wrote:
>>
>> Another possibility is to use dm-crypt block size 4k and use a filesystem 
>> with 4k blocksize on it (it will never send requests not aligned on 4k 
>> boundary, so we could reject such requests with an error).
> 
> Is there ever a reason to use something other than 4K block size on
> dm-crypt?

Most existing sw FDE systems use 512bytes blocks. I would like to see
configurable block size (at least up to 4k) but as Mikulas pointed out
it opens several new problems. 

Anyway, I do not see reason why crypto accelerators should not process
these small sectors better - just hw must be designed for it.

Milan
