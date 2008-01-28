From: malahal@us.ibm.com
Subject: Re: About using multipath in SLES 10
Date: Mon, 28 Jan 2008 13:14:39 -0800
Message-ID: <20080128211439.GA18651@us.ibm.com>
References: <479DF5C8.6050909@Voltaire.COM> <20080128163651.GB17040@us.ibm.com>
	<39C75744D164D948A170E9792AF8E7CA110B91@exil.voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <39C75744D164D948A170E9792AF8E7CA110B91@exil.voltaire.com>
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

Erez Zilber [erezz@voltaire.com] wrote:
> I understand. I've tried disktest, and it work ok. I have another
> question - I'm running a single iSCSI initiator against 2 iSCSI
> target. I started disktest on /dev/dm-1 and after a few seconds, I
> disconnected the primary target. It took ~2 minutes until it failed
> over to the secondary device. During these ~2 minutes, it seemed that
> disktest is still reading data from the target, just slower. That's
> very strange. After failover was completed, I was able to use the
> secondary device.

You said, "it seemed that disktest is still reading data from the
target". Maybe it is reading some cached data (read-ahead or some other
such thing...) Also, the multipath kernel module would not know that you
have disconnected the target until an I/O fails. Depending on your error
injection and the susystems design, the I/O failure could be as a result
of a timeout (this depends on your/distro setting, generally 1 minute).

> I have 2 questions:
> 
> 1.	> 	Which parameter in  multipath.conf do I need to change
> in order to failover in a few seconds? Is it polling_interval? I saw
> that the default value is 5 seconds, which should be ok.

Not an expert, but polling interval can't change the failover time. It
may change the 'failback' time though!

> 2.	Before multipath decided that it needs to failover, why did I
> see that traffic is still running? It had no device to work with at
> that time.

Depends on 'how you saw the traffic'! Could be false alarm.
