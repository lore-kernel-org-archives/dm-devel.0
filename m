From: Toon van der Pas <toon@hout.vanvergehaald.nl>
Subject: What's the status on I/O-stats for dm block devices?
Date: Tue, 22 Nov 2005 23:37:03 +0100
Message-ID: <20051122223701.GA23045@shuttle.vanvergehaald.nl>
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

Hi,

I'm running a newsserver with the newsspool on LVM2.
It's working great for years already. Thanks for the great software!

Question: Device mapper doesn't provide I/O-statistics yet.
I found a bug in de Linux kernel bug tracker about this topic,
with a patch from Kevin Corry. I added a comment to the bug report,
asking about the status of the patch, and got a reply from Jens Axboe.
He advised me to ask my question on this list.

See: http://bugme.osdl.org/show_bug.cgi?id=1806

Could anybody comment on Jens' reply, and tell me wether we can
expect a solution? I can't imagine I'm the only one needing this...

Thanks.
