From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: a deadlock bug in the kernel-side device mapper code
Date: Thu, 5 Nov 2009 14:24:35 +0000
Message-ID: <20091105142435.GQ13375@agk-dp.fab.redhat.com>
References: <4AF2D176.4010000@actcom.co.il>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AF2D176.4010000@actcom.co.il>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: guy keren <choo@actcom.co.il>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 05, 2009 at 03:21:58PM +0200, guy keren wrote:
> below is the stack trace of the self-deadlocking code. this is one of  
> the threads of multipathd, that attempts to remove a dm device using a  
> ioctl to the dm driver:

Yes, thanks for reporting this.

This only happens if there are some uevents still waiting to be sent
when the device is being destroyed, but it does need to be fixed.

Alasdair
