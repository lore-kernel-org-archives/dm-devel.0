From: kevin granade <kevin.granade@gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 15:15:03 -0600
Message-ID: <7004b08e0912181315n1894ca90m8752b57708cf55eb@mail.gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <20091217061229.GD3946@linux-sh.org>
	 <m3tyvqgfs4.fsf@intrepid.localdomain>
	 <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	 <24653.1261110557@localhost> <m3my1g1hmr.fsf@intrepid.localdomain>
	 <7004b08e0912180652p42777da3h70906f2fbdb60a69@mail.gmail.com>
	 <Pine.LNX.4.64.0912181137140.23738@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932988AbZLRVPP@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0912181137140.23738@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Valdis.Kletnieks@vt.edu, Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 18, 2009 at 10:43 AM, Mikulas Patocka <mpatocka@redhat.com>=
 wrote:
>> Note: I'm not specifically arguing for keeping the 80-column rule, t=
he
>> project I work on uses 100 columns, and that's quite workable, but I
>> haven't had any problem working with 80 columns as a limit either. =A0=
I
>> do however think that just removing the limit without replacing it
>> with something better is a bad idea.
>>
>> -Kevin Granade
>
> But think what happens when someone views that 100-char code on 80-ch=
ar
> terminal (or for example 94-char, that I used for some times too) ---
> every second line will be wasted with just 20 characters on the left.=
 On
> the other hand, if you have unlimited line length, it will look bette=
r on
> 80-char terminal.

1. I think that is why the limit is at 80 characters, so it's at the
lowest common denominator of screen and will not wrap at all.
(actually wasn't the original limit an email mangling issue?)
2. Aside from choosing the specific limit of 80, I don't think line
wrapping is a major goal of the line length limitation, as I said
before it is a heuristic that is indicative of BAD CODE.  The wrapping
issue is somewhat incidental.
3. I don't trust automated line-wrapping to provide readable code
anyway.  People I think will be much better at doing this, for
example, a common issue is with formatted string functions like scanf.
 A person will (ok, should) know to preferentially wrap after the
format string, and if they are really being nice can generalize about
other things, like name-value pairs:

scanf("%d,%d;%d,%d;%d,%d",
         key1, value1,
         key2, value2,
         key3, value3);

whereas automated wrapping will only know about a limited number of
rules, generally purely syntax-based: (yes, this is somewhat
contrived, but I think it illustrates the kind of limitation I'm
talking about.)

scanf("%d,%d;%d,%d;%d,%d", key1, value1, key2,
         value2, key3, value3);

But this is all really beside the point, if you really want to you can
write a text editor that will unwrap the text for you, and then
re-wrap it exactly how you want it.  I don't think this would be all
that much harder than one that could intelligently wrap the lines in
the first place.

The point I keep coming back to is to follow the *important* coding
guidelines, like avoiding excessive nesting and properly factoring
your code into sub-modules (macros, functions, inlined functions, etc.
as appropriate.)  The line limit acts as a warning that you are
probably doing something wrong, just shortening the line in question
is not the answer.

Other incidental issues:
"wasting lines" - Don't care, factor properly and a single unit of
code should fit in a screenfull or two.
"effort wasted manually wrapping lines" - Also don't care, if you
think the text editor should be smart enough to wrap lines
intelligently, just use it to do it for you.  (hint: they're generally
not actually that smart).  Also consider the alternative there, if
multi-hundred character lines are the norm, just how easy are the
contents of those lines to manipulate?

>
> Mikulas
>
