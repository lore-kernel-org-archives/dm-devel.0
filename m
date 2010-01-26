From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 26 Jan 2010 12:59:15 +0000
Message-ID: <20100126125914.GE5478@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com> <4B5DE54F.7050206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B5DE54F.7050206@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, linux-crypto@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jan 25, 2010 at 07:39:11PM +0100, Milan Broz wrote:
> This should be solved inside cryptoAPI and not blacklist it in dm-crypt,
> see that thread

Agreed.  I'm not going to apply a dm patch that maintains a hard-coded "broken"
list.

Alasdair

