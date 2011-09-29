From: <jerome.levy@emc.com>
Subject: Re: dm-devel Digest, Vol 91, Issue 27
Date: Thu, 29 Sep 2011 12:09:05 -0400
Message-ID: <72AE4C5076364440BADFFCCB0A60785B02F6EE0A77@MX02A.corp.emc.com>
References: <mailman.37.1317312007.19352.dm-devel@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <mailman.37.1317312007.19352.dm-devel@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

> And if, for some reason, multipathd wasn't monitoring a path it should
> be, the best thing to do is to reconfigure multipathd.  Code that
> watched multipath.conf and automatically reconfigured multipathd when it
> changed would be a nice addition though.

I'd suggest an explicit warning of unmonitored paths in syslog rather than an automagic reconfiguration. A simple typo in multipath.conf could cause the loss of a whole lot of data if automatic reconfigs are happening. 

- Jerry
