From: Steven B <damentz@gmail.com>
Subject: Re: high iowait problem(Bug 12309 on bugzilla.kernel.org)
Date: Thu, 15 Apr 2010 00:58:05 -0500
Message-ID: <o2k8c2bb01004142258zd1a02d38ib2128e324b7d9947@mail.gmail.com>
References: <20100331124834.192500@gmx.com> <20100413135416.b537eee8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100413135416.b537eee8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frank Ren <frankrq2009@gmx.com>, mingo <mingo@elte.hu>, "a.p.zijlstra" <a.p.zijlstra@chello.nl>, "jens.axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, stable@kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

Hi Andrew,

> So something between 2.6.32.3 and 2.6.32.8 inclusive rebroke the
> kernel. =A0That's useful info.
>
> Looking at the changelogs, the only thing I can immediately see in th=
e
> block-core area is
>
> : commit cb723ba5d03bf719dbc7409b4d67572d4472ef8b
> : Author: Dmitry Monakhov <dmonakhov@openvz.org>
> : Date: =A0 Wed Jan 27 22:44:36 2010 +0300
> :
> : =A0 =A0 block: fix bio_add_page for non trivial merge_bvec_fn case
>
> which seems unlikely.
>
> I'm seeing just one device-mapper change whcih went in over that
> timeframe:
>
> : commit e0f5cfa7c18b411634e73923841eccd3a4c0ce7f
> : Author: Martin K. Petersen <martin.petersen@oracle.com>
> : Date: =A0 Mon Jan 11 03:21:50 2010 -0500
> :
> : =A0 =A0 DM: Fix device mapper topology stacking
>
>

Although I can't provide any big details, I went through the commits be=
tween
2.6.32.2 and 2.6.32.8 and as many things that could affect IO and rever=
ted
them from my 2.6.33.2 kernel.

Here's my list of commits I reverted that seemed to improve performance=
 locally
running a 2.6.33.2 kernel.

cb723ba5d03bf719dbc7409b4d67572d4472ef8b (this one you suspected)
block: fix bio_add_page for non trivial merge_bvec_fn case

b2ea8cb9c8f1937cb80b9beb50548a05bfc37819
vmscan: do not evict inactive pages when skipping an active list scan

e4dd8ca5be771aa706b0797b3284328bb595bfa1
fasync: split 'fasync_helper()' into separate add/remove functions

Though, I was hoping you guys could identify which one of these is
the real culprit.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
>
>
