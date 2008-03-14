From: Milan Broz <mbroz@redhat.com>
Subject: Re: INFO: task mount:11202 blocked for more than 120
	seconds
Date: Fri, 14 Mar 2008 10:27:07 +0100
Message-ID: <47DA44EB.8000307@redhat.com>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de>
	<20080307224040.GV155259@sgi.com>
	<alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
	<20080309213441.GQ155407@sgi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080309213441.GQ155407@sgi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Chinner <dgc@sgi.com>
Cc: Christian Kujau <lists@nerdbynature.de>, dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
List-Id: dm-devel.ids

David Chinner wrote:
>>> Also, the iolock can be held across I/O so it's possible you've lost an 
>>> I/O. Any I/O errors in the syslog?
>> No, no I/O errors at all. See the kern.log above, I could even do dd(1) 
>> from the md1 (dm-crypt on raid1), no errors either.
> 
> Oh, dm-crypt. Well, I'd definitely start looking there. XFS has a
> history of exposing dm-crypt bugs, and these hangs appear to be I/O
> congestion/scheduling related and not XFS. Also, we haven't changed
> anything related to plug/unplug of block devices in XFS recently, so
> that also points to some other change as well...

Yes, there is bug in dm-crypt...
Please try if the patch here helps: http://lkml.org/lkml/2008/3/14/71

Thanks,
Milan
--
mbroz@redhat.com
