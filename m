From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: RE: dm-devel Digest, Vol 18, Issue 2
Date: Wed, 03 Aug 2005 20:50:35 +0200
Message-ID: <1123095036.21778.41.camel@zezette>
References: <C2EEB4E538D3DC48BF57F391F422779321AB99@SRMANNING.eng.emc.com>
	<1123014429.20148.3.camel@zezette>
	<d6dcfcc90508021449d4de066@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d6dcfcc90508021449d4de066@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christopher Weis <ccweis@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


>         >
>         > Seems like you want to use the "group_by_priority" path
>         grouping policy and
>         > create and get_priority executable which when invoked will
>         return a 1 for 
>         > fast path and 0 for slow path.  See the code for
>         mpath_prio_emc, the
>         > get_priority executable for the EMC CLARiiON array in
>         > multipath-tools/path_priority/pp_emc/pp_emc.c.
>         >
>         Yes, also note "group_by_priority" path grouping policy may be
>         overkill 
>         for the context. PG produced by "group_by_serial" can be
>         sorted with an
>         adequate prioritizer too.
> 
> Does this mean that "group_by_serial" utilizes a
> "default_prio_callout" program/script as well, or is there another
> callout (or something totally different that I'm missing)?
> 
Path prio are fetched in the path discovery phase (via callout, or
defaulting to 1 if no callout specified).

PG policies just decide the path grouping.

There is a implicit notion of PG prio, which is sum(path pio).

group_by_prio is special here : it's a mean for admins to implement a
new pgpolicy without having to hack the tools ... just with shell script
as prio callouts.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
