From: Edward Goggin <egoggin@emc.com>
Subject: RE: patch to dm-emc.c
Date: Tue, 29 Aug 2006 16:57:10 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1389@CORPUSMX40A.corp.emc.com>
References: <44DBA4CB.8030600@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <44DBA4CB.8030600@cs.wisc.edu>
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
Cc: michaelc@cs.wisc.edu, agk@redhat.com
List-Id: dm-devel.ids

On Thursday, August 10, 2006 5:28 PM, Mike Christie wrote
=20
> But I thought, a request should eventually complete and so we=20
> should be
> woken up from get_request_wait, and we will try allocate a=20
> request again
> and then the write request count should have gone down and we=20
> should be
> able to proceed.

Mike,

You are right.  My logic was bad ... I was confusing mapped and
target device queues.  Turns out the delays that I am seeing
(multipathd checker thread is stuck waiting for up to 15 minutes
waiting for a free target device queue) are due to ios being
held and timed out by the SCSI LLD (Emulex).  I never waited
more than 10 minutes in my testing earlier in the month before
looking for some type of deadlock.

I've changed the patch to call blk_get_request() with __GFP_WAIT
always from a worker thread context since using pre-allocated
request structures does not help the problem.

Thanks,

Ed
