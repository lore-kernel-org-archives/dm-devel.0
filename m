From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/21] SUSE multipath-tools resync
Date: Mon, 21 May 2007 11:22:59 +0200
Message-ID: <465164F3.7000408@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christophe,

there have been quite some fixes accumulating here; and as I finally
found some time I thought it a nice idea to have them sent upstream.
There are fixes for various bits and pieces; mostly no big deal.
Most important of these are the following:

- Added an option '-t' to dump the internal hardware table to multipath.
  This is quite helpful when generating your own multipath-tools.conf
  and you'd like to start with some sensible defaults.
- We now got a manpage multipath.conf.5 !
- New priority checker 'hp_sw' which will allow us to group these
  machines by priority, too.

Some patches might be a bit controversial; they make sense to me, but
others might think otherwise:

- I've removed libsysfs and implemented the sysfs handling internally.
  With the current changes in sysfs the older libsysfs doesn't work
  anymore and in either case it was just a big annoyance.
- I've hacked up kpartx to handle extended partitions as well.
  Currently it's quite peculiar with kpartx; we'd be generating
  tables for all partitions _unless_ it's an extended one.
  So we won't be getting any symlinks to the extended partition
  when we're using kpartx, although the device itself is present.

Feel free to omit them if you don't agree.
And of course, feedback etc is welcome.

Christophe, please pull from

git://git.kernel.org/pub/scm/linux/kernel/hare/multipath-tools/.git
#upstream-fixes.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
