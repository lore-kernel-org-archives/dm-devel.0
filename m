From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [dm-devel] Barriers still not passing on simple dm devices...
Date: Sun, 05 Apr 2009 18:24:13 -0700
Message-ID: <49D959BD.7060002@redhat.com>
References: <20090324150517.GX27476@kernel.dk>	 <Pine.LNX.4.64.0903251825310.8027@hs20-bc2-1.build.redhat.com>	 <20090326084205.GG27476@kernel.dk>	 <Pine.LNX.4.64.0903302314500.6158@hs20-bc2-1.build.redhat.com>	 <20090331104933.GJ5178@kernel.dk>	 <Pine.LNX.4.64.0904021923040.19415@hs20-bc2-1.build.redhat.com>	 <20090403081131.GP5178@kernel.dk> <49D77AC3.3020207@redhat.com>	 <20090405012839.GF7553@mit.edu> <49D89C06.1060700@gmail.com> <75b66ecd0904051814n353bb69bp76a38e36cac4d3fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757188AbZDFBZI@vger.kernel.org>
In-Reply-To: <75b66ecd0904051814n353bb69bp76a38e36cac4d3fe@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Revell <rlrevell@joe-job.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>, Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ak@linux.intel.com, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>
List-Id: dm-devel.ids

On 04/05/2009 06:14 PM, Lee Revell wrote:
> On Sun, Apr 5, 2009 at 7:54 AM, Ric Wheeler<ricwheeler@gmail.com>  wrote:
>> One thing to point out here is that there are a lot of "servers" in high end
>> data centers that do not have UPS backup. Those racks full of 1U and 2U
>> boxes that are used to make "grids", "clouds" and so on often are built with
>> as much gear as you can stuff in a rack - no batteries or UPS to be seen, so
>> they are really quite similar to the normal desktop or home systems that we
>> normally run at home :-)
>
> These days even bargain basement data centers provide UPS functionality for
> you, via generator backup and A/B power.
>
> Lee

In my experience, you will see multiple customers with and without UPS backup.

I have certainly dealt personally with many data centers that lost power without 
them & see array vendors that continue to build in their own batteries...

ric
