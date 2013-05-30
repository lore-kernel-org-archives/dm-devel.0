From: Lars Marowsky-Bree <lmb@suse.com>
Subject: Clustered RAID1 performance
Date: Thu, 30 May 2013 11:59:55 +0200
Message-ID: <20130530095955.GE11926@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi all,

we see a significant performance hit when mirroring is used for a cLVM2
LV.

That's clearly due to the performance overhead of bouncing to user-space
(and worse, to the network) for locking etc.

I wonder if consideration has been given to how this could be improved?
Using the in-kernel DLM and holding locks for regions the local node
writes to for longer, exclusive locks while noone is reading,
parallelizing the resync ...? How is the long-term perspective for this
given the dm-raid/md raid stuff?

Before we go drafting I wanted to ask for ideas that are already
floating around ;-) Anyone working on this?


Regards,
    Lars

-- =

Architect Storage/HA
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffe=
r, HRB 21284 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
