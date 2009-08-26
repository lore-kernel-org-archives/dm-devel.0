From: "NeilBrown" <neilb@suse.de>
Subject: Re: Re: New kernel shared snapshots
Date: Wed, 26 Aug 2009 12:25:15 +1000 (EST)
Message-ID: <add48320b3d3f0c81fe6675c6dc24b1a.squirrel@neil.brown.name>
References: <Pine.LNX.4.64.0907270657080.527@hs20-bc2-1.build.redhat.com>
	<805301CC-A5EA-4905-9867-0B4762B63D8E@redhat.com>
	<Pine.LNX.4.64.0908251026430.19589@hs20-bc2-1.build.redhat.com>
	<20090826020236.GA5681@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090826020236.GA5681@infradead.org>
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
Cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Wed, August 26, 2009 12:02 pm, Christoph Hellwig wrote:
> On Tue, Aug 25, 2009 at 10:43:33AM -0400, Mikulas Patocka wrote:
>>
>> I mean, if I have function
>> static struct some_structure *some_function(int a, int b, int c,
>>                                             int d, long long e,
>>                                             struct blablabla *p)
>
> Don't align additional paramter lines to after the opening brace,
> but always two tabs from column zero, e.g.
>
> static struct some_structure *some_function(int a, int b, int c,
> 		int d, long long e, struct blablabla *p)
>
> also much easier to edit, especially if the function name and/or return
> type changes.

(bike shedding alert!)

Can't say I agree with that.  I think the content of a parethesised
group should always be to the right of the opening parenthesis unless
that paranthesis (or bracket or brace) is at the end of the line.
So:

static struct some_structure *some_function(
        int a, int b, int c, int d,
        long long e, struct blablabal *p)

would be a better option.
Though in this case I would got for:

static struct some_structure *
some_function(argument go here....)

NeilBrown
