From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt accepts '+' in the key
Date: Sun, 13 Nov 2016 15:45:27 +0100
Message-ID: <3ee83e71-78e0-7ba3-0fb4-5d906f66aa04@gmail.com>
References: <alpine.LRH.2.02.1611121511510.26536@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1611121511510.26536@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 11/12/2016 09:20 PM, Mikulas Patocka wrote:
> Hi
> 
> dm-crypt uses the function kstrtou8 to decode the encryption key. kstrtou8 
> calls kstrtoull and kstrtoull skips the first character if it is '+'.
> 
> Consequently, it is possible to load keys with '+' in it. For example, 
> this is possible:
> 
> dmsetup create cr --table "0 131072 crypt aes-cbc-essiv:sha256 +0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0 0 /dev/debian/tmptest 0"
> 
> Should this be fixed in dm-crypt or in kstrtou8? A fix in kstrtou8 could 
> be more appropriate, but we don't know how many other kernel parts depend 
> on this "skip plus" behavior...

I would way it should be checked in both places...
For dmcrypt, it should validate input here and should
not accept anything in key field in dm table that is not in hexa representation.

(Is this regression since code switched from simple_strtoul to  kstrtou8
or this bug was there always?)

Milan
