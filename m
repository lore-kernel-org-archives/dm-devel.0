From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/2] block: add partition resize function to blkpg ioctl
Date: Mon, 20 Feb 2012 10:17:42 -0500
Message-ID: <4F426416.7030507@ubuntu.com>
References: <1329251991-22468-1-git-send-email-vgoyal@redhat.com> <1329251991-22468-2-git-send-email-vgoyal@redhat.com> <20120220144221.GC10342@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120220144221.GC10342@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: psusi@cfl.rr.com, maxim.patlasov@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, kzak@redhat.com
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/20/2012 9:42 AM, Vivek Goyal wrote:
> On Tue, Feb 14, 2012 at 03:39:50PM -0500, Vivek Goyal wrote:
>> Add a new operation code ( BLKPG_RESIZE_PARTITION ) to the BLKPG
>> ioctl that allows altering the size of an existing partition,
>> even if it is currently in use.
> 
> Hi Phillip,
> 
> Are you ok with the change?

Yes.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPQmQWAAoJEJrBOlT6nu75V8YH/0khEQy1sCiDmjqaVAqJGn3R
xjS7eCU6ndgGj3CHE+j4AJCTJ6cdrcaheEF/QWd3f2GxI0kQ6bBiWzxMeEXaSA57
VQOyKqoGalaWA78a3xFR1oax8ZwOAQi7LdyttdvzXUTKDXrO57cAAIHGQcLTPFiv
a926d27kMulNQzXvjhBj/h8LAOeUVFIEbrGk5QxOw28gdStEv/RtMKeSvuq3e4qu
/TxNT78K49HBaWuhTZJB4Mg7ttyBTQJrQr5c23oo9KLSUgd+3ZvaHF53vUsP7IMm
Kbor7u648P0Xo2gaWGXPF5z4hmyhO08/1SNFKAKw0CSycpOlwjsbel/Ys57gIAY=
=oTDA
-----END PGP SIGNATURE-----
