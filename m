From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 15:08:43 +0200
Message-ID: <20101010130842.GE8256@basil.fritz.box>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CB1B3B9.4030205@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On Sun, Oct 10, 2010 at 02:38:17PM +0200, Milan Broz wrote:
> 
> On 10/10/2010 01:59 PM, Andi Kleen wrote:
> > DM-CRYPT: Scale to multiple CPUs v3
> > 
> > [Due to popular demand this is a port of the dm-crypt scalability
> > patch to 2.6.36-rc7.  The 2.6.35 and .32 patches were widely used by
> > lots of users with good results. 
> > 
> 
> Hi Andi,
> 
> please can you check split patches in
> http://mbroz.fedorapeople.org/dm-crypt/2.6.36-devel/
> 
> is there some change in your new version?

Yes I updated the work queue setup and ported it to
all these changes in 2.6.36.

See the changelog in the description.

I did it intentionally not split up because a split up is unlikely
to be bisectable. I think there is no need for any splitups.

> Can I send this to dm-devel instead? 
> (It is better for review.)

What review? The code has been ready since last merge window at least
and was revied back then is my understanding.

The various versions I posted have been extensively tested
by lots of people, including me.

-Andi
