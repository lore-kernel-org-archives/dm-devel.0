From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: dm-crypt userland key patch
Date: Thu, 14 Apr 2005 09:13:51 +0200
Message-ID: <62b0912f05041400135426a80e@mail.gmail.com>
References: <ac71172a05041310417117dd09@mail.gmail.com>
	<20050413235852.45bd2500@emotpin>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050413235852.45bd2500@emotpin>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Bjorn Andersson wrote:
> Patch to the dm-crypt module so that it hides the crypto-key from
> userland. (dmsetup table)

Does it also overwrite the key in memory when unloading dm-crypt, make
sure that the memory is pinned so the key doesn't leak to swap, unload
the key before a 'hibernate', and that sort of stuff?
