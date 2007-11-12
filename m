From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: build #338 failed for 2.6.24-rc2-g6e800af in
	linux/drivers/md/dm-mpath-hp-sw.c
Date: Mon, 12 Nov 2007 15:21:00 +0000
Message-ID: <20071112152100.GA22847@agk.fab.redhat.com>
References: <200711121333.24398.toralf.foerster@gmx.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200711121333.24398.toralf.foerster@gmx.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Nov 12, 2007 at 01:33:21PM +0100, Toralf F=F6rster wrote:
> the build with the attached .config failed, make ends with:
> drivers/built-in.o: In function `hp_sw_end_io':
> dm-mpath-hp-sw.c:(.text+0xb0596): undefined reference to `__scsi_print_=
sense'
> make: *** [.tmp_vmlinux1] Error 1
=20
Does this patch fix it?
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/d=
m-mpath-hp-requires-scsi.patch

Alasdair
