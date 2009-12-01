From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH v3 0/4] dm-replicator: introduce new remote
	replication target
Date: Tue, 1 Dec 2009 17:41:42 +0100
Message-ID: <20091201164142.GL19238@suse.de>
References: <1259683507-12455-1-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1259683507-12455-1-git-send-email-heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2009-12-01T17:05:03, heinzm@redhat.com wrote:

> * 3rd version of patch series (dated Oct 23 2009) *
>=20
> Reworked to allow for Build after each single patch has been applied.

Hi Heinz, have you considered a git tree? Might make it easier to review
changes.

> This is a series of 4 patches introducing the device-mapper remote
> data replication target "dm-replicator" to kernel 2.6.
>=20
> Userspace support for remote data replication will be in
> a future LVM2 version.

Is there any code available for testing this yet?

> The target supports disaster recovery by replicating groups of active
> mapped devices (ie. receiving io from applications) to one or more
> remote sites to paired groups of equally sized passive block devices
> (ie. no application access). Synchronous, asynchronous replication
> (with fallbehind settings) and temporary downtime of transports
> are supported.

How is resync handled - peer-to-peer or relayed via the master?=20

What about device failures / IO errors at the sites?

> It utilizes a replication log to ensure write ordering fidelity for
> the whole group of replicated devices, hence allowing for consistent
> recovery after failover of arbitrary applications
> (eg. DBMS utilizing N > 1 devices).

Write ordering is not guaranteed across different file systems / block
devices today; so no DBMS actually requires this. What is the benefit?

What kind of reordering on a per-device basis is allowed via this
infrastructure at each site? (drbd has logic to detect implicit write
dependencies to allow peers to optimize local IO.)

> A "blockdev" site link module implements block devices access to all re=
mote
> devices, ie. all devices exposed via the Linux block device layer
> (eg. iSCSI, FC).

> Again, other eg. network type transport site link handlers may
> follow as plugins.

How is all of this actually configured and used?

> Please review for upstream inclusion.

Should this not be Cc'ed to LKML if you aim for upstream inclusion? I
actually would expect that most of the criticism of drbd's inclusion
would also apply here, no? (With the added point that dm-replicator does
not actually have any users yet.)


Regards,
    Lars

--=20
Architect Storage/HA, OPS Engineering, Novell, Inc.
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde
