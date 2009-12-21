From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [dm-devel] [PATCH v2 1/1] dm-raid45
Date: Mon, 21 Dec 2009 09:48:08 -0700
Message-ID: <e9c3a7c20912210848u3f6ced7cvc57aec586ff7c0ef@mail.gmail.com>
References: <1259243112-28175-1-git-send-email-heinzm@redhat.com>
	 <e9c3a7c20912081638w39469743n76b4114b840f1c43@mail.gmail.com>
	 <1260380840.9639.99.camel@o>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1260380840.9639.99.camel@o>
Sender: linux-raid-owner@vger.kernel.org
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Dec 9, 2009 at 10:47 AM, Heinz Mauelshagen <heinzm@redhat.com> =
wrote:
> On Tue, 2009-12-08 at 17:38 -0700, Dan Williams wrote:
>> On Thu, Nov 26, 2009 at 6:45 AM, =A0<heinzm@redhat.com> wrote:
>> > From: Heinz Mauelshagen <heinzm@redhat.com>
>> >
>> > Neil et al.,
>> >
>> > finally got around to creating a followup (interim) patch, which a=
llows
>> > for changing the xor algorithn at runtime via the message interfac=
e,
>> > hence allowing to test if the xor unrole optimization around the
>> > supported algorithms is performing better than the assembler
>> > optimized one in the kernel.
>>
>> Now that perf is available it would be good to get some comparative
>> cache utilization statistics on the two approaches.
>
> I'd appreciate it.
> Do you have any time to spend on this comparison ?
>

I can give it a shot.  The easiest way to test would be to export your
versions via a struct xor_block_template.  However, the question I
have is how do your macros differ from the existing ones in
include/asm-generic/xor.h?  Can we achieve the same effect by
extending the ones in include/asm-generic/xor.h to do up to 8 at a
time?

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
