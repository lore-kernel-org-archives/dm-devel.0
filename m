From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-crypt accepts '+' in the key
Date: Mon, 14 Nov 2016 16:09:53 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1611141607250.21467@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1611121511510.26536@file01.intranet.prod.int.rdu2.redhat.com> <3ee83e71-78e0-7ba3-0fb4-5d906f66aa04@gmail.com> <20161114003631.GA1304@avx2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161114003631.GA1304@avx2>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>, Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Mon, 14 Nov 2016, Alexey Dobriyan wrote:

> On Sun, Nov 13, 2016 at 03:45:27PM +0100, Milan Broz wrote:
> > On 11/12/2016 09:20 PM, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > dm-crypt uses the function kstrtou8 to decode the encryption key. kstrtou8 
> > > calls kstrtoull and kstrtoull skips the first character if it is '+'.
> > > 
> > > Consequently, it is possible to load keys with '+' in it. For example, 
> > > this is possible:
> > > 
> > > dmsetup create cr --table "0 131072 crypt aes-cbc-essiv:sha256 +0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0 0 /dev/debian/tmptest 0"
> > > 
> > > Should this be fixed in dm-crypt or in kstrtou8? A fix in kstrtou8 could 
> > > be more appropriate, but we don't know how many other kernel parts depend 
> > > on this "skip plus" behavior...
> > 
> > I would way it should be checked in both places...
> > For dmcrypt, it should validate input here and should
> > not accept anything in key field in dm table that is not in hexa representation.
> > 
> > (Is this regression since code switched from simple_strtoul to  kstrtou8
> > or this bug was there always?)
> 
> Well, before kernel would silently parse anything broken as "0".

dm-crypt already validates that there are exactly two characters passed to 
kstrtou8 or simple_strtoul.

> But since it is base-16, "0[xX]" will be accepted before every byte.

Yes, the old dm-crypt code that used simple_strtoul accepted "0x" in a key 
(and parsed it as zero byte). It didn't accept "+" or "-".

> dm-crypt should parse key by hand, frankly.

Mikulas
