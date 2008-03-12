From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Date: Thu, 13 Mar 2008 00:07:04 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803130003110.5593@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com> <2008-03-12-19-03-51+trackit+sam@rfc1149.net> <200803122053.13265.chunkeey@web.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755156AbYCLXH1@vger.kernel.org>
In-Reply-To: <200803122053.13265.chunkeey@web.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Chr <chunkeey@web.de>
Cc: Samuel Tardieu <sam@rfc1149.net>, device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, 12 Mar 2008, Chr wrote:
> http://lkml.org/lkml/2008/3/11/377
> (BTW: I'm still bisecting it... can somebody please confirm that 2.6.24-git17
> http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.24-git17.bz2
> was the _last_ "good" one?)

Hm, -git17 locked up hard when trying to access the device mapper
(just like -rc1), not even sysrq was usable any more. Sadly, 
nothing was logged to the disks/network. Will try earlier snapshots 
then. And yes, this resyncing of the md devices after an unclean shutdown 
is a real pita right now...

Thanks for reporting!
Christian.
-- 
BOFH excuse #197:

I'm sorry a pentium won't do, you need an SGI to connect with us.
