From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2] dm pref-path: provides preferred path load balance
 policy
Date: Fri, 29 Jan 2016 11:50:59 -0600
Message-ID: <20160129175059.GB24960@octiron.msp.redhat.com>
References: <1453469502-15606-1-git-send-email-ravikanth.nalla@hpe.com>
 <56A231C8.90602@suse.de>
 <20160122165932.GA28761@redhat.com>
 <49D617FA63152941907AADE32CF072F12FD72905@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49D617FA63152941907AADE32CF072F12FD72905@G4W3202.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nalla, Ravikanth" <ravikanth.nalla@hpe.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>
List-Id: dm-devel.ids

On Fri, Jan 29, 2016 at 02:10:52PM +0000, Nalla, Ravikanth wrote:
> Hi Mike, Hannes, Ben
> > This seems like a problem that has already been solved with path groups.
> > If the path(s) in your preferred path group are there, multipath will use them.  If not, then it will use your less preferred path(s), and load balance across them > how ever you choose with the path_selectors.
> 
> > I admit that we don't have a path prioritizer that does a good job of allowing users to manually pick a specific path to prefer.  But it seems to me that there is > >where we should be solving the issue.
> 
> Yes as  mentioned , it appears that we will be able to achieve the same result using the above multipath{...} configuration. However as you mentioned I felt that it is not that user friendly in specify the path to prefer. So when you mentioned about solving the problem there, could you please clarify on what you had in mind and is there anything specific from our implementation that can be used there ?
> 

There are two changes that I'm working on.

1. I'm adding an option for the alua prioritizer so that setting the
ALUA TPG Preferred Bit will cause the alau prioritizer to put that path
in a group by itself (with the highest priority). Currently if the
preferred bit is set for an active/optimized path, and there are other
active/optimized paths, they are all grouped together, and there is no
way to change that. So, for people with ALUA enabled hardware, they can
just enable the option, and set the Preferred Bit.

2. For people that need to be able to control the exact priority, I'm
redoing the weighted handler to allow better ways to specify the paths
in a presistent manner.  It won't be as simple as the alua method, but
it will be actually usable, unlike it's current state.

-Ben
