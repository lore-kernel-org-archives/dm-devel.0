From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: [PATCH multipath-tools-0.4.7.rhel5.13 1/1] multipathd
	excessive path checker logging
Date: Fri, 3 Jul 2009 15:39:24 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907031532560.16482@e-smith.charlieb.ott.istop.com>
References: <Pine.LNX.4.64.0906251344350.4229@e-smith.charlieb.ott.istop.com>
	<20090626205057.GL3172@ether.msp.redhat.com>
	<20090627013921.GA2580@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090627013921.GA2580@mars.virtualiron.com>
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



On Fri, 26 Jun 2009, Konrad Rzeszutek wrote:

> On Fri, Jun 26, 2009 at 03:50:57PM -0500, Benjamin Marzinski wrote:
>> On Thu, Jun 25, 2009 at 01:50:51PM -0400, Charlie Brady wrote:
>>>
>>> multipathd logs a path checker message whenever state changes. But it also
>>> logs every non-changed message when verbosity is >=4 and newstate is
>>> PATH_UP or PATH_GHOST, and every non-changed message when verbosity is >= 2
>>> and newstate is PATH_DOWN.
>>>
>>> I believe that the message should only be logged, once, when state changes.
>>
>> I disagree.  If you look at the stuff that gets logged when verbosity >=
>> 4, you'll see that it's a whole bunch of stuff that normal users would
>> never care about, but may be useful for debugging.  This clearly fits.
>>
>> I also think that having a path down is something that shouldn't just
>> blip by once in the logs.  It's something that often requires the
>> sysadmin to intervene. I could see limitting it to, say, only happen
>> on every tenth pass through the checker loop, so that these messages
>> don't clog up the logs so bad. But since there is the option to set the
>> verbosity to 1 to avoid this, I think that printing the path down
>> messages repeatedly is useful.
>
> Hmm.. What if you have 100 LUNs with four paths, meaning you get 400
> messages saying: "Down! Down! Pants on fire!"

Or, in real life, three LUNS with 16paths each:

http://groups.google.am/group/open-iscsi/browse_thread/thread/95865e5da58a28f2

FWIW, I don't think there is any practical value in posting repeated "path 
down" messages to syslog, and it's wrong to do that at default verbosity 
level.
