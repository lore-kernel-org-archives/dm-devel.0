From: Milan Broz <mbroz@redhat.com>
Subject: Re: [BUG] Oops caused by FEC in 4.10.0
Date: Fri, 17 Mar 2017 17:29:34 +0100
Message-ID: <6a654fb0-f6db-1ffa-a8eb-4da2eff07ada@redhat.com>
References: <CAMKhuNG_AKfY_EB9C_Y-8q7sR+9u+Mn9w-hb1YvZQBCNLC_-ww@mail.gmail.com>
	<20170315221223.GA116381@samitolvanen.mtv.corp.google.com>
	<accf7e0f-1964-6e19-9453-a1c27e3666d4@redhat.com>
	<20170317153503.GA52633@samitolvanen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170317153503.GA52633@samitolvanen.mtv.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sami Tolvanen <samitolvanen@google.com>
Cc: michal virgovic <michalvirgovic1@gmail.com>, dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On 03/17/2017 04:35 PM, Sami Tolvanen wrote:
> On Fri, Mar 17, 2017 at 12:45:00PM +0100, Milan Broz wrote:
>> it still does take at least two minutes and tons of logs until even
>> udev scan finishes on a device with incorrect FEC attributes.
> 
> If dm-verity is set up with invalid arguments so that the entire partition
> is corrupt, it does take a while to determine this with FEC as it attempts
> to correct both metadata and data blocks before giving up. It also depends
> on the random read performance of the underlying hardware obviously.

Sure, no problem with that. Just this testing device was the smallest
possible size (4k) so almost 2 minutes for FEC repairs was quite unexpected :)

>> And once it is finished, dm-verity crashes on dm-device removal...
> 
> That's interesting, I haven't seen this before. Looks like something goes
> wrong at the very end of dm_bufio_client_destroy. I'm not familiar enough
> with dm_bufio internals to immediately tell why though.
> 
>> Could we please have all crucial fixes upstream?
> 
> Sorry, there are no other pending fixes remaining in our tree.

Ok, so it is a new bug then. Sorry for being grumpy, I was just trying
to setup trivial verity device to test activation code in veritysetup
(this part was not in initial commit at all) and every attempt to test
table format ended in kernel OOPs.

We should fix all this problems because it smells like a DoS problem
(someone modifies on-disk FEC data to intentionally crash kernel).

Anyway, Michal (our student intern) should help with testing
(and veritysetup code as well), so if you have any patches, please send
it to the dm-devel list and cc him.

Thanks!
Milan
