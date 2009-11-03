From: Laurent CORBES <laurent.corbes@smartjog.com>
Subject: Re: [dm-devel] Re: Ext3 sequential read performance drop 2.6.29 ->
  2.6.30,2.6.31,...
Date: Tue, 3 Nov 2009 11:55:05 +0100
Message-ID: <20091103115505.3d6e096d@smartjog.com>
References: <20091013120955.6bd5844b@smartjog.com>
	<20091102135554.b10ece3e.akpm@linux-foundation.org>
	<20091103100645.GA13118@infradead.org>
	<d6aea4636eac5a7c065f8c1a83c0dbe2.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <d6aea4636eac5a7c065f8c1a83c0dbe2.squirrel@neil.brown.name>
Sender: linux-fsdevel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi all,

> >> > Hi all,
> >> >
> >> > While benchmarking some systems I discover a big sequential read
> >> performance
> >> > drop using ext3 on ~ big files. The drop seems to be introduced =
in
> >> 2.6.30. I'm
> >> > testing with 2.6.28.6 -> 2.6.29.6 -> 2.6.30.4 -> 2.6.31.3.
> >>
> >> Seems that large performance regressions aren't of interest to thi=
s
> >> list :(

Or +200MB/s is enough for a lot of people :)

> > No sure which list you mean, but dm-devel is for dm, not md.  We're=
 also
> > seeing similarly massive performance drops with md and ext3/xfs as
> > already reported on the list.  Someone tracked it down to writeback
> > changes as usual, but there it got stuck.
>=20
> I'm still looking - running some basic tests on 4 filesystems over
> half a dozen recent kernels to see what has been happening.
>=20
> I have a suspicion that there a multiple problems.
> In particular, XFS has a strange degradation which was papered over
> by commit c8a4051c3731b.
> I'm beginning to wonder if it was caused by commit 17bc6c30cf6bf
> but I haven't actually tested that yet.

What is really strange is that from all the tests I did the raw md perf=
s never
dropped. only a few MB of diff between kernel (~2%). This is maybe rela=
ted to
the way upper FS write datas on the md layer.

I'll make the tests on raw disks to see if there is some troubles here =
also. I
can also test with other raid layers. Is there any tuning/debug I
can make for you ? I can also setup a remote access to this system if n=
eeded.

Thanks.
--=20
Laurent Corbes - laurent.corbes@smartjog.com
SmartJog SAS | Phone: +33 1 5868 6225 | Fax: +33 1 5868 6255 | www.smar=
tjog.com
27 Blvd Hippolyte Marqu=E8s, 94200 Ivry-sur-Seine, France
A TDF Group company
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
