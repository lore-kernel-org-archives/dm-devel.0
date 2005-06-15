From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [patch] dm-mpath pg_init could race with destructor
Date: Wed, 15 Jun 2005 13:21:34 -0500
Message-ID: <42B071AE.4040305@cs.wisc.edu>
References: <20050615071946.GA765@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050615071946.GA765@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Lars Marowsky-Bree wrote:
> Why send a pg_init request at this point if there are no queued ios?
> This was in fact my solution, to only send a pg_init io if there are
> queued ios.
> 

Are there management situations where some admin wants to manually 
switch. If he was going to take a controller temporarily offline for 
maitnenance for example? Will multipath tools and dm-mutlipath be used 
to do this type of management, or will it be some vendor specific tool 
that sends a SG_IO directly?

It would not be possible to just have dm-multipath increment some 
refcount like pending so you cannot destroy things while a pg_init IO is 
in flight would it?
