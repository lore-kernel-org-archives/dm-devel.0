From: Milan Broz <mbroz@redhat.com>
Subject: Re: Barrier support in device mapper
Date: Thu, 18 Sep 2008 08:57:02 +0200
Message-ID: <48D1FBBE.4080305@redhat.com>
References: <200809181127.37704.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200809181127.37704.knikanth@suse.de>
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
Cc: Andi Kleen <andi@firstfloor.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Nikanth Karthikesan wrote:
> Are we going to get full-barrier support soon? If not, I would like to see 
> Andi's patch being merged till we get full barrier support ready. I would like 
> to know your thoughts.

Hi,
Andi's patch is not complete and I think there can be several problems with it:

- imagine DM device which has barrier support switched on by this simple patch and
you try to run pvmove on it. How is the barrier request processed by underlying
devices now?

-> mapping can change online (pvmove, lvextend, lvconvert, ...) to more
complicated mapping - who reset barrier flag support?

- what about stacking devices? Imagine crypto - there is one device per
table possible under linear target (where you enable barriers by this patch).
dm-crypt will need to implement some queue flushes to properly support
barriers. Another example - partition mapping over multipath (kpartx), ...
Are you sure that is it safe with Andi's patch?
...

It is dangerous to use that patch IMO, better not support barriers at all here.
That's why we need something more robust.

Unfortunately I received _no_ feedback to mentioned RFC barrier patches.

Milan
--
mbroz@redhat.com
