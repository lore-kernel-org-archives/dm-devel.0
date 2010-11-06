From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: RFC: multipath IO multiplex
Date: Sat, 6 Nov 2010 11:51:02 +0000
Message-ID: <20101106115102.GF10171@agk-dp.fab.redhat.com>
References: <20101105183946.GG25992@suse.de> <20101106053203.7e4ef435@notabene>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101106053203.7e4ef435@notabene>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>, device-mapper development <dm-devel@redhat.com>, lmb@novell.com
List-Id: dm-devel.ids

On Sat, Nov 06, 2010 at 05:32:03AM -0400, Neil Brown wrote:
>  Might it make sense to configure a range of the device where writes always
>  went down all paths?  That would seem to fit with your problem description
>  and might be easiest??

Indeed - a persistent property of the device (even another interface with a
different minor number) not the I/O.

And what is the nature of the data being written, given that I/O to one path
might get delayed and arrive long after it was sent, overwriting data
sent later.  Successful stale writes will always be recognised as such
by readers - how?
 
Alasdair
