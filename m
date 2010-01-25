From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] dm-crypt: disable block encryption with arc4
Date: Mon, 25 Jan 2010 19:39:11 +0100
Message-ID: <4B5DE54F.7050206@redhat.com>
References: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, linux-crypto@vger.kernel.org
List-Id: dm-devel.ids

On 01/25/2010 07:29 PM, Mikulas Patocka wrote:
> Hi
> 
> When using arc4 to encrypt a block device, the resulting device is 
> unreliable. It reads garbage. That's because arc4 is a stream cipher, if 
> you write something, it advances its state and if you attempt to decrypt 
> the same sector, it uses new state that is different.
> 
> This patch disables the use of arc4 on block devices.

arc4 again. it is simply not a block cipher:-)

This should be solved inside cryptoAPI and not blacklist it in dm-crypt,
see that thread
http://article.gmane.org/gmane.linux.kernel.cryptoapi/3441

Milan
