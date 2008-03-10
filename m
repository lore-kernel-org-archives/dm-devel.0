From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Date: Mon, 10 Mar 2008 02:46:38 +0100 (CET)
Message-ID: <alpine.DEB.1.00.0803100235230.9443@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753823AbYCJBq5@vger.kernel.org>
In-Reply-To: <20080309213441.GQ155407@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 10 Mar 2008, David Chinner wrote:
> Oh, dm-crypt. Well, I'd definitely start looking there. XFS has a
> history of exposing dm-crypt bugs, and these hangs appear to be I/O
> congestion/scheduling related and not XFS.

Yeah, I noticed that too, thanks for verifying this: during the 2nd bisect 
run, the box locked up hard when I accessed the device-mapper. I'm using a 
wrapper script to set up my luks/dm-crypt devices and still have to find 
out which command exactly triggers the lockup. So, maybe the hard lockup 
and the hangs are not so unrelated after all...oh well.

> Also, we haven't changed
> anything related to plug/unplug of block devices in XFS recently, so
> that also points to some other change as well...

Thanks for your assistance, David, I really appreciate it. I'll try to 
find out more about this dm-crypt thingy....

Christian.
-- 
BOFH excuse #396:

Mail server hit by UniSpammer.
