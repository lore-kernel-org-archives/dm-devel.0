From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 15:09:41 +0200
Message-ID: <20101010130941.GF8256@basil.fritz.box>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
 <4CB1B762.90900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CB1B762.90900@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sun, Oct 10, 2010 at 02:53:54PM +0200, Milan Broz wrote:
> On 10/10/2010 02:38 PM, Milan Broz wrote:
> 
> > is there some change in your new version?
> Of course I mean except the changes you mentioned which are easy
> to change in my patchset:-)
> 
> (There was requirement from agk to have several simple
> bisectable patches.)

Well my patch is bisectable.

I don't see how it can be split up without being not functional
in the middle.

Either you have per cpu data or you don't.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
