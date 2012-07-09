From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [patch 0/2] [V4] block: Support online resize of disk partitions
Date: Mon, 09 Jul 2012 18:40:03 -0400
Message-ID: <4FFB5DC3.30803@ubuntu.com>
References: <20120709213418.799759100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120709213418.799759100@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, kzak@redhat.com, maxim.patlasov@gmail.com
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/09/2012 05:34 PM, vgoyal@redhat.com wrote:
> Phillip, do let me know if I should put your signed-off-by also in the
> patch.

Sure, kernel side looks good.  My original util-linux patches also added a -u update mode to kpartx, which I think is the more useful interface than the lower level resizepart command, but I suppose I can rebase it to apply on top of this patch.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP+13DAAoJEJrBOlT6nu75cQIIAJvm6ZFxpNNvgkXq0I6blvIj
Q3s5YbzJYecouHPZdy06UXIdfucHKO7WAaMvpmPnDk+JgtltNljVpA50d21NN2lY
k2j2oU9mFHGEKLDnnYobnr6cO2UShaZkrcMtC29S4LaAdgAgPNyD8aTTWS9w0frv
+p2ko+HKvp3neRpOBwfnYXq/rTBLUmOn0k7XsG8QjnNb3aMnMyYp/crV9Kzeb4YX
uCbnIkzN++oDhmnqsLDGt82/VGXZdnA1umISbV9vZw+Q7FfeaiJVMneFxKe5w/FZ
wiCixoCtGhbqtz1hSsUR+rs2ZaDozL0iygSB15Z71aLPim0TLumtRTpfpu+JR3w=
=Vtl+
-----END PGP SIGNATURE-----
