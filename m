From: Edward Thornber <thornber@redhat.com>
Subject: Re: Possible data corruption with dm-thin
Date: Fri, 1 Jul 2016 09:18:56 -0400
Message-ID: <20160701131856.GB32440@roamer.bos.redhat.com>
References: <CAAR726JWQ4VKOVR87QX6Tmuhu1JnCymm7coLT=TFn3BseKm8XA@mail.gmail.com>
	<20160624135510.GA13946@roamer.bos.redhat.com>
	<CAAR726KCTJnbJhU-XhAn0xv3RVEHZY-NFjSNnWqnuVVO6kR4xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAAR726KCTJnbJhU-XhAn0xv3RVEHZY-NFjSNnWqnuVVO6kR4xQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <dennisyang@qnap.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Dennis,

Sorry to take so long about getting back to you.  There was a bug in
the btree library that I mistakenly thought was caused by my fix for
your problem.  Anyway, could you try and recreate your problem with
these two patches applied please (patches are against v4.7-rc5 + my
usual thin-dev extras):

    https://github.com/jthornber/linux-2.6/commit/ebdd99fc12acd0e9178831549896633171d5af1d
    https://github.com/jthornber/linux-2.6/commit/c05989b59d091270c2bf7dd05bdb7a3575223529

Thanks,

- Joe
