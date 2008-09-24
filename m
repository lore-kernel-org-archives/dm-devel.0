From: Stefan Raspl <raspl@linux.vnet.ibm.com>
Subject: Re: Re: [PATCH] Fix Null pointer Exception
Date: Wed, 24 Sep 2008 15:17:37 +0200
Message-ID: <48DA3DF1.6060403@linux.vnet.ibm.com>
References: <48C5478B.2040401@linux.vnet.ibm.com>
	<20080908172153.05268f6d.akpm@linux-foundation.org>
	<20080923165628.GI5288@agk.fab.redhat.com>
Reply-To: raspl@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080923165628.GI5288@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: raspl@linux.vnet.ibm.com, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, Neil
List-Id: dm-devel.ids

Alasdair G Kergon wrote:

> Have you had chance to look at old kernel versions to see in which
> commit this was introduced?

The next best thing I can come up with is that it has been around in
2.6.9 already. But I believe the DASD driver did the NULL thing to
its internal queue also back then, still.

Ciao,
Stefan


--=20
Linux on System z
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrer: Erich Baier
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
