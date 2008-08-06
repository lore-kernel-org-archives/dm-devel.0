From: Milan Broz <mbroz@redhat.com>
Subject: Re: [RFC PATCH 0/4] dm core: full barrier support
Date: Wed, 06 Aug 2008 12:33:45 +0200
Message-ID: <48997E09.9040808@redhat.com>
References: <48739A75.1070807@redhat.com>
	<20080806100522.GA3142@develbox.linuxbox.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080806100522.GA3142@develbox.linuxbox.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Cc: nikola.ciprich@linuxbox.cz, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Nikola Ciprich wrote:
> Hi Milan,
> I'd like to ask, what's the current state of barrier support in DM?

Hi,
current state is exactly these patches below. Still applicable for upstream.
It is not in any development tree yet.

> Did You get any feedback? Are there any plans for pushing it to
> mainline?

No, there was no feedback.

Pushing it mainline depends on Alasdair's decision (maintainer of device-mapper).
(It needs thorough review first and maybe better implementation.)

Milan
--
mbroz@redhat.com


> thanks a lot in advance
> BR
> nik
> 
> On Tue, Jul 08, 2008 at 06:48:53PM +0200, Milan Broz wrote:
>> Hi,
>>
>> there was several discussions about supporting barriers
>> in device-mapper.
>>
>> I wrote this code some time ago, but it never reached dm-devel
>> tree. Take this more like RFC and experimental approach
>> - maybe there is better way how to handle it. 
>> Anyway this implementation works in my tests and is relatively simple.
>>
>> [RFC PATCH 1/4] dm core: remove unused code
>> 	- just remove never used code, already sent some time ago
>> 	in another patchset
>>
>> [RFC PATCH 2/4] dm core: add support for empty barriers
>> 	- the core implementation of empty barrier support
>> 	- implementation for stripe target
>>
>> [RFC PATCH 3/4] dm core: add support for barrier bio with payload
>> 	- tranform payload to sequence of data bio + empty barrier
>>
>> [RFC PATCH 4/4] dm core: wait for barrier in process in suspend
>> 	- try to solve the problem that we cannot suspend device
>> 	during processing of barrier.
