From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [PATCH and question]: dm-table should check for valid
	queue]
Date: Tue, 15 Aug 2006 12:02:04 +0200
Message-ID: <44E19B9C.1010604@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


> On Thu, Aug 10, 2006 at 01:29:08PM +0200, Stefan Bader wrote:
>> But what effect should a missing queue have? Same
>> as device is congested or not or let the call fail somehow?
>  
> I'm curious - under what circumstances is this missing:
> Is it intentional, or is it perhaps a race that needs fixing?
> 

More or less intentional. If a device is (virtually) ripped from the
system the driver will throw everything away. Device-mapper still has a
reference to the bdev but the queue is cleaned and removed.
I am not sure whether the any congested call would ever be triggered in
that situation. But at least the unplug all is when user-space tries to
change the maps to remove or replace the missing device. And very likely
the flush all call would be used as well (probably after that).

Stefan
