From: Ron Peterson <rpeterso@mtholyoke.edu>
Subject: Re: kpartx and udev
Date: Tue, 3 Jun 2008 12:39:07 -0400
Message-ID: <20080603163907.GF20339@localhost.localdomain>
References: <20080603163649.GE20339@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080603163649.GE20339@localhost.localdomain>
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

2008-06-03_12:36:49-0400 Ron Peterson <rpeterso@mtholyoke.edu>:

> #!/bin/sh
> (
> sleep 1
> /sbin/kpartx %1 %2
> ) &

That should read $1 $2 of course....

-- 
Ron Peterson
Network & Systems Manager
Mount Holyoke College
http://www.mtholyoke.edu/~rpeterso
-
I wish my computer would do what I want it to do - not what I tell it to do.
