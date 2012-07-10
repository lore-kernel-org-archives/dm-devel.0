From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [patch 0/2] [V4] block: Support online resize of disk partitions
Date: Tue, 10 Jul 2012 10:13:19 -0400
Message-ID: <4FFC387F.3070308@ubuntu.com>
References: <20120709213418.799759100@redhat.com> <4FFB5DC3.30803@ubuntu.com> <20120710135759.GE14884@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120710135759.GE14884@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, kzak@redhat.com, maxim.patlasov@gmail.com
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 7/10/2012 9:57 AM, Vivek Goyal wrote:
> +static inline sector_t part_nr_sects_read(struct hd_struct *part) 
> +{ +#if BITS_PER_LONG==32 && defined(CONFIG_LBDAF) &&
> defined(CONFIG_SMP) +	sector_t nr_sects; +	unsigned seq; +	do { +
> seq = read_seqcount_begin(&part->nr_sects_seq); +		nr_sects =
> part->nr_sects; +	} while (read_seqcount_retry(&part->nr_sects_seq,
> seq)); +	return nr_sects; +#elif BITS_PER_LONG==32 &&
> defined(CONFIG_PREEMPT)

Shouldn't this be BITS_PER_LONG==32 && defined(CONFIG_LBDAF) &&
defined(CONFIG_PREEMPT)?  No sense disabling preemption when the
sector size is also 32 bits.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP/Dh/AAoJEJrBOlT6nu75ussIANfCKaObXMJ6JhCNLSeiHUqr
FfBd6p2lJIFd73NSymyigZZ1/rPsy9TpMBlcMwpuFh2erxQ7q3rFnP0O52fEgm2+
20c9+oeUGkzYx62fh0KtfrzBpzhiHOivKR/muAZcfNbb75iKTGrZSZUFrdqAqHci
4zCuu8T37BRo4G9TGdIXD1WT3sltZ7yOk4I7RBhAIDkbt82vVakZ6mlW9hyWmyvD
/sMnXMmkNjwTDdhQj2ho9mn9SFcnDA+aAtJfPXjVAT0W9CKNDYbXw28ud+ARxo5T
rkTjoewdxKffZsBmkkSiNCuLWwpkZng+nTchQjyZbmp/pl4UPlQOfcUb6YxpDX4=
=1tUj
-----END PGP SIGNATURE-----
