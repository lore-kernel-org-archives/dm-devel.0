From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 04/25] block: Abstract out bvec iterator
Date: Fri, 17 Jan 2014 09:00:13 +0100
Message-ID: <CAMuHMdUmTqZSAiwYc0Uc=u1YrCZUJeFAuR7PeZqBvWqnqUwmLQ@mail.gmail.com>
References: <20131127004422.GB21305@kmo>
	<1385513128-5035-1-git-send-email-kmo@daterainc.com>
	<1385513128-5035-4-git-send-email-kmo@daterainc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1385513128-5035-4-git-send-email-kmo@daterainc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <kmo@daterainc.com>
Cc: Dave Kleikamp <shaggy@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>, Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>, Jan Beulich <jbeulich@suse.com>, "Ed L. Cashin" <ecashin@coraid.com>, "Michael S. Tsirkin" <mst@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Selvan Mani <smani@micron.com>, Namjae Jeon <namjae.jeon@samsung.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <chris.mason@fusionio.com>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, Ian Campbell <Ian.Campbell@citrix.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Alasdair Kergon <agk@redhat.com>, Sage Weil <sage@inktank.com>, =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>
List-Id: dm-devel.ids

On Wed, Nov 27, 2013 at 1:45 AM, Kent Overstreet <kmo@daterainc.com> wrote:
> Immutable biovecs are going to require an explicit iterator. To
> implement immutable bvecs, a later patch is going to add a bi_bvec_done
> member to this struct; for now, this patch effectively just renames
> things.

You missed xtensa simdisk:

arch/xtensa/platforms/iss/simdisk.c:108:23: error: 'struct bio' has no
member named 'bi_sector'

http://kisskb.ellerman.id.au/kisskb/buildresult/10477507/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
