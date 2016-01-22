From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm pref-path: provides preferred path load balance
 policy
Date: Fri, 22 Jan 2016 11:59:33 -0500
Message-ID: <20160122165932.GA28761@redhat.com>
References: <1453469502-15606-1-git-send-email-ravikanth.nalla@hpe.com>
 <56A231C8.90602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56A231C8.90602@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Ravikanth Nalla <ravikanth.nalla@hpe.com>, linux-kernel@vger.kernel.org, corbet@lwn.net
List-Id: dm-devel.ids

[Hannes please fix your mail client, seems you dropped all the original CCs]

On Fri, Jan 22 2016 at  8:42am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/22/2016 02:31 PM, Ravikanth Nalla wrote:
> > v2:
> >   - changes merged with latest mainline and functionality re-verified.
> >   - performed additional tests to illustrate performance benefits of
> >     using this feature in certain configuration.
> > 
> > In a dm multipath environment, providing end user with an option of
> > selecting preferred path for an I/O in the SAN based on path speed,
> > health status and user preference is found to be useful. This allows
> > a user to select a reliable path over flakey/bad paths thereby
> > achieving higher I/O success rate. The specific scenario in which
> > it is found to be useful is where a user has a need to eliminate
> > the paths experiencing frequent I/O errors due to SAN failures and
> > use the best performing path for I/O whenever it is available.
> > 
> > Another scenario where it is found to be useful is in providing
> > option for user to select a high speed path (say 16GB/8GB FC)
> > over alternative low speed paths (4GB/2GB FC).
> > 
> > A new dm path selector kernel loadable module named "dm_pref_path"
> > is introduced to handle preferred path load balance policy
> > (pref-path) operations. The key operations of this policy is to
> > select and return user specified path from the current discovered
> > online/ healthy paths. If the user specified path do not exist in
> > the online/ healthy paths list due to path being currently in
> > failed state or user has mentioned wrong device information, it
> > will fall back to round-robin policy, where all the online/ healthy
> > paths are given equal preference.
> > 
> > Functionality provided in this module is verified on wide variety
> > of servers ( with 2 CPU sockets, 4 CPU sockets and 8 CPU sockets).
> > Additionally in some specific multipathing configurations involving
> > varied path speeds, proposed preferred path policy provided some
> > performance improvements over existing round-robin and service-time
> > load balance policies.
> > 
> Shouldn't service-time provide similar functionality?
> After all, for all scenarios described above the preferred path
> would have a lower service time, so they should be selected
> automatically, no?

Yes, I'm thinking the same thing.  In fact the service-time also has the
ability to specify 'relative_throughput'
(see: Documentation/device-mapper/dm-service-time.txt).

I'm also missing why different path groups couldn't be used for fast vs
slow paths...

Basically: Ravikanth we need _proof_ that you've exhausted the
capabilities of the existing path selector policies (in conjunction with
path groups)

Not understanding why you verified "some performance improvements" but
stopped short of showing them.
