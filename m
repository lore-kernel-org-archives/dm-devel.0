From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] dm pref-path: provides preferred path load
 balance policy
Date: Sat, 30 Jan 2016 17:32:28 -0600
Message-ID: <20160130233228.GF24960@octiron.msp.redhat.com>
References: <1453469502-15606-1-git-send-email-ravikanth.nalla@hpe.com>
 <56A231C8.90602@suse.de>
 <20160122165932.GA28761@redhat.com>
 <49D617FA63152941907AADE32CF072F12FD72905@G4W3202.americas.hpqcorp.net>
 <20160129175059.GB24960@octiron.msp.redhat.com>
 <56AC7535.2090401@suse.de>
 <20160130202525.GE24960@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160130202525.GE24960@octiron.msp.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Nalla, Ravikanth" <ravikanth.nalla@hpe.com>
List-Id: dm-devel.ids

On Sat, Jan 30, 2016 at 02:25:25PM -0600, Benjamin Marzinski wrote:
> Before this commit, it always used the pref bit. Again, like I said
> before, I'm saying that this was the wrong thing to do.  The Spec is

Oops. I meant: "I'm NOT saying that this was the wrong thing to do".

I am also fine with changing the default back to making the pref bit
always create it's own path group. As long there is a way for users to
get either behavior, I'm happy.

-Ben

> pretty vague on what you should expect to happen when you set to pref
> bit.  When the path was in a group by itself, I got complaints. Now that
> the path is is a group with other active/optimized paths, I get
> complaints.  The only answer is to allow the user to say what they want
> the pref bit to mean.
> 
> -Ben 
