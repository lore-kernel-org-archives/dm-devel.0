From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: ALUA - rescan device capacity on zero sized block
 devices
Date: Tue, 14 Apr 2015 11:49:54 +0200
Message-ID: <552CE2C2.8000809@sandisk.com>
References: <1887682221.152035.1428939145196.JavaMail.zimbra@kangaroot.net>
	<552C008A.9070201@sandisk.com>
	<987831457.156812.1428996031503.JavaMail.zimbra@kangaroot.net>
	<552CCC77.9040703@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <552CCC77.9040703@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 04/14/15 10:14, Hannes Reinecke wrote:
> What we can try is to listen to uevents for the device capacity
> change or ALUA state changes, and retry the read capacity for those
> events.

Any mechanism that relies on uevents would be asynchronous. We need a 
way to ensure that the capacity data is up to date before any 
application starts using that data. In this context that means before 
multipath starts queueing I/O to a path. This might be challenging when 
processing uevents asynchronously ...

Bart.
