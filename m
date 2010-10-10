From: Milan Broz <mbroz@redhat.com>
Subject: Re: DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 18:41:46 +0200
Message-ID: <4CB1ECCA.8040801@redhat.com>
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101010162257.GA1272@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>, device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 10/10/2010 06:22 PM, Mike Snitzer wrote:
> If you feel you shouldn't be doing any more to your split patches then
> I'll review all of this closer tomorrow.

I think there was small bugfix in my patchset (some missing free in error path)
and I change to use generic per-cpu IV struct (not ESSIV only) -
see patch already sent here https://www.redhat.com/archives/dm-devel/2010-July/msg00118.html

Others are just small code shuffle changes (which I know agk is doing to all patches;-)

I'll send patch on top of Andi's v3 if it helps something. (When back to my devel machine).

Milan
