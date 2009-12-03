From: heinzm@redhat.com
Subject: [PATCH v4 0/4] dm-replicator: introduce new remote
	replication target
Date: Thu,  3 Dec 2009 18:47:54 +0100
Message-ID: <1259862478-28557-1-git-send-email-heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>


* 4th version of patch series (dated Oct 23 2009) *

Reworked to factor out large block in replicator_message() into
function of its own.
Removed devel comments, adjusted Copyrights and mail addresses.


This is a series of 4 patches introducing the device-mapper remote
data replication target "dm-replicator" to kernel 2.6.

Userspace support for remote data replication will be in
a future LVM2 version.

The target supports disaster recovery by replicating groups of active
mapped devices (ie. receiving io from applications) to one or more
remote sites to paired groups of equally sized passive block devices
(ie. no application access). Synchronous, asynchronous replication
(with fallbehind settings) and temporary downtime of transports
are supported.

It utilizes a replication log to ensure write ordering fidelity for
the whole group of replicated devices, hence allowing for consistent
recovery after failover of arbitrary applications
(eg. DBMS utilizing N > 1 devices).

In case the replication log runs full, it is capable to fall back
to dirty logging utilizing the existing dm-log module, hence keeping
track of regions of devices wich need resynchronization after access
to the transport returned.

Access logic of the replication log and the site links are implemented
as loadable modules, hence allowing for future implementations with
different capabilities in terms of additional plugins.

A "ringbuffer" replication log module implements a circular ring buffer
store for all writes being processed. Other replication log handlers
may follow this one as plugins too.

A "blockdev" site link module implements block devices access to all remote
devices, ie. all devices exposed via the Linux block device layer
(eg. iSCSI, FC).
Again, other eg. network type transport site link handlers may
follow as plugins.

Please review for upstream inclusion.

Heinz
