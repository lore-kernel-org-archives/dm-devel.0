From: "Jaco Kroon" <jaco@kroon.co.za>
Subject: Re: [KJ] [PATCH] dm: uninitialize static variables
Date: Mon, 12 Dec 2005 09:17:33 +0200 (SAST)
Message-ID: <24930.192.96.150.57.1134371853.squirrel@mail.interexcel.co.za>
References: <20051205132800.34631bbf@lucky.kitzblitz><50993.206.49.219.34.1133786860.squirrel@webmail.embedded.cl>
	<20051205190029.4b29e759@lucky.kitzblitz>
Reply-To: jaco@kroon.co.za
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-bounces@lists.osdl.org>
In-Reply-To: <20051205190029.4b29e759@lucky.kitzblitz>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
To: Nicolas Kaiser <nikai@nikai.net>
Cc: kernel-janitors@lists.osdl.org, dm-devel@redhat.com, Carlos Manuel Duclos Vergara <"@interexcel.co.za"@interexcel.co.za>
List-Id: dm-devel.ids


In reply to Nicolas Kaiser
> * "Carlos Manuel Duclos Vergara" <carlos@embedded.cl>:
>> > uninitialize static variables initialized to 0, to make them go
>> > to .bss instead of .data.
>> >
>>
>> if you want that why not explicitely put them in .bss?
>> something like:
>>
>> > -static unsigned int major = 0;
>> > +static unsigned int major; /* = 0 */
>>
>> static unsigned int major = 0 __attribute__ ((section(".bss"));
>
> I personally like the idea of explicitly expressing this intention,
> but I didn't manage to achieve this together with initialization.
> I tried

From http://janitor.kernelnewbies.org/TODO:

- uninitialize static variables initialized to 0, to make it go to the .bss,
  instead of .data.
  __initdata inside functions has to be initialized, even if to 0 though.

Therefor I would go with

static unsigned int major; /* = 0 */

Let the compiler make the decision, it will make the correct one.  The
comment is just there to indicate that we haven't forgotten to initialise
it.  As soon as you explicitly initialise you force the compiler to place
it somewhere other than bss.


-- 
There are 10 kinds of people in the world, those who understand binary,
and those who don't.
