From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Error when compiling drivers/md/dm-bufio.c
Date: Mon, 7 Nov 2011 13:46:01 +0000
Message-ID: <20111107134601.GH12886@agk-dp.fab.redhat.com>
References: <20111107082231.GB18221@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111107082231.GB18221@smp.if.uj.edu.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On Mon, Nov 07, 2011 at 09:22:31AM +0100, Witold Baryluk wrote:
> I just got error on todays Linus' tree
>   CC [M]  drivers/md/dm-bufio.o
> drivers/md/dm-bufio.c:988:1: warning: type defaults to =E2=80=98int=E2=
=80=99 in declaration of =E2=80=98EXPORT_SYMBOL_GPL=E2=80=99 [-Wimplici=
t-int]

Probably related to this merge:
  commit 32aaeffbd4a7457bf2f7448b33b5946ff2a960eb
  Merge branch 'modsplit-Oct31_2011' of git://git.kernel.org/pub/scm/li=
nux/ker

Previously module.h was included via another header file.
Now, bufio.c needs an explicit

#include <linux/module.h>

Alasdair

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
