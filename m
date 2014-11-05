From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-devel] Some thoughts about providing data block checksumming
 for ext4
Date: Wed, 05 Nov 2014 22:37:09 +0100
Message-ID: <545A9885.8070901@gmail.com>
References: <20141103233308.GA27842@thunk.org> <alpine.LRH.2.02.1411041622490.30941@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1411041703590.7145@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1411041915430.32105@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1411041915430.32105@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Theodore Ts'o <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/05/2014 01:27 AM, Mikulas Patocka wrote:

> So you really need cryptographic hashes instead of checksums to avoid the 
> collisions.

I am not sure if it was mentioned but also see how integrity is implemented in
FreeBSD GELI system by playing with sector sizes
 
http://svnweb.freebsd.org/base/head/sys/geom/eli/g_eli_integrity.c?view=co

Also, for encrypted devices (either on file level or block level) I think 
there are still requests for implementing real crypto authenticated modes (like GCM)
which obviously need similar space for auth tag. (I think ZFS uses it this way.) 

Milan

