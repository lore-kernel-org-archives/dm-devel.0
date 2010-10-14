From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH] Fix double free and use generic private pointer
 in per-cpu struct
Date: Thu, 14 Oct 2010 21:26:20 +0200
Message-ID: <4CB7595C.4000801@redhat.com>
References: <20101010115941.GA8539@basil.fritz.box>	<4CB1B3B9.4030205@redhat.com>	<20101010130842.GE8256@basil.fritz.box>	<4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com>	<4CB1ECCA.8040801@redhat.com> <20101010170750.GA1475@redhat.com> <4CB20C72.3030504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CB20C72.3030504@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 10/10/2010 08:56 PM, Milan Broz wrote:
> On 10/10/2010 07:07 PM, Mike Snitzer wrote:
> 
>> I'll send patch on top of Andi's v3 if it helps something. (When back to my devel machine).
>> That'll be helpful (I'm sure Andi is interested).
> ok here are my changes on top of v3 - one bugfix and generic IV pointer.
> If you merge it to v4 and it appears in git as one patch I have no problem with that.
> 
> Thanks,
> Milan
> 
> 
> [PATCH] Use generic private pointer in per-cpu struct

Hi Andi,

any progress here?
I would like to achieve some consensus and merge some version
of patch to dm tree...
Maybe with known problems if there is no better solution for now.

Thanks,
Milan
