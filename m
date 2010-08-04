From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
 vg/lv - xfs
Date: Wed, 4 Aug 2010 13:53:03 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
References: <20100804073546.GA7494@comet.dominikbrodowski.net> <20100804085039.GA11671@infradead.org> <20100804091317.GA27779@isilmar-3.linta.de> <20100804092122.GA2998@infradead.org> <20100804073546.GA7494@comet.dominikbrodowski.net> <201008041116.09822@zmi.at>
 <20100804102526.GB13766@isilmar-3.linta.de> <20100804111803.GA32643@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100804111803.GA32643@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, Michael Monnerie <michael.monnerie@is.it-management.at>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 4 Aug 2010, Christoph Hellwig wrote:

> The good news is that you have it tracked down, the bad news is that I 
> know very little about dm-crypt.  Maybe the issue is the single threaded 
> decryption in dm-crypt?  Can you check how much CPU time the dm crypt 
> kernel thread uses?

I'm not sure it's that. I have a Core i5 with AES-NI and that didn't 
significantly increase my overall performance, as it's not there the 
bottleneck is (at least in my system).

I earlier sent out an email wondering if someone could shed some light on 
how scheduling, block caching and read-ahead works together when one does 
disks->md->crypto->lvm->fs, becase that's a lot of layers and potentially 
a lot of unneeded buffering, readahead and scheduling magic?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
