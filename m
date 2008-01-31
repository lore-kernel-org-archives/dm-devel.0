From: Andy <genanr@emsphone.com>
Subject: multipath multibus performance
Date: Thu, 31 Jan 2008 10:39:18 -0600
Message-ID: <20080131163918.GA10313@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I would like to increase the performance of the multibus mode of multipath. 
It would be nice if multibus performance would be very close to accessing
the device directly.  From what I have been told, under multibus, I/O's are
broken up into bio's and sent down the multiple paths, with no merging of
adjacent I/O's.  Would it be possible to add code to the kernel so that
adjacent (at least some of them, probably make configurable) would be merged
and sent on a single path?  And, would this increase the performance of
multibus mode?  

I would be willing to work on it myself, but I have never done any kernel
coding (I done plenty of C coding) and would not know where to look to even
attempt adding I/O merging to multipath.

What do you think?  Would this work, and how would I go about doing it?

Andy
