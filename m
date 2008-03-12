From: Chr <chunkeey@web.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Date: Wed, 12 Mar 2008 20:53:12 +0100
Message-ID: <200803122053.13265.chunkeey@web.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com> <2008-03-12-19-03-51+trackit+sam@rfc1149.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753643AbYCLTzD@vger.kernel.org>
In-Reply-To: <2008-03-12-19-03-51+trackit+sam@rfc1149.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Samuel Tardieu <sam@rfc1149.net>
Cc: device-mapper development <dm-devel@redhat.com>, Christian Kujau <lists@nerdbynature.de>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
List-Id: dm-devel.ids

On Wednesday 12 March 2008 19:03:51 Samuel Tardieu wrote:
>
> David> Oh, dm-crypt. Well, I'd definitely start looking there. XFS has
> David> a history of exposing dm-crypt bugs, and these hangs appear to
> David> be I/O congestion/scheduling related and not XFS. Also, we
> David> haven't changed anything related to plug/unplug of block
> David> devices in XFS recently, so that also points to some other
> David> change as well...
>
me too... 

http://lkml.org/lkml/2008/3/11/377
(BTW: I'm still bisecting it... can somebody please confirm that 2.6.24-git17 
http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.24-git17.bz2
was the _last_ "good" one?)  

BTW:
by pressing "SYSRQ-S (Emerg. Sync)" over and over again can unlock
some but not all "D" tasks... 

Regards,
	Chr.
