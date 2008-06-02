From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] Allow paths for multipath
Date: Mon, 02 Jun 2008 10:52:05 +0200
Message-ID: <4843B4B5.8070705@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Hi all,

this patchset modifies multipathing to allows zero paths
to a multipath path target.
This is required to make root on multipath working correctly
even when all paths are temporarily down.

Previously multipath would _not_ remove the reference for
the last path from the multipath target. This caused a
reference to a stale/dead device still to be present in
the kernel, which has quite a lot of interesting side effects.
Not the least to multipath itself, which failed to reconnect
the resumed path correctly to the map, causing the same path
to appear twice in the map.

With this patchset we can now shed the last reference, too.
Hence the device can be freed properly from within the kernel
and multipathd is able to setup the correct map once the
paths reappear. And they will even get the same device numbers
again.

Any I/O during that time will be queued if the
'queue_if_no_path' feature is present, otherwise it will
be returned with -EIO. But this is already done correctly
within the dm-mpath module; the only change there is the
lowering of the lowest acceptable path priority group
number, which of course should be '0' now.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
