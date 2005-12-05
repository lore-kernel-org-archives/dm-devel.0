From: Nicolas Kaiser <nikai@nikai.net>
Subject: Re: [KJ] [PATCH] dm: uninitialize static variables
Date: Mon, 5 Dec 2005 19:00:29 +0100
Message-ID: <20051205190029.4b29e759@lucky.kitzblitz>
References: <20051205132800.34631bbf@lucky.kitzblitz>
	<50993.206.49.219.34.1133786860.squirrel@webmail.embedded.cl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50993.206.49.219.34.1133786860.squirrel@webmail.embedded.cl>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Carlos Manuel Duclos Vergara"@redhat.com, carlos@embedded.cl
Cc: kernel-janitors@lists.osdl.org, dm-devel@redhat.com
List-Id: dm-devel.ids

* "Carlos Manuel Duclos Vergara" <carlos@embedded.cl>:
> > uninitialize static variables initialized to 0, to make them go
> > to .bss instead of .data.
> >
> 
> if you want that why not explicitely put them in .bss?
> something like:
> 
> > -static unsigned int major = 0;
> > +static unsigned int major; /* = 0 */
> 
> static unsigned int major = 0 __attribute__ ((section(".bss"));

I personally like the idea of explicitly expressing this intention,
but I didn't manage to achieve this together with initialization.
I tried

 static unsigned int __attribute__((__section__(".bss"))) major = 0;
 static unsigned int __attribute__((__section__(".bss"))) _major = 0;

but they appear not to end up in .bss nevertheless, compared with the
uninitialized version:

--- dm-mod.ko1.txt      2005-12-05 18:40:00.000000000 +0100
+++ dm-mod.ko2.txt      2005-12-05 18:39:52.000000000 +0100
@@ -27,7 +27,7 @@
 [22] .rel.init.data       REL          00000000 00b174 000028  8       29  21  4
 [23] .gnu.linkonce.this_module PROGBITS     00000000 0087c0 000160  0 WA     0   0 32
 [24] .rel.gnu.linkonce.this_module REL          00000000 00b19c 000010  8       29  23  4
-[25] .bss                 NOBITS       00000000 008920 00049c  0 WA     0   0 32
+[25] .bss                 NOBITS       00000000 008920 000498  0 WA     0   0 32
 [26] .comment             PROGBITS     00000000 008920 00022e  0        0   0  1
 [27] .note.GNU-stack      PROGBITS     00000000 008b4e 000000  0        0   0  1
 [28] .shstrtab            STRTAB       00000000 008b4e 00011e  0        0   0  1

If you could tell me how to achieve this in a fancy way which also works,
I'm all ears. Maybe the janitorial steering committee might also like the
idea enough to adjust their current TODO list.
( http://janitor.kernelnewbies.org/TODO - 10th task in 6th section)

Cheers,
n.
