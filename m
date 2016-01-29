From: "Nalla, Ravikanth" <ravikanth.nalla@hpe.com>
Subject: RE: [PATCH v2] dm pref-path: provides preferred path load balance
 policy
Date: Fri, 29 Jan 2016 14:10:52 +0000
Message-ID: <49D617FA63152941907AADE32CF072F12FD72905@G4W3202.americas.hpqcorp.net>
References: <1453469502-15606-1-git-send-email-ravikanth.nalla@hpe.com>
 <56A231C8.90602@suse.de> <20160122165932.GA28761@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160122165932.GA28761@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>
List-Id: dm-devel.ids

Hi Mike, Hannes, Ben

On 1/22/2016 10:29 PM, Mike Snitzer wrote:

 [Hannes please fix your mail client, seems you dropped all the original CCs]

On Fri, Jan 22 2016 at  8:42am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/22/2016 02:31 PM, Ravikanth Nalla wrote:
> > 
> > Functionality provided in this module is verified on wide variety of 
> > servers ( with 2 CPU sockets, 4 CPU sockets and 8 CPU sockets).
> > Additionally in some specific multipathing configurations involving 
> > varied path speeds, proposed preferred path policy provided some 
> > performance improvements over existing round-robin and service-time 
> > load balance policies.
> > 
> Shouldn't service-time provide similar functionality?
> After all, for all scenarios described above the preferred path would 
> have a lower service time, so they should be selected automatically, 
> no?

Yes you are right that in case if the user is preferring a path because of its path speed, it will have a lower service time and so behavior of service time policy will be similar to the preferred path policy that we proposed. However another reason for proposing this policy is a scenario where user want to totally eliminate a particular path which is flaky and behaving in a unpredictable manner. In this case, service time policy may still schedule I/O on this path as randomly it may demonstrate better service time but the overall I/O performance over a period of time could be affected and so in this scenario selecting a known good preferred path will be beneficial was our thinking. In fact when we did comparative testing our policy with service time in a setup with varying path speeds ( 8
 Gig FC and 4Gig FC) we saw the following results which showed that our policy fared marginally better than the service-time policy.

service-time:
    io/sec    MB/sec    (msec)    Max Response Time 
   =======    ======    ======   =============
   1383.2    1450.3    23.132      44.7 

pref-path:
    io/sec    MB/sec    (msec)    Max Response Time 
   =======    ======    ======   =============
   1444.3    1514.5    22.152      37.4

> Yes, I'm thinking the same thing.  In fact the service-time also has the ability to specify 'relative_throughput'
> (see: Documentation/device-mapper/dm-service-time.txt).

Thanks for suggestion to look at the 'relative_throughput' feature associated with service-time. After your comment, I could see from the code how this feature works but unfortunately we are not able to find documentation on how to specify this in the multipath.conf file. May be we are not looking at the right place and if you have further pointers on how to use this feature, that will be helpful.

> I'm also missing why different path groups couldn't be used for fast vs slow paths...
> Basically: Ravikanth we need _proof_ that you've exhausted the capabilities of the existing path selector policies (in conjunction with path groups)

I assume you are referring to specifying following in multipath.conf file ( prio_args having the path to be preferred )

multipath{
	prio "weightedpath"
	prio_args "devname sdp 1"
	path_grouping_policy group_by_prio
}

Yes with this way it  that it is possible to lock the path to a specific path similar to what we have proposed. However having used this feature, it appears that it is not that intuitive to use it and also need multiple configuration parameters to be specified in the conf file. Hence the main intention with which we  provided this feature was to  provide a more intuitive way to specify a user preferred path.

>Not understanding why you verified "some performance improvements" but stopped short of showing them.

The performance improvements that we observed are shown above. Actually we never intended this to be a performance feature as our intention was to provide users with an easier option to specify a preferred path in scenarios like flaky SAN environments and so that's why we did not mention it earlier.

>On 1/22/2016 10:36 PM, Benjamin Marzinski wrote:

> This seems like a problem that has already been solved with path groups.
> If the path(s) in your preferred path group are there, multipath will use them.  If not, then it will use your less preferred path(s), and load balance across them > how ever you choose with the path_selectors.

> I admit that we don't have a path prioritizer that does a good job of allowing users to manually pick a specific path to prefer.  But it seems to me that there is > >where we should be solving the issue.

Yes as  mentioned , it appears that we will be able to achieve the same result using the above multipath{...} configuration. However as you mentioned I felt that it is not that user friendly in specify the path to prefer. So when you mentioned about solving the problem there, could you please clarify on what you had in mind and is there anything specific from our implementation that can be used there ?
