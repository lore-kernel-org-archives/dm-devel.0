From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Date: Thu, 13 Mar 2008 22:54:25 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803132249060.7433@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803130003110.5593@sheep.housecafe.de> <alpine.DEB.1.00.0803131444480.7433@sheep.housecafe.de> <200803132233.47516.chunkeey@web.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757741AbYCMVyn@vger.kernel.org>
In-Reply-To: <200803132233.47516.chunkeey@web.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Chr <chunkeey@web.de>
Cc: Samuel Tardieu <sam@rfc1149.net>, device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, 13 Mar 2008, Chr wrote:
> On Thursday 13 March 2008 14:45:39 Christian Kujau wrote:
>> and so does -git8 and -git9...sigh :(
>
> hmm, I can boot any of these -rcX-gitY kernels (but not without some stuck
> tasks after about a hour or so...)

Ah, when you said -git17 would be the last "good" kernel, I thought 
everything earlier would not have the stuck tasks.

> but back: I tried lockdep and ran into this: (debug blocker)

I have lockdep enabled as well, but no warnings so far...

> sounds a bit strange? Is this a SMP related problem after all?

I don't think so, as I don't have an SMP system (and CONFIG_SMP is 
disabled as well).

C.
-- 
BOFH excuse #441:

Hash table has woodworm
