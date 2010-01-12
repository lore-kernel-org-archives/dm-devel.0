From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/1] dm-raid45
Date: Tue, 12 Jan 2010 15:44:28 +0100
Message-ID: <1263307468.1346.9.camel@o>
References: <1259243112-28175-1-git-send-email-heinzm@redhat.com>
	 <e9c3a7c20912081638w39469743n76b4114b840f1c43@mail.gmail.com>
	 <1260380840.9639.99.camel@o>
	 <e9c3a7c20912210848u3f6ced7cvc57aec586ff7c0ef@mail.gmail.com>
Reply-To: heinzm@redhat.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20912210848u3f6ced7cvc57aec586ff7c0ef@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, 2009-12-21 at 09:48 -0700, Dan Williams wrote:
> On Wed, Dec 9, 2009 at 10:47 AM, Heinz Mauelshagen <heinzm@redhat.com> wrote:
> > On Tue, 2009-12-08 at 17:38 -0700, Dan Williams wrote:
> >> On Thu, Nov 26, 2009 at 6:45 AM,  <heinzm@redhat.com> wrote:
> >> > From: Heinz Mauelshagen <heinzm@redhat.com>
> >> >
> >> > Neil et al.,
> >> >
> >> > finally got around to creating a followup (interim) patch, which allows
> >> > for changing the xor algorithn at runtime via the message interface,
> >> > hence allowing to test if the xor unrole optimization around the
> >> > supported algorithms is performing better than the assembler
> >> > optimized one in the kernel.
> >>
> >> Now that perf is available it would be good to get some comparative
> >> cache utilization statistics on the two approaches.
> >
> > I'd appreciate it.
> > Do you have any time to spend on this comparison ?
> >
> 
> I can give it a shot.

Thanks.

>  The easiest way to test would be to export your
> versions via a struct xor_block_template.

Yes, but my recent dm-raid45 patch on dm-devel allows for selection of
the xor routine being used and its parameters..

Fiddling the macros into xor_block_template structs would allow for
testing them with other callers...

>  However, the question I
> have is how do your macros differ from the existing ones in
> include/asm-generic/xor.h?

Those xor data from multiple blocks via sequenced single xor operations
whereas mine does them in one go.

> Can we achieve the same effect by
> extending the ones in include/asm-generic/xor.h to do up to 8 at a
> time?

I don't think so but that's one question to answer.

Thanks,
Heinz

> 
> Thanks,
> Dan
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

